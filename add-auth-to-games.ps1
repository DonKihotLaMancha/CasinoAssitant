# PowerShell script to add authentication check to all game HTML files

$gamesFolder = "c:\Users\Asus\Desktop\CAS.Assist\games"
$authScript = '<script src="../auth/auth-check.js"></script>'

# Get all HTML files in games folder
$htmlFiles = Get-ChildItem -Path $gamesFolder -Filter "*.html"

foreach ($file in $htmlFiles) {
    $content = Get-Content $file.FullName -Raw
    
    # Check if auth script is already added
    if ($content -notmatch 'auth-check.js') {
        # Add auth script right after <body> tag
        $content = $content -replace '(<body[^>]*>)', "`$1`n    $authScript"
        
        # Write back to file
        Set-Content -Path $file.FullName -Value $content -NoNewline
        
        Write-Host "Added auth to: $($file.Name)" -ForegroundColor Green
    } else {
        Write-Host "Auth already exists in: $($file.Name)" -ForegroundColor Yellow
    }
}

Write-Host "`nDone! Authentication added to all game pages." -ForegroundColor Cyan
