$scriptDir = Split-Path $MyInvocation.MyCommand.Definition -Parent
Add-Type -Path "$scriptDir\packages\Newtonsoft.Json\lib\net45\Newtonsoft.Json.dll"
Add-Type -Path "$scriptDir\packages\Rackspace\lib\net45\Rackspace.dll"
Add-Type -Path "$scriptDir\packages\openstack.net\lib\net45\openstacknet.dll"
Add-Type -Path "$scriptDir\packages\Flurl.Http.Signed\lib\net45\Flurl.Http.dll"
Add-Type -Path "$scriptDir\packages\Flurl.Signed\lib\portable-net40+sl50+win+wpa81+wp80+MonoAndroid10+MonoTouch10\Flurl.dll"
Add-Type -Path "$scriptDir\packages\Marvin.JsonPatch.Signed\lib\portable-net40+win+wpa81\Marvin.JsonPatch.dll"
