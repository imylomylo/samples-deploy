#!/bin/bash
screen -dmS juicychain-api bash -c "docker-compose -f docker-compose-juicychain-api.yaml up; exec bash"
