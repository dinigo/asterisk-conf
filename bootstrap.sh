#!/bin/bash

# Actualiza los paquetes instalados e instala los necesarios
yum update --assumeyes
yum install perl perl-libwww-perl.noarch sox gcc make git


# Descarga las fuentes de mpg123 y las instala
wget http://garr.dl.sourceforge.net/project/mpg123/mpg123/1.15.3/mpg123-1.15.3.tar.bz2
tar -xjvf mpg123-1.15.3.tar.bz2
cd mpg123-1.15.3
./configure && make && make install


# Descarga el agi de google tts, modifica los permisos
cd /var/lib/asterisk/agi-bin/
wget https://raw.github.com/zaf/asterisk-googletts/master/googletts.agi
chown asterisk:asterisk googletts.agi
chmod 755 googletts.agi


# Configura mis 'dotfiles'
cd ~/
git clone https://github.com/demil133/dotfiles
rm .bashrc
ln -s dotfiles/.bashrc 
ln -s dotfiles/.bash_aliases
ln -s dotfiles/.gitconfig
source .bashrc
source .bash_aliases
echo "syntax on" > .vimrc
echo "set number" >> .vimrc


# Instala los archivos de configuración de asterisk
git clone https://github.com/demil133/asterisk-conf
ast="/etc/asterisk"
cd asterisk-conf
for file in *.conf; do 
    echo $file
    mv -f $ast/$file $ast/$file.backup
    ln -f `pwd`/$file $ast/$file
done

# Copia los archivos de audio
cp sounds/* /var/lib/asterisk/sounds/custom/

# Reinicia asterisk de cierta forma.
amportal restart
