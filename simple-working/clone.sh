#!/bin/bash
START=$PWD
CLONES=$1
LAST_CREATED=$(docker ps -a | grep jamjuice | awk '{print $14}' | awk -F '_' '{print $1}' |cut -d - -f 2 | sort | tail -n 1)
touch clones.migrate-import-api.sh
chmod +x clones.migrate-import-api.sh
touch clones.get-ports-import-api.sh
chmod +x clones.get-ports-import-api.sh
if [ -z $LAST_CREATED ] ; then
	LAST_CREATED=99
fi

for (( i = 0 ; i <  $CLONES ; i++ ))
do
    cd $START
    CLONE=$((100 + i))
    echo "Next in clone instance is $CLONE, last created before this script execution was $LAST_CREATED"
    sleep 1
    if [ $CLONE -gt $LAST_CREATED ] ; then 
        INSTANCE=instance-$CLONE
        mkdir $INSTANCE
        ln -sf -t $INSTANCE/ ../blocknotify-python
        ln -sf -t $INSTANCE ../jamjuice-komodo-node
        ln -sf -t $INSTANCE ../juicychain-api
        ln -sf -t $INSTANCE ../import-api
        ln -sf -t $INSTANCE ../customer-smartchain-nodes-blocknotify
        cp run-blocknotify.sh $INSTANCE
        cp build-service.sh $INSTANCE
        cp pipeline-import.sh $INSTANCE
        THIS_CLONE_PUBKEY=$(cat list.json | jq -r ".[$i][1]")
        THIS_CLONE_WIF=$(cat list.json | jq -r ".[$i][2]")
        THIS_CLONE_ADDRESS=$(cat list.json | jq -r ".[$i][3]")
        echo "CLONE $CLONE create docker-compose (yaml & env)"
        cp $START/clone.XX_CLONE_XX.env $INSTANCE/.env
        cp $START/clone.docker-compose.XX_CLONE_XX.yaml $INSTANCE/docker-compose.yaml
        sed -i "s/XX_CLONE_XX/$CLONE/g" $INSTANCE/.env
        sed -i "s/XX_CLONE_XX/$CLONE/g" $INSTANCE/docker-compose.yaml
        sed -i "s/XX_THIS_NODE_PUBKEY_XX/$THIS_CLONE_PUBKEY/g" $INSTANCE/.env
        sed -i "s/XX_THIS_NODE_WIF_XX/$THIS_CLONE_WIF/g" $INSTANCE/.env
        sed -i "s/XX_THIS_NODE_WALLET_XX/$THIS_CLONE_ADDRESS/g" $INSTANCE/.env
        echo "CLONE $CLONE blocknotify-python application env"
        cp clone.blocknotify-python.XX_CLONE_XX.env $INSTANCE/blocknotify-python/.env
        sed -i "s/XX_CLONE_XX/$CLONE/g" $INSTANCE/blocknotify-python/.env
        sed -i "s/XX_THIS_NODE_PUBKEY_XX/$THIS_CLONE_PUBKEY/g" $INSTANCE/blocknotify-python/.env
        sed -i "s/XX_THIS_NODE_WIF_XX/$THIS_CLONE_WIF/g" $INSTANCE/blocknotify-python/.env
        sed -i "s/XX_THIS_NODE_WALLET_XX/$THIS_CLONE_ADDRESS/g" $INSTANCE/blocknotify-python/.env
        cd $INSTANCE
        ./build-service.sh blocknotify-python
        screen -dmS $INSTANCE bash -c "cd $INSTANCE; docker-compose --project-name $INSTANCE up; exec bash"
        echo "Be patient.  Sleeping for 6 seconds"
        echo "docker exec -i -t ${INSTANCE}_import-api_1 python manage.py migrate" >> $START/clones.migrate-import-api.sh
        sed -i "s/XX_INSTANCE_XX/$INSTANCE/g" $START/$INSTANCE/pipeline-import.sh
        sed -i "s/XX_CLONE_XX/$CLONE/g" $START/$INSTANCE/pipeline-import.sh
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

