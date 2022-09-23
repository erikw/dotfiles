; Custom comment text highlights extending
; https://github.com/nvim-treesitter/nvim-treesitter/blob/master/queries/comment/highlights.scm

("text" @text.danger
 (#any-of? @text.danger "NOPE" ))
