#!/bin/bash
START=$PWD

# number of clones to make
CLONES=$1

# get last created number from this script by looking at currently running containers
LAST_CREATED=$(docker ps -a | grep jamjuice2kv | grep -v working | sed -n 's/^.*\(instance.*\).*/\1/p' | sort | tail -n 1 | cut -d '_' -f 1 | cut -d '-' -f 2)

# handy script for running db migrations for each instance import-api
touch clones.migrate-import-api.sh
chmod +x clones.migrate-import-api.sh

# sanity check 
if [ -z $LAST_CREATED ] ; then
	LAST_CREATED=99
fi

# start loop to create instances
for (( i = 0 ; i < $CLONES ; i++ ))
do
    cd $START
    # add 100, this forms the octet for network segregation e.g. 172.XXX.0.0/16
    CLONE=$((100 + i))
    echo "Next in clone instance is $CLONE, last created before this script execution was $LAST_CREATED"
    sleep 1
    # check if this iteration is greater than the last known created instance (helpful at the start or when re-running to make more)
    echo $CLONE ">" $LAST_CREATED "?"
    if [ "$CLONE" -gt "$LAST_CREATED" ] ; then 
	# name of this instance 
        INSTANCE=instance-$CLONE
	# make working dir for this instance organization and link stuff required
        mkdir $INSTANCE
        ln -sf -t $INSTANCE/ ../blocknotify-python
        ln -sf -t $INSTANCE ../jamjuice-komodo-node
        ln -sf -t $INSTANCE ../juicychain-api
        ln -sf -t $INSTANCE ../import-api
        ln -sf -t $INSTANCE ../customer-smartchain-nodes-blocknotify
	# copy the template scripts & env for this instance
        cp clone.run-blocknotify.sh $INSTANCE/run-blocknotify.sh
        cp build-service.sh $INSTANCE
        cp pipeline-import.sh $INSTANCE
        cp $START/clone.XX_CLONE_XX.env $INSTANCE/.env
        cp $START/clone.docker-compose.XX_CLONE_XX.yaml $INSTANCE/docker-compose.yaml
        cp $START/clone.blocknotify-python.XX_CLONE_XX.env $INSTANCE/blocknotify-python/.env
	# set the values for this instance
        THIS_CLONE_PUBKEY=$(cat list.json | jq -r ".[$i][1]")
        THIS_CLONE_WIF=$(cat list.json | jq -r ".[$i][2]")
        THIS_CLONE_ADDRESS=$(cat list.json | jq -r ".[$i][3]")
        echo "CLONE $CLONE create docker-compose (yaml & env)"
	# sed replace template vars with this instance vars
        sed -i "s/XX_CLONE_XX/$CLONE/g" $INSTANCE/.env
        sed -i "s/XX_CLONE_XX/$CLONE/g" $INSTANCE/docker-compose.yaml
        sed -i "s/XX_THIS_NODE_PUBKEY_XX/$THIS_CLONE_PUBKEY/g" $INSTANCE/.env
        sed -i "s/XX_THIS_NODE_WIF_XX/$THIS_CLONE_WIF/g" $INSTANCE/.env
        sed -i "s/XX_THIS_NODE_WALLET_XX/$THIS_CLONE_ADDRESS/g" $INSTANCE/.env
        echo "CLONE $CLONE blocknotify-python application env"
        sed -i "s/XX_CLONE_XX/$CLONE/g" $INSTANCE/blocknotify-python/.env
        sed -i "s/XX_THIS_NODE_PUBKEY_XX/$THIS_CLONE_PUBKEY/g" $INSTANCE/blocknotify-python/.env
        sed -i "s/XX_THIS_NODE_WIF_XX/$THIS_CLONE_WIF/g" $INSTANCE/blocknotify-python/.env
        sed -i "s/XX_THIS_NODE_WALLET_XX/$THIS_CLONE_ADDRESS/g" $INSTANCE/blocknotify-python/.env
        sed -i "s/XX_INSTANCE_XX/$INSTANCE/g" $START/$INSTANCE/pipeline-import.sh
        sed -i "s/XX_CLONE_XX/$CLONE/g" $START/$INSTANCE/pipeline-import.sh
        cd $INSTANCE
	# build this instance blocknotify with it's own env (sed above)
        ./build-service.sh blocknotify-python
	# run the docker-compose for this instance in a screen session called instance-XXX
        screen -dmS $INSTANCE bash -c "cd $INSTANCE; docker-compose --project-name $INSTANCE up; exec bash"
        echo "Be patient.  Sleeping for 6 seconds"
	# echo a command into a helper script for database migrations for all instances
        echo "docker exec -i -t ${INSTANCE}_import-api_1 python manage.py migrate" >> $START/clones.migrate-import-api.sh
        sleep 6
    else
	echo "Try higher value, adding 1 to $CLONES"
	CLONES=$((CLONES + 1))
	echo "CLONES to try starting bumped up by 1, is now $CLONES"
	echo "Next try will be $((CLONE + i + 1))"
	sleep 1
    fi

done
