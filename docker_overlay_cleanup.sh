## Docker Overlay FS Cleanup
## SOURCE: https://forums.docker.com/t/some-way-to-clean-up-identify-contents-of-var-lib-docker-overlay/30604/29

cd /var/lib/docker/overlay2

ls | xargs -I {} du -shx {}

# Go into the largest directory and then the associated diff directory
cd $LARGEST_DIRECTORY

ls | xargs -I {} du -shx {}