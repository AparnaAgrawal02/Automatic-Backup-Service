#used sendgrid api to send email
function Send-Email     #parameters to,subject,value
{   [CmdletBinding()]
    #parameters
    param (
        [ValidateNotNullOrEmpty()]
        [Parameter(Mandatory)]
        [string]$to,

        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]$subject,
    
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]$value
    )

    $Body = @{
        "personalizations" = @(
            @{
                "to" = @(
                    @{
                        "email" = $to
                    }
                )
            }
        )
        "subject"          = $subject
        "content"          = @(
            @{
                "type"  = "text/plain"
                "value" = $value
            }
        )
        "from"             = @{
            "email" = $dataAdminMail
        }
    }

    $BodyJson = $Body | ConvertTo-Json -Depth 4

    $Header = @{
        "authorization" = $sendgridauth
    }
    Log "Called send-Email Function"
    $Parameters = @{
        Method      = "POST"
        Uri         = "https://api.sendgrid.com/v3/mail/send"
        Headers     = $Header
        ContentType = "application/json"
        Body        = $BodyJson
    }
    try{
        Log "Invoked RestMethod to send email"
        Invoke-RestMethod @Parameters
    } catch {
        Log $_
        exit
    }
    Log "Successful send email"
}
