# Install restic on Windows
* in git-bash, create ~/bin/restic
* Clone my repo https://github.com/erikw/restic-systemd-automatic-backup
* Move needed files (etc/ usr/local) to ~/bin/restic as root directory
** Thus ~/bin/restic/etc, ~/bin/restic/usr/local/sbin
* Install restic from scoop: $(scoop install restic)
* In git bash, source b2_env.sh and initialize repo as normal.
* Finally install scheduled job with ./install_restic_schedulejob.ps1 

