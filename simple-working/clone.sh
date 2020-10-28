#!/bin/bash
START=$PWD
CLONES=$1
LAST_CREATED=$(docker ps -a | grep jamjuice | awk '{print $14}' | awk -F '_' '{print $2}' | sort | tail -n 1)
for (( i = 0 ; i <  $CLONES ; i++ ))
do
    cd $START
    CLONE=$((100 + i))
    echo "Next in clone instance is $CLONE, last created before this script execution was $LAST_CREATED"
    sleep 1
    if [ $CLONE -gt $LAST_CREATED ] ; then 
        INSTANCE=instance_$CLONE
        mkdir $INSTANCE
        ln -sf -t $INSTANCE/ ../blocknotify-python
        ln -sf -t $INSTANCE ../jamjuice-komodo-node
        ln -sf -t $INSTANCE ../juicychain-api
        ln -sf -t $INSTANCE ../import-api
        ln -sf -t $INSTANCE ../customer-smartchain-nodes-blocknotify
        cp run-blocknotify.sh $INSTANCE
        cp build-service.sh $INSTANCE
        THIS_CLONE_PUBKEY=$(cat list.json | jq -r ".[$i][1]")
        THIS_CLONE_WIF=$(cat list.json | jq -r ".[$i][2]")
        THIS_CLONE_ADDRESS=$(cat list.json | jq -r ".[$i][3]")
        echo "CLONE $CLONE create docker-compose (yaml & env)"
        cp clone.XX_CLONE_XX.env $INSTANCE/.env
        cp clone.docker-compose.XX_CLONE_XX.yaml $INSTANCE/docker-compose.yaml
        sed -i "s/XX_CLONE_XX/$CLONE/g" $INSTANCE/.env
        sed -i "s/XX_CLONE_XX/$CLONE/g" $INSTANCE/docker-compose.yaml
        sed -i "s/XX_THIS_NODE_PUBKEY_XX/$THIS_CLONE_PUBKEY/g" $INSTANCE/.env
        sed -i "s/XX_THIS_NODE_WIF_XX/$THIS_CLONE_WIF/g" $INSTANCE/.env
        sed -i "s/XX_THIS_NODE_WALLET_XX/$THIS_CLONE_ADDRESS/g" $INSTANCE/.env
        echo "CLONE $CLONE blocknotify-python application env"
        cp clone.blocknotify-python.XX_CLONE_XX.env instance_$CLONE/blocknotify-python/.env
        sed -i "s/XX_CLONE_XX/$CLONE/g" instance_$CLONE/blocknotify-python/.env
        sed -i "s/XX_THIS_NODE_PUBKEY_XX/$THIS_CLONE_PUBKEY/g" instance_$CLONE/blocknotify-python/.env
        sed -i "s/XX_THIS_NODE_WIF_XX/$THIS_CLONE_WIF/g" instance_$CLONE/blocknotify-python/.env
        sed -i "s/XX_THIS_NODE_WALLET_XX/$THIS_CLONE_ADDRESS/g" instance_$CLONE/blocknotify-python/.env
        cd $INSTANCE
        ./build-service.sh blocknotify-python
        screen -dmS instance_$CLONE bash -c "cd $INSTANCE; docker-compose --project-name instance_$CLONE up; exec bash"
        echo "Be patient.  Sleeping for 6 seconds"
        sleep 6
    else
	echo "Try higher value, adding 1 to $CLONES"
	CLONES=$((CLONES + 1))
	echo "CLONES to try starting bumped up by 1, is now $CLONES"
	echo "Next try will be $((CLONE + i + 1))"
	sleep 1
    fi

done


# docker network rm $(docker network ls | grep komodo | grep -v simple | awk '{print $2}')

