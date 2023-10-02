#region Function Set-WmiInstance
Function Set-WmiInstance {
<#
.SYNOPSIS
    This function is used to modify a WMI Instance.
.DESCRIPTION
    This function is used to modify or optionaly creating a WMI Instance if it does not exist using CIM.
.PARAMETER Namespace
    The Class Namespace.
    The Default is ROOT\cimv2.
.PARAMETER ClassName
    The Class Name.
.PARAMETER Key
    The Properties that are used as keys (Optional).
.PARAMETER PropertySearch
    The Class Instance Properties and Values to find.
.PARAMETER Property
    The Class Instance Properties and Values to set.
.PARAMETER CreateInstance
    Switch for creating the instance if it does not exist.
    Default is $false
.EXAMPLE
    [hashtable]$PropertySearch = @{
        'ServerPort' = '99'
        'ServerIP' = '10.10.10.10'
    }
    [hashtable]$Property = @{
        'ServerPort' = '88'
        'ServerIP' = '11.11.11.11'
        'Source' = 'File1'
        'Date' = $(Get-Date)
    }
    Set-WmiInstance -Namespace 'ROOT' -ClassName 'MEMZone' -Key 'File1' -PropertySearch $PropertySearch -Property $Property
.EXAMPLE
    Set-WmiInstance -Namespace 'ROOT' -ClassName 'MEMZone' -Key 'File1' -Property $Property
.EXAMPLE
    Set-WmiInstance -Namespace 'ROOT' -ClassName 'MEMZone' -Property $Property -CreateInstance
.NOTES
    This is a module function and can typically be called directly.
.LINK
    https://MEM.Zone
.LINK
    https://MEMZ.one/PSWmiToolKit-RELEASES
.LINK
    https://MEMZ.one/PSWmiToolKit-GIT
.LINK
    https://MEMZ.one/PSWmiToolKit-ISSUES
#>
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory = $false, Position = 0)]
        [string]$Namespace = 'ROOT\cimv2',
        [Parameter(Mandatory = $false, Position = 1)]
        [string]$ClassName = 'MEMZone',
        [Parameter(Mandatory = $false, Position = 2)]
        [string[]]$Key = '',
        [Parameter(Mandatory = $false, Position = 3)]
        [hashtable]$PropertySearch = '',
        [Parameter(Mandatory = $true, Position = 4)]
        [hashtable]$Property,
        [Parameter(Mandatory = $false, Position = 5)]
        [switch]$CreateInstance = $false,
        [PSCustomObject]$Result = @()
    )

    Try {

                #move to get instance?

                #  Get Property Names from function input to be used for filtering
                [string[]]$ClassPropertyNames =  $($Property.GetEnumerator().Name)

                #  Get all Instances for the specified Wmi Class, selecting only specified Property Names
                [PSCustomObject]$ClassInstances = Get-CimInstance -Namespace $Namespace -ClassName $ClassName -ErrorAction 'Continue' | Select-Object $ClassPropertyNames

                #  Convert Property hashtable to PSCustomObject for comparison
                [PSCustomObject]$InputProperty = [PSCustomObject]$Property

                #  -ErrorAction 'SilentlyContinue' does not seem to work correctly with the Compare-Object commandlet so it needs to be set globaly
                $ErrorActionPreferenceOriginal = $ErrorActionPreference
                $ErrorActionPreference = 'SilentlyContinue'

                #  Check if and instance with the same values exists. Since $InputProperty is a dinamically generated object Compare-Object has no hope of working correctly.
                #  Luckily Compare-Object as a -Property parameter which allows us to look at specific parameters.
                $InstanceSearch = Compare-Object -ReferenceObject $InputProperty -DifferenceObject $ClassInstances -Property $ClassPropertyNames -IncludeEqual -ExcludeDifferent

                #  Setting the ErrorActionPreference back to the previous value
                $ErrorActionPreference = $ErrorActionPreferenceOriginal

                #  If no matching instance is found, create a new instance, else write error
                If (-not $InstanceSearch) {
                    $NewInstance = & $NewInstanceScriptBlock
                }




        ## Set Connection Props
        [hashtable]$ConnectionProps = @{ NameSpace = $Namespace; ClassName = $ClassName }

        ## Test if the Class exists
        [bool]$ClassTest = Get-WmiClass -Namespace $Namespace -ClassName $ClassName
        If ($ClassTest) {

            ## If -PropertySearch parameter was specified use it to get the instances
            If ($PropertySearch) {
                $InstanceTest = Get-WmiInstance -Namespace $Namespace -ClassName $ClassName -Property $InputProperty -ErrorAction 'SilentlyContinue'
            }

            ## If the -PropertySearch parameter was not specified, use the -Property do get the instances
            Else {
                $InstanceTest = Get-WmiInstance -Namespace $Namespace -ClassName $ClassName -Property $Property -ErrorAction 'SilentlyContinue'
            }

            ## Count Instances
            [int16]$InstanceCount = ($InstanceTest | Measure-Object).Count

            ## Perform actions depending on the $InstanceTest result
            Switch ($InstanceCount) {

                #  If $InstanceTest is not $null and contains just one instance, Set the new values
                '1' { $Result = $InstanceTest | Set-CimInstance -Property $Property -ErrorAction 'Stop' }

                #  If $InstanceTest is not $null and contains more than one instance, abort and return error message
                { $PSItem -gt '1' } { $Result = 'Set Instance - Failed! More than one instance with the specified values found!' }

                #  If $InstanceTest is $null, the -CreateInstance switch was specified and not matching instance exists, create a new instance with the specified values
                { $PSItem -eq '0' -and (-not $InstanceTest) -and $CreateInstance } {

                    #  Create a new instance with or without the key parameter
                    If ($Key) {
                        $Result = New-CimInstance -Namespace $Namespace -ClassName $ClassName -Key $Key -Property $Property -ErrorAction 'Stop'
                    }
                    Else {
                        $Result = New-CimInstance -Namespace $Namespace -ClassName $ClassName -Property $Property -ErrorAction 'Stop'
                    }
                }
                Default { $Result = 'Unhandled Exception!' }
            }
        }
        Else {
            $Result = "Set Instance - Failed! $Namespace`:$ClassName does not exist!"
        }
    }
    Catch {
        $Result = "Set Instance - Failed! `n $PSItem"
    }
    Finally {
        Write-Output -InputObject $Result
    }
}
#endregion