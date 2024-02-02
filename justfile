set windows-shell := ['pwsh.exe', '-NoLogo', '-Command']

alias u := update
alias a := ansible
alias d := dcp
alias lint := ansiblelint
defaultHost := 'talos'

# list commands
[private]
@default:
  just --list

### Ansible ###
# run update playbook
[windows]
update:
  wsl --cd "/mnt/c/users/cameron/github/infra" /home/cameron/.local/bin/ansible-playbook -b "update.yml" -l {{ defaultHost }}
# run update playbook
[linux]
update:
  ansible-playbook -b "update.yml" -l {{ defaultHost }}


# run main playbook, optionally with tags (-t <tags>)
[windows]
ansible *TAGS:
  wsl --cd "/mnt/c/users/cameron/github/infra" /home/cameron/.local/bin/ansible-playbook -b "run.yml" -i "hosts.yml" -l {{ defaultHost }} --vault-password-file "vault.sh" {{ TAGS }}
# run main playbook, optionally with tags (-t <tags>)
[linux]
ansible *TAGS:
  ansible-playbook -b "run.yml" -l {{ defaultHost }} {{ TAGS }}


# ansible-galaxy requirements, use -f to reinstall all
[windows]
reqs FORCE='':
  wsl --cd "/mnt/c/users/cameron/github/infra" /home/cameron/.local/bin/ansible-galaxy install -r "requirements.yml" -p "./galaxy_roles" {{ FORCE }}
# ansible-galaxy requirements, use -f to reinstall all
[linux]
reqs FORCE='':
  ansible-galaxy install -r "requirements.yml" -p "./galaxy_roles" {{ FORCE }}


# ansible-vault (encrypt/decrypt/edit)
[linux]
vault ACTION:
  ansible-vault {{ ACTION }} --vault-password-file "./vault.sh" "vars/secrets.yml"


### Docker ###
# ansible run and docker compose
dcp:
  just a -t compose
  ssh {{ defaultHost }} docker compose -f "~/docker-compose.yml" up -d --remove-orphans


### Lint
yamllint:
    yamllint -s .

ansiblelint: yamllint
    #!/usr/bin/env bash
    ansible-lint .
    ansible-playbook run.yml --syntax-check


### Vagrant ###
# bring up vm
vu:
  vagrant up
  vagrant ssh

# destroy vm
vd:
  vagrant destroy

# reprovision vm
vp:
  vagrant provision