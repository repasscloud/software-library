Set-InstallerLanguages -Arch x86_64 `
    -Lang en-US `
    -SilentSwitch '/silent_switch' `
    -UninstallSwitch '/uninstall_switch' `
    -InstallURI_x64 https://www.7-zip.org/a/7z1900-x64.msi `
    -InstallURI_x86 'https://download.mozilla.org/?product=firefox-msi-latest-ssl&os=win&lang=en-US' `
    -MsiExe_x64 MSI `
    -MsiExe_x86 EXE `
    -UpdateURI_x64 https://www.google.com/ `
    -UpdateRegex_x64 '(/s*.)' `
    -UpdateURI_x86 https://yahoo.com/ `
    -UpdateRegex_x86 '(*.)' `
    -Verbose

    

    "x64": {
        "en-US": {
            "Url": "https://www.7-zip.org/a/7z1900-x64.msi",
            "FollowUrl": "https://www.7-zip.org/a/7z1900-x64.msi",
            "Sha256": "A7803233EEDB6A4B59B3024CCF9292A6FFFB94507DC998AA67C5B745D197A5DC",
            "Sha512": "7837A8677A01EED9C3309923F7084BC864063BA214EE169882C5B04A7A8B198ED052C15E981860D9D7952C98F459A4FAB87A72FD78E7D0303004DCB86F4324C8",
            "InstallerType": "MSI",
            "InstallSwitches": "/silent_switch",
            "UninstallString": "/uninstall_switch",
            "UpdateURI": "https://www.google.com/",
            "UpdateRegex": "(/s*.)"
        }
    },
    "x86": {
        "en-US": {
            "Url": "https://download.mozilla.org/?product=firefox-msi-latest-ssl&os=win&lang=en-US",
            "FollowUrl": "https://download-installer.cdn.mozilla.net/pub/firefox/releases/78.0.2/win32/en-US/Firefox%20Setup%2078.0.2.msi",
            "Sha256": "5E2299E26BDC2615C8811D796A845FA8BB027020121029F475788CD152024458",
            "Sha512": "18010FEE9CA8BCDCF8D29311D131140A6D8FBB9CDC78D82642570A3B383C0A6A90FB2CB74D872C7C53431D03AAD572A85D1791E28AE8A2E90079380990415603",
            "InstallerType": "EXE",
            "InstallSwitches": "/silent_switch",
            "UninstallString": "/uninstall_switch",
            "UpdateURI": "https://yahoo.com/",
            "UpdateRegex": "(*.)"
        }
    },