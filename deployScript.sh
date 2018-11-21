# Useful links
# ------------
# https://stackoverflow.com/questions/11880070/how-to-run-a-script-as-root-in-jenkins
# https://wiki.jenkins.io/display/JENKINS/Jenkins+SSH


# TODO: make the word to search in 'grep' as a var as:
# echo "Tell me the name..."
# read WORD
# FILENAME=ls . | grep "$WORD" | cut -d '.' -f 1

# https://shapeshed.com/unix-cut/
#Store file name for further use
FILENAME=$(ls . | grep "asd" | cut -d '.' -f 1 | sort -u)

#Define root dir of the project
ROOTDIR="/home/$USER/testROOT"

#ROOT folder cleaning
cd $ROOTDIR

rm *.jar_* | mv *.jar ${FILENAME}.jar_$(date +%d-%m-%Y)

# DEPLOY
touch $FILENAME.jar

#Artifact perms
chown --reference *.jar_$(date +%d-%m-%Y) $FILENAME.jar
chmod --reference *.jar_$(date +%d-%m-%Y) $FILENAME.jar

# API var
API="$FILENAME.service"

#  RHEL / CentOS 7.x httpd restart command
RESTART="/bin/systemctl restart $API"

#Path to pgrep command
PGREP="/usr/bin/pgrep"

# Find process pid
$PGREP ${API}

if [ $? -ne 0 ] #If process not running
then
    # Restart it
    $RESTART
fi
