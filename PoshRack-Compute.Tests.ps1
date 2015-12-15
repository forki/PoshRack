
$RepoRoot = (Resolve-Path $PSScriptRoot\..\..).Path

$ModuleName = "PoshRack"
#Import-Module (Join-Path $RepoRoot "Modules\$ModuleName\$ModuleName-Networks.psm1") -Force;
Import-Module PoshRack

#$here = Split-Path -Parent $MyInvocation.MyCommand.Path
#$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path).Replace(".Tests.", ".")
#. "$here\$sut" 



Describe "Compute List Functions" {
	InModuleScope $ModuleName {

		$t_account = "rackORD"

		Context "List Compute Images NO details" {
			$t_imageList = Get-RSImage -Account $t_account
			It "Gets a list of Compute Images" {
				($t_imageList.Count -gt 0) | Should Be $True
			}
		}
		Context "List Compute Images with details" {
			$t_imageList = Get-RSImage -Account $t_account -Details
			It "Gets a list of Compute Images" {
				($t_imageList.Count -gt 0) | Should Be $True
			}
		}
	}
}
