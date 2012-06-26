var INFO = 
<plugin name="Last.fm Now Playing" version="0.1"
        href=""
        summary="Last song played and scrobbled at Last.fm">
    <author email="erik.westrup@gmail.com" href="http://2r.se/">Erik Westrup</author>
    <license href="http://opensource.org/licenses/mit-license.php">MIT</license>
    <project name="Vimperator" minVersion="2.0" maxVersion="3.5"/>
    <description>
        Open up the last song played and scrobbles at Last.fm
        <ul>
            <li>:lastnp  - Open URL to last scrobble</li>
        </ul>
    </description>
</plugin>;

commands.addUserCommand ("lastnp", "Open URL to last scrobble.",
    function (args) {
        util.httpGet ("http://ws.audioscrobbler.com/2.0/?method=user.getrecenttracks&limit=1&format=json&user=erikwestrup&api_key=b25b959554ed76058ac220b7b2e0a026", function (req) {
			if (req.status == 200) {
                                var npObj = JSON.parse(req.responseText);
                                //liberator.echo("Got it! ");
				liberator.echo( npObj.recenttracks.track.artist["#text"] + " - " + npObj.recenttracks.track.name);
                                //window.open(npObj.recenttracks.track.url);
                                liberator.open(npObj.recenttracks.track.url, liberator.NEW_TAB);

			} else liberator.echoerr("Error contacting Last.fm!\n");
        });
    }
);

/* vim:se sts=4 sw=4 et: */
