---
external help file: PSWmiToolKit-help.xml
Module Name: PSWmiToolKit
online version: https://MEMZ.one/PSWmiToolKit
schema: 2.0.0
---

# Rename-WmiNamespace

## SYNOPSIS

This function is used to rename a WMI namespace.

## SYNTAX

```powershell
Rename-WmiNamespace [[-Namespace] <String>] [-Name] <String> [-NewName] <String> [<CommonParameters>]
```

## DESCRIPTION

This function is used to rename a WMI namespace by creating a new namespace, copying all existing classes to it and removing the old one.

## EXAMPLES

### EXAMPLE 1

```powershell
Rename-WmiNamespace -Namespace 'ROOT\cimv2' -Name 'ConfigMgr' -NewName 'MEMZone'
```

## PARAMETERS

### -Namespace

Specifies the root namespace where to search for the namespace name.
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

Specifies the namespace name to be renamed.

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

Specifies the new namespace name.

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
For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

This is a module function and can typically be called directly.

## RELATED LINKS

[MEM.Zone](https://MEM.Zone)
[PSWmiToolKit](https://MEMZ.one/PSWmiToolKit)
[PSWmiToolKit-ISSUES](https://MEMZ.one/PSWmiToolKit-ISSUES)
