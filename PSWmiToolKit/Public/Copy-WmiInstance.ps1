#region Function Copy-WmiInstance
Function Copy-WmiInstance {
<#
.SYNOPSIS
    This function is used to copy the instances of a WMI class.
.DESCRIPTION
    This function is used to copy the instances of a WMI class to another class.
.PARAMETER ClassPathSource
    Specifies the class to be copied from.
.PARAMETER ClassPathDestination
    Specifies the class to be copied to.
.PARAMETER Property
    Specifies the instance property to copy. If this parameter is not specified all instances are copied.(Optional)
.PARAMETER MatchAll
    This switch is used to specify wether to match all or any of the specified instance properties. If this switch is specified you must enter all data
    present in the desired source class instance in order to have a succesfull match. Default is: $false.
.PARAMETER CreateDestination
    This switch is used to create the destination if it does not exist. Default is: $false.
.EXAMPLE
    Copy-WmiInstance -ClassPathSource 'ROOT\ConfigMgr:MEMZone' -ClassPathDestination 'ROOT\ConfigMgr:MEMZoneBlog' -CreateDestination
.EXAMPLE
    [hashtable]$Property = @{ Description = 'MEMZone WebSite' }
    Copy-WmiInstance -ClassPathSource 'ROOT\ConfigMgr:MEMZone' -ClassPathDestination 'ROOT\ConfigMgr:MEMZoneBlog' -Property $Property -CreateDestination
.EXAMPLE
    [hashtable]$Property = @{
        MEMZoneWebSite = 'https:\ConfigMgr-Zone.com'
        Description = 'MEMZone WebSite'
    }
    Copy-WmiInstance -ClassPathSource 'ROOT\ConfigMgr:MEMZone' -ClassPathDestination 'ROOT\ConfigMgr:MEMZoneBlog'  -Property $Property -MatchAll -CreateDestination
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
        [hashtable]$Property,
        [Parameter(Mandatory = $false, Position = 3)]
        [ValidateNotNullorEmpty()]
        [switch]$MatchAll = $false,
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

            ## Set source and destination paths and name variables
            #  Set NamespaceSource
            $NamespaceSource = (Split-Path -Path $ClassPathSource -Qualifier).TrimEnd(':')
            #  Set NamespaceDestination
            $NamespaceDestination =  (Split-Path -Path $ClassPathDestination -Qualifier).TrimEnd(':')
            #  Set ClassNameSource
            $ClassNameSource = (Split-Path -Path $ClassPathSource -NoQualifier)
            #  Set ClassNameDestination
            $ClassNameDestination = (Split-Path -Path $ClassPathDestination -NoQualifier)

            ## Check if the source class exists. If source class does not exist throw an error
            $null = Get-WmiClass -Namespace $NamespaceSource -ClassName $ClassNameSource -ErrorAction 'Stop'

            ## Get the class source properties
            $ClassPropertiesSource = Get-WmiProperty -Namespace $NamespaceSource -ClassName $ClassNameSource -ErrorAction 'SilentlyContinue'

            ## Check if the destination class exists
            $ClassDestinationTest = Get-WmiClass -Namespace $NamespaceDestination -ClassName $ClassNameDestination -ErrorAction 'SilentlyContinue'

            ## Create destination class if specified
            If ((-not $ClassDestinationTest) -and $CreateDestination) {
                $null = Copy-WmiClassQualifier -ClassPathSource $ClassPathSource -ClassPathDestination $ClassPathDestination -CreateDestination -ErrorAction 'Stop'
            }
            ElseIf (-not $ClassDestinationTest) {
                $DestinationClassErr = "Destination [$NamespaceDestination`:$ClassNameDestination] does not exist. Use the -CreateDestination switch to automatically create the destination class."
                Write-Log -Message $DestinationClassErr -Severity 2 -Source ${CmdletName}
                Write-Error -Message $DestinationClassErr -Category 'ObjectNotFound'
            }

            ## Get destination class properties
            $ClassPropertiesDestination = Get-WmiProperty -Namespace $NamespaceDestination -ClassName $ClassNameDestination -ErrorAction 'SilentlyContinue'

            ## Copy class properties from the source class if not present in the destination class
            $ClassPropertiesSource | ForEach-Object {
                If ($PSItem.Name -notin $ClassPropertiesDestination.Name) {
                    #  Create property
                    $null = New-WmiProperty -Namespace $NamespaceDestination -ClassName $ClassNameDestination -PropertyName $PSItem.Name -PropertyType $PSItem.CimType
                    #  Set qualifier if present
                    If ($PSItem.Qualifiers.Name) {
                        $null = Set-WmiPropertyQualifier -Namespace $NamespaceDestination -ClassName $ClassNameDestination -PropertyName $PSItem.Name -Qualifier @{ Name = $PSItem.Qualifiers.Name; Value = $PSItem.Qualifiers.Value }
                    }
                }
            }

            ## Get source class instances
            $ClassInstancesSource =  Get-WmiInstance -Namespace $NamespaceSource -ClassName $ClassNameSource -ErrorAction 'SilentlyContinue' | Select-Object -Property $ClassPropertiesSource.Name

            ## Initialize $CopyInstance object
            [PSCustomObject]$CopyInstance = @()

            ## Copy instances if thery are present in the source class ignoring any errors
            If ($ClassInstancesSource) {

                #  Convert instance to hashtable
                $ClassInstancesSource | ForEach-Object {

                    #  Initialize/Reset $InstanceProperty hashtable
                    $InstanceProperty = @{}

                    #  Assemble instance property hashtable
                    For ($i = 0; $i -le $($ClassPropertiesSource.Name.Length -1); $i++) {
                        $InstanceProperty += [ordered]@{
                            $($ClassPropertiesSource.Name[$i]) = $PSItem.($ClassPropertiesSource.Name[$i])
                        }
                    }

                    #  Initialize $ShouldCopy. This variable will be used to asses wether the instance should be copied or not
                    $ShouldCopy = $true
                    #  Convert input property and instance property to copy to custom objects for comparison
                    $InputPropertyObj = [PSCustomObject]$Property
                    $InstancePropertyObj = [PSCustomObject]$InstanceProperty

                    #  If Property parameter is specified check if instance Property matches the Input Property. If no match is found set the $ShouldCopy value to $false
                    If ($Property -and $MatchAll) {
                        $ShouldCopy = [boolean]$(Compare-Object -ReferenceObject $InputPropertyObj -DifferenceObject $InstancePropertyObj -Property $ClassPropertiesSource.Name -IncludeEqual -ExcludeDifferent)
                    }
                    ElseIf ($Property) {
                        $ShouldCopy = [boolean]$(Compare-Object -ReferenceObject $InputPropertyObj -DifferenceObject $InstancePropertyObj -IncludeEqual -ExcludeDifferent)
                    }

                    #  Check if instance already in destination class
                    $ClassInstanceTest = Get-WmiInstance -Namespace $NamespaceDestination -ClassName $ClassNameDestination -Property $InstanceProperty -ErrorAction 'SilentlyContinue'

                    #  Create instance if no instance is found in destination class and $ShouldCopy value is $True
                    If ((-not $ClassInstanceTest) -and $ShouldCopy) {
                        $CopyInstance += New-WmiInstance -Namespace $NamespaceDestination -ClassName $ClassNameDestination -Property $InstanceProperty -ErrorAction 'Stop'
                    }
                    ElseIf (-not $ShouldCopy) {
                        Write-Log -Message "Instance does not match specified input property." -Severity 2 -Source ${CmdletName} -DebugMessage
                    }
                    Else {
                        Write-Log -Message "Instance already in destination class [$NamespaceDestination`:$ClassNameDestination]." -Severity 2 -Source ${CmdletName} -DebugMessage
                    }
                }
            }
            Else {
                Write-Log -Message  "No instances found in source class [$NamespaceSource`:$ClassNameSource]." -Severity 2 -Source ${CmdletName} -DebugMessage
            }
        }
        Catch {
            Write-Log -Message "Failed to copy class instances. `n$(Resolve-Error)" -Severity 3 -Source ${CmdletName}
        }
        Finally {
            Write-Output -InputObject $CopyInstance
        }
    }
    End {
        Write-FunctionHeaderOrFooter -CmdletName ${CmdletName} -Footer
    }
}
#endregion