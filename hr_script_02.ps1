# Define your Google Drive account and folder name
$GoogleDriveAccount = "your-email@email.com"
$FolderName = "Your Folder Name"

# Specify the path for the output index file
$IndexFilePath = "C:\path\to\output\index.json"

# Install the Google API client library
Install-Package -Name Google.Apis.Drive.v3

# Authenticate with Google Drive using OAuth2
# Replace 'YourClientID' and 'YourClientSecret' with your own credentials
$ClientID = "YourClientID"
$ClientSecret = "YourClientSecret"
$CredentialPath = "C:\path\to\your\credential.json"
$RedirectUri = "urn:ietf:wg:oauth:2.0:oob"

# Load the Google API library
Add-Type -TypeDefinition @"
    using System;
    using Google.Apis.Auth.OAuth2;
    using Google.Apis.Services;
    using Google.Apis.Drive.v3;
"@

# Create credentials and request access
$UserCredential = GoogleWebAuthorizationBroker::AuthorizeAsync(
    [GoogleClientSecrets]::Load([System.IO.File]::OpenRead($CredentialPath)).Secrets,
    [String[]]@("https://www.googleapis.com/auth/drive.readonly"),
    "user",
    [System.Threading.CancellationToken]::None
).Result

# Create a Drive service
$Service = [Google.Apis.Drive.v3.DriveService]::new()
$Service::new([BaseClientService.Initializer]@{
    HttpClientInitializer = $UserCredential,
    ApplicationName = "Google Drive Indexer"
})

# List files in the specified folder
$Files = $Service.Files.List().Q = "'$GoogleDriveAccount' in owners and name = '$FolderName' and mimeType != 'application/vnd.google-apps.folder'"

# Create an empty array to store the file metadata
$IndexData = @()

# Iterate through the files and add their metadata to the index
foreach ($File in $Files.Execute().Files) {
    $FileMetadata = @{
        Name = $File.Name
        ID = $File.Id
        Size = $File.Size
        MimeType = $File.MimeType
        WebContentLink = $File.WebContentLink
    }
    $IndexData += $FileMetadata
}

# Convert the index data to JSON and save it to the specified file
$IndexData | ConvertTo-Json | Set-Content -Path $IndexFilePath

Write-Host "Index file created and saved at $IndexFilePath"
