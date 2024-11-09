function make_fulcrum_config {
source $bc >/dev/null 2>&1

#remove later, it's at the start of new_install_fulcrum
if [[ -z $rpcuser ]] ; then #from parmanode.conf 
    announce "Please set a username and password in Bitcoin conf. You can do that from the
    \r    Parmanode-Bitcoin menu. Aborting. " ; return 1 
fi

# set datadir variable
    if [[ $drive_fulcrum == "external" ]] ; then #works Linux and Mac
    datadir="$parmanode_drive/fulcrum_db" 
    fi

    if [[ $drive_fulcrum == "internal" ]] ; then
    datadir="$HOME/.fulcrum_db"
    fi

if [[ $computer_type == Pi ]] ; then fastsync=0 ; else fastsync=1000 ; fi

if [[ $fulcrumdocker == "true" ]] ; then local bitcoinIP="host.docker.internal" ; else local bitcoinIP="127.0.0.1" ; fi


echo "fast-sync = $fastsync 
datadir = $datadir
bitcoind = $bitcoinIP:8332
ssl = 0.0.0.0:50002
tcp = 0.0.0.0:50001
cert = $HOME/parmanode/fulcrum/cert.pem
key = $HOME/parmanode/fulcrum/key.pem
rpcuser = $rpcuser
rpcpassword = $rpcpassword
peering = false " | sudo tee -a $fc >$dn 2>&1

return 0
}