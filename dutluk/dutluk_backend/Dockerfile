FROM maven:3.8.4-openjdk-17
COPY . /dutluk_backend
WORKDIR /dutluk_backend
RUN mvn clean install
EXPOSE 8080
CMD ["java", "-jar", "target/dutluk_backend-0.0.1.jar"]
