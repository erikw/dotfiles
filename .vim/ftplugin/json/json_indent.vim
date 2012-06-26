" Format JSON code.
" Source: " http://stackoverflow.com/questions/16620835/how-to-fix-json-indentation-in-vim
command! -range -nargs=0 -bar JSONFormat <line1>,<line2>!python -m json.tool
