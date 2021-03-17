#!/bin/bash
CURRENT_VERSION=3
cp .env.api-provider.jamjuice${CURRENT_VERSION} .env
/bin/rm -Rf ./api-provider/jamjuice-komodo-node/data
/bin/rm -Rf ./api-provider/jamjuicekv-komodo-node/data
