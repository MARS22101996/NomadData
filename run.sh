#!/bin/sh -e
./home/consul_start.sh
sudo nomad agent -config /home/server.hcl
sudo nomad agent -config /home/client1.hcl
sudo docker run -e NOMAD_ENABLE=1 -e NOMAD_ADDR="http://10.100.199.200:4646" -p 8000:3000 jippi/hashi-ui
./home/start.sh
./home/run_jobs.sh

exit 0
