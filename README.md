#PoshRack

#Description
PoshStack is a Microsoft PowerShell v5 (or higher) client for the Rackspace-specific extensions to OpenStack, built on the Rackspace.NET SDK v1.

The goal of this project is to give command line access to the Rackspace cloud from the Windows PowerShell client, allowing Windows system administrators, DevOps engineers and developers to easily and quickly manage and automate their work.

This project targets only those parts of the Rackspace cloud that are specific to Rackspace. For generic OpenStack functions, the tool PoshStack should be used. PoshRack and PoshStack can both be used, side by side.

## Installation is so easy...

### Prerequisite
PoshRack requires Windows Management Framework 5.0 (or newer).

### Installation and Configuration
Installation requires two steps: Install and Configure. PoshRack is installed using PsGet

#### Install
Open a PowerShell prompt and run the following two lines:
```bash
(new-object Net.WebClient).DownloadString("http://psget.net/GetPsGet.ps1") | Invoke-Expression
install-module PoshRack
```
#### Configure
##### Important Note: The RSCloudAccounts.csv file location and name is specified in the user profile, using the variable "$RSAccounts". See the included file profile.ps1 for an example

Update the RSCloudAccounts.csv file with your cloud account credentials:  
  * _AccountName_ - User-defined name for the account. This can be pretty much anything you desire, and it's only used in the context of PoshRack. For example, you may choose to name the accounts based on the default regions you assign to them (e.g. RackIAD or RackDFW). This _AccountName_ is **not** the same as your _RackspaceUsername_.
  * _RackspaceUsername_ - This is your Rackspace.
  * _RackspaceAPIKey_ - This is your API key.
  * _Region_ - This is your default region.

You can see your Rackspace cloud accounts configuration by running
```bash
Show-RSAccounts
```

##### An example of the contents of RSCloudAccounts.csv

```
AccountName,RackspaceUsername,RackspacePassword,RackspaceAPIKey,Region
RackIAD,username_here,apikey_here,IAD
RackDFW,username_here,apikey_here,dfw
RackORD,username_here,apikey_here,Ord
```

## Contributing is a cinch as well...
Make your contribution to the goodness. Fork the code, pick an issue, and get coding. If you're unsure where to start or what it all means, choose an issue and leave a comment, asking for assistance.
