Running the operator locally
============================

Fedora 30 Silverblue
--------------------

The operator can be run within toolbox. Within toolbox, a number of packages need to be installed

* sudo dnf install -y ansible python3-openshift python3-ansible-runner
* sudo pip3 install ansible-runner-http

Make a link to your operator in /opt

* sudo ln -sf $(pwd) /opt/ansible

Finally, run the operator:

ANSIBLE_CONFIG=ansible.cfg operator-sdk up local

