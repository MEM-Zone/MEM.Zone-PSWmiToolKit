#region Function Copy-WmiProperty
Function Copy-WmiProperty {
<#
.SYNOPSIS
    This function is used to copy the properties of a WMI class.
.DESCRIPTION
    This function is used to copy the properties of a WMI class to another class. Default qualifier flavors will be used.
.PARAMETER ClassPathSource
    Specifies the class to be copied from.
.PARAMETER ClassPathDestination
    Specifies the class to be copied to.
.PARAMETER PropertyName
    Specifies the property name or names to copy. If this parameter is not specified all properties will be copied.(Optional)
.PARAMETER CreateDestination
    This switch is used to create the destination if it does not exist. Default is: $false.
.EXAMPLE
    Copy-WmiProperty -ClassPathSource 'ROOT\ConfigMgr:MEMZone' -ClassPathDestination 'ROOT\ConfigMgr:MEMZoneBlog' -CreateDestination
.EXAMPLE
    Copy-WmiProperty -ClassPathSource 'ROOT\ConfigMgr:MEMZone' -ClassPathDestination 'ROOT\ConfigMgr:MEMZoneBlog' -PropertyName 'MEMZoneWebSite' -CreateDestination
.NOTES
    This is a module function and can typically be called directly.
.LINK
    https://MEM.Zone/
.LINK
    https://MEM.Zone/PSWmiToolKit-RELEASES
.LINK
    https://MEM.Zone/PSWmiToolKit-GIT
.LINK
    https://MEM.Zone/PSWmiToolKit-ISSUES
#>
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory = $true, Position = 0)]
        [ValidateNotNullorEmpty()]
        [string]$ClassPathSource,
        [Parameter(Mandatory = $true, Position = 1)]
        [ValidateNotNullorEmpty()]
        [string]$ClassPathDestination,
        [Parameter(Mandatory = $false, Position = 2)]
        [ValidateNotNullorEmpty()]
        [string[]]$PropertyName,
        [Parameter(Mandatory = $false, Position = 3)]
        [ValidateNotNullorEmpty()]
        [switch]$CreateDestination = $false
    )

    Begin {
        ## Get the name of this function and write header
        [string]${CmdletName} = $PSCmdlet.MyInvocation.MyCommand.Name
        Write-FunctionHeaderOrFooter -CmdletName ${CmdletName} -CmdletBoundParameters $PSBoundParameters -Header
    }
    Process {
        Try {

            ## Set source and destination paths and name variables
            #  Set NamespaceSource
            $NamespaceSource = (Split-Path -Path $ClassPathSource -Qualifier).TrimEnd(':')
            #  Set NamespaceDestination
            $NamespaceDestination =  (Split-Path -Path $ClassPathDestination -Qualifier).TrimEnd(':')
            #  Set ClassNameSource
            $ClassNameSource = (Split-Path -Path $ClassPathSource -NoQualifier)
            #  Set ClassNameDestination
            $ClassNameDestination = (Split-Path -Path $ClassPathDestination -NoQualifier)

            ## Check if source class exists
            $null = Get-WmiClass -Namespace $NamespaceSource -ClassName $ClassNameSource -ErrorAction 'Stop'

            ## Get source class properties
            $ClassPropertiesSource = Get-WmiProperty -Namespace $NamespaceSource -ClassName $ClassNameSource -ErrorAction 'SilentlyContinue'

            ## Check if the destination class exists
            $ClassDestinationTest = Get-WmiClass -Namespace $NamespaceDestination -ClassName $ClassNameDestination -ErrorAction 'SilentlyContinue'

            ## Create destination class if specified
            If ((-not $ClassDestinationTest) -and $CreateDestination) {
                Copy-WmiClassQualifier -ClassPathSource $ClassPathSource -ClassPathDestination $ClassPathDestination -CreateDestination -ErrorAction 'Stop'
            }
            ElseIf (-not $ClassDestinationTest) {
                $DestinationClassErr = "Destination [$NamespaceSource`:$ClassName] does not exist. Use the -CreateDestination switch to automatically create the destination class."
                Write-Log -Message $DestinationClassErr -Severity 2 -Source ${CmdletName}
                Write-Error -Message $DestinationClassErr -Category 'ObjectNotFound'
            }

            ## Check if there are any properties in if not specified otherwiser
            If ($ClassPropertiesSource) {

                ## Copy all class properties if not specified otherwise
                If (-not $PropertyName) {

                    #  Create destination property and property qualifiers one by one
                    $ClassPropertiesSource | ForEach-Object {
                        #  Create property
                        $CopyClassProperty = New-WmiProperty -Namespace $NamespaceDestination -ClassName $ClassNameDestination -PropertyName $PSItem.Name -PropertyType $PSItem.CimType
                        #  Set qualifier if present in source property
                        If ($PSItem.Qualifiers.Name) {
                            $null = Set-WmiPropertyQualifier -Namespace $NamespaceDestination -ClassName $ClassNameDestination -PropertyName $PSItem.Name -Qualifier @{ Name = $PSItem.Qualifiers.Name; Value = $PSItem.Qualifiers.Value }
                        }
                    }
                }
                Else {

                    ## Copy specified property and property qualifier if it exists in source class, otherwise log the error and continue
                    $ClassPropertiesSource | ForEach-Object {
                        If ($PSItem.Name -in $PropertyName) {
                            #  Create property
                            $CopyClassProperty =  New-WmiProperty -Namespace $NamespaceDestination -ClassName $ClassNameDestination -PropertyName $PSItem.Name -PropertyType $PSItem.CimType
                            #  Set qualifier if present
                            If ($PSItem.Qualifiers.Name) {
                                $null = Set-WmiPropertyQualifier -Namespace $NamespaceDestination -ClassName $ClassNameDestination -PropertyName $PSItem.Name -Qualifier @{ Name = $PSItem.Qualifiers.Name; Value = $PSItem.Qualifiers.Value }
                            }
                        }
                        Else {
                            $ClassPropertyNotFoundErr = "Failed to copy class property [$($PSItem.Name)]. Property not found in source class [$NamespaceSource`:$ClassName]."
                            Write-Log -Message $ClassPropertyNotFoundErr -Severity 3 -Source ${CmdletName}
                        }
                    }
                }
            }
            Else {

                ## If no class properties are found log error but continue execution regardless of the $ErrorActionPreference variable value
                Write-Log -Message "No properties found in source class [$NamespaceSource`:$ClassName]." -Severity 2 -Source ${CmdletName}
            }
        }
        Catch {
            Write-Log -Message "Failed to copy class property. `n$(Resolve-Error)" -Severity 3 -Source ${CmdletName}
            Break
        }
        Finally {
            Write-Output -InputObject $CopyClassProperty
        }
    }
    End {
        Write-FunctionHeaderOrFooter -CmdletName ${CmdletName} -Footer
    }
}
#endregion