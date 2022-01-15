#fuction to take backup and then compress to zipfile
function Backup{
    try
    {   Log "Called  Backup Function"
        #took backup of database and stored it at $filePath
        Backup-SqlDatabase -Path $dataBasePath -Database $dataBaseName -BackupFile $filePath
        Log "Backup Successfull"
        # created zipfile from backup file
        $compress = @{
            Path             = $filePath
            CompressionLevel = "Optimal"
            DestinationPath  = $zipFilePath
        }
        Compress-Archive @compress
        Log "created compressed zipfile"
        #deleted .bak file
        Remove-Item $filePath
        Log "Removed .bak file"
    }
    catch
    {   Log $_
        Send-Email -to $email -subject "[DmAarogya BackupService] Backup Unsuccessful" -value $_
       # Send-Email -to $email2 -subject "[DmAarogya BackupService] Backup Unsuccessful" -value $_
        exit
    }
}