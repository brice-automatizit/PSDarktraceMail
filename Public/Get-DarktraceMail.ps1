function Get-DarktraceMail {
    <#
    .SYNOPSIS

    Returns the details of a message.

    .DESCRIPTION

    Returns the details of a message.

    .EXAMPLE
    PS>$detailMail = "UUID" | Get-DarktraceMessage

    .INPUTS

    .OUTPUTS
        
    Object[]  #$detailsMessages = Invoke-SMACall $(New-SMAQueryURL -endpoint "quarantine/messages/details" -mid $mid -quarantineType "pvo")
    #>
    #[CmdletBinding(DefaultParameterSetName="none")]
    [CmdletBinding()]
    [OutputType('[DarktraceMail]')]
    Param (
        [Parameter(
            HelpMessage = 'Message',
            Mandatory = $true,
            ValueFromPipeline = $true,
            Position = 0
        )]
        [string]
        $uuid
    )
    Begin {
    }
    Process {
        Try {
            $message = Send-DarktraceMailApiRequest -endpoint "agemail/api/ep/api/v1.0/emails/$uuid" -Method Get
        } Catch {}
        if ($message) {
            [DarktraceGetMail]$message
        } else {
            Write-Warning "No message found for uuid $uuid"
        }
    }
    End {
    }
}