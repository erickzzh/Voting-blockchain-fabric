package main

import (
	"strconv"
	"testing"

	"github.com/hyperledger/fabric/core/chaincode/shim"
)

/*
* TestInvokeInitVehiclePart simulates an initVehiclePart transaction on the CarDemo cahincode
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

func Test_Invoke(t *testing.T) {
	scc := new(ballot)
	stub := shim.NewMockStub("voting", scc)
	res := stub.MockInvoke("1", [][]byte{[]byte("initBallot"), []byte("erick"), []byte("Zhang")})
	if res.Status != shim.OK {
		t.Log("bad status received, expected: 200; received:" + strconv.FormatInt(int64(res.Status), 10))
		t.Log("response: " + string(res.Message))
		t.FailNow()
	}
	if res.Payload == nil {
		t.Log("initBallot failed to create a ballot")
		t.FailNow()
	}

}
