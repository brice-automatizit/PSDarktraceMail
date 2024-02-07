# PSDarktraceMail

[![PowerShell Gallery][psgallery-badge]][psgallery]

A PowerShell module for interfacing with the Darktrace Mail API

## Usage

### Install

```PowerShell
PS> Install-Module PSDarktraceMail
```

### Import

```PowerShell
PS> Import-Module PSDarktraceMail
```

### Connect

```PowerShell
PS> Connect-DarktraceMail -ServerUri "https://<your appliance uri>" -Credential $(Get-Credential)
```

Enter the Token in the username and Private Token in the password

### Example for unattended

```PowerShell
PS> # Save credentials
PS> Get-Credential | Export-CliXml "$($ENV:USERPROFILE)\darktrace.xml"
PS> # Use those save credentials (same computer, same windows session)
PS> Connect-DarktraceMail -ServerUri "https://<your appliance uri>" -Credential $(Import-Clixml "$($ENV:USERPROFILE)\darktrace.xml")
```

### Search for an Email 

Search holded mails with sender address containing "scammer" up to 4 days ago

```PowerShell
PS> $results = Search-DarktraceMail -StartDate $(get-date).AddDays(-4) -SenderFilter "scammer" -HoldedOnly
```

Search all mails up to 3 days ago

```PowerShell
PS> $others = Search-DarktraceMail -StartDate $(get-date).AddDays(-3)
```

Advanced Options:

* Specify the ```-StartDate``` value for the starting date.
* Specify the ```-EndDate``` value for the ending date.
* Specify the ```-SenderFilter``` value for sender filtering (contains).
* Specify the ```-RecipientFilter``` value for recipient filtering (contains).
* Specify the ```-HoldedOnly``` flag to retrieve holder messages only.


### Get details from an UUID

From pipeline

```PowerShell
PS> $message = "E8CF7E71-8F00-47BE-94A8-CF71D0FF8F3C.1" | Get-DarktraceMail
```

### Download mail in EML

```PowerShell
PS> $path = $($ENV:TMP)
PS> $message | Save-DarktraceMail -Path $path
PS> # or through UUID
PS> "E8CF7E71-8F00-47BE-94A8-CF71D0FF8F3C.1" | Save-DarktraceMail -Path $path
```

### Release mail

```PowerShell
PS> $message | Unblock-DarktraceMail
```

### Block mail

```PowerShell
PS> $message | Block-DarktraceMail
```

[psgallery-badge]:      https://img.shields.io/powershellgallery/dt/PSDarktraceMail.svg
[psgallery]:            https://www.powershellgallery.com/packages/PSDarktraceMail