#### Neovim配置

> mkdir ~/.config/nvim
>
> nvim  ~/.config/nvim/init.vim

#### 安装配色主题

> 1.mkdir ~/.config/nvim/colors
>
> 2.下载的配色文件如monokai.vim复制到此文件夹
>
> 3.init.vim中指定主题：colorscheme monokai

#### 安装plug.vim

> mkdir ~/.config/nvim/autoload
>
> init.vim中配置：
>
> ```
> call plug#begin('~/.config/nvim/plugApp') //括号里的路径可以根据实际情况设置
> Plug 'junegunn/vim-easy-align'
> call plug#end()
> ```

#### 安装Coc.nvim

> 出现please install dependencies and compile coc .nvim by: yarn install错误解决方法
>
> 1.npm install -g yarn     安装yarn
>
> 2.到~/.vim/bundle/coc.nvim的文件目录下执行:yarn install

