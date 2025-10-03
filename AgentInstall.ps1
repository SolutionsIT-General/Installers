<#
This script will install the CONNECTWISE AUTOMATE AGENT. 
The script will first qualify if another Automate agent is already
installed on the computer. If the existing agent belongs to different 
Automate server, it will automatically uninstall the existing 
agent. This comparison is based on the server's FQDN. 
#>

[CmdletBinding()]
param (
    [Parameter(Mandatory=$true)]
    [string]$Server,
    [Parameter(Mandatory=$true)]
    [string]$Token,
    [Parameter(Mandatory=$true)]
    [int]$LocationId
)

##### Script Logic #####
try {
    [Net.ServicePointManager]::SecurityProtocol = [Enum]::ToObject([Net.SecurityProtocolType], 3072)
    Invoke-Expression(New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/SolutionsIT-General/PowerShell/master/Automate-Module.ps1')
} catch {
    "$_"
    exit 1001
}

# Creates global variable called Automate
Confirm-Automate -Silent

if ($Automate.Installed -and $Automate.ServerAddress -eq "https://$Server") {
    "Automate is installed. ComputerID: $($Automate.ComputerID)"
    exit 0
} else {
    Install-Automate -Server $Server -LocationID $LocationId -Token $Token -Silent
    if ($Automate.Installed) {
        "Automate is installed. ComputerID: $($Automate.ComputerID)"
        exit 0
    } else {
        "Automate was not installed"
        exit 1001
    }
}

