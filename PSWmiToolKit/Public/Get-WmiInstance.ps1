#region Function Get-WmiInstance
Function Get-WmiInstance {
<#
.SYNOPSIS
    This function is used get the values of an WMI instance.
.DESCRIPTION
    This function is used find a WMI instance by comparing properties. It will return the the instance where all specified properties match.
.PARAMETER Namespace
    Specifies the namespace where to search for the WMI class. Default is: 'ROOT\cimv2'.
.PARAMETER ClassName
    Specifies the class name for which to get the instance properties.
.PARAMETER Property
    Specifies the class instance properties and values to find.
.PARAMETER KeyOnly
    Indicates that only objects with key properties populated are returned.
.EXAMPLE
    [hashtable]$Property = @{
        'ServerPort' = '80'
        'ServerIP' = '10.10.10.11'
        'Source' = 'MEMZone Blog'
    }
    Get-WmiInstance -Namespace 'ROOT' -ClassName 'MEMZone' -Property $Property
.EXAMPLE
    Get-WmiInstance -Namespace 'ROOT' -ClassName 'MEMZone' -Property @{ 'Source' = 'MEMZone Blog' } -KeyOnly
.EXAMPLE
    Get-WmiInstance -Namespace 'ROOT' -ClassName 'MEMZone'
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
        [Parameter(Mandatory = $false, Position = 0)]
        [string]$Namespace = 'ROOT\cimv2',
        [ValidateNotNullorEmpty()]
        [Parameter(Mandatory = $true, Position = 1)]
        [ValidateNotNullorEmpty()]
        [string]$ClassName,
        [Parameter(Mandatory = $false, Position = 2)]
        [ValidateNotNullorEmpty()]
        [hashtable]$Property,
        [Parameter(Mandatory = $false, Position = 3)]
        [switch]$KeyOnly
    )

    Begin {
        ## Get the name of this function and write header
        [string]${CmdletName} = $PSCmdlet.MyInvocation.MyCommand.Name
        Write-FunctionHeaderOrFooter -CmdletName ${CmdletName} -CmdletBoundParameters $PSBoundParameters -Header
    }
    Process {
        Try {

            ## Check if the class exists
            $null = Get-WmiClass -Namespace $Namespace -ClassName $ClassName -ErrorAction 'Stop'

            ## Get all instance details or get only details where the key properties are filled in
            If ($KeyOnly) {
                $WmiInstance = Get-CimInstance -Namespace $Namespace -ClassName $ClassName -KeyOnly
            }
            Else {
                $WmiInstance = Get-CimInstance -Namespace $Namespace -ClassName $ClassName
            }

            ## Match instance details based on specified parameters
            If ($WmiInstance) {
                If ($Property) {

                    #  Get Property Names from function input to be used for filtering
                    [string[]]$InputPropertyNames =  $($Property.GetEnumerator().Name)

                    #  Convert Property hashtable to PSCustomObject for comparison
                    [PSCustomObject]$InputProperty = [PSCustomObject]$Property

                    #  -ErrorAction 'SilentlyContinue' does not seem to work correctly with the Compare-Object commandlet so it needs to be set globaly
                    $OriginalErrorActionPreference = $ErrorActionPreference
                    $ErrorActionPreference = 'SilentlyContinue'

                    #  Check if and instance with the same values exists. Since $InputProperty is a dinamically generated object Compare-Object has no hope of working correctly.
                    #  Luckily Compare-Object as a -Property parameter which allows us to look at specific parameters.
                    $GetInstance = $WmiInstance | ForEach-Object {
                        $MatchInstance = Compare-Object -ReferenceObject $PSItem -DifferenceObject $InputProperty -Property $InputPropertyNames -IncludeEqual -ExcludeDifferent
                        If ($MatchInstance) {
                            #  Add matched instance to output
                            $PSItem
                        }
                    }

                    #  Setting the ErrorActionPreference back to the previous value
                    $ErrorActionPreference = $OriginalErrorActionPreference
                }
                Else {
                    $GetInstance = $WmiInstance
                }
            }

            #  If no instances (or matching instances) are found, write debug message and optionally throw error if -ErrorAction 'Stop' is specified
            If (-not $GetInstance) {
                $InstanceNotFoundErr = "No matching instances found in class [$Namespace`:$ClassName]."
                Write-Log -Message $InstanceNotFoundErr -Severity 2 -Source ${CmdletName} -DebugMessage
                Write-Error -Message $InstanceNotFoundErr -Category 'ObjectNotFound'
            }
        }
        Catch {
            Write-Log -Message "Failed to retrieve wmi instances for class [$Namespace`:$ClassName]. `n$(Resolve-Error)" -Severity 3 -Source ${CmdletName}
            Break
        }
        Finally {
            Write-Output -InputObject $GetInstance
        }
    }
    End {
        Write-FunctionHeaderOrFooter -CmdletName ${CmdletName} -Footer
    }
}
#endregion