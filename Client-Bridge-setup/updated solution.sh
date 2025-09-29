Complete No-Mainframe-Changes Solution

mqsc
/* ===== ALL CONFIGURED ON EKS qm1 ONLY ===== */

/* 1. Client connection channel using EXISTING mainframe channel */
DEFINE CHANNEL('TO.VSP1.CLNTCONN') +
       CHLTYPE(CLNTCONN) +
       TRPTYPE(TCP) +
       CONNAME('mainframe.company.com(1414)') +  /* Your mainframe details */
       QMNAME('VSP1') +                          /* Must match mainframe QMgr name */
       CHANNEL('SYSTEM.DEF.SVRCONN') +           /* Must match existing channel */
       REPLACE

/* 2. Remote queue definitions pointing to EXISTING mainframe queues */
DEFINE QREMOTE('TO.MAINFRAME.SEND') +
       RNAME('VSP.INPUT.SEND') +           /* Existing mainframe queue */
       RQMNAME('VSP1') +                   /* Existing mainframe QMgr */
       XMITQ('') +                         /* Client connection - no transmission queue */
       REPLACE

DEFINE QREMOTE('FROM.MAINFRAME.RECV') +
       RNAME('VSP.OUTPUT.RECV') +          /* Existing mainframe queue */
       RQMNAME('VSP1') +                   /* Existing mainframe QMgr */
       XMITQ('') +                         /* Client connection */
       REPLACE

/* 3. Local aliases for your microservices */
DEFINE QALIAS('APP01.TO.MF.ALIAS') +
       TARGET('TO.MAINFRAME.SEND') +
       REPLACE

DEFINE QALIAS('APP01.FROM.MF.ALIAS') +
       TARGET('FROM.MAINFRAME.RECV') +
       REPLACE

/* 4. Channel for your EKS apps */
DEFINE CHANNEL('QM1.APP.SVRCONN') +
       CHLTYPE(SVRCONN) +
       TRPTYPE(TCP) +
       REPLACE

START CHANNEL('QM1.APP.SVRCONN')
Verification - No Mainframe Access Needed

You can test this without any mainframe changes:

bash
# Test if client connection works
echo "Test message" | /opt/mqm/samp/bin/amqsput APP01.TO.MF.ALIAS qm1

# Check channel status - if it connects, you're good!
echo "DISPLAY CHSTATUS('TO.VSP1.CLNTCONN')" | runmqsc qm1
What Success Looks Like:

If the channel shows STATUS(RUNNING) and SUBSTATE(MQGET), it means:

✅ Connected to mainframe successfully
✅ Authenticated via existing SVRCONN channel
✅ Can access the existing queues
✅ ZERO mainframe changes required
Summary:

Yes, Solution 1 works with your constraints! The CLNTCONN channel approach only requires:

Mainframe hostname/port
Existing SVRCONN channel name
Existing queue manager name
Existing queue names
No creation, no changes, no modifications on the mainframe side. You're just using what already exists.
