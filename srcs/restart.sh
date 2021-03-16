#!/bin/bash
docker kill ft_server
docker rm ft_server
docker rmi ft_server
docker build -t ft_server .
docker run -it --rm -p 80:80 -p 443:443 ft_server