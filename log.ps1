$calender = Get-Date
$TodayLogFile =$PSScriptRoot +"\log\"+$calender.dayofweek + ".txt"
#at 0 hour checks if todays files exits and deletes
if ($calender.hour -eq $changeLogFileHour){
    if (Test-Path -path $TodayLogFile) {
        Remove-Item $TodayLogFile
    }
}
Function Log {
    #parameter message
    param(
        [Parameter(Mandatory=$true)][String]$msg
    )
    #if file doesn't exits creates
    if (!(Test-Path -path $TodayLogFile)) {
        New-Item -Path $TodayLogFile -ItemType File
    }
    Add-Content $TodayLogFile $("$(Get-Date -UFormat %Y-%m-%d-%H-%M): "+ $msg)
}
Log "date: $($calender.day),Hour: $($calender.hour)"