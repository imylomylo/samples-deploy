#!/bin/bash
docker image rm -f $(docker images | grep instance | awk '{print $3}')
