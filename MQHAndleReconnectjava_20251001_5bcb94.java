@Component
public class MQConnectionRecovery {
    
    private static final Logger logger = LoggerFactory.getLogger(MQConnectionRecovery.class);
    
    @EventListener
    public void handleJmsException(JmsException event) {
        if (isConnectionBroken(event)) {
            logger.warn("MQRC 2538 detected - triggering connection recovery");
            // Spring's CachingConnectionFactory will auto-reconnect
        }
    }
    
    private boolean isConnectionBroken(JmsException e) {
        Throwable cause = e.getCause();
        while (cause != null) {
            if (cause instanceof JMSException) {
                JMSException jmsEx = (JMSException) cause;
                if ("MQRC_CONNECTION_BROKEN".equals(jmsEx.getMessage()) || 
                    jmsEx.getErrorCode() == 2538) {
                    return true;
                }
            }
            cause = cause.getCause();
        }
        return false;
    }
}