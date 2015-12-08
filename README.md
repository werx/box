# Werx Box

Ubuntu 14.04 based vagrant box for LAMP development based on the excellent project from <https://github.com/fideloper/Vaprobash>

## Features:

- Apache
- PHP 5.6
- Global composer installation
- MariaDB or MySQL
- SQLite
- PostgreSQL
- RVM
- NodeJS
- NPM
- Beanstalkd
- Redis
- Memcached

## installation
```bash
git clone git@github.com:werx/box.git
cd box
```
Comment/uncomment installation commands as needed in `Vagrantfile`, then

```bash
vagrant up
```

Then visit http://192.168.22.10 in your browser and you should see the phpinfo page.

Add your content to the `web` sub-directory and it will sync to the VM.
