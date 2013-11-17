#!/bin/bash

# Figure out what the last comic is
NUM="$(curl http://xkcd.com/ | grep Permanent | cut -d ' ' -f6 | cut -d '/' -f4)"

# Set the image
IMG='http://imgs.xkcd.com/comics/'

# Get the whole site
wget --recursive --page-requisites --convert-links http://xkcd.com/

# Change directories to xkcd.com
cd xkcd.com

# Load the xkcd logo
mkdir img
cd img
wget http://imgs.xkcd.com/static/terrible_small_logo.png
cd ..

# Create the comic folder
mkdir comics

# Loop through them all to fix the few things that didn't change
for i in `seq 1 $NUM`
do
    if [ $i != 404 ]
	then

	cd $i
	sed 's/http:\/\/imgs.xkcd.com\/static\//..\/imgs\//' < index.html > new.html
	rm index.html && mv new.html index.html
	
	NAME=$(cat index.html | grep comics | cut -d '=' -f1)
	NAME=(`echo $NAME | cut -d ':' -f3 | cut -d '/' -f5`)
	
	sed 's/http:\/\/imgs.xkcd.com\/comics\//..\/comics\//g' < index.html > new.html
	rm index.html && mv new.html index.html
	cd ../comics/
	wget $IMG$NAME
	cd ..
    fi
done