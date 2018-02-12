---
external help file: PSWmiToolkit-help.xml
Module Name: PSWmiToolKit
online version: https://sccm-zone.com
schema: 2.0.0
---

# Get-WmiInstance

## SYNOPSIS
This function is used get the values of an WMI instance.

## SYNTAX

```
Get-WmiInstance [[-Namespace] <String>] [-ClassName] <String> [[-Property] <Hashtable>] [-KeyOnly]
 [<CommonParameters>]
```

## DESCRIPTION
This function is used find a WMI instance by comparing properties.
It will return the the instance where all specified properties match.

## EXAMPLES

### EXAMPLE 1
```
[hashtable]$Property = @{
```

'ServerPort' = '80'
    'ServerIP' = '10.10.10.11'
    'Source' = 'SCCMZone Blog'
}
Get-WmiInstance -Namespace 'ROOT' -ClassName 'SCCMZone' -Property $Property

### EXAMPLE 2
```
Get-WmiInstance -Namespace 'ROOT' -ClassName 'SCCMZone' -Property @{ 'Source' = 'SCCMZone Blog' } -KeyOnly
```

### EXAMPLE 3
```
Get-WmiInstance -Namespace 'ROOT' -ClassName 'SCCMZone'
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
Specifies the class name for which to get the instance properties.

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

### -Property
Specifies the class instance properties and values to find.

```yaml
Type: Hashtable
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -KeyOnly
Indicates that only objects with key properties populated are returned.

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
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES
This is a module function and can typically be called directly.

## RELATED LINKS

[https://sccm-zone.com](https://sccm-zone.com)

[https://github.com/JhonnyTerminus/SCCM](https://github.com/JhonnyTerminus/SCCM)

