# ervpa
RadineryCMS with Errbit, managed with Vagrant, Puppet and Ansible

## Deploying

```bash
$ vagrant up
$ ansible-playbook -vvvv -i lib/vagrant-ansible-inventory.py infrastructure.yml
```
