#!/bin/bash
SENDMANYARG="{"
for address in `cat list.json | jq '.[][3]'`
do
   SENDMANYARG=${SENDMANYARG}${address}": 150.5," 
done

SENDMANYARG=`echo $SENDMANYARG | sed 's/.$//'`
SENDMANYARG=$SENDMANYARG"}"

echo "komodo-cli -ac_name=JAMJUICE3 sendmany \"\" '$SENDMANYARG'"
echo "komodo-cli -ac_name=JAMJUICE3KV1 sendmany \"\" '$SENDMANYARG'"
