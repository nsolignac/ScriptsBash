#Path to pgrep command
rm *.jar_*

#  RHEL / CentOS 7.x httpd restart command
RESTART="/bin/systemctl restart cmp-servicios-api"

#Path to pgrep command
PGREP="/usr/bin/pgrep"

API="dbeaver"

# Find process pid
$PGREP ${API}

if [ $? -ne 0 ] #If process not running
then
    # Restart it
    $RESTART
fi
