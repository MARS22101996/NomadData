job "ticket" {
  datacenters = ["dc1"]
  type = "service"
  update {
    stagger = "10s"
    max_parallel = 1
  }
  group "services" {
    count = 1
    task "ticket" {
      driver = "docker"
      config {
        image = "localhost:5000/ticket"
        ssl = true
        port_map {
          web = 5003
        }
      }
      service {
        port = "web"
        tags = ["urlprefix-/TicketService"]
        check {
          type     = "http"
          port     = "web"
          path     = "/TicketService/status"
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