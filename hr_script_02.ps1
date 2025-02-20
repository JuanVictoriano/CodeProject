# Script to create an index file for importing documents from a Google Drive account

# Set the base directory where you want to store the index file
$baseDirectory = "C:\Users\YourUser\Documents\ImportIndex"
if (-not (Test-Path -Path $baseDirectory)) {
    New-Item -Path $baseDirectory -ItemType Directory
}

# Install required NuGet package for Google Drive API
Install-Package -Name Google.Apis.Drive.v3 -Source NuGet.org

# Import required Google Drive namespaces
Add-Type -Path "C:\Path\To\Google.Apis.Drive.v3.dll"
Add-Type -Path "C:\Path\To\Google.Apis.Auth.dll"

# Configure the Google Drive API
$clientId = "YOUR_CLIENT_ID"
$clientSecret = "YOUR_CLIENT_SECRET"
$redirectUri = "urn:ietf:wg:oauth:2.0:oob"

# Create Google Drive service
$googleDriveService = New-Object -TypeName Google.Apis.Drive.v3.DriveService

# Set up credentials
$credential = Google.Apis.Auth.OAuth2.GoogleWebAuthorizationBroker::AuthorizeAsync(
    (New-Object Google.Apis.Auth.OAuth2.ClientSecrets -Property @{
        ClientId = $clientId
        ClientSecret = $clientSecret
    }),
    ([System.String[]]@("https://www.googleapis.com/auth/drive.readonly")),
    "user",
    [System.Threading.CancellationToken]::None
).Result

$googleDriveService.HttpClient.DefaultRequestHeaders.Authorization = New-Object System.Net.Http.Headers.AuthenticationHeaderValue(
    "Bearer",
    $credential.Token.AccessToken
)

# Retrieve files from the Google Drive account
$files = $googleDriveService.Files.List().Execute().Files

# Create the index file
$indexFilePath = Join-Path -Path $baseDirectory -ChildPath "import_index.txt"
$indexContent = "List of documents in your-email@email.com Google Drive account:`n`n"

foreach ($file in $files) {
    $indexContent += "File Name: $($file.Name)`t File ID: $($file.Id)`n"
}

$indexContent | Out-File -FilePath $indexFilePath -Encoding utf8

Write-Host "Index file created successfully at $indexFilePath"
