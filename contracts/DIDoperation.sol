pragma solidity ^0.4.24;

contract AbstractURI{
    function generate(bytes meta) public returns(string);
}

contract DecentralizedIdentifier {
    struct DID {
        bool exist;
        bytes meta;
        uint16 userType;
        uint8 status;
    }
    mapping(string => DID) dids; // 1,2,3 represent 3 status
    mapping(string => string) hashToDID;
    mapping(uint16 => AbstractURI) generateMethods;
    constructor() public {
    }
    function createDID(string inputHash, uint16 userType, bytes meta) public payable returns(string resultDID) {
        bytes32 didString = keccak256(abi.encodePacked(inputHash));
        resultDID = string(abi.encodePacked("did:iotex:",getHexString(didString)));
        require(!dids[resultDID].exist, "did already existed");
        hashToDID[inputHash] = resultDID;
        dids[resultDID] = DID(true, meta,userType,0);
    }
    function getDID(string inputHash) public returns(string did)
    {
        string memory result = hashToDID[inputHash];
        require(dids[result].exist, "did not exist");
        did = result;
    }
    function addType(uint16 userType, address addr) public returns (bool success)
    {
        AbstractURI abURI = AbstractURI(addr);
        generateMethods[userType] = abURI;
        success = true;
    }
    function getURI(string didString) public returns(string uri){
        DID storage did = dids[didString];
        require(did.exist, "");
        uri = generateMethods[did.userType].generate(did.meta);
    }
    function getHexString(bytes32 value) public pure returns (string) {
        bytes memory result = new bytes(64);
        string memory characterString = "0123456789abcdef";
        bytes memory characters = bytes(characterString);
        for (uint8 i = 0; i < 32; i++) {
            result[i * 2] = characters[uint256((value[i] & 0xF0) >> 4)];
            result[i * 2 + 1] = characters[uint256(value[i] & 0xF)];
        }
        return string(result);
    }


}


/*
{
	"linkReferences": {},
	"object": "608060405234801561001057600080fd5b506111e4806100206000396000f30060806040526004361061006d576000357c0100000000000000000000000000000000000000000000000000000000900463ffffffff1680633907835014610072578063619bf3fa1461011c57806393ff5d3e14610245578063de77851a14610327578063e078389814610390575b600080fd5b34801561007e57600080fd5b506100a16004803603810190808035600019169060200190929190505050610472565b6040518080602001828103825283818151815260200191508051906020019080838360005b838110156100e15780820151818401526020810190506100c6565b50505050905090810190601f16801561010e5780820380516001836020036101000a031916815260200191505b509250505060405180910390f35b6101ca600480360381019080803590602001908201803590602001908080601f0160208091040260200160405190810160405280939291908181526020018383808284378201915050505050509192919290803561ffff169060200190929190803590602001908201803590602001908080601f0160208091040260200160405190810160405280939291908181526020018383808284378201915050505050509192919290505050610772565b6040518080602001828103825283818151815260200191508051906020019080838360005b8381101561020a5780820151818401526020810190506101ef565b50505050905090810190601f1680156102375780820380516001836020036101000a031916815260200191505b509250505060405180910390f35b34801561025157600080fd5b506102ac600480360381019080803590602001908201803590602001908080601f0160208091040260200160405190810160405280939291908181526020018383808284378201915050505050509192919290505050610b7b565b6040518080602001828103825283818151815260200191508051906020019080838360005b838110156102ec5780820151818401526020810190506102d1565b50505050905090810190601f1680156103195780820380516001836020036101000a031916815260200191505b509250505060405180910390f35b34801561033357600080fd5b50610376600480360381019080803561ffff169060200190929190803573ffffffffffffffffffffffffffffffffffffffff169060200190929190505050610e26565b604051808215151515815260200191505060405180910390f35b34801561039c57600080fd5b506103f7600480360381019080803590602001908201803590602001908080601f0160208091040260200160405190810160405280939291908181526020018383808284378201915050505050509192919290505050610e91565b6040518080602001828103825283818151815260200191508051906020019080838360005b8381101561043757808201518184015260208101905061041c565b50505050905090810190601f1680156104645780820380516001836020036101000a031916815260200191505b509250505060405180910390f35b6060806060806000604080519080825280601f01601f1916602001820160405280156104ad5781602001602082028038833980820191505090505b5093506040805190810160405280601081526020017f30313233343536373839616263646566000000000000000000000000000000008152509250829150600090505b60208160ff1610156107665781600460f07f010000000000000000000000000000000000000000000000000000000000000002888460ff1660208110151561053457fe5b1a7f010000000000000000000000000000000000000000000000000000000000000002167effffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff19169060020a90047f010000000000000000000000000000000000000000000000000000000000000090048151811015156105af57fe5b9060200101517f010000000000000000000000000000000000000000000000000000000000000090047f010000000000000000000000000000000000000000000000000000000000000002846002830260ff1681518110151561060e57fe5b9060200101907effffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff1916908160001a90535081600f7f010000000000000000000000000000000000000000000000000000000000000002878360ff1660208110151561067457fe5b1a7f010000000000000000000000000000000000000000000000000000000000000002167f010000000000000000000000000000000000000000000000000000000000000090048151811015156106c757fe5b9060200101517f010000000000000000000000000000000000000000000000000000000000000090047f010000000000000000000000000000000000000000000000000000000000000002846001600284020160ff1681518110151561072957fe5b9060200101907effffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff1916908160001a90535080806001019150506104f0565b83945050505050919050565b60606000846040516020018082805190602001908083835b6020831015156107af578051825260208201915060208101905060208303925061078a565b6001836020036101000a0380198251168184511680821785525050505050509050019150506040516020818303038152906040526040518082805190602001908083835b60208310151561081857805182526020820191506020810190506020830392506107f3565b6001836020036101000a0380198251168184511680821785525050505050509050019150506040518091039020905061085081610472565b60405160200180807f6469643a696f7465783a00000000000000000000000000000000000000000000815250600a0182805190602001908083835b6020831015156108b0578051825260208201915060208101905060208303925061088b565b6001836020036101000a03801982511681845116808217855250505050505090500191505060405160208183030381529060405291506000826040518082805190602001908083835b60208310151561091e57805182526020820191506020810190506020830392506108f9565b6001836020036101000a038019825116818451168082178552505050505050905001915050908152602001604051809103902060000160009054906101000a900460ff161515156109d7576040517f08c379a00000000000000000000000000000000000000000000000000000000081526004018080602001828103825260138152602001807f64696420616c726561647920657869737465640000000000000000000000000081525060200191505060405180910390fd5b816001866040518082805190602001908083835b602083101515610a1057805182526020820191506020810190506020830392506109eb565b6001836020036101000a03801982511681845116808217855250505050505090500191505090815260200160405180910390209080519060200190610a56929190611093565b506080604051908101604052806001151581526020018481526020018561ffff168152602001600060ff168152506000836040518082805190602001908083835b602083101515610abc5780518252602082019150602081019050602083039250610a97565b6001836020036101000a038019825116818451168082178552505050505050905001915050908152602001604051809103902060008201518160000160006101000a81548160ff0219169083151502179055506020820151816001019080519060200190610b2b929190611113565b5060408201518160020160006101000a81548161ffff021916908361ffff16021790555060608201518160020160026101000a81548160ff021916908360ff160217905550905050509392505050565b6060600080836040518082805190602001908083835b602083101515610bb65780518252602082019150602081019050602083039250610b91565b6001836020036101000a038019825116818451168082178552505050505050905001915050908152602001604051809103902090508060000160009054906101000a900460ff161515610c4c576040517f08c379a0000000000000000000000000000000000000000000000000000000008152600401808060200182810382526000815260200160200191505060405180910390fd5b600260008260020160009054906101000a900461ffff1661ffff1661ffff16815260200190815260200160002060009054906101000a900473ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff16636450a322826001016040518263ffffffff167c01000000000000000000000000000000000000000000000000000000000281526004018080602001828103825283818154600181600116156101000203166002900481526020019150805460018160011615610100020316600290048015610d6d5780601f10610d4257610100808354040283529160200191610d6d565b820191906000526020600020905b815481529060010190602001808311610d5057829003601f168201915b505092505050600060405180830381600087803b158015610d8d57600080fd5b505af1158015610da1573d6000803e3d6000fd5b505050506040513d6000823e3d601f19601f820116820180604052506020811015610dcb57600080fd5b810190808051640100000000811115610de357600080fd5b82810190506020810184811115610df957600080fd5b8151856001820283011164010000000082111715610e1657600080fd5b5050929190505050915050919050565b60008082905080600260008661ffff1661ffff16815260200190815260200160002060006101000a81548173ffffffffffffffffffffffffffffffffffffffff021916908373ffffffffffffffffffffffffffffffffffffffff160217905550600191505092915050565b6060806001836040518082805190602001908083835b602083101515610ecc5780518252602082019150602081019050602083039250610ea7565b6001836020036101000a03801982511681845116808217855250505050505090500191505090815260200160405180910390208054600181600116156101000203166002900480601f016020809104026020016040519081016040528092919081815260200182805460018160011615610100020316600290048015610f935780601f10610f6857610100808354040283529160200191610f93565b820191906000526020600020905b815481529060010190602001808311610f7657829003601f168201915b505050505090506000816040518082805190602001908083835b602083101515610fd25780518252602082019150602081019050602083039250610fad565b6001836020036101000a038019825116818451168082178552505050505050905001915050908152602001604051809103902060000160009054906101000a900460ff16151561108a576040517f08c379a000000000000000000000000000000000000000000000000000000000815260040180806020018281038252600d8152602001807f646964206e6f742065786973740000000000000000000000000000000000000081525060200191505060405180910390fd5b80915050919050565b828054600181600116156101000203166002900490600052602060002090601f016020900481019282601f106110d457805160ff1916838001178555611102565b82800160010185558215611102579182015b828111156111015782518255916020019190600101906110e6565b5b50905061110f9190611193565b5090565b828054600181600116156101000203166002900490600052602060002090601f016020900481019282601f1061115457805160ff1916838001178555611182565b82800160010185558215611182579182015b82811115611181578251825591602001919060010190611166565b5b50905061118f9190611193565b5090565b6111b591905b808211156111b1576000816000905550600101611199565b5090565b905600a165627a7a72305820bb2d49abfbd0b8f4c356ab319d4bcef6ae59ae6c16581a48a74e292d7a494a810029",
	"opcodes": "PUSH1 0x80 PUSH1 0x40 MSTORE CALLVALUE DUP1 ISZERO PUSH2 0x10 JUMPI PUSH1 0x0 DUP1 REVERT JUMPDEST POP PUSH2 0x11E4 DUP1 PUSH2 0x20 PUSH1 0x0 CODECOPY PUSH1 0x0 RETURN STOP PUSH1 0x80 PUSH1 0x40 MSTORE PUSH1 0x4 CALLDATASIZE LT PUSH2 0x6D JUMPI PUSH1 0x0 CALLDATALOAD PUSH29 0x100000000000000000000000000000000000000000000000000000000 SWAP1 DIV PUSH4 0xFFFFFFFF AND DUP1 PUSH4 0x39078350 EQ PUSH2 0x72 JUMPI DUP1 PUSH4 0x619BF3FA EQ PUSH2 0x11C JUMPI DUP1 PUSH4 0x93FF5D3E EQ PUSH2 0x245 JUMPI DUP1 PUSH4 0xDE77851A EQ PUSH2 0x327 JUMPI DUP1 PUSH4 0xE0783898 EQ PUSH2 0x390 JUMPI JUMPDEST PUSH1 0x0 DUP1 REVERT JUMPDEST CALLVALUE DUP1 ISZERO PUSH2 0x7E JUMPI PUSH1 0x0 DUP1 REVERT JUMPDEST POP PUSH2 0xA1 PUSH1 0x4 DUP1 CALLDATASIZE SUB DUP2 ADD SWAP1 DUP1 DUP1 CALLDATALOAD PUSH1 0x0 NOT AND SWAP1 PUSH1 0x20 ADD SWAP1 SWAP3 SWAP2 SWAP1 POP POP POP PUSH2 0x472 JUMP JUMPDEST PUSH1 0x40 MLOAD DUP1 DUP1 PUSH1 0x20 ADD DUP3 DUP2 SUB DUP3 MSTORE DUP4 DUP2 DUP2 MLOAD DUP2 MSTORE PUSH1 0x20 ADD SWAP2 POP DUP1 MLOAD SWAP1 PUSH1 0x20 ADD SWAP1 DUP1 DUP4 DUP4 PUSH1 0x0 JUMPDEST DUP4 DUP2 LT ISZERO PUSH2 0xE1 JUMPI DUP1 DUP3 ADD MLOAD DUP2 DUP5 ADD MSTORE PUSH1 0x20 DUP2 ADD SWAP1 POP PUSH2 0xC6 JUMP JUMPDEST POP POP POP POP SWAP1 POP SWAP1 DUP2 ADD SWAP1 PUSH1 0x1F AND DUP1 ISZERO PUSH2 0x10E JUMPI DUP1 DUP3 SUB DUP1 MLOAD PUSH1 0x1 DUP4 PUSH1 0x20 SUB PUSH2 0x100 EXP SUB NOT AND DUP2 MSTORE PUSH1 0x20 ADD SWAP2 POP JUMPDEST POP SWAP3 POP POP POP PUSH1 0x40 MLOAD DUP1 SWAP2 SUB SWAP1 RETURN JUMPDEST PUSH2 0x1CA PUSH1 0x4 DUP1 CALLDATASIZE SUB DUP2 ADD SWAP1 DUP1 DUP1 CALLDATALOAD SWAP1 PUSH1 0x20 ADD SWAP1 DUP3 ADD DUP1 CALLDATALOAD SWAP1 PUSH1 0x20 ADD SWAP1 DUP1 DUP1 PUSH1 0x1F ADD PUSH1 0x20 DUP1 SWAP2 DIV MUL PUSH1 0x20 ADD PUSH1 0x40 MLOAD SWAP1 DUP2 ADD PUSH1 0x40 MSTORE DUP1 SWAP4 SWAP3 SWAP2 SWAP1 DUP2 DUP2 MSTORE PUSH1 0x20 ADD DUP4 DUP4 DUP1 DUP3 DUP5 CALLDATACOPY DUP3 ADD SWAP2 POP POP POP POP POP POP SWAP2 SWAP3 SWAP2 SWAP3 SWAP1 DUP1 CALLDATALOAD PUSH2 0xFFFF AND SWAP1 PUSH1 0x20 ADD SWAP1 SWAP3 SWAP2 SWAP1 DUP1 CALLDATALOAD SWAP1 PUSH1 0x20 ADD SWAP1 DUP3 ADD DUP1 CALLDATALOAD SWAP1 PUSH1 0x20 ADD SWAP1 DUP1 DUP1 PUSH1 0x1F ADD PUSH1 0x20 DUP1 SWAP2 DIV MUL PUSH1 0x20 ADD PUSH1 0x40 MLOAD SWAP1 DUP2 ADD PUSH1 0x40 MSTORE DUP1 SWAP4 SWAP3 SWAP2 SWAP1 DUP2 DUP2 MSTORE PUSH1 0x20 ADD DUP4 DUP4 DUP1 DUP3 DUP5 CALLDATACOPY DUP3 ADD SWAP2 POP POP POP POP POP POP SWAP2 SWAP3 SWAP2 SWAP3 SWAP1 POP POP POP PUSH2 0x772 JUMP JUMPDEST PUSH1 0x40 MLOAD DUP1 DUP1 PUSH1 0x20 ADD DUP3 DUP2 SUB DUP3 MSTORE DUP4 DUP2 DUP2 MLOAD DUP2 MSTORE PUSH1 0x20 ADD SWAP2 POP DUP1 MLOAD SWAP1 PUSH1 0x20 ADD SWAP1 DUP1 DUP4 DUP4 PUSH1 0x0 JUMPDEST DUP4 DUP2 LT ISZERO PUSH2 0x20A JUMPI DUP1 DUP3 ADD MLOAD DUP2 DUP5 ADD MSTORE PUSH1 0x20 DUP2 ADD SWAP1 POP PUSH2 0x1EF JUMP JUMPDEST POP POP POP POP SWAP1 POP SWAP1 DUP2 ADD SWAP1 PUSH1 0x1F AND DUP1 ISZERO PUSH2 0x237 JUMPI DUP1 DUP3 SUB DUP1 MLOAD PUSH1 0x1 DUP4 PUSH1 0x20 SUB PUSH2 0x100 EXP SUB NOT AND DUP2 MSTORE PUSH1 0x20 ADD SWAP2 POP JUMPDEST POP SWAP3 POP POP POP PUSH1 0x40 MLOAD DUP1 SWAP2 SUB SWAP1 RETURN JUMPDEST CALLVALUE DUP1 ISZERO PUSH2 0x251 JUMPI PUSH1 0x0 DUP1 REVERT JUMPDEST POP PUSH2 0x2AC PUSH1 0x4 DUP1 CALLDATASIZE SUB DUP2 ADD SWAP1 DUP1 DUP1 CALLDATALOAD SWAP1 PUSH1 0x20 ADD SWAP1 DUP3 ADD DUP1 CALLDATALOAD SWAP1 PUSH1 0x20 ADD SWAP1 DUP1 DUP1 PUSH1 0x1F ADD PUSH1 0x20 DUP1 SWAP2 DIV MUL PUSH1 0x20 ADD PUSH1 0x40 MLOAD SWAP1 DUP2 ADD PUSH1 0x40 MSTORE DUP1 SWAP4 SWAP3 SWAP2 SWAP1 DUP2 DUP2 MSTORE PUSH1 0x20 ADD DUP4 DUP4 DUP1 DUP3 DUP5 CALLDATACOPY DUP3 ADD SWAP2 POP POP POP POP POP POP SWAP2 SWAP3 SWAP2 SWAP3 SWAP1 POP POP POP PUSH2 0xB7B JUMP JUMPDEST PUSH1 0x40 MLOAD DUP1 DUP1 PUSH1 0x20 ADD DUP3 DUP2 SUB DUP3 MSTORE DUP4 DUP2 DUP2 MLOAD DUP2 MSTORE PUSH1 0x20 ADD SWAP2 POP DUP1 MLOAD SWAP1 PUSH1 0x20 ADD SWAP1 DUP1 DUP4 DUP4 PUSH1 0x0 JUMPDEST DUP4 DUP2 LT ISZERO PUSH2 0x2EC JUMPI DUP1 DUP3 ADD MLOAD DUP2 DUP5 ADD MSTORE PUSH1 0x20 DUP2 ADD SWAP1 POP PUSH2 0x2D1 JUMP JUMPDEST POP POP POP POP SWAP1 POP SWAP1 DUP2 ADD SWAP1 PUSH1 0x1F AND DUP1 ISZERO PUSH2 0x319 JUMPI DUP1 DUP3 SUB DUP1 MLOAD PUSH1 0x1 DUP4 PUSH1 0x20 SUB PUSH2 0x100 EXP SUB NOT AND DUP2 MSTORE PUSH1 0x20 ADD SWAP2 POP JUMPDEST POP SWAP3 POP POP POP PUSH1 0x40 MLOAD DUP1 SWAP2 SUB SWAP1 RETURN JUMPDEST CALLVALUE DUP1 ISZERO PUSH2 0x333 JUMPI PUSH1 0x0 DUP1 REVERT JUMPDEST POP PUSH2 0x376 PUSH1 0x4 DUP1 CALLDATASIZE SUB DUP2 ADD SWAP1 DUP1 DUP1 CALLDATALOAD PUSH2 0xFFFF AND SWAP1 PUSH1 0x20 ADD SWAP1 SWAP3 SWAP2 SWAP1 DUP1 CALLDATALOAD PUSH20 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF AND SWAP1 PUSH1 0x20 ADD SWAP1 SWAP3 SWAP2 SWAP1 POP POP POP PUSH2 0xE26 JUMP JUMPDEST PUSH1 0x40 MLOAD DUP1 DUP3 ISZERO ISZERO ISZERO ISZERO DUP2 MSTORE PUSH1 0x20 ADD SWAP2 POP POP PUSH1 0x40 MLOAD DUP1 SWAP2 SUB SWAP1 RETURN JUMPDEST CALLVALUE DUP1 ISZERO PUSH2 0x39C JUMPI PUSH1 0x0 DUP1 REVERT JUMPDEST POP PUSH2 0x3F7 PUSH1 0x4 DUP1 CALLDATASIZE SUB DUP2 ADD SWAP1 DUP1 DUP1 CALLDATALOAD SWAP1 PUSH1 0x20 ADD SWAP1 DUP3 ADD DUP1 CALLDATALOAD SWAP1 PUSH1 0x20 ADD SWAP1 DUP1 DUP1 PUSH1 0x1F ADD PUSH1 0x20 DUP1 SWAP2 DIV MUL PUSH1 0x20 ADD PUSH1 0x40 MLOAD SWAP1 DUP2 ADD PUSH1 0x40 MSTORE DUP1 SWAP4 SWAP3 SWAP2 SWAP1 DUP2 DUP2 MSTORE PUSH1 0x20 ADD DUP4 DUP4 DUP1 DUP3 DUP5 CALLDATACOPY DUP3 ADD SWAP2 POP POP POP POP POP POP SWAP2 SWAP3 SWAP2 SWAP3 SWAP1 POP POP POP PUSH2 0xE91 JUMP JUMPDEST PUSH1 0x40 MLOAD DUP1 DUP1 PUSH1 0x20 ADD DUP3 DUP2 SUB DUP3 MSTORE DUP4 DUP2 DUP2 MLOAD DUP2 MSTORE PUSH1 0x20 ADD SWAP2 POP DUP1 MLOAD SWAP1 PUSH1 0x20 ADD SWAP1 DUP1 DUP4 DUP4 PUSH1 0x0 JUMPDEST DUP4 DUP2 LT ISZERO PUSH2 0x437 JUMPI DUP1 DUP3 ADD MLOAD DUP2 DUP5 ADD MSTORE PUSH1 0x20 DUP2 ADD SWAP1 POP PUSH2 0x41C JUMP JUMPDEST POP POP POP POP SWAP1 POP SWAP1 DUP2 ADD SWAP1 PUSH1 0x1F AND DUP1 ISZERO PUSH2 0x464 JUMPI DUP1 DUP3 SUB DUP1 MLOAD PUSH1 0x1 DUP4 PUSH1 0x20 SUB PUSH2 0x100 EXP SUB NOT AND DUP2 MSTORE PUSH1 0x20 ADD SWAP2 POP JUMPDEST POP SWAP3 POP POP POP PUSH1 0x40 MLOAD DUP1 SWAP2 SUB SWAP1 RETURN JUMPDEST PUSH1 0x60 DUP1 PUSH1 0x60 DUP1 PUSH1 0x0 PUSH1 0x40 DUP1 MLOAD SWAP1 DUP1 DUP3 MSTORE DUP1 PUSH1 0x1F ADD PUSH1 0x1F NOT AND PUSH1 0x20 ADD DUP3 ADD PUSH1 0x40 MSTORE DUP1 ISZERO PUSH2 0x4AD JUMPI DUP2 PUSH1 0x20 ADD PUSH1 0x20 DUP3 MUL DUP1 CODESIZE DUP4 CODECOPY DUP1 DUP3 ADD SWAP2 POP POP SWAP1 POP JUMPDEST POP SWAP4 POP PUSH1 0x40 DUP1 MLOAD SWAP1 DUP2 ADD PUSH1 0x40 MSTORE DUP1 PUSH1 0x10 DUP2 MSTORE PUSH1 0x20 ADD PUSH32 0x3031323334353637383961626364656600000000000000000000000000000000 DUP2 MSTORE POP SWAP3 POP DUP3 SWAP2 POP PUSH1 0x0 SWAP1 POP JUMPDEST PUSH1 0x20 DUP2 PUSH1 0xFF AND LT ISZERO PUSH2 0x766 JUMPI DUP2 PUSH1 0x4 PUSH1 0xF0 PUSH32 0x100000000000000000000000000000000000000000000000000000000000000 MUL DUP9 DUP5 PUSH1 0xFF AND PUSH1 0x20 DUP2 LT ISZERO ISZERO PUSH2 0x534 JUMPI INVALID JUMPDEST BYTE PUSH32 0x100000000000000000000000000000000000000000000000000000000000000 MUL AND PUSH31 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF NOT AND SWAP1 PUSH1 0x2 EXP SWAP1 DIV PUSH32 0x100000000000000000000000000000000000000000000000000000000000000 SWAP1 DIV DUP2 MLOAD DUP2 LT ISZERO ISZERO PUSH2 0x5AF JUMPI INVALID JUMPDEST SWAP1 PUSH1 0x20 ADD ADD MLOAD PUSH32 0x100000000000000000000000000000000000000000000000000000000000000 SWAP1 DIV PUSH32 0x100000000000000000000000000000000000000000000000000000000000000 MUL DUP5 PUSH1 0x2 DUP4 MUL PUSH1 0xFF AND DUP2 MLOAD DUP2 LT ISZERO ISZERO PUSH2 0x60E JUMPI INVALID JUMPDEST SWAP1 PUSH1 0x20 ADD ADD SWAP1 PUSH31 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF NOT AND SWAP1 DUP2 PUSH1 0x0 BYTE SWAP1 MSTORE8 POP DUP2 PUSH1 0xF PUSH32 0x100000000000000000000000000000000000000000000000000000000000000 MUL DUP8 DUP4 PUSH1 0xFF AND PUSH1 0x20 DUP2 LT ISZERO ISZERO PUSH2 0x674 JUMPI INVALID JUMPDEST BYTE PUSH32 0x100000000000000000000000000000000000000000000000000000000000000 MUL AND PUSH32 0x100000000000000000000000000000000000000000000000000000000000000 SWAP1 DIV DUP2 MLOAD DUP2 LT ISZERO ISZERO PUSH2 0x6C7 JUMPI INVALID JUMPDEST SWAP1 PUSH1 0x20 ADD ADD MLOAD PUSH32 0x100000000000000000000000000000000000000000000000000000000000000 SWAP1 DIV PUSH32 0x100000000000000000000000000000000000000000000000000000000000000 MUL DUP5 PUSH1 0x1 PUSH1 0x2 DUP5 MUL ADD PUSH1 0xFF AND DUP2 MLOAD DUP2 LT ISZERO ISZERO PUSH2 0x729 JUMPI INVALID JUMPDEST SWAP1 PUSH1 0x20 ADD ADD SWAP1 PUSH31 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF NOT AND SWAP1 DUP2 PUSH1 0x0 BYTE SWAP1 MSTORE8 POP DUP1 DUP1 PUSH1 0x1 ADD SWAP2 POP POP PUSH2 0x4F0 JUMP JUMPDEST DUP4 SWAP5 POP POP POP POP POP SWAP2 SWAP1 POP JUMP JUMPDEST PUSH1 0x60 PUSH1 0x0 DUP5 PUSH1 0x40 MLOAD PUSH1 0x20 ADD DUP1 DUP3 DUP1 MLOAD SWAP1 PUSH1 0x20 ADD SWAP1 DUP1 DUP4 DUP4 JUMPDEST PUSH1 0x20 DUP4 LT ISZERO ISZERO PUSH2 0x7AF JUMPI DUP1 MLOAD DUP3 MSTORE PUSH1 0x20 DUP3 ADD SWAP2 POP PUSH1 0x20 DUP2 ADD SWAP1 POP PUSH1 0x20 DUP4 SUB SWAP3 POP PUSH2 0x78A JUMP JUMPDEST PUSH1 0x1 DUP4 PUSH1 0x20 SUB PUSH2 0x100 EXP SUB DUP1 NOT DUP3 MLOAD AND DUP2 DUP5 MLOAD AND DUP1 DUP3 OR DUP6 MSTORE POP POP POP POP POP POP SWAP1 POP ADD SWAP2 POP POP PUSH1 0x40 MLOAD PUSH1 0x20 DUP2 DUP4 SUB SUB DUP2 MSTORE SWAP1 PUSH1 0x40 MSTORE PUSH1 0x40 MLOAD DUP1 DUP3 DUP1 MLOAD SWAP1 PUSH1 0x20 ADD SWAP1 DUP1 DUP4 DUP4 JUMPDEST PUSH1 0x20 DUP4 LT ISZERO ISZERO PUSH2 0x818 JUMPI DUP1 MLOAD DUP3 MSTORE PUSH1 0x20 DUP3 ADD SWAP2 POP PUSH1 0x20 DUP2 ADD SWAP1 POP PUSH1 0x20 DUP4 SUB SWAP3 POP PUSH2 0x7F3 JUMP JUMPDEST PUSH1 0x1 DUP4 PUSH1 0x20 SUB PUSH2 0x100 EXP SUB DUP1 NOT DUP3 MLOAD AND DUP2 DUP5 MLOAD AND DUP1 DUP3 OR DUP6 MSTORE POP POP POP POP POP POP SWAP1 POP ADD SWAP2 POP POP PUSH1 0x40 MLOAD DUP1 SWAP2 SUB SWAP1 KECCAK256 SWAP1 POP PUSH2 0x850 DUP2 PUSH2 0x472 JUMP JUMPDEST PUSH1 0x40 MLOAD PUSH1 0x20 ADD DUP1 DUP1 PUSH32 0x6469643A696F7465783A00000000000000000000000000000000000000000000 DUP2 MSTORE POP PUSH1 0xA ADD DUP3 DUP1 MLOAD SWAP1 PUSH1 0x20 ADD SWAP1 DUP1 DUP4 DUP4 JUMPDEST PUSH1 0x20 DUP4 LT ISZERO ISZERO PUSH2 0x8B0 JUMPI DUP1 MLOAD DUP3 MSTORE PUSH1 0x20 DUP3 ADD SWAP2 POP PUSH1 0x20 DUP2 ADD SWAP1 POP PUSH1 0x20 DUP4 SUB SWAP3 POP PUSH2 0x88B JUMP JUMPDEST PUSH1 0x1 DUP4 PUSH1 0x20 SUB PUSH2 0x100 EXP SUB DUP1 NOT DUP3 MLOAD AND DUP2 DUP5 MLOAD AND DUP1 DUP3 OR DUP6 MSTORE POP POP POP POP POP POP SWAP1 POP ADD SWAP2 POP POP PUSH1 0x40 MLOAD PUSH1 0x20 DUP2 DUP4 SUB SUB DUP2 MSTORE SWAP1 PUSH1 0x40 MSTORE SWAP2 POP PUSH1 0x0 DUP3 PUSH1 0x40 MLOAD DUP1 DUP3 DUP1 MLOAD SWAP1 PUSH1 0x20 ADD SWAP1 DUP1 DUP4 DUP4 JUMPDEST PUSH1 0x20 DUP4 LT ISZERO ISZERO PUSH2 0x91E JUMPI DUP1 MLOAD DUP3 MSTORE PUSH1 0x20 DUP3 ADD SWAP2 POP PUSH1 0x20 DUP2 ADD SWAP1 POP PUSH1 0x20 DUP4 SUB SWAP3 POP PUSH2 0x8F9 JUMP JUMPDEST PUSH1 0x1 DUP4 PUSH1 0x20 SUB PUSH2 0x100 EXP SUB DUP1 NOT DUP3 MLOAD AND DUP2 DUP5 MLOAD AND DUP1 DUP3 OR DUP6 MSTORE POP POP POP POP POP POP SWAP1 POP ADD SWAP2 POP POP SWAP1 DUP2 MSTORE PUSH1 0x20 ADD PUSH1 0x40 MLOAD DUP1 SWAP2 SUB SWAP1 KECCAK256 PUSH1 0x0 ADD PUSH1 0x0 SWAP1 SLOAD SWAP1 PUSH2 0x100 EXP SWAP1 DIV PUSH1 0xFF AND ISZERO ISZERO ISZERO PUSH2 0x9D7 JUMPI PUSH1 0x40 MLOAD PUSH32 0x8C379A000000000000000000000000000000000000000000000000000000000 DUP2 MSTORE PUSH1 0x4 ADD DUP1 DUP1 PUSH1 0x20 ADD DUP3 DUP2 SUB DUP3 MSTORE PUSH1 0x13 DUP2 MSTORE PUSH1 0x20 ADD DUP1 PUSH32 0x64696420616C7265616479206578697374656400000000000000000000000000 DUP2 MSTORE POP PUSH1 0x20 ADD SWAP2 POP POP PUSH1 0x40 MLOAD DUP1 SWAP2 SUB SWAP1 REVERT JUMPDEST DUP2 PUSH1 0x1 DUP7 PUSH1 0x40 MLOAD DUP1 DUP3 DUP1 MLOAD SWAP1 PUSH1 0x20 ADD SWAP1 DUP1 DUP4 DUP4 JUMPDEST PUSH1 0x20 DUP4 LT ISZERO ISZERO PUSH2 0xA10 JUMPI DUP1 MLOAD DUP3 MSTORE PUSH1 0x20 DUP3 ADD SWAP2 POP PUSH1 0x20 DUP2 ADD SWAP1 POP PUSH1 0x20 DUP4 SUB SWAP3 POP PUSH2 0x9EB JUMP JUMPDEST PUSH1 0x1 DUP4 PUSH1 0x20 SUB PUSH2 0x100 EXP SUB DUP1 NOT DUP3 MLOAD AND DUP2 DUP5 MLOAD AND DUP1 DUP3 OR DUP6 MSTORE POP POP POP POP POP POP SWAP1 POP ADD SWAP2 POP POP SWAP1 DUP2 MSTORE PUSH1 0x20 ADD PUSH1 0x40 MLOAD DUP1 SWAP2 SUB SWAP1 KECCAK256 SWAP1 DUP1 MLOAD SWAP1 PUSH1 0x20 ADD SWAP1 PUSH2 0xA56 SWAP3 SWAP2 SWAP1 PUSH2 0x1093 JUMP JUMPDEST POP PUSH1 0x80 PUSH1 0x40 MLOAD SWAP1 DUP2 ADD PUSH1 0x40 MSTORE DUP1 PUSH1 0x1 ISZERO ISZERO DUP2 MSTORE PUSH1 0x20 ADD DUP5 DUP2 MSTORE PUSH1 0x20 ADD DUP6 PUSH2 0xFFFF AND DUP2 MSTORE PUSH1 0x20 ADD PUSH1 0x0 PUSH1 0xFF AND DUP2 MSTORE POP PUSH1 0x0 DUP4 PUSH1 0x40 MLOAD DUP1 DUP3 DUP1 MLOAD SWAP1 PUSH1 0x20 ADD SWAP1 DUP1 DUP4 DUP4 JUMPDEST PUSH1 0x20 DUP4 LT ISZERO ISZERO PUSH2 0xABC JUMPI DUP1 MLOAD DUP3 MSTORE PUSH1 0x20 DUP3 ADD SWAP2 POP PUSH1 0x20 DUP2 ADD SWAP1 POP PUSH1 0x20 DUP4 SUB SWAP3 POP PUSH2 0xA97 JUMP JUMPDEST PUSH1 0x1 DUP4 PUSH1 0x20 SUB PUSH2 0x100 EXP SUB DUP1 NOT DUP3 MLOAD AND DUP2 DUP5 MLOAD AND DUP1 DUP3 OR DUP6 MSTORE POP POP POP POP POP POP SWAP1 POP ADD SWAP2 POP POP SWAP1 DUP2 MSTORE PUSH1 0x20 ADD PUSH1 0x40 MLOAD DUP1 SWAP2 SUB SWAP1 KECCAK256 PUSH1 0x0 DUP3 ADD MLOAD DUP2 PUSH1 0x0 ADD PUSH1 0x0 PUSH2 0x100 EXP DUP2 SLOAD DUP2 PUSH1 0xFF MUL NOT AND SWAP1 DUP4 ISZERO ISZERO MUL OR SWAP1 SSTORE POP PUSH1 0x20 DUP3 ADD MLOAD DUP2 PUSH1 0x1 ADD SWAP1 DUP1 MLOAD SWAP1 PUSH1 0x20 ADD SWAP1 PUSH2 0xB2B SWAP3 SWAP2 SWAP1 PUSH2 0x1113 JUMP JUMPDEST POP PUSH1 0x40 DUP3 ADD MLOAD DUP2 PUSH1 0x2 ADD PUSH1 0x0 PUSH2 0x100 EXP DUP2 SLOAD DUP2 PUSH2 0xFFFF MUL NOT AND SWAP1 DUP4 PUSH2 0xFFFF AND MUL OR SWAP1 SSTORE POP PUSH1 0x60 DUP3 ADD MLOAD DUP2 PUSH1 0x2 ADD PUSH1 0x2 PUSH2 0x100 EXP DUP2 SLOAD DUP2 PUSH1 0xFF MUL NOT AND SWAP1 DUP4 PUSH1 0xFF AND MUL OR SWAP1 SSTORE POP SWAP1 POP POP POP SWAP4 SWAP3 POP POP POP JUMP JUMPDEST PUSH1 0x60 PUSH1 0x0 DUP1 DUP4 PUSH1 0x40 MLOAD DUP1 DUP3 DUP1 MLOAD SWAP1 PUSH1 0x20 ADD SWAP1 DUP1 DUP4 DUP4 JUMPDEST PUSH1 0x20 DUP4 LT ISZERO ISZERO PUSH2 0xBB6 JUMPI DUP1 MLOAD DUP3 MSTORE PUSH1 0x20 DUP3 ADD SWAP2 POP PUSH1 0x20 DUP2 ADD SWAP1 POP PUSH1 0x20 DUP4 SUB SWAP3 POP PUSH2 0xB91 JUMP JUMPDEST PUSH1 0x1 DUP4 PUSH1 0x20 SUB PUSH2 0x100 EXP SUB DUP1 NOT DUP3 MLOAD AND DUP2 DUP5 MLOAD AND DUP1 DUP3 OR DUP6 MSTORE POP POP POP POP POP POP SWAP1 POP ADD SWAP2 POP POP SWAP1 DUP2 MSTORE PUSH1 0x20 ADD PUSH1 0x40 MLOAD DUP1 SWAP2 SUB SWAP1 KECCAK256 SWAP1 POP DUP1 PUSH1 0x0 ADD PUSH1 0x0 SWAP1 SLOAD SWAP1 PUSH2 0x100 EXP SWAP1 DIV PUSH1 0xFF AND ISZERO ISZERO PUSH2 0xC4C JUMPI PUSH1 0x40 MLOAD PUSH32 0x8C379A000000000000000000000000000000000000000000000000000000000 DUP2 MSTORE PUSH1 0x4 ADD DUP1 DUP1 PUSH1 0x20 ADD DUP3 DUP2 SUB DUP3 MSTORE PUSH1 0x0 DUP2 MSTORE PUSH1 0x20 ADD PUSH1 0x20 ADD SWAP2 POP POP PUSH1 0x40 MLOAD DUP1 SWAP2 SUB SWAP1 REVERT JUMPDEST PUSH1 0x2 PUSH1 0x0 DUP3 PUSH1 0x2 ADD PUSH1 0x0 SWAP1 SLOAD SWAP1 PUSH2 0x100 EXP SWAP1 DIV PUSH2 0xFFFF AND PUSH2 0xFFFF AND PUSH2 0xFFFF AND DUP2 MSTORE PUSH1 0x20 ADD SWAP1 DUP2 MSTORE PUSH1 0x20 ADD PUSH1 0x0 KECCAK256 PUSH1 0x0 SWAP1 SLOAD SWAP1 PUSH2 0x100 EXP SWAP1 DIV PUSH20 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF AND PUSH20 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF AND PUSH4 0x6450A322 DUP3 PUSH1 0x1 ADD PUSH1 0x40 MLOAD DUP3 PUSH4 0xFFFFFFFF AND PUSH29 0x100000000000000000000000000000000000000000000000000000000 MUL DUP2 MSTORE PUSH1 0x4 ADD DUP1 DUP1 PUSH1 0x20 ADD DUP3 DUP2 SUB DUP3 MSTORE DUP4 DUP2 DUP2 SLOAD PUSH1 0x1 DUP2 PUSH1 0x1 AND ISZERO PUSH2 0x100 MUL SUB AND PUSH1 0x2 SWAP1 DIV DUP2 MSTORE PUSH1 0x20 ADD SWAP2 POP DUP1 SLOAD PUSH1 0x1 DUP2 PUSH1 0x1 AND ISZERO PUSH2 0x100 MUL SUB AND PUSH1 0x2 SWAP1 DIV DUP1 ISZERO PUSH2 0xD6D JUMPI DUP1 PUSH1 0x1F LT PUSH2 0xD42 JUMPI PUSH2 0x100 DUP1 DUP4 SLOAD DIV MUL DUP4 MSTORE SWAP2 PUSH1 0x20 ADD SWAP2 PUSH2 0xD6D JUMP JUMPDEST DUP3 ADD SWAP2 SWAP1 PUSH1 0x0 MSTORE PUSH1 0x20 PUSH1 0x0 KECCAK256 SWAP1 JUMPDEST DUP2 SLOAD DUP2 MSTORE SWAP1 PUSH1 0x1 ADD SWAP1 PUSH1 0x20 ADD DUP1 DUP4 GT PUSH2 0xD50 JUMPI DUP3 SWAP1 SUB PUSH1 0x1F AND DUP3 ADD SWAP2 JUMPDEST POP POP SWAP3 POP POP POP PUSH1 0x0 PUSH1 0x40 MLOAD DUP1 DUP4 SUB DUP2 PUSH1 0x0 DUP8 DUP1 EXTCODESIZE ISZERO DUP1 ISZERO PUSH2 0xD8D JUMPI PUSH1 0x0 DUP1 REVERT JUMPDEST POP GAS CALL ISZERO DUP1 ISZERO PUSH2 0xDA1 JUMPI RETURNDATASIZE PUSH1 0x0 DUP1 RETURNDATACOPY RETURNDATASIZE PUSH1 0x0 REVERT JUMPDEST POP POP POP POP PUSH1 0x40 MLOAD RETURNDATASIZE PUSH1 0x0 DUP3 RETURNDATACOPY RETURNDATASIZE PUSH1 0x1F NOT PUSH1 0x1F DUP3 ADD AND DUP3 ADD DUP1 PUSH1 0x40 MSTORE POP PUSH1 0x20 DUP2 LT ISZERO PUSH2 0xDCB JUMPI PUSH1 0x0 DUP1 REVERT JUMPDEST DUP2 ADD SWAP1 DUP1 DUP1 MLOAD PUSH5 0x100000000 DUP2 GT ISZERO PUSH2 0xDE3 JUMPI PUSH1 0x0 DUP1 REVERT JUMPDEST DUP3 DUP2 ADD SWAP1 POP PUSH1 0x20 DUP2 ADD DUP5 DUP2 GT ISZERO PUSH2 0xDF9 JUMPI PUSH1 0x0 DUP1 REVERT JUMPDEST DUP2 MLOAD DUP6 PUSH1 0x1 DUP3 MUL DUP4 ADD GT PUSH5 0x100000000 DUP3 GT OR ISZERO PUSH2 0xE16 JUMPI PUSH1 0x0 DUP1 REVERT JUMPDEST POP POP SWAP3 SWAP2 SWAP1 POP POP POP SWAP2 POP POP SWAP2 SWAP1 POP JUMP JUMPDEST PUSH1 0x0 DUP1 DUP3 SWAP1 POP DUP1 PUSH1 0x2 PUSH1 0x0 DUP7 PUSH2 0xFFFF AND PUSH2 0xFFFF AND DUP2 MSTORE PUSH1 0x20 ADD SWAP1 DUP2 MSTORE PUSH1 0x20 ADD PUSH1 0x0 KECCAK256 PUSH1 0x0 PUSH2 0x100 EXP DUP2 SLOAD DUP2 PUSH20 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF MUL NOT AND SWAP1 DUP4 PUSH20 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF AND MUL OR SWAP1 SSTORE POP PUSH1 0x1 SWAP2 POP POP SWAP3 SWAP2 POP POP JUMP JUMPDEST PUSH1 0x60 DUP1 PUSH1 0x1 DUP4 PUSH1 0x40 MLOAD DUP1 DUP3 DUP1 MLOAD SWAP1 PUSH1 0x20 ADD SWAP1 DUP1 DUP4 DUP4 JUMPDEST PUSH1 0x20 DUP4 LT ISZERO ISZERO PUSH2 0xECC JUMPI DUP1 MLOAD DUP3 MSTORE PUSH1 0x20 DUP3 ADD SWAP2 POP PUSH1 0x20 DUP2 ADD SWAP1 POP PUSH1 0x20 DUP4 SUB SWAP3 POP PUSH2 0xEA7 JUMP JUMPDEST PUSH1 0x1 DUP4 PUSH1 0x20 SUB PUSH2 0x100 EXP SUB DUP1 NOT DUP3 MLOAD AND DUP2 DUP5 MLOAD AND DUP1 DUP3 OR DUP6 MSTORE POP POP POP POP POP POP SWAP1 POP ADD SWAP2 POP POP SWAP1 DUP2 MSTORE PUSH1 0x20 ADD PUSH1 0x40 MLOAD DUP1 SWAP2 SUB SWAP1 KECCAK256 DUP1 SLOAD PUSH1 0x1 DUP2 PUSH1 0x1 AND ISZERO PUSH2 0x100 MUL SUB AND PUSH1 0x2 SWAP1 DIV DUP1 PUSH1 0x1F ADD PUSH1 0x20 DUP1 SWAP2 DIV MUL PUSH1 0x20 ADD PUSH1 0x40 MLOAD SWAP1 DUP2 ADD PUSH1 0x40 MSTORE DUP1 SWAP3 SWAP2 SWAP1 DUP2 DUP2 MSTORE PUSH1 0x20 ADD DUP3 DUP1 SLOAD PUSH1 0x1 DUP2 PUSH1 0x1 AND ISZERO PUSH2 0x100 MUL SUB AND PUSH1 0x2 SWAP1 DIV DUP1 ISZERO PUSH2 0xF93 JUMPI DUP1 PUSH1 0x1F LT PUSH2 0xF68 JUMPI PUSH2 0x100 DUP1 DUP4 SLOAD DIV MUL DUP4 MSTORE SWAP2 PUSH1 0x20 ADD SWAP2 PUSH2 0xF93 JUMP JUMPDEST DUP3 ADD SWAP2 SWAP1 PUSH1 0x0 MSTORE PUSH1 0x20 PUSH1 0x0 KECCAK256 SWAP1 JUMPDEST DUP2 SLOAD DUP2 MSTORE SWAP1 PUSH1 0x1 ADD SWAP1 PUSH1 0x20 ADD DUP1 DUP4 GT PUSH2 0xF76 JUMPI DUP3 SWAP1 SUB PUSH1 0x1F AND DUP3 ADD SWAP2 JUMPDEST POP POP POP POP POP SWAP1 POP PUSH1 0x0 DUP2 PUSH1 0x40 MLOAD DUP1 DUP3 DUP1 MLOAD SWAP1 PUSH1 0x20 ADD SWAP1 DUP1 DUP4 DUP4 JUMPDEST PUSH1 0x20 DUP4 LT ISZERO ISZERO PUSH2 0xFD2 JUMPI DUP1 MLOAD DUP3 MSTORE PUSH1 0x20 DUP3 ADD SWAP2 POP PUSH1 0x20 DUP2 ADD SWAP1 POP PUSH1 0x20 DUP4 SUB SWAP3 POP PUSH2 0xFAD JUMP JUMPDEST PUSH1 0x1 DUP4 PUSH1 0x20 SUB PUSH2 0x100 EXP SUB DUP1 NOT DUP3 MLOAD AND DUP2 DUP5 MLOAD AND DUP1 DUP3 OR DUP6 MSTORE POP POP POP POP POP POP SWAP1 POP ADD SWAP2 POP POP SWAP1 DUP2 MSTORE PUSH1 0x20 ADD PUSH1 0x40 MLOAD DUP1 SWAP2 SUB SWAP1 KECCAK256 PUSH1 0x0 ADD PUSH1 0x0 SWAP1 SLOAD SWAP1 PUSH2 0x100 EXP SWAP1 DIV PUSH1 0xFF AND ISZERO ISZERO PUSH2 0x108A JUMPI PUSH1 0x40 MLOAD PUSH32 0x8C379A000000000000000000000000000000000000000000000000000000000 DUP2 MSTORE PUSH1 0x4 ADD DUP1 DUP1 PUSH1 0x20 ADD DUP3 DUP2 SUB DUP3 MSTORE PUSH1 0xD DUP2 MSTORE PUSH1 0x20 ADD DUP1 PUSH32 0x646964206E6F7420657869737400000000000000000000000000000000000000 DUP2 MSTORE POP PUSH1 0x20 ADD SWAP2 POP POP PUSH1 0x40 MLOAD DUP1 SWAP2 SUB SWAP1 REVERT JUMPDEST DUP1 SWAP2 POP POP SWAP2 SWAP1 POP JUMP JUMPDEST DUP3 DUP1 SLOAD PUSH1 0x1 DUP2 PUSH1 0x1 AND ISZERO PUSH2 0x100 MUL SUB AND PUSH1 0x2 SWAP1 DIV SWAP1 PUSH1 0x0 MSTORE PUSH1 0x20 PUSH1 0x0 KECCAK256 SWAP1 PUSH1 0x1F ADD PUSH1 0x20 SWAP1 DIV DUP2 ADD SWAP3 DUP3 PUSH1 0x1F LT PUSH2 0x10D4 JUMPI DUP1 MLOAD PUSH1 0xFF NOT AND DUP4 DUP1 ADD OR DUP6 SSTORE PUSH2 0x1102 JUMP JUMPDEST DUP3 DUP1 ADD PUSH1 0x1 ADD DUP6 SSTORE DUP3 ISZERO PUSH2 0x1102 JUMPI SWAP2 DUP3 ADD JUMPDEST DUP3 DUP2 GT ISZERO PUSH2 0x1101 JUMPI DUP3 MLOAD DUP3 SSTORE SWAP2 PUSH1 0x20 ADD SWAP2 SWAP1 PUSH1 0x1 ADD SWAP1 PUSH2 0x10E6 JUMP JUMPDEST JUMPDEST POP SWAP1 POP PUSH2 0x110F SWAP2 SWAP1 PUSH2 0x1193 JUMP JUMPDEST POP SWAP1 JUMP JUMPDEST DUP3 DUP1 SLOAD PUSH1 0x1 DUP2 PUSH1 0x1 AND ISZERO PUSH2 0x100 MUL SUB AND PUSH1 0x2 SWAP1 DIV SWAP1 PUSH1 0x0 MSTORE PUSH1 0x20 PUSH1 0x0 KECCAK256 SWAP1 PUSH1 0x1F ADD PUSH1 0x20 SWAP1 DIV DUP2 ADD SWAP3 DUP3 PUSH1 0x1F LT PUSH2 0x1154 JUMPI DUP1 MLOAD PUSH1 0xFF NOT AND DUP4 DUP1 ADD OR DUP6 SSTORE PUSH2 0x1182 JUMP JUMPDEST DUP3 DUP1 ADD PUSH1 0x1 ADD DUP6 SSTORE DUP3 ISZERO PUSH2 0x1182 JUMPI SWAP2 DUP3 ADD JUMPDEST DUP3 DUP2 GT ISZERO PUSH2 0x1181 JUMPI DUP3 MLOAD DUP3 SSTORE SWAP2 PUSH1 0x20 ADD SWAP2 SWAP1 PUSH1 0x1 ADD SWAP1 PUSH2 0x1166 JUMP JUMPDEST JUMPDEST POP SWAP1 POP PUSH2 0x118F SWAP2 SWAP1 PUSH2 0x1193 JUMP JUMPDEST POP SWAP1 JUMP JUMPDEST PUSH2 0x11B5 SWAP2 SWAP1 JUMPDEST DUP1 DUP3 GT ISZERO PUSH2 0x11B1 JUMPI PUSH1 0x0 DUP2 PUSH1 0x0 SWAP1 SSTORE POP PUSH1 0x1 ADD PUSH2 0x1199 JUMP JUMPDEST POP SWAP1 JUMP JUMPDEST SWAP1 JUMP STOP LOG1 PUSH6 0x627A7A723058 KECCAK256 0xbb 0x2d 0x49 0xab CREATE2 0xd0 0xb8 DELEGATECALL 0xc3 JUMP 0xab BALANCE SWAP14 0x4b 0xce 0xf6 0xae MSIZE 0xae PUSH13 0x16581A48A74E292D7A494A8100 0x29 ",
	"sourceMap": "109:1856:0:-;;;412:28;8:9:-1;5:2;;;30:1;27;20:12;5:2;412:28:0;109:1856;;;;;;"
}
 */
 