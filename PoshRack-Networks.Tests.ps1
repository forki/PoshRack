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

		$testdata = Get-RSNetwork -Account rackiad
		$testNetwork = $testdata | Where-Object {$_.Name -like "*TestNetwork*"} | Select-Object -First 1

		Context "New Network" {
			$result = Add-RSNetwork -Account "rackiad" -NetworkName "TestNetwork2" 
			It "Creates a network" {
				$result.Id | Should not be $null
			}
		}

		Context "New Port"{
			$result = Add-RSNetworkPort -Account rackiad -NetworkID $testNetwork.Id
			It "Has an invalid network id" {
				$result | Should Throw
			}

			It "Adds a port to the network" {
				$result.Id | Should not be $null
			}
		}

	}
}

Describe "Get or List" {
	InModuleScope $ModuleName {

		$testdata = Get-RSNetwork -Account rackiad
		$testNetwork = $testdata | Where-Object {$_.Name -like "*TestNetwork*"} | Select-Object -First 1

		Context "Get a list of networks" {
			$result = Get-RSNetwork -Account rackiad
			It "Has multiple entries" {
				($result.Count -gt 1) | Should Be $True
			}
		}

		Context "Get a list of networks from a starting point" {
			$result = Get-RSNetwork -Account rackiad -StartingNetworkID $testNetwork.Id
			It "Has multiple entries" {
				($result.Count -gt 1) | Should Be $True
			}
		}

		Context "Get a single network" {
			#$result = Get-RSNetwork -Account rackiad -NetworkID "fad2868a-46a9-4a5d-8f9b-5d251b40f51a" 
			$result = Get-RSNetwork -Account rackiad -NetworkID $testNetwork.Id 
			It "Finds the network" {
				$result.Count | Should Be 1
			}
		}

		Context "Get a list of all ports" {
			$result = Get-RSNetworkPort -Account rackiad
			It "Found the list" {
				($result.Count -gt 0) | Should Be $True
			}
		}
	}
}

Describe "Update" {
	InModuleScope $ModuleName {
		
		Context "Update a port" {
			$result = Get-RSNetworkPort -Account rackiad
			$before = $result[0]			
			$after = Update-RSNetworkPort -Account rackiad -PortID $before.Id -PortName "TestPort"
			It "Updated" {
				($before.Name -eq $after.Name) | Should Be $False
			}
		}

		Context "Update a subnet" {
			$result = Get-RSNetworkSubnet -Account rackiad 
			$before = $result[0]
			$after = Update-RSNetworkSubnet -Account rackiad -SubnetID $before.Id -SubnetName "TestSubnet"
			It "Updated" {
				($before.Name -eq $after.Name) | Should Be $False
			}
		}
	}
}

Describe "Delete" {
	InModuleScope $ModuleName {
		
		$testdata = Get-RSNetwork -Account rackiad
		$testNetwork = $testdata | Where-Object {$_.Name -like "*TestNetwork*"} | Select-Object -First 1
		
		Context "Delete a Subnet" {
			$result = Remove-RSNetworkSubnet -Account rackiad -SubnetID "c73077e1-3283-4a87-9fb6-5ef583817313"
			It "It is deleted" {
				$result.IsSuccessStatusCode | Should Be $True
			}
		}

		Context "Delete a network" {			
			$result = Remove-RSNetwork -Account rackiad -NetworkID $testNetwork.Id
			It "It is deleted" {
				$result.IsSuccessStatusCode | Should Be $True
			}
		}

		Context "Delete a Port" {
			$item = Get-RSNetworkPort -Account rackiad | Where-Object {$_.DeviceOwner -eq $null} | Select-Object -First 1
			$result = Remove-RSNetworkPort -Account rackiad -PortID $item.id
			$result.IsSuccessStatusCode | Should Be $True
		}
	}
}
