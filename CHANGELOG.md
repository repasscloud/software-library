# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]
  - Uninstaller string lookup.

## [4.3.7.9] - 2020-07-29
**Added**
  - Manifest `v4.3.7.9` ratified.
  - CPU Arch selection referenced from online allowing rapid updates.
  - OSI License selection referenced from online allowing rapid updates.

**Changed**
  - _f_ Get-URLStatusCode now as `Get.URLStatusCode` PSModule.
  - _f_ Get-RedirectedURL now as `GetRedirectedURL` PSModule.

**Removed**
  - Inter-dependent functions from the `/lib` directory have all been depreciated.
  - Copyright notice from CMani, is read directly from online.
  - Manifest `v4.3.6.8` deprecated.

## [4.2.5.7] - 2020-07-03
**Added**
  - `Arch` to manifest.
  - Retroactively added `Arch` to all existing manifests.

## [4.2.4.6] - 2020-07-03
**Added**
  - Additional language support for installers per manifest.
  - Option to expand into NuSpec where Release was previously.
  - SHA512 checksum to installers.

**Changed**
  - Manifest version from 4.2.x.x to 4.2.4.6 formally.

**Removed**
  - Legacy manifests.
  - Release of Manifest.