#!/bin/bash
# test-client-bridge.sh

echo "Testing Client Bridge: qm1 ↔ vsp1"
echo "Mainframe Queues: VSP.INPUT.SEND (send) / VSP.OUTPUT.RECV (receive)"

# Test 1: Send to mainframe
echo "=== Sending to VSP.INPUT.SEND ==="
echo "Test message $(date)" | /opt/mqm/samp/bin/amqsput TO.MAINFRAME.SEND qm1

# Test 2: Receive from mainframe
echo "=== Receiving from VSP.OUTPUT.RECV ==="
echo "Waiting for messages (timeout 30s)..."
/opt/mqm/samp/bin/amqsget FROM.MAINFRAME.RECV qm1 30

# Test 3: Verify configuration
echo "=== Verifying Setup ==="
runmqsc qm1 << EOF
DISPLAY QALIAS('TO.MAINFRAME.SEND')
DISPLAY QALIAS('FROM.MAINFRAME.RECV')
DISPLAY CHSTATUS('QM1.APP.SVRCONN')
EOF

echo "=== Test Complete ==="