---
external help file: PSWmiToolkit-help.xml
Module Name: PSWmiToolKit
online version: https://sccm-zone.com
schema: 2.0.0
---

# Remove-WmiNamespace

## SYNOPSIS
This function is used to delete a WMI namespace.

## SYNTAX

```
Remove-WmiNamespace [-Namespace] <String> [-Force] [-Recurse] [<CommonParameters>]
```

## DESCRIPTION
This function is used to delete a WMI namespace by name.

## EXAMPLES

### EXAMPLE 1
```
Remove-WmiNamespace -Namespace 'ROOT\SCCM' -Force -Recurse
```

## PARAMETERS

### -Namespace
Specifies the namespace to remove.

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

### -Force
This switch deletes all existing classes in the specified path.
Default is: $false.

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

### -Recurse
This switch deletes all existing child namespaces in the specified path.

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

## OUTPUTS

## NOTES
This is a module function and can typically be called directly.

## RELATED LINKS

[https://sccm-zone.com](https://sccm-zone.com)

[https://github.com/JhonnyTerminus/SCCM](https://github.com/JhonnyTerminus/SCCM)

