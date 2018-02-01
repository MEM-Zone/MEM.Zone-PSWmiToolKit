#region Function Copy-WmiClass
Function Copy-WmiClass {
<#
.SYNOPSIS
    This function is used to copy a WMI class.
.DESCRIPTION
    This function is used to copy a WMI class to another namespace.
.PARAMETER NamespaceSource
    Specifies the source namespace.
.PARAMETER NamespaceDestination
    Specifies the destinaiton namespace.
.PARAMETER ClassName
    Specifies the class name or names to copy. If this parameter is not specified all classes will be copied.(Optional)
.PARAMETER Force
    This switch is used to overwrite the destination class if it already exists. Default is: $false.
.PARAMETER CreateDestination
    This switch is used to create the destination namespace if it does not exist. Default is: $false.
.EXAMPLE
    Copy-WmiClass -ClassName 'SCCMZone' -NamespaceSource 'ROOT\SCCM' -NamespaceDestination 'ROOT\Blog' -CreateDestination
.EXAMPLE
    Copy-WmiClass -NamespaceSource 'ROOT\SCCM' -NamespaceDestination 'ROOT\Blog' -CreateDestination
.NOTES
    This is a module function and can typically be called directly.
.LINK
    https://sccm-zone.com
.LINK
    https://github.com/JhonnyTerminus/SCCM
#>
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory=$true,Position=0)]
        [ValidateNotNullorEmpty()]
        [string]$NamespaceSource,
        [Parameter(Mandatory=$true,Position=1)]
        [ValidateNotNullorEmpty()]
        [string]$NamespaceDestination,
        [Parameter(Mandatory=$false,Position=2)]
        [ValidateNotNullorEmpty()]
        [string[]]$ClassName,
        [Parameter(Mandatory=$false,Position=3)]
        [ValidateNotNullorEmpty()]
        [switch]$Force = $false,
        [Parameter(Mandatory=$false,Position=4)]
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

            ##  Get all classes in the source namespace
            $WmiClass = (Get-WmiClass -Namespace $NamespaceSource -ErrorAction 'Stop').CimClassName

            ## Check if the destination namespace exists
            $NamespaceDestinationTest = Get-WmiNameSpace -Namespace $NamespaceDestination -ErrorAction 'SilentlyContinue'

            ## Create destination namespace if specified
            If ((-not $NamespaceDestinationTest) -and $CreateDestination) {

                #  Create destination namespace
                New-WmiNameSpace -Namespace $NamespaceDestination -CreateSubTree -ErrorAction 'Stop'
            }
            ElseIf (-not $NamespaceDestinationTest) {
                $DestinationNamespaceNotFoundErr = "Destination namespace [$NamespaceDestination] not found. Use -CreateDestination switch to create the destination automatically."
                Write-Log -Message $DestinationNamespaceNotFoundErr -Severity 2 -Source ${CmdletName}
                Write-Error -Message $DestinationNamespaceNotFoundErr -Category 'ObjectNotFound'
            }

            ## Select classes to copy depending on specified parameters
            If (-not $ClassName) {
                $CopyClass = $WmiClass
            }
            Else {
                $CopyClass = $WmiClass | Where-Object { $_  -in $ClassName }
            }

            ## Copy matching classes otherwise throw error if -ErrorAction Stop is specified
            If ($CopyClass) {

                #  Parse the $Copyclasse object one class at a time
                $CopyClass | ForEach-Object {

                    #  Initialize the $ShouldCopy variable with $true value
                    [boolean]$ShouldCopy = $true

                    #  Set class name to copy in a more readable format
                    $ClassNameToCopy = $_

                    #  Check if destination class exists
                    $ClassNameDestinationTest = Get-WmiClass -Namespace $NamespaceDestination -ClassName $ClassNameToCopy -ErrorAction 'SilentlyContinue'

                    #  If the class already exists in the destination and the -Force switch is specified remove it, otherwise set the $ShouldCopy variable to $false
                    If ($ClassNameDestinationTest -and $Force) {
                        $null = Remove-WmiClass -Namespace $NamespaceDestination -ClassName $ClassNameToCopy -ErrorAction 'Stop'
                    }
                    ElseIf ($ClassNameDestinationTest) {
                        $ShouldCopy = $false
                    }

                    #  Copy the class if the $ShouldCopy variable is set to $true
                    If ($ShouldCopy) {

                        #  Copy source class to destination namespace
                        Copy-WmiProperty -ClassPathSource "$NamespaceSource`:$ClassNameToCopy" -ClassPathDestination "$NamespaceDestination`:$ClassNameToCopy" -CreateDestination -ErrorAction 'Stop'

                        #  Check if source class has instances
                        $ClassInstanceSourceTest = Get-WmiInstance -Namespace $NamespaceSource -ClassName $ClassNameToCopy -ErrorAction 'SilentlyContinue'

                        #  Copy source class instances if any are found
                        If ($ClassInstanceSourceTest) {
                            Copy-WmiInstance -ClassPathSource  "$NamespaceSource`:$ClassNameToCopy" -ClassPathDestination "$NamespaceDestination`:$ClassNameToCopy" -ErrorAction 'Stop'
                        }
                    }
                    Else {
                        Write-Log -Message "Destination class [$NamespaceDestination`:$ClassNameToCopy] already exists. Use the -Force switch to overwrite." -Severity 2 -Source ${CmdletName}
                    }
                }
            }
            Else {
                $ClassNotFoundErr = "No matching class [$ClassName] found in source namespace [$NamespaceSource]."
                Write-Log -Message $ClassNotFoundErr -Severity 2 -Source ${CmdletName} -DebugMessage
                Write-Error -Message $ClassNotFoundErr -Category 'ObjectNotFound'
            }
        }
        Catch {
            Write-Log -Message "Failed to copy class. `n$(Resolve-Error)" -Severity 3 -Source ${CmdletName}
            Break
        }
        Finally {
            Write-Output -InputObject $CopyClass
        }
    }
    End {
        Write-FunctionHeaderOrFooter -CmdletName ${CmdletName} -Footer
    }
}
#endregion