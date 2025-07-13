package com.example.eureka_server;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.cloud.netflix.eureka.server.EnableEurekaServer;

/**
 * Eureka Server Application for Reddit Clone
 *
 * This is the main entry point for the Service Discovery server.
 * All microservices will register with this server.
 */
@SpringBootApplication
@EnableEurekaServer
public class EurekaServerApplication {

	public static void main(String[] args) {
		SpringApplication.run(EurekaServerApplication.class, args);

		System.out.println("🚀 Eureka Server started successfully!");
		System.out.println("📊 Dashboard available at: http://localhost:8761");
		System.out.println("🔐 Login: admin / admin123");
	}
}