FROM ethereum/client-go:latest

ADD CustomGenesis.json /root/CustomGenesis.json

RUN bash -c 'geth init ~/CustomGenesis.json'

RUN bash -c 'mkdir /root/VPSChain'
