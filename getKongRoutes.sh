# Quick export of just services and routes
KONNECT_TOKEN="your-token" CONTROL_PLANE_ID="your-cp-id"; \
curl -s -H "Authorization: Bearer $KONNECT_TOKEN" \
  "https://us.api.konghq.com/v2/control-planes/$CONTROL_PLANE_ID/core/entities/services" | jq '.data[] | {name, host, port}' > services.json && \
curl -s -H "Authorization: Bearer $KONNECT_TOKEN" \
  "https://us.api.konghq.com/v2/control-planes/$CONTROL_PLANE_ID/core/entities/routes" | jq '.data[] | {name, paths, hosts}' > routes.json
