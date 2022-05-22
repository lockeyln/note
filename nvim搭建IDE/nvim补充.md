#### 必备依赖
- [neovim](https://github.com/neovim/neovim) > 0.7 ：主角就是它
- [nerd font](https://www.nerdfonts.com/) ： 让 neovim 能够显示字体图标，需要额外配置终端显示字体，请自行 Google
- [node](https://nodejs.org/en/) ： 快速下载 LSP 服务器必备的工具
- [npm](https://www.npmjs.com/) ： 同上 ..  

#### 可选依赖( Manjaro Linux，通过 yay 可以下载到下面的依赖项)
```
-- neovim 与系统剪切板交互的必要插件
$ yay -S xsel
​
-- 语法树解析
$ yay -S tree-sitter
​
-- 模糊查找
$ yay -S fd
$ yay -S repgrep
​
-- Lua 代码格式化
$ yay -S stylua
```
