---
external help file: PSWmiToolKit-help.xml
Module Name: PSWmiToolKit
online version: https://MEMZ.one/PSWmiToolKit
schema: 2.0.0
---

# Remove-WmiClass

## SYNOPSIS

This function is used to remove a WMI class.

## SYNTAX

```powershell
Remove-WmiClass [[-Namespace] <String>] [[-ClassName] <String[]>] [-RemoveAll] [<CommonParameters>]
```

## DESCRIPTION

This function is used to remove a WMI class by name.

## EXAMPLES

### Example 1

```powershell
Remove-WmiClass -Namespace 'ROOT' -ClassName 'MEMZone','MEMZoneBlog'
```

### Example 2

```powershell
'MEMZone','MEMZoneBlog' | Remove-WmiClass -Namespace 'ROOT'
```

### Example 3

```powershell
Remove-WmiClass -Namespace 'ROOT' -RemoveAll
```

## PARAMETERS

### -Namespace

Specifies the namespace where to search for the WMI class. Default is: 'ROOT\cimv2'.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 0
Default value: 'ROOT\cimv2'
Accept pipeline input: False
Accept wildcard characters: False
```

### -ClassName

Specifies the class name to remove. Can be piped.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -RemoveAll

This switch is used to remove all namespace classes.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable.
For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

System.String[]

## OUTPUTS

System.Object

## NOTES

This is a module function and can typically be called directly.

## RELATED LINKS

[MEM.Zone](https://MEM.Zone)
[PSWmiToolKit](https://MEMZ.one/PSWmiToolKit)
[PSWmiToolKit-ISSUES](https://MEMZ.one/PSWmiToolKit-ISSUES)
