---
external help file: PSWmiToolKit-help.xml
Module Name: PSWmiToolKit
online version: https://MEMZ.one/PSWmiToolKit
schema: 2.0.0
---

# Get-WmiClass

## SYNOPSIS

This function is used to get WMI class details.

## SYNTAX

```powershell
Get-WmiClass [[-Namespace] <String>] [[-ClassName] <String>] [[-QualifierName] <String>]
 [-IncludeSpecialClasses] [<CommonParameters>]
```

## DESCRIPTION

This function is used to get the details of one or more WMI classes.

## EXAMPLES

### EXAMPLE 1

```powershell
Get-WmiClass -Namespace 'ROOT\ConfigMgr' -ClassName 'MEMZone'
```

### EXAMPLE 2

```powershell
Get-WmiClass -Namespace 'ROOT\ConfigMgr' -QualifierName 'Description'
```

### EXAMPLE 3

```powershell
Get-WmiClass -Namespace 'ROOT\ConfigMgr'
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

Specifies the class name to search for.
Supports wildcards.
Default is: '*'.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: *
Accept pipeline input: False
Accept wildcard characters: False
```

### -QualifierName

Specifies the qualifier name to search for.(Optional)

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -IncludeSpecialClasses

Specifies to include System, MSFT and CIM classes.
Use this or Get operations only.

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
