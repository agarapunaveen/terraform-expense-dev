#!/bin/bash
sudo dnf install ansible -y
cd /tmp
git clone https://github.com/agarapunaveen/ansible-roles-expense.git
cd ansible-roles-expense
ansible-playbook main.yml -e component=backend -e login_password=ExpenseApp1
ansible-playbook main.yml -e component=frontendN