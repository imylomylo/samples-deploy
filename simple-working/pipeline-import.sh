#!/bin/bash
INSTANCE=$1
INSTANCE_PORT=$(docker inspect XX_INSTANCE_XX_import-api_1 | jq -r '.[].NetworkSettings.Ports."8777/tcp"|.[].HostPort')
#API_HOST="http://172.XX_CLONE_XX.0.4:$INSTANCE_PORT/"
API_HOST="http://127.0.0.1:$INSTANCE_PORT/"

for i in {1..1}
do

	# DATES
	PROD_RANDOM_START_DAY=$(cat /dev/urandom | tr -dc '1-2' | fold -w 2 | head -n 1)
        RANDOM_1=$(cat /dev/urandom | tr -dc '1-8' | fold -w 1 | head -n 1)
        PROD_END_DAY=$((PROD_RANDOM_START_DAY + RANDOM_1))
        PROD_MONTH="02"
        PROD_YEAR="2020"
	BBD_MONTH="05"

	# DATA
	RANDOM_VAL_ANFP=18505100
	RANDOM_VAL_DFP="Description here"
	RANDOM_VAL_BNFP=$(cat /dev/urandom | tr -dc '0-9' | fold -w 6 | head -n 1)
	RANDOM_VAL_PC="DE"
	RANDOM_VAL_PL="Herrath"
	RANDOM_VAL_RMN=11200100520
	RANDOM_VAL_PON=100$(cat /dev/urandom | tr -dc '0-9' | fold -w 7 | head -n 1)
	RANDOM_VAL_POP=$(cat /dev/urandom | tr -dc '1-9' | fold -w 3 | head -n 1)
	JDS=$((PROD_RANDOM_START_DAY + 31)) 
	JDE=$((PROD_END_DAY + 31))
	PDS="${PROD_YEAR}-${PROD_MONTH}-${PROD_RANDOM_START_DAY}"
	PDE="${PROD_YEAR}-${PROD_MONTH}-${PROD_END_DAY}"
	BBD="${PROD_YEAR}-${BBD_MONTH}-${PROD_END_DAY}"
	# RAW_JSON=$(echo '{ \"anfp\": \"'${RANDOM_VAL_1}'\",\"dfp\": \"'${RANDOM_VAL_2}'\"}' | base64 -w 0)
	RAW_JSON=$(echo '{ \"anfp\": \"'${RANDOM_VAL_ANFP}'\",\"dfp\": \"'${RANDOM_VAL_DFP}'\",\"bnfp\": \"'${RANDOM_VAL_BNFP}'\",\"pds\": \"'${PDS}'\",\"pde\": \"'${PDE}'\",\"jds\": '${JDS}',\"jde\": '${JDE}',\"bbd\": \"'${BBD}'\",\"pc\": \"'${RANDOM_VAL_PC}'\",\"pl\": \"'${RANDOM_VAL_PL}'\",\"rmn\": \"'${RANDOM_VAL_RMN}'\",\"pon\": \"'${RANDOM_VAL_PON}'\",\"pop\": \"'${RANDOM_VAL_POP}'\"' | base64 -w 0)
	echo ""
	echo curl -X POST -H "Content-Type: application/json" ${API_HOST}raw/refresco/ -d "{ \"anfp\": \"${RANDOM_VAL_ANFP}\",\"dfp\": \"${RANDOM_VAL_DFP}\",\"bnfp\": \"${RANDOM_VAL_BNFP}\",\"pds\": \"${PDS}\",\"pde\": \"${PDE}\",\"jds\": ${JDS},\"jde\": ${JDE},\"bbd\": \"${BBD}\",\"pc\": \"${RANDOM_VAL_PC}\",\"pl\": \"${RANDOM_VAL_PL}\",\"rmn\": \"${RANDOM_VAL_RMN}\",\"pon\": \"${RANDOM_VAL_PON}\",\"pop\": \"${RANDOM_VAL_POP}\", \"raw_json\": \"${RAW_JSON}\"}"
	echo ""
	curl -X POST -H "Content-Type: application/json" ${API_HOST}raw/refresco/ -d "{ \"anfp\": \"${RANDOM_VAL_ANFP}\",\"dfp\": \"${RANDOM_VAL_DFP}\",\"bnfp\": \"${RANDOM_VAL_BNFP}\",\"pds\": \"${PDS}\",\"pde\": \"${PDE}\",\"jds\": ${JDS},\"jde\": ${JDE},\"bbd\": \"${BBD}\",\"pc\": \"${RANDOM_VAL_PC}\",\"pl\": \"${RANDOM_VAL_PL}\",\"rmn\": \"${RANDOM_VAL_RMN}\",\"pon\": \"${RANDOM_VAL_PON}\",\"pop\": \"${RANDOM_VAL_POP}\", \"raw_json\": \"${RAW_JSON}\"}"
	sleep 1
done
