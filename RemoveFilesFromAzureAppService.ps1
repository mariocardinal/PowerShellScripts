$WebAppName = "insert Web App name"
$slotName = "insert Slot Name"
$username = 'insert the username from the publish profile' #From the publish profile
$password = "insert the password from the publish profile" #From the publish profile

# Initialize parameters for Invoke-RestMethod
$apiUrl = "https://$WebAppName.scm.azurewebsites.net/api/vfs/site/wwwroot/"
if ($slotName -ne ""){
	$apiUrl = "https://$webAppName`-$slotName.scm.azurewebsites.net/api/vfs/site/wwwroot/"
}
$base64AuthInfo = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(("$($username):$($password)")))
$headers = @{ 
	Authorization="Basic $($base64AuthInfo)"
	'If-Match'      = '*'
}
$userAgent = "powershell/2.0"

# Define a reursive function to delete files
function DeleteKuduDir ($content, $dir)
{
	foreach($c in $content)
	{		
		if($c.mime -eq "inode/directory")
		{
			# Get listing of directory as an array
			$childContent = Invoke-RestMethod -Uri $c.href -Headers $headers -UserAgent $userAgent -Method GET -ContentType "application/json"
			
			# Delete directory
			$newDir = $dir + (Split-Path $c.href -leaf) + "\"
			DeleteKuduDir -content $childContent -dir $newDir
		}
		# Delete file
		$file = Split-Path $c.href -leaf
		Write-Host "Deleting" $dir$file		
		$result = Invoke-RestMethod -Uri $c.href -Headers $headers -UserAgent $userAgent -Method DELETE -ContentType "application/json"
	}
}

# Get listing of wwwroot as an array
$rootContent = Invoke-RestMethod -Uri $apiUrl -Headers $headers -UserAgent $userAgent -Method GET -ContentType "application/json"

# Delete files and directory in wwwroot
DeleteKuduDir -content $rootContent -dir "\"
Write-Host "Done!"
