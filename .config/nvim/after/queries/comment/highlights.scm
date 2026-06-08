;; extends
; Custom comment text highlights extending
; https://github.com/nvim-treesitter/nvim-treesitter/blob/master/queries/comment/highlights.scm

((tag
  (name) @comment.error @nospell
  ("(" @punctuation.bracket
    (user) @constant
    ")" @punctuation.bracket)?
  ":" @punctuation.delimiter)
  (#any-of? @comment.error "NOPE"))

("text" @comment.error @nospell
  (#any-of? @comment.error "NOPE"))
