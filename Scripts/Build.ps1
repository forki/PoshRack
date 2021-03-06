#
# Build.ps1
#

# If NUGET is NOT installed on the build machine, install it here and now.
if(!(test-path $env:LocalAppData\NuGet\NuGet.exe)) {
  # download nuget
  Invoke-WebRequest 'https://www.nuget.org/nuget.exe' -OutFile "$($env:LocalAppData)\NuGet\NuGet.exe"
}


# If Pester is installed on the build machine, run the tests.
if(!(Get-Module -ListAvailable -Name "Pester"))  {
	Write-Warning -Message "******* Pester tests were NOT run; Please install Pester on this machine."
	Write-Warning -Message "******* Pester tests were NOT run; Please install Pester on this machine."
	Write-Warning -Message "******* Pester tests were NOT run; Please install Pester on this machine."
	Write-Warning -Message "******* Pester tests were NOT run; Please install Pester on this machine."
	Write-Warning -Message "******* Pester tests were NOT run; Please install Pester on this machine."
} else {
	$env:RACKSPACE_USERNAME = $env:BAMBOO_RACKSPACE_USERNAME
	$env:RACKSPACE_APIKEY = $env:BAMBOO_RACKSPACE_APIKEY
	$env:RACKSPACE_REGION = $env:BAMBOO_RACKSPACE_REGION
	cd ../..
	$env:psmodulepath += ";" + $pwd.Path
	Import-Module Pester
	Invoke-Pester -OutputFile pesterLog.xml -OutputFormat LegacyNUnitXml
}




# Run PACK to build the Nuget package
cd PoshRack
$CMD = "$env:LocalAppData\NuGet\NuGet.exe"
$arg1 = 'pack'
$arg2 = 'PoshRack.nuspec'
$arg3 = "-NoPackageAnalysis"

& $CMD $arg1 $arg2 $arg3