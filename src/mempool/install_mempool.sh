function install_mempool {
if [[ $mem_debug == "t" ]] ; then
echo "debug point 1. Hit enter to continue."
read
fi

if [[ -z $test ]] ; then
if ! grep -q bitcoin-end < $HOME/.parmanode/installed.conf ; then
announce "Need to install Bitcoin first from Parmanode menu. Aborting." ; return 1 ; fi
fi

if [[ $mem_debug == "t" ]] ; then
echo "debug point 2. Hit enter to continue."
read
fi

if ! docker ps >/dev/null ; then announce "Please install Docker first from Parmanode Add/Other menu, and START it. Aborting." ; return 1 ; fi
sned_sats
source $bc
if [[ $txindex != 1 ]] ; then clear ; echo "
    Sorry, txindex=1 needs to be in the bitcoin.conf file for Mempool to work.
    Type 'yolo' and <enter> to ignore warning, otherwise aborting."
    read choice
    if [[ $choice != yolo ]] ; then debug "not yolo" ; return 1 ; fi
fi

if [[ $server != 1 ]] ; then clear ; echo "
    Sorry, server=1 needs to be in the bitcoin.conf file for Mempool to work.
    Type 'yolo' and <enter> to ignore warning, otherwise aborting."
    read choice
    if [[ $choice != yolo ]] ; then return 1 ; fi
fi
debug "pause1"
# INTRO

cd $hp
git clone https://github.com/mempool/mempool.git
install_conf_add "mempool-start"
#make sure mounted dir permission is correct (Pi is not 1000:1000, so these dir's will not be readable by container.)
sudo chown -R 1000:1000 $hp/mempool/docker/data $hp/mempool/docker/mysql >/dev/null
installed_config_add "mempool-start"
debug "pause2"
#set variables
make_mempool_docker_compose
cp /tmp/docker-compose.yml $hp/mempool/docker/docker-compose.yml
debug "/tmp/docker-compose.yml copied?"
rm /tmp/docker-compose.yml >/dev/null 2>&1
mempool_backend
#choose_mempool_LND
#choose_mempool_tor

cd $hp/mempool/docker 
docker compose up -d || debug "compose up didn't work"

#Final check to make sure the docker gatway IP is included in bitcoin.conf
if docker ps >/dev/null 2>&1 ; then

string="$(docker network inspect docker_PM_network | grep Gateway | awk '{print $2}' | tr -d ' ' | tr -d \" | cut -d \. -f 1)"
debug "string is $string"

if [[ $string != 172 ]] ; then #would be unusualy for it not to be 172

        if ! docker network inspect docker_PM_netowrk >/dev/null 2>&1 ; then 
        announce "some problem with starting the container. Aborting. Please let Parman know to fix."
        return 1
        fi

    stringIP="$(docker network inspect docker_PM_network | grep Gateway | awk '{print $2}' | tr -d ' ' | tr -d \" )"

    if [[ -n $stringIP ]] ; then
      cp $bc $dp/backup_bitcoin.conf 
      echo rpcallowip="$stringIP"/16 | sudo tee -a $bc >/dev/null 2>&1
    fi
    
    if [[ $OS == Linux ]] ; then sudo systemctl restart bitcoind.service 
    elif [[ $OS == Mac ]] ; then stop_bitcoind ; start_bitcoind 
    fi

    announce "An unusual IP address for the Docker Gateway was detected 
    (doesn't start with 172) and was addeed to bitcoin.conf as
    rpcallowip=DockerIP/16. There is a chance this could cause errors.
    A backup of bitcoin.conf has been saved to 
    $dp/backup_bitcoin.conf just in case you need to go back to it.
    Call Parman for help if you have issues (Telegram or Twitter).
    "
    restart_mempool

fi ; fi #end if docker ps

if docker ps | grep -q mempool ; then
    installed_conf_add "mempool-end"
    filter_notice
    success "Mempool" "being installed"
else
announce "There was some problem with the installation. 
    You might need to uninstall and try again.
    Please let Parman know to fix."
return 1
fi
}
