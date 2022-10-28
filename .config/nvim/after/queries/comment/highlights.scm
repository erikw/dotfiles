;; extends
; Custom comment text highlights extending
; https://github.com/nvim-treesitter/nvim-treesitter/blob/master/queries/comment/highlights.scm
; See https://github.com/nvim-treesitter/nvim-treesitter/discussions/3729#discussioncomment-3990247

("text" @text.danger
 (#any-of? @text.danger "NOPE" ))
