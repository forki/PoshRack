<############################################################################################

PoshRack
Load Balancers

    
Description
-----------
**TODO**

############################################################################################>

function Get-RSLBProvider {
    Param(
        [Parameter (Mandatory=$True)] [string] $Account = $(throw "Please specify required Cloud Account by using the -Account parameter"),
        [Parameter (Mandatory=$false)] [string] $RegionOverride = $null
    )

    # The Account comes from the file CloudAccounts.csv
    # It has information regarding credentials and the type of provider (Generic or Rackspace)

    Get-OpenStackAccount -Account $Account
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
    $cloudId    = New-Object net.openstack.Core.Domain.CloudIdentity
    $cloudId.Username = $Credentials.CloudUsername
    $cloudId.APIKey   = $Credentials.CloudAPIKey
    $Global:CloudId = New-Object net.openstack.Providers.Rackspace.CloudIdentityProvider($cloudId)
    Return New-Object net.openstack.Providers.Rackspace.CloudLoadBalancerProvider($cloudId, $Region, $null)
}

# Issue 49 Implement Add-CloudLoadBalancerMetadata
function Add-RSLBMetadata {
    Param(
        [Parameter (Mandatory=$True)] [string] $Account = $(throw "Please specify required Cloud Account by using the -Account parameter"),
        [Parameter (Mandatory=$True)] [net.openstack.Providers.Rackspace.Objects.LoadBalancers.LoadBalancerId] $LBID = $(throw "Please specify the required Load Balancer ID by using the -LBID parameter"),
        [Parameter (Mandatory=$True)] [string[]] $Metadata = $(throw "Please specify the required metadata by using the -Metadata parameter"),
        [Parameter (Mandatory=$False)][bool]   $WaitForTask = $False,
        [Parameter (Mandatory=$False)][string] $RegionOverride
    )

    Get-OpenStackAccount -Account $Account
    
    if ($RegionOverride){
        $Global:RegionOverride = $RegionOverride
    }

    # Use Region code associated with Account, or was an override provided?
    if ($RegionOverride) {
        $Region = $Global:RegionOverride
    } else {
        $Region = $Credentials.Region
    }


    $LBProvider = Get-RSLBProvider -Account rackiad -RegionOverride $Region

    try {

        # DEBUGGING       
        Write-Debug -Message "Add-RSLBMetadata"
        Write-Debug -Message "Account.........................: $Account" 
        Write-Debug -Message "LBID............................: $LBID"
        Write-Debug -Message "Metaadata.......................: $Metadata"
        Write-Debug -Message "WaitForTask.....................: $WaitForTask" 
        Write-Debug -Message "Region..........................: $Region" 

        $CancellationToken = New-Object ([System.Threading.CancellationToken]::None)

        if($WaitForTask) {
            $LBProvider.AddLoadBalancerMetadataAsync($LBID, $Metadata, [net.openstack.Core.AsyncCompletionOption]::RequestCompleted, $CancellationToken, $null).Result
        } else {
            $LBProvider.AddLoadBalancerMetadataAsync($LBID, $Metadata, [net.openstack.Core.AsyncCompletionOption]::RequestSubmitted, $CancellationToken, $null).Result
        }

    }
    catch {
        Invoke-Exception($_.Exception)
    }
<#
 .SYNOPSIS
 Add metadata

 .DESCRIPTION
 The Add-RSLBMetadata cmdlet will add metadata to an existing Load Balancer.
 
 .PARAMETER Account
 Use this parameter to indicate which account you would like to execute this request against.
 Valid choices are defined in PoshRack configuration file.

 .PARAMETER LBID
 An object of type net.openstack.Providers.Rackspace.Objects.LoadBalancers.LoadBalancerID that identifies the existing Load Balancer.
 
 .PARAMETER Metadata
 An array of key-value pairs containing the metadata.

 .PARAMETER WaitForTask
 Use this parameter to specify whether you want to wait for the task to complete or return control to the script immediately.

 .PARAMETER RegionOverride
 This parameter will temporarily override the default region set in PoshRack configuration file.

 .EXAMPLE
 PS C:\Users\Administrator>


 .LINK
 http://api.rackspace.com/api-ref-load-balancers.html
#>
}

# Issue 50 Implement Add-CloudLoadBalancerNode
function Add-RSLBNode {
    Param(
        [Parameter (Mandatory=$True)] [string] $Account = $(throw "Please specify required Cloud Account by using the -Account parameter"),
        [Parameter (Mandatory=$True)] [net.openstack.Providers.Rackspace.Objects.LoadBalancers.LoadBalancerId] $LBID = $(throw "Please specify the required Load Balancer ID by using the -LBID parameter"),
        [Parameter (Mandatory=$True)] [net.openstack.Providers.Rackspace.Objects.LoadBalancers.NodeConfiguration] $NodeConfig = $(throw "Please specify the required Node Configuration by using the -NodeConfig parameter"),
        [Parameter (Mandatory=$False)][bool]   $WaitForTask = $False,
        [Parameter (Mandatory=$False)][string] $RegionOverride
    )

    Get-OpenStackAccount -Account $Account
    
    if ($RegionOverride){
        $Global:RegionOverride = $RegionOverride
    }

    # Use Region code associated with Account, or was an override provided?
    if ($RegionOverride) {
        $Region = $Global:RegionOverride
    } else {
        $Region = $Credentials.Region
    }


    $LBProvider = Get-RSLBProvider -Account rackiad -RegionOverride $Region

    try {

        # DEBUGGING       
        Write-Debug -Message "Add-RSLBNode"
        Write-Debug -Message "Account.........................: $Account" 
        Write-Debug -Message "LBID............................: $LBID"
        Write-Debug -Message "NodeConfig......................: $NodeConfig"
        Write-Debug -Message "WaitForTask.....................: $WaitForTask" 
        Write-Debug -Message "Region..........................: $Region" 

        $CancellationToken = New-Object ([System.Threading.CancellationToken]::None)

        if($WaitForTask) {
            $LBProvider.AddNodeAsync($LBID, $NodeConfig, [net.openstack.Core.AsyncCompletionOption]::RequestCompleted, $CancellationToken, $null).Result
        } else {
            $LBProvider.AddNodeAsync($LBID, $NodeConfig, [net.openstack.Core.AsyncCompletionOption]::RequestSubmitted, $CancellationToken, $null).Result
        }

    }
    catch {
        Invoke-Exception($_.Exception)
    }
<#
 .SYNOPSIS
 Add LB Node

 .DESCRIPTION
 The Add-RSLBNode cmdlet will add a Node to an existing Load Balancer.
 
 .PARAMETER Account
 Use this parameter to indicate which account you would like to execute this request against.
 Valid choices are defined in PoshRack configuration file.

 .PARAMETER LBID
 An object of type net.openstack.Providers.Rackspace.Objects.LoadBalancers.LoadBalancerID that identifies the existing Load Balancer.
 
 .PARAMETER NodeConfig
 An object of type net.openstack.Providers.Rackspace.Objects.LoadBalancers.NodeConfiguration that contains configuration data for new new Node.

 .PARAMETER WaitForTask
 Use this parameter to specify whether you want to wait for the task to complete or return control to the script immediately.

 .PARAMETER RegionOverride
 This parameter will temporarily override the default region set in PoshRack configuration file.

 .EXAMPLE
 PS C:\Users\Administrator>


 .LINK
 http://api.rackspace.com/api-ref-load-balancers.html
#>
}

# Issue 51 Implement Add-CloudLoadBalancerNodeMetadata
function Add-RSLBNodeMetadata {
    Param(
        [Parameter (Mandatory=$True)] [string] $Account = $(throw "Please specify required Cloud Account by using the -Account parameter"),
        [Parameter (Mandatory=$True)] [net.openstack.Providers.Rackspace.Objects.LoadBalancers.LoadBalancerId] $LBID = $(throw "Please specify the required Load Balancer ID by using the -LBID parameter"),
        [Parameter (Mandatory=$True)] [net.openstack.Providers.Rackspace.Objects.LoadBalancers.NodeId] $NodeID = $(throw "Please specify the required Node ID by using the -NodeID parameter"),
        [Parameter (Mandatory=$True)] [string[]] $Metadata = $(throw "Please specify the required metadata by using the -Metadata parameter"),
        [Parameter (Mandatory=$False)][string] $RegionOverride
    )

    Get-OpenStackAccount -Account $Account
    
    if ($RegionOverride){
        $Global:RegionOverride = $RegionOverride
    }

    # Use Region code associated with Account, or was an override provided?
    if ($RegionOverride) {
        $Region = $Global:RegionOverride
    } else {
        $Region = $Credentials.Region
    }


    $LBProvider = Get-RSLBProvider -Account rackiad -RegionOverride $Region

    try {

        # DEBUGGING       
        Write-Debug -Message "New-RSLBNodeMetadatda"
        Write-Debug -Message "Account.........................: $Account" 
        Write-Debug -Message "LBID............................: $LBID"
        Write-Debug -Message "NodeID..........................: $NodeID"
        Write-Debug -Message "Metadata........................: $Metadata"
        Write-Debug -Message "WaitForTask.....................: $WaitForTask" 
        Write-Debug -Message "Region..........................: $Region" 

        $CancellationToken = New-Object ([System.Threading.CancellationToken]::None)

        if($WaitForTask) {
            $LBProvider.AddNodeMetadataAsync($LBID, $NodeID, $Metadata, [net.openstack.Core.AsyncCompletionOption]::RequestCompleted, $CancellationToken, $null).Result
        } else {
            $LBProvider.AddNodeMetadataAsync($LBID, $NodeID, $Metadata, [net.openstack.Core.AsyncCompletionOption]::RequestSubmitted, $CancellationToken, $null).Result
        }

    }
    catch {
        Invoke-Exception($_.Exception)
    }
<#
 .SYNOPSIS
 Add metadata to node

 .DESCRIPTION
 The New-RSLBNodeMetadata cmdlet will add metadata to an existing Load Balancer Node.
 
 .PARAMETER Account
 Use this parameter to indicate which account you would like to execute this request against.
 Valid choices are defined in PoshRack configuration file.

 .PARAMETER LBID
 An object of type net.openstack.Providers.Rackspace.Objects.LoadBalancers.LoadBalancerId that identifies the Load Balancer.

 .PARAMETER NodeID
 An object of type net.openstack.Providers.Rackspace.Objects.LoadBalancers.NodeId that identifies the Node.

 .PARAMETER Metadata
 An array of key-value pairs that contains the metadata.
 
 .PARAMETER WaitForTask
 Use this parameter to specify whether you want to wait for the task to complete or return control to the script immediately.

 .PARAMETER RegionOverride
 This parameter will temporarily override the default region set in PoshRack configuration file.

 .EXAMPLE
 PS C:\Users\Administrator>


 .LINK
 http://api.rackspace.com/api-ref-load-balancers.html
#>
}

# Issue 52 Implement Add-CloudLoadBalancerNodeRange
function Add-RSLBNodeRange {
    Param(
        [Parameter (Mandatory=$True)] [string] $Account = $(throw "Please specify required Cloud Account by using the -Account parameter"),
        [Parameter (Mandatory=$True)] [net.openstack.Providers.Rackspace.Objects.LoadBalancers.LoadBalancerId] $LBID = $(throw "Please specify the required Load Balancer ID by using the -LBID parameter"),
        [Parameter (Mandatory=$True)] [net.openstack.Providers.Rackspace.Objects.LoadBalancers.NodeConfiguration[]] $NodeConfigurations = $(throw "Please specify the required Node Configurations by using the -NodeConfigurations parameter"),
        [Parameter (Mandatory=$False)][bool]   $WaitForTask = $False,
        [Parameter (Mandatory=$False)][string] $RegionOverride
    )

    Get-OpenStackAccount -Account $Account
    
    if ($RegionOverride){
        $Global:RegionOverride = $RegionOverride
    }

    # Use Region code associated with Account, or was an override provided?
    if ($RegionOverride) {
        $Region = $Global:RegionOverride
    } else {
        $Region = $Credentials.Region
    }


    $LBProvider = Get-RSLBProvider -Account rackiad -RegionOverride $Region

    try {

        # DEBUGGING       
        Write-Debug -Message "Add-RSLBNodeRange"
        Write-Debug -Message "Account.........................: $Account" 
        Write-Debug -Message "LBID............................: $LBID"
        Write-Debug -Message "NodeConfigurations..............: $NodeConfigurations"
        Write-Debug -Message "WaitForTask.....................: $WaitForTask" 
        Write-Debug -Message "Region..........................: $Region" 

        $CancellationToken = New-Object ([System.Threading.CancellationToken]::None)

        if($WaitForTask) {
            $LBProvider.AddNodeRangeAsync($LBID, $NodeConfigurations, [net.openstack.Core.AsyncCompletionOption]::RequestCompleted, $CancellationToken, $null).Result
        } else {
            $LBProvider.AddNodeRangeAsync($LBID, $NodeConfigurations, [net.openstack.Core.AsyncCompletionOption]::RequestSubmitted, $CancellationToken, $null).Result
        }

    }
    catch {
        Invoke-Exception($_.Exception)
    }
<#
 .SYNOPSIS
 Add node range

 .DESCRIPTION
 The Add-RSLBNodeRange cmdlet will add one or more nodes to a load balancer.
 
 .PARAMETER Account
 Use this parameter to indicate which account you would like to execute this request against.
 Valid choices are defined in PoshRack configuration file.

 .PARAMETER LBID
 An object of type net.openstack.Providers.Rackspace.Objects.LoadBalancers.LoadBalancerId that identifies the Load Balancer.

 .PARAMETER NodeConfigurations
 An array of objects of type net.openstack.Providers.Rackspace.Objects.LoadBalancers.NodeConfiguration containing the nodes to be added.
 
 .PARAMETER WaitForTask
 Use this parameter to specify whether you want to wait for the task to complete or return control to the script immediately.

 .PARAMETER RegionOverride
 This parameter will temporarily override the default region set in PoshRack configuration file.

 .EXAMPLE
 PS C:\Users\Administrator>


 .LINK
 http://api.rackspace.com/api-ref-load-balancers.html
#>
}

# Issue 53 Implement Add-CloudLoadBalancerVirtualAddress
function Add-RSLBVirtualAddress {
    Param(
        [Parameter (Mandatory=$True)] [string] $Account = $(throw "Please specify required Cloud Account by using the -Account parameter"),
        [Parameter (Mandatory=$True)] [net.openstack.Providers.Rackspace.Objects.LoadBalancers.LoadBalancerId] $LBID = $(throw "Please specify the required Load Balancer ID by using the -LBID parameter"),
        [Parameter (Mandatory=$True)] [net.openstack.Providers.Rackspace.Objects.LoadBalancers.LoadBalancerVirtualAddressType] $LBVirtAddrType = $(throw "Please specify the required Load Balancer Virtual Address Type to using the -LBVirtAddrType parameter"),
        [Parameter (Mandatory=$True)] [System.Net.Sockets.AddressFamily] $AddressFamily = $(throw "Please specify the required Address Family by using the required -AddressFamily parameter"),
        [Parameter (Mandatory=$False)][bool]   $WaitForTask = $False,
        [Parameter (Mandatory=$False)][string] $RegionOverride
    )

    Get-OpenStackAccount -Account $Account
    
    if ($RegionOverride){
        $Global:RegionOverride = $RegionOverride
    }

    # Use Region code associated with Account, or was an override provided?
    if ($RegionOverride) {
        $Region = $Global:RegionOverride
    } else {
        $Region = $Credentials.Region
    }


    $LBProvider = Get-RSLBProvider -Account rackiad -RegionOverride $Region

    try {

        # DEBUGGING       
        Write-Debug -Message "Add-RSLBVirtualAddress"
        Write-Debug -Message "Account.........................: $Account" 
        Write-Debug -Message "LBID............................: $LBID"
        Write-Debug -Message "LBVirtAddrType..................: $LBVirtAddrType"
        Write-Debug -Message "AddressType.....................: $AddressType"
        Write-Debug -Message "WaitForTask.....................: $WaitForTask" 
        Write-Debug -Message "Region..........................: $Region" 

        $CancellationToken = New-Object ([System.Threading.CancellationToken]::None)

        if($WaitForTask) {
            $LBProvider.AddVirtualAddressAsync($LBID, $LBVirtAddrType, $AddressFamily, [net.openstack.Core.AsyncCompletionOption]::RequestCompleted, $CancellationToken, $null).Result
        } else {
            $LBProvider.AddVirtualAddressAsync($LBID, $LBVirtAddrType, $AddressFamily, [net.openstack.Core.AsyncCompletionOption]::RequestSubmitted, $CancellationToken, $null).Result
        }

    }
    catch {
        Invoke-Exception($_.Exception)
    }
<#
 .SYNOPSIS
 Create Load Balancer

 .DESCRIPTION
 The New-OpenStackLoadBalancer cmdlet will create a new load balancer.
 
 .PARAMETER Account
 Use this parameter to indicate which account you would like to execute this request against.
 Valid choices are defined in PoshRack configuration file.

 .PARAMETER LBConfig
 An object of type net.openstack.Providers.Rackspace.Objects.LoadBalancers.LoadBalancerConfiguration that describes the new Load Balancer.
 
 .PARAMETER WaitForTask
 Use this parameter to specify whether you want to wait for the task to complete or return control to the script immediately.

 .PARAMETER RegionOverride
 This parameter will temporarily override the default region set in PoshRack configuration file.

 .EXAMPLE
 PS C:\Users\Administrator>


 .LINK
 http://api.rackspace.com/api-ref-load-balancers.html
#>
}

# Issue 54 Implement Clear-CloudLoadBalancerAccessList
function Clear-RSLBAccessList {
    Param(
        [Parameter (Mandatory=$True)] [string] $Account = $(throw "Please specify required Cloud Account by using the -Account parameter"),
        [Parameter (Mandatory=$True)] [net.openstack.Providers.Rackspace.Objects.LoadBalancers.LoadBalancerId] $LBID = $(throw "Please specify the required Load Balancer ID by using the -LBID parameter"),
        [Parameter (Mandatory=$False)][bool]   $WaitForTask = $False,
        [Parameter (Mandatory=$False)][string] $RegionOverride
    )

    Get-OpenStackAccount -Account $Account
    
    if ($RegionOverride){
        $Global:RegionOverride = $RegionOverride
    }

    # Use Region code associated with Account, or was an override provided?
    if ($RegionOverride) {
        $Region = $Global:RegionOverride
    } else {
        $Region = $Credentials.Region
    }


    $LBProvider = Get-RSLBProvider -Account rackiad -RegionOverride $Region

    try {

        # DEBUGGING       
        Write-Debug -Message "Clear-RSLBAccessList"
        Write-Debug -Message "Account.........................: $Account" 
        Write-Debug -Message "LBID............................: $LBID"
        Write-Debug -Message "WaitForTask.....................: $WaitForTask"
        Write-Debug -Message "Region..........................: $Region" 

        $CancellationToken = New-Object ([System.Threading.CancellationToken]::None)

        if($WaitForTask) {
            $LBProvider.ClearAccessListAsync($LBID, [net.openstack.Core.AsyncCompletionOption]::RequestCompleted, $CancellationToken, $null).Result
        } else {
            $LBProvider.ClearAccessListAsync($LBID, [net.openstack.Core.AsyncCompletionOption]::RequestSubmitted, $CancellationToken, $null).Result
        }

    }
    catch {
        Invoke-Exception($_.Exception)
    }
<#
 .SYNOPSIS
 Clear the access list.

 .DESCRIPTION
 The Clear-RSLBAccessList cmdlet will clear a load balancer's access list entries.
 
 .PARAMETER Account
 Use this parameter to indicate which account you would like to execute this request against.
 Valid choices are defined in PoshRack configuration file.

 .PARAMETER LBID
 An object of type net.openstack.Providers.Rackspace.Objects.LoadBalancers.LoadBalancerID that identifies the Load Balancer.

 .PARAMETER WaitForTask
 Specifies whether the calling function will wait for this task to complete (True) or continue without waiting (False).

 .PARAMETER RegionOverride
 This parameter will temporarily override the default region set in PoshRack configuration file.

 .EXAMPLE
 PS C:\Users\Administrator>


 .LINK
 http://api.rackspace.com/api-ref-load-balancers.html
#>
}

# Issue 55 Implement New-CloudLoadBalancer
function New-RSLoadBalancer {
    Param(
        [Parameter (Mandatory=$True)] [string] $Account = $(throw "Please specify required Cloud Account by using the -Account parameter"),
        [Parameter (Mandatory=$True)] [net.openstack.Providers.Rackspace.Objects.LoadBalancers.LoadBalancerConfiguration] $LBConfig = $(throw "Please specify the required Load Balancer Configuration by using the -LBConfig parameter"),
        [Parameter (Mandatory=$False)][bool]   $WaitForTask = $False,
        [Parameter (Mandatory=$False)][string] $RegionOverride
    )

    Get-OpenStackAccount -Account $Account
    
    if ($RegionOverride){
        $Global:RegionOverride = $RegionOverride
    }

    # Use Region code associated with Account, or was an override provided?
    if ($RegionOverride) {
        $Region = $Global:RegionOverride
    } else {
        $Region = $Credentials.Region
    }


    $LBProvider = Get-RSLBProvider -Account rackiad -RegionOverride $Region

    try {

        # DEBUGGING       
        Write-Debug -Message "New-OpenStackLoadBalancer"
        Write-Debug -Message "Account.........................: $Account" 
        Write-Debug -Message "LBConfig........................: $LBConfig"
        Write-Debug -Message "WaitForTask.....................: $WaitForTask" 
        Write-Debug -Message "Region..........................: $Region" 

        $CancellationToken = New-Object ([System.Threading.CancellationToken]::None)

        if($WaitForTask) {
            $LBProvider.CreateLoadBalancerAsync($LBConfig, [net.openstack.Core.AsyncCompletionOption]::RequestCompleted, $CancellationToken, $null).Result
        } else {
            $LBProvider.CreateLoadBalancerAsync($LBConfig, [net.openstack.Core.AsyncCompletionOption]::RequestSubmitted, $CancellationToken, $null).Result
        }

    }
    catch {
        Invoke-Exception($_.Exception)
    }
<#
 .SYNOPSIS
 Create Load Balancer

 .DESCRIPTION
 The New-OpenStackLoadBalancer cmdlet will create a new load balancer.
 
 .PARAMETER Account
 Use this parameter to indicate which account you would like to execute this request against.
 Valid choices are defined in PoshRack configuration file.

 .PARAMETER LBConfig
 An object of type net.openstack.Providers.Rackspace.Objects.LoadBalancers.LoadBalancerConfiguration that describes the new Load Balancer.
 
 .PARAMETER WaitForTask
 Use this parameter to specify whether you want to wait for the task to complete or return control to the script immediately.

 .PARAMETER RegionOverride
 This parameter will temporarily override the default region set in PoshRack configuration file.

 .EXAMPLE
 PS C:\Users\Administrator>


 .LINK
 http://api.rackspace.com/api-ref-load-balancers.html
#>
}

# Issue 56 Implement Get-CloudLoadBalancerConnectionLogging
function Get-RSLBConnectionLogging {
    Param(
        [Parameter (Mandatory=$True)] [string] $Account = $(throw "Please specify required Cloud Account by using the -Account parameter"),
        [Parameter (Mandatory=$True)] [net.openstack.Providers.Rackspace.Objects.LoadBalancers.LoadBalancerId] $LBID = $(throw "Please specify the required Load Balancer ID by using the -LBID parameter"),
        [Parameter (Mandatory=$False)][string] $RegionOverride
    )

    Get-OpenStackAccount -Account $Account
    
    if ($RegionOverride){
        $Global:RegionOverride = $RegionOverride
    }

    # Use Region code associated with Account, or was an override provided?
    if ($RegionOverride) {
        $Region = $Global:RegionOverride
    } else {
        $Region = $Credentials.Region
    }


    $LBProvider = Get-RSLBProvider -Account rackiad -RegionOverride $Region

    try {

        # DEBUGGING       
        Write-Debug -Message "Get-RSLBConnectionLogging"
        Write-Debug -Message "Account.........................: $Account" 
        Write-Debug -Message "LBID............................: $LBID"
        Write-Debug -Message "Region..........................: $Region" 

        $CancellationToken = New-Object ([System.Threading.CancellationToken]::None)

        $LBProvider.GetConnectionLoggingAsync($LBID, $CancellationToken).Result

    }
    catch {
        Invoke-Exception($_.Exception)
    }
<#
 .SYNOPSIS
 Get logging status

 .DESCRIPTION
 The Get-RSLBConnectionLogging cmdlet will allow you to query to see if the Load Balancer has connection logging enabled.
 
 .PARAMETER Account
 Use this parameter to indicate which account you would like to execute this request against.
 Valid choices are defined in PoshRack configuration file.

 .PARAMETER LBID
 An object of type net.openstack.Providers.Rackspace.Objects.LoadBalancers.LoadBalancerID that identifies the Load Balancer.
 
 .PARAMETER RegionOverride
 This parameter will temporarily override the default region set in PoshRack configuration file.

 .EXAMPLE
 PS C:\Users\Administrator>


 .LINK
 http://api.rackspace.com/api-ref-load-balancers.html
#>
}

# Issue 57 Implement Get-CloudLoadBalancerContentCaching
function Get-RSLBContentCaching {
    Param(
        [Parameter (Mandatory=$True)] [string] $Account = $(throw "Please specify required Cloud Account by using the -Account parameter"),
        [Parameter (Mandatory=$True)] [net.openstack.Providers.Rackspace.Objects.LoadBalancers.LoadBalancerId] $LBID = $(throw "Please specify the required Load Balancer ID by using the -LBID parameter"),
        [Parameter (Mandatory=$False)][string] $RegionOverride
    )

    Get-OpenStackAccount -Account $Account
    
    if ($RegionOverride){
        $Global:RegionOverride = $RegionOverride
    }

    # Use Region code associated with Account, or was an override provided?
    if ($RegionOverride) {
        $Region = $Global:RegionOverride
    } else {
        $Region = $Credentials.Region
    }


    $LBProvider = Get-RSLBProvider -Account rackiad -RegionOverride $Region

    try {

        # DEBUGGING       
        Write-Debug -Message "Get-RSLBContentCaching"
        Write-Debug -Message "Account.........................: $Account" 
        Write-Debug -Message "LBID............................: $LBID"
        Write-Debug -Message "Region..........................: $Region" 

        $CancellationToken = New-Object ([System.Threading.CancellationToken]::None)

        $LBProvider.GetContentCachingAsync($LBID, $CancellationToken).Result

    }
    catch {
        Invoke-Exception($_.Exception)
    }
<#
 .SYNOPSIS
 Get content caching status

 .DESCRIPTION
 The Get-RSLBContentCaching cmdlet will allow you to query to see if the Load Balancer has content caching enabled.
 
 .PARAMETER Account
 Use this parameter to indicate which account you would like to execute this request against.
 Valid choices are defined in PoshRack configuration file.

 .PARAMETER LBID
 An object of type net.openstack.Providers.Rackspace.Objects.LoadBalancers.LoadBalancerID that identifies the Load Balancer.
 
 .PARAMETER RegionOverride
 This parameter will temporarily override the default region set in PoshRack configuration file.

 .EXAMPLE
 PS C:\Users\Administrator>


 .LINK
 http://api.rackspace.com/api-ref-load-balancers.html
#>
}

# Issue 58 Implement Get-CloudLoadBalancerErrorPage
function Get-RSLBErrorPage {
    Param(
        [Parameter (Mandatory=$True)] [string] $Account = $(throw "Please specify required Cloud Account by using the -Account parameter"),
        [Parameter (Mandatory=$True)] [net.openstack.Providers.Rackspace.Objects.LoadBalancers.LoadBalancerId] $LBID = $(throw "Please specify the required Load Balancer ID by using the -LBID parameter"),
        [Parameter (Mandatory=$False)][string] $RegionOverride
    )

    Get-OpenStackAccount -Account $Account
    
    if ($RegionOverride){
        $Global:RegionOverride = $RegionOverride
    }

    # Use Region code associated with Account, or was an override provided?
    if ($RegionOverride) {
        $Region = $Global:RegionOverride
    } else {
        $Region = $Credentials.Region
    }


    $LBProvider = Get-RSLBProvider -Account rackiad -RegionOverride $Region

    try {

        # DEBUGGING       
        Write-Debug -Message "Get-RSLBErrorPage"
        Write-Debug -Message "Account.........................: $Account" 
        Write-Debug -Message "LBID............................: $LBID"
        Write-Debug -Message "Region..........................: $Region" 

        $CancellationToken = New-Object ([System.Threading.CancellationToken]::None)

        $LBProvider.GetErrorPageAsync($LBID, $CancellationToken).Result

    }
    catch {
        Invoke-Exception($_.Exception)
    }
<#
 .SYNOPSIS
 Get error page

 .DESCRIPTION
 The Get-RSLBErrorPage cmdlet gets the HTML content of the page which is shown to an end user who is attempting to access a load balancer node that is offline or unavailable.
 
 .PARAMETER Account
 Use this parameter to indicate which account you would like to execute this request against.
 Valid choices are defined in PoshRack configuration file.

 .PARAMETER LBID
 An object of type net.openstack.Providers.Rackspace.Objects.LoadBalancers.LoadBalancerID that identifies the Load Balancer.
 
 .PARAMETER RegionOverride
 This parameter will temporarily override the default region set in PoshRack configuration file.

 .EXAMPLE
 PS C:\Users\Administrator>


 .LINK
 http://api.rackspace.com/api-ref-load-balancers.html
#>
}

# Issue 59 Implement Get-CloudLoadBalancerHealthMonitor
function Get-RSLBHealthMonitor {
    Param(
        [Parameter (Mandatory=$True)] [string] $Account = $(throw "Please specify required Cloud Account by using the -Account parameter"),
        [Parameter (Mandatory=$True)] [net.openstack.Providers.Rackspace.Objects.LoadBalancers.LoadBalancerId] $LBID = $(throw "Please specify the required Load Balancer ID by using the -LBID parameter"),
        [Parameter (Mandatory=$False)][string] $RegionOverride
    )

    Get-OpenStackAccount -Account $Account
    
    if ($RegionOverride){
        $Global:RegionOverride = $RegionOverride
    }

    # Use Region code associated with Account, or was an override provided?
    if ($RegionOverride) {
        $Region = $Global:RegionOverride
    } else {
        $Region = $Credentials.Region
    }


    $LBProvider = Get-RSLBProvider -Account rackiad -RegionOverride $Region

    try {

        # DEBUGGING       
        Write-Debug -Message "c"
        Write-Debug -Message "Account.........................: $Account" 
        Write-Debug -Message "LBID............................: $LBID"
        Write-Debug -Message "Region..........................: $Region" 

        $CancellationToken = New-Object ([System.Threading.CancellationToken]::None)

        $LBProvider.GetHealthMonitorAsync($LBID, $CancellationToken).Result

    }
    catch {
        Invoke-Exception($_.Exception)
    }
<#
 .SYNOPSIS
 Get health monitor

 .DESCRIPTION
 The GetHealthMonitorAsync cmdlet gets the health monitor currently configured for a load balancer.
 
 .PARAMETER Account
 Use this parameter to indicate which account you would like to execute this request against.
 Valid choices are defined in PoshRack configuration file.

 .PARAMETER LBID
 An object of type net.openstack.Providers.Rackspace.Objects.LoadBalancers.LoadBalancerID that identifies the Load Balancer.
 
 .PARAMETER RegionOverride
 This parameter will temporarily override the default region set in PoshRack configuration file.

 .EXAMPLE
 PS C:\Users\Administrator>


 .LINK
 http://api.rackspace.com/api-ref-load-balancers.html
#>

}

# Issue 60 Implement Get-CloudLoadBalancer
# Issue 75 Implement Get-CloudLoadBalancers
function Get-RSLoadBalancer {
    Param(
        [Parameter (Mandatory=$True)] [string] $Account = $(throw "Please specify required Cloud Account by using the -Account parameter"),
        [Parameter (Mandatory=$False)][net.openstack.Providers.Rackspace.Objects.LoadBalancers.LoadBalancerId] $LBID = $null,
        [Parameter (Mandatory=$False)][net.openstack.Providers.Rackspace.Objects.LoadBalancers.LoadBalancerId] $Marker = $null,
        [Parameter (Mandatory=$False)][int]    $Limit = 100,
        [Parameter (Mandatory=$False)][string] $RegionOverride
    )

    Get-OpenStackAccount -Account $Account
    
    if ($RegionOverride){
        $Global:RegionOverride = $RegionOverride
    }

    # Use Region code associated with Account, or was an override provided?
    if ($RegionOverride) {
        $Region = $Global:RegionOverride
    } else {
        $Region = $Credentials.Region
    }


    $LBProvider = Get-RSLBProvider -Account rackiad -RegionOverride $Region

    try {

        # DEBUGGING       
        Write-Debug -Message "Get-OpenStackLoadBalancer"
        Write-Debug -Message "Account.........................: $Account" 
        Write-Debug -Message "LBID............................: $LBID"
        Write-Debug -Message "Marker..........................: $Marker"
        Write-Debug -Message "Limit...........................: $Limit"
        Write-Debug -Message "WaitForTask.....................: $WaitForTask" 
        Write-Debug -Message "Region..........................: $Region" 

        $CancellationToken = New-Object ([System.Threading.CancellationToken]::None)

        IF([string]::IsNullOrEmpty($LBID)) {    
            $LBProvider.ListLoadBalancersAsync($Marker, $Limit, $CancellationToken).Result
        } else {
            $LBProvider.GetLoadBalancerAsync($LBID, $CancellationToken).Result
        }

    }
    catch {
        Invoke-Exception($_.Exception)
    }
<#
 .SYNOPSIS
 Create Load Balancer

 .DESCRIPTION
 The New-OpenStackLoadBalancer cmdlet will create a new load balancer.
 
 .PARAMETER Account
 Use this parameter to indicate which account you would like to execute this request against.
 Valid choices are defined in PoshRack configuration file.

 .PARAMETER LBConfig
 An object of type net.openstack.Providers.Rackspace.Objects.LoadBalancers.LoadBalancerConfiguration that describes the new Load Balancer.
 
 .PARAMETER WaitForTask
 Use this parameter to specify whether you want to wait for the task to complete or return control to the script immediately.

 .PARAMETER RegionOverride
 This parameter will temporarily override the default region set in PoshRack configuration file.

 .EXAMPLE
 PS C:\Users\Administrator>


 .LINK
 http://api.rackspace.com/api-ref-load-balancers.html
#>
}

# Issue 61 Implement Get-CloudLoadBalancerMetadataItem
# Issue 74 Implement Get-CloudLoadBalancerMetadata
function Get-RSLBMetadata {
    Param(
        [Parameter (Mandatory=$True)] [string] $Account = $(throw "Please specify required Cloud Account by using the -Account parameter"),
        [Parameter (Mandatory=$True)] [net.openstack.Providers.Rackspace.Objects.LoadBalancers.LoadBalancerId] $LBID = $(throw "Please specify the required Load Balancer ID by using the -LBID parameter"),
        [Parameter (Mandatory=$False)][net.openstack.Providers.Rackspace.Objects.LoadBalancers.MetadataId] $MetadataID = $null,
        [Parameter (Mandatory=$False)][string] $RegionOverride
    )

    Get-OpenStackAccount -Account $Account
    
    if ($RegionOverride){
        $Global:RegionOverride = $RegionOverride
    }

    # Use Region code associated with Account, or was an override provided?
    if ($RegionOverride) {
        $Region = $Global:RegionOverride
    } else {
        $Region = $Credentials.Region
    }


    $LBProvider = Get-RSLBProvider -Account rackiad -RegionOverride $Region

    try {

        # DEBUGGING       
        Write-Debug -Message "Get-RSLBMetadata"
        Write-Debug -Message "Account.........................: $Account" 
        Write-Debug -Message "LBID............................: $LBID"
        Write-Debug -Message "MetadataID......................: $MetadataID"
        Write-Debug -Message "Region..........................: $Region" 

        $CancellationToken = New-Object ([System.Threading.CancellationToken]::None)

        IF([string]::IsNullOrEmpty($MetadataID)) {    
            $LBProvider.ListLoadBalancerMetadataAsync($LBID, $CancellationToken).Result
        } else {
            $LBProvider.GetLoadBalancerMetadataItemAsync($LBID, $MetadataID, $CancellationToken).Result
        }

    }
    catch {
        Invoke-Exception($_.Exception)
    }
<#
 .SYNOPSIS
 Get metadata.

 .DESCRIPTION
 The Get-RSLBMetadata cmdlet will get metadata for a Load Balancer.
 
 .PARAMETER Account
 Use this parameter to indicate which account you would like to execute this request against.
 Valid choices are defined in PoshRack configuration file.

 .PARAMETER LBID
 An object of type net.openstack.Providers.Rackspace.Objects.LoadBalancers.LoadBalancerId that identifies the Load Balancer.
 
 .PARAMETER MetadataID
 An object of type net.openstack.Providers.Rackspace.Objects.LoadBalancers.MetadataId that identifies a specific Load Balancer metadata item.

 .PARAMETER RegionOverride
 This parameter will temporarily override the default region set in PoshRack configuration file.

 .EXAMPLE
 PS C:\Users\Administrator>


 .LINK
 http://api.rackspace.com/api-ref-load-balancers.html
#>
}

# Issue 62 Implemented Get-CloudLoadBalancerNode
# Issue 77 Implemeneed Get-CloudLoadBalancerNodes
function Get-RSLBNode {
    Param(
        [Parameter (Mandatory=$True)] [string] $Account = $(throw "Please specify required Cloud Account by using the -Account parameter"),
        [Parameter (Mandatory=$True)] [net.openstack.Providers.Rackspace.Objects.LoadBalancers.LoadBalancerId] $LBID = $(throw "Please specify the required Load Balancer ID by using the -LBID parameter"),
        [Parameter (Mandatory=$False)][net.openstack.Providers.Rackspace.Objects.LoadBalancers.NodeID] $NodeID = $null,
        [Parameter (Mandatory=$False)][string] $RegionOverride
    )

    Get-OpenStackAccount -Account $Account
    
    if ($RegionOverride){
        $Global:RegionOverride = $RegionOverride
    }

    # Use Region code associated with Account, or was an override provided?
    if ($RegionOverride) {
        $Region = $Global:RegionOverride
    } else {
        $Region = $Credentials.Region
    }


    $LBProvider = Get-RSLBProvider -Account rackiad -RegionOverride $Region

    try {

        # DEBUGGING       
        Write-Debug -Message "Get-RSLBNode"
        Write-Debug -Message "Account.........................: $Account" 
        Write-Debug -Message "LBID............................: $LBID"
        Write-Debug -Message "NodeID..........................: $NodeID"
        Write-Debug -Message "Region..........................: $Region" 

        $CancellationToken = New-Object ([System.Threading.CancellationToken]::None)

        IF([string]::IsNullOrEmpty($NodeID)) {    
            $LBProvider.ListNodesAsync($LBID, $CancellationToken).Result
        } else {
            $LBProvider.GetNodeAsync($LBID, $NodeID, $CancellationToken).Result
        }

    }
    catch {
        Invoke-Exception($_.Exception)
    }
<#
 .SYNOPSIS
 Get a node

 .DESCRIPTION
 The Get-RSLBNode cmdlet will create one or more Load Balancer Nodes.
 
 .PARAMETER Account
 Use this parameter to indicate which account you would like to execute this request against.
 Valid choices are defined in PoshRack configuration file.

 .PARAMETER LBID
 An object of type net.openstack.Providers.Rackspace.Objects.LoadBalancers.LoadBalancerId that identifies the Load Balancer.
 
 .PARAMETER NodeID
 An object of type net.openstack.Providers.Rackspace.Objects.LoadBalancers.NodeId that identifies a specific Load Balancer Node.

 .PARAMETER RegionOverride
 This parameter will temporarily override the default region set in PoshRack configuration file.

 .EXAMPLE
 PS C:\Users\Administrator>


 .LINK
 http://api.rackspace.com/api-ref-load-balancers.html
#>
}

# Issue 63 Implement Get-CloudLoadBalancerNodeMetadataItem
# Issue 76 Implement List-CloudLoadBalancerNodeMetadata
function Get-RSLBNodeMetadataItem {
    Param(
        [Parameter (Mandatory=$True)] [string] $Account = $(throw "Please specify required Cloud Account by using the -Account parameter"),
        [Parameter (Mandatory=$True)] [net.openstack.Providers.Rackspace.Objects.LoadBalancers.LoadBalancerId] $LBID = $(throw "Please specify the required Load Balancer ID by using the -LBID parameter"),
        [Parameter (Mandatory=$True)] [net.openstack.Providers.Rackspace.Objects.LoadBalancers.NodeId] $NodeID = $(throw "Please specify the required Node ID by using the -NodeID parameter"),
        [Parameter (Mandatory=$False)][net.openstack.Providers.Rackspace.Objects.LoadBalancers.MetadataId] $MetadataID = $null,
        [Parameter (Mandatory=$False)][string] $RegionOverride
    )

    Get-OpenStackAccount -Account $Account
    
    if ($RegionOverride){
        $Global:RegionOverride = $RegionOverride
    }

    # Use Region code associated with Account, or was an override provided?
    if ($RegionOverride) {
        $Region = $Global:RegionOverride
    } else {
        $Region = $Credentials.Region
    }


    $LBProvider = Get-RSLBProvider -Account rackiad -RegionOverride $Region

    try {

        # DEBUGGING       
        Write-Debug -Message "Get-CloudLoadBalancerNodeMetadataItem"
        Write-Debug -Message "Account.........................: $Account" 
        Write-Debug -Message "LBID............................: $LBID"
        Write-Debug -Message "NodeID..........................: $NodeID"
        Write-Debug -Message "MetadataID......................: $MetadataID"
        Write-Debug -Message "Region..........................: $Region" 

        $CancellationToken = New-Object ([System.Threading.CancellationToken]::None)

        IF([string]::IsNullOrEmpty($MetadataID)) {    
            $LBProvider.ListNodeMetadataAsync($LBID, $NodeID, $CancellationToken).Result
        } else {
            $LBProvider.GetNodeMetadataItemAsync($LBID, $NodeID, $MetadataID, $CancellationToken).Result
        }

    }
    catch {
        Invoke-Exception($_.Exception)
    }
<#
 .SYNOPSIS
 Get metadata for a node.

 .DESCRIPTION
 The Get-CloudLoadBalancerNodeMetadataItem cmdlet will get metadata for a Load Balancer Node.
 
 .PARAMETER Account
 Use this parameter to indicate which account you would like to execute this request against.
 Valid choices are defined in PoshRack configuration file.

 .PARAMETER LBID
 An object of type net.openstack.Providers.Rackspace.Objects.LoadBalancers.LoadBalancerId that identifies the Load Balancer.
 
 .PARAMETER NodeID
 An object of type net.openstack.Providers.Rackspace.Objects.LoadBalancers.NodeId that identifies the Load Balancer Node..
 
 .PARAMETER MetadataID
 An object of type net.openstack.Providers.Rackspace.Objects.LoadBalancers.MetadataId that identifies a specific Load Balancer metadata item.

 .PARAMETER RegionOverride
 This parameter will temporarily override the default region set in PoshRack configuration file.

 .EXAMPLE
 PS C:\Users\Administrator>


 .LINK
 http://api.rackspace.com/api-ref-load-balancers.html
#>
}

# Issue 64 Implement Get-CloudLoadBalancerSessionPersistence
function Get-RSLBSessionPersistence {
    Param(
        [Parameter (Mandatory=$True)] [string] $Account = $(throw "Please specify required Cloud Account by using the -Account parameter"),
        [Parameter (Mandatory=$True)] [net.openstack.Providers.Rackspace.Objects.LoadBalancers.LoadBalancerId] $LBID = $(throw "Please specify the required Load Balancer ID by using the -LBID parameter"),
        [Parameter (Mandatory=$False)][string] $RegionOverride
    )

    Get-OpenStackAccount -Account $Account
    
    if ($RegionOverride){
        $Global:RegionOverride = $RegionOverride
    }

    # Use Region code associated with Account, or was an override provided?
    if ($RegionOverride) {
        $Region = $Global:RegionOverride
    } else {
        $Region = $Credentials.Region
    }


    $LBProvider = Get-RSLBProvider -Account rackiad -RegionOverride $Region

    try {

        # DEBUGGING       
        Write-Debug -Message "Get-RSLBSessionPersistence"
        Write-Debug -Message "Account.........................: $Account" 
        Write-Debug -Message "LBID............................: $LBID"
        Write-Debug -Message "Region..........................: $Region" 

        $CancellationToken = New-Object ([System.Threading.CancellationToken]::None)

        $LBProvider.GetSessionPersistenceAsync($LBID, $CancellationToken).Result

    }
    catch {
        Invoke-Exception($_.Exception)
    }
<#
 .SYNOPSIS
 Get session persistence

 .DESCRIPTION
 The Get-RSLBSessionPersistence cmdlet gets the session persistence configuration for a load balancer.
 
 .PARAMETER Account
 Use this parameter to indicate which account you would like to execute this request against.
 Valid choices are defined in PoshRack configuration file.

 .PARAMETER LBID
 An object of type net.openstack.Providers.Rackspace.Objects.LoadBalancers.LoadBalancerID that identifies the Load Balancer.
 
 .PARAMETER RegionOverride
 This parameter will temporarily override the default region set in PoshRack configuration file.

 .EXAMPLE
 PS C:\Users\Administrator>


 .LINK
 http://api.rackspace.com/api-ref-load-balancers.html
#>
}

# Issue 65 Implement Get-CloudLoadBalancerSslConfiguration
function Get-RSLBSslConfiguration {
    Param(
        [Parameter (Mandatory=$True)] [string] $Account = $(throw "Please specify required Cloud Account by using the -Account parameter"),
        [Parameter (Mandatory=$True)] [net.openstack.Providers.Rackspace.Objects.LoadBalancers.LoadBalancerId] $LBID = $(throw "Please specify the required Load Balancer ID by using the -LBID parameter"),
        [Parameter (Mandatory=$False)][string] $RegionOverride
    )

    Get-OpenStackAccount -Account $Account
    
    if ($RegionOverride){
        $Global:RegionOverride = $RegionOverride
    }

    # Use Region code associated with Account, or was an override provided?
    if ($RegionOverride) {
        $Region = $Global:RegionOverride
    } else {
        $Region = $Credentials.Region
    }


    $LBProvider = Get-RSLBProvider -Account rackiad -RegionOverride $Region

    try {

        # DEBUGGING       
        Write-Debug -Message "Get-RSLBSslConfiguration"
        Write-Debug -Message "Account.........................: $Account" 
        Write-Debug -Message "LBID............................: $LBID"
        Write-Debug -Message "Region..........................: $Region" 

        $CancellationToken = New-Object ([System.Threading.CancellationToken]::None)

        $LBProvider.GetSslConfigurationAsync($LBID, $CancellationToken).Result

    }
    catch {
        Invoke-Exception($_.Exception)
    }
<#
 .SYNOPSIS
 Get SSL configuration

 .DESCRIPTION
 The Get-RSLBSslConfiguration cmdlet gets the SSL configuration for a load balancer.
 
 .PARAMETER Account
 Use this parameter to indicate which account you would like to execute this request against.
 Valid choices are defined in PoshRack configuration file.

 .PARAMETER LBID
 An object of type net.openstack.Providers.Rackspace.Objects.LoadBalancers.LoadBalancerID that identifies the Load Balancer.
 
 .PARAMETER RegionOverride
 This parameter will temporarily override the default region set in PoshRack configuration file.

 .EXAMPLE
 PS C:\Users\Administrator>


 .LINK
 http://api.rackspace.com/api-ref-load-balancers.html
#>
}

# Issue 66 Implement Get-CloudLoadBalancerStatistics
function Get-RSLBStatistics {
    Param(
        [Parameter (Mandatory=$True)] [string] $Account = $(throw "Please specify required Cloud Account by using the -Account parameter"),
        [Parameter (Mandatory=$True)] [net.openstack.Providers.Rackspace.Objects.LoadBalancers.LoadBalancerId] $LBID = $(throw "Please specify the required Load Balancer ID by using the -LBID parameter"),
        [Parameter (Mandatory=$False)][string] $RegionOverride
    )

    Get-OpenStackAccount -Account $Account
    
    if ($RegionOverride){
        $Global:RegionOverride = $RegionOverride
    }

    # Use Region code associated with Account, or was an override provided?
    if ($RegionOverride) {
        $Region = $Global:RegionOverride
    } else {
        $Region = $Credentials.Region
    }


    $LBProvider = Get-RSLBProvider -Account rackiad -RegionOverride $Region

    try {

        # DEBUGGING       
        Write-Debug -Message "Get-RSLBStatistics"
        Write-Debug -Message "Account.........................: $Account" 
        Write-Debug -Message "LBID............................: $LBID"
        Write-Debug -Message "Region..........................: $Region" 

        $CancellationToken = New-Object ([System.Threading.CancellationToken]::None)

        $LBProvider.GetStatisticsAsync($LBID, $CancellationToken).Result

    }
    catch {
        Invoke-Exception($_.Exception)
    }
<#
 .SYNOPSIS
 Get statistics

 .DESCRIPTION
 The Get-RSLBStatistics cmdlet gets detailed statistics for a load balancer.
 
 .PARAMETER Account
 Use this parameter to indicate which account you would like to execute this request against.
 Valid choices are defined in PoshRack configuration file.

 .PARAMETER LBID
 An object of type net.openstack.Providers.Rackspace.Objects.LoadBalancers.LoadBalancerID that identifies the Load Balancer.
 
 .PARAMETER RegionOverride
 This parameter will temporarily override the default region set in PoshRack configuration file.

 .EXAMPLE
 PS C:\Users\Administrator>


 .LINK
 http://api.rackspace.com/api-ref-load-balancers.html
#>
}
# Issue 67 Implement Get-CloudLoadBalancerAccessList
function Get-RSLBAccessList {
    Param(
        [Parameter (Mandatory=$True)] [string] $Account = $(throw "Please specify required Cloud Account by using the -Account parameter"),
        [Parameter (Mandatory=$True)] [net.openstack.Providers.Rackspace.Objects.LoadBalancers.LoadBalancerId] $LBID = $(throw "Please specify the required Load Balancer ID by using the -LBID parameter"),
        [Parameter (Mandatory=$False)][string] $RegionOverride
    )

    Get-OpenStackAccount -Account $Account
    
    if ($RegionOverride){
        $Global:RegionOverride = $RegionOverride
    }

    # Use Region code associated with Account, or was an override provided?
    if ($RegionOverride) {
        $Region = $Global:RegionOverride
    } else {
        $Region = $Credentials.Region
    }


    $LBProvider = Get-RSLBProvider -Account rackiad -RegionOverride $Region

    try {

        # DEBUGGING       
        Write-Debug -Message "Get-RSLBAccessList"
        Write-Debug -Message "Account.........................: $Account" 
        Write-Debug -Message "LBID............................: $LBID"
        Write-Debug -Message "Region..........................: $Region" 

        $CancellationToken = New-Object ([System.Threading.CancellationToken]::None)

        $LBProvider.ListAccessListAsync($LBID, $CancellationToken).Result

    }
    catch {
        Invoke-Exception($_.Exception)
    }
<#
 .SYNOPSIS
 Get access list.

 .DESCRIPTION
 The Get-RSLBAccessList cmdlet gets the access list configuration for a load balancer.
 
 .PARAMETER Account
 Use this parameter to indicate which account you would like to execute this request against.
 Valid choices are defined in PoshRack configuration file.

 .PARAMETER LBID
 An object of type net.openstack.Providers.Rackspace.Objects.LoadBalancers.LoadBalancerID that identifies the Load Balancer.
 
 .PARAMETER RegionOverride
 This parameter will temporarily override the default region set in PoshRack configuration file.

 .EXAMPLE
 PS C:\Users\Administrator>


 .LINK
 http://api.rackspace.com/api-ref-load-balancers.html
#>
}

# Issue 68 Implement Get-CloudLoadBalancerAccountLevelUsage
function Get-RSLBAccountLevelUsage {
    Param(
        [Parameter (Mandatory=$True)] [string] $Account = $(throw "Please specify required Cloud Account by using the -Account parameter"),
        [Parameter (Mandatory=$False)][DateTime] $StartTime = $Null,
        [Parameter (Mandatory=$False)][DateTime] $EndTime = $Null,
        [Parameter (Mandatory=$False)][string] $RegionOverride
    )

    Get-OpenStackAccount -Account $Account
    
    if ($RegionOverride){
        $Global:RegionOverride = $RegionOverride
    }

    # Use Region code associated with Account, or was an override provided?
    if ($RegionOverride) {
        $Region = $Global:RegionOverride
    } else {
        $Region = $Credentials.Region
    }


    $LBProvider = Get-RSLBProvider -Account rackiad -RegionOverride $Region

    try {

        # DEBUGGING       
        Write-Debug -Message "Get-RSLBAccountLevelUsage"
        Write-Debug -Message "Account.........................: $Account" 
        Write-Debug -Message "StartTime.......................: $StartTime"
        Write-Debug -Message "EndTime.........................: $EndTime"
        Write-Debug -Message "Region..........................: $Region" 

        $CancellationToken = New-Object ([System.Threading.CancellationToken]::None)

        $LBProvider.ListAccountLevelUsageAsync($StartTime, $EndTime, $CancellationToken).Result

    }
    catch {
        Invoke-Exception($_.Exception)
    }
<#
 .SYNOPSIS
 Get list of algorithms.

 .DESCRIPTION
 The Get-RSLBAccountLevelUsage cmdlet gets a list of all possible Load Balancer algorithms.
 
 .PARAMETER Account
 Use this parameter to indicate which account you would like to execute this request against.
 Valid choices are defined in PoshRack configuration file.
 
 .PARAMETER StartTime
 The start date to consider. The time component, if any, is ignored. If the value is null, the result includes all usage prior to the specified endTime.

 .PARAMETER EndTime
 The end date to consider. The time component, if any, is ignored. If the value is null, the result includes all usage following the specified startTime.

 .PARAMETER RegionOverride
 This parameter will temporarily override the default region set in PoshRack configuration file.

 .EXAMPLE
 PS C:\Users\Administrator>


 .LINK
 http://api.rackspace.com/api-ref-load-balancers.html
#>
}

# Issue 69 Implement Get-CloudLoadBalancerAlgorithms
function Get-RSLBAlgorithmList {
    Param(
        [Parameter (Mandatory=$True)] [string] $Account = $(throw "Please specify required Cloud Account by using the -Account parameter"),
        [Parameter (Mandatory=$False)][string] $RegionOverride
    )

    Get-OpenStackAccount -Account $Account
    
    if ($RegionOverride){
        $Global:RegionOverride = $RegionOverride
    }

    # Use Region code associated with Account, or was an override provided?
    if ($RegionOverride) {
        $Region = $Global:RegionOverride
    } else {
        $Region = $Credentials.Region
    }


    $LBProvider = Get-RSLBProvider -Account rackiad -RegionOverride $Region

    try {

        # DEBUGGING       
        Write-Debug -Message "Get-RSLBAlgorithmList"
        Write-Debug -Message "Account.........................: $Account" 
        Write-Debug -Message "LBID............................: $LBID"
        Write-Debug -Message "Region..........................: $Region" 

        $CancellationToken = New-Object ([System.Threading.CancellationToken]::None)

        $LBProvider.ListAlgorithmsAsync($CancellationToken).Result

    }
    catch {
        Invoke-Exception($_.Exception)
    }
<#
 .SYNOPSIS
 Get list of algorithms.

 .DESCRIPTION
 The Get-RSLBAlgorithmList cmdlet gets a list of all possible Load Balancer algorithms.
 
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

# Issue 70 Implemented Get-CloudLoadBalancerAllowedDomains
function Get-RSLBAllowedDomainList {
    Param(
        [Parameter (Mandatory=$True)] [string] $Account = $(throw "Please specify required Cloud Account by using the -Account parameter"),
        [Parameter (Mandatory=$False)][string] $RegionOverride
    )

    Get-OpenStackAccount -Account $Account
    
    if ($RegionOverride){
        $Global:RegionOverride = $RegionOverride
    }

    # Use Region code associated with Account, or was an override provided?
    if ($RegionOverride) {
        $Region = $Global:RegionOverride
    } else {
        $Region = $Credentials.Region
    }


    $LBProvider = Get-RSLBProvider -Account rackiad -RegionOverride $Region

    try {

        # DEBUGGING       
        Write-Debug -Message "Get-RSLBAllowedDomainList"
        Write-Debug -Message "Account.........................: $Account" 
        Write-Debug -Message "Region..........................: $Region" 

        $CancellationToken = New-Object ([System.Threading.CancellationToken]::None)

        $LBProvider.ListAllowedDomainsAsync($CancellationToken).Result

    }
    catch {
        Invoke-Exception($_.Exception)
    }
<#
 .SYNOPSIS
 Get list of allowed domains.

 .DESCRIPTION
 The Get-ListAllowedDomainsAsync cmdlet gets the domain name restrictions in place for adding load balancer nodes.
 
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

# Issue 71 Implemented Get-CloudLoadBalancerBillableLBs
function Get-RSLBBillableLBs {
    Param(
        [Parameter (Mandatory=$True)] [string] $Account = $(throw "Please specify required Cloud Account by using the -Account parameter"),
        [Parameter (Mandatory=$False)][DateTime] $StartTime = $Null,
        [Parameter (Mandatory=$False)][DateTime] $EndTime = $Null,
        [Parameter (Mandatory=$False)][int]    $Offset = 0,
        [Parameter (Mandatory=$False)][int]    $Limit = $Null,
        [Parameter (Mandatory=$False)][string] $RegionOverride
    )

    Get-OpenStackAccount -Account $Account
    
    if ($RegionOverride){
        $Global:RegionOverride = $RegionOverride
    }

    # Use Region code associated with Account, or was an override provided?
    if ($RegionOverride) {
        $Region = $Global:RegionOverride
    } else {
        $Region = $Credentials.Region
    }


    $LBProvider = Get-RSLBProvider -Account rackiad -RegionOverride $Region

    try {

        # DEBUGGING       
        Write-Debug -Message "Get-RSLBBillableLBs"
        Write-Debug -Message "Account.........................: $Account" 
        Write-Debug -Message "StartTime.......................: $StartTime"
        Write-Debug -Message "EndTime.........................: $EndTime"
        Write-Debug -Message "Offset..........................: $Offset"
        Write-Debug -Message "Limit...........................: $Limit"
        Write-Debug -Message "Region..........................: $Region" 

        $CancellationToken = New-Object ([System.Threading.CancellationToken]::None)

        $LBProvider.ListBillableLoadBalancersAsync($StartTime, $EndTime, $Offset, $Limit, $CancellationToken).Result

    }
    catch {
        Invoke-Exception($_.Exception)
    }
<#
 .SYNOPSIS
 Get list of algorithms.

 .DESCRIPTION
 The Get-RSLBBillableLBs cmdlet gets a list of billable Load Balancers.
 
 .PARAMETER Account
 Use this parameter to indicate which account you would like to execute this request against.
 Valid choices are defined in PoshRack configuration file.

 .PARAMETER StartTime
 The start date to consider. The time component, if any, is ignored. If the value is null, the result includes all usage prior to the specified endTime.

 .PARAMETER EndTime
 The end date to consider. The time component, if any, is ignored. If the value is null, the result includes all usage following the specified startTime.

 .PARAMETER Offset
 The index of the last item in the previous page of results. If the value is null, the list starts at the beginning.

 .PARAMETER Limit
 Gets the maximum number of load balancers to return in a single page of results. If the value is null, a provider-specific default value is used.

 .PARAMETER RegionOverride
 This parameter will temporarily override the default region set in PoshRack configuration file.

 .EXAMPLE
 PS C:\Users\Administrator>


 .LINK
 http://api.rackspace.com/api-ref-load-balancers.html
#>
}

# Issue 72 Implement Get-CloudLoadBalancerCurrentUsage
function Get-RSLBCurrentUsage {
    Param(
        [Parameter (Mandatory=$True)] [string] $Account = $(throw "Please specify required Cloud Account by using the -Account parameter"),
        [Parameter (Mandatory=$True)] [net.openstack.Providers.Rackspace.Objects.LoadBalancers.LoadBalancerId] $LBID = $(throw "Please specify the required Load Balancer ID by using the -LBID parameter"),
        [Parameter (Mandatory=$False)][string] $RegionOverride
    )

    Get-OpenStackAccount -Account $Account
    
    if ($RegionOverride){
        $Global:RegionOverride = $RegionOverride
    }

    # Use Region code associated with Account, or was an override provided?
    if ($RegionOverride) {
        $Region = $Global:RegionOverride
    } else {
        $Region = $Credentials.Region
    }


    $LBProvider = Get-RSLBProvider -Account rackiad -RegionOverride $Region

    try {

        # DEBUGGING       
        Write-Debug -Message "Get-RSLBCurrentUsage"
        Write-Debug -Message "Account.........................: $Account" 
        Write-Debug -Message "LBID............................: $LBID"
        Write-Debug -Message "Region..........................: $Region" 

        $CancellationToken = New-Object ([System.Threading.CancellationToken]::None)

        $LBProvider.ListCurrentUsageAsync($LBID, $CancellationToken).Result

    }
    catch {
        Invoke-Exception($_.Exception)
    }
<#
 .SYNOPSIS
 Get usage.

 .DESCRIPTION
 The Get-RSLBCurrentUsage cmdlet lists all usage for a specific load balancer during a preceding 24 hours
 
 .PARAMETER Account
 Use this parameter to indicate which account you would like to execute this request against.
 Valid choices are defined in PoshRack configuration file.

 .PARAMETER LBID
 An object of type net.openstack.Providers.Rackspace.Objects.LoadBalancers.LoadBalancerID that identifies the Load Balancer.
 
 .PARAMETER RegionOverride
 This parameter will temporarily override the default region set in PoshRack configuration file.

 .EXAMPLE
 PS C:\Users\Administrator>


 .LINK
 http://api.rackspace.com/api-ref-load-balancers.html
#>
}

# Issue 73 Implement Get-CloudLoadBalancerHistoricalUsage
function Get-RSLBHistoricalUsage {
    Param(
        [Parameter (Mandatory=$True)] [string] $Account = $(throw "Please specify required Cloud Account by using the -Account parameter"),
        [Parameter (Mandatory=$True)] [net.openstack.Providers.Rackspace.Objects.LoadBalancers.LoadBalancerId] $LBID = $(throw "Please specify the required Load Balancer ID by using the -LBID parameter"),
        [Parameter (Mandatory=$False)][DateTime] $StartTime = $Null,
        [Parameter (Mandatory=$False)][DateTime] $EndTime = $Null,
        [Parameter (Mandatory=$False)][string] $RegionOverride
    )

    Get-OpenStackAccount -Account $Account
    
    if ($RegionOverride){
        $Global:RegionOverride = $RegionOverride
    }

    # Use Region code associated with Account, or was an override provided?
    if ($RegionOverride) {
        $Region = $Global:RegionOverride
    } else {
        $Region = $Credentials.Region
    }


    $LBProvider = Get-RSLBProvider -Account rackiad -RegionOverride $Region

    try {

        # DEBUGGING       
        Write-Debug -Message "Get-RSLBHistoricalUsage"
        Write-Debug -Message "Account.........................: $Account" 
        Write-Debug -Message "LBID............................: $LBID"
        Write-Debug -Message "StartTime.......................: $StartTime"
        Write-Debug -Message "EndTime.........................: $EndTime"
        Write-Debug -Message "Region..........................: $Region" 

        $CancellationToken = New-Object ([System.Threading.CancellationToken]::None)

        $LBProvider.ListHistoricalUsageAsync($LBID, $StartTime, $EndTime, $CancellationToken).Result

    }
    catch {
        Invoke-Exception($_.Exception)
    }
<#
 .SYNOPSIS
 Get historical usage.

 .DESCRIPTION
 The Get-RSLBHistoricalUsage cmdlet lists all usage for a specific load balancer during a specified date range.
 
 .PARAMETER Account
 Use this parameter to indicate which account you would like to execute this request against.
 Valid choices are defined in PoshRack configuration file.

 .PARAMETER LBID
 An object of type net.openstack.Providers.Rackspace.Objects.LoadBalancers.LoadBalancerID that identifies the Load Balancer.
 
 .PARAMETER StartTime
 The start date to consider. The time component, if any, is ignored. If the value is null, the result includes all usage prior to the specified endTime.

 .PARAMETER EndTime
 The end date to consider. The time component, if any, is ignored. If the value is null, the result includes all usage following the specified startTime.

 .PARAMETER RegionOverride
 This parameter will temporarily override the default region set in PoshRack configuration file.

 .EXAMPLE
 PS C:\Users\Administrator>


 .LINK
 http://api.rackspace.com/api-ref-load-balancers.html
#>
}

# Issue 78 Implemented Get-CloudLoadBalancerNodeServiceEvents
function Get-RSLBNodeServiceEvent {
    Param(
        [Parameter (Mandatory=$True)] [string] $Account = $(throw "Please specify required Cloud Account by using the -Account parameter"),
        [Parameter (Mandatory=$True)] [net.openstack.Providers.Rackspace.Objects.LoadBalancers.LoadBalancerId] $LBID = $(throw "Please specify the required Load Balancer ID by using the -LBID parameter"),
        [Parameter (Mandatory=$True)] [net.openstack.Providers.Rackspace.Objects.LoadBalancers.NodeServiceEventId] $MarkerID = $(throw "Please specify the required Marker ID by using the -MarkerID parameter"),
        [Parameter (Mandatory=$False)][int]    $Limit = 100,
        [Parameter (Mandatory=$False)][string] $RegionOverride
    )

    Get-OpenStackAccount -Account $Account
    
    if ($RegionOverride){
        $Global:RegionOverride = $RegionOverride
    }

    # Use Region code associated with Account, or was an override provided?
    if ($RegionOverride) {
        $Region = $Global:RegionOverride
    } else {
        $Region = $Credentials.Region
    }


    $LBProvider = Get-RSLBProvider -Account rackiad -RegionOverride $Region

    try {

        # DEBUGGING       
        Write-Debug -Message "Get-RSLBNodeServiceEvent"
        Write-Debug -Message "Account.........................: $Account" 
        Write-Debug -Message "LBID............................: $LBID"
        Write-Debug -Message "MarkerID........................: $MarkerID"
        Write-Debug -Message "Limit...........................: $Limit"
        Write-Debug -Message "Region..........................: $Region" 

        $CancellationToken = New-Object ([System.Threading.CancellationToken]::None)

        $LBProvider.ListNodeServiceEventsAsync($LBID, $MarkerID, $Limit, $CancellationToken).Result

    }
    catch {
        Invoke-Exception($_.Exception)
    }
<#
 .SYNOPSIS
 Get service events.

 .DESCRIPTION
 The Get-RSLBNodeServiceEvent cmdlet lists the service events for a load balancer node
 
 .PARAMETER Account
 Use this parameter to indicate which account you would like to execute this request against.
 Valid choices are defined in PoshRack configuration file.

 .PARAMETER LBID
 An object of type net.openstack.Providers.Rackspace.Objects.LoadBalancers.LoadBalancerID that identifies the Load Balancer.
 
 .PARAMETER MarkerID
 The net.openstack.Providers.Rackspace.Objects.LoadBalancers.NodeServiceEvent.Id of the last item in the previous list. If the value is null, the list starts at the beginning.

 .PARAMETER Limit
 Indicates the maximum number of items to return. Used for . If the value is null, a provider-specific default value is used.

 .PARAMETER RegionOverride
 This parameter will temporarily override the default region set in PoshRack configuration file.

 .EXAMPLE
 PS C:\Users\Administrator>


 .LINK
 http://api.rackspace.com/api-ref-load-balancers.html
#>
}

# Issue 79 Implemented Get-CloudLoadBalancerProtocols
function Get-RSLBProtocolList {
    Param(
        [Parameter (Mandatory=$True)] [string] $Account = $(throw "Please specify required Cloud Account by using the -Account parameter"),
        [Parameter (Mandatory=$False)][string] $RegionOverride
    )

    Get-OpenStackAccount -Account $Account
    
    if ($RegionOverride){
        $Global:RegionOverride = $RegionOverride
    }

    # Use Region code associated with Account, or was an override provided?
    if ($RegionOverride) {
        $Region = $Global:RegionOverride
    } else {
        $Region = $Credentials.Region
    }


    $LBProvider = Get-RSLBProvider -Account rackiad -RegionOverride $Region

    try {

        # DEBUGGING       
        Write-Debug -Message "Get-RSLBProtocolList"
        Write-Debug -Message "Account.........................: $Account" 
        Write-Debug -Message "Region..........................: $Region" 

        $CancellationToken = New-Object ([System.Threading.CancellationToken]::None)

        $LBProvider.ListProtocolsAsync($CancellationToken).Result

    }
    catch {
        Invoke-Exception($_.Exception)
    }
<#
 .SYNOPSIS
 Get list of protocols.

 .DESCRIPTION
 The Get-RSLBProtocolList cmdlet gets a collection of supported load balancing protocols.
 
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

# Issue #80 Implement Get-CloudLoadBalancerThrottles
function Get-RSLBThrottleList {
    Param(
        [Parameter (Mandatory=$True)] [string] $Account = $(throw "Please specify required Cloud Account by using the -Account parameter"),
        [Parameter (Mandatory=$True)] [net.openstack.Providers.Rackspace.Objects.LoadBalancers.LoadBalancerId] $LBID = $(throw "Please specify the required Load Balancer ID by using the -LBID parameter"),
        [Parameter (Mandatory=$False)][string] $RegionOverride
    )

    Get-OpenStackAccount -Account $Account
    
    if ($RegionOverride){
        $Global:RegionOverride = $RegionOverride
    }

    # Use Region code associated with Account, or was an override provided?
    if ($RegionOverride) {
        $Region = $Global:RegionOverride
    } else {
        $Region = $Credentials.Region
    }


    $LBProvider = Get-RSLBProvider -Account rackiad -RegionOverride $Region

    try {

        # DEBUGGING       
        Write-Debug -Message "Get-RSLBThrottleList"
        Write-Debug -Message "Account.........................: $Account" 
        Write-Debug -Message "LBID............................: $LBID"
        Write-Debug -Message "Region..........................: $Region" 

        $CancellationToken = New-Object ([System.Threading.CancellationToken]::None)

        $LBProvider.ListThrottlesAsync($LBID, $CancellationToken).Result

    }
    catch {
        Invoke-Exception($_.Exception)
    }
<#
 .SYNOPSIS
 Get throttling configuration.

 .DESCRIPTION
 The Get-RSLBThrottleList cmdlet gets the connection throttling configuration for a load balancer.
 
 .PARAMETER Account
 Use this parameter to indicate which account you would like to execute this request against.
 Valid choices are defined in PoshRack configuration file.

 .PARAMETER LBID
 An object of type net.openstack.Providers.Rackspace.Objects.LoadBalancers.LoadBalancerID that identifies the Load Balancer.
 
 .PARAMETER RegionOverride
 This parameter will temporarily override the default region set in PoshRack configuration file.

 .EXAMPLE
 PS C:\Users\Administrator>


 .LINK
 http://api.rackspace.com/api-ref-load-balancers.html
#>
}

# Issue 81 Implement Get-CloudLoadBalancerVirtualAddresses
function Get-RSLBVirtualAddressList {
    Param(
        [Parameter (Mandatory=$True)] [string] $Account = $(throw "Please specify required Cloud Account by using the -Account parameter"),
        [Parameter (Mandatory=$True)] [net.openstack.Providers.Rackspace.Objects.LoadBalancers.LoadBalancerId] $LBID = $(throw "Please specify the required Load Balancer ID by using the -LBID parameter"),
        [Parameter (Mandatory=$False)][string] $RegionOverride
    )

    Get-OpenStackAccount -Account $Account
    
    if ($RegionOverride){
        $Global:RegionOverride = $RegionOverride
    }

    # Use Region code associated with Account, or was an override provided?
    if ($RegionOverride) {
        $Region = $Global:RegionOverride
    } else {
        $Region = $Credentials.Region
    }


    $LBProvider = Get-RSLBProvider -Account rackiad -RegionOverride $Region

    try {

        # DEBUGGING       
        Write-Debug -Message "Get-RSLBVirtualAddressList"
        Write-Debug -Message "Account.........................: $Account" 
        Write-Debug -Message "LBID............................: $LBID"
        Write-Debug -Message "Region..........................: $Region" 

        $CancellationToken = New-Object ([System.Threading.CancellationToken]::None)

        $LBProvider.ListVirtualAddressesAsync($LBID, $CancellationToken).Result

    }
    catch {
        Invoke-Exception($_.Exception)
    }
<#
 .SYNOPSIS
 Get virtual address list.

 .DESCRIPTION
 The Get-RSLBVirtualAddressList cmdlet gets the virtual addresses for a load balancer.
 
 .PARAMETER Account
 Use this parameter to indicate which account you would like to execute this request against.
 Valid choices are defined in PoshRack configuration file.

 .PARAMETER LBID
 An object of type net.openstack.Providers.Rackspace.Objects.LoadBalancers.LoadBalancerID that identifies the Load Balancer.
 
 .PARAMETER RegionOverride
 This parameter will temporarily override the default region set in PoshRack configuration file.

 .EXAMPLE
 PS C:\Users\Administrator>


 .LINK
 http://api.rackspace.com/api-ref-load-balancers.html
#>
}

# Issue 82 Implement Remove-CloudLoadBalancerAccessList
# Issue 83 Implement Remove-CloudLoadBalancerAccessListRange
function Remove-RSLBAccessList {
    Param(
        [Parameter (Mandatory=$True)] [string] $Account = $(throw "Please specify required Cloud Account by using the -Account parameter"),
        [Parameter (Mandatory=$True)] [net.openstack.Providers.Rackspace.Objects.LoadBalancers.LoadBalancerId] $LBID = $(throw "Please specify the required Load Balancer ID by using the -LBID parameter"),
        [Parameter (Mandatory=$False)][net.openstack.Providers.Rackspace.Objects.LoadBalancers.NetworkItemId] $NetworkItemID = $Null,
        [Parameter (Mandatory=$False)][net.openstack.Providers.Rackspace.Objects.LoadBalancers.NetworkItemId[]] $ListOfNetworkItemIDs = $Null,
        [Parameter (Mandatory=$False)][bool]   $WaitForTask = $False,
        [Parameter (Mandatory=$False)][string] $RegionOverride
    )

    Get-OpenStackAccount -Account $Account
    
    if ($RegionOverride){
        $Global:RegionOverride = $RegionOverride
    }

    # Use Region code associated with Account, or was an override provided?
    if ($RegionOverride) {
        $Region = $Global:RegionOverride
    } else {
        $Region = $Credentials.Region
    }


    $LBProvider = Get-RSLBProvider -Account rackiad -RegionOverride $Region

    try {

        # DEBUGGING       
        Write-Debug -Message "Remove-RSLBAccessList"
        Write-Debug -Message "Account.........................: $Account" 
        Write-Debug -Message "LBID............................: $LBID"
        Write-Debug -Message "NetworkItemID...................: $NetworkItemID"
        Write-Debug -Message "ListOfNetworkItemIDs............: $ListOfNetworkItemIDs"
        Write-Debug -Message "WaitForTask.....................: $WaitForTask"
        Write-Debug -Message "Region..........................: $Region" 

        $CancellationToken = New-Object ([System.Threading.CancellationToken]::None)

        if (![string]::IsNullOrEmpty($NetworkItemID)) {
            if($WaitForTask) {
                $LBProvider.RemoveAccessListAsync($LBID, $NetworkItemID, [net.openstack.Core.AsyncCompletionOption]::RequestCompleted, $CancellationToken, $null).Result
            } else {
                $LBProvider.RemoveAccessListAsync($LBID, $NetworkItemID, [net.openstack.Core.AsyncCompletionOption]::RequestSubmitted, $CancellationToken, $null).Result
            }
        } else {
            if($WaitForTask) {
                $LBProvider.RemoveAccessListRangeAsync($LBID, $ListOfNetworkItemIDs, [net.openstack.Core.AsyncCompletionOption]::RequestCompleted, $CancellationToken, $null).Result
            } else {
                $LBProvider.RemoveAccessListRangeAsync($LBID, $ListOfNetworkItemIDs, [net.openstack.Core.AsyncCompletionOption]::RequestSubmitted, $CancellationToken, $null).Result
            }
        }
    }
    catch {
        Invoke-Exception($_.Exception)
    }
<#
 .SYNOPSIS
 Remove access list.

 .DESCRIPTION
 The Remove-RSLBAccessList cmdlet will remove a network item from the access list of a load balancer..
 
 .PARAMETER Account
 Use this parameter to indicate which account you would like to execute this request against.
 Valid choices are defined in PoshRack configuration file.

 .PARAMETER LBID
 An object of type net.openstack.Providers.Rackspace.Objects.LoadBalancers.LoadBalancerID that identifies the Load Balancer.
 
 .PARAMETER NetworkItemID
 An object of type net.openstack.Providers.Rackspace.Objects.LoadBalancers.NetworkItemId that identifies the network.

 .PARAMETER WaitForTask
 Specifies whether the calling function will wait for this task to complete (True) or continue without waiting (False).

 .PARAMETER RegionOverride
 This parameter will temporarily override the default region set in PoshRack configuration file.

 .EXAMPLE
 PS C:\Users\Administrator>


 .LINK
 http://api.rackspace.com/api-ref-load-balancers.html
#>
}

# Issue 84 Implement Remove-CloudLoadBalancerErrorPage
function Remove-RSLBErrorPage {
    Param(
        [Parameter (Mandatory=$True)] [string] $Account = $(throw "Please specify required Cloud Account by using the -Account parameter"),
        [Parameter (Mandatory=$True)] [net.openstack.Providers.Rackspace.Objects.LoadBalancers.LoadBalancerId] $LBID = $(throw "Please specify the required Load Balancer ID by using the -LBID parameter"),
        [Parameter (Mandatory=$False)][bool]   $WaitForTask = $False,
        [Parameter (Mandatory=$False)][string] $RegionOverride
    )

    Get-OpenStackAccount -Account $Account
    
    if ($RegionOverride){
        $Global:RegionOverride = $RegionOverride
    }

    # Use Region code associated with Account, or was an override provided?
    if ($RegionOverride) {
        $Region = $Global:RegionOverride
    } else {
        $Region = $Credentials.Region
    }


    $LBProvider = Get-RSLBProvider -Account rackiad -RegionOverride $Region

    try {

        # DEBUGGING       
        Write-Debug -Message "Remove-RSLBErrorPage"
        Write-Debug -Message "Account.........................: $Account" 
        Write-Debug -Message "LBID............................: $LBID"
        Write-Debug -Message "WaitForTask.....................: $WaitForTask"
        Write-Debug -Message "Region..........................: $Region" 

        $CancellationToken = New-Object ([System.Threading.CancellationToken]::None)

        if($WaitForTask) {
            $LBProvider.RemoveErrorPageAsync($LBID, [net.openstack.Core.AsyncCompletionOption]::RequestCompleted, $CancellationToken, $null).Result
        } else {
            $LBProvider.RemoveErrorPageAsync($LBID, [net.openstack.Core.AsyncCompletionOption]::RequestSubmitted, $CancellationToken, $null).Result
        }
    }
    catch {
        Invoke-Exception($_.Exception)
    }
<#
 .SYNOPSIS
 Remove error page.

 .DESCRIPTION
 The Remove-RSLBErrorPage cmdlet will remove the error page for a load balancer.
 
 .PARAMETER Account
 Use this parameter to indicate which account you would like to execute this request against.
 Valid choices are defined in PoshRack configuration file.

 .PARAMETER LBID
 An object of type net.openstack.Providers.Rackspace.Objects.LoadBalancers.LoadBalancerID that identifies the Load Balancer.
 
 .PARAMETER WaitForTask
 Specifies whether the calling function will wait for this task to complete (True) or continue without waiting (False).

 .PARAMETER RegionOverride
 This parameter will temporarily override the default region set in PoshRack configuration file.

 .EXAMPLE
 PS C:\Users\Administrator>


 .LINK
 http://api.rackspace.com/api-ref-load-balancers.html
#>
}

# Issue 85 Implement Remove-CloudLoadBalancerHealthMonitor
function Remove-RSLBHealthMonitor {
    Param(
        [Parameter (Mandatory=$True)] [string] $Account = $(throw "Please specify required Cloud Account by using the -Account parameter"),
        [Parameter (Mandatory=$True)] [net.openstack.Providers.Rackspace.Objects.LoadBalancers.LoadBalancerId] $LBID = $(throw "Please specify the required Load Balancer ID by using the -LBID parameter"),
        [Parameter (Mandatory=$False)][bool]   $WaitForTask = $False,
        [Parameter (Mandatory=$False)][string] $RegionOverride
    )

    Get-OpenStackAccount -Account $Account
    
    if ($RegionOverride){
        $Global:RegionOverride = $RegionOverride
    }

    # Use Region code associated with Account, or was an override provided?
    if ($RegionOverride) {
        $Region = $Global:RegionOverride
    } else {
        $Region = $Credentials.Region
    }


    $LBProvider = Get-RSLBProvider -Account rackiad -RegionOverride $Region

    try {

        # DEBUGGING       
        Write-Debug -Message "Remove-RSLBHealthMonitor"
        Write-Debug -Message "Account.........................: $Account" 
        Write-Debug -Message "LBID............................: $LBID"
        Write-Debug -Message "WaitForTask.....................: $WaitForTask"
        Write-Debug -Message "Region..........................: $Region" 

        $CancellationToken = New-Object ([System.Threading.CancellationToken]::None)

        if($WaitForTask) {
            $LBProvider.RemoveHealthMonitorAsync($LBID, [net.openstack.Core.AsyncCompletionOption]::RequestCompleted, $CancellationToken, $null).Result
        } else {
            $LBProvider.RemoveHealthMonitorAsync($LBID, [net.openstack.Core.AsyncCompletionOption]::RequestSubmitted, $CancellationToken, $null).Result
        }
    }
    catch {
        Invoke-Exception($_.Exception)
    }
<#
 .SYNOPSIS
 Remove health monitor

 .DESCRIPTION
 The Remove-RSLBHealthMonitor cmdlet will remove the health monitors for a load balancer.
 
 .PARAMETER Account
 Use this parameter to indicate which account you would like to execute this request against.
 Valid choices are defined in PoshRack configuration file.

 .PARAMETER LBID
 An object of type net.openstack.Providers.Rackspace.Objects.LoadBalancers.LoadBalancerID that identifies the Load Balancer.
 
 .PARAMETER WaitForTask
 Specifies whether the calling function will wait for this task to complete (True) or continue without waiting (False).

 .PARAMETER RegionOverride
 This parameter will temporarily override the default region set in PoshRack configuration file.

 .EXAMPLE
 PS C:\Users\Administrator>


 .LINK
 http://api.rackspace.com/api-ref-load-balancers.html
#>
}

# Issue 86 Implemented Remove-CloudLoadBalancer
# Issue 88 Implemented Remove-CloudLoadBalancerRange
function Remove-OpenStackLoadBalancer {
    Param(
        [Parameter (Mandatory=$True)] [string] $Account = $(throw "Please specify required Cloud Account by using the -Account parameter"),
        [Parameter (Mandatory=$False)][net.openstack.Providers.Rackspace.Objects.LoadBalancers.LoadBalancerId] $LBID = $null,
        [Parameter (Mandatory=$False)][net.openstack.Providers.Rackspace.Objects.LoadBalancers.LoadBalancerId[]] $ListOfLBIDs = $null,
        [Parameter (Mandatory=$False)][bool]   $WaitForTask = $False,
        [Parameter (Mandatory=$False)][string] $RegionOverride
    )

    Get-OpenStackAccount -Account $Account
    
    if ($RegionOverride){
        $Global:RegionOverride = $RegionOverride
    }

    # Use Region code associated with Account, or was an override provided?
    if ($RegionOverride) {
        $Region = $Global:RegionOverride
    } else {
        $Region = $Credentials.Region
    }


    $LBProvider = Get-RSLBProvider -Account rackiad -RegionOverride $Region

    try {

        # DEBUGGING       
        Write-Debug -Message "Remove-OpenStackLoadBalancer"
        Write-Debug -Message "Account.........................: $Account" 
        Write-Debug -Message "LBID............................: $LBID"
        Write-Debug -Message "ListOfLBIDs.....................: $ListOfLBIDs"
        Write-Debug -Message "WaitForTask.....................: $WaitForTask"
        Write-Debug -Message "Region..........................: $Region" 

        $CancellationToken = New-Object ([System.Threading.CancellationToken]::None)

        if (![string]::IsNullOrEmpty($LBID)) {
            if($WaitForTask) {
                $LBProvider.RemoveLoadBalancerAsync($LBID, [net.openstack.Core.AsyncCompletionOption]::RequestCompleted, $CancellationToken, $null).Result
            } else {
                $LBProvider.RemoveLoadBalancerAsync($LBID, [net.openstack.Core.AsyncCompletionOption]::RequestSubmitted, $CancellationToken, $null).Result
            }
        } else {
            if($WaitForTask) {
                $LBProvider.RemoveLoadBalancerRangeAsync($ListOfLBIDs, [net.openstack.Core.AsyncCompletionOption]::RequestCompleted, $CancellationToken, $null).Result
            } else {
                $LBProvider.RemoveLoadBalancerRangeAsync($ListOfLBIDs, [net.openstack.Core.AsyncCompletionOption]::RequestSubmitted, $CancellationToken, $null).Result
            }
        }
    }
    catch {
        Invoke-Exception($_.Exception)
    }
<#
 .SYNOPSIS
 Remove a load balancer.

 .DESCRIPTION
 The Remove-OpenStackLoadBalancer cmdlet will remove a load balancer.
 
 .PARAMETER Account
 Use this parameter to indicate which account you would like to execute this request against.
 Valid choices are defined in PoshRack configuration file.

 .PARAMETER LBID
 An object of type net.openstack.Providers.Rackspace.Objects.LoadBalancers.LoadBalancerID that identifies the Load Balancer.
 
 .PARAMETER WaitForTask
 Specifies whether the calling function will wait for this task to complete (True) or continue without waiting (False).

 .PARAMETER RegionOverride
 This parameter will temporarily override the default region set in PoshRack configuration file.

 .EXAMPLE
 PS C:\Users\Administrator>


 .LINK
 http://api.rackspace.com/api-ref-load-balancers.html
#>
}

# Issue #87 Implemented Remove-CloudLoadBalancerMetadataItem
function Remove-RSLBMetadataItem {
    Param(
        [Parameter (Mandatory=$True)] [string] $Account = $(throw "Please specify required Cloud Account by using the -Account parameter"),
        [Parameter (Mandatory=$True)] [net.openstack.Providers.Rackspace.Objects.LoadBalancers.LoadBalancerId] $LBID = $(throw "Please specify the required Load Balancer ID by using the -LBID parameter"),
        [Parameter (Mandatory=$True)] [net.openstack.Providers.Rackspace.Objects.LoadBalancers.MetaDataId[]]   $ListOfMetaDataID = $(throw "Please specify the required list of Metadata IDs by using the -ListOfMetadataID parameter"),
        [Parameter (Mandatory=$False)][string] $RegionOverride
    )

    Get-OpenStackAccount -Account $Account
    
    if ($RegionOverride){
        $Global:RegionOverride = $RegionOverride
    }

    # Use Region code associated with Account, or was an override provided?
    if ($RegionOverride) {
        $Region = $Global:RegionOverride
    } else {
        $Region = $Credentials.Region
    }


    $LBProvider = Get-RSLBProvider -Account rackiad -RegionOverride $Region

    try {

        # DEBUGGING       
        Write-Debug -Message "Remove-RSLBMetadataItem"
        Write-Debug -Message "Account.........................: $Account" 
        Write-Debug -Message "LBID............................: $LBID"
        Write-Debug -Message "ListOfMetadataID................: $ListOfMetaDataID"
        Write-Debug -Message "Region..........................: $Region" 

        $CancellationToken = New-Object ([System.Threading.CancellationToken]::None)

        $LBProvider.RemoveLoadBalancerMetadataItemAsync($LBID, $ListOfMetaDataID, $CancellationToken).Result
    }
    catch {
        Invoke-Exception($_.Exception)
    }
<#
 .SYNOPSIS
 Remove metadata.

 .DESCRIPTION
 The Remove-RSLBMetadataItem cmdlet will remove one or more metadata items from a load balancer.
 
 .PARAMETER Account
 Use this parameter to indicate which account you would like to execute this request against.
 Valid choices are defined in PoshRack configuration file.

 .PARAMETER LBID
 An object of type net.openstack.Providers.Rackspace.Objects.LoadBalancers.LoadBalancerID that identifies the Load Balancer.
 
 .PARAMETER ListOfMetaDataID
 A list of metadata ids that indicate which metadata items to be removed.

 .PARAMETER RegionOverride
 This parameter will temporarily override the default region set in PoshRack configuration file.

 .EXAMPLE
 PS C:\Users\Administrator>


 .LINK
 http://api.rackspace.com/api-ref-load-balancers.html
#>
}

# Issue 89 Implemented Remove-CloudLoadBalancerNode
function Remove-RSLBNode {
    Param(
        [Parameter (Mandatory=$True)] [string] $Account = $(throw "Please specify required Cloud Account by using the -Account parameter"),
        [Parameter (Mandatory=$True)] [net.openstack.Providers.Rackspace.Objects.LoadBalancers.LoadBalancerId] $LBID = $null,
        [Parameter (Mandatory=$False)][net.openstack.Providers.Rackspace.Objects.LoadBalancers.NodeId] $NodeID = $null,
        [Parameter (Mandatory=$False)][net.openstack.Providers.Rackspace.Objects.LoadBalancers.NodeId[]] $ListOfNodeIDs = $null,
        [Parameter (Mandatory=$False)][bool]   $WaitForTask = $False,
        [Parameter (Mandatory=$False)][string] $RegionOverride
    )

    Get-OpenStackAccount -Account $Account
    
    if ($RegionOverride){
        $Global:RegionOverride = $RegionOverride
    }

    # Use Region code associated with Account, or was an override provided?
    if ($RegionOverride) {
        $Region = $Global:RegionOverride
    } else {
        $Region = $Credentials.Region
    }


    $LBProvider = Get-RSLBProvider -Account rackiad -RegionOverride $Region

    try {

        # DEBUGGING       
        Write-Debug -Message "Remove-RSLBNode"
        Write-Debug -Message "Account.........................: $Account" 
        Write-Debug -Message "LBID............................: $LBID"
        Write-Debug -Message "NodeID..........................: $NodeID"
        Write-Debug -Message "ListOfNodeIDs...................: $ListOfNodeIDs"
        Write-Debug -Message "WaitForTask.....................: $WaitForTask"
        Write-Debug -Message "Region..........................: $Region" 

        $CancellationToken = New-Object ([System.Threading.CancellationToken]::None)

        if (![string]::IsNullOrEmpty($NodeID)) {
            if($WaitForTask) {
                $LBProvider.RemoveNodeAsync($LBID, $NodeID, [net.openstack.Core.AsyncCompletionOption]::RequestCompleted, $CancellationToken, $null).Result
            } else {
                $LBProvider.RemoveNodeAsync($LBID, $NodeID, [net.openstack.Core.AsyncCompletionOption]::RequestSubmitted, $CancellationToken, $null).Result
            }
        } else {
            if($WaitForTask) {
                $LBProvider.RemoveNodeRangeAsync($LBID, $ListOfNodeIDs, [net.openstack.Core.AsyncCompletionOption]::RequestCompleted, $CancellationToken, $null).Result
            } else {
                $LBProvider.RemoveNodeRangeAsync($LBID, $ListOfNodeIDs, [net.openstack.Core.AsyncCompletionOption]::RequestSubmitted, $CancellationToken, $null).Result
            }
        }
    }
    catch {
        Invoke-Exception($_.Exception)
    }
<#
 .SYNOPSIS
 Remove one or more nodes.

 .DESCRIPTION
 The Remove-RSLBNode cmdlet will remove a load balancer.
 
 .PARAMETER Account
 Use this parameter to indicate which account you would like to execute this request against.
 Valid choices are defined in PoshRack configuration file.

 .PARAMETER LBID
 An object of type net.openstack.Providers.Rackspace.Objects.LoadBalancers.LoadBalancerID that identifies the Load Balancer.

 .PARAMETER NodeID
 An object of type net.openstack.Providers.Rackspace.Objects.LoadBalancers.NodeId that identifies a single node to be removed.

 .PARAMETER ListOfNodeIDs
 A list of nodes to be removed.
 
 .PARAMETER WaitForTask
 Specifies whether the calling function will wait for this task to complete (True) or continue without waiting (False).

 .PARAMETER RegionOverride
 This parameter will temporarily override the default region set in PoshRack configuration file.

 .EXAMPLE
 PS C:\Users\Administrator>


 .LINK
 http://api.rackspace.com/api-ref-load-balancers.html
#>
}

# Issue 90 Implement Remove-CloudLoadBalancerNodeMetadataItem
function Remove-RSLBNodeMetadataItem {
    Param(
        [Parameter (Mandatory=$True)] [string] $Account = $(throw "Please specify required Cloud Account by using the -Account parameter"),
        [Parameter (Mandatory=$True)] [net.openstack.Providers.Rackspace.Objects.LoadBalancers.LoadBalancerId] $LBID = $(throw "Please specify the required Load Balancer ID by using the -LBID parameter"),
        [Parameter (Mandatory=$True)] [net.openstack.Providers.Rackspace.Objects.LoadBalancers.NodeId] $NodeID = $(throw "Please specify the required Node ID by using the -NodeID parameter"),
        [Parameter (Mandatory=$True)] [net.openstack.Providers.Rackspace.Objects.LoadBalancers.MetadataId[]] $ListOfMetadataIDs = $(throw "Please specify the required list of Metadata IDs by using the -ListOfMetadataIDs parameter"),
        [Parameter (Mandatory=$False)][string] $RegionOverride
    )

    Get-OpenStackAccount -Account $Account
    
    if ($RegionOverride){
        $Global:RegionOverride = $RegionOverride
    }

    # Use Region code associated with Account, or was an override provided?
    if ($RegionOverride) {
        $Region = $Global:RegionOverride
    } else {
        $Region = $Credentials.Region
    }


    $LBProvider = Get-RSLBProvider -Account rackiad -RegionOverride $Region

    try {

        # DEBUGGING       
        Write-Debug -Message "Remove-RSLBNodeMetadataItem"
        Write-Debug -Message "Account.........................: $Account" 
        Write-Debug -Message "LBID............................: $LBID"
        Write-Debug -Message "NodeID..........................: $NodeID"
        Write-Debug -Message "ListOfNodeIDs...................: $ListOfMetadataIDs"
        Write-Debug -Message "Region..........................: $Region" 

        $CancellationToken = New-Object ([System.Threading.CancellationToken]::None)

        $LBProvider.RemoveNodeMetadataItemAsync($LBID, $NodeID, $ListOfMetadataIDs, $CancellationToken).Result

    }
    catch {
        Invoke-Exception($_.Exception)
    }
<#
 .SYNOPSIS
 Remove one or more node metadata items.

 .DESCRIPTION
 The Remove-RSLBNodeMetadataItem cmdlet will remove one or more metadata items associated with a load balancer node.
 
 .PARAMETER Account
 Use this parameter to indicate which account you would like to execute this request against.
 Valid choices are defined in PoshRack configuration file.

 .PARAMETER LBID
 An object of type net.openstack.Providers.Rackspace.Objects.LoadBalancers.LoadBalancerID that identifies the Load Balancer.

 .PARAMETER NodeID
 An object of type net.openstack.Providers.Rackspace.Objects.LoadBalancers.NodeId that identifies a the node.

 .PARAMETER ListOfMetadataIDs
 A list of metadata items to be removed.
 
 .PARAMETER RegionOverride
 This parameter will temporarily override the default region set in PoshRack configuration file.

 .EXAMPLE
 PS C:\Users\Administrator>


 .LINK
 http://api.rackspace.com/api-ref-load-balancers.html
#>
}

# Issue 92 Implement Remove-CloudLoadBalancerSessionPersistence
function Remove-RSLBSessionPersistence {
    Param(
        [Parameter (Mandatory=$True)] [string] $Account = $(throw "Please specify required Cloud Account by using the -Account parameter"),
        [Parameter (Mandatory=$True)] [net.openstack.Providers.Rackspace.Objects.LoadBalancers.LoadBalancerId] $LBID = $(throw "Please specify the required Load Balancer ID by using the -LBID parameter"),
        [Parameter (Mandatory=$False)][bool]   $WaitForTask = $False,
        [Parameter (Mandatory=$False)][string] $RegionOverride
    )

    Get-OpenStackAccount -Account $Account
    
    if ($RegionOverride){
        $Global:RegionOverride = $RegionOverride
    }

    # Use Region code associated with Account, or was an override provided?
    if ($RegionOverride) {
        $Region = $Global:RegionOverride
    } else {
        $Region = $Credentials.Region
    }


    $LBProvider = Get-RSLBProvider -Account rackiad -RegionOverride $Region

    try {

        # DEBUGGING       
        Write-Debug -Message "Remove-RSLBSessionPersistence"
        Write-Debug -Message "Account.........................: $Account" 
        Write-Debug -Message "LBID............................: $LBID"
        Write-Debug -Message "WaitForTask.....................: $WaitForTask"
        Write-Debug -Message "Region..........................: $Region" 

        $CancellationToken = New-Object ([System.Threading.CancellationToken]::None)

        if($WaitForTask) {
            $LBProvider.RemoveSessionPersistenceAsync($LBID, [net.openstack.Core.AsyncCompletionOption]::RequestCompleted, $CancellationToken, $null).Result
        } else {
            $LBProvider.RemoveSessionPersistenceAsync($LBID, [net.openstack.Core.AsyncCompletionOption]::RequestSubmitted, $CancellationToken, $null).Result
        }

    }
    catch {
        Invoke-Exception($_.Exception)
    }
<#
 .SYNOPSIS
 Remove session persistence.

 .DESCRIPTION
 The Remove-RSLBSessionPersistence cmdlet will remove the session persistence configuration for a load balancer
 
 .PARAMETER Account
 Use this parameter to indicate which account you would like to execute this request against.
 Valid choices are defined in PoshRack configuration file.

 .PARAMETER LBID
 An object of type net.openstack.Providers.Rackspace.Objects.LoadBalancers.LoadBalancerID that identifies the Load Balancer.

 .PARAMETER WaitForTask
 Specifies whether the calling function will wait for this task to complete (True) or continue without waiting (False).

 .PARAMETER RegionOverride
 This parameter will temporarily override the default region set in PoshRack configuration file.

 .EXAMPLE
 PS C:\Users\Administrator>


 .LINK
 http://api.rackspace.com/api-ref-load-balancers.html
#>
}

# Issue 93 Implement Remove-CloudLoadBalancerSslConfiguration
function Remove-RSLBSSLConfiguration {
    Param(
        [Parameter (Mandatory=$True)] [string] $Account = $(throw "Please specify required Cloud Account by using the -Account parameter"),
        [Parameter (Mandatory=$True)] [net.openstack.Providers.Rackspace.Objects.LoadBalancers.LoadBalancerId] $LBID = $(throw "Please specify the required Load Balancer ID by using the -LBID parameter"),
        [Parameter (Mandatory=$False)][bool]   $WaitForTask = $False,
        [Parameter (Mandatory=$False)][string] $RegionOverride
    )

    Get-OpenStackAccount -Account $Account
    
    if ($RegionOverride){
        $Global:RegionOverride = $RegionOverride
    }

    # Use Region code associated with Account, or was an override provided?
    if ($RegionOverride) {
        $Region = $Global:RegionOverride
    } else {
        $Region = $Credentials.Region
    }


    $LBProvider = Get-RSLBProvider -Account rackiad -RegionOverride $Region

    try {

        # DEBUGGING       
        Write-Debug -Message "Remove-RSLBSSLConfiguration"
        Write-Debug -Message "Account.........................: $Account" 
        Write-Debug -Message "LBID............................: $LBID"
        Write-Debug -Message "WaitForTask.....................: $WaitForTask"
        Write-Debug -Message "Region..........................: $Region" 

        $CancellationToken = New-Object ([System.Threading.CancellationToken]::None)

        if($WaitForTask) {
            $LBProvider.RemoveSslConfigurationAsync($LBID, [net.openstack.Core.AsyncCompletionOption]::RequestCompleted, $CancellationToken, $null).Result
        } else {
            $LBProvider.RemoveSslConfigurationAsync($LBID, [net.openstack.Core.AsyncCompletionOption]::RequestSubmitted, $CancellationToken, $null).Result
        }

    }
    catch {
        Invoke-Exception($_.Exception)
    }
<#
 .SYNOPSIS
 Remove SSL Configuration.

 .DESCRIPTION
 The Remove-RSLBSSLConfiguration cmdlet will remove the SSL configuration for a load balancer
 
 .PARAMETER Account
 Use this parameter to indicate which account you would like to execute this request against.
 Valid choices are defined in PoshRack configuration file.

 .PARAMETER LBID
 An object of type net.openstack.Providers.Rackspace.Objects.LoadBalancers.LoadBalancerID that identifies the Load Balancer.

 .PARAMETER WaitForTask
 Specifies whether the calling function will wait for this task to complete (True) or continue without waiting (False).

 .PARAMETER RegionOverride
 This parameter will temporarily override the default region set in PoshRack configuration file.

 .EXAMPLE
 PS C:\Users\Administrator>


 .LINK
 http://api.rackspace.com/api-ref-load-balancers.html
#>
}

# Issue 94 Implement Remove-CloudLoadBalancerThrottles
function Remove-RSLBThrottle {
    Param(
        [Parameter (Mandatory=$True)] [string] $Account = $(throw "Please specify required Cloud Account by using the -Account parameter"),
        [Parameter (Mandatory=$True)] [net.openstack.Providers.Rackspace.Objects.LoadBalancers.LoadBalancerId] $LBID = $(throw "Please specify the required Load Balancer ID by using the -LBID parameter"),
        [Parameter (Mandatory=$False)][bool]   $WaitForTask = $False,
        [Parameter (Mandatory=$False)][string] $RegionOverride
    )

    Get-OpenStackAccount -Account $Account
    
    if ($RegionOverride){
        $Global:RegionOverride = $RegionOverride
    }

    # Use Region code associated with Account, or was an override provided?
    if ($RegionOverride) {
        $Region = $Global:RegionOverride
    } else {
        $Region = $Credentials.Region
    }


    $LBProvider = Get-RSLBProvider -Account rackiad -RegionOverride $Region

    try {

        # DEBUGGING       
        Write-Debug -Message "Remove-RSLBThrottle"
        Write-Debug -Message "Account.........................: $Account" 
        Write-Debug -Message "LBID............................: $LBID"
        Write-Debug -Message "WaitForTask.....................: $WaitForTask"
        Write-Debug -Message "Region..........................: $Region" 

        $CancellationToken = New-Object ([System.Threading.CancellationToken]::None)

        if($WaitForTask) {
            $LBProvider.RemoveThrottlesAsync($LBID, [net.openstack.Core.AsyncCompletionOption]::RequestCompleted, $CancellationToken, $null).Result
        } else {
            $LBProvider.RemoveThrottlesAsync($LBID, [net.openstack.Core.AsyncCompletionOption]::RequestSubmitted, $CancellationToken, $null).Result
        }

    }
    catch {
        Invoke-Exception($_.Exception)
    }
<#
 .SYNOPSIS
 Remove SSL Configuration.

 .DESCRIPTION
 The Remove-RSLBThrottle cmdlet will remove the connection throttling configuration for a load balancer.
 
 .PARAMETER Account
 Use this parameter to indicate which account you would like to execute this request against.
 Valid choices are defined in PoshRack configuration file.

 .PARAMETER LBID
 An object of type net.openstack.Providers.Rackspace.Objects.LoadBalancers.LoadBalancerID that identifies the Load Balancer.

 .PARAMETER WaitForTask
 Specifies whether the calling function will wait for this task to complete (True) or continue without waiting (False).

 .PARAMETER RegionOverride
 This parameter will temporarily override the default region set in PoshRack configuration file.

 .EXAMPLE
 PS C:\Users\Administrator>


 .LINK
 http://api.rackspace.com/api-ref-load-balancers.html
#>
}

# Issue 95 Implement Remove-CloudLoadBalancerVirtualAddress
# Issue 96 Implement Remove-CloudLoadBalancerVirtualAddressRange
function Remove-RSLBVirtualAddress {
    Param(
        [Parameter (Mandatory=$True)] [string] $Account = $(throw "Please specify required Cloud Account by using the -Account parameter"),
        [Parameter (Mandatory=$True)] [net.openstack.Providers.Rackspace.Objects.LoadBalancers.LoadBalancerId] $LBID = $null,
        [Parameter (Mandatory=$False)][net.openstack.Providers.Rackspace.Objects.LoadBalancers.VirtualAddressId] $VirtualAddressID = $null,
        [Parameter (Mandatory=$False)][net.openstack.Providers.Rackspace.Objects.LoadBalancers.VirtualAddressId[]] $ListOfVirtualAddressIDs = $null,
        [Parameter (Mandatory=$False)][bool]   $WaitForTask = $False,
        [Parameter (Mandatory=$False)][string] $RegionOverride
    )

    Get-OpenStackAccount -Account $Account
    
    if ($RegionOverride){
        $Global:RegionOverride = $RegionOverride
    }

    # Use Region code associated with Account, or was an override provided?
    if ($RegionOverride) {
        $Region = $Global:RegionOverride
    } else {
        $Region = $Credentials.Region
    }


    $LBProvider = Get-RSLBProvider -Account rackiad -RegionOverride $Region

    try {

        # DEBUGGING       
        Write-Debug -Message "Remove-RSLBVirtualAddress"
        Write-Debug -Message "Account.........................: $Account" 
        Write-Debug -Message "LBID............................: $LBID"
        Write-Debug -Message "VirtualAddressID................: $VirtualAddressID"
        Write-Debug -Message "ListOfVirtualAddressIDs.........: $ListOfVirtualAddressIDs"
        Write-Debug -Message "WaitForTask.....................: $WaitForTask"
        Write-Debug -Message "Region..........................: $Region" 

        $CancellationToken = New-Object ([System.Threading.CancellationToken]::None)

        if (![string]::IsNullOrEmpty($VirtualAddressID)) {
            if($WaitForTask) {
                $LBProvider.RemoveVirtualAddressAsync($LBID, $VirtualAddressID, [net.openstack.Core.AsyncCompletionOption]::RequestCompleted, $CancellationToken, $null).Result
            } else {
                $LBProvider.RemoveVirtualAddressAsync($LBID, $VirtualAddressID, [net.openstack.Core.AsyncCompletionOption]::RequestSubmitted, $CancellationToken, $null).Result
            }
        } else {
            if($WaitForTask) {
                $LBProvider.RemoveVirtualAddressRangeAsync($LBID, $ListOfVirtualAddressIDs, [net.openstack.Core.AsyncCompletionOption]::RequestCompleted, $CancellationToken, $null).Result
            } else {
                $LBProvider.RemoveVirtualAddressRangeAsync($LBID, $ListOfVirtualAddressIDs, [net.openstack.Core.AsyncCompletionOption]::RequestSubmitted, $CancellationToken, $null).Result
            }
        }
    }
    catch {
        Invoke-Exception($_.Exception)
    }
<#
 .SYNOPSIS
 Remove one or more nodes.

 .DESCRIPTION
 The Remove-RSLBVirtualAddress cmdlet will remove one or more virtual addresses associated with a load balancer.
 
 .PARAMETER Account
 Use this parameter to indicate which account you would like to execute this request against.
 Valid choices are defined in PoshRack configuration file.

 .PARAMETER LBID
 An object of type net.openstack.Providers.Rackspace.Objects.LoadBalancers.LoadBalancerID that identifies the Load Balancer.

 .PARAMETER VirtualAddressID
 An object of type net.openstack.Providers.Rackspace.Objects.LoadBalancers.VirtualAddressId that identifies a single virtual address to be removed.

 .PARAMETER ListOfVirtualAddressIDs
 A list of virtual addresses to be removed.
 
 .PARAMETER WaitForTask
 Specifies whether the calling function will wait for this task to complete (True) or continue without waiting (False).

 .PARAMETER RegionOverride
 This parameter will temporarily override the default region set in PoshRack configuration file.

 .EXAMPLE
 PS C:\Users\Administrator>


 .LINK
 http://api.rackspace.com/api-ref-load-balancers.html
#>
}

# Issue 97 Implement Set-CloudLoadBalancerConnectionLogging
function Set-RSLBConnectionLogging {
    Param(
        [Parameter (Mandatory=$True)] [string] $Account = $(throw "Please specify required Cloud Account by using the -Account parameter"),
        [Parameter (Mandatory=$True)] [net.openstack.Providers.Rackspace.Objects.LoadBalancers.LoadBalancerId] $LBID = $(throw "Please specify the required Load Balancer ID by using the -LBID parameter"),
        [Parameter (Mandatory=$False)][bool]   $Enabled = $True,
        [Parameter (Mandatory=$False)][bool]   $WaitForTask = $False,
        [Parameter (Mandatory=$False)][string] $RegionOverride
    )

    Get-OpenStackAccount -Account $Account
    
    if ($RegionOverride){
        $Global:RegionOverride = $RegionOverride
    }

    # Use Region code associated with Account, or was an override provided?
    if ($RegionOverride) {
        $Region = $Global:RegionOverride
    } else {
        $Region = $Credentials.Region
    }


    $LBProvider = Get-RSLBProvider -Account rackiad -RegionOverride $Region

    try {

        # DEBUGGING       
        Write-Debug -Message "Set-RSLBConnectionLogging"
        Write-Debug -Message "Account.........................: $Account" 
        Write-Debug -Message "LBID............................: $LBID"
        Write-Debug -Message "Enabled.........................: $Enabled"
        Write-Debug -Message "WaitForTask.....................: $WaitForTask"
        Write-Debug -Message "Region..........................: $Region" 

        $CancellationToken = New-Object ([System.Threading.CancellationToken]::None)

        if($WaitForTask) {
            $LBProvider.SetConnectionLoggingAsync($LBID, $Enabled, [net.openstack.Core.AsyncCompletionOption]::RequestCompleted, $CancellationToken, $null).Result
        } else {
            $LBProvider.SetConnectionLoggingAsync($LBID, $Enabled, [net.openstack.Core.AsyncCompletionOption]::RequestSubmitted, $CancellationToken, $null).Result
        }

    }
    catch {
        Invoke-Exception($_.Exception)
    }
<#
 .SYNOPSIS
 Enable/Disable Connection Logging.

 .DESCRIPTION
 The Set-RSLBConnectionLogging cmdlet will allow you to enable or disable a load balancer's connection logging.
 
 .PARAMETER Account
 Use this parameter to indicate which account you would like to execute this request against.
 Valid choices are defined in PoshRack configuration file.

 .PARAMETER LBID
 An object of type net.openstack.Providers.Rackspace.Objects.LoadBalancers.LoadBalancerID that identifies the Load Balancer.

 .PARAMETER Enabled
 True turns on Connection Logging, False turns it off.

 .PARAMETER WaitForTask
 Specifies whether the calling function will wait for this task to complete (True) or continue without waiting (False).

 .PARAMETER RegionOverride
 This parameter will temporarily override the default region set in PoshRack configuration file.

 .EXAMPLE
 PS C:\Users\Administrator>


 .LINK
 http://api.rackspace.com/api-ref-load-balancers.html
#>
}

# Issue 98 Implement Set-CloudLoadBalancerContentCaching
function Set-RSLBContentCaching {
    Param(
        [Parameter (Mandatory=$True)] [string] $Account = $(throw "Please specify required Cloud Account by using the -Account parameter"),
        [Parameter (Mandatory=$True)] [net.openstack.Providers.Rackspace.Objects.LoadBalancers.LoadBalancerId] $LBID = $(throw "Please specify the required Load Balancer ID by using the -LBID parameter"),
        [Parameter (Mandatory=$False)][bool]   $Enabled = $True,
        [Parameter (Mandatory=$False)][bool]   $WaitForTask = $False,
        [Parameter (Mandatory=$False)][string] $RegionOverride
    )

    Get-OpenStackAccount -Account $Account
    
    if ($RegionOverride){
        $Global:RegionOverride = $RegionOverride
    }

    # Use Region code associated with Account, or was an override provided?
    if ($RegionOverride) {
        $Region = $Global:RegionOverride
    } else {
        $Region = $Credentials.Region
    }


    $LBProvider = Get-RSLBProvider -Account rackiad -RegionOverride $Region

    try {

        # DEBUGGING       
        Write-Debug -Message "Set-RSLBContentCaching"
        Write-Debug -Message "Account.........................: $Account" 
        Write-Debug -Message "LBID............................: $LBID"
        Write-Debug -Message "Enabled.........................: $Enabled"
        Write-Debug -Message "WaitForTask.....................: $WaitForTask"
        Write-Debug -Message "Region..........................: $Region" 

        $CancellationToken = New-Object ([System.Threading.CancellationToken]::None)

        if($WaitForTask) {
            $LBProvider.SetContentCachingAsync($LBID, $Enabled, [net.openstack.Core.AsyncCompletionOption]::RequestCompleted, $CancellationToken, $null).Result
        } else {
            $LBProvider.SetContentCachingAsync($LBID, $Enabled, [net.openstack.Core.AsyncCompletionOption]::RequestSubmitted, $CancellationToken, $null).Result
        }

    }
    catch {
        Invoke-Exception($_.Exception)
    }
<#
 .SYNOPSIS
 Enable/Disable content caching.

 .DESCRIPTION
 The Set-RSLBContentCaching cmdlet will allow you to enable or disable a load balancer's content caching.
 
 .PARAMETER Account
 Use this parameter to indicate which account you would like to execute this request against.
 Valid choices are defined in PoshRack configuration file.

 .PARAMETER LBID
 An object of type net.openstack.Providers.Rackspace.Objects.LoadBalancers.LoadBalancerID that identifies the Load Balancer.

 .PARAMETER Enabled
 True turns on Content Caching, False turns it off.

 .PARAMETER WaitForTask
 Specifies whether the calling function will wait for this task to complete (True) or continue without waiting (False).

 .PARAMETER RegionOverride
 This parameter will temporarily override the default region set in PoshRack configuration file.

 .EXAMPLE
 PS C:\Users\Administrator>


 .LINK
 http://api.rackspace.com/api-ref-load-balancers.html
#>
}

# Issue 99 Implement Set-CloudLoadBalancerErrorPage
function Set-RSLBErrorPage {
    Param(
        [Parameter (Mandatory=$True)] [string] $Account = $(throw "Please specify required Cloud Account by using the -Account parameter"),
        [Parameter (Mandatory=$True)] [net.openstack.Providers.Rackspace.Objects.LoadBalancers.LoadBalancerId] $LBID = $(throw "Please specify the required Load Balancer ID by using the -LBID parameter"),
        [Parameter (Mandatory=$True)] [string] $Content = $(throw "Please specify the required HTML Content for the error page by using the -Content parameter"),
        [Parameter (Mandatory=$False)][bool]   $WaitForTask = $False,
        [Parameter (Mandatory=$False)][string] $RegionOverride
    )

    Get-OpenStackAccount -Account $Account
    
    if ($RegionOverride){
        $Global:RegionOverride = $RegionOverride
    }

    # Use Region code associated with Account, or was an override provided?
    if ($RegionOverride) {
        $Region = $Global:RegionOverride
    } else {
        $Region = $Credentials.Region
    }


    $LBProvider = Get-RSLBProvider -Account rackiad -RegionOverride $Region

    try {

        # DEBUGGING       
        Write-Debug -Message "Set-RSLBErrorPage"
        Write-Debug -Message "Account.........................: $Account" 
        Write-Debug -Message "LBID............................: $LBID"
        Write-Debug -Message "Content.........................: $Content"
        Write-Debug -Message "WaitForTask.....................: $WaitForTask"
        Write-Debug -Message "Region..........................: $Region" 

        $CancellationToken = New-Object ([System.Threading.CancellationToken]::None)

        if($WaitForTask) {
            $LBProvider.SetErrorPageAsync($LBID, $Content, [net.openstack.Core.AsyncCompletionOption]::RequestCompleted, $CancellationToken, $null).Result
        } else {
            $LBProvider.SetErrorPageAsync($LBID, $Content, [net.openstack.Core.AsyncCompletionOption]::RequestSubmitted, $CancellationToken, $null).Result
        }

    }
    catch {
        Invoke-Exception($_.Exception)
    }
<#
 .SYNOPSIS
 Set error page HTML.

 .DESCRIPTION
 The Set-RSLBErrorPage cmdlet sets the HTML content of the custom error page which is shown to an end user who is attempting to access a load balancer node that is offline or unavailable.
 
 .PARAMETER Account
 Use this parameter to indicate which account you would like to execute this request against.
 Valid choices are defined in PoshRack configuration file.

 .PARAMETER LBID
 An object of type net.openstack.Providers.Rackspace.Objects.LoadBalancers.LoadBalancerID that identifies the Load Balancer.

 .PARAMETER Content
 The HTML content of the error page.

 .PARAMETER WaitForTask
 Specifies whether the calling function will wait for this task to complete (True) or continue without waiting (False).

 .PARAMETER RegionOverride
 This parameter will temporarily override the default region set in PoshRack configuration file.

 .EXAMPLE
 PS C:\Users\Administrator>


 .LINK
 http://api.rackspace.com/api-ref-load-balancers.html
#>
}

# Issue 100 Implement Set-CloudLoadBalancerHealthMonitor
function Set-RSLBHealthMonitor {
    Param(
        [Parameter (Mandatory=$True)] [string] $Account = $(throw "Please specify required Cloud Account by using the -Account parameter"),
        [Parameter (Mandatory=$True)] [net.openstack.Providers.Rackspace.Objects.LoadBalancers.LoadBalancerId] $LBID = $(throw "Please specify the required Load Balancer ID by using the -LBID parameter"),
        [Parameter (Mandatory=$True)] [net.openstack.Providers.Rackspace.Objects.LoadBalancers.HealthMonitor] $HealthMonitor = $(throw "Please specify the required Health Monitor by using the -HealthMonitor parameter"),
        [Parameter (Mandatory=$False)][bool]   $WaitForTask = $False,
        [Parameter (Mandatory=$False)][string] $RegionOverride
    )

    Get-OpenStackAccount -Account $Account
    
    if ($RegionOverride){
        $Global:RegionOverride = $RegionOverride
    }

    # Use Region code associated with Account, or was an override provided?
    if ($RegionOverride) {
        $Region = $Global:RegionOverride
    } else {
        $Region = $Credentials.Region
    }


    $LBProvider = Get-RSLBProvider -Account rackiad -RegionOverride $Region

    try {

        # DEBUGGING       
        Write-Debug -Message "Set-RSLBHealthMonitor"
        Write-Debug -Message "Account.........................: $Account" 
        Write-Debug -Message "LBID............................: $LBID"
        Write-Debug -Message "HealthMonitor...................: $HealthMonitor"
        Write-Debug -Message "WaitForTask.....................: $WaitForTask"
        Write-Debug -Message "Region..........................: $Region" 

        $CancellationToken = New-Object ([System.Threading.CancellationToken]::None)

        if($WaitForTask) {
            $LBProvider.SetHealthMonitorAsync($LBID, $HealthMonitor, [net.openstack.Core.AsyncCompletionOption]::RequestCompleted, $CancellationToken, $null).Result
        } else {
            $LBProvider.SetHealthMonitorAsync($LBID, $HealthMonitor, [net.openstack.Core.AsyncCompletionOption]::RequestSubmitted, $CancellationToken, $null).Result
        }

    }
    catch {
        Invoke-Exception($_.Exception)
    }
<#
 .SYNOPSIS
 Set a Health Monitor.

 .DESCRIPTION
 The Set-RSLBHealthMonitor cmdlet sets the health monitor configuration for a load balancer.
 
 .PARAMETER Account
 Use this parameter to indicate which account you would like to execute this request against.
 Valid choices are defined in PoshRack configuration file.

 .PARAMETER LBID
 An object of type net.openstack.Providers.Rackspace.Objects.LoadBalancers.LoadBalancerID that identifies the Load Balancer.

 .PARAMETER HealthMonitor
 The updated health monitor configuration..

 .PARAMETER WaitForTask
 Specifies whether the calling function will wait for this task to complete (True) or continue without waiting (False).

 .PARAMETER RegionOverride
 This parameter will temporarily override the default region set in PoshRack configuration file.

 .EXAMPLE
 PS C:\Users\Administrator>


 .LINK
 http://api.rackspace.com/api-ref-load-balancers.html
#>
}

# Issue #101 Implement Set-CloudLoadBalancerSessionPersistence
function Set-RSLBSessionPersistence {
    Param(
        [Parameter (Mandatory=$True)] [string] $Account = $(throw "Please specify required Cloud Account by using the -Account parameter"),
        [Parameter (Mandatory=$True)] [net.openstack.Providers.Rackspace.Objects.LoadBalancers.LoadBalancerId] $LBID = $(throw "Please specify the required Load Balancer ID by using the -LBID parameter"),
        [Parameter (Mandatory=$True)] [net.openstack.Providers.Rackspace.Objects.LoadBalancers.SessionPersistence] $SessionPersistence = $(throw "Please specify the required Session Persistence by using the -SessionPersistence parameter"),
        [Parameter (Mandatory=$False)][bool]   $WaitForTask = $False,
        [Parameter (Mandatory=$False)][string] $RegionOverride
    )

    Get-OpenStackAccount -Account $Account
    
    if ($RegionOverride){
        $Global:RegionOverride = $RegionOverride
    }

    # Use Region code associated with Account, or was an override provided?
    if ($RegionOverride) {
        $Region = $Global:RegionOverride
    } else {
        $Region = $Credentials.Region
    }


    $LBProvider = Get-RSLBProvider -Account rackiad -RegionOverride $Region

    try {

        # DEBUGGING       
        Write-Debug -Message "Set-RSLBSessionPersistence"
        Write-Debug -Message "Account.........................: $Account" 
        Write-Debug -Message "LBID............................: $LBID"
        Write-Debug -Message "SessionPersistence..............: $SessionPersistence"
        Write-Debug -Message "WaitForTask.....................: $WaitForTask"
        Write-Debug -Message "Region..........................: $Region" 

        $CancellationToken = New-Object ([System.Threading.CancellationToken]::None)

        if($WaitForTask) {
            $LBProvider.SetSessionPersistenceAsync($LBID, $SessionPersistence, [net.openstack.Core.AsyncCompletionOption]::RequestCompleted, $CancellationToken, $null).Result
        } else {
            $LBProvider.SetSessionPersistenceAsync($LBID, $SessionPersistence, [net.openstack.Core.AsyncCompletionOption]::RequestSubmitted, $CancellationToken, $null).Result
        }

    }
    catch {
        Invoke-Exception($_.Exception)
    }
<#
 .SYNOPSIS
 Set session persistence.

 .DESCRIPTION
 The Set-RSLBSessionPersistence cmdlet sets the session persistence configuration for a load balancer.
 
 .PARAMETER Account
 Use this parameter to indicate which account you would like to execute this request against.
 Valid choices are defined in PoshRack configuration file.

 .PARAMETER LBID
 An object of type net.openstack.Providers.Rackspace.Objects.LoadBalancers.LoadBalancerID that identifies the Load Balancer.

 .PARAMETER SessionPersistence
 The session persistence configuration.

 .PARAMETER WaitForTask
 Specifies whether the calling function will wait for this task to complete (True) or continue without waiting (False).

 .PARAMETER RegionOverride
 This parameter will temporarily override the default region set in PoshRack configuration file.

 .EXAMPLE
 PS C:\Users\Administrator>


 .LINK
 http://api.rackspace.com/api-ref-load-balancers.html
#>
}

# Issue 102 Implement Update-CloudLoadBalancer
function Update-RSLoadBalancer {
    Param(
        [Parameter (Mandatory=$True)] [string] $Account = $(throw "Please specify required Cloud Account by using the -Account parameter"),
        [Parameter (Mandatory=$True)] [net.openstack.Providers.Rackspace.Objects.LoadBalancers.LoadBalancerId] $LBID = $(throw "Please specify the required Load Balancer ID by using the -LBID parameter"),
        [Parameter (Mandatory=$True)] [net.openstack.Providers.Rackspace.Objects.LoadBalancers.LoadBalancerUpdate] $LBUpdate = $(throw "Please specify the required Load Balancer Update infomration by using the -LBUpdate parameter"),
        [Parameter (Mandatory=$False)][bool]   $WaitForTask = $False,
        [Parameter (Mandatory=$False)][string] $RegionOverride
    )

    Get-OpenStackAccount -Account $Account
    
    if ($RegionOverride){
        $Global:RegionOverride = $RegionOverride
    }

    # Use Region code associated with Account, or was an override provided?
    if ($RegionOverride) {
        $Region = $Global:RegionOverride
    } else {
        $Region = $Credentials.Region
    }


    $LBProvider = Get-RSLBProvider -Account rackiad -RegionOverride $Region

    try {

        # DEBUGGING       
        Write-Debug -Message "Update-RSLoadBalancer"
        Write-Debug -Message "Account.........................: $Account" 
        Write-Debug -Message "LBID............................: $LBID"
        Write-Debug -Message "LBUpdate........................: $LBUpdate"
        Write-Debug -Message "WaitForTask.....................: $WaitForTask"
        Write-Debug -Message "Region..........................: $Region" 

        $CancellationToken = New-Object ([System.Threading.CancellationToken]::None)

 #           await clbp.UpdateLoadBalancerAsync(loadBalancerId, lbUpdate, AsyncCompletionOption.RequestCompleted, CancellationToken.None, null);

        if($WaitForTask) {
            $LBProvider.UpdateLoadBalancerAsync($LBID, $LBUpdate, [net.openstack.Core.AsyncCompletionOption]::RequestCompleted, $CancellationToken, $null).Result
        } else {
            $LBProvider.UpdateLoadBalancerAsync($LBID, $LBUpdate, [net.openstack.Core.AsyncCompletionOption]::RequestSubmitted, $CancellationToken, $null).Result
        }

    }
    catch {
        Invoke-Exception($_.Exception)
    }
<#
 .SYNOPSIS
 Update load balancer.

 .DESCRIPTION
 The Update-RSLoadBalancer cmdlet updates attributes for an existing load balancer.
 
 .PARAMETER Account
 Use this parameter to indicate which account you would like to execute this request against.
 Valid choices are defined in PoshRack configuration file.

 .PARAMETER LBID
 An object of type net.openstack.Providers.Rackspace.Objects.LoadBalancers.LoadBalancerID that identifies the Load Balancer.

 .PARAMETER LBUpdate
 An object of type net.openstack.Providers.Rackspace.Objects.LoadBalancers.LoadBalancerUpdate that contains the updated information for the Load Balancer.

 .PARAMETER WaitForTask
 Specifies whether the calling function will wait for this task to complete (True) or continue without waiting (False).

 .PARAMETER RegionOverride
 This parameter will temporarily override the default region set in PoshRack configuration file.

 .EXAMPLE
 PS C:\Users\Administrator>


 .LINK
 http://api.rackspace.com/api-ref-load-balancers.html
#>
}

# Issue #103 Implement Update-CloudLoadBalancerMetadataItem
function Update-RSLBMetadataItem {
    Param(
        [Parameter (Mandatory=$True)] [string] $Account = $(throw "Please specify required Cloud Account by using the -Account parameter"),
        [Parameter (Mandatory=$True)] [net.openstack.Providers.Rackspace.Objects.LoadBalancers.LoadBalancerId] $LBID = $(throw "Please specify the required Load Balancer ID by using the -LBID parameter"),
        [Parameter (Mandatory=$True)] [net.openstack.Providers.Rackspace.Objects.LoadBalancers.MetadataId] $MetadataID = $(throw "Please specify the required Metadata ID by using the -MetadataID parameter"),
        [Parameter (Mandatory=$True)] [string] $Metadata = $(throw "Please specify the required metadata information by using the -Metadata parameter."),
        [Parameter (Mandatory=$False)][string] $RegionOverride
    )

    Get-OpenStackAccount -Account $Account
    
    if ($RegionOverride){
        $Global:RegionOverride = $RegionOverride
    }

    # Use Region code associated with Account, or was an override provided?
    if ($RegionOverride) {
        $Region = $Global:RegionOverride
    } else {
        $Region = $Credentials.Region
    }


    $LBProvider = Get-RSLBProvider -Account rackiad -RegionOverride $Region

    try {

        # DEBUGGING       
        Write-Debug -Message "Update-RSLBMetadataItem"
        Write-Debug -Message "Account.........................: $Account" 
        Write-Debug -Message "LBID............................: $LBID"
        Write-Debug -Message "MetadataID......................: $MetadataID"
        Write-Debug -Message "Metadata........................: $Metadata"
        Write-Debug -Message "Region..........................: $Region" 

        $CancellationToken = New-Object ([System.Threading.CancellationToken]::None)

        $LBProvider.UpdateLoadBalancerMetadataItemAsync($LBID, $MetadataID, $Metadata, $CancellationToken, $null).Result

    }
    catch {
        Invoke-Exception($_.Exception)
    }
<#
 .SYNOPSIS
 Update load balancer metadata item.

 .DESCRIPTION
 The Update-RSLBMetadataItem cmdlet sets the value for a metadata item associated with a load balancer.
 
 .PARAMETER Account
 Use this parameter to indicate which account you would like to execute this request against.
 Valid choices are defined in PoshRack configuration file.

 .PARAMETER LBID
 An object of type net.openstack.Providers.Rackspace.Objects.LoadBalancers.LoadBalancerID that identifies the Load Balancer.

 .PARAMETER MetadataID
 An object of type net.openstack.Providers.Rackspace.Objects.LoadBalancers.MetadataId that identifies the metadata item to be updated.

 .PARAMETER Metadata
 The new value for the metadata item.

 .PARAMETER RegionOverride
 This parameter will temporarily override the default region set in PoshRack configuration file.

 .EXAMPLE
 PS C:\Users\Administrator>


 .LINK
 http://api.rackspace.com/api-ref-load-balancers.html
#>
}

# Issue 104 Implement Update-CloudLoadBalancerNode
function Update-RSLBNode {
    Param(
        [Parameter (Mandatory=$True)] [string] $Account = $(throw "Please specify required Cloud Account by using the -Account parameter"),
        [Parameter (Mandatory=$True)] [net.openstack.Providers.Rackspace.Objects.LoadBalancers.LoadBalancerId] $LBID = $(throw "Please specify the required Load Balancer ID by using the -LBID parameter"),
        [Parameter (Mandatory=$True)] [net.openstack.Providers.Rackspace.Objects.LoadBalancers.NodeId] $NodeID = $(throw "Please specify the required Node ID by using the -NodeID parameter"),
        [Parameter (Mandatory=$True)] [net.openstack.Providers.Rackspace.Objects.LoadBalancers.NodeUpdate] $NodeUpdate = $(throw "Please specify the required Node Update information by using the -NodeUpdate parameter"),
        [Parameter (Mandatory=$False)][bool]   $WaitForTask = $False,
        [Parameter (Mandatory=$False)][string] $RegionOverride
    )

    Get-OpenStackAccount -Account $Account
    
    if ($RegionOverride){
        $Global:RegionOverride = $RegionOverride
    }

    # Use Region code associated with Account, or was an override provided?
    if ($RegionOverride) {
        $Region = $Global:RegionOverride
    } else {
        $Region = $Credentials.Region
    }


    $LBProvider = Get-RSLBProvider -Account rackiad -RegionOverride $Region

    try {

        # DEBUGGING       
        Write-Debug -Message "Update-RSLBNode"
        Write-Debug -Message "Account.........................: $Account" 
        Write-Debug -Message "LBID............................: $LBID"
        Write-Debug -Message "NodeID..........................: $NodeID"
        Write-Debug -Message "NodeUpdate......................: $NodeUpdate"
        Write-Debug -Message "WaitForTask.....................: $WaitForTask"
        Write-Debug -Message "Region..........................: $Region" 

        $CancellationToken = New-Object ([System.Threading.CancellationToken]::None)

        if($WaitForTask) {
            $LBProvider.UpdateNodeAsync($LBID, $NodeID, $NodeUpdate, [net.openstack.Core.AsyncCompletionOption]::RequestCompleted, $CancellationToken, $null).Result
        } else {
            $LBProvider.UpdateNodeAsync($LBID, $NodeID, $NodeUpdate, [net.openstack.Core.AsyncCompletionOption]::RequestSubmitted, $CancellationToken, $null).Result
        }

    }
    catch {
        Invoke-Exception($_.Exception)
    }
<#
 .SYNOPSIS
 Update load balancer.

 .DESCRIPTION
 The Update-RSLBNode cmdlet updates the configuration of a load balancer node.
 
 .PARAMETER Account
 Use this parameter to indicate which account you would like to execute this request against.
 Valid choices are defined in PoshRack configuration file.

 .PARAMETER LBID
 An object of type net.openstack.Providers.Rackspace.Objects.LoadBalancers.LoadBalancerID that identifies the Load Balancer.

 .PARAMETER NodeID
 An object of type net.openstack.Providers.Rackspace.Objects.LoadBalancers.LoadBalancerUpdate that contains the updated information for the Load Balancer.

 .PARAMETER WaitForTask
 Specifies whether the calling function will wait for this task to complete (True) or continue without waiting (False).

 .PARAMETER RegionOverride
 This parameter will temporarily override the default region set in PoshRack configuration file.

 .EXAMPLE
 PS C:\Users\Administrator>


 .LINK
 http://api.rackspace.com/api-ref-load-balancers.html
#>
}

# Issue 105 Implement Update-CloudLoadBalancerNodeMetadataItem
function Update-RSLBNodeMetadataItem {
    Param(
        [Parameter (Mandatory=$True)] [string] $Account = $(throw "Please specify required Cloud Account by using the -Account parameter"),
        [Parameter (Mandatory=$True)] [net.openstack.Providers.Rackspace.Objects.LoadBalancers.LoadBalancerId] $LBID = $(throw "Please specify the required Load Balancer ID by using the -LBID parameter"),
        [Parameter (Mandatory=$True)] [net.openstack.Providers.Rackspace.Objects.LoadBalancers.NodeId] $NodeID = $(throw "Please specify the required Node ID by using the -NodeID parameter"),
        [Parameter (Mandatory=$True)] [net.openstack.Providers.Rackspace.Objects.LoadBalancers.MetadataId] $MetadataID = $(throw "Please specify the required Metadata Item ID by using the -MetadataID parameter"),
        [Parameter (Mandatory=$True)] [string] $NewValue = $(throw "Please specify the required metadata value by using the -NewValue parameter."),
        [Parameter (Mandatory=$False)][string] $RegionOverride
    )

    Get-OpenStackAccount -Account $Account
    
    if ($RegionOverride){
        $Global:RegionOverride = $RegionOverride
    }

    # Use Region code associated with Account, or was an override provided?
    if ($RegionOverride) {
        $Region = $Global:RegionOverride
    } else {
        $Region = $Credentials.Region
    }


    $LBProvider = Get-RSLBProvider -Account rackiad -RegionOverride $Region

    try {

        # DEBUGGING       
        Write-Debug -Message "Update-RSLBNodeMetadataItem"
        Write-Debug -Message "Account.........................: $Account" 
        Write-Debug -Message "LBID............................: $LBID"
        Write-Debug -Message "NodeID..........................: $NodeID"
        Write-Debug -Message "MetadataID......................: $MetadataID"
        Write-Debug -Message "NewValue........................: $NewValue"
        Write-Debug -Message "Region..........................: $Region" 

        $CancellationToken = New-Object ([System.Threading.CancellationToken]::None)

        $LBProvider.UpdateNodeMetadataItemAsync($LBID, $NodeID, $MetadataID, $NewValue, $CancellationToken).Result

    }
    catch {
        Invoke-Exception($_.Exception)
    }
<#
 .SYNOPSIS
 Update load balancer.

 .DESCRIPTION
 The Update-RSLBNodeMetadataItem cmdlet updates a metadata item of a load balancer node.
 
 .PARAMETER Account
 Use this parameter to indicate which account you would like to execute this request against.
 Valid choices are defined in PoshRack configuration file.

 .PARAMETER LBID
 An object of type net.openstack.Providers.Rackspace.Objects.LoadBalancers.LoadBalancerID that identifies the Load Balancer.

 .PARAMETER NodeID
 An object of type net.openstack.Providers.Rackspace.Objects.LoadBalancers.LoadBalancerUpdate that contains the updated information for the Load Balancer.

 .PARAMETER MetadataID
 Identifies the metadata item.

 .PARAMETER $NewValue
 The new value of the metadata item.

 .PARAMETER RegionOverride
 This parameter will temporarily override the default region set in PoshRack configuration file.

 .EXAMPLE
 PS C:\Users\Administrator>


 .LINK
 http://api.rackspace.com/api-ref-load-balancers.html
#>
}

# Issue 106 Implement Update-CloudLoadBalancerSslConfiguration
function Update-RSLBSSLConfiguration {
    Param(
        [Parameter (Mandatory=$True)] [string] $Account = $(throw "Please specify required Cloud Account by using the -Account parameter"),
        [Parameter (Mandatory=$True)] [net.openstack.Providers.Rackspace.Objects.LoadBalancers.LoadBalancerId] $LBID = $(throw "Please specify the required Load Balancer ID by using the -LBID parameter"),
        [Parameter (Mandatory=$True)] [net.openstack.Providers.Rackspace.Objects.LoadBalancers.LoadBalancerSslConfiguration] $SSLConfiguration = $(throw "Please specify the required SSL Configuration by using the -SSLConfiguration parameter"),
        [Parameter (Mandatory=$False)][bool]   $WaitForTask = $False,
        [Parameter (Mandatory=$False)][string] $RegionOverride
    )

    Get-OpenStackAccount -Account $Account
    
    if ($RegionOverride){
        $Global:RegionOverride = $RegionOverride
    }

    # Use Region code associated with Account, or was an override provided?
    if ($RegionOverride) {
        $Region = $Global:RegionOverride
    } else {
        $Region = $Credentials.Region
    }


    $LBProvider = Get-RSLBProvider -Account rackiad -RegionOverride $Region

    try {

        # DEBUGGING       
        Write-Debug -Message "Update-RSLBSSLConfiguration"
        Write-Debug -Message "Account.........................: $Account" 
        Write-Debug -Message "LBID............................: $LBID"
        Write-Debug -Message "SSLConfiguration................: $SSLConfiguration"
        Write-Debug -Message "WaitForTask.....................: $WaitForTask" 
        Write-Debug -Message "Region..........................: $Region" 

        $CancellationToken = New-Object ([System.Threading.CancellationToken]::None)

        if($WaitForTask) {
            $LBProvider.UpdateSslConfigurationAsync($LBID, $SSLConfiguration, [net.openstack.Core.AsyncCompletionOption]::RequestCompleted, $CancellationToken, $null).Result
        } else {
            $LBProvider.UpdateSslConfigurationAsync($LBID, $SSLConfiguration, [net.openstack.Core.AsyncCompletionOption]::RequestSubmitted, $CancellationToken, $null).Result
        }

    }
    catch {
        Invoke-Exception($_.Exception)
    }
<#
 .SYNOPSIS
 Update SSL Configuration.

 .DESCRIPTION
 The Update-RSLBSSLConfiguration cmdlet updates the SSL termination configuration for a load balancer..
 
 .PARAMETER Account
 Use this parameter to indicate which account you would like to execute this request against.
 Valid choices are defined in PoshRack configuration file.

 .PARAMETER LBID
 An object of type net.openstack.Providers.Rackspace.Objects.LoadBalancers.LoadBalancerID that identifies the Load Balancer.

 .PARAMETER SSLConfiguration
 An object of type net.openstack.Providers.Rackspace.Objects.LoadBalancers.LoadBalancerSslConfiguration that contains the updated SSL Configuration for the Load Balancer.

 .PARAMETER WaitForTask
 Specifies whether the calling function will wait for this task to complete (True) or continue without waiting (False).

 .PARAMETER RegionOverride
 This parameter will temporarily override the default region set in PoshRack configuration file.

 .EXAMPLE
 PS C:\Users\Administrator>


 .LINK
 http://api.rackspace.com/api-ref-load-balancers.html
#>
}

# Issue 107 Implement Update-CloudLoadBalancerThrottles
function Update-RSLBConnectionThrottle {
    Param(
        [Parameter (Mandatory=$True)] [string] $Account = $(throw "Please specify required Cloud Account by using the -Account parameter"),
        [Parameter (Mandatory=$True)] [net.openstack.Providers.Rackspace.Objects.LoadBalancers.LoadBalancerId] $LBID = $(throw "Please specify the required Load Balancer ID by using the -LBID parameter"),
        [Parameter (Mandatory=$True)] [net.openstack.Providers.Rackspace.Objects.LoadBalancers.ConnectionThrottles] $Throttle = $(throw "Please specify the required connection throttle information by using the -ConnectionThrottle parameter"),
        [Parameter (Mandatory=$False)][bool]   $WaitForTask = $False,
        [Parameter (Mandatory=$False)][string] $RegionOverride
    )

    Get-OpenStackAccount -Account $Account
    
    if ($RegionOverride){
        $Global:RegionOverride = $RegionOverride
    }

    # Use Region code associated with Account, or was an override provided?
    if ($RegionOverride) {
        $Region = $Global:RegionOverride
    } else {
        $Region = $Credentials.Region
    }


    $LBProvider = Get-RSLBProvider -Account rackiad -RegionOverride $Region

    try {

        # DEBUGGING       
        Write-Debug -Message "Update-RSLBConnectionThrottle"
        Write-Debug -Message "Account.........................: $Account" 
        Write-Debug -Message "LBID............................: $LBID"
        Write-Debug -Message "ConnectionThrottle..............: $ConnectionThrottle"
        Write-Debug -Message "WaitForTask.....................: $WaitForTask" 
        Write-Debug -Message "Region..........................: $Region" 

        $CancellationToken = New-Object ([System.Threading.CancellationToken]::None)

        if($WaitForTask) {
            $LBProvider.UpdateThrottlesAsync($LBID, $ConnectionThrottle, [net.openstack.Core.AsyncCompletionOption]::RequestCompleted, $CancellationToken, $null).Result
        } else {
            $LBProvider.UpdateThrottlesAsync($LBID, $ConnectionThrottle, [net.openstack.Core.AsyncCompletionOption]::RequestSubmitted, $CancellationToken, $null).Result
        }

    }
    catch {
        Invoke-Exception($_.Exception)
    }
<#
 .SYNOPSIS
 Update Connection Throttles.

 .DESCRIPTION
 The Update-RSLBConnectionThrottle cmdlet updates the connection throttling configuration for a load balancer.
 
 .PARAMETER Account
 Use this parameter to indicate which account you would like to execute this request against.
 Valid choices are defined in PoshRack configuration file.

 .PARAMETER LBID
 An object of type net.openstack.Providers.Rackspace.Objects.LoadBalancers.LoadBalancerID that identifies the Load Balancer.

 .PARAMETER ConnectionThrottle
 An object of type net.openstack.Providers.Rackspace.Objects.LoadBalancers.ConnectionThrottles that contains the updated connetion throttles for the Load Balancer.

 .PARAMETER WaitForTask
 Specifies whether the calling function will wait for this task to complete (True) or continue without waiting (False).

 .PARAMETER RegionOverride
 This parameter will temporarily override the default region set in PoshRack configuration file.

 .EXAMPLE
 PS C:\Users\Administrator>


 .LINK
 http://api.rackspace.com/api-ref-load-balancers.html
#>
}

Export-ModuleMember -Function *
