---
external help file: PSWmiToolKit-help.xml
Module Name: PSWmiToolKit
online version: https://MEM.Zone/PSWmiToolKit
schema: 2.0.0
---

# Remove-WmiProperty

## SYNOPSIS

This function is used to remove WMI class properties.

## SYNTAX

```powershell
Remove-WmiProperty [[-Namespace] <String>] [-ClassName] <String> [[-PropertyName] <String[]>] [-RemoveAll]
 [-Force] [<CommonParameters>]
```

## DESCRIPTION

This function is used to remove WMI class properties by name.

## EXAMPLES

### EXAMPLE 1

```powershell
Remove-WmiProperty -Namespace 'ROOT' -ClassName 'MEMZone' -Property 'MEMZone','Blog'
```

### EXAMPLE 2

```powershell
Remove-WmiProperty -Namespace 'ROOT' -ClassName 'MEMZone' -RemoveAll -Force
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

Specifies the class name for which to remove the properties.

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

Specifies the class property name or names to remove.

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

### -RemoveAll

This switch is used to remove all properties.
Default is: $false.
If this switch is specified the Property parameter is ignored.

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

### -Force

This switch is used to remove all instances.
The class must be empty in order to be able to delete properties.
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
