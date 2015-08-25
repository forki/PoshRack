$scriptDir = Split-Path $MyInvocation.MyCommand.Definition -Parent
#[Reflection.Assembly]::LoadFile("$scriptDir\bin\Newtonsoft.Json.dll")
#[Reflection.Assembly]::LoadFile("$scriptDir\bin\SimpleRESTServices.dll")
#[Reflection.Assembly]::LoadFile("$scriptDir\bin\Rackspace.dll")
#[Reflection.Assembly]::LoadFile("$scriptDir\Bin\openstacknet.dll")
#[Reflection.Assembly]::LoadFile("$scriptDir\bin\Flurl.Http.dll")
#[Reflection.Assembly]::LoadFile("$scriptdir\bin\Flurl.dll")
Add-Type -Path "$scriptDir\bin\Newtonsoft.Json.dll"
Add-Type -Path "$scriptDir\bin\SimpleRESTServices.dll"
Add-Type -Path "$scriptDir\bin\Rackspace.dll"
Add-Type -Path "$scriptDir\bin\openstacknet.dll"
Add-Type -Path "$scriptDir\bin\Flurl.Http.dll"
Add-Type -Path "$scriptDir\bin\Flurl.dll"
Add-Type -Path "$scriptDir\bin\Marvin.JsonPatch.dll"
