---
external help file: PSWmiToolkit-help.xml
Module Name: PSWmiToolKit
online version: https://sccm-zone.com
schema: 2.0.0
---

# Copy-WmiInstance

## SYNOPSIS
This function is used to copy the instances of a WMI class.

## SYNTAX

```
Copy-WmiInstance [-ClassPathSource] <String> [-ClassPathDestination] <String> [[-Property] <Hashtable>]
 [-MatchAll] [-CreateDestination] [<CommonParameters>]
```

## DESCRIPTION
This function is used to copy the instances of a WMI class to another class.

## EXAMPLES

### EXAMPLE 1
```
Copy-WmiInstance -ClassPathSource 'ROOT\SCCM:SCCMZone' -ClassPathDestination 'ROOT\SCCM:SCCMZoneBlog' -CreateDestination
```

### EXAMPLE 2
```
[hashtable]$Property = @{ Description = 'SCCMZone WebSite' }
```

Copy-WmiInstance -ClassPathSource 'ROOT\SCCM:SCCMZone' -ClassPathDestination 'ROOT\SCCM:SCCMZoneBlog' -Property $Property -CreateDestination

### EXAMPLE 3
```
[hashtable]$Property = @{
```

SCCMZoneWebSite = 'https:\SCCM-Zone.com'
    Description = 'SCCMZone WebSite'
}
Copy-WmiInstance -ClassPathSource 'ROOT\SCCM:SCCMZone' -ClassPathDestination 'ROOT\SCCM:SCCMZoneBlog'  -Property $Property -MatchAll -CreateDestination

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

### -Property
Specifies the instance property to copy.
If this parameter is not specified all instances are copied.(Optional)

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

### -MatchAll
This switch is used to specify wether to match all or any of the specified instance properties.
If this switch is specified you must enter all data
present in the desired source class instance in order to have a succesfull match.
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
This switch is used to create the destination if it does not exist.
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
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES
This is a module function and can typically be called directly.

## RELATED LINKS

[https://sccm-zone.com](https://sccm-zone.com)

[https://github.com/JhonnyTerminus/SCCM](https://github.com/JhonnyTerminus/SCCM)

