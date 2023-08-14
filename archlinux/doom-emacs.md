archlinux默认安装的emacs是29.1，由于doom-emacs不支持最新emacs29.1，通过一下方式安装28.1

```
git 克隆 git://git.savannah.gnu.org/emacs.git
cd emacs
git checkout emacs-28
./autogen.sh
./configure --with-native-compilation
make -j$(nproc)
```
  
