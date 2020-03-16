#region Function Get-WmiClassQualifier
Function Get-WmiClassQualifier {
<#
.SYNOPSIS
    This function is used to get the qualifiers of a WMI class.
.DESCRIPTION
    This function is used to get one or more qualifiers of a WMI class.
.PARAMETER Namespace
    Specifies the namespace where to search for the WMI class. Default is: 'ROOT\cimv2'.
.PARAMETER ClassName
    Specifies the class name for which to get the qualifiers.
.PARAMETER QualifierName
    Specifies the qualifier search for. Suports wildcards. Default is: '*'.
.PARAMETER QualifierValue
    Specifies the qualifier search for. Supports wildcards.(Optional)
.EXAMPLE
    Get-WmiClassQualifier -Namespace 'ROOT\SCCM' -ClassName 'SCCMZone' -QualifierName 'Description' -QualifierValue 'SCCMZone Blog'
.EXAMPLE
    Get-WmiClassQualifier -Namespace 'ROOT\SCCM' -ClassName 'SCCMZone' -QualifierName 'Description' -QualifierValue 'SCCMZone*'
.EXAMPLE
    Get-WmiClassQualifier -Namespace 'ROOT\SCCM' -ClassName 'SCCMZone'
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
        [Parameter(Mandatory=$false,Position=2)]
        [ValidateNotNullorEmpty()]
        [string]$QualifierName = '*',
        [Parameter(Mandatory=$false,Position=3)]
        [ValidateNotNullorEmpty()]
        [string]$QualifierValue
    )

    Begin {
        ## Get the name of this function and write header
        [string]${CmdletName} = $PSCmdlet.MyInvocation.MyCommand.Name
        Write-FunctionHeaderOrFooter -CmdletName ${CmdletName} -CmdletBoundParameters $PSBoundParameters -Header
    }
    Process {
        Try {

            ## Get the all class qualifiers
            $WmiClassQualifier = (Get-WmiClass -Namespace $Namespace -ClassName $ClassName -ErrorAction 'Stop' | Select-Object *).CimClassQualifiers | Where-Object -Property Name -like $QualifierName

            ## Filter class qualifiers according to specifed parameters
            If ($QualifierValue) {
                $GetClassQualifier = $WmiClassQualifier | Where-Object -Property Value -like $QualifierValue
            }
            Else {
                $GetClassQualifier = $WmiClassQualifier
            }

            ## If no class qualifiers are found, write debug message and optionally throw error if -ErrorAction 'Stop' is specified
            If (-not $GetClassQualifier) {
                $ClassQualifierNotFoundErr = "No qualifier [$QualifierName] found for class [$Namespace`:$ClassName]."
                Write-Log -Message $ClassQualifierNotFoundErr -Severity 2 -Source ${CmdletName} -DebugMessage
                Write-Error -Message $ClassQualifierNotFoundErr -Category 'ObjectNotFound'
            }
        }
        Catch {
            Write-Log -Message "Failed to retrieve wmi class [$Namespace`:$ClassName] qualifier [$QualifierName]. `n$(Resolve-Error)" -Severity 3 -Source ${CmdletName}
            Break
        }
        Finally {
            Write-Output -InputObject $GetClassQualifier
        }
    }
    End {
        Write-FunctionHeaderOrFooter -CmdletName ${CmdletName} -Footer
    }
}
#endregion