#region Function Get-WmiPropertyQualifier
Function Get-WmiPropertyQualifier {
<#
.SYNOPSIS
    This function is used to get the property qualifiers of a WMI class.
.DESCRIPTION
    This function is used to get one or more property qualifiers of a WMI class.
.PARAMETER Namespace
    Specifies the namespace where to search for the WMI class. Default is: 'ROOT\cimv2'.
.PARAMETER ClassName
    Specifies the class name for which to get the property qualifiers.
.PARAMETER PropertyName
    Specifies the property name for which to get the property qualifiers. Supports wilcards. Can be piped. Default is: '*'.
.PARAMETER QualifierName
    Specifies the property qualifier name or names to search for.(Optional)
.PARAMETER QualifierValue
    Specifies the property qualifier value or values to search for.(Optional)
.EXAMPLE
    Get-WmiPropertyQualifier -Namespace 'ROOT' -ClassName 'MEMZone' -PropertyName 'MEMZone Blog'
.EXAMPLE
    'MEMZone Blog', 'ServerAddress' | Get-WmiPropertyQualifier -Namespace 'ROOT' -ClassName 'MEMZone'
.EXAMPLE
    Get-WmiPropertyQualifier -Namespace 'ROOT' -ClassName 'MEMZone' -QualifierName 'key','Description'
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
        [Parameter(Mandatory = $false,ValueFromPipeline, Position = 2)]
        [ValidateNotNullorEmpty()]
        [string]$PropertyName = '*',
        [Parameter(Mandatory = $false, Position = 3)]
        [ValidateNotNullorEmpty()]
        [string[]]$QualifierName,
        [Parameter(Mandatory = $false, Position = 4)]
        [ValidateNotNullorEmpty()]
        [string[]]$QualifierValue
    )

    Begin {
        ## Get the name of this function and write header
        [string]${CmdletName} = $PSCmdlet.MyInvocation.MyCommand.Name
        Write-FunctionHeaderOrFooter -CmdletName ${CmdletName} -CmdletBoundParameters $PSBoundParameters -Header
    }
    Process {
        Try {

            ## Get all details for the specified property name
            $WmiPropertyQualifier = (Get-WmiClass -Namespace $Namespace -ClassName $ClassName -ErrorAction 'Stop').CimClassProperties | Where-Object -Property Name -like $PropertyName | Select-Object -ExpandProperty 'Qualifiers'

            ## Get property qualifiers based on specified parameters
            If ($QualifierName -and $QualifierValue) {
                $GetPropertyQualifier = $WmiPropertyQualifier | Where-Object { ($PSItem.Name -in $QualifierName) -and ($PSItem.Value -in $QualifierValue) }
            }
            ElseIf ($QualifierName) {
                $GetPropertyQualifier = $WmiPropertyQualifier | Where-Object { ($PSItem.Name -in $QualifierName) }
            }
            ElseIf ($QualifierValue) {
                $GetPropertyQualifier = $WmiPropertyQualifier | Where-Object { $PSItem.Value -in $QualifierValue }
            }
            Else {
                $GetPropertyQualifier = $WmiPropertyQualifier
            }

            ## On property qualifiers retrieval failure, write debug message and optionally throw error if -ErrorAction 'Stop' is specified
            If (-not $GetPropertyQualifier) {
                $PropertyQualifierNotFoundErr = "No property [$PropertyName] qualifier [$QualifierName `= $QualifierValue] found for class [$Namespace`:$ClassName]."
                Write-Log -Message $PropertyQualifierNotFoundErr -Severity 2 -Source ${CmdletName} -DebugMessage
                Write-Error -Message $PropertyQualifierNotFoundErr -Category 'ObjectNotFound'
            }
        }
        Catch {
            Write-Log -Message "Failed to retrieve wmi class [$Namespace`:$ClassName] property qualifiers. `n$(Resolve-Error)" -Severity 3 -Source ${CmdletName}
            Break
        }
        Finally {
            Write-Output -InputObject $GetPropertyQualifier
        }
    }
    End {
        Write-FunctionHeaderOrFooter -CmdletName ${CmdletName} -Footer
    }
}
#endregion