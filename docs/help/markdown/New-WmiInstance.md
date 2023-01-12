---
external help file: PSWmiToolKit-help.xml
Module Name: PSWmiToolKit
online version: https://MEM.Zone/PSWmiToolKit
schema: 2.0.0
---

# New-WmiInstance

## SYNOPSIS

This function is used to create a WMI Instance.

## SYNTAX

```powershell
New-WmiInstance [[-Namespace] <String>] [-ClassName] <String> [[-Key] <String[]>] [-Property] <PSObject>
 [<CommonParameters>]
```

## DESCRIPTION

This function is used to create a WMI Instance using CIM.

## EXAMPLES

### EXAMPLE 1

```powershell
[hashtable]$Property = @{
    'ServerPort' = '89'
    'ServerIP' = '11.11.11.11'
    'Source' = 'File1'
    'Date' = $(Get-Date)
}
New-WmiInstance -Namespace 'ROOT' -ClassName 'MEMZone' -Key 'File1' -Property $Property
```

### EXAMPLE 2

```powershell
"Server Port = 89 `n ServerIp = 11.11.11.11 `n Source = File `n Date = $(GetDate)" | New-WmiInstance -Namespace 'ROOT' -ClassName 'MEMZone' -Property $Property
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

Specifies the class where to create the new WMI instance.

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

### -Key

Specifies properties that are used as keys (Optional).

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

### -Property

Specifies the class instance Properties or Values.
You can also specify a string but you must separate the name and value with a new line character (\`n).
This parameter can also be piped.

```yaml
Type: PSObject
Parameter Sets: (All)
Aliases:

Required: True
Position: 4
Default value: None
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
[MEM.Zone/GIT](https://MEM.Zone/GIT)
