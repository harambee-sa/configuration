#! /bin/bash

PLAYBOOK="update-edx.yml"
EXTRA_VARS="~/configuration/server-vars.yml"
TAG="tag_Name_harambee_uat_rg_edx*"
sshkey="~/.ssh/priv"

. ~/venv/bin/activate
cd ~/configuration/playbooks/
export ANSIBLE_CONFIG=~/configuration/playbooks/ansible.cfg
export ANSIBLE_HOSTS=~/configuration/harambee/ec2.py
export EC2_INI_PATH=~/configuration/harambee/ec2.ini 
~/venv/bin/ansible-playbook -i ~/configuration/harambee/ec2.py ~/configuration/playbooks/${PLAYBOOK} -e@${EXTRA_VARS} --limit ${TAG} --private-key ${sshkey}
