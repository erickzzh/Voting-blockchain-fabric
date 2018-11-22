package main

import (
	"fmt"
	"strconv"
	"testing"

	"github.com/hyperledger/fabric/core/chaincode/shim"
)

const Erick_Zhang_hash = "21927f188e663d70a9d407374a6aa0cba362f86f31089c8c1e15b1c0148ce24a"

/*
* TestInvokeInitVehiclePart simulates an initVehiclePart transaction on the CarDemo chaincode
 */

func Test_CheckInit(t *testing.T) {
	scc := new(ballot)
	stub := shim.NewMockStub("voting", scc)
	res := stub.MockInit("1", [][]byte{})
	if res.Status != shim.OK {
		t.Log("bad status received, expected: 200; received:" + strconv.FormatInt(int64(res.Status), 10))
		t.Log("response: " + string(res.Message))
		t.FailNow()
	}
}

func Test_Invoke_initBallot(t *testing.T) {
	scc := new(ballot)
	stub := shim.NewMockStub("voting", scc)
	res := stub.MockInvoke("1", [][]byte{[]byte("initBallot"), []byte("Erick"), []byte("Zhang")})
	if res.Status != shim.OK {
		t.Log("bad status received, expected: 200; received:" + strconv.FormatInt(int64(res.Status), 10))
		t.Log("response: " + string(res.Message))
		t.FailNow()
	}
	if res.Payload == nil {
		t.Log("initBallot failed to create a ballot")
		t.FailNow()
	}
	response := res.Payload
	fmt.Println(response)

}

func Test_Invoke_voting(t *testing.T) {
	scc := new(ballot)
	stub := shim.NewMockStub("voting", scc)
	res := stub.MockInvoke("1", [][]byte{[]byte("initBallot"), []byte("Erick"), []byte("Zhang")})
	res = stub.MockInvoke("2", [][]byte{[]byte("vote"), []byte(Erick_Zhang_hash), []byte("YES")})

	if res.Status != shim.OK {
		t.Log("bad status received, expected: 200; received:" + strconv.FormatInt(int64(res.Status), 10))
		t.Log("response: " + string(res.Message))
		t.FailNow()
	}
	if res.Payload == nil {
		t.Log("initBallot failed to create a ballot")
		t.FailNow()
	}
	t.Log(res.Payload)

}
