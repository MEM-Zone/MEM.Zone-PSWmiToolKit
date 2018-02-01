#region Function Get-WmiNameSpace
Function Get-WmiNameSpace {
<#
.SYNOPSIS
    This function is used to get a WMI namespace.
.DESCRIPTION
    This function is used to get the details of one or more WMI namespaces.
.PARAMETER Namespace
    Specifies the namespace path. Supports wildcards only when not using the -Recurse or -List switch.
.PARAMETER List
    This switch is used to list all namespaces in the specified path.
.PARAMETER Recurse
    This switch is used to get the whole WMI namespace tree recursively.
.EXAMPLE
    Get-WmiNameSpace -NameSpace 'ROOT\SCCM'
.EXAMPLE
    Get-WmiNameSpace -NameSpace 'ROOT\*'
.EXAMPLE
    Get-WmiNameSpace -NameSpace 'ROOT' -List
.EXAMPLE
    Get-WmiNameSpace -NameSpace 'ROOT' -Recurse
.INPUTS
    None.
.OUTPUTS
    None.
.NOTES
    This is a module function and can typically be called directly.
.LINK
    https://sccm-zone.com
.LINK
    https://github.com/JhonnyTerminus/SCCM
.COMPONENT
    WMI
.FUNCTIONALITY
    WMI Management
#>
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory=$true,Position=0)]
        [ValidateNotNullorEmpty()]
        [SupportsWildcards()]
        [string]$Namespace,
        [Parameter(Mandatory=$false,Position=1)]
        [ValidateNotNullorEmpty()]
        [ValidateScript({
            If ($Namespace -match '\*') { Throw "Wildcards are not supported with this switch." }
            Return $true
        })]
        [switch]$List = $false,
        [Parameter(Mandatory=$false,Position=2)]
        [ValidateNotNullorEmpty()]
        [ValidateScript({
            If ($Namespace -match '\*') { Throw "Wildcards are not supported with this switch." }
            Return $true
        })]
        [switch]$Recurse = $false
    )

    Begin {
        ## Get the name of this function and write header
        [string]${CmdletName} = $PSCmdlet.MyInvocation.MyCommand.Name
        Write-FunctionHeaderOrFooter -CmdletName ${CmdletName} -CmdletBoundParameters $PSBoundParameters -Header

        ## Initialize result variable
        [PSCustomObject]$GetNamespace = $null
    }
    Process {
        Try {

            ## Get namespace tree recursively if specified, otherwise just get the current namespace
            If ($Recurse) {

                    #  Call Get-NamespacesRecursive internal function
                    $GetNamespace = Get-WmiNamespaceRecursive -NamespaceRoot $Namespace -ErrorAction 'SilentlyContinue' | Sort-Object -Property Path
            }
            Else {

                ## If namespace is 'ROOT' or -List is specified get namespace else get Parent\Leaf namespace
                If ($List -or ($Namespace -eq 'ROOT')) {
                    $WmiNamespace = Get-CimInstance -Namespace $Namespace -ClassName '__Namespace' -ErrorAction 'SilentlyContinue' -ErrorVariable Err
                }
                Else {
                    #  Set namespace path and name
                    $NamespaceParent = $(Split-Path -Path $Namespace -Parent)
                    $NamespaceLeaf = $(Split-Path -Path $Namespace -Leaf)
                    #  Get namespace
                    $WmiNamespace = Get-CimInstance -Namespace $NamespaceParent -ClassName '__Namespace' -ErrorAction 'SilentlyContinue' -ErrorVariable Err | Where-Object { $_.Name -like $NamespaceLeaf }
                }

                ## If no namespace is found, write debug message and optionally throw error is -ErrorAction 'Stop' is specified
                If (-not $WmiNamespace -and $List -and (-not $Err)) {
                    $NamespaceChildrenNotFoundErr = "Namespace [$Namespace] has no children."
                    Write-Log -Message $NamespaceChildrenNotFoundErr -Severity 2 -Source ${CmdletName} -DebugMessage
                    Write-Error -Message $NamespaceChildrenNotFoundErr -Category 'ObjectNotFound'
                }
                ElseIf (-not $WmiNamespace) {
                    $NamespaceNotFoundErr = "Namespace [$Namespace] not found."
                    Write-Log -Message $NamespaceNotFoundErr -Severity 2 -Source ${CmdletName} -DebugMessage
                    Write-Error -Message $NamespaceNotFoundErr -Category 'ObjectNotFound'
                }
                ElseIf (-not $Err) {
                    $GetNamespace = $WmiNamespace | ForEach-Object {
                        [PSCustomObject]@{
                            Name = $Name = $_.Name
                            Path = $Path = $_.CimSystemProperties.Namespace -replace ('/','\')
                            FullName = "$Path`\$Name"
                        }
                    }
                }
            }
        }
        Catch {
            Write-Log -Message "Failed to retrieve wmi namespace [$Namespace]. `n$(Resolve-Error)" -Severity 3 -Source ${CmdletName}
            Break
        }
        Finally {
            Write-Output -InputObject $GetNamespace
        }
    }
    End {
        Write-FunctionHeaderOrFooter -CmdletName ${CmdletName} -Footer
    }
}
#endregion