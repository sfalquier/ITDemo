package org.sfalquier.resources;

import static io.restassured.RestAssured.given;
import static io.restassured.RestAssured.when;
import static org.hamcrest.Matchers.*;

import io.restassured.RestAssured;
import org.junit.Test;

import java.util.Optional;

public class ITDemoResourceIT {

    static {
        String host = Optional.ofNullable(System.getenv("HOST")).orElse("localhost");
        int port = Integer.valueOf(Optional.ofNullable(System.getenv("PORT")).orElse("8080"));
        RestAssured.baseURI = "http://"+host;
        RestAssured.port = port;
        RestAssured.basePath = "";
    }

    @Test
    public void testSayHello() {
        when().get("/hello-world")
                .then().statusCode(200)
                .body("id", equalTo(1))
                .body("content", equalTo("Hello, Stranger!"));

        given().
                param("name", "Foo").
        when().get("/hello-world")
                .then().statusCode(200)
                .body("id", equalTo(2))
                .body("content", equalTo("Hello, Foo!"));
    }
}
