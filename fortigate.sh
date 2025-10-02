bash
# Get service cluster IP
kubectl get svc other-service-name -o wide

# Test connectivity to cluster IP
curl http://<cluster-ip>:<port>
8. Immediate Diagnostic Script

Create this script to run in your pod:

bash
#!/bin/bash
SERVICE_NAME="other-service-name"
NAMESPACE="other-namespace"
PORT="8080"

echo "=== Network Diagnostic ==="

# 1. Test DNS resolution
echo "1. DNS Resolution:"
nslookup $SERVICE_NAME
nslookup $SERVICE_NAME.$NAMESPACE.svc.cluster.local

# 2. Test basic connectivity
echo "2. Ping Test:"
ping -c 3 $SERVICE_NAME
ping -c 3 $SERVICE_NAME.$NAMESPACE.svc.cluster.local

# 3. Test port connectivity
echo "3. Port Test:"
nc -zv $SERVICE_NAME $PORT
nc -zv $SERVICE_NAME.$NAMESPACE.svc.cluster.local $PORT

# 4. Test HTTP
echo "4. HTTP Test:"
curl -v --connect-timeout 10 http://$SERVICE_NAME:$PORT/health
curl -v --connect-timeout 10 http://$SERVICE_NAME.$NAMESPACE.svc.cluster.local:$PORT/health
9. Most Likely Causes

Wrong service name (65% probability)
NetworkPolicy blocking (20% probability)
Service not running/no endpoints (10% probability)
Wrong port (5% probability)
Run This Immediately:

bash
# From your pod, run:
nslookup other-service-name
curl -v http://other-service-name.other-namespace.svc.cluster.local:8080/health
The nslookup will tell you if DNS is working, and curl will show you exactly where the connection is failing.
