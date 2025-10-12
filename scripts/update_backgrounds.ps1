# Update all game pages with consistent modern background

$backgroundCSS = @"
        body {
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', 'Roboto', sans-serif;
            background: linear-gradient(135deg, #1A1A2E 0%, #16213E 100%);
            min-height: 100vh;
            color: white;
            margin: 0;
            padding: 20px;
            position: relative;
        }
        
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
"@

$files = Get-ChildItem -Path "games\*.html" -File

foreach ($file in $files) {
    $content = Get-Content $file.FullName -Raw
    
    # Check if file has body style
    if ($content -match '(?s)body\s*\{[^}]+\}') {
        # Replace body style and add animation
        $content = $content -replace '(?s)(body\s*\{)[^}]+(\})', $backgroundCSS
        
        # Add animation keyframes if not present
        if ($content -notmatch '@keyframes patternMove') {
            # Find the last closing brace of style section
            $content = $content -replace '(</style>)', "`n$backgroundCSS`n`$1"
        }
        
        Set-Content -Path $file.FullName -Value $content
        Write-Host "Updated: $($file.Name)" -ForegroundColor Green
    }
}

Write-Host "`nAll game backgrounds updated!" -ForegroundColor Cyan
