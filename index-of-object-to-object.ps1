

$Arch=@('x64','x86')
$Lang=@('en-US','en-AU')

$x64InstallURI=@('US-rpc-x64','AU-rpc-x64')
$x86InstallURI=@('US-rpc-x86','US-rpc-x86')

$d=[Ordered]@{}
$d.Category="browser"
$d.Manifest="4.2.4.6"
$d.Nuspec=$true
$d.NuspecURI="https://raw.githubusercontent.com/chocolatey-community/chocolatey-coreteampackages/master/automatic/firefox/firefox.nuspec"
$d.Copyright=$License
$d.Id=@{}
$d.Id.Version="78.0.2"
$d.Id.Name="Firefox"
$d.Id.Publisher="Mozilla"
$d.Id.Copyright="Copyright $([char]0x00A9) 1998-2020 Mozilla Foundation"
$d.Id.Tags=@('browser','mozilla','firefox')
$d.Id.Description="Bringing together all kinds of awesomeness to make browsing better for you."
$d.Id.Homepage="https://www.mozilla.org/en-US/firefox/new/"
$d.Id.Arch=$Arch
$d.Id.Languages=$Lang
$d.Id.Depends=@()
$d.Id.Installers=@{}



foreach ($i in $Arch) {
    $d.Id.Installers.$i=@{}

    foreach ($f in $Lang) {
        $d.Id.Installers.$i.$f=@{}
    }
}


foreach($language in $lang) {

    foreach ($t in $x64InstallURI) {
        $d.Id.Installers.x64.$language.x64installuriplease=$t
    }
}



$d | ConvertTo-Json -Depth 5


