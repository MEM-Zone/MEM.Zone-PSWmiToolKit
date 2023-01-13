#region Function Remove-WmiClassQualifier
Function Remove-WmiClassQualifier {
<#
.SYNOPSIS
    This function is used to remove qualifiers from a WMI class.
.DESCRIPTION
    This function is used to remove qualifiers from a WMI class by name.
.PARAMETER Namespace
    Specifies the namespace where to search for the WMI namespace. Default is: 'ROOT\cimv2'.
.PARAMETER ClassName
    Specifies the class name for which to remove the qualifiers.
.PARAMETER QualifierName
    Specifies the qualifier name or names to be removed.
.PARAMETER RemoveAll
    This switch will remove all class qualifiers.
.EXAMPLE
    Remove-WmiClassQualifier -Namespace 'ROOT' -ClassName 'MEMZone' -QualifierName 'Description', 'Static'
.EXAMPLE
    Remove-WmiClassQualifier -Namespace 'ROOT' -ClassName 'MEMZone' -RemoveAll
.NOTES
    This is a module function and can typically be called directly.
.LINK
    https://MEM.Zone/
.LINK
    https://MEM.Zone/PSWmiToolKit-RELEASES
.LINK
    https://MEM.Zone/PSWmiToolKit/GIT
.LINK
    https://MEM.Zone/PSWmiToolKit/ISSUES
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
    [string[]]$QualifierName,
    [Parameter(Mandatory = $false, Position = 3)]
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

            ## Get class qualifiers
            $WmiClassQualifier = (Get-WmiClassQualifier -Namespace $Namespace -ClassName $ClassName -ErrorAction 'Stop').Name

            ## Add qualifier name to deletion array depending on selected options
            If ($RemoveAll) {
                $RemoveClassQualifier = $WmiClassQualifier
            }
            ElseIf ($QualifierName) {
                $RemoveClassQualifier = $WmiClassQualifier | Where-Object { $PSItem -in $QualifierName }
            }
            Else {
                $QualifierNameIsNullErr = "QualifierName cannot be `$null if -RemoveAll is not specified."
                Write-Log -Message $QualifierNameIsNullErr -Severity 2 -Source ${CmdletName} -DebugMessage
                Write-Error -Message $QualifierNameIsNullErr -Category 'InvalidArgument'
            }

            ## Remove qualifiers by name
            If ($RemoveClassQualifier) {

                #  Create the ManagementClass object
                [wmiclass]$ClassObject = New-Object -TypeName 'System.Management.ManagementClass' -ArgumentList @("\\.\$Namespace`:$ClassName")

                #  Remove class qualifiers one by one
                $QualifierName | ForEach-Object { $ClassObject.Qualifiers.Remove($PSItem) }

            }
            Else {

                #  Error handling
                $PropertyNotFoundErr = "No matching qualifier [$QualifierName] found for class [$Namespace`:$ClassName]."
                Write-Log -Message $PropertyNotFoundErr -Severity 2 -Source ${CmdletName} -DebugMessage
                Write-Error -Message $PropertyNotFoundErr -Category 'ObjectNotFound'
            }

            ## Write class object
            $null = $ClassObject.Put()
            $ClassObject.Dispose()
        }
        Catch {
            Write-Log -Message "Failed to remove qualifier for class [$Namespace`:$ClassName]. `n$(Resolve-Error)" -Severity 3 -Source ${CmdletName}
            Break
        }
        Finally {}
    }
    End {
        Write-FunctionHeaderOrFooter -CmdletName ${CmdletName} -Footer
    }
}
#endregion