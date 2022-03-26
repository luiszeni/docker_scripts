#$1 image id
#$2 container name
#$3 path to work directory in host machine  /src:/dest

if [ ! $3 ]
then
	echo "usage"
	echo "p1 image id"
	echo "p2 container name"
	echo "optional:"
	echo "p3 path to work directory in host machine  /src:/dest"
	echo "p4 path to work directory in host machine  /src:/dest"
else

	SERV_L=~/.docker_X
	DOCKER_L=/root/.docker_X

	XAUTH=$SERV_L"/docker.xauth"
	XAUT_CONT=$DOCKER_L"/docker.xauth"

	XREFRESH=$SERV_L"/refresh_x.sh"

	echo $SERV_L $DOCKER_L $XAUTH $XAUT_CONT

	xauth nlist $DISPLAY | sed -e 's/^..../ffff/' | xauth -f $XAUTH nmerge -
	chmod 700 $XAUTH

	X11PORT=`echo $DISPLAY | sed 's/^[^:]*:\([^\.]\+\).*/\1/'`
	DISPLAY=`echo $DISPLAY | sed 's/^[^:]*\(.*\)/172.17.0.1\1/'`

	printf "echo 'Updating Display to $DISPLAY'\nexport DISPLAY=$DISPLAY\nexport XAUTHORITY=$XAUT_CONT\n" >$XREFRESH

	if [ $3 ]
	  then
		
		if [ $4 ]
	  		then
	  			echo -e "--Creating machine: $2\nFrom image: $1\nWith link: $3 and $4"
				docker run  -p $4 --expose 5000 --gpus all -v $3 --shm-size 16G -ti --name $2 -v /home/zeni/.nv:/root/.nv -v $SERV_L:$DOCKER_L -e DISPLAY=$DISPLAY  -e XAUTHORITY=$XAUT_CONT $1 
			else
				echo -e "Creating machine: $2\nFrom image: $1\nWith link: $3"
				docker run --gpus all -v $3 --shm-size 16G -ti --name $2 -v $SERV_L:$DOCKER_L -e DISPLAY=$DISPLAY -e XAUTHORITY=$XAUT_CONT $1 

		fi
	   else
	  	echo -e "Creating machine: $2\nFrom image: $1\nWithout link"
	    docker run --gpus all --shm-size 16G -ti --name $2 -v $SERV_L:$DOCKER_L -e DISPLAY=$DISPLAY -e XAUTHORITY=$XAUT_CONT $1 
	fi

	echo "removing xauth files"
	rm $XAUTH
	rm $XREFRESH
fi


# #--shm-size 8G to the docker run command seems to be the trick as mentioned here. Let me fully test it, if solved I'll close issue.
