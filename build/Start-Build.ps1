Param (
    $Task = 'Default'
)

Function Install-PSDepend {
    <#
.SYNOPSIS
    Bootstrap PSDepend
.DESCRIPTION
    Bootstrap PSDepend

    Why? No reliance on PowerShellGallery
        * Downloads nuget to your ~\ home directory
        * Creates $Path (and full path to it)
        * Downloads module to $Path\PSDepend
        * Moves nuget.exe to $Path\PSDepend (skips nuget bootstrap on initial PSDepend import)
.PARAMETER Path
    Module path to install PSDepend

    Defaults to Profile\Documents\WindowsPowerShell\Modules
.EXAMPLE
    .\Install-PSDepend.ps1 -Path C:\Modules

    # Installs to C:\Modules\PSDepend
#>
    [cmdletbinding()]
    Param (
        [string]$Path = $( Join-Path ([Environment]::GetFolderPath('MyDocuments')) 'WindowsPowerShell\Modules')
    )
    $ExistingProgressPreference = "$ProgressPreference"
    $ProgressPreference = 'SilentlyContinue'
    Try {
        ## Bootstrap nuget if we don't have it
        If (-not ($NugetPath = (Get-Command 'nuget.exe' -ErrorAction SilentlyContinue).Path)) {
            $NugetPath = Join-Path -Path $ENV:USERPROFILE -ChildPath nuget.exe
            if(-not (Test-Path $NugetPath)) {
                Invoke-WebRequest -uri 'https://dist.nuget.org/win-x86-commandline/latest/nuget.exe' -OutFile $NugetPath
            }
        }

        ## Bootstrap PSDepend, re-use nuget.exe for the module
        If ($path) { $null = mkdir $path -Force }
        $NugetParams = 'Install', 'PSDepend', '-Source', 'https://www.powershellgallery.com/api/v2/',
                    '-ExcludeVersion', '-NonInteractive', '-OutputDirectory', $Path
        & $NugetPath @NugetParams
        Move-Item -Path $NugetPath -Destination "$(Join-Path -Path $Path -ChildPath PSDepend)\nuget.exe" -Force
    }
    finally {
        $ProgressPreference = $ExistingProgressPreference
    }
}

## Install PSDepend if not available
Get-PackageProvider -Name NuGet -ForceBootstrap | Out-Null
If (-not (Get-Module -ListAvailable PSDepend)) {
        Install-PSDepend
}

## Set dependencies
[hashtable]$BuildRequirements = @{
    # Some defaults for all dependencies
    PSDependOptions = @{
        Target = '$ENV:USERPROFILE\Documents\WindowsPowerShell\Modules'
        AddToPath = $True
        Parameters = @{
            Force = $True
        }
    }

    # Grab some modules without depending on PowerShellGet
    'psake' = @{ DependencyType = 'PSGalleryNuget' }
    'PSDeploy' = @{ DependencyType = 'PSGalleryNuget' }
    'BuildHelpers' = @{ DependencyType = 'PSGalleryNuget' }
    'Pester' = @{
        DependencyType = 'PSGalleryNuget'
        Version = '4.1.1'
    }
}

## Import PSDepend module and resolve build requirements
Import-Module PSDepend
$null = Invoke-PSDepend -InputObject $BuildRequirements -Install -Import -Force

## Resolve build environment
Set-BuildEnvironment -Force

## Makes variables declared in Build.PSake available in other scriptblocks, performs custom tasks depending on input
Invoke-PSake $PSScriptRoot\Build.PSake.ps1 -TaskList $Task -NoLogo

## Exit build build
Exit ( [int]( -not $PSake.Build_Success ) )

## Build Help
<#
    New-MarkdownHelp -Module PSWmiToolKit -OutputFolder 'D:\GitHub\PSWmiToolKit\docs\help\markdown' -WithModulePage

    $CabFilesFolder = 'D:\GitHub\PSWmiToolKit\docs\help\offline'
    $LandingPagePath = 'D:\GitHub\PSWmiToolKit\docs\help\markdown\PSWmiToolKit.md'
    $OutputFolder = 'D:\GitHub\PSWmiToolKit\docs\help\updatable'

    New-ExternalHelpCab -CabFilesFolder $CabFilesFolder -LandingPagePath $LandingPagePath -OutputFolder $OutputFolder -IncrementHelpVersion

#>