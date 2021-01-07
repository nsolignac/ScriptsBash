## BKP DOCKER REGISTRY SONDEOS

## DOCS:
## https://stackoverflow.com/questions/35575674/how-to-save-all-docker-images-and-copy-to-another-machine
## https://unix.stackexchange.com/questions/10026/how-can-i-best-copy-large-numbers-of-small-files-over-scp
## https://forums.docker.com/t/how-to-back-up-a-private-docker-registry-v2/30503

tar czf - <files> | ssh user@host "cd /wherever && tar xvzf -"