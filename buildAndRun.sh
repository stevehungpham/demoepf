
mvn clean package

docker build -t hellomule4 .

docker run -it --rm -p 8088:8088 hellomule4 
