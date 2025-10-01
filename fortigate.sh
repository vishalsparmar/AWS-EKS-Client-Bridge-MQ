#!/bin/bash
echo "=== Identifying Limit Type ==="

# Test 1: Session Count Limit
echo "1. Session Count Test:"
( nc -v mainframe.company.com 1414 >/dev/null 2>&1 & )
( nc -v mainframe.company.com 1414 >/dev/null 2>&1 & )
( nc -v mainframe.company.com 1414 >/dev/null 2>&1 & )
sleep 2
nc -zv mainframe.company.com 1414 && echo "  ✓ 4th connection worked" || echo "  ✗ 4th connection failed"

# Test 2: Rate Limit  
echo "2. Rate Limit Test:"
for i in {1..5}; do
  nc -zv mainframe.company.com 1414 2>&1 | grep -q "succeeded" && echo "  ✓" || echo "  ✗"
done

# Test 3: Source IP Limit
echo "3. Source IP Limit Test:"
# Test from different source ports
for port in 50000 50001 50002; do
  nc -p $port -zv mainframe.company.com 1414 2>&1 | grep -q "succeeded" && echo "  Port $port: ✓" || echo "  Port $port: ✗"
done
