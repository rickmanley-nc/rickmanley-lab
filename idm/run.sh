cd /home/rnelson/git
git clone git@github.com:rickmanley-nc/idm.git
cd idm

ansible-playbook --ask-become-pass deploy.yml
ansible-playbook --ask-become-pass --ask-vault-pass main.yml -k

source ~/.bashrc
exit 0

# wget -qO- https://github.com/rickmanley-nc/idm/raw/master/run.sh | bash
