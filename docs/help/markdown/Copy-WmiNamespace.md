---
external help file: PSWmiToolKit-help.xml
Module Name: PSWmiToolKit
online version: https://MEM.Zone/PSWmiToolKit
schema: 2.0.0
---

# Copy-WmiNamespace

## SYNOPSIS

This function is used to copy a WMI namespace.

## SYNTAX

```powershell
Copy-WmiNamespace [-NamespaceSource] <String> [-NamespaceDestination] <String> [-Force] [<CommonParameters>]
```

## DESCRIPTION

This function is used to copy a WMI namespace to another namespace.
.

## EXAMPLES

### EXAMPLE 1

```powershell
Copy-WmiNamespace -NamespaceSource 'ROOT\MEMZone' -NamespaceDestination 'ROOT\cimv2' -Force
```

### EXAMPLE 2

```powershell
Copy-WmiNamespace -NamespaceSource 'ROOT\MEMZone' -NamespaceDestination 'ROOT\cimv2' -ErrorAction 'SilentlyContinue'
```

## PARAMETERS

### -NamespaceSource

Specifies the source namespace to copy.

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

### -NamespaceDestination

Specifies the destination namespace.

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

### -Force

This switch is used to overwrite the destination namespace.

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
[PSWmiToolKit](https://MEM.Zone/PSWmiToolKit)
[PSWmiToolKit-ISSUES](https://MEM.Zone/PSWmiToolKit-ISSUES)
