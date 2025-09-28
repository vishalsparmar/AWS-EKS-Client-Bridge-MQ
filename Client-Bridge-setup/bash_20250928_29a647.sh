# Send test message to mainframe VSP.INPUT.SEND queue
echo "Test message to mainframe input" | /opt/mqm/samp/bin/amqsput TO.MAINFRAME.SEND qm1

# Alternative: Using direct alias
echo "Direct test" | /opt/mqm/samp/bin/amqsput 'VSP.INPUT.SEND' qm1