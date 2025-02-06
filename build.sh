#!/bin/bash
echo 'Build image'
docker build -f -t ghcr.io/nobitacnt/image-php-octane .
docker tag ghcr.io/nobitacnt/image-php-octane ghcr.io/nobitacnt/image-php-octane
docker push ghcr.io/nobitacnt/image-php-octane
