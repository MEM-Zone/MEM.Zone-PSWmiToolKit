#region Function Get-WmiProperty
Function Get-WmiProperty {
<#
.SYNOPSIS
    This function is used to get the properties of a WMI class.
.DESCRIPTION
    This function is used to get one or more properties of a WMI class.
.PARAMETER Namespace
    Specifies the namespace where to search for the WMI class. Default is: 'ROOT\cimv2'.
.PARAMETER ClassName
    Specifies the class name for which to get the properties.
.PARAMETER PropertyName
    Specifies the propery name to search for. Supports wildcards. Default is: '*'.
.PARAMETER PropertyValue
    Specifies the propery value or values to search for. Supports wildcards.(Optional)
.PARAMETER QualifierName
    Specifies the property qualifier name to match. Supports wildcards.(Optional)
.PARAMETER Property
    Matches property Name, Value and CimType. Can be piped. If this parameter is specified all other search parameters will be ignored.(Optional)
    Supported format:
        [PSCustomobject]@{
            'Name' = 'Website'
            'Value' = $null
            'CimType' = 'String'
        }
.EXAMPLE
    Get-WmiProperty -Namespace 'ROOT' -ClassName 'SCCMZone'
.EXAMPLE
    Get-WmiProperty -Namespace 'ROOT' -ClassName 'SCCMZone' -PropertyName 'WebsiteSite' -QualifierName 'key'
.EXAMPLE
    Get-WmiProperty -Namespace 'ROOT' -ClassName 'SCCMZone' -PropertyName '*Site'
.EXAMPLE
    $Property = [PSCustomobject]@{
        'Name' = 'Website'
        'Value' = $null
        'CimType' = 'String'
    }
    Get-WmiProperty -Namespace 'ROOT' -ClassName 'SCCMZone' -Property $Property
    $Property | Get-WmiProperty -Namespace 'ROOT' -ClassName 'SCCMZone'
.NOTES
    This is a module function and can typically be called directly.
.LINK
    https://sccm-zone.com
.LINK
    https://github.com/JhonnyTerminus/SCCM
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
        [string]$PropertyName = '*',
        [Parameter(Mandatory=$false,Position=3)]
        [ValidateNotNullorEmpty()]
        [string]$PropertyValue,
        [Parameter(Mandatory=$false,Position=4)]
        [ValidateNotNullorEmpty()]
        [string]$QualifierName,
        [Parameter(Mandatory=$false,ValueFromPipeline,Position=5)]
        [ValidateNotNullorEmpty()]
        [PSCustomObject]$Property = @()
    )

    Begin {
        ## Get the name of this function and write header
        [string]${CmdletName} = $PSCmdlet.MyInvocation.MyCommand.Name
        Write-FunctionHeaderOrFooter -CmdletName ${CmdletName} -CmdletBoundParameters $PSBoundParameters -Header
    }
    Process {
        Try {

            ## Check if class exists
            $ClassTest = Get-WmiClass -Namespace $Namespace -ClassName $ClassName -ErrorAction 'SilentlyContinue'

            ## If no class is found, write debug message and optionally throw error if -ErrorAction 'Stop' is specified
            If (-not $ClassTest) {
                $ClassNotFoundErr = "No class [$ClassName] found in namespace [$Namespace]."
                Write-Log -Message $ClassNotFoundErr -Severity 2 -Source ${CmdletName} -DebugMessage
                Write-Error -Message $ClassNotFoundErr -Category 'ObjectNotFound'
            }

            ## Get class properties
            $WmiProperty = (Get-WmiClass -Namespace $Namespace -ClassName $ClassName -ErrorAction 'SilentlyContinue' | Select-Object *).CimClassProperties | Where-Object -Property Name -like $PropertyName

            ## Get class property based on specified parameters
            If ($Property) {

                #  Compare all specified properties and return only properties that match Name, Value and CimType.
                $GetProperty = Compare-Object -ReferenceObject $Property -DifferenceObject $WmiProperty -Property Name, Value, CimType -IncludeEqual -ExcludeDifferent -PassThru

            }
            ElseIf ($PropertyValue -and $QualifierName) {
                $GetProperty = $WmiProperty | Where-Object { ($_.Value -like $PropertyValue) -and ($_.Qualifiers.Name -like $QualifierName) }
            }
            ElseIf ($PropertyValue) {
                $GetProperty = $WmiProperty | Where-Object -Property Value -like $PropertyValue
            }
            ElseIf ($QualifierName) {
                $GetProperty = $WmiProperty | Where-Object { $_.Qualifiers.Name -like $QualifierName }
            }
            Else {
                $GetProperty = $WmiProperty
            }

            ## If no matching properties are found, write debug message and optionally throw error if -ErrorAction 'Stop' is specified
            If (-not $GetProperty) {
                $PropertyNotFoundErr = "No property [$PropertyName] found for class [$Namespace`:$ClassName]."
                Write-Log -Message $PropertyNotFoundErr -Severity 2 -Source ${CmdletName} -DebugMessage
                Write-Error -Message $PropertyNotFoundErr -Category 'ObjectNotFound'
            }
        }
        Catch {
            Write-Log -Message "Failed to retrieve wmi class [$Namespace`:$ClassName] properties. `n$(Resolve-Error)" -Severity 3 -Source ${CmdletName}
            Break
        }
        Finally {
            Write-Output -InputObject $GetProperty
        }
    }
    End {
        Write-FunctionHeaderOrFooter -CmdletName ${CmdletName} -Footer
    }
}
#endregion