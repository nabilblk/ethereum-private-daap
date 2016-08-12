### Verify Ethereum Compiler : 

Open console (Docker)

```
docker exec -it bootstrap geth attach ipc://root/.ethereum/devchain/geth.ipc console
```
#### Installation of Solidity Compiler
```
apt-get update
apt-get install solc
which solc
```

#### Set Compiler Ethereum 
```
admin.setSolc("/usr/bin/solc")
eth.getCompilers()
```

```
var greeterSource = 'contract mortal { address owner; function mortal() { owner = msg.sender; } function kill() { if (msg.sender == owner) selfdestruct(owner); } } contract greeter is mortal { string greeting; function greeter(string _greeting) public { greeting = _greeting; } function greet() constant returns (string) { return greeting; } }'

var greeterCompiled = web3.eth.compile.solidity(greeterSource)
```

```
var _greeting = "Hello World!"
var greeterContract = web3.eth.contract(greeterCompiled.greeter.info.abiDefinition);

var greeter = greeterContract.new(_greeting,{from:web3.eth.accounts[0], data: greeterCompiled.greeter.code, gas: 300000}, function(e, contract){
    if(!e) {

      if(!contract.address) {
        console.log("Contract transaction send: TransactionHash: " + contract.transactionHash + " waiting to be mined...");

      } else {
        console.log("Contract mined! Address: " + contract.address);
        console.log(contract);
      }

    }
})
```

```
eth.getCode(greeter.address)
greeter.greet();
```

## Get other poeple to interact with our smart COntract 
```
ABI DEFINITION : greeterCompiled.greeter.info.abiDefinition;
Contract Adress : greeter.address;
```
Resulats : 

```
[{
    constant: false,
    inputs: [],
    name: "kill",
    outputs: [],
    type: "function"
}, {
    constant: true,
    inputs: [],
    name: "greet",
    outputs: [{
        name: "",
        type: "string"
    }],
    type: "function"
}, {
    inputs: [{
        name: "_greeting",
        type: "string"
    }],
    type: "constructor"
}]
```
And then to execute : 

```
var greeter2 = eth.contract([{ constant: false, inputs: [], name: "kill", outputs: [], type: "function" }, { constant: true, inputs: [], name: "greet", outputs: [{ name: "", type: "string" }], type: "function" }, { inputs: [{ name: "_greeting", type: "string" }], type: "constructor" }]).at('0x040266bc2d9cc16d06dc1b53400d523a18cf0c35');

```

http://www.textfixer.com/tools/remove-line-breaks.php

docker exec -it bootstrap geth --datadir=~/.ethereum/devchain --exec 'personal.unlockAccount(eth.accounts[0])' attach ipc://root/.ethereum/devchain/geth.ipc

