#!/bin/bash
docker stop $(docker ps -a | grep instance | awk '{print $1}')
docker rm $(docker ps -a | grep instance | awk '{print $1}')
