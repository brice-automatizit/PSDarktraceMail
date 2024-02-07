# Classes for parameter validation
class DarktraceSearchMailRcpts {
    [bool]$action_status
    [bool]$is_group_email
    [bool]$is_read
    [string[]]$rcpt_actions_taken
    [string]$rcpt_status
    [string]$rcpt_to
    [string[]]$tags
}

class DarktraceGetMailRcpts {
    [bool]$action_status
    [bool]$is_group_email
    [bool]$is_read
    [string[]]$rcpt_actions_taken
    [string]$rcpt_status
    [string]$rcpt_to
    [object]$requestedRelease
    [System.String[]]$summary
    [string[]]$tags
}

class DarktraceSearchMail {
    [string]$direction
    [string]$dtime
    [long]$dtime_unix
    [string]$header_from
    [string]$header_from_email
    [string]$header_from_personal
    [string]$header_subject
    [bool]$in_progress
    [int]$model_score
    [int]$n_attachments
    [int]$n_links
    [DarktraceSearchMailRcpts[]]$rcpts
    [Object[]]$restricted_recipients
    [string]$uuid
}

class DarktraceGetMail {
    [object]$campaign_id
    [string]$direction
    [string]$dtime
    [long]$dtime_unix
    [string]$header_from
    [string]$header_from_email
    [string]$header_from_personal
    [string]$header_subject
    [bool]$in_progress
    [int]$model_score
    [int]$n_attachments
    [int]$n_links
    [DarktraceGetMailRcpts[]]$rcpts
    [Object[]]$restricted_recipients
    [string]$uuid
}