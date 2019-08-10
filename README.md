# Chocolatey: Veeam Agent for Windows

[![Build Status](https://img.shields.io/travis/sbaerlocher/chocolatey.veeam-agent?style=flat-square)](https://travis-ci.org/sbaerlocher/chocolatey.veeam-agent) [![license](https://img.shields.io/github/license/mashape/apistatus.svg?style=popout-square)](licence) [![Chocolatey](https://img.shields.io/chocolatey/v/veeam-agent?label=package%20version)](https://chocolatey.org/packages/veeam-agent) [![Chocolatey](https://img.shields.io/chocolatey/dt/veeam-agent?label=package%20downloads&style=flat-square)](https://chocolatey.org/packages/veeam-agent)

## Description

Veeam® Agent for Microsoft Windows provides a simple solution for backing up Windows-based servers, desktops and laptops. With Veeam Agent for Microsoft Windows, you can easily back up your computer to an external hard drive, NAS (network-attached storage) share or a Veeam Backup and Replication™ repository. And, should ransomware encrypt your files, your system fails to boot, your hard drive crashes or an important file gets corrupted or accidentally deleted, you can recover what you need in minutes — like it never happened.

## Package Parameters

- `/NoAutostartHard` Disables Veeam Agent Gui when starting Windows.
- `/CleanStartmenu` Removes frequently used Veeam shortcuts from the Startmenu.

## Installation

installation without parameters.

```powershell
 choco install veeam-agent
```

installation with parameters.

```powershell
 choco install veeam-agent --params="'/NoAutostartHard /CleanStartmenu'"
```

## Author

- [Simon Bärlocher](https://sbaerlocher.ch)
- Eric Stevens

## License

This project is under the MIT License. See the [LICENSE](https://sbaerlo.ch/licence) file for the full license text.

## Copyright

(c) 2019, Simon Bärlocher
