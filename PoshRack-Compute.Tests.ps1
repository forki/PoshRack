
$RepoRoot = (Resolve-Path $PSScriptRoot\..\..).Path

$ModuleName = "PoshRack"
#Import-Module (Join-Path $RepoRoot "Modules\$ModuleName\$ModuleName-Networks.psm1") -Force;
Import-Module PoshRack

#$here = Split-Path -Parent $MyInvocation.MyCommand.Path
#$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path).Replace(".Tests.", ".")
#. "$here\$sut" 



Describe "Compute Create Functions" {
	InModuleScope $ModuleName {
		
		Context "Create a server" {

		}
	}
}

Describe "Compute List Functions" {
	InModuleScope $ModuleName {

		Context "List Compute Images NO details" {
			$t_imageList = Get-RSComputeImage
			It "Gets a list of Compute Images" {
				($t_imageList.Count -gt 0) | Should Be $True
			}
		}
		Context "List Compute Images with details" {
			$t_imageList = Get-RSComputeImage -Details
			It "Gets a list of Compute Images" {
				($t_imageList.Count -gt 0) | Should Be $True
			}
		}
		Context "List only 11 Compute Images" {
			$t_imagelist = Get-RSComputeImage -Limit 11
			It "Gets only 11 images" {
				$t_imagelist.Count | Should BeExactly 11
			}
		}
		Context "Get one and only one Compute Image from ORD" {
			$t_image = Get-RSComputeImage -RegionOverride ORD | Select-Object -first 1
			$t = Get-RSComputeImage -ImageId $t_image.id
			It "Get a Compute Image" {
				$t | Should Not BeNullOrEmpty
			}
			It "Does not get more than one Compute Image" {
				$t.Count | Should Be 1
			}
			It "Includes the Region" {
				$t.Region | Should Be 'ORD'
			}
		}
		Context "Get Compute Images from Region SYD" {
			$t_image = Get-RSComputeImage -RegionOverride SYD | Select-Object -First 1
			It "Get Compute Images from SYD" {
				$t_image.Region | Should Be 'SYD'
			}
		}
		Context "Get a list of Compute Flavors" {
#			$t_flavorlist = Get-RSComputeFlavor
#			It "Gets a list of Compute Flavors" {
#				($t_flavorlist.Count -gt 0) | Should Be $True
#			}
		}
	}
}
