$pattern = '[^a-zA-Z0-9_]'

$string1 = 'abcdefg12345HIJKLMNOP!@#$%qrs)(*&^TUVWXyz'
$string2 = 'df098vji3m4tg0bvdvjbd------_"""""""""""__f #@$#RTF # VW$Csu-9t `HJ*# TU(_#JRT '

$string1 -replace $pattern,''
$string2 -replace $pattern,''



"This is a copyright © notice" -match 'Copyright' -and "This is a Copyright © notice" -match [char]0x00A9








$From = 'ikea'
$subject = 'are*'


if ($subject -match '\.')
{
    write-output '-match     : String contains the * character'
}
else {
    Write-Output '-match     : String does not contain the * Character'
}

if ($subject.Contains('.'))
{
    write-output '.Contains(): String contains the * character'
}
else {
    Write-Output '.Contains(): String does not contain the * Character'
}






$s='thisis.text'
$s -match '\.' -and $s -notmatch ' '










<#
[Parameter(Mandatory=$false,
            ValueFromPipeline=$false,
            ValueFromPipelineByPropertyName=$true,
            ValueFromRemainingArguments=$false,
            Position=2)]
        [ValidateNotNull]
        [ValidateNotNullOrEmpty]
        [ValidateCount(5,14)]
        [ValidateSet('browser','business','entertainment','graphic_design','photo','social','productivity','games','security','microsoft')]
        [ValidateScript(
            {
                [Array]$catList = @('browser','business','entertainment','graphic_design','photo','social','productivity','games','security','microsoft')
                if ( $_ -in $catList ) {
                    $_
                }
                else {
                    Throw "'$_' does NOT use an approved Publisher name."
                }
            }
        )]
        [Alias('cat')]
        [String]$Category

        #>