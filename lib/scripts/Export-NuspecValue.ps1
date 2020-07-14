# Set Nuspec value
function Export-NuspecValue {
    param(
        [Parameter(Mandatory=$false,Position=0)]
        [ValidateScript({
            if ( $_.Length -gt 0 -and (Get-UrlStatusCode -Url $_) -like 200 ) {
                $_
            }
            else {
                Throw "'$_' does NOT provide a valid URL."
            }
        })]
        [uri]
        $NuspecURI
    )

    # Linebreak
    $OFS="`r`n"

    if (-not($NuspecURI)) {
        [String]$return_value='  "Nuspec": false,' + $OFS + '  "NuspecURI": "' + $NuspecURI + '",'
        return $return_value
    } else {
        [String]$return_value='  "Nuspec": true,' + $OFS + '  "NuspecURI": "' + $NuspecURI + '",'
        return $return_value
    }
}