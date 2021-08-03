#!/bin/bash
SENDMANYARG="{"
for address in `cat list.json | jq '.[][3]'`
do
   SENDMANYARG=${SENDMANYARG}${address}": 2.5," 
done

SENDMANYARG=`echo $SENDMANYARG | sed 's/.$//'`
SENDMANYARG=$SENDMANYARG"}"

echo "komodo-cli -ac_name=JAMJUICE sendmany \"\" '$SENDMANYARG'"
