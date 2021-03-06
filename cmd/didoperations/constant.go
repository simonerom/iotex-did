package didoperations

import (
	"log"
	"math/big"

	"github.com/iotexproject/iotex-DID/util"
	"github.com/iotexproject/iotex-antenna-go/v2/iotex"
	"github.com/iotexproject/iotex-proto/golang/iotexapi"
	"google.golang.org/grpc"

	"github.com/ethereum/go-ethereum/common"
	"github.com/iotexproject/iotex-address/address"
)

const (
	// IoTeXDIDABI defines the ABI of IoTeX DID contract
	IoTeXDIDABI = `[
    {
      "anonymous": false,
      "inputs": [
        {
          "indexed": true,
          "name": "id",
          "type": "string"
        },
        {
          "indexed": false,
          "name": "didString",
          "type": "string"
        }
      ],
      "name": "CreateDID",
      "type": "event"
    },
    {
      "anonymous": false,
      "inputs": [
        {
          "indexed": true,
          "name": "didString",
          "type": "string"
        },
        {
          "indexed": false,
          "name": "hash",
          "type": "bytes32"
        }
      ],
      "name": "UpdateHash",
      "type": "event"
    },
    {
      "anonymous": false,
      "inputs": [
        {
          "indexed": true,
          "name": "didString",
          "type": "string"
        },
        {
          "indexed": false,
          "name": "uri",
          "type": "string"
        }
      ],
      "name": "UpdateURI",
      "type": "event"
    },
    {
      "anonymous": false,
      "inputs": [
        {
          "indexed": true,
          "name": "didString",
          "type": "string"
        }
      ],
      "name": "DeleteDID",
      "type": "event"
    },
    {
      "constant": false,
      "inputs": [
        {
          "name": "id",
          "type": "string"
        },
        {
          "name": "hash",
          "type": "bytes32"
        },
        {
          "name": "uri",
          "type": "string"
        }
      ],
      "name": "createDID",
      "outputs": [],
      "payable": false,
      "stateMutability": "nonpayable",
      "type": "function"
    },
    {
      "constant": false,
      "inputs": [
        {
          "name": "did",
          "type": "string"
        },
        {
          "name": "hash",
          "type": "bytes32"
        }
      ],
      "name": "updateHash",
      "outputs": [],
      "payable": false,
      "stateMutability": "nonpayable",
      "type": "function"
    },
    {
      "constant": false,
      "inputs": [
        {
          "name": "did",
          "type": "string"
        },
        {
          "name": "uri",
          "type": "string"
        }
      ],
      "name": "updateURI",
      "outputs": [],
      "payable": false,
      "stateMutability": "nonpayable",
      "type": "function"
    },
    {
      "constant": false,
      "inputs": [
        {
          "name": "did",
          "type": "string"
        }
      ],
      "name": "deleteDID",
      "outputs": [],
      "payable": false,
      "stateMutability": "nonpayable",
      "type": "function"
    },
    {
      "constant": true,
      "inputs": [
        {
          "name": "did",
          "type": "string"
        }
      ],
      "name": "getHash",
      "outputs": [
        {
          "name": "",
          "type": "bytes32"
        }
      ],
      "payable": false,
      "stateMutability": "view",
      "type": "function"
    },
    {
      "constant": true,
      "inputs": [
        {
          "name": "did",
          "type": "string"
        }
      ],
      "name": "getURI",
      "outputs": [
        {
          "name": "",
          "type": "string"
        }
      ],
      "payable": false,
      "stateMutability": "view",
      "type": "function"
    }
  ]`

	// DeviceDecentralizedIdentifierABI defines the ABI of Device DID
	DeviceDecentralizedIdentifierABI = `[
    {
      "constant": false,
      "inputs": [
        {
          "name": "addrs",
          "type": "address[]"
        }
      ],
      "name": "removeAddressesFromWhitelist",
      "outputs": [
        {
          "name": "success",
          "type": "bool"
        }
      ],
      "payable": false,
      "stateMutability": "nonpayable",
      "type": "function"
    },
    {
      "constant": false,
      "inputs": [
        {
          "name": "addr",
          "type": "address"
        }
      ],
      "name": "removeAddressFromWhitelist",
      "outputs": [
        {
          "name": "success",
          "type": "bool"
        }
      ],
      "payable": false,
      "stateMutability": "nonpayable",
      "type": "function"
    },
    {
      "constant": false,
      "inputs": [
        {
          "name": "addr",
          "type": "address"
        }
      ],
      "name": "addAddressToWhitelist",
      "outputs": [
        {
          "name": "success",
          "type": "bool"
        }
      ],
      "payable": false,
      "stateMutability": "nonpayable",
      "type": "function"
    },
    {
      "constant": true,
      "inputs": [],
      "name": "owner",
      "outputs": [
        {
          "name": "",
          "type": "address"
        }
      ],
      "payable": false,
      "stateMutability": "view",
      "type": "function"
    },
    {
      "constant": true,
      "inputs": [
        {
          "name": "",
          "type": "address"
        }
      ],
      "name": "whitelist",
      "outputs": [
        {
          "name": "",
          "type": "bool"
        }
      ],
      "payable": false,
      "stateMutability": "view",
      "type": "function"
    },
    {
      "constant": true,
      "inputs": [
        {
          "name": "",
          "type": "bytes32"
        }
      ],
      "name": "nameSpaceToSelfManagedAddress",
      "outputs": [
        {
          "name": "",
          "type": "address"
        }
      ],
      "payable": false,
      "stateMutability": "view",
      "type": "function"
    },
    {
      "constant": false,
      "inputs": [
        {
          "name": "addrs",
          "type": "address[]"
        }
      ],
      "name": "addAddressesToWhitelist",
      "outputs": [
        {
          "name": "success",
          "type": "bool"
        }
      ],
      "payable": false,
      "stateMutability": "nonpayable",
      "type": "function"
    },
    {
      "constant": false,
      "inputs": [
        {
          "name": "newOwner",
          "type": "address"
        }
      ],
      "name": "transferOwnership",
      "outputs": [],
      "payable": false,
      "stateMutability": "nonpayable",
      "type": "function"
    },
    {
      "inputs": [],
      "payable": false,
      "stateMutability": "nonpayable",
      "type": "constructor"
    },
    {
      "anonymous": false,
      "inputs": [
        {
          "indexed": true,
          "name": "nameSpace",
          "type": "bytes32"
        },
        {
          "indexed": false,
          "name": "addr",
          "type": "address"
        }
      ],
      "name": "RegisterSelfManagedContract",
      "type": "event"
    },
    {
      "anonymous": false,
      "inputs": [
        {
          "indexed": true,
          "name": "nameSpace",
          "type": "bytes32"
        }
      ],
      "name": "DeregisterSelfManagedContract",
      "type": "event"
    },
    {
      "anonymous": false,
      "inputs": [
        {
          "indexed": true,
          "name": "nameSpace",
          "type": "bytes32"
        },
        {
          "indexed": false,
          "name": "addr",
          "type": "address"
        }
      ],
      "name": "UpdateSelfManagedContract",
      "type": "event"
    },
    {
      "anonymous": false,
      "inputs": [
        {
          "indexed": false,
          "name": "addr",
          "type": "address"
        }
      ],
      "name": "WhitelistedAddressAdded",
      "type": "event"
    },
    {
      "anonymous": false,
      "inputs": [
        {
          "indexed": false,
          "name": "addr",
          "type": "address"
        }
      ],
      "name": "WhitelistedAddressRemoved",
      "type": "event"
    },
    {
      "anonymous": false,
      "inputs": [
        {
          "indexed": true,
          "name": "previousOwner",
          "type": "address"
        },
        {
          "indexed": true,
          "name": "newOwner",
          "type": "address"
        }
      ],
      "name": "OwnershipTransferred",
      "type": "event"
    },
    {
      "constant": false,
      "inputs": [
        {
          "name": "nameSpace",
          "type": "bytes32"
        },
        {
          "name": "addr",
          "type": "address"
        }
      ],
      "name": "registerSelfManagedContract",
      "outputs": [],
      "payable": false,
      "stateMutability": "nonpayable",
      "type": "function"
    },
    {
      "constant": false,
      "inputs": [
        {
          "name": "nameSpace",
          "type": "bytes32"
        }
      ],
      "name": "deregisterSelfManagedContract",
      "outputs": [],
      "payable": false,
      "stateMutability": "nonpayable",
      "type": "function"
    },
    {
      "constant": false,
      "inputs": [
        {
          "name": "nameSpace",
          "type": "bytes32"
        },
        {
          "name": "addr",
          "type": "address"
        }
      ],
      "name": "updateSelfManagedContractAddress",
      "outputs": [],
      "payable": false,
      "stateMutability": "nonpayable",
      "type": "function"
    },
    {
      "constant": true,
      "inputs": [
        {
          "name": "nameSpace",
          "type": "bytes32"
        },
        {
          "name": "did",
          "type": "string"
        }
      ],
      "name": "getHash",
      "outputs": [
        {
          "name": "",
          "type": "bytes32"
        }
      ],
      "payable": false,
      "stateMutability": "view",
      "type": "function"
    },
    {
      "constant": true,
      "inputs": [
        {
          "name": "nameSpace",
          "type": "bytes32"
        },
        {
          "name": "did",
          "type": "string"
        }
      ],
      "name": "getURI",
      "outputs": [
        {
          "name": "",
          "type": "string"
        }
      ],
      "payable": false,
      "stateMutability": "view",
      "type": "function"
    }
  ]`

	MockDeviceDIDABI = `[
    {
      "constant": false,
      "inputs": [
        {
          "name": "addrs",
          "type": "address[]"
        }
      ],
      "name": "removeAddressesFromWhitelist",
      "outputs": [
        {
          "name": "success",
          "type": "bool"
        }
      ],
      "payable": false,
      "stateMutability": "nonpayable",
      "type": "function"
    },
    {
      "constant": false,
      "inputs": [
        {
          "name": "addr",
          "type": "address"
        }
      ],
      "name": "removeAddressFromWhitelist",
      "outputs": [
        {
          "name": "success",
          "type": "bool"
        }
      ],
      "payable": false,
      "stateMutability": "nonpayable",
      "type": "function"
    },
    {
      "constant": true,
      "inputs": [],
      "name": "cloudServiceAddr",
      "outputs": [
        {
          "name": "",
          "type": "address"
        }
      ],
      "payable": false,
      "stateMutability": "view",
      "type": "function"
    },
    {
      "constant": false,
      "inputs": [
        {
          "name": "addr",
          "type": "address"
        }
      ],
      "name": "addAddressToWhitelist",
      "outputs": [
        {
          "name": "success",
          "type": "bool"
        }
      ],
      "payable": false,
      "stateMutability": "nonpayable",
      "type": "function"
    },
    {
      "constant": true,
      "inputs": [],
      "name": "owner",
      "outputs": [
        {
          "name": "",
          "type": "address"
        }
      ],
      "payable": false,
      "stateMutability": "view",
      "type": "function"
    },
    {
      "constant": true,
      "inputs": [
        {
          "name": "",
          "type": "address"
        }
      ],
      "name": "whitelist",
      "outputs": [
        {
          "name": "",
          "type": "bool"
        }
      ],
      "payable": false,
      "stateMutability": "view",
      "type": "function"
    },
    {
      "constant": false,
      "inputs": [
        {
          "name": "addrs",
          "type": "address[]"
        }
      ],
      "name": "addAddressesToWhitelist",
      "outputs": [
        {
          "name": "success",
          "type": "bool"
        }
      ],
      "payable": false,
      "stateMutability": "nonpayable",
      "type": "function"
    },
    {
      "constant": false,
      "inputs": [
        {
          "name": "newOwner",
          "type": "address"
        }
      ],
      "name": "transferOwnership",
      "outputs": [],
      "payable": false,
      "stateMutability": "nonpayable",
      "type": "function"
    },
    {
      "inputs": [
        {
          "name": "_cloudServiceAddr",
          "type": "address"
        }
      ],
      "payable": false,
      "stateMutability": "nonpayable",
      "type": "constructor"
    },
    {
      "anonymous": false,
      "inputs": [
        {
          "indexed": true,
          "name": "owner",
          "type": "address"
        },
        {
          "indexed": true,
          "name": "uuid",
          "type": "string"
        },
        {
          "indexed": false,
          "name": "didString",
          "type": "string"
        }
      ],
      "name": "CreateDID",
      "type": "event"
    },
    {
      "anonymous": false,
      "inputs": [
        {
          "indexed": true,
          "name": "didString",
          "type": "string"
        },
        {
          "indexed": false,
          "name": "hash",
          "type": "bytes32"
        }
      ],
      "name": "UpdateHash",
      "type": "event"
    },
    {
      "anonymous": false,
      "inputs": [
        {
          "indexed": true,
          "name": "didString",
          "type": "string"
        },
        {
          "indexed": false,
          "name": "uri",
          "type": "string"
        }
      ],
      "name": "UpdateURI",
      "type": "event"
    },
    {
      "anonymous": false,
      "inputs": [
        {
          "indexed": true,
          "name": "didString",
          "type": "string"
        }
      ],
      "name": "DeleteDID",
      "type": "event"
    },
    {
      "anonymous": false,
      "inputs": [
        {
          "indexed": false,
          "name": "addr",
          "type": "address"
        }
      ],
      "name": "WhitelistedAddressAdded",
      "type": "event"
    },
    {
      "anonymous": false,
      "inputs": [
        {
          "indexed": false,
          "name": "addr",
          "type": "address"
        }
      ],
      "name": "WhitelistedAddressRemoved",
      "type": "event"
    },
    {
      "anonymous": false,
      "inputs": [
        {
          "indexed": true,
          "name": "previousOwner",
          "type": "address"
        },
        {
          "indexed": true,
          "name": "newOwner",
          "type": "address"
        }
      ],
      "name": "OwnershipTransferred",
      "type": "event"
    },
    {
      "constant": false,
      "inputs": [
        {
          "name": "uuid",
          "type": "string"
        },
        {
          "name": "proof",
          "type": "bytes"
        },
        {
          "name": "hash",
          "type": "bytes32"
        },
        {
          "name": "uri",
          "type": "string"
        }
      ],
      "name": "createDID",
      "outputs": [],
      "payable": false,
      "stateMutability": "nonpayable",
      "type": "function"
    },
    {
      "constant": false,
      "inputs": [
        {
          "name": "uuid",
          "type": "string"
        },
        {
          "name": "proof",
          "type": "bytes"
        },
        {
          "name": "hash",
          "type": "bytes32"
        }
      ],
      "name": "updateHash",
      "outputs": [],
      "payable": false,
      "stateMutability": "nonpayable",
      "type": "function"
    },
    {
      "constant": false,
      "inputs": [
        {
          "name": "uuid",
          "type": "string"
        },
        {
          "name": "proof",
          "type": "bytes"
        },
        {
          "name": "uri",
          "type": "string"
        }
      ],
      "name": "updateURI",
      "outputs": [],
      "payable": false,
      "stateMutability": "nonpayable",
      "type": "function"
    },
    {
      "constant": false,
      "inputs": [
        {
          "name": "uuid",
          "type": "string"
        },
        {
          "name": "proof",
          "type": "bytes"
        }
      ],
      "name": "deleteDID",
      "outputs": [],
      "payable": false,
      "stateMutability": "nonpayable",
      "type": "function"
    },
    {
      "constant": false,
      "inputs": [
        {
          "name": "_cloudServiceAddr",
          "type": "address"
        }
      ],
      "name": "setCloudServiceAddr",
      "outputs": [],
      "payable": false,
      "stateMutability": "nonpayable",
      "type": "function"
    },
    {
      "constant": true,
      "inputs": [
        {
          "name": "did",
          "type": "string"
        }
      ],
      "name": "getHash",
      "outputs": [
        {
          "name": "",
          "type": "bytes32"
        }
      ],
      "payable": false,
      "stateMutability": "view",
      "type": "function"
    },
    {
      "constant": true,
      "inputs": [
        {
          "name": "did",
          "type": "string"
        }
      ],
      "name": "getURI",
      "outputs": [
        {
          "name": "",
          "type": "string"
        }
      ],
      "payable": false,
      "stateMutability": "view",
      "type": "function"
    }
  ]`

	ControllerContractAddress         = "io15kftve6k3nrwccwsahq205gckavzn8mkuf2ws3"
	DeviceOperatorContractAddress = "io1saftaaamturktykv27ftj32ckj86sqly0tgwjj"
	MockDeviceContractAddress = "io1zegt9x0kkt6v60d9c87aq96q3h63qv9wdjwkhe"
	ControllerDIDPrefix               = "did:io:"
	MockDeviceDIDPrefix = "did:io:mock:"
	IOEndpoint              = "api.testnet.iotex.one:443"
)

var (
	GasPrice  = big.NewInt(1e12)
	GasLimit  = uint64(3000000)
	_password string
	_uuid string
	_signature string
)

// getAuthedClient gets authed client using given account's credentials
func getAuthedClient(conn *grpc.ClientConn, pwd string) (iotex.AuthedClient, error) {
	account, err := util.GetVaultAccount(pwd)
	if err != nil {
		log.Fatal("failed to get account", err)
	}
	return iotex.NewAuthedClient(iotexapi.NewAPIServiceClient(conn), account), nil
}

// ioAddrToEvmAddr converts IoTeX address into evm address
func ioAddrToEvmAddr(ioAddr string) (common.Address, error) {
	address, err := address.FromString(ioAddr)
	if err != nil {
		return common.Address{}, err
	}
	return common.BytesToAddress(address.Bytes()), nil
}

// stringToBytes32 converts string to bytes32
func stringToBytes32(str string) [32]byte {
	var name [32]byte
	copy(name[:], str)
	return name
}
