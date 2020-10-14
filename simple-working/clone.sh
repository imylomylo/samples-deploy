#!/bin/bash
CLONES=$1
for (( i = 0 ; i <  $CLONES ; i++ ))
do
    CLONE=$((100 + i))
    echo "CLONE $CLONE created"
    cp clone.instance.XX_CLONE_XX.env instance.$CLONE.env
    cp clone.docker-compose.XX_CLONE_XX.yaml instance.docker-compose.$CLONE.yaml
    sed -i "s/XX_CLONE_XX/$CLONE/g" instance.$CLONE.env
    sed -i "s/XX_CLONE_XX/$CLONE/g" instance.docker-compose.$CLONE.yaml
    screen -S clones -x -X screen bash -c "docker-compose -f instance.docker-compose.$CLONE.yaml --env-file instance.$CLONE.env --project-name $CLONE up; exec bash"
    sleep 1
done
