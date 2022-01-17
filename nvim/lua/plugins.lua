---@diagnostic disable: undefined-global
--在没有安装packer的电脑上，自动安装packer插件
local fn = vim.fn
local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
	fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})	--默认地址
--	fn.system({'git', 'clone', '--depth', '1', 'https://codechina.csdn.net/mirrors/wbthomason/packer.nvim.git', install_path})	--csdn加速镜像
	vim.cmd 'packadd packer.nvim'
end
-- Only required if you have packer configured as `opt`
vim.cmd [[packadd packer.nvim]]
return require('packer').startup({
	function()
		use 'wbthomason/packer.nvim'-- Packer can manage itself
        --Nvim LSP 客户端的快速入门配置
        use "neovim/nvim-lspconfig"
        use {
        "hrsh7th/nvim-cmp",
        requires = {
        "hrsh7th/cmp-nvim-lsp", --neovim 内置 LSP 客户端的 nvim-cmp 源
        --以下插件可选，可以根据个人喜好删减
        "onsails/lspkind-nvim", --美化自动完成提示信息
        "hrsh7th/cmp-buffer", --从buffer中智能提示
        "hrsh7th/cmp-nvim-lua", --nvim-cmp source for neovim Lua API.
        "octaltree/cmp-look", --用于完成英语单词
        "hrsh7th/cmp-path", --自动提示硬盘上的文件
        "hrsh7th/cmp-calc", --输入数学算式（如1+1=）自动计算
        "f3fora/cmp-spell", --nvim-cmp 的拼写源基于 vim 的拼写建议
        "hrsh7th/cmp-emoji", --输入: 可以显示表情
        }
        }

        -- lua代码段提示
        use {
        "L3MON4D3/LuaSnip",
        requires = {
        "saadparwaiz1/cmp_luasnip", -- Snippets source for nvim-cmp
        "rafamadriz/friendly-snippets" --代码段合集
        }
        }
        -- 自动安装lsp语言服务器
        use 'williamboman/nvim-lsp-installer'
        --界面美化插件vim-airline
       use {
        "vim-airline/vim-airline",
        requires = {
          "vim-airline/vim-airline-themes",
          --综合图标支持such vim-airline lightline, vim-startify
          "ryanoasis/vim-devicons"
        }
        }
        -- 安装主题
        use "sainnhe/gruvbox-material"

	end,
	config = {
		max_jobs = 16,
		git = {
			default_url_format = 'https://hub.fastgit.org/%s'
		},
		display = {
			open_fn = function()
				return require('packer.util').float({ border = 'single' })
			end
		}
	}
})
