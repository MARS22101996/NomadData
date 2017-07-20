#!/bin/bash

function build {
  sudo docker build -t $1 .

  sudo docker tag $1 localhost:5000/$1
  sudo docker push localhost:5000/$1
  cd ~
}

sudo docker run -d -p 5000:5000 --restart always --name registry registry:2
cd ~
cd /home/services/msa-team-service/TeamService/src/TeamService.WEB
build team
docker tag ubuntu localhost:5000/ubuntu

cd /home/services/msa-user-service/UserService/src/UserService.WEB
build user

cd /home/services/msa-ticket-service/TicketService/src/TicketService.WEB
build ticket

cd /home/services/msa-statistic-service/StatisticService/src/StatisticService.WEB
build statistic

cd /home/services/msa-notification-service/NotificationService/src/NotificationService.WEB
build notification

cd /home/services/msa-api-gateway/src/ApiGateway
build apigateway

cd /home/services/msa-task-manager-ui/TaskManagerUI/src/TaskManagerUI
build ui