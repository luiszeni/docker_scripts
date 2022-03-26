echo "Starting this docker machine: -> "$1

SERV_L=~/.docker_X
DOCKER_L=/root/.docker_X

XAUTH=$SERV_L"/docker.xauth"
XAUT_CONT=$DOCKER_L"/docker.xauth"

XREFRESH=$SERV_L"/refresh_x.sh"


xauth nlist $DISPLAY | sed -e 's/^..../ffff/' | xauth -f $XAUTH nmerge -
chmod 700 $XAUTH

X11PORT=`echo $DISPLAY | sed 's/^[^:]*:\([^\.]\+\).*/\1/'`
DISPLAY=`echo $DISPLAY | sed 's/^[^:]*\(.*\)/172.17.0.1\1/'`

printf "echo 'Updating Display to $DISPLAY'\nexport DISPLAY=$DISPLAY\nexport XAUTHORITY=$XAUT_CONT\n" >$XREFRESH

docker start -ai $1 

echo "removing xauth files"
rm $XAUTH
rm $XREFRESH