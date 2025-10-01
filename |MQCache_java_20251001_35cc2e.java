@Configuration
public class MQConfig {
    
    @Bean
    public ConnectionFactory mqConnectionFactory() {
        MQConnectionFactory factory = new MQConnectionFactory();
        try {
            factory.setHostName("your-host");
            factory.setPort(1414);
            factory.setQueueManager("YOUR_QMGR");
            factory.setChannel("YOUR_CHANNEL");
            // v9.3.5.0 specific settings
            factory.setTransportType(1); // CLIENT
            factory.setCCSID(1208);
            // Critical reconnection settings
            factory.setClientReconnectOptions(WMQConstants.WMQ_CLIENT_RECONNECT);
            factory.setClientReconnectTimeout(1800); // 30 minutes
            factory.setReconnectDelay(5000); // 5 seconds
            // Heartbeat for connection health
            factory.setHeartbeatInterval(300);
            factory.setKeepAliveInterval(60);
        } catch (JMSException e) {
            throw new RuntimeException(e);
        }
        
        // Wrap with caching
        CachingConnectionFactory cachingFactory = new CachingConnectionFactory(factory);
        cachingFactory.setSessionCacheSize(10);
        cachingFactory.setReconnectOnException(true);
        cachingFactory.setExceptionListener(new MQExceptionListener());
        
        return cachingFactory;
    }
}