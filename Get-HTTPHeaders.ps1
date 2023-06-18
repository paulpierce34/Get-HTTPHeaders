## The purpose of this script is to grab all the HTTP response headers from a single URL or list of URLs and export to csv
## Output file will be saved to user's Documents folder. Adjust $OutputPath if you want to change this

$URL = "" ## Provide the http(s) URL. ex: https://google.com
#$URLFilePath = "" ## The full path to the .txt file of URLs. ex: C:\Users\admin\Documents\allurls.txt








## Format a date object for filename append
$TodayDate = Get-Date -Format yyyy-MM-dd-mm

## Set Output path file to documents folder
$DocumentPath = [Environment]::GetFolderPath("MyDocuments")
$OutputPath = $DocumentPath + "\" + "URLHeaders-" + $Todaydate + ".csv"

 
## Define empty object for a customPSObject to be exported
$AllURLObject = @() 


if (-not ([string]::IsNullOrEmpty($URLFilePath)) -and ( -not [string]::IsNullOrEmpty($URL))) {
write-host -ForegroundColor Yellow "Both a URL and a text file of URLs have been specified. Please choose one or the other and re-run script."
Remove-Variable URL, AllURLs, URLFilePath -ErrorAction SilentlyContinue
break

}



## This is the logic for one URL provided
if ($URL -like "*http*" -and ([string]::IsNullOrEmpty($AllURLs))){

write-host "Working on $URL..."

$response = Invoke-WebRequest $URL -UseBasicParsing -Method Head

$AllURLObject += New-Object PSObject -Property @{

URL = $URL;
Status_Code = $response.StatusCode;
Connection = $response.Headers["Connection"];
Strict_Transport_Security = $response.Headers["Strict-Transport-Security"];
Pragma = $response.Headers["Pragma"];
Server_Timing = $response.Headers["Server-Timing"];
Accept_Ranges = $response.Headers["Accept-Ranges"];
Content_Length = $response.Headers["Content-Length"];
Cache_Control = $response.Headers["Cache-Control"];
Content_Type = $response.Headers["Content-Type"];
Date = $response.Headers["Date"];
Expires = $response.Headers["Expires"];
ETag = $response.Headers["ETag"];
Last_Modified = $response.Headers["Last-Modified"];
Server = $response.Headers["Server"];
WWW_Authenticate = $response.Headers["WWW-Authenticate"];
X_Content_Type_Options = $response.Headers["X-Content-Type-Options"];
Vary = $response.Headers["vary"];
X_Real_IP = $response.Headers["X-Real-IP"];
Forwarded = $response.Headers["Forwarded"];
X_Forwarded_Server = $response.Headers["X-Forwarded-Server"];
Max_Forwards = $response.Headers["Max-Forwards"];

}

$AllURLObject | Export-CSV -Path $OutputPath -NoTypeInformation

}

elseif (-not ([string]::IsNullOrEmpty($URL)) -and $URL -notlike "*http*") {

write-host -ForegroundColor Yellow "URL does not seem to be valid. Please specify http(s) and re-run script"

}
elseif (([string]::IsNullOrEmpty($URLFilePath)) -and ([string]::IsNullOrEmpty($URL))){

write-host -ForegroundColor Yellow "No URLs provided. Please specify an http(s) URL or a text file of URLs"

}






## Iterate through all of the provided URLs in text file
if (-not ([string]::IsNullOrEmpty($URLFilePath)) -and ([string]::IsNullOrEmpty($URL))){

$AllURLs = Get-Content -Path $URLFilePath

Foreach ($SingleURL in $AllURLs){

if ($SingleURL -like "*http*"){

write-host "Working on $SingleURL..."

$response = Invoke-WebRequest $SingleURL -UseBasicParsing -Method Head


$AllURLObject += New-Object PSObject -Property @{

URL = $SingleURL;
Status_Code = $response.StatusCode;
Connection = $response.Headers["Connection"];
Strict_Transport_Security = $response.Headers["Strict-Transport-Security"];
Pragma = $response.Headers["Pragma"];
Server_Timing = $response.Headers["Server-Timing"];
Accept_Ranges = $response.Headers["Accept-Ranges"];
Content_Length = $response.Headers["Content-Length"];
Cache_Control = $response.Headers["Cache-Control"];
Content_Type = $response.Headers["Content-Type"];
Date = $response.Headers["Date"];
Expires = $response.Headers["Expires"];
ETag = $response.Headers["ETag"];
Last_Modified = $response.Headers["Last-Modified"];
Server = $response.Headers["Server"];
WWW_Authenticate = $response.Headers["WWW-Authenticate"];
X_Content_Type_Options = $response.Headers["X-Content-Type-Options"];
Vary = $response.Headers["vary"];

}

$AllURLObject | Export-CSV -Path $OutputPath -NoTypeInformation

}
else {
write-host -Foregroundcolor Red "$SingleURL is not a valid URL, skipping..."
}

}

} ## end of allurls

Remove-Variable URL, AllURLs, URLFilePath -ErrorAction SilentlyContinue


if (Test-Path $OutputPath){

write-host -Foregroundcolor Cyan "Successfully created output file here: $OutputPath"

}
else {

write-host -Foregroundcolor Red "Unable to create output file here: $OutputPath"

}
