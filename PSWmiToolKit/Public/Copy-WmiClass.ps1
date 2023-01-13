#region Function Copy-WmiClass
Function Copy-WmiClass {
<#
.SYNOPSIS
    Copies a WMI class.
.DESCRIPTION
    Copies WMI class to another namespace.
.PARAMETER NamespaceSource
    Specifies the source namespace.
.PARAMETER NamespaceDestination
    Specifies the destinaiton namespace.
.PARAMETER ClassName
    Specifies the class name or names to copy. If this parameter is not specified all classes will be copied.(Optional)
.PARAMETER Force
    Overwrites the destination class if it already exists.
.PARAMETER CreateDestination
    Creates the destination namespace if it does not exist.
.EXAMPLE
    Copy-WmiClass -ClassName 'MEMZone' -NamespaceSource 'ROOT\ConfigMgr' -NamespaceDestination 'ROOT\Blog' -CreateDestination
.EXAMPLE
    Copy-WmiClass -NamespaceSource 'ROOT\ConfigMgr' -NamespaceDestination 'ROOT\Blog' -CreateDestination
.NOTES
    This is a module function and can typically be called directly.
.LINK
    https://MEM.Zone/
.LINK
    https://MEM.Zone/PSWmiToolKit-RELEASES
.LINK
    https://MEM.Zone/PSWmiToolKit/GIT
.LINK
    https://MEM.Zone/PSWmiToolKit/ISSUES
#>
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory = $true, Position = 0)]
        [ValidateNotNullorEmpty()]
        [string]$NamespaceSource,
        [Parameter(Mandatory = $true, Position = 1)]
        [ValidateNotNullorEmpty()]
        [string]$NamespaceDestination,
        [Parameter(Mandatory = $false, Position = 2)]
        [ValidateNotNullorEmpty()]
        [string[]]$ClassName,
        [Parameter(Mandatory = $false, Position = 3)]
        [ValidateNotNullorEmpty()]
        [switch]$Force = $false,
        [Parameter(Mandatory = $false, Position = 4)]
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
            $WmiClassNames = (Get-WmiClass -Namespace $NamespaceSource -ErrorAction 'Stop').CimClassName

            ## Check if the destination namespace exists
            $NamespaceExists = [boolean](Get-WmiNamespace -Namespace $NamespaceDestination -ErrorAction 'SilentlyContinue')

            ## Create destination namespace if specified
            If ((-not $NamespaceExists) -and $CreateDestination) {

                #  Create destination namespace
                New-WmiNamespace -Namespace $NamespaceDestination -CreateSubTree -ErrorAction 'Stop'
            }
            ElseIf (-not $NamespaceExists) {
                $DestinationNamespaceNotFoundErr = "Destination namespace [$NamespaceDestination] not found. Use -CreateDestination switch to create the destination automatically."
                Write-Log -Message $DestinationNamespaceNotFoundErr -Severity 2 -Source ${CmdletName}
                Write-Error -Message $DestinationNamespaceNotFoundErr -Category 'ObjectNotFound'
            }

            ## Select classes to copy depending on specified parameters
            If (-not $ClassName) { $ClassNames = $WmiClassNames } Else { $ClassNames = $WmiClassNames.Where({ $PSItem -in $ClassName }) }

            ## Copy matching classes otherwise throw error if -ErrorAction Stop is specified
            If ($ClassNames) {

                #  Parse the $CopyClassNames object one class at a time
                ForEach ($ClassName in $ClassNames) {

                    #  Initialize the $ShouldCopy variable with $true value
                    [boolean]$ShouldCopy = $true

                    #  Check if destination class exists
                    $ClassNameExists = [boolean](Get-WmiClass -Namespace $NamespaceDestination -ClassName $ClassName -ErrorAction 'SilentlyContinue')

                    #  If the class already exists in the destination and the -Force switch is specified remove it, otherwise set the $ShouldCopy variable to $false
                    If ($ClassNameExists -and $Force) { $null = Remove-WmiClass -Namespace $NamespaceDestination -ClassName $ClassName -ErrorAction 'Stop' }
                    ElseIf ($ClassNameExists) { $ShouldCopy = $false }

                    #  Copy the class if the $ShouldCopy variable is set to $true
                    If ($ShouldCopy) {

                        #  Copy source class to destination namespace
                        Copy-WmiProperty -ClassPathSource "$NamespaceSource`:$ClassName" -ClassPathDestination "$NamespaceDestination`:$ClassName" -CreateDestination -ErrorAction 'Stop'

                        #  Check if source class has instances
                        $ClassHasInstances = [boolean](Get-WmiInstance -Namespace $NamespaceSource -ClassName $ClassName -ErrorAction 'SilentlyContinue')

                        #  Copy source class instances if any are found
                        If ($ClassHasInstances) { Copy-WmiInstance -ClassPathSource  "$NamespaceSource`:$ClassName" -ClassPathDestination "$NamespaceDestination`:$ClassName" -ErrorAction 'Stop' }
                    }
                    Else {
                        Write-Log -Message "Destination class [$NamespaceDestination`:$ClassName] already exists. Use the -Force switch to overwrite." -Severity 2 -Source ${CmdletName}
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