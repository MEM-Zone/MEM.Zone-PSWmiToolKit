---
external help file: PSWmiToolKit-help.xml
Module Name: PSWmiToolKit
online version: https://MEMZ.one/PSWmiToolKit
schema: 2.0.0
---

# New-WmiClass

## SYNOPSIS

This function is used to create a WMI class.

## SYNTAX

```powershell
New-WmiClass [[-Namespace] <String>] [-ClassName] <String> [[-Qualifiers] <PSObject>] [-CreateDestination]
 [<CommonParameters>]
```

## DESCRIPTION

This function is used to create a WMI class with custom properties.

## EXAMPLES

### EXAMPLE 1

```powershell
[hashtable]$Qualifiers = @{
    Key = $true
    Static = $true
    Description = 'MEMZone Blog'
}
New-WmiClass -Namespace 'ROOT' -ClassName 'MEMZone' -Qualifiers $Qualifiers
```

### EXAMPLE 2

```powershell
"Key = $true `n Static = $true `n Description = MEM.Zone Blog" | New-WmiClass -Namespace 'ROOT' -ClassName 'MEMZone'
```

### EXAMPLE 3

```powershell
New-WmiClass -Namespace 'ROOT\SCCM' -ClassName 'MEMZone' -CreateDestination
```

## PARAMETERS

### -Namespace

Specifies the namespace where to search for the WMI namespace.
Default is: 'ROOT\cimv2'.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: ROOT\cimv2
Accept pipeline input: False
Accept wildcard characters: False
```

### -ClassName

Specifies the name for the new class.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Qualifiers

Specifies one ore more property qualifiers using qualifier name and value only.
You can omit this parameter or enter one or more items in the hashtable.
You can also specify a string but you must separate the name and value with a new line character (\`n).
This parameter can also be piped.
The qualifiers will be added with these default values and flavors:

```powershell
    Static = $true
    IsAmended = $false
    PropagatesToInstance = $true
    PropagatesToSubClass = $false
    IsOverridable = $true
```

```yaml
Type: PSObject
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: @("Static = $true")
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -CreateDestination

This switch is used to create destination namespace.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable.
For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

This is a module function and can typically be called directly.

## RELATED LINKS

[MEM.Zone](https://MEM.Zone)
[PSWmiToolKit](https://MEMZ.one/PSWmiToolKit)
[PSWmiToolKit-ISSUES](https://MEMZ.one/PSWmiToolKit-ISSUES)
