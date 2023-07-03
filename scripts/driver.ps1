$DOMAIN=$args[0]
$PASSWORD=$args[1]
$statePath = "C:\state.txt"
if (!(Test-Path $statePath)) {
    New-Item $statePath -ItemType file -Force
    Set-Content $statePath "0"
}
$state = Get-Content $statePath
switch ($state) {
    "0" {
        cmd.exe /c C:\vagrant\scripts\configs\enable-rdp.bat
        cmd.exe /c C:\vagrant\scripts\configs\disable_firewall.bat
    }
    "1" {
        C:\vagrant\scripts\installs\install_dotnet45.ps1
    }
    "2" {
        C:\vagrant\scripts\installs\install_wmf.ps1
    }
    "3" {
        C:\vagrant\scripts\installs\chocolatey.ps1
    }
    "4" {
        echo n | cmd.exe /c C:\vagrant\scripts\installs\setup_iis.bat
        echo n | cmd.exe /c C:\vagrant\scripts\installs\setup_snmp.bat
    }
    "5" {
        cmd.exe /c C:\vagrant\scripts\configs\disable-auto-logon.bat
        cmd.exe /c C:\vagrant\scripts\chocolatey_installs\chocolatey-compatibility.bat
        cmd.exe /c C:\vagrant\scripts\chocolatey_installs\boxstarter.bat
        cmd.exe /c C:\vagrant\scripts\chocolatey_installs\7zip.bat
        cmd.exe /c C:\vagrant\scripts\configs\apply_password_settings.bat
        cmd.exe /c C:\vagrant\scripts\configs\create_users.bat
        cmd.exe /c C:\vagrant\scripts\installs\setup_ftp_site.bat
        cmd.exe /c C:\vagrant\scripts\chocolatey_installs\java.bat
    }
    "6" {
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
    }
    "7" {
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
    }
    "8" {
        $secpasswd = ConvertTo-SecureString $PASSWORD -AsPlainText -Force
        $mycreds = New-Object System.Management.Automation.PSCredential ($DOMAIN, $secpasswd)
        Add-Computer -DomainName $DOMAIN -Credential $mycreds -Restart -Force
    }
    default {
        echo "No more steps to run"
    }
}

$state = [int]$state + 1 
Set-Content $statePath $state 

if ($state -lt 9) {
    Restart-Computer -Force
}

