apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: your-service-ingress
  namespace: your-namespace
  annotations:
    # ALB Controller specific
    kubernetes.io/ingress.class: alb
    alb.ingress.kubernetes.io/scheme: internal  # or internet-facing
    alb.ingress.kubernetes.io/target-type: ip   # or instance
    
    # Health check settings
    alb.ingress.kubernetes.io/healthcheck-protocol: HTTP
    alb.ingress.kubernetes.io/healthcheck-port: traffic-port
    alb.ingress.kubernetes.io/healthcheck-path: /health
    alb.ingress.kubernetes.io/healthcheck-interval-seconds: "30"
    alb.ingress.kubernetes.io/healthcheck-timeout-seconds: "5"
    alb.ingress.kubernetes.io/healthy-threshold-count: "2"
    alb.ingress.kubernetes.io/unhealthy-threshold-count: "2"
    
    # SSL/TLS (if using HTTPS)
    alb.ingress.kubernetes.io/listen-ports: '[{"HTTP": 80}, {"HTTPS": 443}]'
    alb.ingress.kubernetes.io/certificate-arn: arn:aws:acm:region:account:certificate/id
    
    # Security groups
    alb.ingress.kubernetes.io/security-groups: sg-xxxxxxx
    
    # Subnet configuration
    alb.ingress.kubernetes.io/subnets: subnet-xxxxxx,subnet-yyyyyy
    
spec:
  rules:
  - host: your-service.your-namespace.your-domain.com
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: your-service
            port:
              number: 8080
