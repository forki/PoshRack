#
# PushToNuget.ps1
#

$START = Convert-Path .
Write-Verbose "Using Bamboo path:"
Write-Verbose $START


cd ..\Scripts\PoshRack


# First, we need to find the name of the package
$PackageFile = Get-ChildItem -Filter *.nupkg | sort LastWriteTime | Select-Object -last 1

# If null or empty, bail immediately
# TODO TEST FOR NULL file name

Write-Verbose "Pushing Nuget package:"
Write-Verbose $PackageFile


# Now we can push it to nuget.org using the NuGet command line tool
$CMD = "$env:LocalAppData\NuGet\NuGet.exe"
$arg1 = 'push'
$arg2 = $PackageFile.Name
$arg3 = "$env:BAMBOO_NUGET_APIKEY_PASSWORD"
& $CMD $arg1 $arg2 $arg3
