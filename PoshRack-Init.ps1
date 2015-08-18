$scriptDir = Split-Path $MyInvocation.MyCommand.Definition -Parent
[Reflection.Assembly]::LoadFile("$scriptDir\bin\Newtonsoft.Json.dll")
[Reflection.Assembly]::LoadFile("$scriptDir\bin\SimpleRESTServices.dll")
[Reflection.Assembly]::LoadFile("$scriptDir\bin\openstacknet.dll")
