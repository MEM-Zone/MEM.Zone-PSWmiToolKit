---
external help file: PSWmiToolkit-help.xml
Module Name: PSWmiToolKit
online version: https://github.com/JhonnyTerminus/PSWmiToolKit
schema: 2.0.0
---

# Get-WmiNamespace

## SYNOPSIS
This function is used to get WMI namespace information.

## SYNTAX

```
Get-WmiNamespace [-Namespace] <String[]> [-List] [-Recurse] [<CommonParameters>]
```

## DESCRIPTION
This function is used to get the details of one or more WMI namespaces.

## EXAMPLES

### EXAMPLE 1
```
Get-WmiNamespace -NameSpace 'ROOT\SCCM'
```

### EXAMPLE 2
```
Get-WmiNamespace -NameSpace 'ROOT\*CM'
```

### EXAMPLE 3
```
Get-WmiNamespace -NameSpace 'ROOT' -List
```

### EXAMPLE 4
```
Get-WmiNamespace -NameSpace 'ROOT' -Recurse
```

### EXAMPLE 5
```
'Root\SCCM', 'Root\SC*' | Get-WmiNamespace
```

## PARAMETERS

### -Namespace
Specifies the namespace(s) path(s).
Supports wildcards only when not using the -Recurse or -List switch.
Can be piped.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: True
```

### -List
This switch is used to list all namespaces in the specified path.
Cannot be used in conjunction with the -Recurse switch.

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

### -Recurse
This switch is used to get the whole WMI namespace tree recursively.
Cannot be used in conjunction with the -List switch.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable.
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.String[].

## OUTPUTS

### System.Management.Automation.PSCustomObject.
    'Name'
    'Path'
    'FullName'

## NOTES
This is a public module function and can typically be called directly.

## RELATED LINKS

[https://github.com/JhonnyTerminus/PSWmiToolKit](https://github.com/JhonnyTerminus/PSWmiToolKit)

[https://sccm-zone.com](https://sccm-zone.com)

