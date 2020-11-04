#!/bin/bash
docker network rm $(docker network ls | grep instance | awk '{print $1}')
