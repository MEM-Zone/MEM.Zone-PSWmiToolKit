---
external help file: PSWmiToolKit-help.xml
Module Name: PSWmiToolKit
online version: https://MEM.Zone/PSWmiToolKit
schema: 2.0.0
---

# Set-WmiClassQualifier

## SYNOPSIS

This function is used to set qualifiers to a WMI class.

## SYNTAX

```powershell
Set-WmiClassQualifier [[-Namespace] <String>] [-ClassName] <String> [[-Qualifier] <PSObject>]
 [<CommonParameters>]
```

## DESCRIPTION

This function is used to set qualifiers to a WMI class. Existing qualifiers with the same name will be overwriten

## EXAMPLES

### EXAMPLE 1

```powershell
Set-WmiClassQualifier -Namespace 'ROOT' -ClassName 'MEMZone' -Qualifier @{ Name = 'Description'; Value = 'MEM.Zone Blog' }
```

### EXAMPLE 2

```powershell
Set-WmiClassQualifier -Namespace 'ROOT' -ClassName 'MEMZone' -Qualifier "Name = Description `n Value = MEM.Zone Blog"
```

### EXAMPLE 3

```powershell
"Name = Description `n Value = MEM.Zone Blog" | Set-WmiClassQualifier -Namespace 'ROOT' -ClassName 'MEMZone'
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

Specifies the class name for which to add the qualifiers.

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

### -Qualifier

Specifies the qualifier name, value and flavours as hashtable.
You can omit this parameter or enter one or more items in the hashtable.
You can also specify a string but you must separate the name and value with a new line character (\`n).
This parameter can also be piped.
If you omit a hashtable item the default item value will be used.
Only item values can be specified (right of the '=' sign).
Default is:

```powershell
    [hashtable][ordered]@{
        Name = 'Static'
        Value = $true
        IsAmended = $false
        PropagatesToInstance = $true
        PropagatesToSubClass = $false
        IsOverridable = $true
    }
```

```yaml
Type: PSObject
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: @()
Accept pipeline input: True (ByValue)
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
