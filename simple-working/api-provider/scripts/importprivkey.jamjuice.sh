#!/bin/bash
#rpcuser=changeme
#rpcpassword=alsochangeme
#rpcport=33063
source ../../.env
rpcuser=$KOMODO_SMARTCHAIN_NODE_USERNAME
rpcpassword=$KOMODO_SMARTCHAIN_NODE_PASSWORD
rpcport=$KOMODO_SMARTCHAIN_NODE_RPC_PORT
wif=$THIS_NODE_WIF
#echo $rpcuser $rpcpassword @ $rpcport $wif
curl -s --user $rpcuser:$rpcpassword --data-binary "{\"jsonrpc\": \"1.0\", \"id\": \"curltest\", \"method\": \"importprivkey\", \"params\": [\"$wif\"]}" -H 'content-type: text/plain;' http://127.0.0.1:$rpcport/
