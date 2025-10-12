# Apply consistent modern background to all game HTML files

$newBodyStyle = @'
        body {
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', 'Roboto', sans-serif;
            background: linear-gradient(135deg, #1A1A2E 0%, #16213E 100%);
            min-height: 100vh;
            color: white;
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
'@

$files = Get-ChildItem -Path "games\*.html" -File
$updated = 0
$skipped = 0

foreach ($file in $files) {
    try {
        $content = Get-Content $file.FullName -Raw -Encoding UTF8
        
        # Pattern to match body style block
        $bodyPattern = '(?s)(        body\s*\{)[^}]+(        \})'
        
        if ($content -match $bodyPattern) {
            # Replace the body style
            $content = $content -replace $bodyPattern, $newBodyStyle
            
            # Remove old patternMove keyframes if they exist
            $content = $content -replace '(?s)@keyframes patternMove\s*\{[^}]+\}', ''
            
            # Save the file
            Set-Content -Path $file.FullName -Value $content -Encoding UTF8 -NoNewline
            Write-Host "✓ Updated: $($file.Name)" -ForegroundColor Green
            $updated++
        } else {
            Write-Host "⊘ Skipped: $($file.Name) (no body style found)" -ForegroundColor Yellow
            $skipped++
        }
    } catch {
        Write-Host "✗ Error: $($file.Name) - $($_.Exception.Message)" -ForegroundColor Red
    }
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Updated: $updated files" -ForegroundColor Green
Write-Host "Skipped: $skipped files" -ForegroundColor Yellow
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "All game backgrounds are now consistent!" -ForegroundColor Cyan
