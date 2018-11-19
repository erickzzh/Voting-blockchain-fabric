package main

import (
	"crypto/sha256"
	"encoding/hex"
	"fmt"

	"github.com/hyperledger/fabric/core/chaincode/shim"
	"github.com/hyperledger/fabric/protos/peer"
)

type ballot struct {
	firstName string
	lastName  string
	ballotID  string
	decision  string
}

// Init is called during chaincode instantiation to initialize any data.
func (t *ballot) Init(stub shim.ChaincodeStubInterface) peer.Response {
	return shim.Success(nil)
}

func (t *ballot) Invoke(stub shim.ChaincodeStubInterface) peer.Response {
	function, args := stub.GetFunctionAndParameters()
	fmt.Println("invoke is running " + function)

	switch function {
	case "initBallot":
		//create a new ballot
		return t.initBallot(stub, args)
	//TODO: Need to create more cases

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
	hash.Write([]byte(personFirstName + personLastName))
	ballotID := hex.EncodeToString(hash.Sum(nil))
	voteInit := ""
	//fmt.Printf("%x", h.Sum(nil)) prints the sha256 string

	//TODO: should then check if the ballotID is already in the system. We won't check this case as for now
	// 1. write this data to the ledger
	// 2. implement an index and then query all the ballotID to see if it exist
	//FIXME: need to have a proper return function

}

func main() {
	if err := shim.Start(new(ballot)); err != nil {
		fmt.Printf("Error starting SimpleAsset chaincode: %s", err)
	}
}
