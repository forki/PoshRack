<############################################################################################

PoshRack
Networks

    
Description
-----------
**TODO**

############################################################################################>

function Get-RSNetworkService {
    Param(
        [Parameter (Mandatory=$True)] [string] $Account = $(throw "Please specify required Cloud Account by using the -Account parameter"),
        [Parameter (Mandatory=$false)] [string] $RegionOverride = $null
    )

    # The Account comes from the file RSCloudAccounts.csv

    Get-RSAccount -Account $Account
    if ($RegionOverride){
        $Global:RegionOverride = $RegionOverride
    }

    # Use Region code associated with Account, or was an override provided?
    if ($RegionOverride) {
        $Region = $Global:RegionOverride
    } else {
        $Region = $Credentials.Region
    }



    # Get Identity Provider
    $RSId    = New-Object net.openstack.Core.Domain.CloudIdentity
    $RSId.Username = $Credentials.RackspaceUsername
    $RSId.APIKey   = $Credentials.RackspaceAPIKey
    $Global:RSId = New-Object net.openstack.Providers.Rackspace.CloudIdentityProvider($RSId)
    $NetworkService = New-Object Rackspace.CloudNetworks.v2.CloudNetworkService($Global:RSId, $Region)
    Return $Networkservice
}

function New-RSNetwork {
    Param(
        [Parameter (Mandatory=$True)] [string] $Account = $(throw "Please specify the required Rackspace Account by using the -Account parameter"),
        [Parameter (Mandatory=$True)] [string] $NetworkName = $(throw "Network Name is required"),
        [Parameter (Mandatory=$False)][string] $RegionOverride
    )

    Get-RSAccount -Account $Account
    
    if ($RegionOverride){
        $Global:RegionOverride = $RegionOverride
    }

    # Use Region code associated with Account, or was an override provided?
    if ($RegionOverride) {
        $Region = $Global:RegionOverride
    } else {
        $Region = $Credentials.Region
    }


    $NetworkService = Get-RSNetworkService -Account $Account -RegionOverride $Region

    try {

        # DEBUGGING       
        Write-Debug -Message "New-RSNetwork"
        Write-Debug -Message "Account.........................: $Account" 
        Write-Debug -Message "NetworkName.....................: $NetworkName"
        Write-Debug -Message "Region..........................: $Region" 

        $CancellationToken = New-Object ([System.Threading.CancellationToken]::None)
        $NetworkDefinition = New-Object Rackspace.CloudNetworks.v2.NetworkDefinition
        $NetworkDefinition.Name = $NetworkName
        $NetworkService.CreateNetworkAsync($NetworkDefinition, $CancellationToken).Result

    }
    catch {
        Invoke-Exception($_.Exception)
    }
}

function Get-RSNetwork {
    Param(
        [Parameter (Mandatory=$True)] [string] $Account = $(throw "Please specify the required Rackspace Account by using the -Account parameter"),
        [Parameter (Mandatory=$False)][string] $RegionOverride
    )

    Get-RSAccount -Account $Account
    
    if ($RegionOverride){
        $Global:RegionOverride = $RegionOverride
    }

    # Use Region code associated with Account, or was an override provided?
    if ($RegionOverride) {
        $Region = $Global:RegionOverride
    } else {
        $Region = $Credentials.Region
    }


    $NetworkService = Get-RSNetworkService -Account $Account -RegionOverride $Region

    try {

        # DEBUGGING       
        Write-Debug -Message "Get-RSNetwork"
        Write-Debug -Message "Account.........................: $Account" 
        Write-Debug -Message "Region..........................: $Region" 

        $CancellationToken = New-Object ([System.Threading.CancellationToken]::None)
        $Start = New-Object -TypeName Rackspace.Identifier -ArgumentList @("ee9f1b13-47c9-42de-bece-cea26c910387")
        [System.Nullable``1[[System.Int32]]] $pageSize = 99
        
       $NetworkService.ListNetworksAsync($null, $pageSize, $CancellationToken).Result
        
    }
    catch {
        Invoke-Exception($_.Exception)
    }
<#
 .SYNOPSIS

 .DESCRIPTION
 
 .PARAMETER Account
 Use this parameter to indicate which account you would like to execute this request against.
 Valid choices are defined in PoshRack configuration file.

 .PARAMETER RegionOverride
 This parameter will temporarily override the default region set in PoshRack configuration file.

 .EXAMPLE
 PS C:\Users\Administrator>


 .LINK
 http://api.rackspace.com/api-ref-load-balancers.html
#>
}

function Add-RSNetworkPort {
    Param(
        [Parameter (Mandatory=$True)] [string]   $Account           = $(throw "Please specify the required Rackspace Account by using the -Account parameter"),
        [Parameter (Mandatory=$True)] [string]   $NetworkID         = $(throw "Port ID is required"),
        [Parameter (Mandatory=$False)][string]   $DeviceID          = $null,
        [Parameter (Mandatory=$False)][string]   $DeviceOwner       = $null,
        [Parameter (Mandatory=$False)][string[]] $IPAddressList     = $null,
        [Parameter (Mandatory=$False)][string]   $PortName          = $null,
        [Parameter (Mandatory=$False)][string[]] $SecurityGroupList = $null,
        [Parameter (Mandatory=$False)][string]   $RegionOverride
    )

    Get-RSAccount -Account $Account
    
    if ($RegionOverride){
        $Global:RegionOverride = $RegionOverride
    }

    # Use Region code associated with Account, or was an override provided?
    if ($RegionOverride) {
        $Region = $Global:RegionOverride
    } else {
        $Region = $Credentials.Region
    }


    $NetworkService = Get-RSNetworkService -Account $Account -RegionOverride $Region

    try {

        # DEBUGGING       
        Write-Debug -Message "Add-RSNetworkPort"
        Write-Debug -Message "Account.........................: $Account" 
        Write-Debug -Message "DeviceID........................: $DeviceID"
        Write-Debug -Message "NetworkID.......................: $NetworkID"
        Write-Debug -Message "Region..........................: $Region" 

        $CancellationToken = New-Object ([System.Threading.CancellationToken]::None)

        $_networkid = New-Object -TypeName ([Rackspace.Identifier]) -ArgumentList $NetworkID
        $_portDefinition = New-Object -TypeName ([Rackspace.CloudNetworks.v2.PortCreateDefinition]) -ArgumentList $_networkid

        if (![string]::IsNullOrEmpty($DeviceID)) {
            $_portDefinition.DeviceId = $DeviceID
        }

        if (![string]::IsNullOrEmpty($PortName)) {
            $_portDefinition.Name = $PortName
        }

        if (![string]::IsNullOrEmpty($DeviceOwner)) {
            $_portDefinition.DeviceOwner = $DeviceOwner
        }

        if (![string]::IsNullOrEmpty($IPAddressList)) {
            $_portDefinition.FixedIPs = $IPAddressList
        }

        if (![string]::IsNullOrEmpty($SecurityGroupList)) {
            $_portDefinition.SecuityGroups = $SecurityGroupList
        }

        $NetworkService.CreatePortAsync($_portDefinition, $CancellationToken).Result

    }
    catch {
        Invoke-Exception($_.Exception)
    }
}

function Add-RSNetworkSubnet {
    Param(
        [Parameter (Mandatory=$True)] [string]   $Account           = $(throw "Please specify the required Rackspace Account by using the -Account parameter"),
        [Parameter (Mandatory=$True)] [string]   $NetworkID         = $(throw "Network ID is required"),
        [Parameter (Mandatory=$False)][string] [ValidateSet("IPv4","IPv6")]   $IPVersion         = "IPv4" ,
        [Parameter (Mandatory=$True)] [string]   $CIDR              = $null,
        [Parameter (Mandatory=$False)][string]   $RegionOverride
    )

    Get-RSAccount -Account $Account
    
    if ($RegionOverride){
        $Global:RegionOverride = $RegionOverride
    }

    # Use Region code associated with Account, or was an override provided?
    if ($RegionOverride) {
        $Region = $Global:RegionOverride
    } else {
        $Region = $Credentials.Region
    }


    $NetworkService = Get-RSNetworkService -Account $Account -RegionOverride $Region

    try {

        # DEBUGGING       
        Write-Debug -Message "Add-RSNetworkSubnet"
        Write-Debug -Message "Account.........................: $Account" 
        Write-Debug -Message "CIDR............................: $CIDR"
        Write-Debug -Message "NetworkID.......................: $NetworkID"
        Write-Debug -Message "Region..........................: $Region" 

        $CancellationToken = New-Object ([System.Threading.CancellationToken]::None)

        $_networkid = New-Object -TypeName ([Rackspace.Identifier]) -ArgumentList @($NetworkID)
# For some reason the following line wasn't working, so I replaced it by using If statement right after it.
# $_ipversion = New-Object ([Rackspace.CloudNetworks.IPVersion]::IPv4)
        if ($IPVersion = "IPv4") {
            $_subnetDefinition = New-Object -TypeName ([Rackspace.CloudNetworks.v2.SubnetCreateDefinition]) -ArgumentList @($_networkid, ([Rackspace.CloudNetworks.IPVersion]::IPv4), $CIDR)
        } else {
            $_subnetDefinition = New-Object -TypeName ([Rackspace.CloudNetworks.v2.SubnetCreateDefinition]) -ArgumentList @($_networkid, ([Rackspace.CloudNetworks.IPVersion]::IPv6), $CIDR)
        }
        $NetworkService.CreateSubnetAsync($_subnetDefinition, $CancellationToken).Result

    }
    catch {
        Invoke-Exception($_.Exception)
    }
}

function Get-RSNetworkPort {
    Param(
        [Parameter (Mandatory=$True)] [string]   $Account           = $(throw "Please specify the required Rackspace Account by using the -Account parameter"),
        [Parameter (Mandatory=$False)][string]   $StartingPortID    = $null,
        [Parameter (Mandatory=$False)][int]      $PageSize          = 99,
        [Parameter (Mandatory=$False)][string]   $RegionOverride
    )

    Get-RSAccount -Account $Account
    
    if ($RegionOverride){
        $Global:RegionOverride = $RegionOverride
    }

    # Use Region code associated with Account, or was an override provided?
    if ($RegionOverride) {
        $Region = $Global:RegionOverride
    } else {
        $Region = $Credentials.Region
    }


    $NetworkService = Get-RSNetworkService -Account $Account -RegionOverride $Region

    try {

        # DEBUGGING       
        Write-Debug -Message "Get-RSNetworkPort"
        Write-Debug -Message "Account.........................: $Account" 
        Write-Debug -Message "StartingPortID..................: $StartingPortID"
        Write-Debug -Message "PageSize........................: $PageSize"
        Write-Debug -Message "Region..........................: $Region" 

        $CancellationToken = New-Object ([System.Threading.CancellationToken]::None)

        if (![string]::IsNullOrEmpty($StartingPortID)) {
            $_startingPortID = New-Object Rackspace.Identifier $StartingPortID
        }

        $NetworkService.ListPortsAsync($_startingPortID, $PageSize, $CancellationToken).Result

    }
    catch {
        Invoke-Exception($_.Exception)
    }
}

function Get-RSNetworkSubnet {
    [CmdletBinding()]
    Param(
        [Parameter(ParameterSetName="List", Mandatory=$True)]
        [Parameter(ParameterSetName="Subnet", Mandatory=$True)]
        [string]   $Account           = $(throw "Please specify the required Rackspace Account by using the -Account parameter"),

        [Parameter(ParameterSetName="List", Mandatory=$False)]
        [Parameter(ParameterSetName="Subnet", Mandatory=$False)]
        [string]   $RegionOverride,

        [Parameter(ParameterSetName="Subnet", Mandatory=$True)]
        [string]   $SubnetID  = $null,

        [Parameter(ParameterSetName="List", Mandatory=$False)]
        [int]      $PageSize          = 99,

        [Parameter(ParameterSetName="List", Mandatory=$False)]
        [string]   $StartingSubnetID  = $null
    )

    Get-RSAccount -Account $Account
    
    if ($RegionOverride){
        $Global:RegionOverride = $RegionOverride
    }

    # Use Region code associated with Account, or was an override provided?
    if ($RegionOverride) {
        $Region = $Global:RegionOverride
    } else {
        $Region = $Credentials.Region
    }


    $NetworkService = Get-RSNetworkService -Account $Account -RegionOverride $Region

    try {

        # DEBUGGING       
        Write-Debug -Message "Get-RSNetworkSubnet"
        Write-Debug -Message $PsCmdlet.ParameterSetName
        Write-Debug -Message "Account.........................: $Account" 
        Write-Debug -Message "StartingSubnetID................: $StartingSubnetID"
        Write-Debug -Message "SubnetID........................: $SubnetID"
        Write-Debug -Message "PageSize........................: $PageSize"
        Write-Debug -Message "Region..........................: $Region" 
        
        $CancellationToken = New-Object ([System.Threading.CancellationToken]::None)

        switch ($PsCmdlet.ParameterSetName) {
            "List" {
                if (![string]::IsNullOrEmpty($StartingSubnetID)) {
                    $_startingSubnetID = New-Object Rackspace.Identifier $StartingSubnetID
                    $NetworkService.ListSubnetsAsync($_startingSubnetID, $PageSize, $CancellationToken).Result
                } else {
                    $NetworkService.ListSubnetsAsync($null, $PageSize, $CancellationToken).Result
                }
            }
            "Subnet" {
                $_subnetID = New-Object Rackspace.Identifier $SubnetID
                $NetworkService.GetSubnetAsync($_subnetID, $CancellationToken).Result
            }
        }
    }
    catch {
        Invoke-Exception($_.Exception)
    }
}

function Update-RSNetwork {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$True)]
        [string]   $Account = $(throw "Please specify the required Rackspace Account by using the -Account parameter"),
        [Parameter(Mandatory=$True)]
        [string]   $NetworkID = $(throw "The -NetworkID parameter is required"),
        [Parameter(Mandatory=$False)]
        [string]   $RegionOverride,
        [Parameter(Mandatory=$True)]
        [string]   $Name  = $(throw "The -Name parameter is required")
    )

    Get-RSAccount -Account $Account
    
    if ($RegionOverride){
        $Global:RegionOverride = $RegionOverride
    }

    # Use Region code associated with Account, or was an override provided?
    if ($RegionOverride) {
        $Region = $Global:RegionOverride
    } else {
        $Region = $Credentials.Region
    }


    $NetworkService = Get-RSNetworkService -Account $Account -RegionOverride $Region

    try {

        # DEBUGGING       
        Write-Debug -Message "Update-RSNetwork"
        Write-Debug -Message "Account.........................: $Account" 
        Write-Debug -Message "NetworkID.......................: $NetworkID" 
        Write-Debug -Message "Name............................: $Name" 
        Write-Debug -Message "Region..........................: $Region" 
        
        $CancellationToken = New-Object ([System.Threading.CancellationToken]::None)

        $_networkid = New-Object Rackspace.Identifier $NetworkID

        $NetworkDefinition = New-Object ([Rackspace.CloudNetworks.v2.NetworkDefinition])
        $NetworkDefinition.Name = $Name

        $NetworkService.UpdateNetworkAsync($_networkid, $NetworkDefinition, $CancellationToken).Result

    }
    catch {
        Invoke-Exception($_.Exception)
    }
}

Export-ModuleMember -Function *
