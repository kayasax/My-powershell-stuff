# Loïc MICHEL 14/10/2013
# Importer les tâches planifiées à partir de leur définition xml (depuis le planificateur de tâche : clic droit/ exporter)
# les tâches seront nommées d'après le nom des fichiers (sans l'extension .xml)


#variables à modifier
$source="c:\temp\tasks" # répertoire contenant les .xml des tâches
$taskFolder="\SMAC" # Sous dossier du planificateur

# Début du programme
$cred=Get-Credential groupe\sys-mac-smacsr -message "Indiquer le mot de passe SVP" 

# Connexion au service planificateur de tâches
$sch = New-Object -ComObject("Schedule.Service")
$sch.connect("localhost")
$root=$sch.GetFolder("\")
$root.CreateFolder("$taskFolder")
$folder =$sch.GetFolder("\$taskFolder") 
  	
#import .xml
Get-childItem -path $source -Filter *.xml | %{  # on va lire chaque fichier xml du dossuer source
	$task_name = $_.Name.Replace('.xml', '') # nom de la tache crée à partir du nom de fichier
	$task_xml = Get-Content $_.FullName
	$task = $sch.NewTask($null) 
	$task.XmlText = $task_xml
	$folder.RegisterTaskDefinition($task_name, $task, 6, $cred.UserName, $cred.GetNetworkCredential().password, 1, $null)
}

# Si besoin fonction d'export
#$folder.getTasks(0) | % {
#    $path="$($source)\$($_.name).xml"
#    $x=New-Item -ItemType file -Path $path
#    Set-Content -Path $path -Value $_.xml
#}
	