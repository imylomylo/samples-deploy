#!/bin/bash
CLONES=$1
# check if screen name clones exists, if not create
# check if list.json exists, if not, exit
for (( i = 0 ; i <  $CLONES ; i++ ))
do
    CLONE=$((100 + i))
    echo "CLONE $CLONE created"
    cp clone.instance.XX_CLONE_XX.env instance.$CLONE.env
    cp clone.docker-compose.XX_CLONE_XX.yaml instance.docker-compose.$CLONE.yaml
    sed -i "s/XX_CLONE_XX/$CLONE/g" instance.$CLONE.env
    sed -i "s/XX_CLONE_XX/$CLONE/g" instance.docker-compose.$CLONE.yaml
    THIS_CLONE_PUBKEY=$(cat list.json | jq -r ".[$i][1]")
    THIS_CLONE_WIF=$(cat list.json | jq -r ".[$i][2]")
    THIS_CLONE_ADDRESS=$(cat list.json | jq -r ".[$i][3]")
    screen -S clones -x -X screen bash -c "docker-compose -f instance.docker-compose.$CLONE.yaml --env-file instance.$CLONE.env --project-name $CLONE up; exec bash"
    sleep 1
done
