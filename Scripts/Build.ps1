#
# Build.ps1
#

# If NUGET is NOT installed on the build machine, install it here and now.
if(!( test-path $env:LocalAppData\NuGet\NuGet.exe)) {
  # download nuget
  Invoke-WebRequest 'https://www.nuget.org/nuget.exe' -OutFile "$($env:LocalAppData)\NuGet\NuGet.exe"
}


# If Pester is NOT installed on the build machine, install it here and now.
if(-not(Get-Module -Name "Pester")) {
	(new-object Net.WebClient).DownloadString("http://psget.net/GetPsGet.ps1") | iex
	Import-Module PsGet
	Install-Module Pester -Global 
}

# Run Pester tests and output to NUnit-compatible XML file. This
# allows the CICD (Bamboo.com) to pick up the results.
Import-Module Pester
Invoke-Pester -OutputXml



# Run PACK to build the Nuget package
$CMD = "$env:LocalAppData\NuGet\NuGet.exe"
$arg1 = 'pack'
$arg2 = '..\PoshRack.nuspec'
$arg3 = "-NoPackageAnalysis"

& $CMD $arg1 $arg2 $arg3