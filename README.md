Copy ssh key to server-0 since it will be used as Ansible host.

SSH into server-0 and install required packages

    yum install -y git python3

Clone this repo

    git clone https://github.com/ztzxt/k8s-consul-challenge.git


Intall requirements.txt

    pip3 install -r requirements.txt