---
external help file: PSWmiToolKit-help.xml
Module Name: PSWmiToolKit
online version: https://MEM.Zone/PSWmiToolKit
schema: 2.0.0
---

# Remove-WmiClassQualifier

## SYNOPSIS

This function is used to remove qualifiers from a WMI class.

## SYNTAX

```powershell
Remove-WmiClassQualifier [[-Namespace] <String>] [-ClassName] <String> [[-QualifierName] <String[]>]
 [-RemoveAll] [<CommonParameters>]
```

## DESCRIPTION

This function is used to remove qualifiers from a WMI class by name.

## EXAMPLES

### EXAMPLE 1

```powershell
Remove-WmiClassQualifier -Namespace 'ROOT' -ClassName 'MEMZone' -QualifierName 'Description', 'Static'
```

### EXAMPLE 2

```powershell
Remove-WmiClassQualifier -Namespace 'ROOT' -ClassName 'MEMZone' -RemoveAll
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

Specifies the class name for which to remove the qualifiers.

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

Specifies the qualifier name or names to be removed.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -RemoveAll

This switch will remove all class qualifiers.

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
[MEM.Zone/GIT](https://MEM.Zone/GIT)
