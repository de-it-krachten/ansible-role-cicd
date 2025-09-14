[![CI](https://github.com/de-it-krachten/ansible-role-cicd/workflows/CI/badge.svg?event=push)](https://github.com/de-it-krachten/ansible-role-cicd/actions?query=workflow%3ACI)


# ansible-role-cicd

Set of scripts to help setup CI/CD



## Dependencies

#### Roles
None

#### Collections
None

## Platforms

Supported platforms

- Red Hat Enterprise Linux 8<sup>1</sup>
- Red Hat Enterprise Linux 9<sup>1</sup>
- Red Hat Enterprise Linux 10<sup>1</sup>
- RockyLinux 8
- RockyLinux 9
- RockyLinux 10
- OracleLinux 8
- OracleLinux 9
- OracleLinux 10
- AlmaLinux 8
- AlmaLinux 9
- AlmaLinux 10
- SUSE Linux Enterprise 15<sup>1</sup>
- openSUSE Leap 15
- Debian 11 (Bullseye)
- Debian 12 (Bookworm)
- Debian 13 (Trixie)
- Ubuntu 22.04 LTS
- Ubuntu 24.04 LTS
- Fedora 41
- Fedora 42

Note:
<sup>1</sup> : no automated testing is performed on these platforms

## Role Variables
### defaults/main.yml
<pre><code>
# Root directory where to install the code
cicd_root: /opt/cicd-tools

# File ownership
cicd_owner: root
cicd_group: root

# Symbolic links on the target under cicd_root
cicd_links:
  - { src: ansible/ansible-collections.sh, dest: bin/ }
  - { src: ansible/ansible-fix.sh, dest: bin/ }
  - { src: ansible/ansible-fqcn-converter.sh, dest: bin/ }
  - { src: ansible/ansible-galaxy.sh, dest: bin/ }
  - { src: ansible/ansible-get-collections.sh, dest: bin/ }
  - { src: ansible/ansible-lint.sh, dest: bin/ }
  - { src: ansible/ansible-list-modules.sh, dest: bin/ }
  - { src: ansible/ansible-requirements-clean.sh, dest: bin/ }
  - { src: ansible/ansible-vault.sh, dest: bin/ }
  - { src: ansible/vault.sh, dest: bin/ }
  - { src: cicd/ci-init.sh, dest: bin/ci-init-ansible-collection.sh }
  - { src: cicd/ci-init.sh, dest: bin/ci-init-ansible-playbooks.sh }
  - { src: cicd/ci-init.sh, dest: bin/ci-init-ansible-role.sh }
  - { src: cicd/ci-init.sh, dest: bin/ }
  - { src: cicd/ci-init-docker.sh, dest: bin/ }
  - { src: docker/docker-clean.sh, dest: bin/ }
  - { src: generic/functions.sh, dest: bin/ }
  - { src: generic/functions_ansible.sh, dest: bin/ }
  - { src: molecule/molecule-test.sh, dest: bin/ }
  - { src: readme/readme.sh, dest: bin/ }
  - { src: semrel/semantic-release.sh, dest: bin/ }
  - { src: bin/functions.sh, dest: ansible/functions.sh }
  - { src: bin/functions_ansible.sh, dest: ansible/functions_ansible.sh }
  - { src: bin/functions.sh, dest: molecule/functions.sh }
  - { src: bin/functions_ansible.sh, dest: molecule/functions_ansible.sh }
  - { src: github/clone-tree.sh, dest: bin/github-clone-tree.sh }
  - { src: github/make-repo.sh, dest: bin/github-make-repo.sh }
</pre></code>




## Example Playbook
### molecule/default/converge.yml
<pre><code>
- name: sample playbook for role 'cicd'
  hosts: all
  become: 'yes'
  tasks:
    - name: Include role 'cicd'
      ansible.builtin.include_role:
        name: cicd
</pre></code>
