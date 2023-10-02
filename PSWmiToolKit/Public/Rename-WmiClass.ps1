#region Function Rename-WmiClass
Function Rename-WmiClass {
<#
.SYNOPSIS
    This function is used to rename a WMI class.
.DESCRIPTION
    This function is used to rename a WMI class by creating a new class, copying all existing properties and instances to it and removing the old one.
.PARAMETER Namespace
    Specifies the namespace for the class. Default is: ROOT\cimv2.
.PARAMETER Name
    Specifies the class name to be renamed.
.PARAMETER NewName
    Specifies the new class name.
.EXAMPLE
    Rename-WmiClass -Namespace 'ROOT\cimv2' -Name 'ConfigMgr' -NewName 'MEMZone'
.NOTES
    This is a module function and can typically be called directly.
.LINK
    https://MEM.Zone
.LINK
    https://MEMZ.one/PSWmiToolKit-RELEASES
.LINK
    https://MEMZ.one/PSWmiToolKit-GIT
.LINK
    https://MEMZ.one/PSWmiToolKit-ISSUES
#>
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory = $false, Position = 0)]
        [ValidateNotNullorEmpty()]
        [string]$Namespace = 'ROOT\cimv2',
        [Parameter(Mandatory = $true, Position = 1)]
        [ValidateNotNullorEmpty()]
        [string]$Name,
        [Parameter(Mandatory = $true, Position = 2)]
        [ValidateNotNullorEmpty()]
        [string]$NewName
    )

    Begin {
        ## Get the name of this function and write header
        [string]${CmdletName} = $PSCmdlet.MyInvocation.MyCommand.Name
        Write-FunctionHeaderOrFooter -CmdletName ${CmdletName} -CmdletBoundParameters $PSBoundParameters -Header
    }
    Process {
        Try {

            ## Set class paths
            $ClassPathSource = "$Namespace`:$Name"
            $ClassPathDestination =  "$Namespace`:$NewName"

            ## Check if the source class exists
            Get-WmiClass -Namespace $ClassPathSource -ErrorVariable 'Stop'

            ## Create the new class but throw an error if it already exists
            New-WmiClass -Namespace $Namespace -ClassName $NewName -ErrorAction 'Stop'

            ## Copy the old class
            #  Copy class qualifiers
            Copy-WmiClassQualifier -ClassPathSource $ClassPathSource -ClassPathDestination $ClassPathDestination -ErrorAction 'Stop'

            #  Copy class properties
            Copy-WmiProperty -ClassPathSource $ClassPathSource -ClassPathDestination $ClassPathDestination -ErrorAction 'Stop'

            #  Copy class instances
            Copy-WmiInstance -ClassPathSource $ClassPathSource -ClassPathDestination $ClassPathDestination -ErrorAction 'Stop'

            ## Remove the old class
            Remove-WmiClass -Namespace $Namespace -ClassName $Name -ErrorAction 'Stop'

            ## Write success message to console
            Write-Log -Message "Succesfully renamed class [$ClassPathSource -> $ClassPathDestination]" -Source ${CmdletName}
        }
        Catch {
            Write-Log -Message "Failed to rename class. `n$(Resolve-Error)" -Severity 3 -Source ${CmdletName}
            Break
        }
        Finally {}
    }
    End {
        Write-FunctionHeaderOrFooter -CmdletName ${CmdletName} -Footer
    }
}
#endregion