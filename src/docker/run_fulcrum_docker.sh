function run_fulcrum_docker {

source $HOME/.parmanode/parmanode.conf

if [[ $drive_fulcrum == "external" ]] ; then

        docker_volume_mount="/Volumes/parmanode/fulcrum_db"

        while true ; do
        if ! mountpoint -q "/Volumes/parmanode" ; then
                set_terminal ; echo "Please connect the drive. Enter to try again, (p) to return." ; read choice 
                if [[ $choice == "p" ]] ; then return 1 ; fi
                else 
                break
                fi
        done

        fi

if [[ $drive_fulcrum == "internal" ]] ; then
    docker_volume_mount="$HOME/parmanode/fulcrum_db"
    fi

docker stop fulcrum >/dev/null 2>&1
docker rm fulcrum >/dev/null 2>&1
docker rmi fulcrum >/dev/null 2>&1

docker run -d --name fulcrum \
                -p 50002:50001 \
                -p 50001:50002 \
                -p 50003:50003 \
                -v ${docker_volume_mount}:/home/parman/parmanode/fulcrum_db \
                fulcrum \
&& return 0

return 1 
}