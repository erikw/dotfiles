# See this script's repository at
# http://github.com/avar/irssi-bitlbee-facebook-rename for further
# information.
# NOTE not needed with bitlbee >=~ 3 with nick_source and nick_format.

use strict;
use warnings;
use Irssi;
use Irssi::Irc;
use Text::Unidecode;
use Encode qw(decode);

our $VERSION = '0.02';
our %IRSSI = (
    authors => do { use utf8; 'Ævar Arnfjörð Bjarmason' },
    contact => 'avarab@gmail.com',
    name    => 'facebook-bitlbee-rename',
    description => 'Rename XMPP chat.facebook.com contacts in bitlbee to human-readable names',
    license => 'GPL',
);

my $bitlbeeChannel = "&bitlbee";
my %nicksToRename = ();

sub message_join
{
  # "message join", SERVER_REC, char *channel, char *nick, char *address
  my ($server, $channel, $nick, $address) = @_;
  my ($username, $host) = split /@/, $address;

  if ($host eq 'chat.facebook.com' and $channel =~ m/$bitlbeeChannel/ and $nick =~ m/$username/)
  {
    $nicksToRename{$nick} = $channel;
    $server->command("whois -- $nick");
  }
}

sub whois_data
{
  my ($server, $data) = @_;
  my ($me, $nick, $user, $host) = split(" ", $data);

  if (exists($nicksToRename{$nick}))
  {
    my $channel = $nicksToRename{$nick};
    delete($nicksToRename{$nick});

    my $ircname = substr($data, index($data,':')+1);

    $ircname = munge_nickname( $ircname );

    if ($ircname ne $nick)
    {
      $server->command("msg $channel rename $nick $ircname");
      $server->command("msg $channel save");
    }
  }
}

sub munge_nickname
{
  my ($nick) = @_;

  $nick = decode('utf8', $nick);
  $nick =~ s/[- ]/_/g;
  $nick = unidecode($nick); 
  $nick =~ s/[^A-Za-z0-9-]//g;
  $nick = substr $nick, 0, 21;

  return "fb_" . $nick;
}

Irssi::signal_add_first 'message join' => 'message_join';
Irssi::signal_add_first 'event 311' => 'whois_data';
