function Get-PlatformInfo {
    $arch = [System.Environment]::GetEnvironmentVariable("PROCESSOR_ARCHITECTURE")
    
    switch ($arch) {
        "AMD64" { return "X64" }
        "IA64" { return "X64" }
        "ARM64" { return "X64" }
        "EM64T" { return "X64" }
        "x86" { return "X86" }
        default { throw "Unknown architecture -> $arch. Submit a bug report to KrystilizeNevaDies/Lethalize." }
    }
}

function Request-String($url) {
    $webClient = New-Object System.Net.WebClient
    $webClient.Headers.Add("User-Agent", "Lethal Mod Installer PowerShell Script")
    return $webClient.DownloadString($url)
}

function Request-Stream($url) {
    $webClient = New-Object System.Net.WebClient
    $webClient.Headers.Add("User-Agent", "Lethal Mod Installer PowerShell Script")
    return [System.IO.MemoryStream]::new($webClient.DownloadData($url))
}

function Expand-Stream($zipStream, $destination) {
    # create a temporary file to save the stream content
    $tempFilePath = [System.IO.Path]::GetTempFileName()

    # replace the temporary file extension with .zip
    $tempFilePath = [System.IO.Path]::ChangeExtension($tempFilePath, "zip")

    # save the stream content to the temporary file
    $zipStream.Seek(0, [System.IO.SeekOrigin]::Begin)
    $fileStream = [System.IO.File]::OpenWrite($tempFilePath)
    $zipStream.CopyTo($fileStream)
    $fileStream.Close()

    # extract the temporary file to the destination folder
    Expand-Archive -Path $tempFilePath -DestinationPath $destination -Force

    # delete the temporary file
    Remove-Item -Path $tempFilePath -Force
}

function Get-Arg($arguments, $argName) {
    $argIndex = [Array]::IndexOf($arguments, $argName)
    if ($argIndex -eq -1) {
        throw "Argument $argName not found"
    }
    return $arguments[$argIndex + 1]
}

function Install-Package {
    param (
        [string]$packageName,
        [string]$packageArgument,
        [string]$lethalCompanyPath
    )

    Write-Host "Downloading and installing -> $packageName"
    
    $packageVersion = Get-Arg $arguments $packageArgument
    $packageUrl = "https://thunderstore.io/package/download/$packageName/$packageVersion/"
    $packageStream = Request-Stream $packageUrl
	
	# create a temporary directory to extract the contents
    $tempDir = New-Item -ItemType Directory -Path (Join-Path $env:TEMP -ChildPath ([System.Guid]::NewGuid().ToString()))

    try {
        Expand-Stream $packageStream $tempDir.FullName

        # checks for correct path
        $bepInExFolder = Join-Path $tempDir.FullName "BepInEx"
		$pluginsFolder = Join-Path $tempDir.FullName "plugins"
		
        if (Test-Path $bepInExFolder -PathType Container) {
            $installPath = $lethalCompanyPath
        } elseif (Test-Path $pluginsFolder -PathType Container){
            $installPath = $bepInExPath
        } else {
			$installPath = $pluginsPath
		}

        # move the contents to the installation path
		Copy-Item $tempDir\* -Destination $installPath -Recurse -Force
    } finally {
        # clean up the temporary directory
        Remove-Item $tempDir -Recurse -Force
    }

    Write-Host "Installed $packageName @ $installPath"
    Write-Host ""
}

function Install ($arguments) {
    $response = Request-String "https://api.github.com/repos/BepInEx/BepInEx/releases/latest"
    $jsonObject = ConvertFrom-Json $response

    $platform2Asset = @{}

    foreach ($assetNode in $jsonObject.assets) {
        if ($null -eq $assetNode) { continue }

        $asset = $assetNode

        $name = $asset.name

        switch -Wildcard ($name) {
            "BepInEx_unix*" { $platform2Asset["Unix"] = $asset.browser_download_url; break }
            "BepInEx_x64*" { $platform2Asset["X64"] = $asset.browser_download_url; break }
            "BepInEx_x86*" { $platform2Asset["X86"] = $asset.browser_download_url; break }
        }
    }

    $platform = Get-PlatformInfo
    Write-Host "Detected platform -> $platform"

    $assetUrl = $platform2Asset[$platform]

    if ($null -eq $assetUrl) {
        throw "Failed to find asset for platform $platform"
    }

    Write-Host "Downloading $assetUrl"
    $stream = Request-Stream $assetUrl
    Write-Host "Downloaded $assetUrl"
    Write-Host ""

    $lethalCompanyPath = (Get-ItemProperty -Path "Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Steam App 1966720").InstallLocation
    if ($null -eq $lethalCompanyPath) {
        throw "Steam Lethal Company install not found"
    }
	
	$pluginsPath = Join-Path -Path $lethalCompanyPath -ChildPath 'BepInEx\plugins'
    if ($null -eq $pluginsPath) {
        throw "BepInEx folder not found"
    }

    $bepInExPath = Join-Path $lethalCompanyPath "BepInEx"

    Write-Host "Lethal Company path found -> $lethalCompanyPath"
    Write-Host ""
    
    if (Test-Path $bepInExPath) {
        Write-Host "Deleting old files"
        Remove-Item $bepInExPath -Recurse -Force
        Write-Host "Deleted old files"
        Write-Host ""
    }

    Write-Host "Installing BepInEx"
    Expand-Stream $stream $lethalCompanyPath
    Write-Host "Installed BepInEx"
    Write-Host ""
	
	# process package arguments dynamically
	for ($i = 0; $i -lt $arguments.Count; $i += 2) {
		$packageNameWithDash = $arguments[$i]
		$packageVersion = $arguments[$i + 1]

		# remove the leading '-' character from the package name
		$packageName = $packageNameWithDash -replace '^-', ''

		Install-Package -packageName $packageName -packageArgument $packageNameWithDash -lethalCompanyPath $lethalCompanyPath -version $packageVersion
	}
}


try {
    Install $args

    Write-Host "Install successful"
} catch {
    Write-Host "Install failed -> $_"
}

Read-Host “Press ENTER to exit...”