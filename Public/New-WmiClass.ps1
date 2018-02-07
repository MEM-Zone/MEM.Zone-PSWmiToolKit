#region Function New-WmiClass
Function New-WmiClass {
<#
.SYNOPSIS
    This function is used to create a WMI class.
.DESCRIPTION
    This function is used to create a WMI class with custom properties.
.PARAMETER Namespace
    Specifies the namespace where to search for the WMI namespace. Default is: 'ROOT\cimv2'.
.PARAMETER ClassName
    Specifies the name for the new class.
.PARAMETER Qualifiers
    Specifies one ore more property qualifiers using qualifier name and value only. You can omit this parameter or enter one or more items in the hashtable.
    You can also specify a string but you must separate the name and value with a new line character (`n). This parameter can also be piped.
    The qualifiers will be added with these default values and flavors:
        Static = $true
        IsAmended = $false
        PropagatesToInstance = $true
        PropagatesToSubClass = $false
        IsOverridable = $true
.PARAMETER CreateDestination
    This switch is used to create destination namespace.
.EXAMPLE
    [hashtable]$Qualifiers = @{
        Key = $true
        Static = $true
        Description = 'SCCMZone Blog'
    }
    New-WmiClass -Namespace 'ROOT' -ClassName 'SCCMZone' -Qualifiers $Qualifiers
.EXAMPLE
    "Key = $true `n Static = $true `n Description = SCCMZone Blog" | New-WmiClass -Namespace 'ROOT' -ClassName 'SCCMZone'
.EXAMPLE
    New-WmiClass -Namespace 'ROOT\SCCM' -ClassName 'SCCMZone' -CreateDestination
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
        [PSCustomObject]$Qualifiers = @("Static = $true"),
        [Parameter(Mandatory=$false,Position=3)]
        [ValidateNotNullorEmpty()]
        [switch]$CreateDestination = $false
    )

    Begin {
        ## Get the name of this function and write header
        [string]${CmdletName} = $PSCmdlet.MyInvocation.MyCommand.Name
        Write-FunctionHeaderOrFooter -CmdletName ${CmdletName} -CmdletBoundParameters $PSBoundParameters -Header
    }
    Process {
        Try {

            ## Check if the class exists
            [boolean]$ClassTest = Get-WmiClass -Namespace $Namespace -ClassName $ClassName -ErrorAction 'SilentlyContinue'

            ## Check if the namespace exists
            [boolean]$NamespaceTest = Get-WmiNamespace -Namespace $Namespace -ErrorAction 'SilentlyContinue'

            ## Create destination namespace if specified, otherwise throw error if -ErrorAction 'Stop' is specified
            If ((-not $NamespaceTest) -and $CreateDestination) {
                $null = New-WmiNamespace $Namespace -CreateSubTree -ErrorAction 'Stop'
            }
            ElseIf (-not $NamespaceTest) {
                $NamespaceNotFoundErr = "Namespace [$Namespace] does not exist. Use the -CreateDestination switch to create namespace."
                Write-Log -Message $NamespaceNotFoundErr -Severity 3 -Source ${CmdletName}
                Write-Error -Message $NamespaceNotFoundErr -Category 'ObjectNotFound'
            }

            ## Create class if it does not exist
            If (-not $ClassTest) {

                #  Create class object
                [wmiclass]$ClassObject = New-Object -TypeName 'System.Management.ManagementClass' -ArgumentList @("\\.\$Namespace`:__CLASS", [String]::Empty, $null)
                $ClassObject.Name = $ClassName

                #  Write the class and dispose of the class object
                $NewClass = $ClassObject.Put()
                $ClassObject.Dispose()

                #  On class creation failure, write debug message and optionally throw error if -ErrorAction 'Stop' is specified
                If (-not $NewClass) {

                    #  Error handling and logging
                    $NewClassErr = "Failed to create class [$ClassName] in namespace [$Namespace]."
                    Write-Log -Message $NewClassErr -Severity 3 -Source ${CmdletName} -DebugMessage
                    Write-Error -Message $NewClassErr -Category 'InvalidResult'
                }

                ## If input qualifier is not a hashtable convert string input to hashtable
                If ($Qualifiers -isnot [hashtable]) {
                    $Qualifiers = $Qualifiers | ConvertFrom-StringData
                }

                ## Set property qualifiers one by one if specified, otherwise set default qualifier name, value and flavors
                If ($Qualifiers) {
                    #  Convert to a hashtable format accepted by Set-WmiClassQualifier. Name = QualifierName and Value = QualifierValue are expected.
                    $Qualifiers.Keys | ForEach-Object {
                        [hashtable]$PropertyQualifier = @{ Name = $_; Value = $Qualifiers.Item($_) }
                        #  Set qualifier
                        $null = Set-WmiClassQualifier -Namespace $Namespace -ClassName $ClassName -Qualifier $PropertyQualifier -ErrorAction 'Stop'
                    }
                }
                Else {
                    $null = Set-WmiClassQualifier -Namespace $Namespace -ClassName $ClassName -ErrorAction 'Stop'
                }
            }
            Else {
                $ClassAlreadyExistsErr = "Failed to create class [$Namespace`:$ClassName]. Class already exists."
                Write-Log -Message $ClassAlreadyExistsErr -Severity 2 -Source ${CmdletName} -DebugMessage
                Write-Error -Message $ClassAlreadyExistsErr -Category 'ResourceExists'
            }
        }
        Catch {
            Write-Log -Message "Failed to create class [$ClassName] in namespace [$Namespace]. `n$(Resolve-Error)" -Severity 3 -Source ${CmdletName}
            Break
        }
        Finally {
            Write-Output -InputObject $NewClass
        }
    }
    End {
        Write-FunctionHeaderOrFooter -CmdletName ${CmdletName} -Footer
    }
}
#endregion