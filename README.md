# MoreCompany + Additional Mods 

This windows powershell script installs BepInEx dependency, MoreCompany, and other additional mods listed under credits.

Initially, this was made to ease the additional installation of the Skinwalkers mod alongside MoreCompany for my friends, but feel free to use it if you'd like.

## Install MoreCompany + Skinwalkers

``
powershell -nop -ExecutionPolicy Bypass -c "Invoke-Command -ScriptBlock ([scriptblock]::Create([System.Text.Encoding]::UTF8.GetString((New-Object Net.WebClient).DownloadData('https://github.com/returnkirbo/MoreCompany-Skinwalkers/releases/download/release/Install-MoreCompany.ps1')))) -ArgumentList @('-morecompany','1.7.2','-skinwalkers','2.0.1','-helmetcameras','2.1.5','-moresuits','1.4.1')"
``

Remove parameters if you wish to exclude a mod. Below is an example of what removing ``'-moresuits','1.4.1'`` looks like.

``
powershell -nop -ExecutionPolicy Bypass -c "Invoke-Command -ScriptBlock ([scriptblock]::Create([System.Text.Encoding]::UTF8.GetString((New-Object Net.WebClient).DownloadData('https://github.com/returnkirbo/MoreCompany-Skinwalkers/releases/download/release/Install-MoreCompany.ps1')))) -ArgumentList @('-morecompany','1.7.2','-skinwalkers','2.0.1','-helmetcameras','2.1.5')"
``

## Mods used + Credits

[BepInExPack](https://thunderstore.io/c/lethal-company/p/BepInEx/BepInExPack/)
[MoreCompany](https://thunderstore.io/c/lethal-company/p/notnotnotswipez/MoreCompany/)
[SkinWalkers](https://thunderstore.io/c/lethal-company/p/RugbugRedfern/Skinwalkers/)
[HelmetCameras](https://thunderstore.io/c/lethal-company/p/RickArg/Helmet_Cameras/)
[MoreSuits](https://thunderstore.io/c/lethal-company/p/x753/More_Suits/)
[BetterEmotes](https://thunderstore.io/c/lethal-company/p/Sligili/More_Emotes/)

This is a direct copy of [Lethalize](https://github.com/KrystilizeNevaDies/Lethalize) with additional mod(s), full thanks to KrystilizeNevaDies!
