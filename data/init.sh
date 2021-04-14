#!/bin/bash
# Init-Start Script for docker-borgserver
# SSH_KEY_DIR must be owned by borg[uid: 1000]
SSH_KEY_DIR=${SSH_KEY_DIR:-/keys}

echo "########################################################"
echo " * Containerized BorgServer | Init-Container *"

# Create SSH-Host-Keys on persistent storage, if not exist
echo " * Checking / Preparing SSH Host-Keys..."
for keytype in ed25519 rsa ; do
  if [ ! -f "${SSH_KEY_DIR}/ssh_host_${keytype}_key" ] ; then
    echo "  ** Creating SSH Hostkey [${keytype}]..."
    ssh-keygen -q -f "${SSH_KEY_DIR}/ssh_host_${keytype}_key" -N '' -t ${keytype}
  fi
done

echo "########################################################"
echo " * Init done! Ready to fire up your borgserver!"

exit 0
