#! /bin/bash

PLAYBOOK="update-edx.yml"
sshkey="~/.ssh/priv"
EXTRA_VARS="~/configuration/server-vars.yml"
INVENTORY="~/configuration/harambee/inventory-harambee-uat.ini"

. ~/venv/bin/activate
cd ~/configuration/playbooks/
export ANSIBLE_CONFIG=~/configuration/playbooks/ansible.cfg
~/venv/bin/ansible-playbook -i ${INVENTORY} ~/configuration/playbooks/${PLAYBOOK} -e@${EXTRA_VARS} --limit ${TAG} --private-key ${sshkey}
