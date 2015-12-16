#
# PoshRack_Networks.ps1
#

$RepoRoot = (Resolve-Path $PSScriptRoot\..\..).Path

$ModuleName = "PoshRack"
#Import-Module (Join-Path $RepoRoot "Modules\$ModuleName\$ModuleName-Networks.psm1") -Force;
Import-Module PoshRack

#$here = Split-Path -Parent $MyInvocation.MyCommand.Path
#$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path).Replace(".Tests.", ".")
#. "$here\$sut" 


Describe "Creation" {
	InModuleScope $ModuleName {

		$testdata = Get-RSNetwork -Account RackORD
	}
}

Describe "Get or List" {
	InModuleScope $ModuleName {

		$testdata = Get-RSNetwork -Account RackORD

		Context "Get a list of networks" {
			$result = Get-RSNetwork -Account RackORD
			It "Has multiple entries" {
				($result.Count -gt 1) | Should Be $True
			}
		}

		Context "Get a list of networks from a starting point" {
		}

		Context "Get a single network" {
		}

		Context "Get a list of all ports" {
		}
	}
}

Describe "Update" {
	InModuleScope $ModuleName {
	}
}

Describe "Delete" {
	InModuleScope $ModuleName {
		
		$testdata = Get-RSNetwork -Account rackORD
		
	}
}
