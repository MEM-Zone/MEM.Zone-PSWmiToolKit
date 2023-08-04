#region Function New-WmiInstance
Function New-WmiInstance {
<#
.SYNOPSIS
    This function is used to create a WMI Instance.
.DESCRIPTION
    This function is used to create a WMI Instance using CIM.
.PARAMETER Namespace
    Specifies the namespace where to search for the WMI class. Default is: 'ROOT\cimv2'.
.PARAMETER ClassName
    Specifies the class where to create the new WMI instance.
.PARAMETER Key
    Specifies properties that are used as keys (Optional).
.PARAMETER Property
    Specifies the class instance Properties or Values. You can also specify a string but you must separate the name and value with a new line character (`n).
    This parameter can also be piped.
.EXAMPLE
    [hashtable]$Property = @{
        'ServerPort' = '89'
        'ServerIP' = '11.11.11.11'
        'Source' = 'File1'
        'Date' = $(Get-Date)
    }
    New-WmiInstance -Namespace 'ROOT' -ClassName 'MEMZone' -Key 'File1' -Property $Property
.EXAMPLE
    "Server Port = 89 `n ServerIp = 11.11.11.11 `n Source = File `n Date = $(GetDate)" | New-WmiInstance -Namespace 'ROOT' -ClassName 'MEMZone' -Property $Property
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
        [string[]]$Key,
        [Parameter(Mandatory = $true,ValueFromPipeline, Position = 3)]
        [ValidateNotNullorEmpty()]
        [PSCustomObject]$Property
    )

    Begin {
        ## Get the name of this function and write header
        [string]${CmdletName} = $PSCmdlet.MyInvocation.MyCommand.Name
        Write-FunctionHeaderOrFooter -CmdletName ${CmdletName} -CmdletBoundParameters $PSBoundParameters -Header
    }
    Process {
        Try {

            ## Check if class exists
            $null = Get-WmiClass -Namespace $Namespace -ClassName $ClassName -ErrorAction 'Stop'

            ## If input qualifier is not a hashtable convert string input to hashtable
            If ($Property -isnot [hashtable]) {
                $Property = $Property | ConvertFrom-StringData
            }

            ## Create instance
            If ($Key) {
                $NewInstance = New-CimInstance -Namespace $Namespace -ClassName $ClassName -Key $Key -Property $Property
            }
            Else {
                $NewInstance = New-CimInstance -Namespace $Namespace -ClassName $ClassName -Property $Property
            }

            ## On instance creation failure, write debug message and optionally throw error if -ErrorAction 'Stop' is specified
            If (-not $NewInstance) {
                Write-Log -Message "Failed to create instance in class [$Namespace`:$ClassName]. `n$(Resolve-Error)" -Severity 3 -Source ${CmdletName} -DebugMessage
            }
        }
        Catch {
            Write-Log -Message "Failed to create instance in class [$Namespace`:$ClassName]. `n$(Resolve-Error)" -Severity 3 -Source ${CmdletName}
            Break
        }
        Finally {
            Write-Output -InputObject $NewInstance
        }
    }
    End {
        Write-FunctionHeaderOrFooter -CmdletName ${CmdletName} -Footer
    }
}
#endregion