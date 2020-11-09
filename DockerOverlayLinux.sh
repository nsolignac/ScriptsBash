## SOURCE: https://github.com/moby/moby/issues/29358

docker inspect $(docker ps -qa) | grep -oE '[a-f0-9]{64}' >> inspect-hashs.txt
docker inspect $(docker images -qa) | grep -oE '[a-f0-9]{64}' >> inspect-hashs.txt
ls -l /var/lib/docker/overlay > overlays.txt
grep -vxFf inspect-hashs.txt overlays.txt