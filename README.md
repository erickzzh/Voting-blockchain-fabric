# Voting-blockchain-fabric
Hyperledger project for voting

## Set up
Most of the instructions could be foud from:

https://hyperledger-fabric.readthedocs.io/en/latest/prereqs.html

https://hyperledger-fabric.readthedocs.io/en/latest/build_network.html

https://medium.com/hyperlegendary/setting-up-a-blockchain-business-network-with-hyperledger-fabric-composer-running-in-multiple-bfbe4e38b6c6

https://github.com/CATechnologies/blockchain-tutorials/wiki/Tutorial:-Hyperledger-Fabric-v1.1-%E2%80%93-Create-a-Development-Business-Network-on-zLinux

this set-up guide is for Mac users.

### Install Docker and Docker Compose
You will need the following installed on the platform on which you will be operating, or developing on (or for), Hyperledger Fabric:

- MacOSX, *nix, or Windows 10: [Docker](https://www.docker.com/get-started) Docker version 17.06.2-ce or greater is required.
- Older versions of Windows: [Docker Toolbox](https://docs.docker.com/toolbox/toolbox_install_windows/) - again, Docker version Docker 17.06.2-ce or greater is required.

You can check the version of Docker you have installed with the following command from a terminal prompt:

```bash
$ docker --version
```

```bash
$ docker-compose --version
```

### Install Go Programming Language

Hyperledger Fabric uses the Go Programming Language for many of its components.

- [Go](https://golang.org/dl/) version 1.10.x is required.

Given that we will be writing chaincode programs in Go, there are two environment variables you will need to set properly; you can make these settings permanent by placing them in the appropriate startup file, such as your personal ~/.bashrc file if you are using the bash shell under Linux.

```bash
export GOPATH=$HOME/go
```
```bash
export PATH=$PATH:$GOPATH/bin
```

### Retrieve Artifacts from Hyperledger Fabric Repositories

First of all, we will clone fabric-samples repository. This will help us to use configuration used in the official Hyperledger Fabric example project as the base for our own configuration.

Navigate to the location of your choice on your filesystem and open it from terminal. Then run the following commands to clone remote Git repository:

```bash
git clone -b master https://github.com/hyperledger/fabric-samples.git
cd fabric-samples
```

As a next step, we are going to download and install Hyperledger Fabric binaries specific to your platform.

Execute the following command to download Hyperledger Fabric binaries and Docker images:

```bash
curl -sSL http://bit.ly/2ysbOFE | bash -s 1.2.0
```
You may want to add that to your PATH environment variable so that these can be picked up without fully qualifying the path to each binary. e.g.:

```bash
export PATH=<path to download location>/bin:$PATH
```

## Network Set up
Everything is now in place for us to generate our certificates and keys. Make sure you are inside the project folder and run:

```bash
../bin/cryptogen generate --config crypto-config.yaml --output=crypto-config
```

## Create the orderer genesis block, channel, and the anchor peer for each organisation.

Anchor peer: An anchor peer on a channel is a public peer that all others peers can discover and communicate with. Each organisation on a channel has an anchor peer.

The ```configtxgen``` command doesn't automatically create the ```channel-artifacts``` directory.
Do it manually.
```bash
$ mkdir channel-artifacts
```

#### Genesis block:
```bash
$ ../bin/configtxgen -profile OrdererGenesis -outputBlock ./channel-artifacts/genesis.block
```

Warnings can be ignored at this stage as we do not have any policy and chaincode deployed.

### Channel Configuration


```bash
../bin/configtxgen -profile votingchannel -outputCreateChannelTx ./channel-artifacts/channel.tx -channelID votingchannel
```

### Anchor Peers Config

We have to run the command for each anchor peer.

```bash
../bin/configtxgen -profile votingchannel -outputAnchorPeersUpdate ./channel-artifacts/station1Anchor.tx -channelID votingchannel -asOrg station1MSP

../bin/configtxgen -profile votingchannel -outputAnchorPeersUpdate ./channel-artifacts/station2Anchor.tx -channelID votingchannel -asOrg station2MSP

../bin/configtxgen -profile votingchannel -outputAnchorPeersUpdate ./channel-artifacts/station3Anchor.tx -channelID votingchannel -asOrg station3MSP

../bin/configtxgen -profile votingchannel -outputAnchorPeersUpdate ./channel-artifacts/station4Anchor.tx -channelID votingchannel -asOrg station4MSP

../bin/configtxgen -profile votingchannel -outputAnchorPeersUpdate ./channel-artifacts/GovermentAgencyAnchor.tx -channelID votingchannel -asOrg GovermentAgencyMSP
```

### Docker Compose

```bash
docker-compose -f docker-compose-cli.yaml up -d
```
Run the above script if you have already created a channel and wants to start over 

```bash
docker-compose -f docker-compose-cli.yaml up -d
```

Your should receive something like:

```bash
Status: Downloaded newer image for hyperledger/fabric-tools:latest
Creating peer0.station4.voting.org        ... done
Creating couchdb                          ... done
Creating peer1.station3.voting.org        ... done
Creating peer1.GovermentAgency.voting.org ... done
Creating peer1.station1.voting.org        ... done
Creating peer0.station3.voting.org        ... done
Creating peer0.GovermentAgency.voting.org ... done
Creating orderer.voting.org               ... done
Creating peer0.station2.voting.org        ... done
Creating peer1.station2.voting.org        ... done
Creating peer1.station4.voting.org        ... done
Creating peer0.station1.voting.org        ... done
Creating peer2.GovermentAgency.voting.org ... done
Creating cli                              ... done
```

### Start docker cli:
```bash
docker start cli
```
Enter the cli docker container:
```bash
docker exec -it cli bash
```

### Create channel
The first command that we issue is the peer create channel command. This command targets the orderer (where the channels must be created) and uses the channel.tx and the channel name that is created using the configtxgen tool. As we are in the context of CLI container command line we define CHANNEL_NAME environment variable with our channel name.

```bash
export CHANNEL_NAME=votingchannel

peer channel create -o orderer.voting.org:7050 -c $CHANNEL_NAME -f ./channel-artifacts/channel.tx --tls --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/voting.org/orderers/orderer.voting.org/msp/tlscacerts/tlsca.voting.org-cert.pem
```



