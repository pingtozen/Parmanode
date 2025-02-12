function menu_sparrow {
if ! grep -q "sparrow-end" $ic ; then return 0 ; fi
while true ; do 
set_terminal
unset sversion
if [[ $OS == Mac ]] ; then
sversion=$(/Applications/Sparrow.app/Contents/MacOS/Sparrow --version | grep -Eo '[0-9].+$')
else
sversion=$($hp/Sparrow/bin/Sparrow --version | grep -Eo '[0-9].+$')
fi

source $HOME/.parmanode/sparrow.connection >$dn

set_terminal_high ; echo -e "
########################################################################################
                  $cyan         Sparrow Menu -- Version $sversion                  $orange      
########################################################################################


               CURRENT SPARROW CONNECTION TYPE: $cyan$connection$orange

$green
                  (start) $orange         Start Sparrow 
$red
                  (mm)    $orange         Manage node connection...
$cyan
                  (sc)    $orange         View/Edit config file (scv for vim)
$cyan
                  (t)     $orange         Troubleshooting info
$cyan
                  (w)     $orange         Show saved wallet files
$cyan
                  (cl)    $orange         Clear connection certificates 
                           $orange         (can help connection issues)


########################################################################################
"
choose "xpmq" ; read choice 
jump $choice || { invalid ; continue ; } ; set_terminal
case $choice in 

m|M) back2main ;; q|Q|QUIT|Quit) exit 0 ;; p|P) menu_use ;; 

start|Start|START|S|s)
check_SSH || return 0
run_sparrow
return 0 ;;

mm|MM)
sparrow_connection_menu 
;;

sc|SC|Sc)
echo -e "
########################################################################################
    
        This will run Nano text editor to edit 
$cyan 
        $HOME/.sparrow/config
$orange    
        See the controls at the bottom to save and exit. Be careful messing around 
        with this file.

        Any changes will only be applied once you restart Bitcoin.
$cyan
        Note, every time you change the sparrow connection type from the Parmanode
        menu, the config file will be replaced/refeshed.
$orange
########################################################################################
"
enter_continue ; jump $enter_cont
nano $HOME/.sparrow/config
continue
;;
scv|SCV)
vim_warning ; vim $HOME/.sparrow/config
;;

t|T)
troubleshooting_sparrow
;;

cl)
clear_sparrow
;;

w|W)
set_terminal_high
echo -e "
########################################################################################


    Directory:$cyan $HOME/.sparrow/wallets/ $orange


    Files: $bright_blue

$(ls $HOME/.sparrow/wallets)

$orange
########################################################################################
"
enter_continue ; jump $enter_cont
set_terminal
;;

*)
invalid
;;

esac
done
}

function sparrow_connection_menu {
while true ; do
source $HOME/.parmanode/sparrow.connection >$dn
set_terminal
echo -e "
########################################################################################
$cyan
                            SPARROW CONNECTION OPTIONS  $orange

########################################################################################

                          
               CURRENT SPARROW CONNECTION TYPE: $cyan$connection$orange


$cyan                (d)  $orange     Bitcoin Core via tcp (default)

$cyan                (fs)   $orange   Fulcrum via ssl (port 50002)

$cyan                (ft)    $orange  Fulcrum via tcp (port 50001)

$cyan                (ftor) $orange   Fulcrum via Tor (port 7002)

$cyan                (et)    $orange  electrs via tcp (port 50005)
                
$cyan                N/A   $orange    electrs via SSL (Not available)

$cyan                (etor) $orange   electrs via Tor (port 7004) 

$cyan                (rtor) $orange   To a remote Electrum/Fulcrum server via Tor (eg a friend's)


########################################################################################
"
choose xpmq ; read choice 
jump $choice || { invalid ; continue ; } ; set_terminal
case $choice in
q|Q) exit ;; p|P) return 0 ;; m|M) back2main ;;

d|D)
sparrow_core
return 0
;;

ftor)
no_mac || return 1
sparrow_fulcrumtor
return 0
;;

etor)
no_mac || return 1
sparrow_electrstor
return 0
;;

fs)
no_mac || return 1
sparrow_fulcrumssl
return 0
;;

ft)
sparrow_fulcrumtcp
return 0
;;

rtor|Rtor|RTOR)
sparrow_remote
return 0
;;

et)
sparrow_electrs
return 0
;;

*)
invalid
;;
esac
done
}