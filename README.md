# Visual C++ Redist Intune Deployment

*The scripts `Install-VCRedist.ps1`, `Save-VCRedist.ps1`, `Get-VCRedistDetection.ps1`, `New-VCRedistApp.ps1` and the file `VCRedist.json.dist` were originally created by Nickolaj Andersen
 and taken from https://github.com/MSEndpointMgr/Intune/tree/master/Apps/Visual%20C%2B%2B. I have modified them slightly to fit my own needs.*

I needed to distribute Visual C++ Redistributable 2019 and found the excellent work done by [Nickolaj Andersen](https://github.com/Nickolaj) which was pretty much what I needed. Main issue I had with Nicholaj's script is that they are part of a huge git [repo](https://github.com/MSEndpointMgr/Intune) with all sorts of other goodness in there but I wanted something simple that I could maintain as needed for this specific purpose.

# Instructions

## Overview

You need to host the [`VCRedist.json`](VCRedist.json) file somewhere with details of which VC Redist packages you want to deploy. The URL in the repo's scripts is a Container Blob on my Azure subscription and contains only the latest version of vc_redist. So if you use this script, amend [`VCRedist.json`](VCRedist.json) for your own requirements and host on your own server/service.

Whatever versions specified in the [`VCRedist.json`](VCRedist.json) will be installed by the `Install-VCRedist.ps1` script from the Source folder. Note, that ALL versions specified in the JSON file get installed, not just the latest one. So if you use the full list from the .dist file, then all versions will get installed.

## Initial Deployement

1. Download the files from this repo and amend [`VCRedist.json`](VCRedist.json) as needed. The full list of available packages are in the [`VCRedist.json.dist`](VCRedist.json.dist) file.
1. Upload the [`VCRedist.json`](VCRedist.json) file to whatever hosting you are going to be using and update both `Install-VCRedist.ps1` and `Save-VCRedist.ps1` with the relevant URL.
1. Run the `Save-VCRedist.ps1` script to download the relevant packages locally.
1. Import the IntuneWin32App PowerShell module (if you don't already have it) with `Install-Module -Name IntuneWin32App`. Admin rights likely needed to do this. Further details of the module available [here](https://msendpointmgr.com/2020/03/17/manage-win32-applications-in-microsoft-intune-with-powershell/).
1. Run `Connect-MsIntuneGraph` and connect to the relevant tenant where you are doing the Intune deployement.
1. Run the `New-VCRedistApp.ps1` script which should build the Intune package and upload it to whatever tenant you connected to with the `Connect-MsIntuneGraph` command. Once uploaded, the newly created package will NOT be assigned. Go into Intune and assign as needed.

## Subsequent Deployments

When a new version comes out, update the [`VCRedist.json`](VCRedist.json) file on your server/service and repeat the above steps above from the `Save-VCRedist.ps1` script point onwards to get a new Intune packages built and uploaded to Intune.