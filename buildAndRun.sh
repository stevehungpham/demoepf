
mvn clean package

docker build -t stevehungpham/demoepf .

docker run -it --rm -p 8088:8088 stevehungpham/demoepf 
