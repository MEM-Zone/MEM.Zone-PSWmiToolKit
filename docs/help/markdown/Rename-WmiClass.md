---
external help file: PSWmiToolKit-help.xml
Module Name: PSWmiToolKit
online version: https://sccm-zone.com
schema: 2.0.0
---

# Rename-WmiClass

## SYNOPSIS
This function is used to rename a WMI class.

## SYNTAX

```
Rename-WmiClass [[-Namespace] <String>] [-Name] <String> [-NewName] <String> [<CommonParameters>]
```

## DESCRIPTION
This function is used to rename a WMI class by creating a new class, copying all existing properties and instances to it and removing the old one.

## EXAMPLES

### EXAMPLE 1
```
Rename-WmiClass -Namespace 'ROOT\cimv2' -Name 'SCCM' -NewName 'SCCMZone'
```

## PARAMETERS

### -Namespace
Specifies the namespace for the class.
Default is: ROOT\cimv2.

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

### -Name
Specifies the class name to be renamed.

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

### -NewName
Specifies the new class name.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 3
Default value: None
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

