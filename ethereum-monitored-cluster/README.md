# Ethereum Docker

Assuming you ran docker-compose against the ```default``` machine.

#### Ethereum Cluster with netstats monitoring

To run an Ethereum Docker cluster run the following:

```
docker-compose up -d
```

By default this will create:

* 1 Ethereum Bootstrapped container
* 1 Ethereum container (which connects to the bootstrapped container on launch)
* 1 Netstats container (with a Web UI to view activity in the cluster)

To access the Netstats Web UI:

```
open http://$(docker-machine ip default):3000
```

##### Scaling the number of nodes/containers in the cluster

```
docker-compose scale eth=3
```

Will scale the number of Ethereum nodes upwards (replace 3 with however many nodes
you prefer). These nodes will connect to the P2P network (via the bootstrap node)
by default.