package com.sdge.si;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.EnableAutoConfiguration;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.context.annotation.ImportResource;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@SpringBootApplication
//@ImportResource({"classpath:spring/main-context.xml"})  Use for XML DSL
@ComponentScan(basePackages = {"com.sdge.si"})
@RestController
@EnableAutoConfiguration
public class Application {

    // must have a main method spring-boot can run
    public static void main(String[] args) {
        SpringApplication.run(Application.class, args);
    }

    @RequestMapping("/greetings")
    String gethelloWorld() {
        return "Hello World!";
    }
}
