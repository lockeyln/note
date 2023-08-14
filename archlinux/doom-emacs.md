archlinux默认安装的emacs是29.1，由于doom-emacs不支持最新emacs29.1，通过一下方式安装28.1

1. git 克隆 git://git.savannah.gnu.org/emacs.git
2. cd emacs
3. git checkout emacs-28
4. ./autogen.sh
5. ./configure --with-native-compilation
6. make -j$(nproc)

  
