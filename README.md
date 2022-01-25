# docker-helpers
Various scripts related to docker

docker_cAdvisor_run.sh : deploy cAdvisor (not used anymore)
docker_clean.sh : Remove old docker containers and docker images using https://github.com/Yelp/docker-custodian dcgc (not used, as docker has now equivalent commands)
docker_clear_log.sh : used to truncate very long docker log files, take container's name as parameter
docker_install_focal.sh : script to install docker on Ubuntu focal
docker_install_xenial.sh : script to install docker on Ubuntu focal
docker_reload_config.sh : reload docker daemon config without stopping containers
docker_ufw_rules.sh : add UFW rules for docker (with iptables disabled)
hetzner_docker_daemon.json : default docker daemon configuration (xenial)
hetzner_docker_daemon_focal.json :  default docker daemon configuration (focal)
hetzner_docker_daemon_focal_ufw_docker.json : default docker daemon configuration (focal + ufw)
list_volumes_size.sh : list the size of all docker volumes
