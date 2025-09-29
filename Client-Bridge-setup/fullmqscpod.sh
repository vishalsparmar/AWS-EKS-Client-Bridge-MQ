# Get the pod name
QM1_POD=$(kubectl get pods -n mq -l app.kubernetes.io/instance=qm1 -o jsonpath='{.items[0].metadata.name}')

# Run MQSC commands to create aliases
kubectl exec -n mq $QM1_POD -- bash -c 'echo "
DEFINE QALIAS('\''TO.MAINFRAME.SEND'\'') +
       TARGET('\''VSP.INPUT.SEND'\'') +
       TARGCLIENT('\''MQClient'\'') +
       REPLACE

DEFINE QALIAS('\''FROM.MAINFRAME.RECV'\'') +
       TARGET('\''VSP.OUTPUT.RECV'\'') +
       TARGCLIENT('\''MQClient'\'') +
       REPLACE

DEFINE CHANNEL('\''QM1.APP.SVRCONN'\'') +
       CHLTYPE(SVRCONN) +
       TRPTYPE(TCP) +
       REPLACE

START CHANNEL('\''QM1.APP.SVRCONN'\'')
" | runmqsc qm1'
