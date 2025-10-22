# Safely evacuate pods from the overloaded node
kubectl drain <node-name> --ignore-daemonsets --delete-emptydir-data --force

# After drain completes, restart kubelet
kubectl debug node/<node-name> --image=busybox -- chroot /host systemctl restart kubelet
