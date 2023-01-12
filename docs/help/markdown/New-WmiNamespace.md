---
external help file: PSWmiToolKit-help.xml
Module Name: PSWmiToolKit
online version: https://MEM.Zone/PSWmiToolKit
schema: 2.0.0
---

# New-WmiNamespace

## SYNOPSIS

This function is used to create a new WMI namespace.

## SYNTAX

```powershell
New-WmiNamespace [-Namespace] <String> [-CreateSubTree] [<CommonParameters>]
```

## DESCRIPTION

This function is used to create a new WMI namespace.

## EXAMPLES

### EXAMPLE 1

```powershell
New-WmiNamespace -Namespace 'ROOT\ConfigMgr'
```

### EXAMPLE 2

```powershell
New-WmiNamespace -Namespace 'ROOT\ConfigMgr\MEMZone\Blog' -CreateSubTree
```

## PARAMETERS

### -Namespace

Specifies the namespace to create.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -CreateSubTree

This swith is used to create the whole namespace sub tree if it does not exist.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
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
[MEM.Zone/GIT](https://MEM.Zone/GIT)
