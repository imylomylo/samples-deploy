## Notes:
- To run: `docker-compose up`.
- The data from juicy chain will be saved locally to `./ijuice-komodo-node/data`, blockchain data
will not be lost when the `ijuice-komodo-node` container is restarted or deleted.
- Environment variables which are needed accross different docker-compose services are in `.env`.
- All other environment variables are defined explicitly in the `docker-compose` file.
- No config file is used, all parametsers are passed as arguments to the komodo binary.


## Some useful commands, based on current environment variables
- from terminal: `docker exec simple-working_ijuice-komodo-node_1 tail -f /var/data/komodo/coindata/IJUICE/debug.log`.
- from the ijuice-komodo-node: `curl --user changeme:alsochangeme --data '{"method": "getinfo"}' http://127.0.0.1:24708`.
