# Lethal Company Modpack

This windows powershell script installs BepInEx dependency, MoreCompany, and other additional mods listed under credits.

Initially, this was made to ease the additional installation of additional mods for [Lethalize](https://github.com/KrystilizeNevaDies/Lethalize) for my friends as an alternative towards a mod manager, but feel free to use it if you'd like.

## Installing

```
powershell -nop -ExecutionPolicy Bypass -c "Invoke-Command -ScriptBlock ([scriptblock]::Create([System.Text.Encoding]::UTF8.GetString((New-Object Net.WebClient).DownloadData('https://github.com/returnkirbo/Lethal-Company-Modpack/releases/download/release/Install-Modpack.ps1')))) -ArgumentList @( `
    '-morecompany','1.7.2', `
    '-skinwalkers','2.0.1', `
    '-helmetcameras','2.1.5', `
    '-moresuits','1.4.1', `
    '-moreemotes','1.2.1', `
    '-boomboxcontroller','1.1.0', `
    '-shiplobby','1.0.2', `
    '-yippee','1.2.2', `
    '-spectateenemies','1.5.0', `
    '-compatibilitychecker','1.1.1', `
    '-activewalkies','1.4.2', `
    '-walkieuse','1.3.1', `
    '-flashlightuse','1.4.1')"
```

Remove parameters if you wish to exclude a mod. Below is an example of what removing ``'-moresuits','1.4.1'`` looks like. (compare it to the install script)

```
powershell -nop -ExecutionPolicy Bypass -c "Invoke-Command -ScriptBlock ([scriptblock]::Create([System.Text.Encoding]::UTF8.GetString((New-Object Net.WebClient).DownloadData('https://github.com/returnkirbo/Lethal-Company-Modpack/releases/download/release/Install-Modpack.ps1')))) -ArgumentList @( `
    '-morecompany','1.7.2', `
    '-skinwalkers','2.0.1', `
    '-helmetcameras','2.1.5')"
```

You can also change the version number by just looking at their corresponding numbers

``'-skinwalkers','2.0.1'``
                  
## Mods used/versions + Credits

Lethal Company -> 45

[BepInExPack](https://thunderstore.io/c/lethal-company/p/BepInEx/BepInExPack/) -> always latest
<br>[MoreCompany](https://thunderstore.io/c/lethal-company/p/notnotnotswipez/MoreCompany/) -> 1.7.2
<br>[SkinWalkers](https://thunderstore.io/c/lethal-company/p/RugbugRedfern/Skinwalkers/) -> 2.0.1
<br>[HelmetCameras](https://thunderstore.io/c/lethal-company/p/RickArg/Helmet_Cameras/) -> 2.1.5
<br>[MoreSuits](https://thunderstore.io/c/lethal-company/p/x753/More_Suits/) -> 1.4.1
<br>[MoreEmotes](https://thunderstore.io/c/lethal-company/p/Sligili/More_Emotes/) -> 1.2.1
<br>[Boombox_Controller](https://thunderstore.io/c/lethal-company/p/KoderTeh/Boombox_Controller/) -> 1.1.0
<br>[ShipLobby](https://thunderstore.io/c/lethal-company/p/tinyhoot/ShipLobby/) -> 1.0.2
<br>[YippeeMod](https://thunderstore.io/c/lethal-company/p/sunnobunno/YippeeMod/) -> 1.2.3
<br>[SpectateEnemies](https://thunderstore.io/c/lethal-company/p/AllToasters/SpectateEnemies/) -> 1.5.0
<br>[CompatibilityChecker](https://thunderstore.io/c/lethal-company/p/Ryokune/CompatibilityChecker/) -> 1.1.1
<br>[AlwaysHearActiveWalkies](https://thunderstore.io/c/lethal-company/p/Suskitech/AlwaysHearActiveWalkies/) -> 1.4.2
<br>[WalkieUse](https://thunderstore.io/c/lethal-company/p/Renegades/WalkieUse/) -> 1.3.1
<br>[FlashlightToggle](https://thunderstore.io/c/lethal-company/p/Renegades/FlashlightToggle/) -> 1.4.1

Want a mod added? Issues? Questions? File an issue and I'll get to you soon.

This is a direct copy of [Lethalize](https://github.com/KrystilizeNevaDies/Lethalize) with additional mod(s), full thanks to KrystilizeNevaDies!
