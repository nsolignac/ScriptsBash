#List all video outputs and the possible resolutions for those.

xrandr -q

#Choose the name of the output and resolution, and store it in variables.

echo "Which OUTPUT?"
read OUTPUT

echo "Which RESOLUTION?"
read RESOLUTION

#Set the resolution for the display choosen.

xrandr --output	$OUTPUT --mode $RESOLUTION

#by NS
