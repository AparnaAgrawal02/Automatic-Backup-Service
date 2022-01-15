$hourlyFolder = 'DmAarogya_hourly_backup' 
$dailyFolder = 'DmAarogya_daily_backup'  
$weeklyFolder = 'DmAarogya_weekly_backup'
$monthlyFolder = 'DmAarogya_monthly_backup'
$yearlyFolder = 'DmAarogya_yearly_backup'

$folderPath = "C:\DatabaseBackupService\"
$dataBasePath = "SQLSERVER:\SQL\YCC2008\SQLEXPRESS"
$dataBaseName = "DmAarogyanew"
$file = "dmAarogya_db_$(Get-Date -UFormat %Y%m%d%H%M).bak"
$filePath = Join-Path $folderPath "backups\$file"
$zipFilePath = Join-Path $folderPath "backups\$($file.Split(".")[0]).zip"
$zipFile = "$($file.Split(".")[0]).zip"

#created calender object ,used to get current date,day,time 
$calender = Get-Date
$uploadHour = "23"
$uploadDate = "01" 
$uploadMonth = "01"
$changeLogFileHour = "0"

