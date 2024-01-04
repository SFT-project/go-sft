# go-sft

## Deployment of nodes

nodes are currently deployed through the internal network, and do not open any ports to the external network.External RPC ports can also be achieved through nginx-like proxies.

>go-sft --datadir=xxx --port=xxxx --rpc --rpcaddr=0.0.0.0 --rpcport=xxx --rpcapi=db, eth, net, web3, txpool --rpccorsdomain=*

Parameter description:

- datadir is the directory where blockchain data is stored, including all blocks, transactions and index data.
- port can not be specified, as specified when the node is found.
- rpcaddr is the IP address of the open rpc interface.
- rpcport is the port used by the open rpc interface.
- rpcapi is the open api type, which can generally be used with the above several APIs.
- rpccorsdomain is open cross-domain access.

For special needs such as the need to use node wallet signature and transfer, the api type personal can be opened, and --allow-insecure-unlock can be specified.

## Local access methods of nodes

After the above node deployment is completed, a file geth. ipc will be generated in the data directory. The local command line can access node data by 

> go-sft attach geth. ipc.

## RPC interface

The RPC interface is the same as the traditional EVM type public chain, refer to ETH, etc.

### config 

- Discovery node configuration: params/bootnodes.go, var MainnetBootnodes is configured as the discovery node
- Creation parameter configuration: core/genesis.go, The parameters defined in func DefaultGenesisBlock() are the parameters of the genesis block
- Consensus modification: consensus/ethash/sealer.go, func mine
- Block Reward: consensus/ethash/consensus.go, func accumulateRewards

### debug

package: github.com/sft-project/go-sft/cmd/geth

- ethClient in cmd/geth/main.go
- DefaultConfig in eth/config.go
- DefaultConfig in node/defaults.go
- cmd/evm/main.go
- cmd/devp2p/main.go
- p2p/server.go
- rpc/server.go
- miner/worker.go
