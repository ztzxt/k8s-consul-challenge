service {
  name = "prometheus-int"
  address = "192.168.4.133"
  port = 80
  checks = [
    {
      args = ["curl", "192.168.4.133/-/healthy"]
      interval = "5s"
      timeout = "20s"
    }
  ]
}
