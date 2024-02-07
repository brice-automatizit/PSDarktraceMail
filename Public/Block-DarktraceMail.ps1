function Block-DarktraceMail {
    <#
    .SYNOPSIS

    Block a mail

    .DESCRIPTION

    Set hold action to a mail

    .EXAMPLE
        
    PS>

    .INPUTS

    .OUTPUTS
        
    $true or $false
    #>
    [CmdletBinding(DefaultParameterSetName="WithUUID")]
    [OutputType('[bool]', ParameterSetName="none")]
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
        $uuid
    )
    Begin {
    }
    Process {
        if ($uuid) {
            Write-Verbose "UUID specified Need to grab message details."
            Try {
                $message = $uuid | Get-DarktraceMail
            } Catch {
                throw $_.Exception
            }
        }
        if ($message -and $message.GetType() -in [DarktraceSearchMail], [DarktraceGetMail]) {
            Try {
                $body = @{
                    "action"= "hold";
                    "recipients" = @($message.rcpts.rcpt_to)
                } | convertto-json
                Write-Verbose "Sending body $($body)"
                $result = Send-DarktraceMailApiRequest -endpoint "agemail/api/ep/api/v1.0/emails/$($message.uuid)/action" -method "POST" -body $body
            } catch {
                throw $_.Exception
            }
        } else {
            throw "Incorrect message provided"
        }
    }
    End {
        if ($result.resp) {
            $result.resp
        } else {
            $result
        }
    }
}