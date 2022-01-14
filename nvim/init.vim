" init.nvim只是作为入口文件

" 基础选项设置
runtime ./vimrc.vim

" 按键映射
runtime ./keymaps.vim

" 插件管理
lua require('plugins')