Param
(
 [Parameter(Mandatory = $True)]  
 [string] $JSONObject, 
 [Parameter(Mandatory = $True)]  
 [string] $key  
)

function GetData()
{

$objKey=$key.replace('/','.');
echo $JSONObject

$dataObject= ConvertFrom-Json $JSONObject

$d="$"+"dataObject."+$objKey

Invoke-Expression $d
}

GetData 