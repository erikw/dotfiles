use strict;
use warnings;

#####
#
# Version history
#
# 0.4
#	Push hilights
# 0.3
#	Add ability to toggle prowl mode (on/off/auto)
# 0.2
#	Modify to use new API keys, much better!
# 0.1
#	Initial working version
#

# irssi imports
use Irssi;
use Irssi::Irc;
use vars qw($VERSION %IRSSI %config);

use LWP::UserAgent;

$VERSION = "0.2";

%IRSSI = (
	authors => "Denis Lemire",
	contact => "denis\@lemire.name",
	name => "prowl",
	description => "Sets nick away when client discconects from the "
		. "irssi-proxy sends messages to an iPhone via prowl.",
	license => "GPLv2",
	url => "http://www.denis.lemire.name",
);

$config{away_level} = 0;
$config{awayreason} = 'Auto-away because client has disconnected from proxy.';
$config{mode} = 'auto';
$config{debug} = 0;
$config{clientcount} = 0;

sub debug
{
	if ($config{debug}) {
		my $text = shift;
		my $caller = caller;
		Irssi::print('From ' . $caller . ":\n" . $text);
	}
}

sub send_prowl
{
	my ($event, $text) = @_;

	if ($config{mode} eq 'off') {
		debug("Not sending notification, prowl is off.");
		return;
	}

	debug("Sending prowl");

	my %options = ();

	$options{'application'} ||= "Irssi";
	$options{'event'} = $event;
	$options{'notification'} = $text;
	$options{'priority'} ||= 0;

	# Get the API key from STDIN if one isn't provided via a file or from the command line.

	if (open(APIKEYFILE, $ENV{HOME} . "/.prowlkey")) {
		$options{apikey} = <APIKEYFILE>;

		chomp $options{apikey};

		close(APIKEYFILE); 
	} else {
		debug ("Unable to open prowl key file\n");
	}

	# URL encode our arguments
	$options{'application'} =~ s/([^A-Za-z0-9])/sprintf("%%%02X", ord($1))/seg;
	$options{'event'} =~ s/([^A-Za-z0-9])/sprintf("%%%02X", ord($1))/seg;
	$options{'notification'} =~ s/([^A-Za-z0-9])/sprintf("%%%02X", ord($1))/seg;

	# Generate our HTTP request.
	my ($userAgent, $request, $response, $requestURL);
	$userAgent = LWP::UserAgent->new;
	$userAgent->agent("ProwlScript/1.0");

	$requestURL = sprintf("https://prowlapp.com/publicapi/add?apikey=%s&application=%s&event=%s&description=%s&priority=%d",
					$options{'apikey'},
					$options{'application'},
					$options{'event'},
					$options{'notification'},
					$options{'priority'});

	$request = HTTP::Request->new(GET => $requestURL);

	$response = $userAgent->request($request);

	if ($response->is_success) {
		debug ("Notification successfully posted.\n");
	} elsif ($response->code == 401) {
		debug ("Notification not posted: incorrect API key.\n");
	} else {
		debug ("Notification not posted: " . $response->content . "\n");
	}
}

sub client_connect
{
	my $client = shift;
	my $server = $client->{server};
	 
	$config{clientcount}++;
	debug("Client connected.");

	if ($server->{usermode_away}) {
		$server->send_raw('AWAY :');
	}
}

sub client_disconnect
{
	my $client = shift;
	my $server = $client->{server};
	debug('Client Disconnectted');

	$config{clientcount}-- unless $config{clientcount} == 0;

	unless ($server->{usermode_away}) {
		# we are not away on this server already.. set the autoaway
		# reason
		$server->send_raw(
			'AWAY :' . $config{awayreason}
		);
	}
}

sub msg_pub
{
	my ($server, $data, $nick, $mask, $target) = @_;
	 
	if (($server->{usermode_away} == "1" || $config{mode} eq 'on')  && ($data =~ /$server->{nick}/i)) {
		debug("Got pub msg with my name");
		send_prowl ("Mention", $nick . ': ' . $data);
	}
}

sub msg_pri
{
	my ($server, $data, $nick, $address) = @_;
	if ($server->{usermode_away} == "1" || $config{mode} eq 'on') {
		send_prowl ("Private msg", $nick . ': ' . $data);
	}
}

sub msg_hilight
{
	my ($dest, $text, $stripped) = @_;

	my $server = $dest->{server};

	if ($dest->{level} & MSGLEVEL_HILIGHT) {
		if ($server->{usermode_away} == "1" || $config{mode} eq 'on') {
			send_prowl ("Highlight", $stripped);
		}
	}
}

sub cmd_prowl
{
	my ($args, $server, $winit) = @_;

	$args = lc($args);

	if (
		$args =~ /^auto$/ ||
		$args =~ /^on$/ ||
		$args =~ /^off$/
	) {
		if ($args eq $config{mode}) {
			Irssi::print("Prowl mode already $args");
		} else {
			Irssi::print("Prowl mode: $args (was " . $config{mode} . ')' );
			$config{mode} = $args;
		}
	} elsif ($args =~/^test$/) {
		Irssi::print("Sending test prowl notification");
		send_prowl ("Test", "If you can read this, it worked.");
	} elsif ($args =~/^debug$/) {
		if ($config{debug}) {
			$config{debug} = 0;
			Irssi::print("Prowl debug disabled");
		} else {
			$config{debug} = 1;
			Irssi::print("Prowl debug enabled");
		}
	} else {
		Irssi::print('Prowl: Say what?!');
	}
}

Irssi::signal_add_last('proxy client connected', 'client_connect');
Irssi::signal_add_last('proxy client disconnected', 'client_disconnect');
Irssi::signal_add_last('message public', 'msg_pub');
Irssi::signal_add_last('message private', 'msg_pri');
Irssi::command_bind 'prowl' => \&cmd_prowl;
Irssi::signal_add_last("print text", "msg_hilight");
