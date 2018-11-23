package main

import (
	"crypto/sha256"
	"encoding/hex"
	"encoding/json"
	"fmt"

	"github.com/hyperledger/fabric/core/chaincode/shim"
	"github.com/hyperledger/fabric/protos/peer"
)

//VERY IMPORTANT: The first letter needs to be captilized
type ballot struct {
	FirstName string
	LastName  string
	BallotID  string
	Decision  string
}

// Init is called during chaincode instantiation to initialize any data.
func (t *ballot) Init(stub shim.ChaincodeStubInterface) peer.Response {
	return shim.Success(nil)
}

func (t *ballot) Invoke(stub shim.ChaincodeStubInterface) peer.Response {
	function, args := stub.GetFunctionAndParameters()
	fmt.Println("invoke is running " + function)

	// Handle different functions
	switch function {
	//TODO: Need to create more cases
	case "initBallot":
		//create a new ballot
		return t.initBallot(stub, args)
	case "vote":
		//voting action
		return t.vote(stub, args)

	default:
		//error
		fmt.Println("invoke did not find func: " + function)
		return shim.Error("Received unknown function invocation")
	}
}

func (t *ballot) initBallot(stub shim.ChaincodeStubInterface, args []string) peer.Response {
	//  0-firstName  1-lastName
	// "Erick",  "Zhang"

	if len(args) != 2 {
		return shim.Error("Incorrect number of arguments. Expecting 2")
	}

	// ==== Input sanitation ====
	fmt.Println("- start init ballot")

	if len(args[0]) == 0 {
		return shim.Error("1st argument must be a non-empty string")
	}
	if len(args[1]) == 0 {
		return shim.Error("2nd argument must be a non-empty string")
	}

	personFirstName := args[0]
	personLastName := args[1]
	hash := sha256.New()
	hash.Write([]byte(personFirstName + personLastName)) // ballotID is created based on the person's name
	ballotID := hex.EncodeToString(hash.Sum(nil))
	voteInit := "VOTE INIT"

	//fmt.Printf("%x", h.Sum(nil)) prints the sha256 string

	// ==== Create ballot object and marshal to JSON ====
	Ballot := ballot{personFirstName, personLastName, ballotID, voteInit}
	ballotJSONByte, err := json.Marshal(Ballot)
	if err != nil {
		return shim.Error(err.Error())
	}

	//ballotID becomes the key for this tuple
	err = stub.PutState(string(ballotID), ballotJSONByte)
	if err != nil {
		return shim.Error(err.Error())
	}
	return shim.Success([]byte(ballotID))

	//TODO: should then check if the ballotID is already in the system. We won't check this case as for now
	// 1. write this data to the ledger
	// 2. implement an index and then query all the ballotID to see if it exist
	//FIXME: need to have a proper return function

}

func (t *ballot) vote(stub shim.ChaincodeStubInterface, args []string) peer.Response {

	//  0- ballID, 1-Decision
	// "This is going to be passed from the client side",  "YES/NO"

	if len(args) != 2 {
		return shim.Error("Incorrect number of arguments. Expecting 2")
	}
	ballotID := args[0]
	decision := args[1]

	// ==== Create a voting and marshal to JSON ====
	//first we need to get the voter personal info based on the ballotID
	ballotAsByte, err := stub.GetState(ballotID)
	if err != nil {
		return shim.Error(err.Error())
	}

	Ballot := ballot{}

	//umarshal the data to a new ballot struct
	json.Unmarshal(ballotAsByte, &Ballot)
	if Ballot.BallotID == "" {
		return shim.Error(err.Error())
	}
	Ballot.Decision = decision

	//create a new id to be place within the db
	hash := sha256.New()
	hash.Write([]byte(Ballot.FirstName + Ballot.LastName + decision)) // ballotID is created based on the person's name
	newBallotID := hex.EncodeToString(hash.Sum(nil))

	//marshal ballot into byte
	ballotAsByte, err = json.Marshal(Ballot)
	if err != nil {
		return shim.Error(err.Error())
	}
	err = stub.PutState(newBallotID, ballotAsByte)

	if err != nil {
		return shim.Error(err.Error())
	}
	return shim.Success(ballotAsByte)

}

func main() {
	if err := shim.Start(new(ballot)); err != nil {
		fmt.Printf("Error starting SimpleAsset chaincode: %s", err)
	}
}
