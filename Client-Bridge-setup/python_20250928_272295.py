import pymqi
import json
import time
import logging
from threading import Thread

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

class MainframeBridgeClient:
    def __init__(self, qmgr_name='qm1', host='qm1-ibm-mq.mq.svc.cluster.local', 
                 port=1414, channel='QM1.APP.SVRCONN'):
        self.qmgr_name = qmgr_name
        self.connection_info = f"{host}({port})"
        self.channel = channel
        self.send_queue = 'TO.MAINFRAME.SEND'
        self.receive_queue = 'FROM.MAINFRAME.RECV'
        self.qmgr = None
        self.connect()
    
    def connect(self):
        try:
            cd = pymqi.CD()
            cd.ChannelName = self.channel.encode()
            cd.ConnectionName = self.connection_info.encode()
            cd.ChannelType = pymqi.CMQC.MQCHT_CLNTCONN
            cd.TransportType = pymqi.CMQC.MQXPT_TCP
            
            self.qmgr = pymqi.QueueManager(None)
            self.qmgr.connect_with_options(self.qmgr_name, cd, None)
            logger.info(f"Connected to {self.qmgr_name}")
        except pymqi.MQMIError as e:
            logger.error(f"Connection failed: {e}")
            raise
    
    def send_to_mainframe(self, message_data):
        try:
            message = {
                'timestamp': time.time(),
                'data': message_data,
                'source': 'eks-python-app'
            }
            message_json = json.dumps(message)
            queue = pymqi.Queue(self.qmgr, self.send_queue)
            queue.put(message_json.encode('utf-8'))
            queue.close()
            logger.info(f"Sent to VSP.INPUT.SEND: {message_data}")
            return True
        except pymqi.MQMIError as e:
            logger.error(f"Send failed: {e}")
            return False
    
    def receive_from_mainframe(self, timeout=30000):
        try:
            queue = pymqi.Queue(self.qmgr, self.receive_queue)
            message_bytes = queue.get(None, pymqi.CMQC.MQWI_UNLIMITED, wait=timeout)
            queue.close()
            if message_bytes:
                message_data = json.loads(message_bytes.decode('utf-8'))
                logger.info(f"Received from VSP.OUTPUT.RECV: {message_data}")
                return message_data
            return None
        except pymqi.MQMIError as e:
            if e.reason == pymqi.CMQC.MQRC_NO_MSG_AVAILABLE:
                return None
            logger.error(f"Receive failed: {e}")
            return None
    
    def close(self):
        if self.qmgr:
            self.qmgr.disconnect()
            logger.info("Disconnected")

if __name__ == "__main__":
    client = MainframeBridgeClient()
    client.send_to_mainframe("Test connection")
    client.close()