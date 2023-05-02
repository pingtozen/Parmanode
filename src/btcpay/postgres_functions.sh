
# start postgress, create parman database user with script, create 2 databases.

function startup_postgres {
#docker exec -d -u root btcpay /bin/bash -c \
#"sed -i 's/md5/trust/g' /etc/postgresql/*/main/pg_hba.conf" # i for in-place, s for substitute, g for global, find 1 replace with stirng 2

docker exec -d -u root btcpay /bin/bash -c "service postgresql start" 
postgres_intermission || return 1
}


# config file: /etc/postgresql/13/main/pg_hba.conf 

#docker exec -d -u root btcpay /bin/bash -c \
#"echo \"
#local   all             postgres                                peer
#local   all             all                                     peer
#host    all             all             127.0.0.1/32            trust
#host    all             all             ::1/128                 trust
#local   replication     all                                     peer
#host    replication     all             127.0.0.1/32            md5
#host    replication     all             ::1/128                 md5
#" | tee /etc/postgresql/*/main/pg_hba.conf >/dev/null"


function postgres_intermission {
set_terminal

counter=0
while [ $counter -le 5 ] ; do
postgres_database_creation

#check if database created before prceeding.

#get container to write to a log file the status of the database. Log is in a mounted volume
#accessible by host.

    docker exec -it -u postgres btcpay /bin/bash -c " \
    echo \"$(psql -l | grep btcpayserver)\" >/home/parman/.docker/database_running.log"

wait 2

#check if container wrote to the log file (success?)
if grep "btcpayserver" >/dev/null 2>&1 $HOME/.docker/database_running.log
then return 0 ; fi

counter=$((counter + 1))

done

log "btcpay" "failed to start btcpay database"
set_terminal
echo "Docker was unable to start the btcpay postgress database. Installation has failed."
enter_continue
return 1
}


function postgres_database_creation {

sleep 1
docker exec -d -u postgres btcpay /bin/bash -c \
"/home/parman/parmanode/postgres_script.sh ; \
createdb -O parman btcpayserver ; \
createdb -O parman nbxplorer" 

}