#!/bin/bash

# GET ALL NODES
INSTANCES=$(ls -d instance-*)

for current in $INSTANCES
do
# NODE UTXOs
# get all node addresses
current_address=$(grep THIS_NODE_WALLET $current/.env | awk -F '=' '{print $2}')
echo $current_address
# get utxo count (all)
curl -s http://seed.juicydev.coingateways.com:64422/insight-api-komodo/addrs/$current_address/utxo  | jq '. | length'
# get utxo value (all)
curl -s http://seed.juicydev.coingateways.com:64422/insight-api-komodo/addrs/$current_address/utxo  | jq '.[] | .amount' | jq -s add

# get utxo count older than 5
curl -s http://seed.juicydev.coingateways.com:64422/insight-api-komodo/addrs/$current_address/utxo  | jq '.[] | select (.confirmations > 5)' | jq -s length
# get utxo value older than 5
curl -s http://seed.juicydev.coingateways.com:64422/insight-api-komodo/addrs/$current_address/utxo  | jq '.[] | select (.confirmations > 5) | .amount ' | jq -s add

# get utxo count younger than 5
curl -s http://seed.juicydev.coingateways.com:64422/insight-api-komodo/addrs/$current_address/utxo  | jq '.[] | select (.confirmations < 5)' | jq -s length
# get utxo value younger than 5
curl -s http://seed.juicydev.coingateways.com:64422/insight-api-komodo/addrs/$current_address/utxo  | jq '.[] | select (.confirmations < 5) | .amount ' | jq -s add

# Imports
# get number total imports
# get total integrity addresses
# get total integrity pre tx
# get total integrity post tx
done
