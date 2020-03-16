#region Function Get-WmiClass
Function Get-WmiClass {
<#
.SYNOPSIS
    This function is used to get WMI class details.
.DESCRIPTION
    This function is used to get the details of one or more WMI classes.
.PARAMETER Namespace
    Specifies the namespace where to search for the WMI class. Default is: 'ROOT\cimv2'.
.PARAMETER ClassName
    Specifies the class name to search for. Supports wildcards. Default is: '*'.
.PARAMETER QualifierName
    Specifies the qualifier name to search for.(Optional)
.PARAMETER IncludeSpecialClasses
    Specifies to include System, MSFT and CIM classes. Use this or Get operations only.
.EXAMPLE
    Get-WmiClass -Namespace 'ROOT\SCCM' -ClassName 'SCCMZone'
.EXAMPLE
    Get-WmiClass -Namespace 'ROOT\SCCM' -QualifierName 'Description'
.EXAMPLE
    Get-WmiClass -Namespace 'ROOT\SCCM'
.INPUTS
    None.
.OUTPUTS
    None.
.NOTES
    This is a module function and can typically be called directly.
.LINK
    https://sccm-zone.com
.LINK
    https://github.com/Ioan-Popovici/SCCM
.COMPONENT
    WMI
.FUNCTIONALITY
    WMI Management
#>
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory=$false,Position=0)]
        [ValidateNotNullorEmpty()]
        [string]$Namespace = 'ROOT\cimv2',
        [Parameter(Mandatory=$false,Position=1)]
        [ValidateNotNullorEmpty()]
        [string]$ClassName = '*',
        [Parameter(Mandatory=$false,Position=2)]
        [ValidateNotNullorEmpty()]
        [string]$QualifierName,
        [Parameter(Mandatory=$false,Position=3)]
        [ValidateNotNullorEmpty()]
        [switch]$IncludeSpecialClasses
    )

    Begin {
        ## Get the name of this function and write header
        [string]${CmdletName} = $PSCmdlet.MyInvocation.MyCommand.Name
        Write-FunctionHeaderOrFooter -CmdletName ${CmdletName} -CmdletBoundParameters $PSBoundParameters -Header
    }
    Process {
        Try {

            ## Check if the namespace exists
            $NamespaceTest = Get-WmiNamespace -Namespace $Namespace -ErrorAction 'SilentlyContinue'
            If (-not $NamespaceTest) {
                $NamespaceNotFoundErr = "Namespace [$Namespace] not found."
                Write-Log -Message $NamespaceNotFoundErr -Severity 2 -Source ${CmdletName} -DebugMessage
                Write-Error -Message $NamespaceNotFoundErr -Category 'ObjectNotFound'
            }

            ## Get all class details
            If ($QualifierName) {
                $WmiClass = Get-CimClass -Namespace $Namespace -Class $ClassName -QualifierName $QualifierName -ErrorAction 'SilentlyContinue'
            }
            Else {
                $WmiClass = Get-CimClass -Namespace $Namespace -Class $ClassName -ErrorAction 'SilentlyContinue'
            }

            ## Filter class or classes details based on specified parameters
            If ($IncludeSpecialClasses) {
                $GetClass = $WmiClass
            }
            Else {
                $GetClass = $WmiClass | Where-Object { ($_.CimClassName -notmatch '__') -and ($_.CimClassName -notmatch 'CIM_') -and ($_.CimClassName -notmatch 'MSFT_') }
            }

            ## If no class is found, write debug message and optionally throw error if -ErrorAction 'Stop' is specified
            If (-not $GetClass) {
                $ClassNotFoundErr = "No class [$ClassName] found in namespace [$Namespace]."
                Write-Log -Message $ClassNotFoundErr -Severity 2 -Source ${CmdletName} -DebugMessage
                Write-Error -Message $ClassNotFoundErr -Category 'ObjectNotFound'
            }
        }
        Catch {
            Write-Log -Message "Failed to retrieve wmi class [$Namespace`:$ClassName]. `n$(Resolve-Error)" -Severity 3 -Source ${CmdletName}
            Break
        }
        Finally {

            ## If we have anyting to return, add typename for formatting purposes, otherwise set the result to $null
            If ($GetClass) {
                $GetClass.PSObject.TypeNames.Insert(0,'Get.WmiClass.Typename')
            }
            Else {
                $GetClass = $null
            }

            ## Return result
            Write-Output -InputObject $GetClass
        }
    }
    End {
        Write-FunctionHeaderOrFooter -CmdletName ${CmdletName} -Footer
    }
}
#endregion