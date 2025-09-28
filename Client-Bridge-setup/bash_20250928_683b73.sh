# Receive messages from mainframe VSP.OUTPUT.RECV queue
/opt/mqm/samp/bin/amqsget FROM.MAINFRAME.RECV qm1

# Alternative: Using direct alias with timeout (wait 30 seconds)
/opt/mqm/samp/bin/amqsget 'VSP.OUTPUT.RECV' qm1 30