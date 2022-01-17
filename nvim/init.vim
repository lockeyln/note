" init.nvim只是作为入口文件

" 基础选项设置
runtime ./vimrc.vim

" 按键映射
runtime ./keymaps.vim

" 插件管理
lua require('plugins')

" 优先加载airline插件
source ~/.config/nvim/after/plugin/airline.rc.vim

" 主题的配置文件引用
source ~/.config/nvim/colors/gruvbox_material.rc.vim
