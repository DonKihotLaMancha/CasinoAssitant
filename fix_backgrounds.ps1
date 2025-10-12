$files = Get-ChildItem -Path "games\*.html" -File
$updated = 0

foreach ($file in $files) {
    $content = Get-Content $file.FullName -Raw
    
    # Simple replacement of body background
    $content = $content -replace 'background:\s*var\([^)]+\);', 'background: linear-gradient(135deg, #1A1A2E 0%, #16213E 100%);'
    $content = $content -replace 'background:\s*linear-gradient\([^;]+;', 'background: linear-gradient(135deg, #1A1A2E 0%, #16213E 100%);'
    
    # Add position relative if not present
    if ($content -match 'body\s*\{' -and $content -notmatch 'position:\s*relative') {
        $content = $content -replace '(padding:\s*\d+px;)', '$1`n            position: relative;'
    }
    
    # Add animated background if not present
    if ($content -notmatch 'body::before') {
        $bgPattern = @'

        
        /* Animated background pattern */
        body::before {
            content: '';
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background-image: 
                repeating-linear-gradient(45deg, transparent, transparent 35px, rgba(255,107,53,0.03) 35px, rgba(255,107,53,0.03) 70px),
                repeating-linear-gradient(-45deg, transparent, transparent 35px, rgba(0,78,137,0.03) 35px, rgba(0,78,137,0.03) 70px);
            z-index: -1;
            animation: patternMove 20s linear infinite;
        }
        
        @keyframes patternMove {
            0% { background-position: 0 0, 0 0; }
            100% { background-position: 70px 70px, -70px 70px; }
        }
'@
        $content = $content -replace '(        \.container\s*\{)', "$bgPattern`n`n`$1"
    }
    
    Set-Content -Path $file.FullName -Value $content
    Write-Host "Updated: $($file.Name)"
    $updated++
}

Write-Host ""
Write-Host "Total updated: $updated files"
