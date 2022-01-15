Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope LocalMachine
Import-Module SQLPS 
Install-Module -Name PSSendGrid -Scope CurrentUser
Install-Module -Name PSGSuite -Scope CurrentUser -Force
Set-PSGSuiteConfig -ConfigName MyConfig -SetAsDefaultConfig -ClientSecretsPath $clientSecretsPath -AdminEmail $dataAdminMail 
Get-GSGmailProfile -Verbose
