@Component
public class ModernMessagePoller {
    
    private static final Logger logger = LoggerFactory.getLogger(ModernMessagePoller.class);
    
    @Autowired
    private JmsTemplate jmsTemplate;
    
    @Scheduled(fixedDelay = 10000) // Poll every 10 seconds
    public void pollWithModernFeatures() {
        try {
            // With v9.3.5.0, auto-reconnect will handle MQRC 2538
            Message message = jmsTemplate.receive("YOUR.QUEUE.NAME");
            
            if (message != null) {
                processMessage(message);
                logger.info("Successfully processed message");
            }
            
        } catch (JmsException e) {
            // v9.3.5.0 will auto-reconnect in background
            // Just log and continue - don't crash the poller
            if (isConnectionBroken(e)) {
                logger.warn("Connection broken - auto-reconnect in progress: {}", e.getMessage());
            } else {
                logger.error("Other MQ error: {}", e.getMessage(), e);
            }
        }
    }
    
    private boolean isConnectionBroken(JmsException e) {
        Throwable cause = e.getCause();
        while (cause != null) {
            if (cause instanceof JMSException) {
                JMSException jmsEx = (JMSException) cause;
                return jmsEx.getErrorCode() == 2538 || 
                       "MQRC_CONNECTION_BROKEN".equals(jmsEx.getMessage());
            }
            cause = cause.getCause();
        }
        return false;
    }
}