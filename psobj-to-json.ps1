[String]$License=@"
Copyright $([char]0x00A9) 2020 RePass Pty Ltd (https://www.repasscloud.com/).
Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
"@

$f=@{
    Category='browser'
    Manifest='4.2.4.6'
    Nuspec=$true
    NuspecURI='https://raw.githubusercontent.com/chocolatey-community/chocolatey-coreteampackages/master/automatic/firefox/firefox.nuspec'
    Copyright=$License
    Id=@{
        Version="78.0.2"
        Name="Firefox"
        Publisher="Mozilla"
        Copyright="Copyright $([char]0x00A9) 1998-2020 Mozilla Foundation"
        Tags=@('browser','mozilla','firefox')
        Description="Bringing together all kinds of awesomeness to make browsing better for you."
        Homepage="https://www.mozilla.org/en-US/firefox/new/"
        Arch=@('x64')
        Languages=@('en-US')
        Depends=@()
        Installers=@{
            x64=@{
                en_US=@{
                    URL="https://download.mozilla.org/?product=firefox-msi-latest-ssl&os=win64&lang=en-US"
                    FollowURL="cat"
                    Sha256="cat"
                    Sha512="car"
                    InstallerType="car"
                    InstallSwitches="car"
                    UninstallString="car"
                }
            }
        }
    }
} | ConvertTo-Json -Depth 5
