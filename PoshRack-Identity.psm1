<############################################################################################

PoshRack
    Identity


Description
-----------
PowerShell v3 module for interaction with Rackspace Cloud API

Identity v2.0 API reference
---------------------------
http://docs.rackspace.com/auth/api/v2.0/auth-client-devguide/content/Overview-d1e65.html

############################################################################################>


function Get-RSIdentityProvider {
    Param(
        [Parameter (Mandatory=$True)] [string] $Account = $(throw "Please specify required Cloud Account with -Account parameter")
        )

    # The Account comes from the file CloudAccounts.csv

    Get-RSAccount -Account $Account

    # Get Identity Provider
    $RSId    = New-Object net.openstack.Core.Domain.CloudIdentity
    $RSId.Username = $Credentials.CloudUsername
    $RSId.APIKey   = $Credentials.CloudAPIKey
    $Global:RSId = New-Object net.openstack.Providers.Rackspace.CloudIdentityProvider($RSId)
    Return $Global:RSId
}

function Get-RSIdentityRole {
    param (
        [Parameter(Mandatory=$True)][string] $Account = $(throw "Please specify required Cloud Account with -Account parameter")
    )

    $RSIdentityProvider = Get-RSIdentityProvider $Account
    $RSIdentityProvider.ListRoles($null, $null, $null, $null)

<#
 .SYNOPSIS
 Get a list of roles defined for the account.

 .DESCRIPTION
 The Get-RSIdentityRoles cmdlet will display a list of roles on the cloud account together with extra details on each. 
 The list includes information about each role. This will include role id, name, wieght, propagation and description.

 .PARAMETER Account
 Use this parameter to indicate which account you would like to execute this request against. 
 Valid choices are defined in PoshNova configuration file.

 .EXAMPLE
 PS C:\> Get-RSIdentityRoles prod
 This example shows how to get a list of all networks currently deployed for prod account.

 .LINK
 http://docs.rackspace.com/auth/api/v2.0/auth-client-devguide/content/GET_listRoles_v2.0_OS-KSADM_roles_Role_Calls.html
#>
}

function Get-RSIdentityTenant {
    param (
        [Parameter(Mandatory=$True)][string] $Account = $(throw "Please specify required Cloud Account with -Account parameter")
    )

    $RSIdentityProvider = Get-RSIdentityProvider $Account
    $RSIdentityProvider.ListTenants($null)

<#
 .SYNOPSIS
 Get a list of tenants in an RS deployment.

 .DESCRIPTION
 The Get-RSIdentityTenants cmdlet will display a list of tenants on an RS deployment. This is not really used on Rackspace Public cloud.

 .PARAMETER Account
 Use this parameter to indicate which account you would like to execute this request against. 
 Valid choices are defined in PoshNova configuration file.

 .EXAMPLE
 PS C:\> Get-RSIdentityRoles prod
 
 .LINK
 http://docs.rackspace.com/auth/api/v2.0/auth-client-devguide/content/GET_listTenants_v2.0_tenants_Tenant_Calls.html
#>
}

function Get-RSIdentityUser {
    param (
        [Parameter(Position=0,Mandatory=$False)][string] $UserID,
        [Parameter(Position=0,Mandatory=$False)][string] $UserName,
        [Parameter(Position=0,Mandatory=$False)][string] $UserEmail,
        [Parameter(Position=1,Mandatory=$True)][string] $Account = $(throw "Please specify required Cloud Account with -Account parameter")
    )

    $RSIdentityProvider = Get-RSIdentityProvider $Account

    if (-Not [string]::IsNullOrEmpty($UserID)) {
        return $RSIdentityProvider.GetUser($UserID, $null)
    }

    if (-Not [string]::IsNullOrEmpty($UserEmail)) {
        return $RSIdentityProvider.GetUsersByEmail($UserEmail, $null)
    }

    if (-Not [string]::IsNullOrEmpty($UserName)) {
        return $RSIdentityProvider.GetUserByName($UserName, $null)
    }

    $RSIdentityProvider.ListUsers($null)

<#
 .SYNOPSIS
 Get details of a single user, identified by ID, name or email.

 .DESCRIPTION
 The Get-RSIdentityUser cmdlet will retrieve user details for a user, which can be identified by his/her ID, username or email address. 

 The details returned includes user ID, status, creation and update dates/times, default region and email address.

 .PARAMETER Account
 Use this mandatory parameter to indicate which account you would like to execute this request against. 
 Valid choices are defined in PoshNova configuration file.

 .PARAMETER $UserID
 Use this optional parameter to identify user by his/her user ID you would like to specify. 

 .PARAMETER $UserName
 Use this optional parameter to identify user by his/her user name you would like to specify. 

 .PARAMETER $UserEmail
 Use this optional parameter to identify user by his/her email you would like to specify. 

 .EXAMPLE
 PS C:\> Get-RSIdentityUser -UserName demouser -Account prod
 This example shows how to get details user demouser in prod account.

 .EXAMPLE
 PS C:\> Get-RSIdentityUser -UserID 12345678 -Account prod
 This example shows how to get details user ID 12345678 in prod account.

 .EXAMPLE
 PS C:\> Get-RSIdentityUser -UserEmail demouser@democorp.com -Account prod
 This example shows how to get details user with email 'demouser@democorp.com' in prod account.

 .LINK
 http://docs.rackspace.com/auth/api/v2.0/auth-client-devguide/content/User_Calls.html
#>
}

function Get-RSIdentityUserRole {
    param (
        [Parameter(Position=0,Mandatory=$True)][string] $UserID = $(throw "Specify the user ID with -UserID"),
        [Parameter(Position=1,Mandatory=$True)][string] $Account = $(throw "Please specify required Cloud Account with -Account parameter")
    )


    $RSIdentityProvider = Get-RSIdentityProvider $Account
    $RSIdentityProvider.GetRolesByUser($UserID, $null)

<#
 .SYNOPSIS
 Get a list roles which a specific user is asigned.

 .DESCRIPTION
 The Get-RSIdentityUserRoles cmdlet will display a list of roles which a user is assigned.
 The list includes role id, name, , propagation and description.

 .PARAMETER Account
 Use this mandatory parameter to indicate which account you would like to execute this request against. 
 Valid choices are defined in PoshNova configuration file.

 .PARAMETER $UserID
 Use this mandatory parameter to specify a user by his/her user ID. 

 .EXAMPLE
 PS C:\> Get-RSIdentityUserRoles -UserID 12345678 -Account prod
 This example shows how to get a list of assigned roles for a specific user, identified by his/her user ID.

 .LINK
 http://docs.rackspace.com/auth/api/v2.0/auth-client-devguide/content/GET_listRoles_v2.0_OS-KSADM_roles_Role_Calls.html
#>
}

function New-RSIdentityUser {
    param (
        [Parameter(Mandatory=$True)] [string] $Account = $(throw "Please specify required Cloud Account with -Account parameter"),
        [Parameter(Mandatory=$True)] [string] $UserName = $(throw "Specify the user name with -UserName"),
        [Parameter(Mandatory=$True)] [string] $UserEmail = $(throw "Specify the user's email with -UserEmail"),
        [Parameter(Mandatory=$False)][string] $UserPass = $null,
        [Parameter(Mandatory=$False)][bool]   $Enabled = $True
    )

    $RSIdentityProvider = Get-RSIdentityProvider $Account

    $user = New-Object -TypeName net.openstack.Core.Domain.NewUser -ArgumentList @($UserName,$UserEmail,$UserPass,$True)

    return $RSIdentityProvider.AddUser($user, $null)

<#
 .SYNOPSIS
 Create a new cloud user.

 .DESCRIPTION
 The New-RSIdentityUser cmdlet will create a new user.
 The list includes role id, name, , propagation and description.

 .PARAMETER $UserName
 Use this mandatory parameter to specify a username for the new account. 

 .PARAMETER $UserEmail
 Use this mandatory parameter to specify an email address for the new account. 

 .PARAMETER $UserPass
 Use this parameter to specify a password for the new account. 
 If you do not specify this parameter, a secure password will be set for the user and will be included as part of the cmdlet output.

 .PARAMETER $Disabled
 Use this switch parameter to disable the account as soon as it is created.

 .PARAMETER Account
 Use this mandatory parameter to indicate which account you would like to execute this request against. 
 Valid choices are defined in PoshNova configuration file.

 .EXAMPLE
 PS C:\> Get-RSIdentityUserRoles -UserID 12345678 -Account prod
 This example shows how to get a list of assigned roles for a specific user, identified by his/her user ID.

 .LINK
 http://docs.rackspace.com/auth/api/v2.0/auth-client-devguide/content/User_Calls.html
#>
}

function Remove-RSIdentityUser {
    param (
        [Parameter(Mandatory=$True)][string] $Account = $(throw "Please specify required Cloud Account with -Account parameter"),
        [Parameter(Mandatory=$True)][string] $UserID = $(throw "Specify the user ID with -UserID")
    )

    $RSIdentityProvider = Get-RSIdentityProvider $Account
    $RSIdentityProvider.DeleteUser($UserID, $null)
    
}

function Edit-RSIdentityUser {
    param (
        [Parameter(Mandatory=$True)][string]  $Account = $(throw "Please specify required Cloud Account with -Account parameter"),
        [Parameter(Mandatory=$True)][string]  $UserID = $(throw "Specify the user name with -UserID"),
        [Parameter(Mandatory=$False)][string] $UserName,
        [Parameter(Mandatory=$False)][string] $UserEmail,
        [Parameter(Mandatory=$False)][bool]   $Enabled = $True,
        [Parameter(Mandatory=$False)][string] $DefaultRegion
    )

    $RSIdentityProvider = Get-RSIdentityProvider $Account
    $User = Get-RSIdentityUser -Account $Account -UserID $UserID

    if (-Not [string]::IsNullOrEmpty($DefaultRegion)) {
        $User.DefaultRegion = $DefaultRegion
    }

    if (-Not [string]::IsNullOrEmpty($UserEmail)) {
        $User.Email = $UserEmail
    }

    if (-Not [string]::IsNullOrEmpty($UserName)) {
        $UserName = $UserName
    }

    $User.Enabled = $Enabled

    $RSIdentityProvider.UpdateUser($User, $null)


<#
 .SYNOPSIS
 Edit an existing cloud user.

 .DESCRIPTION
 The Edit-RSIdentityUser cmdlet will edit any attributes for an existing user, as supplied via the parameters.
 All optional parameters can be specified as part of the same command.

 .PARAMETER $UserID
 Use this mandatory parameter to identify the user you would like to edit.

 .PARAMETER $UserName
 Use this parameter to edit the username.

 .PARAMETER $UserEmail
 Use this parameter to edit an email address for the account. 

 .PARAMETER $UserPass
 Use this parameter to edit a password for and account. 

 .PARAMETER $Disabled
 Use this switch parameter to disable or enable a user account.

 .PARAMETER Account
 Use this mandatory parameter to indicate which account you would like to execute this request against. 
 Valid choices are defined in PoshNova configuration file.

 .EXAMPLE
 PS C:\> Edit-RSIdentityUser -UserID 12345678 -Account prod -UserName "new-user-name" -Disabled false
 This example shows how to change the username for a specific user at the same time as enabling it.

 .LINK
 http://docs.rackspace.com/auth/api/v2.0/auth-client-devguide/content/User_Calls.html
#>
}

function Add-RSIdentityRoleForUser {
    param (
        [Parameter(Position=0,Mandatory=$True)][string] $UserID = $(throw "Specify the user ID with -UserID"),
        [Parameter(Position=1,Mandatory=$True)][string] $RoleID = $(throw "Specify the role ID with -RoleID"),
        [Parameter(Position=2,Mandatory=$True)][string] $Account = $(throw "Please specify required Cloud Account with -Account")
    )

    $RSIdentityProvider = Get-RSIdentityProvider $Account
    $RSIdentityProvider.AddRoleToUser($UserID, $RoleID, $null)

<#
 .SYNOPSIS
 Add role membership for a cloud user.

 .DESCRIPTION
 The Add-RSIdentityRoleForUser cmdlet will add role membership for an existing cloud user.

 .PARAMETER $UserID
 Use this mandatory parameter to identify the user you would like to edit by his/her unique ID.

 .PARAMETER $RoleID
 Use this mandatory parameter used to specify the role ID. Use Get-RSIdentityRoles to see a list of all available roles.

 .PARAMETER $Account
 Use this mandatory parameter to indicate which account you would like to execute this request against. 
 Valid choices are defined in PoshNova configuration file.

 .EXAMPLE
 PS C:\> Add-RSIdentityRoleForUser -UserID 12345678 -RoleID 12345678 -Account prod
 This example shows how to modify role assignment for a specific user.

 .LINK
 http://docs.rackspace.com/auth/api/v2.0/auth-client-devguide/content/User_Calls.html
#>
}

function Remove-RSIdentityRoleFromUser {
    param (
        [Parameter(Position=0,Mandatory=$True)][string] $UserID = $(throw "Specify the user ID with -UserID"),
        [Parameter(Position=1,Mandatory=$True)][string] $RoleID = $(throw "Specify the role ID with -RoleID"),
        [Parameter(Position=2,Mandatory=$True)][string] $Account = $(throw "Please specify required Cloud Account with -Account")
    )

    $RSIdentityProvider = Get-RSIdentityProvider $Account
    $RSIdentityProvider.DeleteRoleFromUser($UserID, $RoleID, $null)

<#
 .SYNOPSIS
 Remove role membership from a cloud user.

 .DESCRIPTION
 The Remove-RSIdentityRoleForUser cmdlet will remove role membership for an existing cloud user.

 .PARAMETER $UserID
 Use this mandatory parameter to identify the user you would like to edit by his/her unique ID.

 .PARAMETER $RoleID
 Use this mandatory parameter used to specify the role ID. Use Get-RSIdentityUserRoles to see a list of all currently-assigned roles for this user.

 .PARAMETER $Account
 Use this mandatory parameter to indicate which account you would like to execute this request against. 
 Valid choices are defined in PoshNova configuration file.

 .EXAMPLE
 PS C:\> Remove-RSIdentityRoleForUser -UserID 12345678 -RoleID 12345678 -Account prod
 This example shows how to modify role assignment for a specific user.

 .LINK
 http://docs.rackspace.com/auth/api/v2.0/auth-client-devguide/content/User_Calls.html
#>
}

Export-ModuleMember -Function *