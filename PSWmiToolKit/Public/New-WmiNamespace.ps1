#region Function New-WmiNamespace
Function New-WmiNamespace {
<#
.SYNOPSIS
    This function is used to create a new WMI namespace.
.DESCRIPTION
    This function is used to create a new WMI namespace.
.PARAMETER Namespace
    Specifies the namespace to create.
.PARAMETER CreateSubTree
    This swith is used to create the whole namespace sub tree if it does not exist.
.EXAMPLE
    New-WmiNamespace -Namespace 'ROOT\ConfigMgr'
.EXAMPLE
    New-WmiNamespace -Namespace 'ROOT\ConfigMgr\MEMZone\Blog' -CreateSubTree
.NOTES
    This is a module function and can typically be called directly.
.LINK
    https://MEM.Zone
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
        [string]$Namespace,
        [Parameter(Mandatory = $false, Position = 1)]
        [ValidateNotNullorEmpty()]
        [switch]$CreateSubTree = $false
    )

    Begin {
        ## Get the name of this function and write header
        [string]${CmdletName} = $PSCmdlet.MyInvocation.MyCommand.Name
        Write-FunctionHeaderOrFooter -CmdletName ${CmdletName} -CmdletBoundParameters $PSBoundParameters -Header
    }
    Process {
        Try {

            ## Check if the namespace exists
            $WmiNamespace = Get-WmiNamespace -Namespace $Namespace -ErrorAction 'SilentlyContinue'

            ## Create Namespace if it does not exist
            If (-not $WmiNamespace) {

                #  Split path into it's components
                $NamespacePaths = $Namespace.Split('\')

                #  Assigning root namespace, just for show, should always be 'ROOT'
                [string]$Path = $NamespacePaths[0]

                #  Initialize NamespacePathsObject
                [PSCustomObject]$NamespacePathsObject = @()

                #  Parsing path components and assemle individual paths
                For ($i = 1; $i -le $($NamespacePaths.Length -1); $i++ ) {
                    $Path += '\' + $NamespacePaths[$i]

                    #  Assembing path props and add them to the NamspacePathsObject
                    $PathProps = [ordered]@{ Name = $(Split-Path -Path $Path) ; Value = $(Split-Path -Path $Path -Leaf) }
                    $NamespacePathsObject += $PathProps
                }

                #  Split path into it's components
                $NamespacePaths = $Namespace.Split('\')

                #  Assigning root namespace, just for show, should always be 'ROOT'
                [string]$Path = $NamespacePaths[0]

                #  Initialize NamespacePathsObject
                [PSCustomObject]$NamespacePathsObject = @()

                #  Parsing path components and assemle individual paths
                For ($i = 1; $i -le $($NamespacePaths.Length -1); $i++ ) {
                    $Path += '\' + $NamespacePaths[$i]

                    #  Assembing path props and add them to the NamspacePathsObject
                    $PathProps = [ordered]@{
                        'NamespacePath' = $(Split-Path -Path $Path)
                        'NamespaceName' = $(Split-Path -Path $Path -Leaf)
                        'NamespaceTest' = [boolean]$(Get-WmiNamespace -Namespace $Path -ErrorAction 'SilentlyContinue')
                    }
                    $NamespacePathsObject += [PSCustomObject]$PathProps
                }

                #  If the path does not contain missing subnamespaces or the -CreateSubTree switch is specified create namespace or namespaces
                If ((($NamespacePathsObject -match $false).Count -eq 1 ) -or $CreateSubTree) {

                    #  Create each namespace in path one by one
                    $NamespacePathsObject | ForEach-Object {

                        #  Check if we need to create the namespace
                        If (-not $PSItem.NamespaceTest) {
                            #  Create namespace object and assign namespace name
                            $NameSpaceObject = (New-Object -TypeName 'System.Management.ManagementClass' -ArgumentList "\\.\$($PSItem.NameSpacePath)`:__NAMESPACE").CreateInstance()
                            $NameSpaceObject.Name = $PSItem.NamespaceName

                            #  Write the namespace object
                            $NewNamespace = $NameSpaceObject.Put()
                            $NameSpaceObject.Dispose()
                        }
                        Else {
                            Write-Log -Message "Namespace [$($PSItem.NamespacePath)`\$($PSItem.NamespaceName)] already exists." -Severity 2 -Source ${CmdletName} -DebugMessage
                        }
                    }

                    #  On namespace creation failure, write debug message and optionally throw error if -ErrorAction 'Stop' is specified
                    If (-not $NewNamespace) {
                        $CreateNamespaceErr = "Failed to create namespace [$($PSItem.NameSpacePath)`\$($PSItem.NamespaceName)]."
                        Write-Log -Message $CreateNamespaceErr -Severity 3 -Source ${CmdletName} -DebugMessage
                        Write-Error -Message $CreateNamespaceErr -Category 'InvalidResult'
                    }
                }
                ElseIf (($($NamespacePathsObject -match $false).Count -gt 1)) {
                    $SubNamespaceFoundErr = "Child namespace detected in namespace path [$Namespace]. Use the -CreateSubtree switch to create the whole path."
                    Write-Log -Message $SubNamespaceFoundErr -Severity 2 -Source ${CmdletName} -DebugMessage
                    Write-Error -Message $SubNamespaceFoundErr -Category 'InvalidOperation'
                }
            }
            Else {
                $NamespaceAlreadyExistsErr = "Failed to create namespace. [$Namespace] already exists."
                Write-Log -Message $NamespaceAlreadyExistsErr -Severity 2 -Source ${CmdletName} -DebugMessage
                Write-Error -Message $NamespaceAlreadyExistsErr -Category 'ResourceExists'
            }
        }
        Catch {
            Write-Log -Message "Failed to create namespace [$Namespace]. `n$(Resolve-Error)" -Severity 3 -Source ${CmdletName}
            Break
        }
        Finally {
            Write-Output -InputObject $NewNamespace
        }
    }
    End {
        Write-FunctionHeaderOrFooter -CmdletName ${CmdletName} -Footer
    }
}
#endregion