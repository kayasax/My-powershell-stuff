# get lastbootuptime of all workstations from a particular site

[CmdletBinding()] #make script react as cmdlet (-verbose etc..)
	param(
		[Parameter(Position=0, Mandatory=$true,ValueFromPipeline = $true, HelpMessage='Indiquer le nom du site à scanner ex : MRIDF')]
		[ValidateNotNullOrEmpty()]
		[System.String]
		$site
	)

write-host "Récupération des adresses depuis le serveur DHCP RODC-$site" -foreground magenta
$ordis=dhcp rodc-$site|select -expand computername
write-host "Interrogation dernier démarrage" -foreground magenta
try{
gwmi "Win32_OperatingSystem" -ComputerName $ordis -asjob  -ea silentlycontinue
$resu=get-job | ? {$_.psjobtypename -eq "wmijob" } |wait-job |receive-job}
catch{"error"}
$resu | select PSCOMPUTERNAME, @{name="lastboottime";expression={$_.converttodatetime($_.lastbootuptime)}} |sort lastboottime |ft
	
	remove-job * -force