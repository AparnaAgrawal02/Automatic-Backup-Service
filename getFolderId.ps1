#gets folder id of  folder from gdrive,creates if not present
function Get-FolderId
{   #parameter folderName
    [CmdletBinding()]
    param (
        [ValidateNotNullOrEmpty()]
        [Parameter(Mandatory)]
        [string]$FolderName
    )
    #Log "Called Get-Folder Function"
    #gets list of  folder having name folderName
    $FolderList = Get-GSDriveFileList -Fields @('files(id, name)')-Filter @("name = '$FolderName'")
    #create folder of not present
    if ($FolderList -eq $null)
        {  
            #New-GSDriveFile -Name "$FolderName"-MimeType DriveFolder
            $FolderList = Get-GSDriveFileList -Fields @('files(id, name)')-Filter @("name = '$FolderName'")
        }
        return $FolderList[0].id

}