# MoreCompany-Skinwalkers

This windows powershell script installs BepInEx dependency, MoreCompany, as well as the Skinwalkers mod. 

Initially, this was made to ease the additional installation of the Skinwalkers mod alongside MoreCompany for my friends, but feel free to use it if you'd like.

This is a direct copy of [Lethalize](https://github.com/KrystilizeNevaDies/Lethalize) with additional mod(s), full thanks to KrystilizeNevaDies.

## Install MoreCompany + Skinwalkers

``
powershell -nop -ExecutionPolicy Bypass -c "Invoke-Command -ScriptBlock ([scriptblock]::Create([System.Text.Encoding]::UTF8.GetString((New-Object Net.WebClient).DownloadData('https://github.com/returnkirbo/MoreCompany-Skinwalkers/releases/download/release/Install-MoreCompany.ps1')))) -ArgumentList @('-morecompany','1.7.1','-skinwalkers','2.0.1')"
``

## Mods used

[BepInExPack](https://thunderstore.io/c/lethal-company/p/BepInEx/BepInExPack/)
[MoreCompany](https://thunderstore.io/c/lethal-company/p/notnotnotswipez/MoreCompany/)
[SkinWalkers](https://thunderstore.io/c/lethal-company/p/RugbugRedfern/Skinwalkers/)
