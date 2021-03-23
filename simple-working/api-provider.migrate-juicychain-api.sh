#!/bin/bash
docker exec -i -t api-provider_juicychain-api_1 python manage.py migrate
