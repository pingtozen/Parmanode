function ParmanodL_write {
# dd the image to microSD 


if [[ $OS == Linux ]] ; then
sudo umount -f ${disk}* || sudo umount -f /dev/${disk}* 
debug "after umount"
please_wait
sudo dd if="${image_path}" of="${disk_no_part}" bs=2000000 status=progress 
fi

if [[ $OS == Mac ]] ; then
sudo diskutil unmountDisk /dev/${disk} || sudo diskutil unmountDisk force /dev/${disk}
clear
echo "
Flashing the drive with Parmanode OS. This can take a weirdly long
time with no screen feedback, probably more than 10 minutes. 

Let this be a lesson that you should have been using Linux :P

To get a status snapshot, you can hit <control> T, as many times
as you like.

Please wait...

"
sudo dd if="${image_path}" of="${disk_no_part}" bs=2000000 
fi
# will change to dcfldd soon
sync

echo -e "
If there was an error, this is a chance to do stuff in a different
terminal to fix it, then try again. On Macs, it might be that the
unmount function failed, or the drive remounted automatically. 
Unfortunately, right-click ejecting causes problems - do this instead: 
$yellow
    diskutil unmountDisk $disk_no_part
$orange
Options
    $cyan <enter>$orange to continue (everything seems to have worked)
    $cyan r$orange then$cyan <enter>$orange to repeat the 'dd' command 
    $cyan x$orange then$cyan <enter>$orange to abort

    If you abort, you can try to flash the image file yourself using a
    tool like Balena Etcher. Get it from $pink
    https://etcher.balena.io/ $orange
    The file you need to flash has been saved. Find it here $pink
    $HOME/ParmanodL/
    $orange"
    
read choice ; set_terminal
case $choice in
r) ParmanodL_write ;;
x) return 1 ;;
*) return 0 ;;
esac
}
