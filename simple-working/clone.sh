#!/bin/bash
CLONES=$1
for (( i = 0 ; i <  $CLONES ; i++ ))
do
    CLONE=$((100 + i))
    echo "CLONE $CLONE create docker-compose (yaml & env)"
    cp clone.instance.XX_CLONE_XX.env instance.$CLONE.env
    cp clone.docker-compose.XX_CLONE_XX.yaml instance.docker-compose.$CLONE.yaml
    sed -i "s/XX_CLONE_XX/$CLONE/g" instance.$CLONE.env
    sed -i "s/XX_CLONE_XX/$CLONE/g" instance.docker-compose.$CLONE.yaml
    THIS_CLONE_PUBKEY=$(cat list.json | jq -r ".[$i][1]")
    THIS_CLONE_WIF=$(cat list.json | jq -r ".[$i][2]")
    THIS_CLONE_ADDRESS=$(cat list.json | jq -r ".[$i][3]")
    echo "CLONE $CLONE blocknotify-python application env"
    cp clone.instance.blocknotify-python.XX_CLONE_XX.env clone.instance.blocknotify-python.$CLONE.env
    cp clone.instance.blocknotify-python.$CLONE.env blocknotify-python/.env
    screen -dmS clone_$CLONE bash -c "docker-compose -f instance.docker-compose.$CLONE.yaml --env-file instance.$CLONE.env --project-name $CLONE up; exec bash"
    sleep 10
done
