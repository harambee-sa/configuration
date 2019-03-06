#! /bin/bash

PLAYBOOK="update-mongo.yml"
EXTRA_VARS="~/configuration/server-vars.yml"
INVENTORY="~/configuration/harambee/inventory-harambee-uat.ini"

. ~/venv/bin/activate
ANSIBLE_CONFIG=~/configuration/playbooks/ansible.cfg
~/venv/bin/ansible-playbook -i ${INVENTORY} ~/configuration/playbooks/${PLAYBOOK} -e@${EXTRA_VARS}
