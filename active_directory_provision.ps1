$domainName = $args[0]
$password = ConvertTo-SecureString $args[1] -AsPlainText -Force
$credential = New-Object System.Management.Automation.PSCredential ("$domainName\Administrator", $password)
Install-WindowsFeature -name AD-Domain-Services -IncludeManagementTools
Install-ADDSForest -DomainName $domainName -SafeModeAdministratorPassword $credential -Force -Confirm:$false
Restart-Computer
