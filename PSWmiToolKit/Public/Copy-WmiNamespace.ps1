#region Function Copy-WmiNamespace
Function Copy-WmiNamespace {
<#
.SYNOPSIS
    This function is used to copy a WMI namespace.
.DESCRIPTION
    This function is used to copy a WMI namespace to another namespace. .
.PARAMETER NamespaceSource
    Specifies the source namespace to copy.
.PARAMETER NamespaceDestination
    Specifies the destination namespace.
.PARAMETER Force
    This switch is used to overwrite the destination namespace.
.EXAMPLE
    Copy-WmiNamespace -NamespaceSource 'ROOT\MEMZone' -NamespaceDestination 'ROOT\cimv2' -Force
.EXAMPLE
    Copy-WmiNamespace -NamespaceSource 'ROOT\MEMZone' -NamespaceDestination 'ROOT\cimv2' -ErrorAction 'SilentlyContinue'
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
        [Parameter(Mandatory = $true, Position = 0)]
        [ValidateNotNullorEmpty()]
        [string]$NamespaceSource,
        [Parameter(Mandatory = $true, Position = 1)]
        [ValidateNotNullorEmpty()]
        [string]$NamespaceDestination,
        [Parameter(Mandatory = $false, Position = 3)]
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

            ## Check if the source namespace exists
            $null = Get-WmiNamespace -Namespace $NamespaceSource -ErrorAction 'Stop'

            ## Get source namespace tree
            $NamespaceSourceTree = Get-WmiNamespace -Namespace $NamespaceSource -Recurse -ErrorAction 'SilentlyContinue'

            ## Check if we need to copy root namespace classes
            $ClassNameSourceRoot = Get-WmiClass -Namespace $NamespaceSource -ErrorAction 'SilentlyContinue'

            #  Copy root namespace classes if present
            If ($ClassNameSourceRoot) {
                #  Copy classes one by one
                $ClassNameSourceRoot | ForEach-Object {
                    Copy-WmiClass -NamespaceSource $NamespaceSource -NamespaceDestination $NamespaceDestination -ClassName $PSItem.CimClassName -CreateDestination -Force -ErrorAction 'Stop'
                }
            }

            ## Parse namespace tree and copy namespaces and classes one by one
            $NamespaceSourceTree | ForEach-Object {

                #  Initialize the $ShouldCopy variable with $true
                [boolean]$ShouldCopy = $true

                #  Set current namespace source and destination paths. The destination is set by replacing the source namespace with the destination namespace.
                [string]$NamespaceSourcePath = $PSItem.FullName
                [string]$NamespaceDestinationPath = $NamespaceSourcePath -ireplace [regex]::Escape($NamespaceSource), $NamespaceDestination

                #  Check if the destination namespace exists
                $NamespaceDestinationTest = Get-WmiNamespace -Namespace $NamespaceDestinationPath -ErrorAction 'SilentlyContinue'

                #  If the namespace already exists in the destination and the -Force switch is specified remove the namespace, otherwise set the $ShouldCopy variable to $false
                If ($NamespaceDestinationTest -and $Force) {
                    $null = Remove-WmiNamespace -Namespace  $NamespaceDestinationPath -Force
                }
                ElseIf ($NamespaceDestinationTest) {
                    $ShouldCopy = $false
                }

                #  Copy the namespace if the $ShouldCopy variable is set to $true
                If ($ShouldCopy) {

                    #  Create the destination namespace
                    $CopyNamespace = New-WmiNamespace -Namespace $NamespaceDestinationPath -CreateSubTree -ErrorAction 'Stop'

                    #  Get current source namespace classes
                    $ClassNameSource = Get-WmiClass -Namespace $NamespaceSourcePath -ErrorAction 'SilentlyContinue'

                    #  Copy classes if present in the current source namespace
                    If ($ClassNameSource) {
                        #  Copy classes one by one
                        $ClassNameSource | ForEach-Object {
                            Copy-WmiClass -NamespaceSource $NamespaceSourcePath -NamespaceDestination $NamespaceDestinationPath -ClassName $PSItem.CimClassName -Force -ErrorAction 'Stop'
                        }
                    }
                }
                Else {

                    ## If a destination namespace is already present log error and stop execution if -ErrorAction 'Stop' is specified
                    $DestinationNamespaceExistsErr = "Destination namespace [$NamespaceDestinationPath] already exists. Use the -Force switch to overwrite."
                    Write-Log -Message $DestinationNamespaceExistsErr -Severity 2 -Source ${CmdletName}
                    Write-Error -Message $NamespaceAlreadyExistsErr -Category 'ResourceExists'
                }
            }
        }
        Catch {
            Write-Log -Message "Failed to copy namespace. `n$(Resolve-Error)" -Severity 3 -Source ${CmdletName}
            Break
        }
        Finally {
            Write-Output -InputObject $CopyNamespace
        }
    }
    End {
        Write-FunctionHeaderOrFooter -CmdletName ${CmdletName} -Footer
    }
}
#endregion