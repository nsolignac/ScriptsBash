#Path to pgrep command
rm *.jar_*

#  RHEL / CentOS 7.x httpd restart command
RESTART = "/bin/systemctl restart cmp-servicios-api"

#Path to pgrep command
PGREP = "/usr/bin/pgrep"

CMP-API = "servicios_cmp_backend.jar"

# Find process pid
$PGREP ${CMP-API}

if [ $? -ne 0 ] #If process not running
then
    # Restart it
    $RESTART
fi
