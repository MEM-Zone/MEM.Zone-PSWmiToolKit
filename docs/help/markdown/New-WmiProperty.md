---
external help file: PSWmiToolKit-help.xml
Module Name: PSWmiToolKit
online version: https://sccm-zone.com
schema: 2.0.0
---

# New-WmiProperty

## SYNOPSIS
This function is used to add properties to a WMI class.

## SYNTAX

```
New-WmiProperty [[-Namespace] <String>] [-ClassName] <String> [-PropertyName] <String> [-PropertyType] <String>
 [[-Qualifiers] <PSObject>] [<CommonParameters>]
```

## DESCRIPTION
This function is used to add custom properties to a WMI class.

## EXAMPLES

### EXAMPLE 1
```
[hashtable]$Qualifiers = @{
```

Key = $true
    Static = $true
    Description = 'SCCMZone Blog'
}
New-WmiProperty -Namespace 'ROOT\SCCM' -ClassName 'SCCMZone' -PropertyName 'Website' -PropertyType 'String' -Qualifiers $Qualifiers

### EXAMPLE 2
```
"Key = $true `n Description = SCCMZone Blog" | New-WmiProperty -Namespace 'ROOT\SCCM' -ClassName 'SCCMZone' -PropertyName 'Website' -PropertyType 'String'
```

## PARAMETERS

### -Namespace
Specifies the namespace where to search for the WMI namespace.
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
Specifies the class name for which to add the properties.

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
Specifies the property name.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -PropertyType
Specifies the property type.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 4
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Qualifiers
Specifies one ore more property qualifiers using qualifier name and value only.
You can omit this parameter or enter one or more items in the hashtable.
You can also specify a string but you must separate the name and value with a new line character (\`n).
This parameter can also be piped.
The qualifiers will be added with these default flavors:
    IsAmended = $false
    PropagatesToInstance = $true
    PropagatesToSubClass = $false
    IsOverridable = $true

```yaml
Type: PSObject
Parameter Sets: (All)
Aliases:

Required: False
Position: 5
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

