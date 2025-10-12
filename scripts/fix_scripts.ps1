# Fix all game HTML files - add defer to scripts and ensure back buttons work

$files = Get-ChildItem -Path "games\*.html" -File

foreach ($file in $files) {
    $content = Get-Content $file.FullName -Raw
    
    # Add defer to sounds.js
    $content = $content -replace '<script src="../docs/sounds.js"></script>', '<script src="../docs/sounds.js" defer></script>'
    
    # Add defer to theme-manager.js
    $content = $content -replace '<script src="../docs/theme-manager.js"></script>', '<script src="../docs/theme-manager.js" defer></script>'
    
    # Add defer to i18n.js
    $content = $content -replace '<script src="../docs/i18n.js"></script>', '<script src="../docs/i18n.js" defer></script>'
    
    # Add defer to academy-features.js
    $content = $content -replace '<script src="academy-features.js"></script>', '<script src="academy-features.js" defer></script>'
    
    # Save the file
    Set-Content -Path $file.FullName -Value $content
    
    Write-Host "Fixed: $($file.Name)"
}

Write-Host "`nAll files fixed!"
