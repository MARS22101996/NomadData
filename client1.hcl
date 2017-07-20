# Increase log verbosity
log_level = "DEBUG"

# Setup data dir
data_dir = "/tmp/client1"

# Enable the client
client {
    enabled = true

    # For demo assume we are talking to server1. For production,
    # this should be like "nomad.service.consul:4647" and a system
    # like Consul used for service discovery.
    servers = ["10.100.199.200:4647"]

    # Since we are starting two clients on the same host, we need to set
    # this in order to force nomad to generate client UUIDs randomly,
    # instead of based on the host UUID.
    no_host_uuid = true
}

addresses {
    http = "10.100.199.200"
    rpc = "10.100.199.200"
    serf = "10.100.199.200"
}

advertise {
    http = "10.100.199.200:4646"
    rpc = "10.100.199.200:4647"
    serf = "10.100.199.200:4648"
}

# Modify our port to avoid a collision with server1
ports {
    http = 5656
}