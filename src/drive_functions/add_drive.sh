function add_drive {

info_add_drive || return 1

detect_drive

drive_details || return 1

label_check || return 1 

if [[ $OS == "Mac" ]] ; then
    set_terminal
    echo "
########################################################################################

    The drive should be ready. If it is not mounted, disconnect and reconnect.

########################################################################################
"
enter_continue ; return 0;
fi

if [[ $OS == "Linux" ]] ; then

    if [[ ! -d /media/$(whoami)/parmanode ]] ; then sudo mkdir -p /media/$(whoami)/parmanode ; fi
    
    write_to_fstab2

sudo mount -a

set_terminal ; echo "
########################################################################################

    If you saw no errors, your drive should now be mounted.

########################################################################################
"
enter_continue
return 0
fi #end if Linux
}

    

function drive_details {
source $HOME/.parmanode/var

if [[ $OS == "Mac" ]] ; then
set_terminal
diskutil info $disk
echo "
########################################################################################

    Type yes if you think this is the correct drive to use, anything else to abort.

########################################################################################
"
read choice ; 
case $choice in yes|YES|Yes|y|Y) return 0 ;; *) return 1 ;; esac
fi

    
if [[ $OS == "Linux" ]] ; then

export $(sudo blkid -o export $disk) >/dev/null
size=$(sudo lsblk $disk --noheadings | awk '{print $4'})
echo "size=\"$size\"" >> $HOME/.parmanode/var
echo "LABEL=\"$LABEL\"" >> $HOME/.parmanode/var
echo "UUID=\"$UUID\"" >> $HOME/.parmanode/var
echo "TYPE=\"$TYPE\"" >> $HOME/.parmanode/var

echo "
########################################################################################

    DETAILS OF THE DRIVE ...

        The label is $LABEL

        The UUID is ${UUID}

        The drive size is $size

"
if [[ $1 == "after" ]] ; then
echo "
    Hit <enter> to continue
########################################################################################
" ; read ; return 0 ; fi
echo "
    Type yes if you think this is correct, anything else to abort.

########################################################################################
"
read choice
case $choice in yes|YES|Yes|y|Y) return 0 ;; *) return 1 ;; esac
fi #ends if Linux

}

function label_check {
source $HOME/.parmanode/var

if [[ $OS == "Mac" ]] ; then
    
    if cat $HOME/.parmanode/difference | grep "parmanode" ; then
    return 0 ; fi
    fi

if [[ $OS == "Linux" ]] ; then

    if [[ $LABEL == "parmanode" ]] ; then 
    return 0 ; fi
    fi

while true ; do
set_terminal ; echo "
########################################################################################

    The drive you wish to use needs to have the label, "parmanode". Go ahead and 
    have this changed now? (If there are errors here, you can rename the drive
    yourself, and return to this program to \"add\" the drive as a Parmanode drive.)

                        y)        Yes

                        n)        No (aborts)

########################################################################################
"
choose "xpq" ; read choice
set_terminal
case $choice in q|Q|Quit|QUIT|quit) exit 0 ;; p|P) return 0 ;;
y|Y|Yes|Yes|yes) break ;;
n|N|NO|No|no) return 1 ;;
*) invalid ;;
esac
done

if [[ $OS == "Linux" ]] ; then

    if [[ $TYPE == "vfat" ]] ; then sudo fatlabel $disk parmanode 
    else sudo e2label $disk parmanode >/dev/null 
    fi

    drive_details "after" ; if [ $? == 1 ] ; then return 1 ; fi
    return 0
    fi # end if Linux

if [[ $OS == "Mac" ]] ; then
    
   cat $HOME/.parmanode/difference

   echo "
######################################################################################## 

    Above are details about your drive. The Label is under the NAME column. Type it
    in exactly below (case sensitive) then hit <enter>

########################################################################################
"
read user_label 

diskutil rename "${user_label}" "parmanode"

set_terminal

if diskutil info $disk >/dev/null | grep "parmanode" ; then
    echo "    The label has been changed."
    enter_continue
    else
    echo "    There seems to be an error renaming the drive." 
    fi

fi # end if Mac
}

