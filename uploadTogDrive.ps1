#function to upload backup zipfile to corresponding folder considering date,day and time.
#rotates hourly and weekly backups and stores monthly and yearly backups 
function UploadTODrive
{   #parameter zipFilePath
    [CmdletBinding()]
    param (
        [ValidateNotNullOrEmpty()]
        [Parameter(Mandatory)]
        [string]$zipFilePath
    )
    try
    {   Log "Called UploadToDrive Function"
        (Get-PSProvider 'SqlServer').Home = $folderPath
        #gets folder id of hourly folder from gdrive,creates if not present
        $hourlyFolderId = Get-FolderId -folderName $hourlyFolder
        
        #gets folder id of daily folder from gdrive,creates if not present
        $dailyFolderId = Get-FolderId -folderName $dailyFolder

        #gets folder id of weekly folder from gdrive,creates if not present
        $weeklyFolderId = Get-FolderId -folderName $weeklyFolder

        #gets folder id of monthly folder from gdrive,creates if not present
        $monthlyFolderId = Get-FolderId -folderName $monthlyFolder

        #gets folder id of monthly folder from gdrive,creates if not present
        $yearlyFolderId = Get-FolderId -folderName $yearlyFolder

        Log "got Folderid of each folder from google drive"
        #-------------------------------------hourly backup--------------------------------------------------------------------
        Log "-----------------hourly Backup----------------"
        #initialized hourFileName according to current time
        $hourFileName = $dataBaseName + '_db_' + $calender.hour + '.zip'
        #uploads $zipFilePath to dailyFolderId  with default retry count 10
        Start-GSDriveFileUpload -Path $zipFilePath -Wait -Parents $hourlyFolderId
        Log "uploaded zipfile to Gdrive"
        # gets id of currently uploaded file
        $newFileId = $(Get-GSDriveFileList -Fields @('files(id, name)')-ParentFolderId "$hourlyFolderId" -Filter @("name = '$zipFile'"))[0].id
        Log "got the id of newly uploded file"
        #gets the list of files named $hourFileName 
        $list = Get-GSDriveFileList -Fields @('files(id, name)')-ParentFolderId "$hourlyFolderId" -Filter @("name = '$hourFileName'")
        #if list is not empty remove that file
        if ($list -ne $null)
        {
            $oldFileId = $list[0].id
            Write-Output "Y" | powershell "Remove-GSDriveFile -FileId $oldFileId"
        }
        Log "found oldid of same hour if exit and deleted"
        #updates the name of currently added file to $hourFileName
        Update-GSDriveFile -FileId $newFileId -Name $hourFileName
        Log "updated name of hourfile"

        #-----------------------------------daily backup--------------------------------------------------------------------
        if ($calender.hour -eq $uploadHour)
        {   Log "-----------------daily Backup----------------"
            #initialized weekFileName according to current day
            $dayFileName = $dataBaseName + '_db_' + $calender.dayofweek + '.zip'
            #gets the list of files named $weekFileName 
            $list = Get-GSDriveFileList -Fields @('files(id, name)')-ParentFolderId "$dailyFolderID" -Filter @("name = '$dayFileName'")
            #if list is not empty remove that file
            if ($list -ne $null)
            {
                $oldFileId = $list[0].id
                Write-Output "Y" | powershell "Remove-GSDriveFile -FileId $oldFileId"
            }
            Log "found oldid of same day if exit and deleted"
            #copies the file uploaded to dailyFolder to weeklyFolder and rename
            Copy-GSDriveFile -FileID $newFileId -Name $dayFileName -Parents "$dailyFolderId" 
            Log "copied file from hour folder to dailyfolder and renamed"
        }
        #-----------------------------------weekly backup--------------------------------------------------------------------
        if ($($calender.day)%7 -eq "1")
        {   Log "-----------------Weekly Backup----------------"
            #initialized weekFileName according to current day
            $weekFileName = $dataBaseName + '_db_' + $calender.day  + '.zip'
            #gets the list of files named $weekFileName 
            $list = Get-GSDriveFileList -Fields @('files(id, name)')-ParentFolderId "$weeklyFolderID" -Filter @("name = '$weekFileName'")
            #if list is not empty remove that file
            if ($list -ne $null)
            {
                $oldFileId = $list[0].id
                Write-Output "Y" | powershell "Remove-GSDriveFile -FileId $oldFileId"
            }
            Log "found oldid of same week if exit and deleted"
            #copies the file uploaded to dailyFolder to weeklyFolder and rename
            Copy-GSDriveFile -FileID $newFileId -Name $weekFileName -Parents "$weeklyFolderId" 
            Log "copied file from hour folder to weekly folder and renamed"
        }

        #-----------------------------------monthly backup--------------------------------------------------------------------
        if ($calender.day -eq $uploadDate -And $calender.hour -eq $uploadHour)
        {   Log "-----------------monthly Backup----------------"
            $monthFileName = $dataBaseName + '_db_' + $calender.month + $calender.year + '.zip'  
            #copies the file uploaded to dailyFolder to monthlyFolder and rename
            Copy-GSDriveFile -FileID $newFileId -Name $monthFileName -Parents "$monthlyFolderId"
            Log "copied file from hour folder to monthly folder and renamed"
        }
        #-----------------------------------yearly backup--------------------------------------------------------------------
        if ($calender.month -eq $uploadMonth -And $calender.day -eq $uploadDate -And $calender.hour -eq $uploadHour )
        {    Log "-----------------yearly Backup----------------"
            $yearFileName = $dataBaseName + '_db_' + $calender.year + '.zip'
            #copies the file uploaded to dailyFolder to yearlyFolder and rename
            Copy-GSDriveFile -FileID $newFileId -Name $yearFileName -Parents "$yearlyFolderId"
            Log "copied file from hour folder to yearly folder and renamed"

        }
        #removes zipfile 
        Remove-Item $zipFilePath
        Log "Removed zipfile from computer"
        Log "Successfully Uploaded"
        #confirmation email for successful upload
        Send-Email -to $email -subject "[DmAarogya BackupService] Backup Successfull" -value "successfully uploaded to gdrive"
        Send-Email -to $email2 -subject "[DmAarogya BackupService] Backup Successfull" -value "successfully uploaded to gdrive"
    }
    catch
    {
        Send-Email -to $email -subject "[DmAarogya BackupService] Upload Unsuccessfull" -value $_
        Send-Email -to $email2 -subject "[DmAarogya BackupService] Upload Unsuccessfull" -value $_
        Log $_
        exit
    }
}