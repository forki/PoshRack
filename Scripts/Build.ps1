#
# Build.ps1
#


# Run Pester tests and output to NUnit-compatible XML file. This
# allows the CICD (Bamboo.com) to pick up the results.
Invoke-Pester -OutputXml



# If NUGET is NOT installed on the build machine, install it here and now.
if(!( test-path $env:LocalAppData\NuGet\NuGet.exe)) {
  # download nuget
  Invoke-WebRequest 'https://www.nuget.org/nuget.exe' -OutFile "$($env:LocalAppData)\NuGet\NuGet.exe"
}

# Run PACK to build the Nuget package
$CMD = "$env:LocalAppData\NuGet\NuGet.exe"
$arg1 = 'pack'
$arg2 = '..\PoshRack.nuspec'
$arg3 = "-NoPackageAnalysis"

& $CMD $arg1 $arg2 $arg3