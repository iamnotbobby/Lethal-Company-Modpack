# Lethal Company Modpack

This Windows powershell script allows you to install BepInEx (by default) and any [Thunderstore](https://thunderstore.io/c/lethal-company) mods/modpacks for Lethal Company you specify with a dependency string with ease of distribution among your friends.

Initially, this was made to ease the additional installation of additional mods for [Lethalize](https://github.com/KrystilizeNevaDies/Lethalize) for my friends as an alternative towards a mod manager, but feel free to use it if you'd like.

"hey man just pop this script into powershell"

## Installing Singular Mod(s)

In order to install a mod, you must modify the script to your liking. This script takes the dependency string found on Thunderstore mods.

![image](https://github.com/returnkirbo/Lethal-Company-Modpack/assets/107429396/0834bb78-ba80-4c4f-b71a-3d00540a8032)

```
powershell -nop -ExecutionPolicy Bypass -c "Invoke-Command -ScriptBlock ([scriptblock]::Create([System.Text.Encoding]::UTF8.GetString((New-Object Net.WebClient).DownloadData('https://raw.githubusercontent.com/returnkirbo/Lethal-Company-Modpack/14a899f63d397ac6478e5ef7a1368c09ea0d89ca/Install-Modpack.ps1')))) -ArgumentList @( `
'dependencyString', `
'dependencyString')"
```

Below is an example of what a script may look. You may also use this if you'd like.

```
powershell -nop -ExecutionPolicy Bypass -c "Invoke-Command -ScriptBlock ([scriptblock]::Create([System.Text.Encoding]::UTF8.GetString((New-Object Net.WebClient).DownloadData('https://raw.githubusercontent.com/returnkirbo/Lethal-Company-Modpack/14a899f63d397ac6478e5ef7a1368c09ea0d89ca/Install-Modpack.ps1')))) -ArgumentList @( `
'notnotnotswipez-MoreCompany-1.7.4', `
'RugbugRedfern-Skinwalkers-4.0.1', `
'RickArg-Helmet_Cameras-2.1.5', `
'x753-More_Suits-1.4.1', `
'Sligili-More_Emotes-1.3.3', `
'Ozone-Runtime_Netcode_Patcher-0.2.5', `
'KoderTeh-Boombox_Controller-1.1.8', `
'tinyhoot-ShipLobby-1.0.2', `
'sunnobunno-YippeeMod-1.2.3', `
'AllToasters-SpectateEnemies-2.2.1', `
'Rune580-LethalCompany_InputUtils-0.5.5', `
'Suskitech-AlwaysHearActiveWalkies-1.4.4', `
'FlipMods-ReservedWalkieSlot-1.5.5',
'FlipMods-ReservedFlashlightSlot-1.5.10', `
'FlipMods-ReservedItemSlotCore-1.8.11', `
'Stoneman-LethalProgression-1.3.2' `
'EliteMasterEric-Coroner-1.5.3' `
'Evaisa-HookGenPatcher-0.0.5' `
'Evaisa-LethalLib-0.13.0' `
'rhydiaan-NicerTeleporters-1.1.1' `
'malco-Lategame_Upgrades-3.0.2')"
```

Afterwards, execute the script in Windows's powershell. 

## Installing Thunderstore Modpacks + Optional Mod(s)

Below is the given format for installing a modpack. All BepInEx configs that come from modpacks are saved as long they aren't overwritten.
```
powershell -nop -ExecutionPolicy Bypass -c "Invoke-Command -ScriptBlock ([scriptblock]::Create([System.Text.Encoding]::UTF8.GetString((New-Object Net.WebClient).DownloadData('https://raw.githubusercontent.com/returnkirbo/Lethal-Company-Modpack/14a899f63d397ac6478e5ef7a1368c09ea0d89ca/Install-Modpack.ps1')))) -ArgumentList @( `
'modpack','dependencyString')"
```

To add mods ontop of a modpack, just add a new line of arguments similar to installing a singular mod. Declaring a modpack should be the **first** arguments given.
```
powershell -nop -ExecutionPolicy Bypass -c "Invoke-Command -ScriptBlock ([scriptblock]::Create([System.Text.Encoding]::UTF8.GetString((New-Object Net.WebClient).DownloadData('https://raw.githubusercontent.com/returnkirbo/Lethal-Company-Modpack/14a899f63d397ac6478e5ef7a1368c09ea0d89ca/Install-Modpack.ps1')))) -ArgumentList @( `
'modpack','dependencyString', `
'dependencyString')"
```

Afterwards, execute the script in Windows's powershell. 

As of right now, only one modpack can be downloaded so if you wish to add more mods, just add a new line with the correct format.

## Powershell Syntax

Ensure that you have the correct syntax otherwise the script may not execute correctly.
<br>``'`` specifies each invididual argument | ex. ``'notnotnotswipez-MoreCompany-1.7.4'``
<br>``,`` refers to next line, required after a ``'`` | ex. ``'notnotnotswipez-MoreCompany-1.7.4',``
<br>`` ` `` refers to new line | ex. ``'notnotnotswipez-MoreCompany-1.7.4', ` ``

*if you only need one set of arguments, you only need to provide ``)"`` as the closing and not ``,`` or `` ` ``*

If you receive a 404 Not Found error it most likely means that one of the arguments set does not correctly match the given mod either due to misspelling, nonexistent version, or the mod not exist at all.
                  
## Footnotes

Want a mod added? Issues? Questions? File an issue and I'll get to you soon.

The ``readme.md`` download links from the example scripts are commit locked to the latest version, so even if the Powershell file changed on GitHub, the script you copied and pasted into Powershell wouldn't alter unless you had a script that was updated to the latest commit.

This is a modified version of [Lethalize](https://github.com/KrystilizeNevaDies/Lethalize) with the option to add any mod you'd like. Full thanks to KrystilizeNevaDies!
