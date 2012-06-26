## Put this script in ~/.irssi/scripts[autorun] and load it with "/load perl" and "/script load notify_led".
# References:
# https://github.com/shabble/irssi-docs/wiki/Signals
# https://github.com/shabble/irssi-docs/wiki/Window

use strict;
use Irssi;
use vars qw($VERSION %IRSSI);
#use HTML::Entities;

$VERSION = "0.1";
%IRSSI = (
		authors		=> 'Erik Westrup',
		contact		=> 'erik.westrup@gmail.com',
		name		=> 'notify_led',
		description => 'Blink shortly if there are new window highligths.',
		license		=> 'GNU General Public License',
		url			=> 'http://localhost/',
);

sub notify_led_blink {
		my $tty = `tty`;
		my $cmd_blink_on = '';
		my $cmd_blink_off = '';
		if ($tty =~ m|/dev/tty|) {
				# TODO fix this. It lacks a tty apparently.
				$cmd_blink_on = 'setleds -L +scroll';
				$cmd_blink_off = 'setleds -L -scroll';
		} else {
				$cmd_blink_on = 'xset led named "Scroll Lock"';
				$cmd_blink_off = 'xset -led named "Scroll Lock"';
		}
		my $cmd = "EXEC - for i in {1..5}; do $cmd_blink_on; sleep 0.2s; $cmd_blink_off; sleep 0.2s; done";
		Irssi::command($cmd);
}

sub event_window_activity {
		my ($win, $old_level) = @_;
		if ($win->{'data_level'} == 3) {
				notify_led_blink();
		}
}

Irssi::signal_add('window activity', 'event_window_activity');
