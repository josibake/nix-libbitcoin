# Generated from libbitcoin-server src/parser.cpp at commit 1df3db4a653ca56a8785093bc7facee4996796b0.
# Keep this file in sync when updating the libbitcoin-server source pin.
{lib}: let
  inherit (lib) mkOption types;
  mkNullable = type: description:
    mkOption {
      inherit type description;
      default = null;
    };
in {
  forks = mkOption {
    type = types.submodule {
      options = {
        difficult = mkNullable (types.nullOr types.bool) "Require difficult blocks, defaults to 'true' (use false for testnet).";
        retarget = mkNullable (types.nullOr types.bool) "Retarget difficulty, defaults to 'true'.";
        bip16 = mkNullable (types.nullOr types.bool) "Add pay-to-script-hash processing, defaults to 'true' (soft fork).";
        bip30 = mkNullable (types.nullOr types.bool) "Disallow collision of unspent transaction hashes, defaults to 'true' (soft fork).";
        bip34 = mkNullable (types.nullOr types.bool) "Require coinbase input includes block height, defaults to 'true' (soft fork).";
        bip42 = mkNullable (types.nullOr types.bool) "Finite monetary supply, defaults to 'true' (soft fork).";
        bip66 = mkNullable (types.nullOr types.bool) "Require strict signature encoding, defaults to 'true' (soft fork).";
        bip65 = mkNullable (types.nullOr types.bool) "Add check-locktime-verify op code, defaults to 'true' (soft fork).";
        bip90 = mkNullable (types.nullOr types.bool) "Assume bip34, bip65, and bip66 activation if enabled, defaults to 'true' (hard fork).";
        bip68 = mkNullable (types.nullOr types.bool) "Add relative locktime enforcement, defaults to 'true' (soft fork).";
        bip112 = mkNullable (types.nullOr types.bool) "Add check-sequence-verify op code, defaults to 'true' (soft fork).";
        bip113 = mkNullable (types.nullOr types.bool) "Use median time past for locktime, defaults to 'true' (soft fork).";
        bip141 = mkNullable (types.nullOr types.bool) "Segregated witness consensus layer, defaults to 'true' (soft fork).";
        bip143 = mkNullable (types.nullOr types.bool) "Witness version 0 (segwit), defaults to 'true' (soft fork).";
        bip147 = mkNullable (types.nullOr types.bool) "Prevent dummy value malleability, defaults to 'true' (soft fork).";
        bip341 = mkNullable (types.nullOr types.bool) "Witness version 1 (taproot), defaults to 'true' (soft fork).";
        bip342 = mkNullable (types.nullOr types.bool) "Validation of taproot script, defaults to 'true' (soft fork).";
        time_warp_patch = mkNullable (types.nullOr types.bool) "Fix time warp bug, defaults to 'false' (hard fork).";
        retarget_overflow_patch = mkNullable (types.nullOr types.bool) "Fix target overflow for very low difficulty, defaults to 'false' (hard fork).";
        scrypt_proof_of_work = mkNullable (types.nullOr types.bool) "Use scrypt hashing for proof of work, defaults to 'false' (hard fork).";
      };
    };
    default = {};
    description = "libbitcoin-server [forks] configuration settings.";
  };
  bitcoin = mkOption {
    type = types.submodule {
      options = {
        initial_block_subsidy_bitcoin = mkNullable (types.nullOr types.ints.unsigned) "The initial block subsidy, defaults to '50'.";
        subsidy_interval = mkNullable (types.nullOr types.ints.unsigned) "The subsidy halving period, defaults to '210000'.";
        timestamp_limit_seconds = mkNullable (types.nullOr types.ints.unsigned) "The future timestamp allowance, defaults to '7200'.";
        retargeting_factor = mkNullable (types.nullOr types.ints.unsigned) "The difficulty retargeting factor, defaults to '4'.";
        retargeting_interval_seconds = mkNullable (types.nullOr types.ints.unsigned) "The difficulty retargeting period, defaults to '1209600'.";
        block_spacing_seconds = mkNullable (types.nullOr types.ints.unsigned) "The target block period, defaults to '600'.";
        proof_of_work_limit = mkNullable (types.nullOr types.ints.unsigned) "The proof of work limit, defaults to '486604799'.";
        genesis_block = mkNullable (types.nullOr types.str) "The hexideciaml encoding of the genesis block, defaults to mainnet.";
        checkpoint = mkNullable (types.nullOr (types.listOf types.str)) "The blockchain checkpoints, defaults to the consensus set.";
        bip16_activation_time = mkNullable (types.nullOr types.ints.unsigned) "The activation time for bip16 in unix time, defaults to '1333238400'.";
        bip34_activation_threshold = mkNullable (types.nullOr types.ints.unsigned) "The number of new version blocks required for bip34 style soft fork activation, defaults to '750'.";
        bip34_enforcement_threshold = mkNullable (types.nullOr types.ints.unsigned) "The number of new version blocks required for bip34 style soft fork enforcement, defaults to '950'.";
        bip34_activation_sample = mkNullable (types.nullOr types.ints.unsigned) "The number of blocks considered for bip34 style soft fork activation, defaults to '1000'.";
        bip34_freeze = mkNullable (types.nullOr types.ints.unsigned) "The block height to freeze the bip34 softfork for bip90, defaults to '227931'.";
        bip65_freeze = mkNullable (types.nullOr types.ints.unsigned) "The block height to freeze the bip65 softfork for bip90, defaults to '388381'.";
        bip66_freeze = mkNullable (types.nullOr types.ints.unsigned) "The block height to freeze the bip66 softfork for bip90, defaults to '363725'.";
        bip30_reactivate_height = mkNullable (types.nullOr types.ints.unsigned) "The height for bip30 reactivation, defaults to '1983702'.";
        bip30_deactivate_checkpoint = mkNullable (types.nullOr types.str) "The hash:height checkpoint for bip30 deactivation, defaults to '000000000000024b89b42a942fe0d9fea3bb44ab7bd1b19115dd6a759c0808b8:227931'.";
        bip9_bit0_active_checkpoint = mkNullable (types.nullOr types.str) "The hash:height checkpoint for bip9 bit0 activation, defaults to '000000000000000004a1b34462cb8aeebd5799177f7a29cf28f2d1961716b5b5:419328'.";
        bip9_bit1_active_checkpoint = mkNullable (types.nullOr types.str) "The hash:height checkpoint for bip9 bit1 activation, defaults to '0000000000000000001c8018d9cb3b742ef25114f27563e3fc4a1902167f9893:481824'.";
        bip9_bit2_active_checkpoint = mkNullable (types.nullOr types.str) "The hash:height checkpoint for bip9 bit2 activation, defaults to '0000000000000000000687bca986194dc2c1f949318629b44bb54ec0a94d8244:709632'.";
        milestone = mkNullable (types.nullOr types.str) "A block presumed to be valid but not required to be present, defaults to '000000000000000000010538edbfd2d5b809a33dd83f284aeea41c6d0d96968a:900000'.";
        minimum_work = mkNullable (types.nullOr types.str) "The minimum work for any branch to be considered valid, defaults to '000000000000000000000000000000000000000052b2559353df4117b7348b64'.";
      };
    };
    default = {};
    description = "libbitcoin-server [bitcoin] configuration settings.";
  };
  network = mkOption {
    type = types.submodule {
      options = {
        threads = mkNullable (types.nullOr types.ints.unsigned) "The minimum number of threads in the network threadpool, defaults to '16'.";
        retry_timeout_seconds = mkNullable (types.nullOr types.ints.unsigned) "The time delay for failed connection retry, defaults to '1'.";
        connect_timeout_seconds = mkNullable (types.nullOr types.ints.unsigned) "The time limit for connection establishment, defaults to '5'.";
        rate_limit = mkNullable (types.nullOr types.ints.unsigned) "The peer download rate limit (not implemented).";
        blacklist = mkNullable (types.nullOr (types.listOf types.str)) "IP address to disallow, allows all others, multiple allowed.";
        whitelist = mkNullable (types.nullOr (types.listOf types.str)) "IP address to allow, prohibits all others, multiple allowed.";
      };
    };
    default = {};
    description = "libbitcoin-server [network] configuration settings.";
  };
  peer = mkOption {
    type = types.submodule {
      options = {
        address_upper = mkNullable (types.nullOr types.ints.unsigned) "The upper bound for address selection divisor, defaults to '10'.";
        address_lower = mkNullable (types.nullOr types.ints.unsigned) "The lower bound for address selection divisor, defaults to '5'.";
        protocol_maximum = mkNullable (types.nullOr types.ints.unsigned) "The maximum network protocol version, defaults to '70012'.";
        protocol_minimum = mkNullable (types.nullOr types.ints.unsigned) "The minimum network protocol version, defaults to '31800'.";
        services_maximum = mkNullable (types.nullOr types.ints.unsigned) "The maximum services exposed by network connections, defaults to '9' (full node, witness).";
        services_minimum = mkNullable (types.nullOr types.ints.unsigned) "The minimum services exposed by network connections, defaults to '9' (full node, witness).";
        invalid_services = mkNullable (types.nullOr types.ints.unsigned) "The advertised services that cause a peer to be dropped, defaults to '176'.";
        enable_address = mkNullable (types.nullOr types.bool) "Enable address messages, defaults to 'true'.";
        enable_address_v2 = mkNullable (types.nullOr types.bool) "Enable address v2 messages, defaults to 'false'.";
        enable_witness_tx = mkNullable (types.nullOr types.bool) "Enable witness transaction identifier relay, defaults to 'false'.";
        enable_compact = mkNullable (types.nullOr types.bool) "Enable compact block messages, defaults to 'false'.";
        enable_alert = mkNullable (types.nullOr types.bool) "Enable alert messages, defaults to 'false'.";
        enable_reject = mkNullable (types.nullOr types.bool) "Enable reject messages, defaults to 'false'.";
        enable_relay = mkNullable (types.nullOr types.bool) "Enable transaction relay, defaults to 'true'.";
        validate_checksum = mkNullable (types.nullOr types.bool) "Validate the checksum of network messages, defaults to 'false'.";
        identifier = mkNullable (types.nullOr types.ints.unsigned) "The magic number for message headers, defaults to '3652501241'.";
        handshake_timeout_seconds = mkNullable (types.nullOr types.ints.unsigned) "The time limit to complete the connection handshake, defaults to '15'.";
        channel_heartbeat_minutes = mkNullable (types.nullOr types.ints.unsigned) "The time between ping messages, defaults to '5'.";
        maximum_skew_minutes = mkNullable (types.nullOr types.ints.unsigned) "The maximum allowable channel clock skew, defaults to '120'.";
        user_agent = mkNullable (types.nullOr types.str) "The node user agent string, defaults to '";
        path = mkNullable (types.nullOr (types.either types.path types.str)) "The peer address cache file directory, defaults to empty.";
      };
    };
    default = {};
    description = "libbitcoin-server [peer] configuration settings.";
  };
  outbound = mkOption {
    type = types.submodule {
      options = {
        connections = mkNullable (types.nullOr types.ints.unsigned) "The target number of outgoing network connections, defaults to '100'.";
        inactivity_minutes = mkNullable (types.nullOr types.ints.unsigned) "The inactivity time limit for any connection, defaults to '10'.";
        expiration_minutes = mkNullable (types.nullOr types.ints.unsigned) "The age limit for any connection, defaults to '60'.";
        minimum_buffer = mkNullable (types.nullOr types.ints.unsigned) "The minimum retained read buffer size, defaults to '4000000'.";
        maximum_request = mkNullable (types.nullOr types.ints.unsigned) "The maximum allowed request size, defaults to '4000000'.";
        use_ipv6 = mkNullable (types.nullOr types.bool) "Use internet protocol version 6 (IPv6) addresses, defaults to 'false'.";
        seed = mkNullable (types.nullOr (types.listOf types.str)) "A seed node for initializing the host pool, multiple allowed.";
        connect_batch_size = mkNullable (types.nullOr types.ints.unsigned) "The number of concurrent attempts to establish one connection, defaults to '5'.";
        host_pool_capacity = mkNullable (types.nullOr types.ints.unsigned) "The maximum number of peer hosts in the pool, defaults to '10000'.";
        seeding_timeout_seconds = mkNullable (types.nullOr types.ints.unsigned) "The time limit for obtaining seed connections and addresses, defaults to '30'.";
        username = mkNullable (types.nullOr types.str) "The socks5 proxy username (optional).";
        password = mkNullable (types.nullOr types.str) "The socks5 proxy password (optional).";
        socks = mkNullable (types.nullOr types.str) "The socks5 proxy endpoint (port required).";
      };
    };
    default = {};
    description = "libbitcoin-server [outbound] configuration settings.";
  };
  inbound = mkOption {
    type = types.submodule {
      options = {
        bind = mkNullable (types.nullOr (types.listOf types.str)) "IP address to bind for listening, multiple allowed, defaults to '0.0.0.0:8333' (all IPv4).";
        connections = mkNullable (types.nullOr types.ints.unsigned) "The target number of incoming network connections, defaults to '100'.";
        inactivity_minutes = mkNullable (types.nullOr types.ints.unsigned) "The inactivity time limit for any connection, defaults to '10'.";
        expiration_minutes = mkNullable (types.nullOr types.ints.unsigned) "The age limit for any connection, defaults to '60'.";
        minimum_buffer = mkNullable (types.nullOr types.ints.unsigned) "The minimum retained read buffer size, defaults to '4000000'.";
        maximum_request = mkNullable (types.nullOr types.ints.unsigned) "The maximum allowed request size, defaults to '4000000'.";
        enable_loopback = mkNullable (types.nullOr types.bool) "Allow connections from the node to itself, defaults to 'false'.";
        self = mkNullable (types.nullOr (types.listOf types.str)) "IP address to advertise, multiple allowed.";
      };
    };
    default = {};
    description = "libbitcoin-server [inbound] configuration settings.";
  };
  manual = mkOption {
    type = types.submodule {
      options = {
        inactivity_minutes = mkNullable (types.nullOr types.ints.unsigned) "The inactivity time limit for any connection, defaults to '10' (will attempt reconnect).";
        expiration_minutes = mkNullable (types.nullOr types.ints.unsigned) "The age limit for any connection, defaults to '60' (will attempt reconnect).";
        minimum_buffer = mkNullable (types.nullOr types.ints.unsigned) "The minimum retained read buffer size, defaults to '4000000'.";
        maximum_request = mkNullable (types.nullOr types.ints.unsigned) "The maximum allowed request size, defaults to '4000000'.";
        peer = mkNullable (types.nullOr (types.listOf types.str)) "A persistent peer node, multiple allowed.";
        username = mkNullable (types.nullOr types.str) "The socks5 proxy username (optional).";
        password = mkNullable (types.nullOr types.str) "The socks5 proxy password (optional).";
        socks = mkNullable (types.nullOr types.str) "The socks5 proxy endpoint (port required).";
      };
    };
    default = {};
    description = "libbitcoin-server [manual] configuration settings.";
  };
  admin = mkOption {
    type = types.submodule {
      options = {
        bind = mkNullable (types.nullOr (types.listOf types.str)) "IP address to bind, multiple allowed, defaults to empty (disabled).";
        safe = mkNullable (types.nullOr (types.listOf types.str)) "IP address to secure bind, multiple allowed, defaults to empty (disabled).";
        cert_auth = mkNullable (types.nullOr (types.either types.path types.str)) "The certificate authority directory (*.PEM), enables client authentication.";
        cert_path = mkNullable (types.nullOr (types.either types.path types.str)) "The path to the server certificate file (.PEM), defaults to unused.";
        key_path = mkNullable (types.nullOr (types.either types.path types.str)) "The path to the server private key file (.PEM), defaults to unused.";
        key_pass = mkNullable (types.nullOr types.str) "The password to decrypt the server private key file (.PEM), optional.";
        connections = mkNullable (types.nullOr types.ints.unsigned) "The required maximum number of connections, defaults to '0'.";
        inactivity_minutes = mkNullable (types.nullOr types.ints.unsigned) "The idle timeout (http keep-alive), defaults to '10'.";
        expiration_minutes = mkNullable (types.nullOr types.ints.unsigned) "The idle timeout (http keep-alive), defaults to '60'.";
        minimum_buffer = mkNullable (types.nullOr types.ints.unsigned) "The minimum retained read buffer size, defaults to '4000000'.";
        maximum_request = mkNullable (types.nullOr types.ints.unsigned) "The maximum allowed request size, defaults to '4000000'.";
        server = mkNullable (types.nullOr types.str) "The server name (http header), defaults to '";
        host = mkNullable (types.nullOr (types.listOf types.str)) "The host name (http verification), multiple allowed, defaults to empty (disabled).";
        origin = mkNullable (types.nullOr (types.listOf types.str)) "The allowed origin (see CORS), multiple allowed, defaults to empty (disabled).";
        allow_opaque_origin = mkNullable (types.nullOr types.bool) "Allow requests from opaque origin (see CORS), multiple allowed, defaults to false.";
        path = mkNullable (types.nullOr (types.either types.path types.str)) "The required root path of source files to be served, defaults to empty.";
        default = mkNullable (types.nullOr types.str) "The path of the default source page, defaults to 'index.html'.";
      };
    };
    default = {};
    description = "libbitcoin-server [admin] configuration settings.";
  };
  native = mkOption {
    type = types.submodule {
      options = {
        bind = mkNullable (types.nullOr (types.listOf types.str)) "IP address to bind, multiple allowed, defaults to empty (disabled).";
        safe = mkNullable (types.nullOr (types.listOf types.str)) "IP address to secure bind, multiple allowed, defaults to empty (disabled).";
        cert_auth = mkNullable (types.nullOr (types.either types.path types.str)) "The certificate authority directory (*.PEM), enables client authentication.";
        cert_path = mkNullable (types.nullOr (types.either types.path types.str)) "The path to the server certificate file (.PEM), defaults to unused.";
        key_path = mkNullable (types.nullOr (types.either types.path types.str)) "The path to the server private key file (.PEM), defaults to unused.";
        key_pass = mkNullable (types.nullOr types.str) "The password to decrypt the server private key file (.PEM), optional.";
        connections = mkNullable (types.nullOr types.ints.unsigned) "The required maximum number of connections, defaults to '0'.";
        inactivity_minutes = mkNullable (types.nullOr types.ints.unsigned) "The idle timeout (http keep-server), defaults to '60'.";
        expiration_minutes = mkNullable (types.nullOr types.ints.unsigned) "The idle timeout (http keep-alive), defaults to '60'.";
        minimum_buffer = mkNullable (types.nullOr types.ints.unsigned) "The minimum retained read buffer size, defaults to '4000000'.";
        maximum_request = mkNullable (types.nullOr types.ints.unsigned) "The maximum allowed request size, defaults to '4000000'.";
        server = mkNullable (types.nullOr types.str) "The server name (http header), defaults to '";
        host = mkNullable (types.nullOr (types.listOf types.str)) "The host name (http verification), multiple allowed, defaults to empty (disabled).";
        origin = mkNullable (types.nullOr (types.listOf types.str)) "The allowed origin (see CORS), multiple allowed, defaults to empty (disabled).";
        allow_opaque_origin = mkNullable (types.nullOr types.bool) "Allow requests from opaque origin (see CORS), multiple allowed, defaults to false.";
        path = mkNullable (types.nullOr (types.either types.path types.str)) "The required root path of source files to be served, defaults to empty.";
        default = mkNullable (types.nullOr types.str) "The path of the default source page, defaults to 'index.html'.";
        websocket = mkNullable (types.nullOr types.bool) "Enable websocket interface, defaults to true.";
      };
    };
    default = {};
    description = "libbitcoin-server [native] configuration settings.";
  };
  bitcoind = mkOption {
    type = types.submodule {
      options = {
        bind = mkNullable (types.nullOr (types.listOf types.str)) "IP address to bind, multiple allowed, defaults to empty (disabled).";
        safe = mkNullable (types.nullOr (types.listOf types.str)) "IP address to secure bind, multiple allowed, defaults to empty (disabled).";
        cert_auth = mkNullable (types.nullOr (types.either types.path types.str)) "The certificate authority directory (*.PEM), enables client authentication.";
        cert_path = mkNullable (types.nullOr (types.either types.path types.str)) "The path to the server certificate file (.PEM), defaults to unused.";
        key_path = mkNullable (types.nullOr (types.either types.path types.str)) "The path to the server private key file (.PEM), defaults to unused.";
        key_pass = mkNullable (types.nullOr types.str) "The password to decrypt the server private key file (.PEM), optional.";
        username = mkNullable (types.nullOr types.str) "The http basic authorization username (not secure).";
        password = mkNullable (types.nullOr types.str) "The http basic authorization password (not secure).";
        connections = mkNullable (types.nullOr types.ints.unsigned) "The required maximum number of connections, defaults to '0'.";
        inactivity_minutes = mkNullable (types.nullOr types.ints.unsigned) "The idle timeout (http keep-alive), defaults to '10'.";
        expiration_minutes = mkNullable (types.nullOr types.ints.unsigned) "The idle timeout (http keep-alive), defaults to '60'.";
        minimum_buffer = mkNullable (types.nullOr types.ints.unsigned) "The minimum retained read buffer size, defaults to '4000000'.";
        maximum_request = mkNullable (types.nullOr types.ints.unsigned) "The maximum allowed request size, defaults to '4000000'.";
        server = mkNullable (types.nullOr types.str) "The server name (http header), defaults to '";
        host = mkNullable (types.nullOr (types.listOf types.str)) "The host name (http verification), multiple allowed, defaults to empty (disabled).";
        origin = mkNullable (types.nullOr (types.listOf types.str)) "The allowed origin (see CORS), multiple allowed, defaults to empty (disabled).";
        allow_opaque_origin = mkNullable (types.nullOr types.bool) "Allow requests from opaque origin (see CORS), multiple allowed, defaults to false.";
      };
    };
    default = {};
    description = "libbitcoin-server [bitcoind] configuration settings.";
  };
  electrum = mkOption {
    type = types.submodule {
      options = {
        bind = mkNullable (types.nullOr (types.listOf types.str)) "IP address to bind, multiple allowed, defaults to empty (disabled).";
        safe = mkNullable (types.nullOr (types.listOf types.str)) "IP address to secure bind, multiple allowed, defaults to empty (disabled).";
        cert_path = mkNullable (types.nullOr (types.either types.path types.str)) "The path to the server certificate file (.PEM), defaults to unused.";
        key_path = mkNullable (types.nullOr (types.either types.path types.str)) "The path to the server private key file (.PEM), defaults to unused.";
        connections = mkNullable (types.nullOr types.ints.unsigned) "The required maximum number of connections, defaults to '0'.";
        inactivity_minutes = mkNullable (types.nullOr types.ints.unsigned) "The idle timeout (http keep-alive), defaults to '10'.";
        expiration_minutes = mkNullable (types.nullOr types.ints.unsigned) "The idle timeout (http keep-alive), defaults to '60'.";
        minimum_buffer = mkNullable (types.nullOr types.ints.unsigned) "The minimum retained read buffer size, defaults to '4000000'.";
        maximum_request = mkNullable (types.nullOr types.ints.unsigned) "The maximum allowed request size, defaults to '4000000'.";
        maximum_headers = mkNullable (types.nullOr types.ints.unsigned) "The maximum allowed headers returned per request, defaults to '20160'.";
        maximum_history = mkNullable (types.nullOr types.ints.unsigned) "The maximum number of address history entries upon one subscription, defaults to '1000000'.";
        maximum_subscriptions = mkNullable (types.nullOr types.ints.unsigned) "The maximum allowed address subscriptions per channel, defaults to '1000000'.";
        silent_payment_threads = mkNullable (types.nullOr types.ints.unsigned) "The maximum concurrent silent payment scan workers, defaults to '0' (cores minus two).";
        protocol_minimum = mkNullable (types.nullOr types.str) "Minimum protocol version, defaults to '1.0'.";
        protocol_maximum = mkNullable (types.nullOr types.str) "Maximum protocol version, defaults to '1.7'.";
        server_name = mkNullable (types.nullOr types.str) "String returned by server.version, defaults to '";
        donation_address = mkNullable (types.nullOr types.str) "String returned by server.donation_address, defaults to empty.";
        banner_message = mkNullable (types.nullOr types.str) "String returned by server.banner, defaults to empty.";
        self_bind = mkNullable (types.nullOr (types.listOf types.str)) "Advertised host:port at which this server can be reached (defaults to empty).";
        self_safe = mkNullable (types.nullOr (types.listOf types.str)) "Advertised secure host:port at which this server can be reached (defaults to empty).";
        more_bind = mkNullable (types.nullOr (types.listOf types.str)) "Advertised host:port at which another server can be reached (defaults to empty).";
        more_safe = mkNullable (types.nullOr (types.listOf types.str)) "Advertised secure host:port at which another server can be reached (defaults to empty).";
      };
    };
    default = {};
    description = "libbitcoin-server [electrum] configuration settings.";
  };
  stratum_v1 = mkOption {
    type = types.submodule {
      options = {
        bind = mkNullable (types.nullOr (types.listOf types.str)) "IP address to bind, multiple allowed, defaults to empty (disabled).";
        safe = mkNullable (types.nullOr (types.listOf types.str)) "IP address to secure bind, multiple allowed, defaults to empty (disabled).";
        cert_path = mkNullable (types.nullOr (types.either types.path types.str)) "The path to the server certificate file (.PEM), defaults to unused.";
        key_path = mkNullable (types.nullOr (types.either types.path types.str)) "The path to the server private key file (.PEM), defaults to unused.";
        connections = mkNullable (types.nullOr types.ints.unsigned) "The required maximum number of connections, defaults to '0'.";
        inactivity_minutes = mkNullable (types.nullOr types.ints.unsigned) "The idle timeout (http keep-alive), defaults to '10'.";
        expiration_minutes = mkNullable (types.nullOr types.ints.unsigned) "The idle timeout (http keep-alive), defaults to '60'.";
        minimum_buffer = mkNullable (types.nullOr types.ints.unsigned) "The minimum retained read buffer size, defaults to '4000000'.";
        maximum_request = mkNullable (types.nullOr types.ints.unsigned) "The maximum allowed request size, defaults to '4000000'.";
      };
    };
    default = {};
    description = "libbitcoin-server [stratum_v1] configuration settings.";
  };
  stratum_v2 = mkOption {
    type = types.submodule {
      options = {
        bind = mkNullable (types.nullOr (types.listOf types.str)) "IP address to bind, multiple allowed, defaults to empty (disabled).";
        connections = mkNullable (types.nullOr types.ints.unsigned) "The required maximum number of connections, defaults to '0'.";
        inactivity_minutes = mkNullable (types.nullOr types.ints.unsigned) "The idle timeout (http keep-alive), defaults to '10'.";
        expiration_minutes = mkNullable (types.nullOr types.ints.unsigned) "The idle timeout (http keep-alive), defaults to '60'.";
        minimum_buffer = mkNullable (types.nullOr types.ints.unsigned) "The minimum retained read buffer size, defaults to '4000000'.";
        maximum_request = mkNullable (types.nullOr types.ints.unsigned) "The maximum allowed request size, defaults to '4000000'.";
      };
    };
    default = {};
    description = "libbitcoin-server [stratum_v2] configuration settings.";
  };
  node = mkOption {
    type = types.submodule {
      options = {
        threads = mkNullable (types.nullOr types.ints.unsigned) "The number of threads in the validation threadpool, defaults to '32'.";
        thread_priority = mkNullable (types.nullOr types.bool) "Set validation threads to high processing priority, defaults to 'true'.";
        memory_priority = mkNullable (types.nullOr types.bool) "Set the process to high memory priority, defaults to 'true'.";
        allow_overlapped = mkNullable (types.nullOr types.bool) "Allow overlapped block requests, defaults to 'true'.";
        allow_batch_race = mkNullable (types.nullOr types.bool) "Allow downloads to continue when all window signatures are batched, defaults to 'true'.";
        delay_inbound = mkNullable (types.nullOr types.bool) "Delay accepting inbound connections until node is current, defaults to 'true'.";
        defer_validation = mkNullable (types.nullOr types.bool) "Defer validation, defaults to 'false'.";
        defer_confirmation = mkNullable (types.nullOr types.bool) "Defer confirmation, defaults to 'false'.";
        batch_signatures = mkNullable (types.nullOr types.ints.unsigned) "Count of signatures to verify in a batch, defaults to '100000' (0 disables).";
        fee_estimate_horizon = mkNullable (types.nullOr types.ints.unsigned) "Fee estimation horizon, limited to 1008, defaults to '0' (0 disables).";
        minimum_fee_rate = mkNullable (types.nullOr types.float) "Minimum fee rate for non-conflicting tx acceptance, defaults to '0.0'.";
        minimum_bump_rate = mkNullable (types.nullOr types.float) "Minimum fee rate increment for conflicting tx acceptance, defaults to '0.0'.";
        allowed_deviation = mkNullable (types.nullOr types.float) "Allowable underperformance standard deviation, defaults to '1.5' (0 disables).";
        announcement_cache = mkNullable (types.nullOr types.ints.unsigned) "Limit of per channel cached peer block and tx announcements, to avoid replaying, defaults to '42'.";
        maximum_height = mkNullable (types.nullOr types.ints.unsigned) "Maximum block height to populate, defaults to 0 (unlimited).";
        maximum_concurrency = mkNullable (types.nullOr types.ints.unsigned) "Maximum number of blocks to download concurrently, defaults to '50000' (0 disables).";
        sample_period_seconds = mkNullable (types.nullOr types.ints.unsigned) "Sampling period for drop of stalled channels, defaults to '10' (0 disables).";
        currency_window_minutes = mkNullable (types.nullOr types.ints.unsigned) "Time from present that blocks are considered current, defaults to '1440' (0 disables).";
        warn_dirty_background_ratio = mkNullable (types.nullOr types.ints.unsigned) "Warn on linux if 'vm.dirty_background_ratio' is below value, defaults to 90 (0 disables).";
        warn_dirty_ratio = mkNullable (types.nullOr types.ints.unsigned) "Warn on linux if 'vm.dirty_ratio' is below value, defaults to 90 (0 disables).";
      };
    };
    default = {};
    description = "libbitcoin-server [node] configuration settings.";
  };
  database = mkOption {
    type = types.submodule {
      options = {
        path = mkNullable (types.nullOr (types.either types.path types.str)) "The blockchain database directory, defaults to 'blockchain'.";
        turbo = mkNullable (types.nullOr types.bool) "Allow indiviudal non-validation queries to use all CPUs, defaults to false.";
        mark_unconfirmable = mkNullable (types.nullOr types.bool) "Save unconfirmable block state (prevents revalidation), defaults to 'true'.";
        interval_depth = mkNullable (types.nullOr types.ints.unsigned) "The interval depth for merkle proof optimization, defaults to '11'.";
        header_buckets = mkNullable (types.nullOr types.ints.unsigned) "The number of buckets in the header table head, defaults to '386364'.";
        header_size = mkNullable (types.nullOr types.ints.unsigned) "The minimum allocation of the header table body, defaults to '21000000'.";
        header_rate = mkNullable (types.nullOr types.ints.unsigned) "The percentage expansion of the header table body, defaults to '5'.";
        input_size = mkNullable (types.nullOr types.ints.unsigned) "The minimum allocation of the input table body, defaults to '92500000000'.";
        input_rate = mkNullable (types.nullOr types.ints.unsigned) "The percentage expansion of the input table body, defaults to '5'.";
        output_size = mkNullable (types.nullOr types.ints.unsigned) "The minimum allocation of the output table body, defaults to '25300000000'.";
        output_rate = mkNullable (types.nullOr types.ints.unsigned) "The percentage expansion of the output table body, defaults to '5'.";
        point_buckets = mkNullable (types.nullOr types.ints.unsigned) "The number of buckets in the spend table head, defaults to '1365977136'.";
        point_size = mkNullable (types.nullOr types.ints.unsigned) "The minimum allocation of the point table body, defaults to '25700000000'.";
        point_rate = mkNullable (types.nullOr types.ints.unsigned) "The percentage expansion of the point table body, defaults to '5'.";
        ins_size = mkNullable (types.nullOr types.ints.unsigned) "The minimum allocation of the point table body, defaults to '8550000000'.";
        ins_rate = mkNullable (types.nullOr types.ints.unsigned) "The percentage expansion of the ins table body, defaults to '5'.";
        outs_size = mkNullable (types.nullOr types.ints.unsigned) "The minimum allocation of the puts table body, defaults to '3700000000'.";
        outs_rate = mkNullable (types.nullOr types.ints.unsigned) "The percentage expansion of the puts table body, defaults to '5'.";
        tx_buckets = mkNullable (types.nullOr types.ints.unsigned) "The number of buckets in the tx table head, defaults to '469222525'.";
        tx_size = mkNullable (types.nullOr types.ints.unsigned) "The minimum allocation of the tx table body, defaults to '17000000000'.";
        tx_rate = mkNullable (types.nullOr types.ints.unsigned) "The percentage expansion of the tx table body, defaults to '5'.";
        txs_buckets = mkNullable (types.nullOr types.ints.unsigned) "The number of buckets in the txs table head, defaults to '900001'.";
        txs_size = mkNullable (types.nullOr types.ints.unsigned) "The minimum allocation of the txs table body, defaults to '1050000000'.";
        txs_rate = mkNullable (types.nullOr types.ints.unsigned) "The percentage expansion of the txs table body, defaults to '5'.";
        candidate_size = mkNullable (types.nullOr types.ints.unsigned) "The minimum allocation of the candidate table body, defaults to '2575500'.";
        candidate_rate = mkNullable (types.nullOr types.ints.unsigned) "The percentage expansion of the candidate table body, defaults to '5'.";
        confirmed_size = mkNullable (types.nullOr types.ints.unsigned) "The minimum allocation of the candidate table body, defaults to '2575500'.";
        confirmed_rate = mkNullable (types.nullOr types.ints.unsigned) "The percentage expansion of the candidate table body, defaults to '5'.";
        strong_tx_buckets = mkNullable (types.nullOr types.ints.unsigned) "The number of buckets in the strong_tx table head, defaults to '469222525'.";
        strong_tx_size = mkNullable (types.nullOr types.ints.unsigned) "The minimum allocation of the strong_tx table body, defaults to '2900000000'.";
        strong_tx_rate = mkNullable (types.nullOr types.ints.unsigned) "The percentage expansion of the strong_tx table body, defaults to '5'.";
        ecdsa_size = mkNullable (types.nullOr types.ints.unsigned) "The minimum allocation of the batch_ecdsa table body, defaults to '1'.";
        ecdsa_rate = mkNullable (types.nullOr types.ints.unsigned) "The percentage expansion of the batch_ecdsa table body, defaults to '5'.";
        schnorr_size = mkNullable (types.nullOr types.ints.unsigned) "The minimum allocation of the batch_schnorr table body, defaults to '1'.";
        schnorr_rate = mkNullable (types.nullOr types.ints.unsigned) "The percentage expansion of the batch_schnorr table body, defaults to '5'.";
        duplicate_buckets = mkNullable (types.nullOr types.ints.unsigned) "The minimum number of buckets in the duplicate table head, defaults to '1024'.";
        duplicate_size = mkNullable (types.nullOr types.ints.unsigned) "The minimum allocation of the duplicate table body, defaults to '44'.";
        duplicate_rate = mkNullable (types.nullOr types.ints.unsigned) "The percentage expansion of the duplicate table, defaults to '5'.";
        prevout_buckets = mkNullable (types.nullOr types.ints.unsigned) "The minimum number of buckets in the prevout table head, defaults to '0'.";
        prevout_size = mkNullable (types.nullOr types.ints.unsigned) "The minimum allocation of the prevout table body, defaults to '1'.";
        prevout_rate = mkNullable (types.nullOr types.ints.unsigned) "The percentage expansion of the prevout table, defaults to '5'.";
        validated_bk_buckets = mkNullable (types.nullOr types.ints.unsigned) "The number of buckets in the validated_bk table head, defaults to '900001'.";
        validated_bk_size = mkNullable (types.nullOr types.ints.unsigned) "The minimum allocation of the validated_bk table body, defaults to '1700000'.";
        validated_bk_rate = mkNullable (types.nullOr types.ints.unsigned) "The percentage expansion of the validated_bk table body, defaults to '5'.";
        validated_tx_buckets = mkNullable (types.nullOr types.ints.unsigned) "The number of buckets in the validated_tx table head, defaults to '1'.";
        validated_tx_size = mkNullable (types.nullOr types.ints.unsigned) "The minimum allocation of the validated_tx table body, defaults to '1'.";
        validated_tx_rate = mkNullable (types.nullOr types.ints.unsigned) "The percentage expansion of the validated_tx table body, defaults to '5'.";
        address_buckets = mkNullable (types.nullOr types.ints.unsigned) "The number of buckets in the address table head, defaults to '1' (0|1 disables).";
        address_size = mkNullable (types.nullOr types.ints.unsigned) "The minimum allocation of the address table body, defaults to '1'.";
        address_rate = mkNullable (types.nullOr types.ints.unsigned) "The percentage expansion of the address table body, defaults to '5'.";
        filter_bk_buckets = mkNullable (types.nullOr types.ints.unsigned) "The number of buckets in the filter_bk table head, defaults to '0' (0 disables).";
        filter_bk_size = mkNullable (types.nullOr types.ints.unsigned) "The minimum allocation of the filter_bk table body, defaults to '1'.";
        filter_bk_rate = mkNullable (types.nullOr types.ints.unsigned) "The percentage expansion of the filter_bk table body, defaults to '5'.";
        filter_tx_buckets = mkNullable (types.nullOr types.ints.unsigned) "The number of buckets in the filter_tx table head, defaults to '0' (0 disables).";
        filter_tx_size = mkNullable (types.nullOr types.ints.unsigned) "The minimum allocation of the filter_tx table body, defaults to '1'.";
        filter_tx_rate = mkNullable (types.nullOr types.ints.unsigned) "The percentage expansion of the filter_tx table body, defaults to '5'.";
        silent_buckets = mkNullable (types.nullOr types.ints.unsigned) "The number of buckets in the silent table head, defaults to '0' (0 disables).";
        silent_size = mkNullable (types.nullOr types.ints.unsigned) "The minimum allocation of the silent table body, defaults to '1'.";
        silent_rate = mkNullable (types.nullOr types.ints.unsigned) "The percentage expansion of the silent table body, defaults to '5'.";
        silent_start_height = mkNullable (types.nullOr types.ints.unsigned) "The first height indexed by the silent table, defaults to the bip341 activation height.";
      };
    };
    default = {};
    description = "libbitcoin-server [database] configuration settings.";
  };
  log = mkOption {
    type = types.submodule {
      options = {
        application = mkNullable (types.nullOr types.bool) "Enable application logging, defaults to 'true'.";
        news = mkNullable (types.nullOr types.bool) "Enable news logging, defaults to 'true'.";
        session = mkNullable (types.nullOr types.bool) "Enable session logging, defaults to 'true'.";
        protocol = mkNullable (types.nullOr types.bool) "Enable protocol logging, defaults to 'false'.";
        proxy = mkNullable (types.nullOr types.bool) "Enable proxy logging, defaults to 'false'.";
        remote = mkNullable (types.nullOr types.bool) "Enable remote fault logging, defaults to 'true'.";
        fault = mkNullable (types.nullOr types.bool) "Enable local fault logging, defaults to 'true'.";
        quitting = mkNullable (types.nullOr types.bool) "Enable quitting logging, defaults to 'false'.";
        objects = mkNullable (types.nullOr types.bool) "Enable objects logging, defaults to 'false'.";
        verbose = mkNullable (types.nullOr types.bool) "Enable verbose logging, defaults to 'false'.";
        maximum_size = mkNullable (types.nullOr types.ints.unsigned) "The maximum byte size of each pair of rotated log files, defaults to 1000000.";
        symbols = mkNullable (types.nullOr (types.either types.path types.str)) "Path to windows debug build symbols file (.pdb).";
        path = mkNullable (types.nullOr (types.either types.path types.str)) "The log files directory, defaults to empty.";
      };
    };
    default = {};
    description = "libbitcoin-server [log] configuration settings.";
  };
}
