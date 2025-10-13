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
# url - repo
cicd_repo: https://github.com/de-it-krachten/cicd-tools

# url - api
cicd_api: https://api.github.com/repos/de-it-krachten/cicd-tools

# Version to install
cicd_version: latest

# Packages
cicd_package_deb: "cicd-tools_{{ cicd_version | regex_replace('^v') }}.deb"
cicd_package_rpm: "cicd-tools-{{ cicd_version | regex_replace('^v') }}-1.noarch.rpm"
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
