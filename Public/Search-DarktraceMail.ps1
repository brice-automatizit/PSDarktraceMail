function Search-DarktraceMail {
    <#
    .SYNOPSIS

    Returns the list of messages according search criterias.

    .DESCRIPTION

    Returns the list of messages according search criterias.
    With different attributes

    .EXAMPLE

    .INPUTS

    .OUTPUTS
        
    Object[]
    #>
    [CmdletBinding()]
    [CmdletBinding(DefaultParameterSetName="none")]
    [OutputType('[DarktraceSearchMail[]]', ParameterSetName="none")]
    Param (
        [Parameter(
            HelpMessage = 'Start Date to look for',
            Position = 1
        )]
        [Datetime]
        $StartDate = $(Get-Date).AddDays(-1),
        [Parameter(
            HelpMessage = 'End Date to look for',
            Position = 2
        )]
        [Datetime]
        $EndDate = $(Get-Date),
        [Parameter(
            HelpMessage = 'Recipient filter (contains)',
            Position = 3
        )]
        [string]
        $RecipientFilter,
        [Parameter(
            HelpMessage = 'Sender filter (contains)',
            Position = 4
        )]
        [string]
        $SenderFilter,
        [Parameter(
            HelpMessage = 'Only return holded',
            Position = 5
        )]
        [Switch]
        $HoldedOnly
    )
    Begin {
        $arrayResults = [System.Collections.ArrayList]::new()
    }
    Process {
        $filtersDT = [PSCustomObject]@{ criteriaList = @(); mode = "and" }
        if ($recipientFilter) {
            Write-Verbose "Add Recipient Filter"
            $filtersDT.criteriaList += [PSCustomObject]@{
                apiFilter = "Recipient.Email"
                value = $recipientFilter
                operator = "~*" #contains operator
            }
        }
        if ($senderFilter) {
            Write-Verbose "Add Sender Filter"
            $filtersDT.criteriaList += [PSCustomObject]@{
                apiFilter = "Header.From.Email"
                value = $senderFilter
                operator = "~*" #contains operator
            }
        }
        if ($HoldedOnly) {
            Write-Verbose "Add Only Holded Filter"
            $filtersDT.criteriaList += [PSCustomObject]@{
                apiFilter = "Action.Action Taken"
                value = "Hold"
                operator = "="
            }
        }

        Write-Verbose $($filtersDT | ConvertTo-Json -Compress)
        $bodyDT = [PSCustomObject]@{ page = 0; itemsPerPage = 20; timeFrom = [DateTimeOffset]::new($startDate.ToUniversalTime()).ToUnixTimeSeconds(); timeTo = [DateTimeOffset]::new($endDate.ToUniversalTime()).ToUnixTimeSeconds(); query = $filtersDT}
        do {
            $searchResultsDT = Send-DarktraceMailApiRequest -endpoint "agemail/api/ep/api/v1.0/emails/search" -Method Post -Body $($bodyDT | ConvertTo-Json -Depth 10)
            $searchResultsDT | ForEach-Object { $arrayResults.Add([DarktraceSearchMail]$_) | Out-Null }
            if ( $($searchResultsDT | Measure-Object | Select-Object -ExpandProperty Count) -ge 20) {
                Write-Verbose "20+ results found. Wait a moment, to grab all results..."
                $bodyDT.Page++
            }
        } while ($($searchResultsDT | Measure-Object | Select-Object -ExpandProperty Count) -ge 20)

        [DarktraceSearchMail[]]$arrayResults
    }
    End {    }
}