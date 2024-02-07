function Connect-DarktraceMail {
    <#
    .SYNOPSIS

    Set internal variables for connexion.

    .DESCRIPTION

    Set internal variables for connexion.

    .PARAMETER  ServerUri
        
    System.Uri
    This is the fully qualified URI of your SMA instance. ex: https://host-sma1.domain.iphmx.com:4431/sma/api/v2.0/"

    .PARAMETER SMACredential

    System.Management.Automation.PSCredential
    This is the username credential you will use to authenticate.

    .EXAMPLE

    PS>Connect-SMAApi -ServerUri 'https://host-sma1.domain.iphmx.com:4431/sma/api/v2.0/' -SMACredential (Get-Credential)
        
    .INPUTS
        
    System.Uri
    System.Management.Automation.PSCredential

    .OUTPUTS
        
    void
    #>
    [CmdletBinding(DefaultParameterSetName = 'Credential')]
    Param (
        [Parameter(
            HelpMessage = 'The fully qualified URI of the server. Do not include the API path.',
            Mandatory = $true,
            Position = 0,
            ParameterSetName = 'Credential'
        )]
        [System.Uri]
        $ServerUri,

        [Parameter(
            HelpMessage = 'username@realm credential',
            Mandatory = $true,
            Position = 1,
            ParameterSetName = 'Credential'
        )]
        [PSCredential]
        $Credential
    )
    Begin {
        # Remove any module-scope variables in case the user is reauthenticating
        Remove-Variable -Scope Script -Name _DarktraceMailToken,_DarktraceMailURL -Force -ErrorAction SilentlyContinue | Out-Null
        Set-Variable -Name _DarktraceMailToken -Value $Credential -Option ReadOnly -Scope Script -Force
        Set-Variable -Name _DarktraceMailURL -Value $ServerUri -Option ReadOnly -Scope Script -Force
    }
    Process {
        if ($PSCmdlet.ParameterSetName -eq 'Credential') { 
            Try {
                $result = Send-DarktraceMailApiRequest -endpoint "agemail/api/ep/api/v1.0/resources/filters"
                if ($result.count -le 1) {
                    throw "Please verify Token"
                } else {
                    Write-Verbose "Authenticated to Darktrace Mail API"
                }
            } Catch {
                Write-Verbose "Cleaning scoped variables"
                Remove-Variable -Scope Script -Name _DarktraceMailToken,_DarktraceMailURL -Force -ErrorAction SilentlyContinue | Out-Null
                throw $_
            }
        }
    }
    End {}
}