function make_lnd_conf {
file="$HOME/.lnd/lnd.conf"

source $HOME/.bitcoin/bitcoin.conf

get_extIP >/dev/null 2>&1

if grep -q "lnddocker" $ic || [[ $install == lnddocker ]] ; then
customHOME=/home/parman
else
customHOME=$HOME
fi

if [[ -z $ipcore ]] ; then ipcore="127.0.0.1"
else
    if [[ -n $remote_user ]] && [[ -n $remote_pass ]] ; then
        rpcuser=$remote_user
        rpcpassword=$remote_pass
    else
        announce "Unexpected absence of remote user/pass values. Using defaults instead."
    fi 
fi

echo "
; LND conf configuration, message added by Parmanode, from version 3.38.0

; It is recommended that you do not edit this file because its state is
; anticpated by Parmanode, and used to make the configuration options
; available in the menus work properly. Modify at your own risk.
;
; exteranlhosts & externalip is what LND advertises for connections with domain or IP
;
; tlsextradomain anbd tls extraip are used to specify additional domains 
; that should be included in the TLS certificate's SAN (Subject Alternative Name) 
; field.

[Application Options]

tlsextraip=0.0.0.0
externalip=$extIP:$lnd_port
tlsautorefresh=true
adminmacaroonpath=~/.lnd/data/chain/bitcoin/mainnet/admin.macaroon
readonlymacaroonpath=~/.lnd/data/chain/bitcoin/mainnet/readonly.macaroon
invoicemacaroonpath=~/.lnd/data/chain/bitcoin/mainnet/invoice.macaroon
listen=0.0.0.0:9735
rpclisten=0.0.0.0:10009
restlisten=0.0.0.0:8080
maxpendingchannels=2
; wallet-unlock-password-file=$customHOME/.lnd/password.txt
; wallet-unlock-allow-create=true
minchansize=200000
alias=$alias

[Bitcoin]
bitcoin.active=true
bitcoin.mainnet=true
bitcoin.node=bitcoind
bitcoin.defaultchanconfs=3
bitcoin.basefee=5000
bitcoin.feerate=50

[Bitcoind]

; these two settings not needed if using rpc and zmq
; bitcoind.dir=~/.bitcoin 
; bitcoind.config=~/.bitcoin/bitcoin.conf

bitcoind.rpcuser=$rpcuser
bitcoind.rpcpass=$rpcpassword
bitcoind.zmqpubrawblock=tcp://$ipcore:28332
bitcoind.zmqpubrawtx=tcp://$ipcore:28333

; default here can be changed, 'bitcoind.rpchost=localhost'
bitcoind.rpchost=$ipcore

[autopilot]

[watchtower]

[wtclient]

[healthcheck]

[signrpc]

[walletrpc]

[chainrpc]

[routerrpc]

[workers]


[caches]

[protocol]

protocol.wumbo-channels=true

[db]

[etcd]

[postgres]


; Postgres connection string.
; db.postgres.dsn=postgres://lnd:lnd@localhost:45432/lnd?sslmode=disable

; Postgres connection timeout. Valid time units are {s, m, h}. Set to zero to
; disable.
; db.postgres.timeout=

; Postgres maximum number of connections. Set to zero for unlimited. It is
; recommended to set a limit that is below the server connection limit.
; Otherwise errors may occur in lnd under high-load conditions.
; db.postgres.maxconnections=

[bolt]

; If true, prevents the database from syncing its freelist to disk. 
; db.bolt.nofreelistsync=1

; Whether the databases used within lnd should automatically be compacted on
; every startup (and if the database has the configured minimum age). This is
; disabled by default because it requires additional disk space to be available
; during the compaction that is freed afterwards. In general compaction leads to
; smaller database files.
; db.bolt.auto-compact=true

; How long ago the last compaction of a database file must be for it to be
; considered for auto compaction again. Can be set to 0 to compact on every
; startup. (default: 168h)
; db.bolt.auto-compact-min-age=0

; Specify the timeout to be used when opening the database.
; db.bolt.dbtimeout=60s


[cluster]

[rpcmiddleware]

rpcmiddleware.enable=true

[remotesigner]

[gossip]

[invoices]

[routing]

[sweeper]
" | tee $file >/dev/null 2>&1

if [[ $bitcoin_choice_with_lnd == local ]] \
&& [[ $install == lnddocker ]] && [[ $OS == Mac ]] ; then
sudo gsed -i "/bitcoind.zmqpubrawblock=/c\bitcoind.zmqpubrawblock=tcp:\/\/host.docker.internal:28332" $file
sudo gsed -i "/bitcoind.zmqpubrawtx=/c\bitcoind.zmqpubrawtx=tcp:\/\/host.docker.internal:28333" $file
fi
} 