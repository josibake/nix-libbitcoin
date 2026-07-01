#!/usr/bin/env python3
#
# Exercise libbitcoin's Electrum silent payments subscription endpoint.

from __future__ import annotations

import argparse
import asyncio
import json
import math
import ssl
import sys
import time
from dataclasses import asdict, dataclass
from typing import Any


METHOD_VERSION = "server.version"
METHOD_FEATURES = "server.features"
METHOD_SUBSCRIBE = "blockchain.silentpayments.subscribe"


class RpcError(Exception):
    pass


@dataclass
class Sample:
    index: int
    ok: bool
    progress: float
    history: int
    connect_seconds: float | None = None
    response_seconds: float | None = None
    first_notify_seconds: float | None = None
    complete_seconds: float | None = None
    error: str | None = None


def compact_json(value: Any) -> bytes:
    return (json.dumps(value, separators=(",", ":")) + "\n").encode()


def parse_labels(text: str) -> list[int]:
    if not text:
        return []

    return [int(label, 0) for label in text.split(",") if label]


def parse_start(start: str, stop: str | None) -> int | str:
    if stop is not None:
        return f"{int(start, 0)}-{int(stop, 0)}"

    if "-" in start:
        return start

    return int(start, 0)


def percentile(values: list[float], pct: float) -> float | None:
    if not values:
        return None

    ordered = sorted(values)
    index = (len(ordered) - 1) * pct
    lower = math.floor(index)
    upper = math.ceil(index)
    if lower == upper:
        return ordered[int(index)]

    return ordered[lower] * (upper - index) + ordered[upper] * (index - lower)


def describe(values: list[float]) -> dict[str, float | None]:
    return {
        "min": min(values) if values else None,
        "p50": percentile(values, 0.50),
        "p90": percentile(values, 0.90),
        "p95": percentile(values, 0.95),
        "p99": percentile(values, 0.99),
        "max": max(values) if values else None,
    }


async def read_message(reader: asyncio.StreamReader, timeout: float) -> Any:
    line = await asyncio.wait_for(reader.readline(), timeout)
    if not line:
        raise RpcError("connection closed")

    try:
        return json.loads(line)
    except json.JSONDecodeError as exc:
        raise RpcError(f"invalid json response: {exc}") from exc


async def call_rpc(
    reader: asyncio.StreamReader,
    writer: asyncio.StreamWriter,
    request_id: int,
    method: str,
    params: list[Any],
    timeout: float,
    notifications: list[Any] | None = None,
) -> Any:
    writer.write(compact_json(
        {"id": request_id, "method": method, "params": params}))
    await writer.drain()

    while True:
        message = await read_message(reader, timeout)
        if not isinstance(message, dict):
            raise RpcError("invalid json-rpc response")

        if message.get("id") == request_id:
            if message.get("error") is not None:
                raise RpcError(json.dumps(message["error"], separators=(",", ":")))
            return message.get("result")

        if notifications is not None:
            notifications.append(message)


async def connect(
    args: argparse.Namespace
) -> tuple[asyncio.StreamReader, asyncio.StreamWriter]:
    context = ssl.create_default_context() if args.tls else None
    return await asyncio.wait_for(
        asyncio.open_connection(args.host, args.port, ssl=context),
        args.connect_timeout,
    )


async def probe(args: argparse.Namespace) -> dict[str, Any]:
    reader, writer = await connect(args)
    try:
        version = await call_rpc(reader, writer, 1, METHOD_VERSION,
            [args.client_name, args.protocol_version], args.timeout)
        features = await call_rpc(reader, writer, 2, METHOD_FEATURES, [],
            args.timeout)
        if not isinstance(features, dict):
            raise RpcError("server.features did not return an object")

        if not args.skip_feature_check and "silent_payments" not in features:
            raise RpcError("server.features does not advertise silent_payments")

        return {"version": version, "features": features}
    finally:
        writer.close()
        await writer.wait_closed()


async def run_subscription(
    args: argparse.Namespace,
    index: int,
    start_value: int | str,
    labels: list[int],
) -> Sample:
    sample = Sample(index=index, ok=False, progress=0.0, history=0)
    request_id = 1000 + index
    start_time = time.perf_counter()

    try:
        reader, writer = await connect(args)
        sample.connect_seconds = time.perf_counter() - start_time
    except Exception as exc:
        sample.error = f"connect: {exc}"
        return sample

    try:
        await call_rpc(reader, writer, request_id, METHOD_VERSION,
            [args.client_name, args.protocol_version], args.timeout)
        request_id += args.requests + 1

        notifications: list[Any] = []
        sent_at = time.perf_counter()
        await call_rpc(reader, writer, request_id, METHOD_SUBSCRIBE, [
            args.scan_private_key,
            args.spend_public_key,
            start_value,
            labels,
        ], args.timeout, notifications)
        sample.response_seconds = time.perf_counter() - sent_at

        deadline = sent_at + args.timeout
        while time.perf_counter() < deadline:
            if notifications:
                message = notifications.pop(0)
            else:
                remaining = max(0.001, deadline - time.perf_counter())
                message = await read_message(reader, remaining)

            if not isinstance(message, dict):
                raise RpcError("invalid json-rpc notification")

            if message.get("method") != METHOD_SUBSCRIBE:
                continue

            params = message.get("params", [])
            if not isinstance(params, list) or len(params) < 3:
                continue

            if sample.first_notify_seconds is None:
                sample.first_notify_seconds = time.perf_counter() - sent_at

            progress = float(params[1])
            history = params[2]
            sample.progress = max(sample.progress, progress)
            if isinstance(history, list):
                sample.history += len(history)

            if progress >= args.min_progress:
                sample.ok = True
                sample.complete_seconds = time.perf_counter() - sent_at
                return sample

        sample.error = f"timeout waiting for progress >= {args.min_progress}"
        return sample
    except Exception as exc:
        sample.error = str(exc)
        return sample
    finally:
        writer.close()
        await writer.wait_closed()


async def run_load(args: argparse.Namespace) -> dict[str, Any]:
    start_value = parse_start(args.start, args.stop)
    labels = parse_labels(args.labels)
    started = time.perf_counter()
    probe_result = await probe(args)

    if args.probe_only:
        return {
            "probe": probe_result,
            "summary": {
                "requests": 0,
                "ok": 0,
                "errors": 0,
                "incomplete": 0,
                "history": 0,
                "elapsed_seconds": time.perf_counter() - started,
            },
            "latencies": {},
            "samples": [],
        }

    semaphore = asyncio.Semaphore(args.clients)

    async def worker(index: int) -> Sample:
        async with semaphore:
            return await run_subscription(args, index, start_value, labels)

    samples = await asyncio.gather(
        *(worker(index) for index in range(args.requests)))
    ok = sum(1 for sample in samples if sample.ok)
    errors = sum(1 for sample in samples if sample.error is not None)
    incomplete = sum(1 for sample in samples
        if sample.error is None and not sample.ok)
    history = sum(sample.history for sample in samples)

    return {
        "probe": probe_result,
        "summary": {
            "requests": args.requests,
            "ok": ok,
            "errors": errors,
            "incomplete": incomplete,
            "history": history,
            "elapsed_seconds": time.perf_counter() - started,
        },
        "latencies": {
            "connect_seconds": describe([
                sample.connect_seconds for sample in samples
                if sample.connect_seconds is not None
            ]),
            "response_seconds": describe([
                sample.response_seconds for sample in samples
                if sample.response_seconds is not None
            ]),
            "first_notify_seconds": describe([
                sample.first_notify_seconds for sample in samples
                if sample.first_notify_seconds is not None
            ]),
            "complete_seconds": describe([
                sample.complete_seconds for sample in samples
                if sample.complete_seconds is not None
            ]),
        },
        "samples": [asdict(sample) for sample in samples],
    }


def print_table(report: dict[str, Any]) -> None:
    probe_result = report["probe"]
    summary = report["summary"]
    features = probe_result.get("features", {})
    silent_payments = features.get("silent_payments")

    print(f"server: {probe_result.get('version')}")
    print(f"silent_payments: {silent_payments}")
    print(
        "requests: {requests} ok: {ok} errors: {errors} incomplete: "
        "{incomplete} history: {history} elapsed: {elapsed_seconds:.3f}s"
        .format(**summary))

    for name, values in report["latencies"].items():
        print(
            f"{name}: "
            f"min={format_seconds(values['min'])} "
            f"p50={format_seconds(values['p50'])} "
            f"p90={format_seconds(values['p90'])} "
            f"p95={format_seconds(values['p95'])} "
            f"p99={format_seconds(values['p99'])} "
            f"max={format_seconds(values['max'])}"
        )

    failures = [sample for sample in report["samples"] if sample["error"]]
    for sample in failures[:10]:
        print(f"error[{sample['index']}]: {sample['error']}", file=sys.stderr)


def format_seconds(value: float | None) -> str:
    return "n/a" if value is None else f"{value:.3f}s"


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(
        description="Load test libbitcoin Electrum silent payments scans.")
    parser.add_argument("--host", default="127.0.0.1")
    parser.add_argument("--port", type=int, default=50001)
    parser.add_argument("--tls", action="store_true")
    parser.add_argument("--connect-timeout", type=float, default=10.0)
    parser.add_argument("--timeout", type=float, default=600.0)
    parser.add_argument("--client-name", default="libbitcoin-sp-load/0.1")
    parser.add_argument("--protocol-version", default="1.4.2")
    parser.add_argument("--scan-private-key")
    parser.add_argument("--spend-public-key")
    parser.add_argument("--start", default="0")
    parser.add_argument("--stop")
    parser.add_argument("--labels", default="")
    parser.add_argument("--clients", type=int, default=1)
    parser.add_argument("--requests", type=int, default=1)
    parser.add_argument("--min-progress", type=float, default=1.0)
    parser.add_argument("--skip-feature-check", action="store_true")
    parser.add_argument("--probe-only", action="store_true")
    parser.add_argument("--json", action="store_true")
    parser.add_argument("--json-out")
    return parser.parse_args()


def main() -> int:
    args = parse_args()
    if args.clients < 1 or args.requests < 1:
        print("--clients and --requests must be positive", file=sys.stderr)
        return 2
    if not args.probe_only and (
        not args.scan_private_key or not args.spend_public_key):
        print(
            "--scan-private-key and --spend-public-key are required",
            file=sys.stderr)
        return 2

    try:
        report = asyncio.run(run_load(args))
    except Exception as exc:
        print(f"benchmark failed: {exc}", file=sys.stderr)
        return 1

    if args.json_out:
        with open(args.json_out, "w", encoding="utf-8") as output:
            json.dump(report, output, indent=2, sort_keys=True)
            output.write("\n")

    if args.json:
        print(json.dumps(report, indent=2, sort_keys=True))
    else:
        print_table(report)

    summary = report["summary"]
    if summary["errors"] or summary["incomplete"]:
        return 1
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
