#region Function Remove-WmiInstance
Function Remove-WmiInstance {
<#
.SYNOPSIS
    This function is used to remove one ore more WMI instances.
.DESCRIPTION
    This function is used to remove one ore more WMI class instances with the specified values using CIM.
.PARAMETER Namespace
    Specifies the namespace where to search for the WMI namespace. Default is: 'ROOT\cimv2'.
.PARAMETER ClassName
    Specifies the class name from which to remove the instances.
.PARAMETER Property
    The class instance property to match. Can be piped. If there is more than one matching instance and the RemoveAll switch is not specified, an error will be thrown.
.PARAMETER RemoveAll
    Removes all matching or existing instances.
.EXAMPLE
    [hashtable]$Property = @{
        'ServerPort' = '80'
        'ServerIP' = '10.10.10.11'
    }
    Remove-WmiInstance -Namespace 'ROOT' -ClassName 'MEMZone' -Property $Property -RemoveAll
.NOTES
    This is a module function and can typically be called directly.
.LINK
    https://MEM.Zone
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
        [ValidateNotNullorEmpty()]
        [string]$Namespace = 'ROOT\cimv2',
        [Parameter(Mandatory = $true, Position = 1)]
        [ValidateNotNullorEmpty()]
        [string]$ClassName,
        [Parameter(Mandatory = $false,ValueFromPipeline, Position = 2)]
        [ValidateNotNullorEmpty()]
        [hashtable]$Property,
        [Parameter(Mandatory = $false, Position = 3)]
        [switch]$RemoveAll
    )

    Begin {
        ## Get the name of this function and write header
        [string]${CmdletName} = $PSCmdlet.MyInvocation.MyCommand.Name
        Write-FunctionHeaderOrFooter -CmdletName ${CmdletName} -CmdletBoundParameters $PSBoundParameters -Header
    }
    Process {
        Try {

            ## Get all class instances. If the class has no instances an error will be thrown
            $WmiInstances = Get-WmiInstance -Namespace $Namespace -ClassName $ClassName -ErrorAction 'Stop'

            ## If Property was specified check for matching instances, otherwise if -RemoveAll switch is specified tag all instances for deletion
            If ($Property) {
                $RemoveInstances = Get-WmiInstance -Namespace $Namespace -ClassName $ClassName -Property $Property -ErrorAction 'SilentlyContinue'
            }
            Else {
                $RemoveInstances = $WmiInstances
            }

            ## Remove according to specified options. If multiple instances are found check for the -RemoveAll switch
            If (($RemoveInstances.Count -eq 1) -or (($RemoveInstances.Count -gt 1) -and $RemoveAll)) {
                #  Remove instances one by one
                $RemoveInstances | ForEach-Object { Remove-CimInstance -InputObject $PSItem -ErrorAction 'Stop' }
            }

            ## Otherwise if more than one instance is detected, write debug message and optionally throw error if -ErrorAction 'Stop' is specified
            ElseIf ($RemoveInstances.Count -gt 1) {
                $MultipleInstancesFoundErr  = "Failed to remove instance. Multiple instances [$($RemoveInstances.Count)] found in class [$Namespace`:$ClassName]."
                Write-Log -Message $MultipleInstancesFoundErr -Severity 2 -Source ${CmdletName} -DebugMessage
                Write-Error -Message $MultipleInstancesFoundErr -Category 'InvalidOperation'
            }

            ## On instance removal failure, write debug message and optionally throw error if -ErrorAction 'Stop' is specified
            ElseIf (-not $RemoveInstances) {
                $InstanceNotFoundErr = "Failed to remove instances. No instances (or matching) found in class [$Namespace`:$ClassName]."
                Write-Log -Message $InstanceNotFoundErr -Severity 2 -Source ${CmdletName} -DebugMessage
                Write-Error -Message $MultipleInstancesFoundErr -Category 'ObjectNotFound'
            }
        }
        Catch {
            Write-Log -Message "Failed to remove instances in [$Namespace`:$ClassName]. `n$(Resolve-Error)" -Severity 3 -Source ${CmdletName}
            Break
        }
        Finally {
            Write-Output -InputObject $RemoveInstances
        }
    }
    End {
        Write-FunctionHeaderOrFooter -CmdletName ${CmdletName} -Footer
    }
}
#endregion