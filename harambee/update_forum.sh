#! /bin/bash

PLAYBOOK="update-forum.yml"
EXTRA_VARS="~/server-vars-uat.yml"
INVENTORY="~/configuration/harambee/inventory-harambee-uat.ini"

. ~/venv/bin/activate
ANSIBLE_CONFIG=~/configuration/playbooks/ansible.cfg
~/venv/bin/ansible-playbook -i ${INVENTORY} ~/configuration/playbooks/${PLAYBOOK} -e@${EXTRA_VARS}
