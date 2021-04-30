docker run --rm -it --name ols -p 8080:8080 --read-only --tmpfs=/tmp --tmpfs=/var/www/vhosts -v /Users/whyxn/docker-
vol/ols:/home/olsuser/lsws klovercloud/ols:latest