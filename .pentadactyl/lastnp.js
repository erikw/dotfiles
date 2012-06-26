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

group.commands.add(["lastnp", "lnp"], "Open URL to last Last.fm scrobble.",
    function (args) {
        util.httpGet ("http://ws.audioscrobbler.com/2.0/?method=user.getrecenttracks&limit=1&format=json&user=erikwestrup&api_key=b25b959554ed76058ac220b7b2e0a026", function (req) {
                        if (req.status == 200) {
                                dactyl.echo("OKAY12");
                                var jsonText = String(req.responseText);
                                var npObj = JSON.parse(stripped.replace("/#text/g", "text"));
                                //var npObj = eval("(" + stripped +")");
                                //dactyl.echo(npObj.recenttracks.track.url);
                                ////window.open(npObj.recenttracks.track.url);
                                dactyl.echo(npObj);
                                dactyl.echo("here");
                                //dactyl.open(npObj.recenttracks.track.url, dactyl.NEW_TAB);
				//dactyl.echo(npObj.recenttracks.track.artist.text + " - " + npObj.recenttracks.track.name);

                        } else dactyl.echoerr("Error contacting Last.fm!\n");
        });
    }
);

/* vim:se sts=4 sw=4 et: */

