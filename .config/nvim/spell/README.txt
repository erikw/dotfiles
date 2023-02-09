The .spl files seems to cause problems sometimes. At an instance (2021-12-27), en_us would work but not sv or de. However when deleting the (sv|de).utf-8.add.spl files, the it worked!

When regenerating those again with
:mkspell ~/.config/nvim/spell/sv.utf-8.add
the same problem came again. Thus, delete these files for now
