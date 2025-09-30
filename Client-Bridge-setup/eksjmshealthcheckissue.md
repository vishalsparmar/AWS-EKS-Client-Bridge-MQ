Immediate Fix - Separate Health Check Logic

1. Create a SIMPLE Health Check

java
@Component
public class SimpleHealthIndicator implements HealthIndicator {
    
    @Override
    public Health health() {
        // Just return UP immediately - no MQ checks
        return Health.up()
            .withDetail("status", "Application running")
            .withDetail("timestamp", System.currentTimeMillis())
            .build();
    }
}
2. Disable Complex Health Checks Temporarily

yaml
management:
  endpoint:
    health:
      enabled: true
      probes:
        enabled: true
  health:
    defaults:
      enabled: false    # Disable default health checks
    diskspace:
      enabled: false    # Disable disk space check
    ping:
      enabled: true     # Keep only simple ping
3. Or Use Liveness/Readiness Separation

yaml
management:
  endpoint:
    health:
      probes:
        enabled: true
  health:
    livenessstate:
      enabled: true
    readinessstate:
      enabled: true
    # Disable all complex checks for liveness
    liveness:
      enabled: false  
    # Keep only simple checks for readiness
    readiness:
      enabled: true
      include: "ping,simpleHealth"
4. Check What Health Groups Are Enabled

bash
# Test different health endpoints
kubectl exec deployment/kms-mainframe-listener -- \
  curl -s http://localhost:8080/actuator/health/liveness

kubectl exec deployment/kms-mainframe-listener -- \
  curl -s http://localhost:8080/actuator/health/readiness

kubectl exec deployment/kms-mainframe-listener -- \
  curl -s http://localhost:8080/actuator/health
Quick Diagnostic

Check what's in your current health endpoint:

bash
kubectl exec deployment/kms-mainframe-listener -- \
  curl -s http://localhost:8080/actuator/health | jq .
Most Likely Cause

You probably have a custom HealthIndicator that's trying to check MQ connection or message status, and that check is blocking the Tomcat thread.

Immediate Solution

Add this to your application.yml right now:

yaml
management:
  endpoint:
    health:
      enabled: true
  health:
    # DISABLE all complex health checks
    db:
      enabled: false
    diskspace:
      enabled: false  
    mail:
      enabled: false
    # Enable only simple checks
    livenessstate:
      enabled: true
    readinessstate:
      enabled: true
Then check if the health endpoint responds immediately. If it does, you found the issue - one of your health checks was blocking.

