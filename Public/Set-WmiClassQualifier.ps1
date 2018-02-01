#region Function Set-WmiClassQualifier
Function Set-WmiClassQualifier {
<#
.SYNOPSIS
    This function is used to set qualifiers to a WMI class.
.DESCRIPTION
    This function is used to set qualifiers to a WMI class. Existing qualifiers with the same name will be overwriten
.PARAMETER Namespace
    Specifies the namespace where to search for the WMI namespace. Default is: 'ROOT\cimv2'.
.PARAMETER ClassName
    Specifies the class name for which to add the qualifiers.
.PARAMETER Qualifier
    Specifies the qualifier name, value and flavours as hashtable. You can omit this parameter or enter one or more items in the hashtable.
    You can also specify a string but you must separate the name and value with a new line character (`n). This parameter can also be piped.
    If you omit a hashtable item the default item value will be used. Only item values can be specified (right of the '=' sign).
    Default is:
        [hashtable][ordered]@{
            Name = 'Static'
            Value = $true
            IsAmended = $false
            PropagatesToInstance = $true
            PropagatesToSubClass = $false
            IsOverridable = $true
        }
.EXAMPLE
    Set-WmiClassQualifier -Namespace 'ROOT' -ClassName 'SCCMZone' -Qualifier @{ Name = 'Description'; Value = 'SCCMZone Blog' }
.EXAMPLE
    Set-WmiClassQualifier -Namespace 'ROOT' -ClassName 'SCCMZone' -Qualifier "Name = Description `n Value = SCCMZone Blog"
.EXAMPLE
    "Name = Description `n Value = SCCMZone Blog" | Set-WmiClassQualifier -Namespace 'ROOT' -ClassName 'SCCMZone'
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
    [Parameter(Mandatory=$false,ValueFromPipeline,Position=2)]
    [ValidateNotNullorEmpty()]
    [PSCustomObject]$Qualifier = @()
    )

    Begin {
        ## Get the name of this function and write header
        [string]${CmdletName} = $PSCmdlet.MyInvocation.MyCommand.Name
        Write-FunctionHeaderOrFooter -CmdletName ${CmdletName} -CmdletBoundParameters $PSBoundParameters -Header
    }
    Process {
        Try {

            ## Check if the class exist
            $null = Get-WmiClass -Namespace $Namespace -ClassName $ClassName -ErrorAction 'Stop'

            ## If input qualifier is not a hashtable convert string input to hashtable
            If ($Qualifier -isnot [hashtable]) {
                $Qualifier = $Qualifier | ConvertFrom-StringData
            }

            ## Add the missing qualifier value, name and flavor to the hashtable using splatting
            If (-not $Qualifier.Item('Name')) { $Qualifier.Add('Name', 'Static') }
            If (-not $Qualifier.Item('Value')) { $Qualifier.Add('Value', $true) }
            If (-not $Qualifier.Item('IsAmended')) { $Qualifier.Add('IsAmended', $false) }
            If (-not $Qualifier.Item('PropagatesToInstance')) { $Qualifier.Add('PropagatesToInstance', $true) }
            If (-not $Qualifier.Item('PropagatesToSubClass')) { $Qualifier.Add('PropagatesToSubClass', $false) }
            If (-not $Qualifier.Item('IsOverridable')) { $Qualifier.Add('IsOverridable', $true) }

            ## Create the ManagementClass object
            [wmiclass]$ClassObject = New-Object -TypeName 'System.Management.ManagementClass' -ArgumentList @("\\.\$Namespace`:$ClassName")

            ## Set key qualifier if specified, otherwise set qualifier
            $ClassObject.Qualifiers.Add($Qualifier.Item('Name'), $Qualifier.Item('Value'), $Qualifier.Item('IsAmended'), $Qualifier.Item('PropagatesToInstance'), $Qualifier.Item('PropagatesToSubClass'), $Qualifier.Item('IsOverridable'))
            $SetClassQualifiers = $ClassObject.Put()
            $ClassObject.Dispose()

            ## On class qualifiers creation failure, write debug message and optionally throw error if -ErrorAction 'Stop' is specified
            If (-not $SetClassQualifiers) {

                #  Error handling and logging
                $SetClassQualifiersErr = "Failed to set qualifier [$Qualifier.Item('Name')] for class [$Namespace`:$ClassName]."
                Write-Log -Message $SetClassQualifiersErr -Severity 3 -Source ${CmdletName} -DebugMessage
                Write-Error -Message $SetClassQualifiersErr -Category 'InvalidResult'
            }
        }
        Catch {
            Write-Log -Message "Failed to set qualifier for class [$Namespace`:$ClassName]. `n$(Resolve-Error)" -Severity 3 -Source ${CmdletName}
            Break
        }
        Finally {
            Write-Output -InputObject $SetClassQualifiers
        }
    }
    End {
        Write-FunctionHeaderOrFooter -CmdletName ${CmdletName} -Footer
    }
}
#endregion