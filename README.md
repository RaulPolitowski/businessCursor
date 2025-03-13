# German Tech Sistemas


# 1. Instalação do Projeto

### 1.1. Instalar o WLS
- wsl --install
- wsl --set-default-version 1
- wsl --set-version Ubuntu 1


### 1.2. Instalar o RVM
- sudo apt update
- sudo apt install gnupg2
- gpg2 --keyserver hkp://keyserver.ubuntu.com --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB
- \curl -sSL https://get.rvm.io -o rvm.sh
- nano rvm.sh
- cat rvm.sh | bash -s stable
- source ~/.rvm/scripts/rvm
- rvm list known
- rvm install 2.3.0
- rvm list
- rvm use 2.3.0


### 1.3. Instalar o Node
- \curl -sSL https://deb.nodesource.com/setup_14.x -o nodejs.sh
- nano nodejs.sh
- cat nodejs.sh | sudo -E bash -
- sudo apt update
- sudo apt install nodejs


### 1.4. Instalar as gems (bibliotecas)
- bundle install


---
## 1.5. Possíveis erros

### Rodar em casos de erro com PG:

wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -

sudo sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt/ $(lsb_release -sc)-pgdg main" > /etc/apt/sources.list.d/PostgreSQL.list'

sudo apt-get update

sudo apt-get install libpq-dev

sudo apt-get install postgresql-11 postgresql-contrib-11

sudo apt-get install postgresql postgresql-contrib
