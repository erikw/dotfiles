; Custom comment text highlights.
; * Extending https://github.com/nvim-treesitter/nvim-treesitter/blob/master/queries/comment/highlights.scm
; * Extend https://github.com/stsewd/tree-sitter-comment/ to recognize NOTE without trailing colon
;    * Ref: https://github.com/stsewd/tree-sitter-comment/issues/13#issuecomment-1240860680
("text" @text.warning
 (#any-of? @text.warning "NOTE" "NOPE" ))
