#region Function Get-WmiNamespace
Function Get-WmiNamespace {
<#
.SYNOPSIS
    This function is used to get WMI namespace information.
.DESCRIPTION
    This function is used to get the details of one or more WMI namespaces.
.PARAMETER Namespace
    Specifies the namespace(s) path(s). Supports wildcards only when not using the -Recurse or -List switch. Can be piped.
.PARAMETER List
    This switch is used to list all namespaces in the specified path. Cannot be used in conjunction with the -Recurse switch.
.PARAMETER Recurse
    This switch is used to get the whole WMI namespace tree recursively. Cannot be used in conjunction with the -List switch.
.EXAMPLE
    C:\PS> Get-WmiNamespace -NameSpace 'ROOT\SCCM'
.EXAMPLE
    C:\PS> Get-WmiNamespace -NameSpace 'ROOT\*CM'
.EXAMPLE
    C:\PS> Get-WmiNamespace -NameSpace 'ROOT' -List
.EXAMPLE
    C:\PS> Get-WmiNamespace -NameSpace 'ROOT' -Recurse
.EXAMPLE
    C:\PS> 'Root\SCCM', 'Root\SC*' | Get-WmiNamespace
.INPUTS
    System.String[].
.OUTPUTS
    System.Management.Automation.PSCustomObject.
        'Name'
        'Path'
        'FullName'
.NOTES
    This is a public module function and can typically be called directly.
.LINK
    https://github.com/JhonnyTerminus/PSWmiToolKit
.LINK
    https://sccm-zone.com
.COMPONENT
    WMI
.FUNCTIONALITY
    WMI Management
#>
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory=$true,ValueFromPipeline,Position=0)]
        [ValidateNotNullorEmpty()]
        [SupportsWildcards()]
        [string[]]$Namespace,
        [Parameter(Mandatory=$false,Position=1)]
        [ValidateNotNullorEmpty()]
        [ValidateScript({
            If ($Namespace -match '\*') { Throw 'Wildcards are not supported with this switch.' }
            Return $true
        })]
        [switch]$List = $false,
        [Parameter(Mandatory=$false,Position=2)]
        [ValidateNotNullorEmpty()]
        [ValidateScript({
            If ($Namespace -match '\*') { Throw 'Wildcards are not supported with this switch.' }
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

                #  Call Get-WmiNamespaceRecursive internal function
                $GetNamespace = Get-WmiNamespaceRecursive -Namespace $Namespace -ErrorAction 'SilentlyContinue' | Sort-Object -Property Path
            }
            Else {

                ## If namespace is 'ROOT' or -List is specified get namespace else get Parent\Leaf namespace
                If ($List -or ($Namespace -eq 'ROOT')) {
                    $WmiNamespace = Get-CimInstance -Namespace $([string]$Namespace) -ClassName '__Namespace' -ErrorAction 'SilentlyContinue' -ErrorVariable Err
                }
                Else {
                    #  Set namespace path and name
                    [string]$NamespaceParent = $(Split-Path -Path $Namespace -Parent)
                    [string]$NamespaceLeaf = $(Split-Path -Path $Namespace -Leaf)
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
                            #  Standardize namespace path separator by changing it from '/' to '\'.
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

            ## If we have anyting to return, add typename for formatting purposes, otherwise set the result to $null
            If ($GetNamespace) {
                $GetNamespace.PSObject.TypeNames.Insert(0,'Get.WmiNamespace.Typename')
            }
            Else {
                $GetNamespace = $null
            }

            ## Return result
            Write-Output -InputObject $GetNamespace
        }
    }
    End {
        Write-FunctionHeaderOrFooter -CmdletName ${CmdletName} -Footer
    }
}
#endregion