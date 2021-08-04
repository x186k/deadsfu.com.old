

# Tutorial on Browser Sending

### Install

You need to download and untar the binary from the [install help](/#install), before starting this walkthough.

### Start the SFU:

You should have a file: `deadsfu` or `deadsfu.exe`, or Docker image ready.

_You can use another hostname instead of `tom42`, just choose something unique._
We suggest you use a ddns5.com names for getting started, but non-ddns5.com are possible. To learn about other domain name usage, see the deadsfu flags.

Linux/macOS
```bash
./deadsfu https://tom42.ddns5.com:8443
```
Windows
```
.\\deadsfu.exe https://tom42.ddns5.com:8443
```
Docker
```bash
docker run --network host x186k/deadsfu /app/main https://tom42.ddns5.com:8443
```

The SFU will print some informational mesages.

Wait 5-20 seconds for this message: `HTTPS READY: Certificate Acquired`

Open your browser to the console: `https://tom42.ddns5.com:8443`


### Your SFU is now ready to use.

Instead of `tom42`, you may use another hostname. Your hostname will be tied to the IP address of the server.


## Open Browser to Send/Receive Page

With the SFU running, copy the following URL and open it in your browser
```
https://tom42.ddns5.com
```

## Start Transmitting

Open one browser tab to the URL you copied.

You should have a camera connected to your system for transmission.

Hit the `Send` button.

You should see video of yourself as captured from your camera.

This video is being sent to the SFU and ready for distribution.

<figure>
<img src="send-button.png" border="5" style="height:100%;width:100%;object-fit:contain">
</figure>


## Start Receiving

Open one, two, or three browser tabs to the URL you copied.

In each, hit the `Receive` button.

In a second or two, you should see video being relayed from the SFU.

<figure>
<img src="receive-button.png" border="5" style="height:100%;width:100%;object-fit:contain">
</figure>

## Try Simulcast

By default when you send, you are sending using Simulcast, this means the sending-tab
is encoding and sending three different levels of video.

You change which of the three simulcast channels you are viewing by using the `Channel` drop down.

<figure>
<img src="select-channel.png" border="5" style="height:100%;width:100%;object-fit:contain">
</figure>



That's it for this tutorial.





<script>
function replace(element, from, to) {
    if (element.childNodes.length) {
        element.childNodes.forEach(child => replace(child, from, to))
    } else {
        const cont = element.textContent
        if (cont) element.textContent = cont.replaceAll(from, to)
    }
}

var words = ['liam','olivia','noah','emma','oliver','ava','cameron','elliott']
var word = words[Math.floor(Math.random() * words.length)]
var namenum = word + Math.floor(Math.random() * 1e4)

let elems = document.querySelectorAll('code')
for (i = 0; i < elems.length; i++) {
  replace(elems[i],"tom42",namenum)
}
</script> 
