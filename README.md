# Software Matrix

```json
{
    "category": "<Category of manifest>",
    "manifest": "<Version number, 4.2.4.6>",
    "release": "<yyyy-MM-dd>",
    "copyright": "<Copyright notice of manifest goes here>",
    "list": ["appName1","appName2"],
    "Id.appName1": {
        "Version": "<SemVer versioning number>",
        "Name": "<Name of the application>",
        "Publisher": "<Developer or publisher of application>",
        "License": "<License type>",
        "LicenseURL": "<Url of license (if known)>",
        "Tags": ["tag1","tag2","etc"],
        "Description": "<A quick description goes here>",
        "Homepage": "<https://www.com/>",
        "Languages": ["en-US","ja-JP","<Languages available for installer>"],
        "Arch": ["x64","x86","<Depending on what is valid>"],
        "Depends": ["<Dependencies>"],
        "Installers": {
            "x64": {
                "en-US": {
                    "Url": "<URL to installer>",
                    "FollowUrl": "<Follow url or Invoke-WebRequest to obain>",
                    "Sha256": "<SHA256 of installer file>",
                    "InstallerType": "<msi, exe, etc>",
                    "Switches": "</s, etc>"
                },
                "ja-JP": {
                    "Url": "<URL to installer>",
                    "FollowUrl": "<Follow url or Invoke-WebRequest to obain>",
                    "Sha256": "<SHA256 of installer file>",
                    "InstallerType": "<msi, exe, etc>",
                    "Switches": "</s, etc>"
                }
            },
            "x86": {
                "en-US": {
                    "Url": "",
                    "FollowUrl": "",
                    "Sha256": "",
                    "InstallerType": "",
                    "Switches": ""
                },
                "ja-JP": {
                    "Url": "",
                    "FollowUrl": "",
                    "Sha256": "",
                    "InstallerType": "",
                    "Switches": ""
                }
            }
        }
    }
}
```
