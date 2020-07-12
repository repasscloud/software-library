# Set Nuspec value
function Set-NuspecValue {
    param(
        [Parameter(Mandatory=$false, Position=0)]
        [ValidateSet($false,$true)]
        [System.Boolean]
        $NuspecFile
    )
    if (-not($NuspecFile)) {
        [String]$return_value='  "Nuspec": false,'
        return $return_value
    } else {
        [String]$return_value='  "Nuspec": true,'
        return $return_value
    }
}