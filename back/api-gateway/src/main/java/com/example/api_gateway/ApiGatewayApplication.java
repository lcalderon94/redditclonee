package com.example.api_gateway;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.cloud.client.discovery.EnableDiscoveryClient;

@SpringBootApplication
@EnableDiscoveryClient
public class ApiGatewayApplication {

	public static void main(String[] args) {
		SpringApplication.run(ApiGatewayApplication.class, args);

		System.out.println("🚀 API Gateway started successfully!");
		System.out.println("🌐 Gateway available at: http://localhost:8080");
		System.out.println("📊 Health Check: http://localhost:8080/actuator/health");
		System.out.println("📈 Metrics: http://localhost:8080/actuator/prometheus");
		System.out.println("🔐 Routes: All /api/** requests will be routed to microservices");
	}
}