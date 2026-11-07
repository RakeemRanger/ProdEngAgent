[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [ValidateNotNullorEmpty()]
    [string]$Environment
)

if ($Environment -eq "Prod"){
    Write-Output 'Cannot Build Test with Prod settings'
    exit
}
else{
    Write-Output 'Pass'
}
