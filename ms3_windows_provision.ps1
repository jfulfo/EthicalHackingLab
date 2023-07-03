$ACCOUNT=$args[0]
$CONTAINER=$args[1]
$DOMAIN=$args[2]
$PASSWORD=$args[3]

# Download scripts and resources
$webClient = New-Object System.Net.WebClient
$scriptUrl = "http://{0}.blob.core.windows.net/{1}/scripts.zip" -f $ACCOUNT, $CONTAINER
$resourceUrl = "http://{0}.blob.core.windows.net/{1}/resources.zip" -f $ACCOUNT, $CONTAINER
$webClient.DownloadFile($scriptUrl, "C:\scripts.zip")
$webClient.DownloadFile($resourceUrl, "C:\resources.zip")
mkdir C:\vagrant
$shell = New-Object -ComObject Shell.Application
$zip = $shell.NameSpace("C:\scripts.zip")
$destination = $shell.NameSpace("C:\vagrant")
$destination.CopyHere($zip.Items(), 0x10)
$zip = $shell.NameSpace("C:\resources.zip")
$destination = $shell.NameSpace("C:\vagrant")
$destination.CopyHere($zip.Items(), 0x10)
rm C:\scripts.zip
rm C:\resources.zip

# Schedule task to run on startup
$scriptPath = "C:\vagrant\scripts\driver.ps1"
$taskName = "ms3WindowsProvision"
$taskRun = "powershell.exe -ExecutionPolicy Unrestricted -File $scriptPath '$DOMAIN' '$PASSWORD'"

schtasks /create /tn $taskName /tr $taskRun /sc ONSTART /ru System

# Run script 
powershell.exe -ExecutionPolicy Unrestricted -File $scriptPath
