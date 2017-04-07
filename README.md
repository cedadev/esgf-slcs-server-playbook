# esgf-slcs-server-playbook

This repository provides an Ansible playbook that can deploy the
[esgf-slcs-server](https://github.com/cedadev/esgf-slcs-server).


## Installing the ESGF SLCS Server

**WARNING:** The playbook will only work on CentOS/RHEL 6.x, and has only been
tested on CentOS 6.8.

Before running the playbook, Ansible must be installed:

```
$ yum install -y -q epel-release
$ yum install -y -q ansible
```

Then clone and execute the playbook. The playbook must be executed as `root`:

```
$ git clone https://github.com/cedadev/esgf-slcs-server-playbook.git
$ cd esgf-slcs-server-playbook
$ sudo ansible-playbook -i playbook/inventories/localhost -e "@path/to/overrides.yml" playbook/playbook.yml
```

The `ansible-playbook` command includes a reference to an overrides file. This is
a file that provides the Ansible variables appropriate for your setup.

There are three example override files provided. The variables available for modification
are documented comprehensively in these files:

  * [production_all.yml](playbook/overrides/production_all.yml): Demonstrates
    settings for a standalone production installation on a blank machine - ESGF
    SLCS Django application installed in a virtual environment and configured to
    run using the Waitress WSGI server proxied by Nginx.

  * [production_venv_only.yml](playbook/overrides/production_venv_only.yml):
    Demonstrates settings for installing the ESGF SLCS Django application into a
    virtual environment using an existing Python installation. Does not install
    or configure the WSGI server or proxy, or any databases.

  * [development.yml](playbook/overrides/development.yml):
    Settings for installing the ESGF SLCS Django application for development,
    primarily for use with the Vagrant box.

The only one that will run to completion without edits is ``development.yml``,
which is used by the Vagrant box (see below). This is because some configuration
is required for a production install (in particular of databases and the CA that
issues the short-lived certificates).


## Running a development sandbox using Vagrant and VirtualBox

### VirtualBox

Vagrant needs a recent [VirtualBox installation](https://www.virtualbox.org/wiki/Downloads).

### Installing Vagrant

See the [Vagrant documentation](https://www.vagrantup.com/docs/installation/) for installation details.

#### Debian/Ubuntu/LinuxMint:

Ubuntu has a vagrant package but it is outdated. You can install Vagrant manually:

```
$ wget https://releases.hashicorp.com/vagrant/1.9.1/vagrant_1.9.1_x86_64.deb
$ sudo dpkg -i vagrant_1.9.1_x86_64.deb
```

### Deploying the Vagrant VM

First, modify the `config.vm.synced_folder` in the `Vagrantfile` to the location
where you checked out the ESGF SLCS Server, then run `vagrant up`.

Many OAuth clients that you may use to test the service require that the OAuth server
runs using HTTPS. Hence everything on the provisioned VM sits behind an Nginx
proxy providing HTTPS.

The default configuration for development requires you to log in to the provisioned
VM and start the Django development server on port 5000:

```
$ vagrant ssh
[vagrant@localhost ~]$ venv/bin/python /code/esgf-slcs-server/manage.py runserver 127.0.0.1:5000
```

Starting the Django development server on port 5000 allows Nginx to pick it up as
a downstream server and pass requests on.

The ESGF SLCS Server will then be available at `https://172.28.128.7`.

The Django administration view for configuring OAuth clients is at: `https://172.28.128.7/admin`.

Ansible sets up a default user database with a test user:

```
username = another
password = changeme
```

You can change this in the Ansible configuration:

```
playbook/roles/esgf_slcs_server/files/create-user-table.sql
```

Changes to Python files in your `esgf-slcs-server` checkout will cause the Django
development server to reload automatically. However, because the Nginx server is
serving static resources, any change to Javascript and CSS files will not be
reflected by the server until the Ansible playbook is re-run to collect the static
files:

```
[vagrant@localhost ~]$ sudo ansible-playbook -i /vagrant/playbook/inventories/localhost -e "@/vagrant/playbook/overrides/development.yml" /vagrant/playbook/playbook.yml
```
