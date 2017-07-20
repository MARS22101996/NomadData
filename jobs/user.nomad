job "user" {
  datacenters = ["dc1"]
  type = "service"
  update {
    stagger = "10s"
    max_parallel = 1
  }
  group "services" {
    count = 1
    task "user" {
      driver = "docker"
      config {
        image = "localhost:5000/user"
        ssl = true
        port_map {
          web = 5001
        }
      }
      service {
        port = "web"
        tags = ["urlprefix-/UserService"]
        check {
          type     = "http"
          port     = "web"
          path     = "/UserService/status"
          interval = "10s"
          timeout  = "2s"
        }
      }
      resources {
        cpu    = 400 # MHz
        memory = 128 # MB
        network {
          mbits = 100
          port "web" { }
          port "https" { }
        }
      }
    }
  }
}