docker run --rm -it --name ols -p 8080:8080 --read-only --tmpfs=/tmp --tmpfs=/var/www/vhosts -v /Users/whyxn/docker-
vol/ols:/home/olsuser/lsws klovercloud/ols:latest


sudo docker run --rm -it --name ols -p 8080:8080 --read-only --tmpfs=/tmp --tmpfs=/var/www/vhosts    -v /home/arjun/Docker-vol/ols/:/home/olsuser/lsws ols_v1

----------------------------------------------------------------------------------------------------------------


#to build the docker image run
sudo docker build --build-arg PHP_VERSION=lsphp74 -t klovercloud/ols:latest .

#to change the OLS version using argument, use the commented out version of openlitespeed installation method on line 18 of DockerFile. Also remove static value of 'ARG OLS_VERSION' and installaion method on line 12.
sudo docker build --build-arg OLS_VERSION=1.6.21 --build-arg PHP_VERSION=lsphp74 -t klovercloud/ols:latest .

#run using the follwing 
sudo docker run -d --rm -it --name ols -p 8080:8080 -p 7080:7080 -p 8433:8433 --read-only --tmpfs=/tmp --tmpfs=/var/www/vhosts -v /home/arjun/Docker-vol/ols/:/home/olsuser/lsws klovercloud/ols:latest

#to check supported php version installed, run without --tmpfs=/var/www/vhosts and go to localhost:8080


