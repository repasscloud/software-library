$ErrorActionPreference = "SilentlyContinue"

$HeadersToken = @{
    Authorization = Get-Content -Path C:\tmp\software-matrix\test\token.key
    Accept = 'application/vnd.github.symmetra-preview+json'
}
$owner = 'repasscloud'
$repository = 'software-library'
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

$bodyText = @"
This is the body text of the ticket.
"@
$Body = @{
    title = 'API Ticket Creation'
    body = $bodyText
    asignees = @("danijeljw")
    labels = @('feature_request')
} | ConvertTo-Json
$NewIssue = Invoke-WebRequest -Method Post -Uri "https://api.github.com/repos/${owner}/${repository}/issues" -Body $Body -Headers $HeadersToken -ContentType "application/json"
$issueNumber = ($NewIssue.Content | ConvertFrom-Json).number
        
    


$issueNumber=35
Invoke-WebRequest -Method Get -Uri "https://api.github.com/repos/${owner}/${repository}/issues/${issueNumber}"





$Body = @{
    state = 'closed'
} | ConvertTo-Json
Invoke-WebRequest -Method Patch -Uri "https://api.github.com/repos/${owner}/${repository}/issues/${issueNumber}" -Body $Body -Headers $HeadersToken -ContentType "application/json"
$Body = @{
    locked  = $true
    active_lock_reason = 'resolved'
} | ConvertTo-Json
Invoke-WebRequest -Method PUT -Uri "https://api.github.com/repos/${owner}/${repository}/issues/${issueNumber}/lock" -Body $Body -Headers $HeadersToken -ContentType "application/json"


$Body = @{
    labels=@("resolved ✔️")
} | ConvertTo-Json
Invoke-WebRequest -Method Patch -Uri "https://api.github.com/repos/${owner}/${repository}/issues/${issueNumber}" -Body $Body -Headers $HeadersToken -ContentType "application/json"




(Invoke-WebRequest -Method Get -Uri "https://api.github.com/repos/${owner}/${repository}/issues/${issueNumber}").RawContent

{"url":"https://api.github.com/repos/repasscloud/software-library/issues/34","repository_url":"https://api.github.com/repos/repasscloud/software-library","labels_url":"https://api.github.com/repos/repasscloud/software-library/issues/34/labels{/name}","comments_url":"https://api.github.com/repos/repasscloud/software-library/issues/34/comments","events_url":"https://api.github.com/repos/repasscloud/software-library/issues/34/events","html_url":"https://github.com/repasscloud/software-library/issues/34","id":656059250,"node_id":"MDU6SXNzdWU2NTYwNTkyNTA=","number":34,"title":"API Ticket Creation","user":{"login":"danijeljw","id":2172792,"node_id":"MDQ6VXNlcjIxNzI3OTI=","avatar_url":"https://avatars2.githubusercontent.com/u/2172792?v=4","gravatar_id":"","url":"https://api.github.com/users/danijeljw","html_url":"https://github.com/danijeljw","followers_url":"https://api.github.com/users/danijeljw/followers","following_url":"https://api.github.com/users/danijeljw/following{/other_user}","gists_url":"https://api.github.com/users/danijeljw/gists{/gist_id}","starred_url":"https://api.github.com/users/danijeljw/starred{/owner}{/repo}","subscriptions_url":"https://api.github.com/users/danijeljw/subscriptions","organizations_url":"https://api.github.com/users/danijeljw/orgs","repos_url":"https://api.github.com/users/danijeljw/repos","events_url":"https://api.github.com/users/danijeljw/events{/privacy}","received_events_url":"https://api.github.com/users/danijeljw/received_events","type":"User","site_admin":false},"labels":[{"id":2192320298,"node_id":"MDU6TGFiZWwyMTkyMzIwMjk4","url":"https://api.github.com/repos/repasscloud/software-library/labels/resolved%20%E2%9C%94%EF%B8%8F","name":"resolved ✔️","color":"8dfc85","default":false,"description":""}],"state":"closed","locked":true,"as
signee":null,"assignees":[],"milestone":null,"comments":1,"created_at":"2020-07-13T18:41:21Z","updated_at":"2020-07-13T18:46:30Z","closed_at":"2020-07-13T18:43:59Z","author_association":"CONTRIBUTOR","active_lock_reason":null,"body":"This is the body text of the ticket.","closed_by":{"login":"danijeljw","id":2172792,"node_id":"MDQ6VXNlcjIxNzI3OTI=","avatar_url":"https://avatars2.githubusercontent.com/u/2172792?v=4","gravatar_id":"","url":"https://api.github.com/users/danijeljw","html_url":"https://github.com/danijeljw","followers_url":"https://api.github.com/users/danijeljw/followers","following_url":"https://api.github.com/users/danijeljw/following{/other_user}","gists_url":"https://api.github.com/users/danijeljw/gists{/gist_id}","starred_url":"https://api.github.com/users/danijeljw/starred{/owner}{/repo}","subscriptions_url":"https://api.github.com/users/danijeljw/subscriptions","organizations_url":"https://api.github.com/users/danijeljw/orgs","repos_url":"https://api.github.com/users/danijeljw/repos","events_url":"https://api.github.com/users/danijeljw/events{/privacy}","received_events_url":"https://api.github.com/users/danijeljw/received_events","type":"User","site_admin":false}}