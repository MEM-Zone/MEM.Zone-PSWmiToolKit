#region Function Remove-WmiProperty
Function Remove-WmiProperty {
<#
.SYNOPSIS
    This function is used to remove WMI class properties.
.DESCRIPTION
    This function is used to remove WMI class properties by name.
.PARAMETER Namespace
    Specifies the namespace where to search for the WMI class. Default is: 'ROOT\cimv2'.
.PARAMETER ClassName
    Specifies the class name for which to remove the properties.
.PARAMETER PropertyName
    Specifies the class property name or names to remove.
.PARAMETER RemoveAll
    This switch is used to remove all properties. Default is: $false. If this switch is specified the Property parameter is ignored.
.PARAMETER Force
    This switch is used to remove all instances. The class must be empty in order to be able to delete properties. Default is: $false.
.EXAMPLE
    Remove-WmiProperty -Namespace 'ROOT' -ClassName 'MEMZone' -Property 'MEMZone','Blog'
.EXAMPLE
    Remove-WmiProperty -Namespace 'ROOT' -ClassName 'MEMZone' -RemoveAll -Force
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
        [Parameter(Mandatory = $true, Position = 1)]
        [ValidateNotNullorEmpty()]
        [string]$ClassName,
        [Parameter(Mandatory = $false, Position = 2)]
        [ValidateNotNullorEmpty()]
        [string[]]$PropertyName,
        [Parameter(Mandatory = $false, Position = 3)]
        [ValidateNotNullorEmpty()]
        [switch]$RemoveAll = $false,
        [Parameter(Mandatory = $false, Position = 4)]
        [ValidateNotNullorEmpty()]
        [switch]$Force = $false
    )

    Begin {
        ## Get the name of this function and write header
        [string]${CmdletName} = $PSCmdlet.MyInvocation.MyCommand.Name
        Write-FunctionHeaderOrFooter -CmdletName ${CmdletName} -CmdletBoundParameters $PSBoundParameters -Header
    }
    Process {
        Try {

            ## Get class property names
            [string[]]$WmiPropertyNames = (Get-WmiProperty -Namespace $Namespace -ClassName $ClassName -ErrorAction 'Stop').Name

            ## Get class instances
            $InstanceTest = Get-WmiInstance -Namespace $Namespace -ClassName $ClassName -ErrorAction 'SilentlyContinue'

            ## Add property to deletion string array depending on selected options
            If ($RemoveAll) {
                $RemoveWmiProperty = $WmiPropertyNames
            }
            ElseIf ($PropertyName) {
                $RemoveWmiProperty = $WmiPropertyNames | Where-Object { $PSItem -in $PropertyName }
            }
            Else {
                $PropertyNameIsNullErr = "PropertyName cannot be `$null if -RemoveAll is not specified."
                Write-Log -Message $PropertyNameIsNullErr -Severity 2 -Source ${CmdletName} -DebugMessage
                Write-Error -Message $PropertyNameIsNullErr -Category 'InvalidArgument'
            }

            ## Remove class property
            If ($RemoveWmiProperty) {

                #  Remove all existing instances if the -Force switch was specified
                If ($Force -and $InstanceTest) {
                    Remove-WmiInstance -Namespace $Namespace -ClassName $ClassName -RemoveAll -ErrorAction 'Continue'
                }
                ElseIf ($InstanceTest) {
                    $ClassHasInstancesErr = "Instances [$($InstanceTest.Count)] detected in class [$Namespace`:$ClassName]. Use the -Force switch to remove instances."
                    Write-Log -Message $ClassHasInstancesErr -Severity 2 -Source ${CmdletName} -DebugMessage
                    Write-Error -Message $ClassHasInstancesErr -Category 'InvalidOperation'
                }

                #  Create the ManagementClass Object
                [wmiclass]$ClassObject = New-Object -TypeName 'System.Management.ManagementClass' -ArgumentList @("\\.\$Namespace`:$ClassName")

                #  Remove the specified class properties
                $RemoveWmiProperty | ForEach-Object { $ClassObject.Properties.Remove($PSItem) }

                #  Write the class and dispose of the object
                $null = $ClassObject.Put()
                $ClassObject.Dispose()
            }
            Else {
                $PropertyNotFoundErr = "No matching property [$PropertyName] found for class [$Namespace`:$ClassName]."
                Write-Log -Message $PropertyNotFoundErr -Severity 2 -Source ${CmdletName} -DebugMessage
                Write-Error -Message $PropertyNotFoundErr -Category 'ObjectNotFound'
            }
        }
        Catch {
            Write-Log -Message "Failed to remove property for class [$Namespace`:$ClassName]. `n$(Resolve-Error)" -Severity 3 -Source ${CmdletName}
            Break
        }
        Finally {}
    }
    End {
        Write-FunctionHeaderOrFooter -CmdletName ${CmdletName} -Footer
    }
}
#endregion