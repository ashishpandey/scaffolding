# scaffolding
Ansible playbooks for server rebuilds

Mostly dealing with a bunch of raspberry Pis and other microservers in my home network

### running

```
ansible-playbook -i radiopo.ini everything.yaml
```

### vaulting

`ansible-vault encrypt_string 'variable_value' --name variable_name`
