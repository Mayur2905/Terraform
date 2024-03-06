#!/bin/bash
sudo -i
sudo yum update -y
sudo yum nodejs -y
sudo yum install npm -y
sudo yum install git -y
sudo git init
sudo git pull https://github.com/SafdarJamal/quiz-app.git
sudo npm install 
sudo npm start
