#!/usr/bin/env bash

vim_cnf="let g:ropevim_autoimport_modules ="
pkgs_normal=$(find $HOME/dev -name 'requirements*.txt' -print0 | xargs -0 grep "\w*==[\d.]*" | cut -d ":" -f 2 | cut -d '=' -f1 | sort -fu)
pkgs_git=$(find $HOME/dev -name 'requirements*.txt' -print0 | xargs -0 grep --no-filename -o '#egg=.*' | sed -e 's/#egg=//' | sort -fu)
pkgs=$(echo -e "$pkgs_normal\n$pkgs_git")
pkgs=($pkgs)

# Add Python standard library modules.
cnf='["__future__", "__main__", "_dummy_thread", "_thread", "abc", "aifc", "argparse", "array", "ast", "asynchat", "asyncio", "asyncore", "atexit", "audioop", "base64", "bdb", "binascii", "binhex", "bisect", "builtins", "bz2", "cProfile", "calendar", "cgi", "cgitb", "chunk", "cmath", "cmd", "code", "codecs", "codeop", "collections", "colorsys", "compileall", "concurrent", "configparser", "contextlib", "copy", "copyreg", "crypt", "csv", "ctypes", "curses", "datetime", "dbm", "decimal", "difflib", "dis", "distutils", "doctest", "dummy_threading", "email", "encodings", "ensurepip", "enum", "errno", "faulthandler", "fcntl", "filecmp", "fileinput", "fnmatch", "formatter", "fpectl", "fractions", "ftplib", "functools", "gc", "getopt", "getpass", "gettext", "glob", "grp", "gzip", "hashlib", "heapq", "hmac", "html", "http", "imaplib", "imghdr", "imp", "importlib", "inspect", "io", "ipaddress", "itertools", "json", "keyword", "lib2to3", "linecache", "locale", "logging", "lzma", "macpath", "mailbox", "mailcap", "marshal", "math", "mimetypes", "mmap", "modulefinder", "msilib", "msvcrt", "multiprocessing", "netrc", "nis", "nntplib", "numbers", "operator", "optparse", "os", "ossaudiodev", "parser", "pathlib", "pdb", "pickle", "pickletools", "pipes", "pkgutil", "platform", "plistlib", "poplib", "posix", "pprint", "profile", "pstats", "pty", "pwd", "py_compile", "pyclbr", "pydoc", "queue", "quopri", "random", "re", "readline", "reprlib", "resource", "rlcompleter", "runpy", "sched", "select", "selectors", "shelve", "shlex", "shutil", "signal", "site", "smtpd", "smtplib", "sndhdr", "socket", "socketserver", "spwd", "sqlite3", "ssl", "stat", "statistics", "string", "stringprep", "struct", "subprocess", "sunau", "symbol", "symtable", "sys", "sysconfig", "syslog", "tabnanny", "tarfile", "telnetlib", "tempfile", "termios", "test", "textwrap", "threading", "time", "timeit", "tkinter", "token", "tokenize", "trace", "traceback", "tracemalloc", "tty", "turtle", "turtledemo", "types", "typing", "unicodedata", "unittest", "urllib", "uu", "uuid", "venv", "warnings", "wave", "weakref", "webbrowser", "winreg", "winsound", "wsgiref", "xdrlib", "xml", "xmlrpc", "zipapp", "zipfile", "zipimport", "zlib",'



for pkg in ${pkgs[@]}; do
	cnf="$cnf\"$pkg.*\","
	#echo $pkg
done
cnf="$cnf]"

echo "$vim_cnf $cnf"
