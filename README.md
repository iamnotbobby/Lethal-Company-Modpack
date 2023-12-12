# MoreCompany-Skinwalkers
MoreCompany + Skinwalkers

This windows powershell script installs BepInEx dependency, MoreCompany, as well as the Skinwalkers mod. This is a copy of [Lethalize](https://github.com/KrystilizeNevaDies/Lethalize), full thanks to KrystilizeNevaDies.

``
powershell -nop -ExecutionPolicy Bypass -c "Invoke-Command -ScriptBlock ([scriptblock]::Create([System.Text.Encoding]::UTF8.GetString((New-Object Net.WebClient).DownloadData('https://github.com/returnkirbo/MoreCompany-Skinwalkers/releases/download/release/Install-MoreCompany.ps1')))) -ArgumentList @('-morecompany','1.7.1','-skinwalkers','2.0.1')"
``

https://thunderstore.io/c/lethal-company/p/BepInEx/BepInExPack/
https://thunderstore.io/c/lethal-company/p/notnotnotswipez/MoreCompany/
https://thunderstore.io/c/lethal-company/p/RugbugRedfern/Skinwalkers/
