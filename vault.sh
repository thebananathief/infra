#!/usr/bin/env bash

if /home/cameron/.local/bin/bw unlock --check --session "$(cat /tmp/bw.token)" | grep -q 'Vault is unlocked!' ; then
    /home/cameron/.local/bin/bw get password "infra-vault" --session "$(grep '^' /tmp/bw.token)"
else
    /home/cameron/.local/bin/bw unlock --raw > /tmp/bw.token
    /home/cameron/.local/bin/bw get password "infra-vault" --session "$(grep '^' /tmp/bw.token)"
fi