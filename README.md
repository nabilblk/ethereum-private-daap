## Docker Ethereum Installation 

### Building Ethereum Image : 
```shell
docker-machine create upwork2 --driver=virtualbox
eval "$(docker-machine env upwork2)"
cd docker-private-network/master/
docker build -t "mynode" .
```
You sould see this as logs : 

```
Sending build context to Docker daemon 3.072 kB
Step 1 : FROM ethereum/client-go:latest
 ---> b39729d2d20d
Step 2 : ADD CustomGenesis.json /root/CustomGenesis.json
 ---> Using cache
 ---> 1c106df7c49a
Step 3 : RUN bash -c 'geth init ~/CustomGenesis.json'
 ---> Using cache
 ---> d5cae18fe3b3
Step 4 : RUN bash -c 'mkdir /root/VPSChain'
 ---> Using cache
 ---> dbe897060b1b
Successfully built dbe897060b1b
```

### Creating Ethereum nodes in a private Network Mode : 

Node 1 : 
```
docker run -it -p 8545:8545 -p 30303:30303 --name e1  mynode --dev --identity "MyNodeName1" --datadir "/root/VPSChain" --rpc --rpcaddr "0.0.0.0" --rpcport "8545" --rpccorsdomain "*" --port "30303" --nodiscover --ipcapi "admin,db,eth,debug,miner,net,shh,txpool,personal,web3" --rpcapi "db,eth,net,web3" --networkid 1900 --nat "any" --maxpeers 2 console
```
Node 2 : 
```
docker run -it -p 8546:8546 -p 30304:30304 --name e2 --link e1:e1 mynode --dev --identity "MyNodeName2" --datadir "/root/VPSChain" --rpc --rpcaddr "0.0.0.0"  --rpcport "8546" --rpccorsdomain "*" --port "30304" --nodiscover --ipcapi "admin,db,eth,debug,miner,net,shh,txpool,personal,web3" --rpcapi "db,eth,net,web3" --networkid 1900 --nat "any" --maxpeers 2 console
```

It's important to see this these logs in the two containers : 
````  
  I0728 22:32:27.209057 eth/backend.go:172] Protocol Versions: [63 62], Network Id: 1900
  I0728 22:32:27.210003 eth/backend.go:180] Successfully wrote custom genesis block: e5be92145a301820111f91866566e3e99ee344d155569e4556a39bc71238f3bc
```

## Ethereum Private Network Configuration 
  
Create an account in the two nodes : 

Node 1 :

```   
  > personal.newAccount("AZERTY")
  "0x7bca2ebe07358e7843b37e473d2067ad168b3257"
```
Node 2 : 

```
  > personal.newAccount("AZERTY")
  "0x77c16f6bd29cff5939b0bb6c3a3c80b4c6ed4d68"
```

In the two nodes we should see this : 

```
  > admin.peers
  []
```

In Node 2 : 

```
  > admin.nodeInfo
  {
    enode: "enode://c6abc01b894caeb96bb56b4358aaf0899cbfd321c9b0a024457200ababc6f49467a2fd72c4f05a0e2d55c1f0d97a144677e55b484ca31aa36fb64a6f180b2e3c@[::]:30304?discport=0",
    id: "c6abc01b894caeb96bb56b4358aaf0899cbfd321c9b0a024457200ababc6f49467a2fd72c4f05a0e2d55c1f0d97a144677e55b484ca31aa36fb64a6f180b2e3c",
    ip: "::",
    listenAddr: "[::]:30304",
    name: "Geth/v1.4.10-stable/linux/go1.5.1/MyNodeName2",
    ports: {
      discovery: 0,
      listener: 30304
    },
    protocols: {
      eth: {
        difficulty: 131072,
        genesis: "0xe5be92145a301820111f91866566e3e99ee344d155569e4556a39bc71238f3bc",
        head: "0xe5be92145a301820111f91866566e3e99ee344d155569e4556a39bc71238f3bc",
        network: 1900
      },
      shh: "unknown"
    }
  }
```

Get the IP of the docker-machine upwork2 : 

```
Je:upwork-blockchain nabil$ docker-machine ip upwork2
192.168.99.100
```

In Node 2 : 

```
> admin.addPeer("enode://527559a2ff6efc129a654c09064fc74fb42a54d28f312103e99542049fc525f549a8f17e3837a12e6f3c086e4477f8c4f61e4eb78052db2057f68edde2a6c22d@192.168.99.100:30303")
true
```

Now : 

In node 2 : 

```
> admin.peers
[{
    caps: ["eth/62", "eth/63", "shh/2"],
    id: "527559a2ff6efc129a654c09064fc74fb42a54d28f312103e99542049fc525f549a8f17e3837a12e6f3c086e4477f8c4f61e4eb78052db2057f68edde2a6c22d",
    name: "Geth/v1.4.10-stable/linux/go1.5.1/MyNodeName1",
    network: {
      localAddress: "172.17.0.3:30304",
      remoteAddress: "172.17.0.1:38944"
    },
    protocols: {
      eth: {
        difficulty: 131072,
        head: "e5be92145a301820111f91866566e3e99ee344d155569e4556a39bc71238f3bc",
        version: 63
      },
      shh: "unknown"
    }
}]
```

In node 1 : 

```
> admin.peers
[{
    caps: ["eth/62", "eth/63", "shh/2"],
    id: "c6abc01b894caeb96bb56b4358aaf0899cbfd321c9b0a024457200ababc6f49467a2fd72c4f05a0e2d55c1f0d97a144677e55b484ca31aa36fb64a6f180b2e3c",
    name: "Geth/v1.4.10-stable/linux/go1.5.1/MyNodeName2",
    network: {
      localAddress: "172.17.0.2:59682",
      remoteAddress: "192.168.99.100:30304"
    },
    protocols: {
      eth: {
        difficulty: 131072,
        head: "e5be92145a301820111f91866566e3e99ee344d155569e4556a39bc71238f3bc",
        version: 63
      },
      shh: "unknown"
    }
}]
```


In Both nodes start mining : 

```
> miner.start()
```

After 1 minutes Stop Mining in the two nodes : 

```
> miner.stop()
```

In Node 1 : 

```
> primary = eth.accounts[0];
"0x7bca2ebe07358e7843b37e473d2067ad168b3257"
> balance = web3.fromWei(eth.getBalance(primary), "ether");
55
```

In Node 2 : 

```
> primary = eth.accounts[0];
"0x77c16f6bd29cff5939b0bb6c3a3c80b4c6ed4d68"
> balance = web3.fromWei(eth.getBalance(primary), "ether");
45
```

Lets try now sending from Account 1 to Account 2 : 

In Node 1 : 

```
> primary = eth.accounts[0];
"0x7bca2ebe07358e7843b37e473d2067ad168b3257"
> balance = web3.fromWei(eth.getBalance(primary), "ether");
55
> sender = "0x7bca2ebe07358e7843b37e473d2067ad168b3257"
"0x7bca2ebe07358e7843b37e473d2067ad168b3257"
> reciever = "0x77c16f6bd29cff5939b0bb6c3a3c80b4c6ed4d68"
"0x77c16f6bd29cff5939b0bb6c3a3c80b4c6ed4d68"
> amount = web3.toWei(0.01, "ether");
"10000000000000000"
> personal.unlockAccount(sender)
Unlock account 0x7bca2ebe07358e7843b37e473d2067ad168b3257
Passphrase: 
true
> eth.sendTransaction({from: sender , to: reciever , value : amount})
I0728 22:53:33.028539 eth/api.go:1193] Tx(0x28f0880411e7c58ec94aea42347fc6f8f00682b49d1c7e6e52bfb788f865d906) to: 0x77c16f6bd29cff5939b0bb6c3a3c80b4c6ed4d68
"0x28f0880411e7c58ec94aea42347fc6f8f00682b49d1c7e6e52bfb788f865d906"
```

To validate The transaction start Mining Again : 

```
> web3.fromWei(eth.getBalance(sender), "ether");
79.98958
> web3.fromWei(eth.getBalance(reciever), "ether");
55.01042
```

So now our private Network Work and we are able to Mine and send transaction . 

## Creating Smart Contract/Daap
 
Let's now create a smart Contract using Truffle :  

```
mkdir mysmartContract
cd mysmartContract/
truffle init
```

Modify the truffle.js and replace : 

```
rpc: {
    host: "localhost",
    port: 8545
  }
```
  By 

```
  rpc: {
      host: "%IP%",
      port: 8545
    }
```    
    
Run : 

```
  truffle migrate 
```

You should see this in ethereum node : 

```
  > I0728 23:03:18.214082 eth/api.go:1191] Tx(0x4c299bda948064380bc9485552dda77f5c4b2bc54fb175fbb762c61aa636b68e) created: 0xb8797611368e41e3ce98cb9404aaeadd05ece7d1
```  

Start Mining to validate SmartContract Creation : 
  
```
  Je:mysmartContract nabil$ truffle migrate 
  Running migration: 1_initial_migration.js
    Deploying Migrations...
    Migrations: 0xb8797611368e41e3ce98cb9404aaeadd05ece7d1
  Saving successful migration to network...
  Saving artifacts...
  Running migration: 2_deploy_contracts.js
    Deploying ConvertLib...
    ConvertLib: 0x6de814329790286a7acbad4c16105e6c0ae9be69
    Linking ConvertLib to MetaCoin
    Deploying MetaCoin...
    MetaCoin: 0x4be5a590320fc6e1749059ee989bdfc630b638d2
  Saving successful migration to network...
  Saving artifacts...
```

RUN : 

```
Je:mysmartContract nabil$ truffle serve
Serving app on port 8080...
Rebuilding...
Completed without errors on Fri Jul 29 2016 00:08:46 GMT+0100 (WEST)
``` 

Go to http://localhost:8080 and start using your Dapp : 
