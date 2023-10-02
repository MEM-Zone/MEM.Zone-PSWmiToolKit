#region Function New-WmiProperty
Function New-WmiProperty {
<#
.SYNOPSIS
    This function is used to add properties to a WMI class.
.DESCRIPTION
    This function is used to add custom properties to a WMI class.
.PARAMETER Namespace
    Specifies the namespace where to search for the WMI namespace. Default is: 'ROOT\cimv2'.
.PARAMETER ClassName
    Specifies the class name for which to add the properties.
.PARAMETER PropertyName
    Specifies the property name.
.PARAMETER PropertyType
    Specifies the property type.
.PARAMETER Qualifiers
    Specifies one ore more property qualifiers using qualifier name and value only. You can omit this parameter or enter one or more items in the hashtable.
    You can also specify a string but you must separate the name and value with a new line character (`n). This parameter can also be piped.
    The qualifiers will be added with these default flavors:
        IsAmended = $false
        PropagatesToInstance = $true
        PropagatesToSubClass = $false
        IsOverridable = $true
.PARAMETER Key
    Specifies if the property is key. Default is: false.(Optional)
.EXAMPLE
    [hashtable]$Qualifiers = @{
        Key = $true
        Static = $true
        Description = 'MEMZone Blog'
    }
    New-WmiProperty -Namespace 'ROOT\ConfigMgr' -ClassName 'MEMZone' -PropertyName 'Website' -PropertyType 'String' -Qualifiers $Qualifiers
.EXAMPLE
    "Key = $true `n Description = MEMZone Blog" | New-WmiProperty -Namespace 'ROOT\ConfigMgr' -ClassName 'MEMZone' -PropertyName 'Website' -PropertyType 'String'
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
        [string]$ClassName,
        [Parameter(Mandatory = $true, Position = 2)]
        [ValidateNotNullorEmpty()]
        [string]$PropertyName,
        [Parameter(Mandatory = $true, Position = 3)]
        [ValidateNotNullorEmpty()]
        [string]$PropertyType,
        [Parameter(Mandatory = $false,ValueFromPipeline, Position = 4)]
        [ValidateNotNullorEmpty()]
        [PSCustomObject]$Qualifiers = @()
    )

    Begin {
        ## Get the name of this function and write header
        [string]${CmdletName} = $PSCmdlet.MyInvocation.MyCommand.Name
        Write-FunctionHeaderOrFooter -CmdletName ${CmdletName} -CmdletBoundParameters $PSBoundParameters -Header
    }
    Process {
        Try {

            ## Check if the class exists
            $null = Get-WmiClass -Namespace $Namespace -ClassName $ClassName -ErrorAction 'Stop'

            ## Check if the property exist
            $WmiPropertyTest = Get-WmiProperty -Namespace $Namespace -ClassName $ClassName -PropertyName $PropertyName -ErrorAction 'SilentlyContinue'

            ## Create the property if it does not exist
            If (-not $WmiPropertyTest) {

                #  Set property to array if specified
                If ($PropertyType -match 'Array') {
                    $PropertyType = $PropertyType.Replace('Array','')
                    $PropertyIsArray = $true
                }
                Else {
                    $PropertyIsArray = $false
                }

                #  Create the ManagementClass object
                [wmiclass]$ClassObject = New-Object -TypeName 'System.Management.ManagementClass' -ArgumentList @("\\.\$Namespace`:$ClassName")

                #  Add class property
                $ClassObject.Properties.Add($PropertyName, [System.Management.CimType]$PropertyType, $PropertyIsArray)

                #  Write class object
                $NewProperty = $ClassObject.Put()
                $ClassObject.Dispose()

                ## On property creation failure, write debug message and optionally throw error if -ErrorAction 'Stop' is specified
                If (-not $NewProperty) {

                    #  Error handling and logging
                    $NewPropertyErr = "Failed create property [$PropertyName] for Class [$Namespace`:$ClassName]."
                    Write-Log -Message $NewPropertyErr -Severity 3 -Source ${CmdletName} -DebugMessage
                    Write-Error -Message $NewPropertyErr -Category 'InvalidResult'
                }

                ## Set property qualifiers one by one if specified
                If ($Qualifiers) {
                    #  Convert to a hashtable format accepted by Set-WmiPropertyQualifier. Name = QualifierName and Value = QualifierValue are expected.
                    $Qualifiers.Keys | ForEach-Object {
                        [hashtable]$PropertyQualifier = @{ Name = $PSItem; Value = $Qualifiers.Item($PSItem) }
                        #  Set qualifier
                        $null = Set-WmiPropertyQualifier -Namespace $Namespace -ClassName $ClassName -PropertyName $PropertyName -Qualifier $PropertyQualifier -ErrorAction 'Stop'
                    }
                }
            }
            Else {
                $PropertyAlreadyExistsErr = "Property [$PropertyName] already present for class [$Namespace`:$ClassName]."
                Write-Log -Message $PropertyAlreadyExistsErr  -Severity 2 -Source ${CmdletName} -DebugMessage
                Write-Error -Message $PropertyAlreadyExistsErr -Category 'ResourceExists'
            }
        }
        Catch {
            Write-Log -Message "Failed to create property for class [$Namespace`:$ClassName]. `n$(Resolve-Error)" -Severity 3 -Source ${CmdletName}
            Break
        }
        Finally {
            Write-Output -InputObject $NewProperty
        }
    }
    End {
        Write-FunctionHeaderOrFooter -CmdletName ${CmdletName} -Footer
    }
}
#endregion