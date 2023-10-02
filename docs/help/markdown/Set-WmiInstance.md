---
external help file: PSWmiToolKit-help.xml
Module Name: PSWmiToolKit
online version: https://MEMZ.one/PSWmiToolKit
schema: 2.0.0
---

# Set-WmiInstance

## SYNOPSIS

This function is used to modify a WMI Instance.

## SYNTAX

```powershell
Set-WmiInstance [-Namespace <String>] [[-ClassName] <String>] [[-Key] <String[]>]
 [[-PropertySearch] <Hashtable>] [-Property] <Hashtable> [-CreateInstance] [-Result <PSObject>]
 [<CommonParameters>]
```

## DESCRIPTION

 This function is used to modify or optionaly creating a WMI Instance if it does not exist using CIM.

## EXAMPLES

### EXAMPLE 1

```powershell
[hashtable]$PropertySearch = @{
    'ServerPort' = '99's
    'ServerIP' = '10.10.10.10'
}

[hashtable]$Property = @{
    'ServerPort' = '88'
    'ServerIP' = '11.11.11.11'
    'Source' = 'File1'
    'Date' = $(Get-Date)
}
Set-WmiInstance -Namespace 'ROOT' -ClassName 'MEMZone' -Key 'File1' -PropertySearch $PropertySearch -Property $Property
```

### EXAMPLE 2

```powershell
Set-WmiInstance -Namespace 'ROOT' -ClassName 'MEMZone' -Key 'File1' -Property $Property
```

### EXAMPLE 3

```powershell
Set-WmiInstance -Namespace 'ROOT' -ClassName 'MEMZone' -Property $Property -CreateInstance
```

### Example 1: Set WMI logging level

```powershell
PS C:\>Set-WmiInstance -Class Win32_WMISetting -Argument @{LoggingLevel=2}
__GENUS                        : 2
__CLASS                        : Win32_WMISetting
__SUPERCLASS                   : CIM_Setting
__DYNASTY                      : CIM_Setting
__RELPATH                      : Win32_WMISetting=@
__PROPERTY_COUNT               : 27
__DERIVATION                   : {CIM_Setting}
__SERVER                       : SYSTEM01
__NAMESPACE                    : root\cimv2
__PATH                         : \\SYSTEM01\root\cimv2:Win32_WMISetting=@
ASPScriptDefaultNamespace      : \\root\cimv2
ASPScriptEnabled               : False
AutorecoverMofs                : {%windir%\system32\wbem\cimwin32.mof, %windir%\system32\wbem\ncprov.mof, %windir%\syst
em32\wbem\wmipcima.mof, %windir%\system32\wbem\secrcw32.mof...}
AutoStartWin9X                 :
BackupInterval                 :
BackupLastTime                 :
BuildVersion                   : 6001.18000
Caption                        :
DatabaseDirectory              : C:\Windows\system32\wbem\repository
DatabaseMaxSize                :
Description                    :
EnableAnonWin9xConnections     :
EnableEvents                   : False
EnableStartupHeapPreallocation : False
HighThresholdOnClientObjects   :
HighThresholdOnEvents          : 20000000
InstallationDirectory          : C:\Windows\system32\wbem
LastStartupHeapPreallocation   :
LoggingDirectory               : C:\Windows\system32\wbem\Logs\
LoggingLevel                   : 2
LowThresholdOnClientObjects    :
LowThresholdOnEvents           : 10000000
MaxLogFileSize                 : 65536
MaxWaitOnClientObjects         :
MaxWaitOnEvents                : 2000
MofSelfInstallDirectory        :
SettingID                      :
```

This command sets the WMI logging level to 2.
The command passes the property to be set and the value, together considered a value pair, in the argument parameter.
The parameter takes a hash table that is defined by the @{property = value} construction.
The class information that is returned reflects the new value.

### Example 2: Create an environment variable and its value

```powershell
PS C:\>Set-WmiInstance -Class win32_environment -Argument @{Name="testvar";VariableValue="testvalue";UserName="<SYSTEM>"}
__GENUS          : 2
__CLASS          : Win32_Environment
__SUPERCLASS     : CIM_SystemResource
__DYNASTY        : CIM_ManagedSystemElement
__RELPATH        : Win32_Environment.Name="testvar",UserName="<SYSTEM>"
__PROPERTY_COUNT : 8
__DERIVATION     : {CIM_SystemResource, CIM_LogicalElement, CIM_ManagedSystemElement}
__SERVER         : SYSTEM01
__NAMESPACE      : root\cimv2
__PATH           : \\SYSTEM01\root\cimv2:Win32_Environment.Name="testvar",UserName="<SYSTEM>"
Caption          : <SYSTEM>\testvar
Description      : <SYSTEM>\testvar
InstallDate      :
Name             : testvar
Status           : OK
SystemVariable   : True
UserName         : <SYSTEM>
VariableValue    : testvalue
```

This command creates the testvar environment variable that has the value testvalue.
It does this by creating a new instance of the Win32_Environment WMI class.
This operation requires appropriate credentials and that you may have to restart Windows PowerShell to see the new environment variable.

### Example 3: Set WMI logging level for several remote computers

```powershell
PS C:\>Set-WmiInstance -Class Win32_WMISetting -Argument @{LoggingLevel=2} -Computername "system01", "system02", "system03"
__GENUS                        : 2
__CLASS                        : Win32_WMISetting
__SUPERCLASS                   : CIM_Setting
__DYNASTY                      : CIM_Setting
__RELPATH                      : Win32_WMISetting=@
__PROPERTY_COUNT               : 27
__DERIVATION                   : {CIM_Setting}
__SERVER                       : SYSTEM01
__NAMESPACE                    : root\cimv2
__PATH                         : \\SYSTEM01\root\cimv2:Win32_WMISetting=@
ASPScriptDefaultNamespace      : \\root\cimv2
ASPScriptEnabled               : False
AutorecoverMofs                : {%windir%\system32\wbem\cimwin32.mof, %windir%\system32\wbem\ncprov.mof, %windir%\syst
em32\wbem\wmipcima.mof, %windir%\system32\wbem\secrcw32.mof...}
AutoStartWin9X                 :
BackupInterval                 :
BackupLastTime                 :
BuildVersion                   : 6001.18000
Caption                        :
DatabaseDirectory              : C:\Windows\system32\wbem\repository
DatabaseMaxSize                :
Description                    :
EnableAnonWin9xConnections     :
EnableEvents                   : False
EnableStartupHeapPreallocation : False
HighThresholdOnClientObjects   :
HighThresholdOnEvents          : 20000000
InstallationDirectory          : C:\Windows\system32\wbem
LastStartupHeapPreallocation   :
LoggingDirectory               : C:\Windows\system32\wbem\Logs\
LoggingLevel                   : 2
LowThresholdOnClientObjects    :
LowThresholdOnEvents           : 10000000
MaxLogFileSize                 : 65536
MaxWaitOnClientObjects         :
MaxWaitOnEvents                : 2000
MofSelfInstallDirectory        :
SettingID                      :
...
```

This command sets the WMI logging level to 2.
The command passes the property to be set and the value, together considered a value pair, in the argument parameter.
The parameter takes a hash table that is defined by the @{property = value} construction.
The returned class information reflects the new value.

## PARAMETERS

### -Namespace

Specifies the Class Namespace. Default is ROOT\cimv2.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ClassName

Specifies the Class Name.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: MEMZone
Accept pipeline input: False
Accept wildcard characters: False
```

### -Key

Specifies the Properties that are used as keys (Optional).

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -PropertySearch

Specifies the Class Instance Properties and Values to find.

```yaml
Type: Hashtable
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Property

Specifies the Class Instance Properties and Values to set.

```yaml
Type: Hashtable
Parameter Sets: (All)
Aliases:

Required: True
Position: 5
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -CreateInstance

Switch for creating the instance if it does not exist.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: 6
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable.
For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

None
This cmdlet does not accept input.

## OUTPUTS

None
This cmdlet does not generate output.

## NOTES
This is a module function and can typically be called directly.

## RELATED LINKS

[MEM.Zone](https://MEM.Zone)
[PSWmiToolKit](https://MEMZ.one/PSWmiToolKit)
[PSWmiToolKit-ISSUES](https://MEMZ.one/PSWmiToolKit-ISSUES)
