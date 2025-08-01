package com.example.api_gateway;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.cloud.gateway.filter.GatewayFilter;
import org.springframework.cloud.gateway.filter.GatewayFilterChain;
import org.springframework.http.server.reactive.ServerHttpRequest;
import org.springframework.http.server.reactive.ServerHttpResponse;
import org.springframework.stereotype.Component;
import org.springframework.web.server.ServerWebExchange;
import reactor.core.publisher.Mono;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

@Component
class LoggingFilter implements GatewayFilter {

    private static final Logger logger = LoggerFactory.getLogger(LoggingFilter.class);
    private static final DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");

    @Override
    public Mono<Void> filter(ServerWebExchange exchange, GatewayFilterChain chain) {
        ServerHttpRequest request = exchange.getRequest();
        String timestamp = LocalDateTime.now().format(formatter);

        // Log incoming request
        logger.info("🌐 [{}] {} {} from {} - User-Agent: {}",
                timestamp,
                request.getMethod(),
                request.getURI(),
                getClientIP(request),
                request.getHeaders().getFirst("User-Agent"));

        // Log request headers for debugging
        if (logger.isDebugEnabled()) {
            request.getHeaders().forEach((name, values) ->
                    logger.debug("📥 Header: {} = {}", name, values));
        }

        long startTime = System.currentTimeMillis();

        return chain.filter(exchange).then(Mono.fromRunnable(() -> {
            ServerHttpResponse response = exchange.getResponse();
            long duration = System.currentTimeMillis() - startTime;

            // Log response
            logger.info("📤 [{}] Response: {} - Duration: {}ms - Size: {} bytes",
                    timestamp,
                    response.getStatusCode(),
                    duration,
                    response.getHeaders().getFirst("Content-Length"));

            // Log slow requests
            if (duration > 1000) {
                logger.warn("🐌 Slow request detected: {} {} took {}ms",
                        request.getMethod(), request.getURI(), duration);
            }
        }));
    }

    private String getClientIP(ServerHttpRequest request) {
        String xForwardedFor = request.getHeaders().getFirst("X-Forwarded-For");
        if (xForwardedFor != null && !xForwardedFor.isEmpty()) {
            return xForwardedFor.split(",")[0].trim();
        }

        String xRealIP = request.getHeaders().getFirst("X-Real-IP");
        if (xRealIP != null && !xRealIP.isEmpty()) {
            return xRealIP;
        }

        return request.getRemoteAddress() != null ?
                request.getRemoteAddress().getAddress().getHostAddress() : "unknown";
    }
}