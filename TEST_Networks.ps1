Remove-Module PoshRack
clear
Import-Module PoshRack

Write-Host "Creating a new network called ViaPoshRack..."
#New-RSNetwork -Account rackiad -NetworkName "ViaPoshRack" 

Write-Host "Creating port..."
#Add-RSNetworkPort -Account rackiad -NetworkID "7fc02848-ffc6-4f29-8e72-04bf4f597c0d" -PortName "TestPort" 

Write-Host "Retrieving a list of ports..."
#Get-RSNetworkPort -Account rackiad -StartingPortID "63a140d4-77f2-45aa-8a9b-46f6f3d33e29"

Write-Host "Creating subnet..."
#Add-RSNetworkSubnet -IPVersion IPv4 -Account rackiad -NetworkID "7fc02848-ffc6-4f29-8e72-04bf4f597c0d" -CIDR "10.2.0.0/24" 

Write-Host "Retrieving a list of subnets..."
#Get-RSNetworkSubnet -Account rackiad  
#Get-RSNetworkSubnet -Account rackiad -StartingSubnetID  "c73077e1-3283-4a87-9fb6-5ef583817313" 
Get-RSNetworkSubnet -Account rackiad -SubnetID  "de6ab790-1b76-492e-8752-2b3c17952b4f"

Update-RSNetwork -Account rackiad -NetworkID 7fc02848-ffc6-4f29-8e72-04bf4f597c0d -Name "FormerPoshRack"


Write-Host "Retrieving a list of Networks..."
$list = Get-RSNetwork -Account Rackiad
Write-Host $list.length "networks found."
foreach ($l in $list) {
    Write-Host "NetworkName:" $l.Name
    Write-Host "NetworkID:" $l.Id
}
