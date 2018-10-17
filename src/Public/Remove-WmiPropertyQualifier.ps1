#region Function Remove-WmiPropertyQualifier
Function Remove-WmiPropertyQualifier {
<#
.SYNOPSIS
    This function is used to remove WMI property qualifiers.
.DESCRIPTION
    This function is used to remove WMI class property qualifiers by name.
.PARAMETER Namespace
    Specifies the namespace. Default is: 'ROOT\cimv2'.
.PARAMETER ClassName
    Specifies the class name.
.PARAMETER PropertyName
    Specifies the property name for which to remove the qualifiers.
.PARAMETER QualifierName
    Specifies the property qualifier name or names.
.PARAMETER RemoveAll
    This switch is used to remove all qualifiers. Default is: $false. If this switch is specified the QualifierName parameter is ignored.
.PARAMETER Force
    This switch is used to remove all class instances. The class must be empty in order to be able to delete properties. Default is: $false.
.EXAMPLE
    Remove-WmiPropertyQualifier -Namespace 'ROOT' -ClassName 'SCCMZone' -PropertyName 'Source' -QualifierName 'Key','Description'
.EXAMPLE
    Remove-WmiPropertyQualifier -Namespace 'ROOT' -ClassName 'SCCMZone' -RemoveAll -Force
.NOTES
    This is a module function and can typically be called directly.
.LINK
    https://sccm-zone.com
.LINK
    https://github.com/Ioan-Popovici/SCCM
#>
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory=$false,Position=0)]
        [ValidateNotNullorEmpty()]
        [string]$Namespace = 'ROOT\cimv2',
        [Parameter(Mandatory=$true,Position=1)]
        [ValidateNotNullorEmpty()]
        [string]$ClassName,
        [Parameter(Mandatory=$true,Position=2)]
        [ValidateNotNullorEmpty()]
        [string]$PropertyName,
        [Parameter(Mandatory=$false,Position=3)]
        [ValidateNotNullorEmpty()]
        [string[]]$QualifierName,
        [Parameter(Mandatory=$false,Position=4)]
        [ValidateNotNullorEmpty()]
        [switch]$RemoveAll = $false,
        [Parameter(Mandatory=$false,Position=5)]
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

            ## Get property qualifier names
            [string[]]$WmiPropertyQualifierNames = (Get-WmiPropertyQualifier -Namespace $Namespace -ClassName $ClassName -PropertyName $PropertyName -ErrorAction 'Stop').Name

            ## Get class instances
            $InstanceTest = Get-WmiInstance -Namespace $Namespace -ClassName $ClassName -ErrorAction 'SilentlyContinue'

            ## Add property qualifiers to deletion string array depending on selected options
            If ($RemoveAll) {
                $RemovePropertyQualifier = $ClassPropertyQualifierNames
            }
            ElseIf ($QualifierName) {
                $RemovePropertyQualifier = $WmiPropertyQualifierNames | Where-Object { $_ -in $QualifierName }
            }
            Else {
                $QualifierNameIsNullErr = "QualifierName cannot be `$null if -RemoveAll is not specified."
                Write-Log -Message $QualifierNameIsNullErr -Severity 2 -Source ${CmdletName} -DebugMessage
                Write-Error -Message $QualifierNameIsNullErr -Category 'InvalidArgument'
            }

            ## Remove property qualifiers
            If ($RemovePropertyQualifier) {

                #  Remove all existing instances if the -Force switch was specified
                If ($Force -and $InstanceTest) {
                    Remove-WmiInstance -Namespace $Namespace -ClassName $ClassName -RemoveAll -ErrorAction 'Stop'
                }
                ElseIf ($InstanceTest) {
                    $ClassHasInstancesErr = "Instances [$($InstanceTest.Count)] detected in class [$Namespace`:$ClassName]. Use the -Force switch to remove instances."
                    Write-Log -Message $ClassHasInstancesErr -Severity 2 -Source ${CmdletName} -DebugMessage
                    Write-Error -Message $ClassHasInstancesErr -Category 'InvalidOperation'
                }

                #  Create the ManagementClass Object
                [wmiclass]$ClassObject = New-Object -TypeName 'System.Management.ManagementClass' -ArgumentList @("\\.\$Namespace`:$ClassName")

                #  Remove the specified property qualifiers
                $RemovePropertyQualifier | ForEach-Object { $ClassObject.Properties[$Property].Qualifiers.Remove($_) }

                #  Write the class and dispose of the object
                $null = $ClassObject.Put()
                $ClassObject.Dispose()
            }
            Else {
                $ProperyQualifierNotFoundErr = "No matching property qualifier [$Property`($QualifierName`)] found for class [$Namespace`:$ClassName]."
                Write-Log -Message $ProperyQualifierNotFoundErr -Severity 2 -Source ${CmdletName}
                Write-Error -Message $ProperyQualifierNotFoundErr -Category 'ObjectNotFound'
            }
        }
        Catch {
            Write-Log -Message "Failed to remove property qualifier for class [$Namespace`:$ClassName]. `n$(Resolve-Error)" -Severity 3 -Source ${CmdletName}
            Break
        }
        Finally {}
    }
    End {
        Write-FunctionHeaderOrFooter -CmdletName ${CmdletName} -Footer
    }
}
#endregion