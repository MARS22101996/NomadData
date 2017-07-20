
job "services" {
  datacenters = ["dc1"]
  type = "service"
  update {
    stagger = "10s"
    max_parallel = 1
  }
  group "cache" {
    count = 1
    restart {
      attempts = 10
      interval = "5m"
      delay = "25s"
      mode = "delay"
    }

    ephemeral_disk {
      size = 300
    }

    task "user_service" {
      driver = "docker"
      config {
        image = "localhost:5000/user"
        port_map {
          db = 5001
        }
      }
      resources {
        cpu    = 500 # 500 MHz
        memory = 64 # 64MB
        network {
          port "http" {
            static = "5001"
            interface {
              availability = "public"
            }
          }
          mbits = 10
          port "db" {}
        }
      }
      service {
        name = "UserService"
        tags = ["urlprefix-/UserService"]
        port = "db"
        check {
          type     = "http"
          path     = "http://10.0.2.15:5001/UserService/status"
          port     = "db"
          interval = "10s"
          timeout  = "2s"
        }
      }
    }

    task "team_service" {
      driver = "docker"
      config {
        image = "localhost:5000/team"
        port_map {
          db = 5002
        }
      }
      resources {
        cpu    = 400 # 500 MHz
        memory = 64 # 64MB
        network {
          port "http" {
            static = "5002"
            interface {
              availability = "public"
            }
          }
          mbits = 10
          port "db" {}
        }
      }
      service {
        name = "TeamService"
        tags = ["urlprefix-/TeamService"]
        port = "db"
        check {
          type     = "http"
          path     = "/status"
          port     = "db"
          interval = "10s"
          timeout  = "2s"
        }
      }
    }

    task "ticket_service" {
      driver = "docker"
      config {
        image = "localhost:5000/ticket"
        port_map {
          db = 5003
        }
      }
      resources {
        cpu    = 500 # 500 MHz
        memory = 64 # 64MB
        network {
          port "http" {
            static = "5003"
          }
          mbits = 10
          port "db" {}
        }
      }
      service {
        name = "TicketService"
        tags = ["urlprefix-/TicketService"]
        port = "db"
        check {
          type     = "http"
          path     = "/status"
          port     = "db"
          interval = "10s"
          timeout  = "2s"
        }
      }
    }

    task "statistic_service" {
      driver = "docker"
      config {
        image = "localhost:5000/statistic"
        port_map {
          db = 5004
        }
      }
      resources {
        cpu    = 500 # 500 MHz
        memory = 64 # 64MB
        network {
          port "http" {
            static = "5004"
          }
          mbits = 10
          port "db" {}
        }
      }
      service {
        name = "StatisticService"
        tags = ["urlprefix-/StatisticService"]
        port = "db"
        check {
          type     = "http"
          path     = "/status"
          port     = "db"
          interval = "10s"
          timeout  = "2s"
        }
      }
    }

    task "notification_service" {
      driver = "docker"
      config {
        image = "localhost:5000/notification"
        port_map {
          db = 5006
        }
      }
      resources {
        cpu    = 500 # 500 MHz
        memory = 64 # 64MB
        network {
          port "http" {
            static = "5006"
          }
          mbits = 10
          port "db" {}
        }
      }
      service {
        name = "NotificationService"
        tags = ["urlprefix-/NotificationService"]
        port = "db"
        check {
          type     = "http"
          path     = "/status"
          port     = "db"
          interval = "10s"
          timeout  = "2s"
        }
      }
    }
  }
}