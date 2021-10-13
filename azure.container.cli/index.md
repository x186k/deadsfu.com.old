



## DeadSFU OBS Streaming from Azure Container using CLI  <!-- omit in toc -->

### Q4 2021 <!-- omit in toc -->


- [What You Will Learn](#what-youll-learn)
- [Thanks](#thanks)
- [Create Azure Account](#create-azure-account)
- [Stopping Instances and Costs](#stopping-instances-and-costs)
- [Installing the CLI *AZ* command](#installing-the-cli-az-command)
- [Logging into Azure from the CLI](#logging-into-azure-from-the-cli)
- [Creating a Resource Group](#creating-a-resource-group)
- [Create the Container Json Template File](#create-the-container-json-template-file)
- [Launch Your Container](#launch-your-container)
- [Get The IP Address](#get-the-ip-address)
- [Open DeadSFU Receive Page](#open-deadsfu-receive-page)
- [Confirm You See The DeadSFU Viewer Page](#confirm-you-see-the-deadsfu-viewer-page)
- [Check OBS Version >= 27.0.1](#check-obs-version--2701)
- [Configure a Camera or Test Source](#configure-a-camera-or-test-source)
- [Launch OBS & Configure FTL](#launch-obs--configure-ftl)
- [Start Streaming](#start-streaming)
- [Whats Next?](#whats-next)
- [Boring: Legal Waiver and Release](#boring-legal-waiver-and-release)


### What You Will Learn

This tutorial will take you through starting an Azure container running DeadSFU
which will allow you to do low-latency OBS streaming (using FTL).

You are then able to share the web page hosted on the container with friends
so they can see your video feee from OBS with sub-second latency.

### Thanks

Thanks to [CJSurret](https://github.com/scj643) for the idea, the technical know-how and, the chops to get this
all working on Azure!

### Create Azure Account

You need an Azure Account. Some Visual Studio licenses include $100 a month of free credits.
Also, in some cases you can qualify for an account with some free resources.

[Free Signup Link](https://azure.microsoft.com/en-us/free/)
I don't get anything if you signup with them, but I hope they'll re-tweet this post. 😍

*A credit card was required for my free account, but I understand the Visual Studio
bundled credit doesn't require a credit card. You'll have to confirm details)*

### Stopping Instances and Costs

Must I really say this?
ALWAYS, ALWAYS make sure to review and stop and container instances when you are done using
your instance.  Even if they don't have your credit card, you may legally be
on the hook for time used and expenses incurred if you leave instances running. Nuf' said.

### Installing the CLI *AZ* command 

Go here to get your AZ command installed, if you haven't already:

[Install AZ command for Azure](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli)

### Logging into Azure from the CLI

A simple command should pop open a browser to allow you to login:
```bash
az login
```

### Creating a Resource Group

I know very little about Azure, but it appears containers need to be launched into instance
groups, so you gotta create one.

```bash
az group create -l eastus2 -n Stream
```

If it works, you'll see something like this:
```
{
  "id": "/subscriptions/xxxxx/resourceGroups/Stream",
  "location": "eastus2",
  "managedBy": null,
  "name": "Stream",
  "properties": {
    "provisioningState": "Succeeded"
  },
  "tags": null,
  "type": "Microsoft.Resources/resourceGroups"
}
```

Note the *Succeeded* in the output.

### Create the Container Json Template File

Create a file, `template.json` with the following Json:

```
{
    "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#",
    "contentVersion": "1.0.0.0",
    "parameters": {
        "containerGroups_deadsfu_name": {
            "defaultValue": "deadsfu",
            "type": "String"
        }
    },
    "variables": {},
    "resources": [
        {
            "type": "Microsoft.ContainerInstance/containerGroups",
            "apiVersion": "2021-03-01",
            "name": "deadsfu",
            "location": "eastus2",
            "properties": {
                "sku": "Standard",
                "containers": [
                    {
                        "name": "deadsfu",
                        "properties": {
                            "image": "x186k/deadsfu",
                            "command": [
                                "/app/main",
                                "--http",
                                ":80",
                                "--ftl-udp-port",
                                "8085",
                                "--ftl-key",
                                "123-abc",
                                "--html",
                                "internal",
                                "--rtp-rx",
                                ":5004"
                            ],
                            "ports": [
                                {
                                    "protocol": "TCP",
                                    "port": 8084
                                },
                                {
                                    "protocol": "TCP",
                                    "port": 80
                                },
                                {
                                    "protocol": "UDP",
                                    "port": 8085
                                },
                                {
                                    "protocol": "UDP",
                                    "port": 5004
                                }
                            ],
                            "environmentVariables": [],
                            "resources": {
                                "requests": {
                                    "memoryInGB": 0.5,
                                    "cpu": 1
                                }
                            }
                        }
                    }
                ],
                "initContainers": [],
                "ipAddress": {
                        "dnsNameLabel": "changeme",
                        "ports": [
                                {
                                    "protocol": "TCP",
                                    "port": 8084
                                },
                                {
                                    "protocol": "TCP",
                                    "port": 80
                                },
                                {
                                    "protocol": "UDP",
                                    "port": 8085
                                },
                                {
                                    "protocol": "UDP",
                                    "port": 5004
                                }
                            ],
                            "type": "Public"


                },
                "restartPolicy": "Never",
                "osType": "Linux"
            }
        }
    ]
}
```

**You may need to change the `changeme` part to get your own hostname, I'm not sure what happens with conflicts.**

**Later, after the first time you get everything working, you may want to change `123-abc`  to a different number-secret, like `46372-foofoo`, it's like a password, and OBS will need to have the right stream-key to work okay.**

We will pull up the IP address later, so hard to say if you need to change that or not.


### Launch Your Container

```bash
az deployment group create --name deadsfu --resource-group Stream --template-file template.json
```

Within the Json output, you should see `"provisioningState": "Succeeded",`


### Get The IP Address

```bash
az container show --resource-group Stream --name deadsfu --output table
```

You should see the IP address.

### Open DeadSFU Receive Page

Now open a browser tab to either the updated hostname, or IP address, something like:

#### Using Hostname:
`http://changeme.eastus2.azurecontainer.io/`, please fix `changeme` as noted earlier.

#### Using IP Address:
Open tab to `http://x.x.x.x` as reported from the `az container show` output, do not add a port.

### Confirm You See The DeadSFU Viewer Page

If you see the following view in your browser tab, then you have launched the SFU successfully.

<img src="image1.png" border="5" style="height:100%;width:100%;object-fit:contain">

If you got this working, you're nearly there, cool!

### Check OBS Version >= 27.0.1

If you don't have OVA installed, go get it:  [OBS homepage](https://obsproject.com/)
Make sure you have version 27.0.1 or greater.

### Configure a Camera or Test Source

This is really beyond this tutorial, but if you have a camera attached to your
system, I recommend you configure it as a `Video Capture Device` in the `Sources` panel.
If you don't have a camera, you might try using an image or video clip as a `Media Source`

### Launch OBS & Configure FTL

Open OBS.
Open `Settings` > `Stream`
Change `Service` to `Custom...`
Change `Server` to `ftl://hostname`   where hostname is the full hostname or IP address you retrieved.
Click `Show` to the right of `Stream Key`, and enter `123-abc` or whatever you substituted in the template.

Save the settings by hitting `OK`


### Start Streaming

Click the `Start Streaming` button.

If everything is working right, you should see your video from OBS in the browser tab.

Something kind of like this, with your video in the center:

<img src="image2.png" border="5" style="height:100%;width:100%;object-fit:contain">


Thanks to Pexels and photographer for image:
https://www.pexels.com/video/men-working-in-the-control-room-of-a-broadcasting-network-company-3433789/



##  Whats Next? / Email Newsletter 

It's up to you where to go from here!

Please subscribe to our newsletter if you'd like more content like this.


[Get the email newletter.](https://docs.google.com/forms/d/e/1FAIpQLSd8rzXabvn73YC_GPRtXZb1zlKPeOEQuHDdVi4m9umJqEaJsA/viewform)




