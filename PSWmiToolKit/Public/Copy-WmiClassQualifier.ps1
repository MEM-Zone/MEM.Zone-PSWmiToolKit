#region Function Copy-WmiClassQualifier
Function Copy-WmiClassQualifier {
<#
.SYNOPSIS
    This function is used to copy the qualifiers of a WMI class.
.DESCRIPTION
    This function is used to copy the qualifiers of a WMI class to another class. Default qualifier flavors will be used.
.PARAMETER ClassPathSource
    Specifies the class to be copied from.
.PARAMETER ClassPathDestination
    Specifies the class to be copied to.
.PARAMETER QualifierName
    Specifies the class qualifier name or names to copy. If this parameter is not specified all class qualifiers will be copied.(Optional)
.PARAMETER CreateDestination
    This switch is used to create the destination if it does not exist. Default is: $false.
.EXAMPLE
    Copy-WmiClassQualifier -ClassPathSource 'ROOT\ConfigMgr:MEMZone' -ClassPathDestination 'ROOT\ConfigMgr:MEMZoneBlog' -CreateDestination
.EXAMPLE
    Copy-WmiClassQualifier -ClassPathSource 'ROOT\ConfigMgr:MEMZone' -ClassPathDestination 'ROOT\ConfigMgr:MEMZoneBlog' -QualifierName 'Description' -CreateDestination
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
        [string]$ClassPathSource,
        [Parameter(Mandatory = $true, Position = 1)]
        [ValidateNotNullorEmpty()]
        [string]$ClassPathDestination,
        [Parameter(Mandatory = $false, Position = 2)]
        [ValidateNotNullorEmpty()]
        [string[]]$QualifierName,
        [Parameter(Mandatory = $false, Position = 3)]
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

            ## Set source and destination paths and name variables
            #  Set NamespaceSource
            $NamespaceSource = (Split-Path -Path $ClassPathSource -Qualifier).TrimEnd(':')
            #  Set NamespaceDestination
            $NamespaceDestination =  (Split-Path -Path $ClassPathDestination -Qualifier).TrimEnd(':')
            #  Set ClassNameSource
            $ClassNameSource = (Split-Path -Path $ClassPathSource -NoQualifier)
            #  Set ClassNameDestination
            $ClassNameDestination = (Split-Path -Path $ClassPathDestination -NoQualifier)

            ## Check if source class exists
            $null = Get-WmiClass -Namespace $NamespaceSource -ClassName $ClassNameSource -ErrorAction 'Stop'

            ## Get source class qualifiers
            $ClassQualifiersSource = Get-WmiClassQualifier -Namespace $NamespaceSource -ClassName $ClassNameSource -ErrorAction 'SilentlyContinue'

            ## Check if the destination class exists
            $ClassDestinationTest = Get-WmiClass -Namespace $NamespaceDestination -ClassName $ClassNameDestination -ErrorAction 'SilentlyContinue'

            ## Create destination namespace and class if specified
            If ((-not $ClassDestinationTest) -and $CreateDestination) {
                $null = New-WmiClass -Namespace $NamespaceDestination -ClassName $ClassNameDestination -CreateDestination -ErrorAction 'Stop'
            }
            ElseIf (-not $ClassDestinationTest) {
                $DestinationClassErr = "Destination [$NamespaceSource`:$ClassName] does not exist. Use the -CreateDestination switch to automatically create the destination class."
                Write-Log -Message $DestinationClassErr -Severity 2 -Source ${CmdletName}
                Write-Error -Message $DestinationClassErr -Category 'ObjectNotFound'
            }

            ## Check if there are any qualifers in the source class
            If ($ClassQualifiersSource) {

                ## Copy all qualifiers if not specified otherwise
                If (-not $QualifierName) {

                    #  Set destination class qualifiers
                    $ClassQualifiersSource | ForEach-Object {
                        #  Set class qualifiers one by one
                        $CopyClassQualifier = Set-WmiClassQualifier -Namespace $NamespaceDestination -ClassName $ClassNameDestination -Qualifier @{ Name = $PSItem.Name; Value = $PSItem.Value } -ErrorAction 'Stop'
                    }
                }
                Else {

                    ## Copy class qualifier if it exists in source class, otherwise log the error and continue
                    $ClassQualifiersSource | ForEach-Object {
                        If ($PSItem.Name -in $QualifierName) {
                            $CopyClassQualifier = Set-WmiClassQualifier -Namespace $NamespaceDestination -ClassName $ClassNameDestination -Qualifier @{ Name = $PSItem.Name; Value = $PSItem.Value } -ErrorAction 'Stop'
                        }
                        Else {
                            $ClassQualifierNotFoundErr = "Failed to copy class qualifier [$($PSItem.Name)]. Qualifier not found in source class [$NamespaceSource`:$ClassName]."
                            Write-Log -Message $ClassQualifierNotFoundErr -Severity 3 -Source ${CmdletName}
                        }
                    }
                }
            }
            Else {

                ## If no class qualifiers are found log error but continue execution regardless of the $ErrorActionPreference variable value
                Write-Log -Message "No qualifiers found in source class [$NamespaceSource`:$ClassName]." -Severity 2 -Source ${CmdletName}
            }
        }
        Catch {
            Write-Log -Message "Failed to copy class qualifier. `n$(Resolve-Error)" -Severity 3 -Source ${CmdletName}
            Break
        }
        Finally {
            Write-Output -InputObject $CopyClassQualifier
        }
    }
    End {
        Write-FunctionHeaderOrFooter -CmdletName ${CmdletName} -Footer
    }
}
#endregion