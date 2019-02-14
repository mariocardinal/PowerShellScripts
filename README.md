# PowerShellScripts
You will find here some of my PowerShell scripts for *Azure DevOps Pipelines*

## RemoveFilesFromAzureAppService.ps1
This is a PowerShell recipe to remove all the files in the wwwroot directory on the Azure Web App.

Recently, when deploying the [To-Do Studio](https://to-do.studio) website with Azure DevOps, I needed to clean the wwwroot directory before deploying. It is usually a simple configuration setting when running the release on a hosted VS2017 agent. When using the Azure App Service Deploy task with the Publish using Web Deploy option, there is an additional option to Remove Additional Files at Destination. Unfortunately, in order to roll the automated E2E tests with Cypress, we must run the release script on a Linux agent. This Remove Additional Files at Destination option is not available anymore on Linux. So I had to automate the cleanup  with an Azure Pipeline task.

At first, to fill this gap, I thought about using the “Azure WebApp Virtual File System Tasks” available in the Azure DevOps marketplace. Unfortunately, this task did not work. So I had to automate the cleanup with a Powershell script.

The non-automated (manual) way to delete files / folders in Azure Web App is to use the Kudu console. For those who like me want to automate this operation with PowerShell, there is KUDU Virtual File System (VFS) Rest API.  The PowerShell script use this REST API.
