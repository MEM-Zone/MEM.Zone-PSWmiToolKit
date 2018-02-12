---
external help file: PSWmiToolkit-help.xml
Module Name: PSWmiToolKit
online version: https://sccm-zone.com
schema: 2.0.0
---

# Get-WmiProperty

## SYNOPSIS
This function is used to get the properties of a WMI class.

## SYNTAX

```
Get-WmiProperty [[-Namespace] <String>] [-ClassName] <String> [[-PropertyName] <String>]
 [[-PropertyValue] <String>] [[-QualifierName] <String>] [[-Property] <PSObject>] [<CommonParameters>]
```

## DESCRIPTION
This function is used to get one or more properties of a WMI class.

## EXAMPLES

### EXAMPLE 1
```
Get-WmiProperty -Namespace 'ROOT' -ClassName 'SCCMZone'
```

### EXAMPLE 2
```
Get-WmiProperty -Namespace 'ROOT' -ClassName 'SCCMZone' -PropertyName 'WebsiteSite' -QualifierName 'key'
```

### EXAMPLE 3
```
Get-WmiProperty -Namespace 'ROOT' -ClassName 'SCCMZone' -PropertyName '*Site'
```

### EXAMPLE 4
```
$Property = [PSCustomobject]@{
```

'Name' = 'Website'
    'Value' = $null
    'CimType' = 'String'
}
Get-WmiProperty -Namespace 'ROOT' -ClassName 'SCCMZone' -Property $Property
$Property | Get-WmiProperty -Namespace 'ROOT' -ClassName 'SCCMZone'

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
Specifies the class name for which to get the properties.

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

### -PropertyName
Specifies the propery name to search for.
Supports wildcards.
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

### -PropertyValue
Specifies the propery value or values to search for.
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

### -QualifierName
Specifies the property qualifier name to match.
Supports wildcards.(Optional)

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 5
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Property
Matches property Name, Value and CimType.
Can be piped.
If this parameter is specified all other search parameters will be ignored.(Optional)
Supported format:
    \[PSCustomobject\]@{
        'Name' = 'Website'
        'Value' = $null
        'CimType' = 'String'
    }

```yaml
Type: PSObject
Parameter Sets: (All)
Aliases:

Required: False
Position: 6
Default value: @()
Accept pipeline input: True (ByValue)
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

