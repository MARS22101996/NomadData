#!/bin/bash

function run {
  nomad run -address="http://10.100.199.200:4646" $1
}

cd jobs

run user.nomad
run team.nomad
run ticket.nomad
run statistic.nomad
run notification.nomad
run fabio.nomad