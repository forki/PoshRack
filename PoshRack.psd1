<############################################################################################

PoshRack
    Module Manifest 
    Version 0.0.1

        
Description
-----------
    PowerShell v5 module for OpenStack, based on the OpenStack.NET SDK

Module manifest for module 'PoshRack'

############################################################################################>

@{

# Script module or binary module file associated with this manifest.
RootModule = 'PoshRackMaster.psm1'

# Version number of this module.
ModuleVersion = '0.0.1'

# ID used to uniquely identify this module
GUID = '162fdc1b-64cd-471d-9137-0afa66aabee4'

# Author of this module
Author = 'don.schenck@rackspace.com'

# Company or vendor of this module
CompanyName = 'Rackspace Hosting'

# Copyright statement for this module
Copyright = ''

# Description of the functionality provided by this module
Description = "PowerShell v5 module for OpenStack, based on the OpenStack.NET SDK"

# Minimum version of the Windows PowerShell engine required by this module
 PowerShellVersion = '3.0'

# Name of the Windows PowerShell host required by this module
# PowerShellHostName = ''

# Minimum version of the Windows PowerShell host required by this module
 PowerShellHostVersion = '3.0'

# Minimum version of the .NET Framework required by this module
 DotNetFrameworkVersion = '4.0'

# Minimum version of the common language runtime (CLR) required by this module
# CLRVersion = ''

# Processor architecture (None, X86, Amd64) required by this module
# ProcessorArchitecture = ''

# Modules that must be imported into the global environment prior to importing this module
# RequiredModules = ""

# Assemblies that must be loaded prior to importing this module
# RequiredAssemblies = @()

# Script files (.ps1) that are run in the caller's environment prior to importing this module.
 ScriptsToProcess = @(
"PoshRack-Init.ps1"
)

# Type files (.ps1xml) to be loaded when importing this module
# TypesToProcess = @()

# Format files (.ps1xml) to be loaded when importing this module
# FormatsToProcess = @()

# Modules to import as nested modules of the module specified in RootModule/ModuleToProcess
NestedModules =  @(
#"PoshRack-CloudMonitoring.psm1",
#"PoshRack-OpenStackDatabases.psm1",
#"PoshRack-OpenStackObjectStorage.psm1",
"PoshRack-LoadBalancers.psm1",
"PoshRack-Identity.psm1"
#"PoshRack-OpenStackBlockStorage.psm1",
#"PoshRack-OpenStackNetworks.psm1",
#"PoshRack-OpenStackCompute.psm1",
#"PoshRack-OpenStackDNS.psm1"
)

# Functions to export from this module
FunctionsToExport = '*'

# Cmdlets to export from this module
CmdletsToExport = '*'

# Variables to export from this module
VariablesToExport = '*'

# Aliases to export from this module
AliasesToExport = '*'

# List of all modules packaged with this module.
#ModuleList = @()

# List of all files packaged with this module
#FileList = @()

# Private data to pass to the module specified in RootModule/ModuleToProcess
# PrivateData = ''

# HelpInfo URI of this module
# HelpInfoURI = ''

# Default prefix for commands exported from this module. Override the default prefix using Import-Module -Prefix.
# DefaultCommandPrefix = ''

}

