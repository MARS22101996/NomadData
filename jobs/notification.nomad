job "notification" {
  datacenters = ["dc1"]
  type = "service"
  update {
    stagger = "10s"
    max_parallel = 1
  }
  group "services" {
    count = 1
    task "notification" {
      driver = "docker"
      config {
        image = "localhost:5000/notification"
        ssl = true
        port_map {
          web = 5006
        }
      }
      service {
        port = "web"
        tags = ["urlprefix-/NotificationService"]
        check {
          type     = "http"
          port     = "web"
          path     = "/NotificationService/status"
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