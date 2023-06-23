$ACCOUNT=$args[0]
$CONTAINER=$args[1]

$webClient = New-Object System.Net.WebClient
$scriptUrl = "http://{0}.blob.core.windows.net/{1}/scripts.zip" -f $ACCOUNT, $CONTAINER
$resourceUrl = "http://{0}.blob.core.windows.net/{1}/resources.zip" -f $ACCOUNT, $CONTAINER
$webClient.DownloadFile($scriptUrl, "C:\scripts.zip")
$webClient.DownloadFile($resourceUrl, "C:\resources.zip")
mkdir C:\vagrant
$shell = New-Object -ComObject Shell.Application
$zip = $shell.NameSpace('C:\scripts.zip')
$destination = $shell.NameSpace('C:\vagrant')
$destination.CopyHere($zip.Items(), 0x10)
$zip = $shell.NameSpace('C:\resources.zip')
$destination = $shell.NameSpace('C:\vagrant')
$destination.CopyHere($zip.Items(), 0x10)
rm C:\scripts.zip
rm C:\resources.zip

cmd.exe /c C:\vagrant\scripts\configs\enable-rdp.bat
cmd.exe /c C:\vagrant\scripts\configs\disable_firewall.bat

C:\vagrant\scripts\installs\install_dotnet45.ps1
C:\vagrant\scripts\installs\install_wmf.ps1
C:\vagrant\scripts\installs\chocolatey.ps1
echo n | cmd.exe /c C:\vagrant\scripts\installs\setup_iis.bat
echo n | cmd.exe /c C:\vagrant\scripts\installs\setup_snmp.bat

cmd.exe /c C:\vagrant\scripts\configs\disable-auto-logon.bat
cmd.exe /c C:\vagrant\scripts\chocolatey_installs\chocolatey-compatibility.bat
cmd.exe /c C:\vagrant\scripts\chocolatey_installs\boxstarter.bat
cmd.exe /c C:\vagrant\scripts\chocolatey_installs\7zip.bat
cmd.exe /c C:\vagrant\scripts\configs\apply_password_settings.bat
cmd.exe /c C:\vagrant\scripts\configs\create_users.bat
cmd.exe /c C:\vagrant\scripts\installs\setup_ftp_site.bat
cmd.exe /c C:\vagrant\scripts\chocolatey_installs\java.bat
cmd.exe /c C:\vagrant\scripts\chocolatey_installs\tomcat.bat
cmd.exe /c C:\vagrant\scripts\installs\setup_apache_struts.bat
cmd.exe /c C:\vagrant\scripts\installs\setup_glassfish.bat
cmd.exe /c C:\vagrant\scripts\installs\start_glassfish_service.bat
cmd.exe /c C:\vagrant\scripts\installs\setup_jenkins.bat
cmd.exe /c C:\vagrant\scripts\chocolatey_installs\vcredist2008.bat
cmd.exe /c C:\vagrant\scripts\installs\install_wamp.bat
cmd.exe /c C:\vagrant\scripts\installs\start_wamp.bat
cmd.exe /c C:\vagrant\scripts\installs\install_wordpress.bat
cmd.exe /c C:\vagrant\scripts\installs\install_openjdk6.bat
cmd.exe /c C:\vagrant\scripts\installs\setup_jmx.bat
cmd.exe /c C:\vagrant\scripts\chocolatey_installs\ruby.bat
cmd.exe /c C:\vagrant\scripts\installs\install_devkit.bat
cmd.exe /c C:\vagrant\scripts\installs\install_rails_server.bat
cmd.exe /c C:\vagrant\scripts\installs\setup_rails_server.bat
cmd.exe /c C:\vagrant\scripts\installs\install_rails_service.bat
cmd.exe /c C:\vagrant\scripts\installs\setup_webdav.bat
cmd.exe /c C:\vagrant\scripts\installs\setup_mysql.bat
cmd.exe /c C:\vagrant\scripts\installs\install_manageengine.bat
cmd.exe /c C:\vagrant\scripts\installs\setup_axis2.bat
cmd.exe /c C:\vagrant\scripts\installs\install_backdoors.bat
cmd.exe /c C:\vagrant\scripts\configs\configure_firewall.bat
cmd.exe /c C:\vagrant\scripts\installs\install_elasticsearch.bat
cmd.exe /c C:\vagrant\scripts\installs\install_flags.bat
cmd.exe /c C:\vagrant\scripts\configs\packer_cleanup.bat
