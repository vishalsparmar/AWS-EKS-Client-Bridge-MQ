(sleep 3; printf '\x1dquit\n') | telnet 10.0.0.1 1414



echo "TEST" | timeout 5 nc -w 3 your-mainframe-ip 1414; echo "Exit: $?"
