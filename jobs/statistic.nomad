job "statistic" {
  datacenters = ["dc1"]
  type = "service"
  update {
    stagger = "10s"
    max_parallel = 1
  }
  group "services" {
    count = 1
    task "statistic" {
      driver = "docker"
      config {
        image = "localhost:5000/statistic"
        ssl = true
        port_map {
          web = 5004
        }
      }
      service {
        port = "web"
        tags = ["urlprefix-/StatisticService"]
        check {
          type     = "http"
          port     = "web"
          path     = "/StatisticService/status"
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