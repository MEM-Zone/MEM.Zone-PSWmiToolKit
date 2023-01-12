---
external help file: PSWmiToolKit-help.xml
Module Name: PSWmiToolKit
online version: https://MEM.Zone/PSWmiToolKit
schema: 2.0.0
---

# Get-WmiClassQualifier

## SYNOPSIS

This function is used to get the qualifiers of a WMI class.

## SYNTAX

```powershell
Get-WmiClassQualifier [[-Namespace] <String>] [-ClassName] <String> [[-QualifierName] <String>]
 [[-QualifierValue] <String>] [<CommonParameters>]
```

## DESCRIPTION

This function is used to get one or more qualifiers of a WMI class.

## EXAMPLES

### EXAMPLE 1

```powershell
Get-WmiClassQualifier -Namespace 'ROOT\ConfigMgr' -ClassName 'MEMZone' -QualifierName 'Description' -QualifierValue 'MEMZone Blog'
```

### EXAMPLE 2

```powershell
Get-WmiClassQualifier -Namespace 'ROOT\ConfigMgr' -ClassName 'MEMZone' -QualifierName 'Description' -QualifierValue 'MEMZone*'
```

### EXAMPLE 3

```powershell
Get-WmiClassQualifier -Namespace 'ROOT\ConfigMgr' -ClassName 'MEMZone'
```

## PARAMETERS

### -Namespace

Specifies the namespace where to search for the WMI class.
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

Specifies the class name for which to get the qualifiers.

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

### -QualifierName

Specifies the qualifier search for.
Suports wildcards.
Default is: '*'.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: *
Accept pipeline input: False
Accept wildcard characters: False
```

### -QualifierValue

Specifies the qualifier search for.
Supports wildcards.(Optional)

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
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
[MEM.Zone/GIT](https://MEM.Zone/GIT)
