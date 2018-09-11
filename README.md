# Docker-Bitcoin

This is a fork from amacneil/docker-bitcoin (https://github.com/amacneil/docker-bitcoin).
This repo has a more specific approach to provide docker images to the latest stable versions of
bitcoin-core and bitcoin-cash(bitcoin-abc nodes).

Bitcoin uses peer-to-peer technology to operate with no central authority or banks; managing transactions and the issuing of bitcoin is carried out collectively by the network. Bitcoin is open-source; its design is public, nobody owns or controls Bitcoin and everyone can take part. Through many of its unique properties, Bitcoin allows exciting uses that could not be covered by any previous payment system.

This Docker image provides `bitcoin`, `bitcoin-cli` and `bitcoin-tx` applications which can be used to run and interact with a bitcoin server.


### Usage

``` docker build -t bitcoind:latest core/ && docker run bitcoind:latest 
    docker build -t bitcoin-abc:latest core/ && docker run bitcoin-abc:latest ```    

### Configuring Bitcoin

``` Simply pass the parameters into "cat <<-EOF" block in docker-entrypoint.sh 
    Export the entrypoint.sh required variables:
    BITCOIN_RPC_USER
    BITCOIN_RPC_PASSWORD
    RABBITMQ_HOST
    RABBITMQ_USER
    RABBITMQ_PASSWORD
    RABBITMQ_ROUTING_KEY
    RABBITMQ_CHANNEL_KEY} ```

### Data Volumes

By default, Docker will create ephemeral containers. That is, the blockchain data will not be persisted, and you will need to sync the blockchain from scratch each time you launch a container.

To keep your blockchain data between container restarts or upgrades, simply add the `-v` option to create a [data volume](https://docs.docker.com/engine/tutorials/dockervolumes/):

### Using bitcoin-cli

By default, Docker runs all containers on a private bridge network. This means that you are unable to access the RPC port (8332) necessary to run `bitcoin-cli` commands.

There are several methods to run `bitclin-cli` against a running `bitcoind` container. The easiest is to simply let your `bitcoin-cli` container share networking with your `bitcoind` container:

If you plan on exposing the RPC port to multiple containers (for example, if you are developing an application which communicates with the RPC port directly), you probably want to consider creating a [user-defined network](https://docs.docker.com/engine/userguide/networking/). You can then use this network for both your `bitcoind` and `bitclin-cli` containers, passing `-rpcconnect` to specify the hostname of your `bitcoind` container:

### License

Configuration files and code in this repository are distributed under the [MIT license](/LICENSE).


