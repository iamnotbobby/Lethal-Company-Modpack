function Get-PlatformInfo {
    $arch = [System.Environment]::GetEnvironmentVariable("PROCESSOR_ARCHITECTURE")
    
    switch ($arch) {
        "AMD64" { return "X64" }
        "IA64" { return "X64" }
        "ARM64" { return "X64" }
        "EM64T" { return "X64" }
        "x86" { return "X86" }
        default { throw "Unknown architecture -> $arch. Submit a bug report to https://github.com/returnkirbo/Lethal-Company-Modpack/" }
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
	$exclusionList = @("README.md", "CHANGELOG.md", "icon.png")
	
	# delete the specified files since they are useless
    foreach ($file in $exclusionList) {
        $filePath = Join-Path $destination $file
        if (Test-Path $filePath -PathType Leaf) {
            Remove-Item $filePath -Force
        }
    }

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
        [string]$packageVersion,
        [string]$lethalCompanyPath
    )

    Write-Progress "Downloading and installing -> $packageName/$packageArgument at v$packageVersion"
    
    $packageUrl = "https://thunderstore.io/package/download/$packageName/$packageVersion/"
    $packageStream = Request-Stream $packageUrl
	
	# create a temporary directory to extract the contents
    $tempDir = New-Item -ItemType Directory -Path (Join-Path $env:TEMP -ChildPath ([System.Guid]::NewGuid().ToString()))

    try {
        Expand-Stream $packageStream $tempDir.FullName

        # checks for correct path
        $bepInExFolder = Join-Path $tempDir.FullName "BepInEx"
	$pluginsFolder = Join-Path $tempDir.FullName "plugins"
	$configFolder = Join-Path $tempDir.FullName "config"

	$pluginsCheck = Join-Path $bepInExPath "plugins"
        $coreCheck = Join-Path $bepInExPath "core"
        $configCheck = Join-Path $bepInExPath "config"
		
		# ensure the required folders exist to prevent "file" format being created
        if (-not (Test-Path $pluginsCheck -PathType Container)) {
            New-Item -ItemType Directory -Path $pluginsCheck | Out-Null
	    Write-Warning "Plugins folder created."
     		Write-Host ""
        }
        if (-not (Test-Path $coreCheck -PathType Container)) {
            New-Item -ItemType Directory -Path $coreCheck | Out-Null
	    Write-Warning "Core folder created."
     		Write-Host ""
        }
        if (-not (Test-Path $configCheck -PathType Container)) {
            New-Item -ItemType Directory -Path $configCheck | Out-Null
	    Write-Warning "Config folder created."
     		Write-Host ""
        }
		
	# path correction
        if (Test-Path $bepInExFolder -PathType Container) {
            $installPath = $lethalCompanyPath
        } elseif (Test-Path $pluginsFolder -PathType Container){
            $installPath = $bepInExPath
		} elseif (Test-Path $configFolder -PathType Container) {
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
    
    # checks for modpack declaration
    if ($arguments[0] -contains 'modpack') {

		# split the dependency string info into author, modname, and version
		$packageParts = $arguments[$i+1] -split '-'
		$packageVersion = $arguments[$i+1] -replace '^.*-(\d+\.\d+\.\d+)$', '$1'
		$packageName = "$($packageParts[0])/$($packageParts[1])"
	
		# ensuring that config folders & other folders aren't left behind before downloading other mods
		Install-Package -packageName $packageName -packageVersion $packageVersion -lethalCompanyPath $lethalCompanyPath
		Write-Warning "Modpack $packageName files installed, attempting install of dependencies from manifest.json now."
		Write-Host ""
		
        $packageUrl = "https://thunderstore.io/package/download/$packageName/$packageVersion"
		
        # unzip the file to a temporary directory to read manifest.json
        $tempDir = New-Item -ItemType Directory -Path (Join-Path $env:TEMP -ChildPath ([System.Guid]::NewGuid().ToString()))
        Expand-Stream (Request-Stream $packageUrl) $tempDir.FullName

        try {
            $manifestPath = Join-Path $tempDir.FullName "manifest.json"
	    
            if (Test-Path $manifestPath -PathType Leaf) {
				$manifestContent = Get-Content $manifestPath -Raw | ConvertFrom-Json

                foreach ($dependency in $manifestContent.dependencies) {
					# assuming dependency is formatted as "Author-ModName-Version"
					$dependencyParts = $dependency -split '-'
					$dependencyAuthor = $dependencyParts[0]
	                $dependencyModName = $dependencyParts[1]
	                $dependencyVersion = $dependencyParts[2]
	
	                # combining into singular package name
	                $dependencyPackageName = "$dependencyAuthor/$dependencyModName"
					
			if ($dependencyModName -ne "BepInExPack"){
  				Install-Package -packageName $dependencyPackageName -packageVersion $dependencyVersion -lethalCompanyPath $lethalCompanyPath
     			} else {
       				Write-Host "Skipping installation of BepInEx as it's already installed."
				Write-Host ""
   				}
                }
            } else {
	    	Write-Host "Manifest file not found in the modpack archive."
		}
        } finally {
			Remove-Item $tempDir -Recurse -Force
				
			Write-Warning "Modpack dependencies installed. Installing other mods if there are any requested by the user."
			Write-Host ""
			
		for ($i = 2; $i -lt $arguments.Count; $i += 1) {
			
			# split the dependency string info into author, modname, and version
			$packageParts = $arguments[$i] -split '-'
			$packageVersion = $arguments[$i] -replace '^.*-(\d+\.\d+\.\d+)$', '$1'
			$packageName = "$($packageParts[0])/$($packageParts[1])"
				
			Install-Package -packageName $packageName -packageVersion $packageVersion -lethalCompanyPath $lethalCompanyPath
		}
	}
	} else {
 		# process multiple package arguments dynamically if it's not a modpack
		for ($i = 0; $i -lt $arguments.Count; $i++) {
			
			# split the dependency string info into author, modname, and version
			$packageParts = $arguments[$i] -split '-'
			$packageVersion = $arguments[$i] -replace '^.*-(\d+\.\d+\.\d+)$', '$1'
			$packageName = "$($packageParts[0])/$($packageParts[1])"
		
			Install-Package -packageName $packageName -packageVersion $packageVersion -lethalCompanyPath $lethalCompanyPath
		}
	}
}


try {
    Install $args
    Write-Host "Install successful"
} catch {
    Write-Error "Install failed -> $_"
}

Read-Host “Press ENTER to exit...”
