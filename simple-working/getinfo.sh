#!/bin/bash
rpcuser=changeme
rpcpassword=alsochangeme
rpcport=33063
curl -s --user $rpcuser:$rpcpassword --data-binary "{\"jsonrpc\": \"1.0\", \"id\": \"curltest\", \"method\": \"getinfo\", \"params\": []}" -H 'content-type: text/plain;' http://127.0.0.1:$rpcport/
