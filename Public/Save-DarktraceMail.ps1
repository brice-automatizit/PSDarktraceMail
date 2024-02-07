function Save-DarktraceMail {
    <#
    .SYNOPSIS

    Download the mail to a local folder.

    .DESCRIPTION

    Download the mail to a local folder.
    Usefull for running actions on those

    .EXAMPLE

    PS>Save-DarktraceMail
        
    .INPUTS

    .OUTPUTS
        
    #>
    [CmdletBinding(DefaultParameterSetName="WithUUID")]
    ##[OutputType('[SMAMailDownloaded]', ParameterSetName="none")]
    Param (
        [Parameter(
            HelpMessage = 'Message from Search-DarktraceMail or Get-DarktraceMail',
            Mandatory = $true,
            ValueFromPipeline = $true,
            Position = 0,
            ParameterSetName="WithDarktraceSearchMail"
        )]
        [Object]
        $Message,
        [Parameter(
            HelpMessage = 'UUID',
            Mandatory = $true,
            ValueFromPipeline = $true,
            Position = 0,
            ParameterSetName="WithUUID"
        )]
        [String]
        $uuid,
        [Parameter(
            HelpMessage = 'Folder Path to store',
            Mandatory = $true
        )]
        [ValidateNotNullOrEmpty()] 
        [string]
        $path
    )
    Begin {
    }
    Process {
        if ($message -and $message.GetType() -in [DarktraceSearchMail], [DarktraceGetMail]) {
            Write-Verbose "Message Object specified."
            $uuid = $message.uuid
        }
        if ($uuid) {
            Try {
                # generate an unique name to avoid conflits
                $cleanedName = "${uuid}_" + [guid]::NewGuid().ToString() + ".eml"
                $filePath = Join-Path $path $cleanedName
                $downloadedEML = Send-DarktraceMailApiRequest -endpoint "agemail/api/ep/api/v1.0/emails/$uuid/download" -Method Get
                Write-Verbose "Write EML file to $filePath"
                "$downloadedEML".Replace("`n","`r`n")  | Out-File $filePath -Encoding UTF8
                <#$downloadedEML | Set-Content -literalPath $filePath
                $text = [IO.File]::ReadAllText($filePath) -replace "`n", "`r`n"
                [IO.File]::WriteAllText($filePath, $text)#>           
            } catch {
                throw $_.Exception
            }
        } else {
            throw "No UUID Found in parameters"
        }
    }
    End {
        if ($downloadedEML) {
            [PSCustomObject]@{
                UUID = $uuid;
                File = Get-Item $filePath
            }
        }
    }
}