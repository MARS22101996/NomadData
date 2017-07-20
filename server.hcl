# Increase log verbosity
log_level = "DEBUG"

# Setup data dir
data_dir = "/tmp/server1"

# Enable the server
server {
    enabled = true
    bootstrap_expect = 1
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