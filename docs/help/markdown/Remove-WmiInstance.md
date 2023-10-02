---
external help file: PSWmiToolKit-help.xml
Module Name: PSWmiToolKit
online version: https://MEMZ.one/PSWmiToolKit
schema: 2.0.0
---

# Remove-WmiInstance

## SYNOPSIS

This function is used to remove one ore more WMI instances.

## SYNTAX

```powershell
Remove-WmiInstance [[-Namespace] <String>] [-ClassName] <String> [[-Property] <Hashtable>] [-RemoveAll]
 [<CommonParameters>]
```

## DESCRIPTION

This function is used to remove one ore more WMI class instances with the specified values using CIM.

## EXAMPLES

### EXAMPLE 1

```powershell
[hashtable]$Property = @{
    'ServerPort' = '80'
    'ServerIP' = '10.10.10.11'
}
Remove-WmiInstance -Namespace 'ROOT' -ClassName 'MEMZone' -Property $Property -RemoveAll
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

Specifies the class name from which to remove the instances.

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

The class instance property to match.
Can be piped.
If there is more than one matching instance and the RemoveAll switch is not specified, an error will be thrown.

```yaml
Type: Hashtable
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -RemoveAll

Removes all matching or existing instances.

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
[PSWmiToolKit](https://MEMZ.one/PSWmiToolKit)
[PSWmiToolKit-ISSUES](https://MEMZ.one/PSWmiToolKit-ISSUES)
