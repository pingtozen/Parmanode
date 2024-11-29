function uninstall_X11 {
toggle_X11 "off" || return 1

if [[ $OS == "Mac" ]] && grep -q "xquartz-end" $ic ; then
yesorno "Do you also want to uninstall XQuartz?" \
  && uninstall_xquartz 
fi

installed_conf_remove "X11"
success "X11 forwarding is removed"
}
