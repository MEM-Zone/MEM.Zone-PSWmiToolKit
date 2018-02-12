---
external help file: PSWmiToolkit-help.xml
Module Name: PSWmiToolKit
online version: https://sccm-zone.com
schema: 2.0.0
---

# New-WmiClass

## SYNOPSIS
This function is used to create a WMI class.

## SYNTAX

```
New-WmiClass [[-Namespace] <String>] [-ClassName] <String> [[-Qualifiers] <PSObject>] [-CreateDestination]
 [<CommonParameters>]
```

## DESCRIPTION
This function is used to create a WMI class with custom properties.

## EXAMPLES

### EXAMPLE 1
```
[hashtable]$Qualifiers = @{
```

Key = $true
    Static = $true
    Description = 'SCCMZone Blog'
}
New-WmiClass -Namespace 'ROOT' -ClassName 'SCCMZone' -Qualifiers $Qualifiers

### EXAMPLE 2
```
"Key = $true `n Static = $true `n Description = SCCMZone Blog" | New-WmiClass -Namespace 'ROOT' -ClassName 'SCCMZone'
```

### EXAMPLE 3
```
New-WmiClass -Namespace 'ROOT\SCCM' -ClassName 'SCCMZone' -CreateDestination
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
    Static = $true
    IsAmended = $false
    PropagatesToInstance = $true
    PropagatesToSubClass = $false
    IsOverridable = $true

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
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES
This is a module function and can typically be called directly.

## RELATED LINKS

[https://sccm-zone.com](https://sccm-zone.com)

[https://github.com/JhonnyTerminus/SCCM](https://github.com/JhonnyTerminus/SCCM)

