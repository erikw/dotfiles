Unfortuantely $XDG_CONFIG_HOME was implemented wrong 
https://github.com/curl/curl/commit/4be1f8dc01013e4dee2b99026cd3b806ea7253c4

Thus creating symlink $XDG_CONFIG_HOME/.curlrc -> $XDG_CONFIG_HOME/curl/curlrc
