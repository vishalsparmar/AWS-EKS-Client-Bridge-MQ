#!/bin/bash
KONNECT_REGION="us"  # or "eu", "au"
KONNECT_TOKEN="your-personal-access-token"
CONTROL_PLANE_ID="your-control-plane-id"
OUTPUT_DIR="konnect-export-$(date +%Y%m%d_%H%M%S)"

mkdir -p $OUTPUT_DIR

# Export services
curl -s -H "Authorization: Bearer $KONNECT_TOKEN" \
  "https://$KONNECT_REGION.api.konghq.com/v2/control-planes/$CONTROL_PLANE_ID/core/entities/services" \
  | jq '.' > "$OUTPUT_DIR/services.json"

# Export routes  
curl -s -H "Authorization: Bearer $KONNECT_TOKEN" \
  "https://$KONNECT_REGION.api.konghq.com/v2/control-planes/$CONTROL_PLANE_ID/core/entities/routes" \
  | jq '.' > "$OUTPUT_DIR/routes.json"

# Export plugins
curl -s -H "Authorization: Bearer $KONNECT_TOKEN" \
  "https://$KONNECT_REGION.api.konghq.com/v2/control-planes/$CONTROL_PLANE_ID/core/entities/plugins" \
  | jq '.' > "$OUTPUT_DIR/plugins.json"

echo "Konnect export completed in: $OUTPUT_DIR"
