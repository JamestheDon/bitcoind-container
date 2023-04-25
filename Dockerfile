## bitcoind setup
FROM ubuntu:latest

## Dependencies; git, make 
RUN apt-get update && \
    apt-get install -y git build-essential libtool autotools-dev automake pkg-config bsdmainutils python3 \
        libevent-dev libboost-dev libsqlite3-dev libzmq3-dev systemtap-sdt-dev


## Clone Bitcoin Core 
RUN git clone https://github.com/bitcoin/bitcoin.git && \
    cd bitcoin && \
    git checkout v24.0.1 && \
    ./autogen.sh && \
    ./configure --without-gui && \
    make -j $(nproc) && \
    make install

RUN mkdir /data 

RUN echo "datadir=/data" >> /bitcoin/bitcoin.conf && \
    echo "testnet=1" >> /bitcoin/bitcoin.conf && \
    echo "rpcuser=turtle" >> /bitcoin/bitcoin.conf && \
    echo "rpcpassword=notmypassword" >> /bitcoin/bitcoin.conf && \
    echo "[test]" >> /bitcoin/bitcoin.conf && \
    echo "rpcport=18334" >> /bitcoin/bitcoin.conf && \
    echo "rpcbind=127.0.0.1" >> /bitcoin/bitcoin.conf && \
    echo "rpcallowip=127.0.0.1" >> /bitcoin/bitcoin.conf

    


EXPOSE 8332 8333

CMD ["bitcoind", "-testnet"]