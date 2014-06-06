<# 
 .Author Loic MICHEL 05/06/2014
 .Synopsis
  Nettoyage des archives de sauvegardes des sites internet

 .Description
  le script permet de ne conserver que les 3 versions les plus récentes des archives

 .Notes
 	
#>

[CmdletBinding()]
Param()

# GENERATION D'UNE TRACE POUR DEBUGGAGE
#########################################
$erroractionPreference="stop" #toutes les erreurs seront bloquantes
$trace="D:\exploitation\logs\trace_backup_site.txt"
try{stop-transcript -ea silentlycontinue }catch{} #suppression d'une éventuelle trace antérieure
start-transcript -path $trace

# VARIABLES PRIVEES
#####################
$_scriptname=$MyInvocation.myCommand.definition
$_enc=[system.text.encoding]::UTF8 #encoding à utiliser pour le mail

#    *** !!  VARIABLES A MODIFIER  !! ***
###########################################
$source="D:\exploitation\backup sites internet" #répertoire de base des sauvegardes SQL
$destination="D:\exploitation\backup sites internet\archives" #destination de la sauvegarde
$logdir="D:\exploitation\logs"
$description="Archivage des backups des sites internet" #la description sera réutilisée dans les messages logs et mails
$message="Erreur : $description ($_scriptname)" #sujet des mails
$from="$env:computername@groupe.sa.colas.com" #expediteur pour mail
$to="michel@smac-sa.com","smac@smac-sa.com" #
$PSEmailServer="smtpinterne.groupe.sa.colas.com" #adresse du serveur smtp

# DEBUT DU SCRIPT
#################
get-date
"`tDébut du script"


try{
  #on déplace le dernier backup 
  ls "$source\backup smac\*.gz" | %{ move  $_.fullname $destination\.}
  
  #on enregistre le nom des 3 fichiers .gz les plus récents
  $keep=ls *.gz |sort lastwritetime -desc | select -expand fullname  | select -first 3
  
  #on supprime les .gz qui ne sont pas à conserver
  ls *.gz | ?{ $_.fullname -notin $keep} |remove-item
}
catch{ # Gestion des erreurs blocantes
	write-host "Une erreur est survenue !"
	$_
	copy-item $trace $logdir\trace2.txt -force
	
	$msg=$message + $($_.Exception.Message)
	Write-EventLog application -EntryType error -Source SMACINFO -eventID 1 -Message $msg
	send-mailmessage  -encoding $_enc -subject $message -bodyasHTML  "$($_.Exception.toString() )<br/> " -to $to -from $from -attachments $logdir\trace2.txt
	$?
	stop-transcript
	break
}

get-date
"Fin normale du script"
stop-transcript

