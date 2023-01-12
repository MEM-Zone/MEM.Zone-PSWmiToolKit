---
external help file: PSWmiToolKit-help.xml
Module Name: PSWmiToolKit
online version: https://MEM.Zone/PSWmiToolKit
schema: 2.0.0
---

# Get-WmiNamespace

## SYNOPSIS

This function is used to get WMI namespace information.

## SYNTAX

```powershell
Get-WmiNamespace [-Namespace] <String[]> [-List] [-Recurse] [<CommonParameters>]
```

## DESCRIPTION

This function is used to get the details of one or more WMI namespaces.

## EXAMPLES

### EXAMPLE 1

```powershell
Get-WmiNamespace -NameSpace 'ROOT\ConfigMgr'
```

### EXAMPLE 2

```powershell
Get-WmiNamespace -NameSpace 'ROOT\*Mgr'
```

### EXAMPLE 3

```powershell
Get-WmiNamespace -NameSpace 'ROOT' -List
```

### EXAMPLE 4

```powershell
Get-WmiNamespace -NameSpace 'ROOT' -Recurse
```

### EXAMPLE 5

```powershell
'Root\SCCM', 'Root\Conf*' | Get-WmiNamespace
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
For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

System.String[].

## OUTPUTS

System.Management.Automation.PSCustomObject.
'Name'
'Path'
'FullName'

## NOTES

This is a public module function and can typically be called directly.

## RELATED LINKS

[MEM.Zone](https://MEM.Zone)
[MEM.Zone/GIT](https://MEM.Zone/GIT)
