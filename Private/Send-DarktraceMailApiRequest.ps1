function Send-DarktraceMailApiRequest {

    [CmdletBinding()]
    Param (
        [Parameter(Position = 0)]
        [Microsoft.PowerShell.Commands.WebRequestMethod]
        $Method = 'Get',

        [Parameter(
            Mandatory = $true,
            Position = 1
        )]
        [string]
        $endpoint,

        [Parameter(Position = 3)]
        [System.Object]
        $Body
    )
    Begin {
        
    }
    Process {
        If (-not ($_DarktraceMailToken -and $_DarktraceMailURL)) {
            throw "Please run Connect-DarktraceMail before"
        } Else { 
            # Calculate signature
            $time = $(Get-Date).ToUniversalTime()
            $timeHeader = $time.ToString('yyyyMMddTHHmmss')
            $authSig = "/${endpoint}`n$($_DarktraceMailToken.UserName)`n${timeHeader}"
            Write-Debug "AuthSig: $authSig"
            if ($Body) {
                $authSig = "/${endpoint}?${body}`n$($_DarktraceMailToken.UserName)`n${timeHeader}"
                Write-Debug "AuthSig with body: $authSig"
            }
            $hmacsha1 = New-Object System.Security.Cryptography.HMACSHA1  
            $hmacsha1.key = [Text.Encoding]::UTF8.GetBytes($_DarktraceMailToken.GetNetworkCredential().Password)
            $signature = $hmacsha1.ComputeHash([Text.Encoding]::UTF8.GetBytes($authSig))
            $dtapiSignature = ($signature | ForEach-Object ToString x2 ) -join ''

            # building arguments
            $HashArguments = @{
                URI = $($_DarktraceMailURL.AbsoluteUri + $endpoint)
                #URI = "https://darktrace.gecina.fr/agemail/api/ep/api/v1.0/resources/filters"
                Method = $method
                ContentType = "application/json;charset=utf-8" 
                Headers = @{
                    "DTAPI-Token" = $_DarktraceMailToken.UserName;
                    "DTAPI-DATE" = $timeHeader;
                    "DTAPI-Signature" = $dtapiSignature
                    "accept" = "application/json"
                }
            }
            if ($Body) {
                $HashArguments.Add("Body",$Body)
            }
            Write-Debug "Run with $($HashArguments | ConvertTo-Json)"
            Invoke-RestMethod @HashArguments
        }
    }
    End {

    }

}