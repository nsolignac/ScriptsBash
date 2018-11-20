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
FILENAME=ls . | grep "asd" | cut -d '.' -f 1

#ROOT folder cleaning
cd /appuser/multichannel/ | rm *.jar_* | mv *.jar ${FILENAME}.jar_$(date +%d-%m-%Y)

#Artifact perms
chown --reference *.jar_$(date +%d-%m-%Y) *.jar && chmod --reference *.jar_$(date +%d-%m-%Y) *.jar

#  RHEL / CentOS 7.x httpd restart command
RESTART="/bin/systemctl restart $API"

#Path to pgrep command
PGREP="/usr/bin/pgrep"

API="cups"

# Find process pid
$PGREP ${API}

if [ $? -ne 0 ] #If process not running
then
    # Restart it
    $RESTART
fi
