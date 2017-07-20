#!/bin/bash

function run {
  nomad stop -address="http://10.100.199.200:4646" $1
}

run user
run team
run ticket
run statistic
run notification