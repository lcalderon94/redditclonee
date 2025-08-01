package com.example.api_gateway;

import org.springframework.cloud.gateway.route.RouteLocator;
import org.springframework.cloud.gateway.route.builder.RouteLocatorBuilder;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
public class GatewayConfig {

    @Bean
    public RouteLocator customRouteLocator(RouteLocatorBuilder builder) {
        return builder.routes()
                // Health check route - no auth required
                .route("health-route", r -> r
                        .path("/health", "/actuator/health")
                        .uri("http://localhost:8080"))

                // Fallback route
                .route("fallback-route", r -> r
                        .path("/fallback")
                        .uri("forward:/fallback"))

                // Public routes - no auth required
                .route("public-auth-routes", r -> r
                        .path("/api/auth/login", "/api/auth/signup", "/api/auth/oauth2/**")
                        .uri("lb://auth-service"))

                // Protected routes - require authentication
                .route("protected-routes", r -> r
                        .path("/api/**")
                        .and()
                        .not(p -> p.path("/api/auth/login", "/api/auth/signup", "/api/auth/oauth2/**"))
                        .filters(f -> f
                                .filter(new AuthenticationFilter())
                                .filter(new LoggingFilter()))
                        .uri("no://op"))

                .build();
    }
}