sudo apt-get install git software-properties-common -y
sudo apt-add-repository ppa:ansible/ansible -y
sudo apt-get update
sudo apt-get install ansible -qy
rm -rf ansible-push-keys
git clone https://github.com/cumulusnetworks/ansible-push-keys
cd ansible-push-keys; cat /etc/dhcp/dhcpd.hosts | grep 'host .* {' | cut -d " " -f 2 >> hosts
cd ansible-push-keys; ansible-playbook push-keys.yml --extra-vars 'ansible_ssh_pass=CumulusLinux!' --extra-vars 'ansible_become_pass=CumulusLinux!'
rm -rf ansible-push-keys
rm -rf local-git-repo
ansible-playbook run-demo.yml
ssh server01 wget -T 30 -t 1 10.0.0.32
ssh server01 cat index.html
