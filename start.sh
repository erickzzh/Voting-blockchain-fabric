echo "Deleting old volumes and config files"
docker-compose -f docker-compose-cli.yaml down --volumes
echo "Creating new volumes and config files"
docker-compose -f docker-compose-cli.yaml up -d
echo "Here is a list of all the docker containers that are running"
docker ps