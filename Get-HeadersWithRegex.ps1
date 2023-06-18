# you can use this function to grab ALL the headers

function Get-HttpHeader {
    param(
        [Parameter(Mandatory=$true)]
        [string]$Url
    )
    $rawContent = (iwr $Url -ErrorAction SilentlyContinue).RawContent
    if ($null -eq $rawContent) {
        Write-Output "Unable to fetch data from $Url"
        return $null
    }
    $lines = $rawContent -split "`n"
    $object = @{}
    $isFirstLine = $true
    foreach ($line in $lines) {
        if ($line -eq "") {
            break
        }
        if ($line -like "<!*") {
            break
        }
        if ($isFirstLine) {
            $object["RESPONSE"] = $line.Trim()
            $isFirstLine = $false
            continue
        }        
        if ($line -match ":") {
            $parts = $line -split ":", 2
            $object[$parts[0].Trim()] = $parts[1].Trim()
        }
    }

    return $object
}
