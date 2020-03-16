---
external help file: PSWmiToolKit-help.xml
Module Name: PSWmiToolKit
online version: https://sccm-zone.com
schema: 2.0.0
---

# Copy-WmiProperty

## SYNOPSIS
This function is used to copy the properties of a WMI class.

## SYNTAX

```
Copy-WmiProperty [-ClassPathSource] <String> [-ClassPathDestination] <String> [[-PropertyName] <String[]>]
 [-CreateDestination] [<CommonParameters>]
```

## DESCRIPTION
This function is used to copy the properties of a WMI class to another class.
Default qualifier flavors will be used.

## EXAMPLES

### EXAMPLE 1
```
Copy-WmiProperty -ClassPathSource 'ROOT\SCCM:SCCMZone' -ClassPathDestination 'ROOT\SCCM:SCCMZoneBlog' -CreateDestination
```

### EXAMPLE 2
```
Copy-WmiProperty -ClassPathSource 'ROOT\SCCM:SCCMZone' -ClassPathDestination 'ROOT\SCCM:SCCMZoneBlog' -PropertyName 'SCCMZoneWebSite' -CreateDestination
```

## PARAMETERS

### -ClassPathSource
Specifies the class to be copied from.

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

### -ClassPathDestination
Specifies the class to be copied to.

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
Specifies the property name or names to copy.
If this parameter is not specified all properties will be copied.(Optional)

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

### -CreateDestination
This switch is used to create the destination if it does not exist.
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

