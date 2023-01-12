---
external help file: PSWmiToolKit-help.xml
Module Name: PSWmiToolKit
online version: https://MEM.Zone/PSWmiToolKit
schema: 2.0.0
---

# Copy-WmiClass

## SYNOPSIS

This function is used to copy a WMI class.

## SYNTAX

```powershell
Copy-WmiClass [-NamespaceSource] <String> [-NamespaceDestination] <String> [[-ClassName] <String[]>] [-Force]
 [-CreateDestination] [<CommonParameters>]
```

## DESCRIPTION

This function is used to copy a WMI class to another namespace.

## EXAMPLES

### EXAMPLE 1

```powershell
Copy-WmiClass -ClassName 'MEMZone' -NamespaceSource 'ROOT\ConfigMgr' -NamespaceDestination 'ROOT\Blog' -CreateDestination
```

### EXAMPLE 2

```powershell
Copy-WmiClass -NamespaceSource 'ROOT\ConfigMgr' -NamespaceDestination 'ROOT\Blog' -CreateDestination
```

## PARAMETERS

### -NamespaceSource

Specifies the source namespace.

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

Specifies the destinaiton namespace.

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

### -ClassName

Specifies the class name or names to copy.
If this parameter is not specified all classes will be copied.(Optional)

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Force

This switch is used to overwrite the destination class if it already exists.
Default is: $false.

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

### -CreateDestination

This switch is used to create the destination namespace if it does not exist.
Default is: $false.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: 5
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
