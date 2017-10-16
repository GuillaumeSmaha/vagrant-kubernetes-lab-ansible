# Playbook pour déployer Gluu

Le playbook est configuré pour installer 1 machine exécutant Gluu ou un cluster Gluu avec le cluster manager.

## Installation

AFin d'utiliser le playbook, il est nécessaire d'installer plusieurs paquets via `pip`:

```shell
sudo pip install dpath ldap3 pyDes python-ldap
```

## Provisioning

### Ansible - Gluu:

- role `gluu-cluster-manager`pour installer le cluster manager de gluu
- role `gluu-setup`pour installer Gluu sur toutes les machines
- role `gluu-configuration`pour configurer Gluu via le LDAP
- role `gluu-customization`pour installer les pages XHTML, customiser le war

### Environnements:
Plusieurs environnements (%env%) peuvent être ajustés

- manager (exemple avec le cluster manager)
- local (pour les VM roulant  sur le PC ou vous lancer ansible)
- lab (pour le LAB à la Ville)
- dev (Pour l'environnement de DEV)
- ...

Si omis, par défaut, l'environnement choisi est celui de la maison (cf ansible.cfg: inventory = ./environments/maison)

Pour lancer le déploiement sur un environnement:
```shell
ansible-playbook -i environments/local site.yml  --ask-sudo-pass --ask-vault-pass
```

### Groupes environnements:
Il y a 4 groupes d'environnement  à utiliser pour déployer Gluu :
- **gluu-cluster-manager:** Groupe contenant le cluster manager
- **gluu-servers:** Groupe contenant tous les noeuds de Gluu
- **gluu-configuration:** Groupe contenant uniquement le noeud avec oxTrust. La configuration sera exécuté sur cette machine.
- **gluu-oxauth:** Groupe contenant les noeuds avec oxAuth. La customisation sera exécuté sur ces machines.

### Ajustement des paramètres:
Pour chaque environnement, il faut ajuster principalement:
- hosts
- group_vars
- host_vars

### IP & Ports:
ports: 
https://gluu.org/docs/ce/operation/faq/#how-to-change-the-hostnameip-addresslistening-port-of-gluu-server

### Structure:
Par défaut, un container est déployé dans `/opt/gluu-server-{{ gluu_version }}`
L'executable gérant le container est situé dans `/sbin/` et les clés pour s'y connecter sont dans `/etc/gluu/`
