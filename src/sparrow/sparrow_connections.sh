function sparrow_fulcrumtor {

if ! which tor >$dn 2>&1 ; then
announce \
"Please install Tor first"
return 1
fi

if ! grep -q "fulcrum-end" $ic ; then
announce \
"Please install Fulcrum first."
return 1
fi

if ! grep -q "fulcrum_tor" $pc ; then
announce \
"Please enable TOR in Fulcrum menu first."
return 1 
fi


set_terminal
echo "If Sparrow is running, make sure to shut it down before proceeding."
enter_continue
rm $HOME/.sparrow/config
make_sparrow_config "fulcrumtor"
}

function sparrow_electrstor {

if ! which tor >$dn 2>&1 ; then
announce \
"Please install Tor first"
return 1
fi

if ! grep -q "electrs-end" $ic && ! grep -q "electrsdkr" $ic ; then
announce \
"Please install electrs first."
return 1 
fi

if ! grep -q "electrs_tor" $pc ; then
announce \
"Please enable TOR in electrs menu first."
return 1
fi


set_terminal
echo "If Sparrow is running, make sure to shut it down before proceeding."
enter_continue
rm $HOME/.sparrow/config
make_sparrow_config "electrstor"
}

function sparrow_fulcrumtcp {
set_terminal
echo "If Sparrow is running, make sure to shut it down before proceeding."
enter_continue
rm $HOME/.sparrow/config
make_sparrow_config "fulcrumtcp"
}

function sparrow_electrs {

set_terminal
echo "If Sparrow is running, make sure to shut it down before proceeding."
enter_continue
rm $HOME/.sparrow/config
make_sparrow_config "electrstcp"
}
function sparrow_fulcrumssl {
set_terminal
echo "If Sparrow is running, make sure to shut it down before proceeding."
enter_continue
rm $HOME/.sparrow/config
make_sparrow_config "fulcrumssl"
}

function sparrow_core {
set_terminal
echo "If Sparrow is running, make sure to shut it down before proceeding."
enter_continue
rm $HOME/.sparrow/config
make_sparrow_config
}
