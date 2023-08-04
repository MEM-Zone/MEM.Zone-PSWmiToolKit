#region Function Remove-WmiClass
Function Remove-WmiClass {
<#
.SYNOPSIS
    This function is used to remove a WMI class.
.DESCRIPTION
    This function is used to remove a WMI class by name.
.PARAMETER Namespace
    Specifies the namespace where to search for the WMI class. Default is: 'ROOT\cimv2'.
.PARAMETER ClassName
    Specifies the class name to remove. Can be piped.
.PARAMETER RemoveAll
    This switch is used to remove all namespace classes.
.EXAMPLE
    Remove-WmiClass -Namespace 'ROOT' -ClassName 'MEMZone','MEMZoneBlog'
.EXAMPLE
    'MEMZone','MEMZoneBlog' | Remove-WmiClass -Namespace 'ROOT'
.EXAMPLE
    Remove-WmiClass -Namespace 'ROOT' -RemoveAll
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
        [ValidateNotNullorEmpty()]
        [string]$Namespace = 'ROOT\cimv2',
        [Parameter(Mandatory = $false,ValueFromPipeline, Position = 1)]
        [ValidateNotNullorEmpty()]
        [string[]]$ClassName,
        [Parameter(Mandatory = $false, Position = 2)]
        [ValidateNotNullorEmpty()]
        [switch]$RemoveAll = $false
    )

    Begin {
        ## Get the name of this function and write header
        [string]${CmdletName} = $PSCmdlet.MyInvocation.MyCommand.Name
        Write-FunctionHeaderOrFooter -CmdletName ${CmdletName} -CmdletBoundParameters $PSBoundParameters -Header
    }
    Process {
        Try {

            ## Get classes names
            [string[]]$WmiClassNames = (Get-WmiClass -Namespace $Namespace -ErrorAction 'Stop').CimClassName

            ## Add classes to deletion string array depending on selected options
            If ($RemoveAll) {
                $ClassNamesToDelete = $WmiClassNames
            }
            ElseIf ($ClassName) {
                $ClassNamesToDelete = $WmiClassNames | Where-Object { $PSItem -in $ClassName }
            }
            Else {
                $ClassNameIsNullErr = "ClassName cannot be `$null if -RemoveAll is not specified."
                Write-Log -Message $ClassNameIsNullErr -Severity 3 -Source ${CmdletName}
                Write-Error -Message $ClassNameIsNullErr -Category 'InvalidArgument'
            }

            ## Remove classes
            If ($ClassNamesToDelete) {
                $ClassNamesToDelete | Foreach-Object {

                    #  Create the class object
                    [wmiclass]$ClassObject = New-Object -TypeName 'System.Management.ManagementClass' -ArgumentList @("\\.\$Namespace`:$PSItem")

                    #  Remove class
                    $null = $ClassObject.Delete()
                    $ClassObject.Dispose()
                }
            }
            Else {
                $ClassNotFoundErr = "No matching class [$ClassName] found for namespace [$Namespace]."
                Write-Log -Message $ClassNotFoundErr -Severity 2 -Source ${CmdletName}
                Write-Error -Message $ClassNotFoundErr -Category 'ObjectNotFound'
            }
        }
        Catch {
            Write-Log -Message "Failed to remove class [$Namespace`:$ClassName]. `n$(Resolve-Error)" -Severity 3 -Source ${CmdletName}
            Break
        }
        Finally {}
    }
    End {
        Write-FunctionHeaderOrFooter -CmdletName ${CmdletName} -Footer
    }
}
#endregion