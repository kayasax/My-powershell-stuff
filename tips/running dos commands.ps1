# running dos command with lengthy parameters may sometimes be difficult to run from powershell
# one easy step that may correct the problem is to call cmd.exe /c before calling the command :

# this will not work
# & c:\windows\handle.exe /accepteula .d1 > C:\upf\logs\backup\handle.txt

# this is OK
start-process -Wait -NoNewWindow  cmd.exe "/c handle.exe .d1 > C:\upf\logs\backup\handle.txt"

# starting at PS V3.0 we can also use the escape operator : --% ( will stop powershell resolving variables except cmd ones like %computername% )