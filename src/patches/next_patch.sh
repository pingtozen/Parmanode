function patch_7 {

#log file location has changed, delete the old one.
if grep -q "electrsdkr" $ic ; then
restart_electrs
docker exec -d electrs /bin/bash -c "rm /home/parman/run_electrs.log"
fi

#no longer needed
if grep prefersbitcoinmempool_only_ask_once $pc ; then
delete_line $ps prefersbitcoinmempool_only_ask_once >$dn 2>&1
fi


}