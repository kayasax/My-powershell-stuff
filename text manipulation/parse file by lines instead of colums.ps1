<#
PARSING (log) files.
when log files contains several colums on the same line we can use importfrom-csv
but how to do when log files is organized 'by lines' ?
example 

Name: ENC1
IPv4 Address: 172.16.2.101
Link Settings: Forced, 100 Mbit, Full Duplex
Name: ENC2
IPv4 Address: 172.16.2.103
Link Settings: Forced, 100 Mbit, Full Duplex
 
#>

$data = (@'
Name: ENC1
 IPv4 Address: 172.16.2.101
 Link Settings: Forced, 100 Mbit, Full Duplex
 Name: ENC2
 IPv4 Address: 172.16.2.103
 Link Settings: Forced, 100 Mbit, Full Duplex
 Name: ENC3
 IPv4 Address: 172.16.2.103
 Link Settings: Forced, 100 Mbps, Full Duplex
 Name: ENC4
 IPv4 Address: 172.16.2.104
 Link Settings: Forced, 100 Mbps, Full Duplex
'@).split("`n") |
foreach {$_.trim()}

Switch -Regex ($data) 
{
 '^Name: (.+)' {$obj = [PSCustomObject]@{Name=$Matches[1];IP=$null;Settings=$null}}
 '^IPv4 Address: (.+)' {$obj.IP = $matches[1]}
 '^Link Settings: (.+)' {$obj.Settings = $Matches[1]$obj}
}

