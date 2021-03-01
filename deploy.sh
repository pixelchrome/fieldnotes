#!/bin/sh
hugo --themesDir=../themes && rsync -avz --delete public/ admin@pixelchrome.org:/usr/local/www/pixelchrome/notes