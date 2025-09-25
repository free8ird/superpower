# Docker Configuration for Fish Shell
# This file contains both docker aliases and abbreviations consolidated

# =============================================================================
# DOCKER ABBREVIATIONS (expandable shortcuts)
# =============================================================================

# Basic docker commands
abbr -a d docker
abbr -a di docker images
abbr -a dps docker ps
abbr -a dpsa docker ps -a
abbr -a dv docker volume ls
abbr -a dn docker network ls

# Container operations
abbr -a dr docker run
abbr -a dri docker run -it
abbr -a drm docker rm
abbr -a dstart docker start
abbr -a dstop docker stop
abbr -a drestart docker restart
abbr -a dkill docker kill

# Image operations
abbr -a drmi docker rmi
abbr -a dbuild docker build
abbr -a dpull docker pull
abbr -a dpush docker push
abbr -a dtag docker tag

# Container interaction
abbr -a dexec docker exec -it
abbr -a dlogs docker logs
abbr -a dlogsf docker logs -f
abbr -a dinspect docker inspect
abbr -a dstats docker stats

# System operations
abbr -a dprune docker system prune
abbr -a dprunea docker system prune -a
abbr -a dvprune docker volume prune
abbr -a diprune docker image prune
abbr -a dnprune docker network prune

# Docker Compose abbreviations
abbr -a dc docker-compose
abbr -a dcu docker-compose up
abbr -a dcud docker-compose up -d
abbr -a dcd docker-compose down
abbr -a dcb docker-compose build
abbr -a dcr docker-compose restart
abbr -a dcl docker-compose logs
abbr -a dclf docker-compose logs -f
abbr -a dce docker-compose exec
abbr -a dcp docker-compose ps

# =============================================================================
# DOCKER ALIASES (direct command replacements)
# =============================================================================

# System information
alias ddf 'docker system df'  # Show docker disk usage
alias dinfo 'docker info'
alias dversion 'docker version'

# Container management
alias drma 'docker rm (docker ps -aq)'  # Remove all containers
alias drmaf 'docker rm -f (docker ps -aq)'  # Force remove all containers
alias dstopall 'docker stop (docker ps -q)'  # Stop all running containers

# Image management
alias drmia 'docker rmi (docker images -q)'  # Remove all images
alias drmiaf 'docker rmi -f (docker images -q)'  # Force remove all images
alias drmid 'docker rmi (docker images -q --filter dangling=true)'  # Remove dangling images

# Network operations
alias dnetls 'docker network ls'
alias dnetinspect 'docker network inspect'
alias dnetcreate 'docker network create'
alias dnetrm 'docker network rm'

# Volume operations
alias dvolls 'docker volume ls'
alias dvolinspect 'docker volume inspect'
alias dvolcreate 'docker volume create'
alias dvolrm 'docker volume rm'

# Utility functions
alias dcleanc 'docker rm (docker ps -aq --filter status=exited)'  # Remove stopped containers
alias dcleani 'docker rmi (docker images -q --filter dangling=true)'  # Remove dangling images
alias dips 'docker inspect --format="{{.Name}} - {{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}" (docker ps -q)'  # Show container IPs

# Docker Compose extended
alias dcstop 'docker-compose stop'
alias dcstart 'docker-compose start'
alias dcconfig 'docker-compose config'
alias dcpull 'docker-compose pull'
alias dcpush 'docker-compose push'
alias dcrm 'docker-compose rm'

# Development shortcuts
alias ddev 'docker-compose -f docker-compose.dev.yml'
alias dprod 'docker-compose -f docker-compose.prod.yml'
alias dtest 'docker-compose -f docker-compose.test.yml'

# Quick container access
alias dshell 'docker exec -it'
alias dbash 'docker exec -it $argv bash'
alias dsh 'docker exec -it $argv sh'

# Docker Swarm (if using swarm mode)
alias dsw 'docker swarm'
alias dswi 'docker swarm init'
alias dswj 'docker swarm join'
alias dswl 'docker swarm leave'
alias dsvc 'docker service'
alias dsvcc 'docker service create'
alias dsvcl 'docker service ls'
alias dsvcr 'docker service rm'
alias dsvcu 'docker service update'
alias dsvcps 'docker service ps'
