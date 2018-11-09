echo "Deleting old volumes and config files"
docker-compose -f docker-compose-cli.yaml -f docker-compose-couch.yaml down --volumes

echo "Creating new volumes and config files"
docker-compose -f docker-compose-cli.yaml -f docker-compose-couch.yaml up -d

sleep 15s

echo "Creating Channel"
docker exec -ti cli sh -c "peer channel create -o orderer.voting.org:7050 -c votingchannel -f ./channel-artifacts/channel.tx --tls --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/voting.org/orderers/orderer.voting.org/msp/tlscacerts/tlsca.voting.org-cert.pem"

echo "Adding peers to the channel"

docker exec -ti cli sh -c "CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/station1.voting.org/users/Admin@station1.voting.org/msp CORE_PEER_ADDRESS=peer0.station1.voting.org:7051 CORE_PEER_LOCALMSPID="station1MSP" CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/station1.voting.org/peers/peer0.station1.voting.org/tls/ca.crt peer channel join -b votingchannel.block"
sleep .5s
docker exec -ti cli sh -c "CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/station1.voting.org/users/Admin@station1.voting.org/msp CORE_PEER_ADDRESS=peer1.station1.voting.org:7051 CORE_PEER_LOCALMSPID="station1MSP" CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/station1.voting.org/peers/peer1.station1.voting.org/tls/ca.crt peer channel join -b votingchannel.block"
sleep .5s
docker exec -ti cli sh -c "CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/station2.voting.org/users/Admin@station2.voting.org/msp CORE_PEER_ADDRESS=peer0.station2.voting.org:7051 CORE_PEER_LOCALMSPID="station2MSP" CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/station2.voting.org/peers/peer0.station2.voting.org/tls/ca.crt peer channel join -b votingchannel.block"
sleep .5s
docker exec -ti cli sh -c "CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/station2.voting.org/users/Admin@station2.voting.org/msp CORE_PEER_ADDRESS=peer1.station2.voting.org:7051 CORE_PEER_LOCALMSPID="station2MSP" CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/station2.voting.org/peers/peer1.station2.voting.org/tls/ca.crt peer channel join -b votingchannel.block"
sleep .5s
docker exec -ti cli sh -c "CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/station3.voting.org/users/Admin@station3.voting.org/msp CORE_PEER_ADDRESS=peer0.station3.voting.org:7051 CORE_PEER_LOCALMSPID="station3MSP" CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/station3.voting.org/peers/peer0.station3.voting.org/tls/ca.crt peer channel join -b votingchannel.block"
sleep .5s
docker exec -ti cli sh -c "CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/station3.voting.org/users/Admin@station3.voting.org/msp CORE_PEER_ADDRESS=peer1.station3.voting.org:7051 CORE_PEER_LOCALMSPID="station3MSP" CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/station3.voting.org/peers/peer1.station3.voting.org/tls/ca.crt peer channel join -b votingchannel.block"
sleep .5s
docker exec -ti cli sh -c "CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/station4.voting.org/users/Admin@station4.voting.org/msp CORE_PEER_ADDRESS=peer0.station4.voting.org:7051 CORE_PEER_LOCALMSPID="station4MSP" CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/station4.voting.org/peers/peer0.station4.voting.org/tls/ca.crt peer channel join -b votingchannel.block"
sleep .5s
docker exec -ti cli sh -c "CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/station4.voting.org/users/Admin@station4.voting.org/msp CORE_PEER_ADDRESS=peer1.station4.voting.org:7051 CORE_PEER_LOCALMSPID="station4MSP" CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/station4.voting.org/peers/peer1.station4.voting.org/tls/ca.crt peer channel join -b votingchannel.block"
sleep .5s
docker exec -ti cli sh -c "CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/GovermentAgency.voting.org/users/Admin@GovermentAgency.voting.org/msp CORE_PEER_ADDRESS=peer0.GovermentAgency.voting.org:7051 CORE_PEER_LOCALMSPID="GovermentAgencyMSP" CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/GovermentAgency.voting.org/peers/peer0.GovermentAgency.voting.org/tls/ca.crt peer channel join -b votingchannel.block"
sleep .5s
docker exec -ti cli sh -c "CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/GovermentAgency.voting.org/users/Admin@GovermentAgency.voting.org/msp CORE_PEER_ADDRESS=peer1.GovermentAgency.voting.org:7051 CORE_PEER_LOCALMSPID="GovermentAgencyMSP" CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/GovermentAgency.voting.org/peers/peer1.GovermentAgency.voting.org/tls/ca.crt peer channel join -b votingchannel.block"


echo "Update anchor peers"

docker exec -ti cli sh -c "CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/station1.voting.org/users/Admin@station1.voting.org/msp CORE_PEER_ADDRESS=peer0.station1.voting.org:7051 CORE_PEER_LOCALMSPID="station1MSP" CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/station1.voting.org/peers/peer0.station1.voting.org/tls/ca.crt peer channel update -o orderer.voting.org:7050 -c votingchannel -f ./channel-artifacts/station1Anchor.tx --tls --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/voting.org/orderers/orderer.voting.org/msp/tlscacerts/tlsca.voting.org-cert.pem"
sleep 3s 
docker exec -ti cli sh -c "CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/station2.voting.org/users/Admin@station2.voting.org/msp CORE_PEER_ADDRESS=peer0.station2.voting.org:7051 CORE_PEER_LOCALMSPID="station2MSP" CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/station2.voting.org/peers/peer0.station2.voting.org/tls/ca.crt peer channel update -o orderer.voting.org:7050 -c votingchannel -f ./channel-artifacts/station2Anchor.tx --tls --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/voting.org/orderers/orderer.voting.org/msp/tlscacerts/tlsca.voting.org-cert.pem"
sleep 3s 
docker exec -ti cli sh -c "CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/station3.voting.org/users/Admin@station3.voting.org/msp CORE_PEER_ADDRESS=peer0.station3.voting.org:7051 CORE_PEER_LOCALMSPID="station3MSP" CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/station3.voting.org/peers/peer0.station3.voting.org/tls/ca.crt peer channel update -o orderer.voting.org:7050 -c votingchannel -f ./channel-artifacts/station3Anchor.tx --tls --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/voting.org/orderers/orderer.voting.org/msp/tlscacerts/tlsca.voting.org-cert.pem"
sleep 3s 
docker exec -ti cli sh -c "CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/station4.voting.org/users/Admin@station4.voting.org/msp CORE_PEER_ADDRESS=peer0.station4.voting.org:7051 CORE_PEER_LOCALMSPID="station4MSP" CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/station4.voting.org/peers/peer0.station4.voting.org/tls/ca.crt peer channel update -o orderer.voting.org:7050 -c votingchannel -f ./channel-artifacts/station4Anchor.tx --tls --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/voting.org/orderers/orderer.voting.org/msp/tlscacerts/tlsca.voting.org-cert.pem"
sleep 3s 
docker exec -ti cli sh -c "CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/GovermentAgency.voting.org/users/Admin@GovermentAgency.voting.org/msp CORE_PEER_ADDRESS=peer0.GovermentAgency.voting.org:7051 CORE_PEER_LOCALMSPID="GovermentAgencyMSP" CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/GovermentAgency.voting.org/peers/peer0.GovermentAgency.voting.org/tls/ca.crt peer channel update -o orderer.voting.org:7050 -c votingchannel -f ./channel-artifacts/GovermentAgencyAnchor.tx --tls --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/voting.org/orderers/orderer.voting.org/msp/tlscacerts/tlsca.voting.org-cert.pem"
sleep 3s 


echo "Here is a list of all the docker containers that are running"
docker ps