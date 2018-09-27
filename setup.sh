ARTIFACT_DIR="./channel-artifacts"
CRYPTO_DIR="./crypto-config"

if [ ! -d "$ARTIFACT_DIR" ]; then
    echo 'Making directory "channel-artifacts"'
    mkdir channel-artifacts
else
    echo 'Removing contents of directory "channel-artifacts"'
    # remove all contents of $DIR
    rm -rf $ARTIFACT_DIR/*
fi


if [ -d "$CRYPTO_DIR" ]; then
    echo 'Removing contents of directory "crypto-config"'
    rm -rf $CRYPTO_DIR
fi
echo "Creating credentials for all participants"
../bin/cryptogen generate --config crypto-config.yaml --output=crypto-config
echo "Creating the Genesis Block"
../bin/configtxgen -profile OrdererGenesis -outputBlock ./channel-artifacts/genesis.block
echo "Creating Channel Configuration"
../bin/configtxgen -profile votingchannel -outputCreateChannelTx ./channel-artifacts/channel.tx -channelID votingchannel
echo "Setting up the anchor peer for each org"
../bin/configtxgen -profile votingchannel -outputAnchorPeersUpdate ./channel-artifacts/station1Anchor.tx -channelID votingchannel -asOrg station1MSP
../bin/configtxgen -profile votingchannel -outputAnchorPeersUpdate ./channel-artifacts/station2Anchor.tx -channelID votingchannel -asOrg station2MSP
../bin/configtxgen -profile votingchannel -outputAnchorPeersUpdate ./channel-artifacts/station3Anchor.tx -channelID votingchannel -asOrg station3MSP
../bin/configtxgen -profile votingchannel -outputAnchorPeersUpdate ./channel-artifacts/station4Anchor.tx -channelID votingchannel -asOrg station4MSP
../bin/configtxgen -profile votingchannel -outputAnchorPeersUpdate ./channel-artifacts/GovermentAgencyAnchor.tx -channelID votingchannel -asOrg GovermentAgencyMSP

