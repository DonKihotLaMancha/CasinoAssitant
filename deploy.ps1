# BetSage Deployment Script
# Automates deployment process with testing

Write-Host "🚀 BetSage Deployment Script" -ForegroundColor Cyan
Write-Host "================================" -ForegroundColor Cyan
Write-Host ""

# Check if we're in the right directory
if (-not (Test-Path "index.html")) {
    Write-Host "❌ Error: Not in project root directory!" -ForegroundColor Red
    Write-Host "Please run this script from C:\Users\Asus\Desktop\CAS.Assist" -ForegroundColor Yellow
    exit 1
}

# Check Git status
Write-Host "📋 Checking Git status..." -ForegroundColor Yellow
$gitStatus = git status --porcelain
if ($gitStatus) {
    Write-Host "✅ Changes detected:" -ForegroundColor Green
    git status --short
    Write-Host ""
} else {
    Write-Host "⚠️  No changes to commit" -ForegroundColor Yellow
    $continue = Read-Host "Continue anyway? (y/n)"
    if ($continue -ne "y") {
        exit 0
    }
}

# Get commit message
Write-Host ""
$commitMessage = Read-Host "Enter commit message (or press Enter for default)"
if ([string]::IsNullOrWhiteSpace($commitMessage)) {
    $commitMessage = "Update site - $(Get-Date -Format 'yyyy-MM-dd HH:mm')"
}

# Stage all changes
Write-Host ""
Write-Host "📦 Staging changes..." -ForegroundColor Yellow
git add .

# Commit changes
Write-Host "💾 Committing changes..." -ForegroundColor Yellow
git commit -m "$commitMessage"

if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ Commit failed!" -ForegroundColor Red
    exit 1
}

# Push to GitHub
Write-Host ""
Write-Host "🚀 Pushing to GitHub..." -ForegroundColor Yellow
git push origin main

if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ Push failed!" -ForegroundColor Red
    Write-Host "Please check your internet connection and try again." -ForegroundColor Yellow
    exit 1
}

Write-Host ""
Write-Host "✅ Successfully pushed to GitHub!" -ForegroundColor Green
Write-Host ""

# Wait for Vercel deployment
Write-Host "⏳ Waiting for Vercel deployment (60 seconds)..." -ForegroundColor Yellow
Write-Host "   You can check status at: https://vercel.com/dashboard" -ForegroundColor Cyan

for ($i = 60; $i -gt 0; $i--) {
    Write-Progress -Activity "Waiting for deployment" -Status "$i seconds remaining" -PercentComplete ((60 - $i) / 60 * 100)
    Start-Sleep -Seconds 1
}

Write-Progress -Activity "Waiting for deployment" -Completed

Write-Host ""
Write-Host "✅ Deployment should be complete!" -ForegroundColor Green
Write-Host ""

# Ask for site URL
$siteUrl = Read-Host "Enter your site URL (e.g., https://your-site.vercel.app)"

if ([string]::IsNullOrWhiteSpace($siteUrl)) {
    Write-Host "⚠️  No URL provided. Skipping tests." -ForegroundColor Yellow
} else {
    # Remove trailing slash
    $siteUrl = $siteUrl.TrimEnd('/')
    
    Write-Host ""
    Write-Host "🧪 Testing deployment..." -ForegroundColor Yellow
    Write-Host ""
    
    # Test key URLs
    $testUrls = @(
        "/",
        "/test.html",
        "/diagnostic.html",
        "/games/blackjack_client.html",
        "/games/poker_odds.html",
        "/games/premium.html"
    )
    
    $passed = 0
    $failed = 0
    
    foreach ($url in $testUrls) {
        $fullUrl = "$siteUrl$url"
        try {
            $response = Invoke-WebRequest -Uri $fullUrl -Method Head -TimeoutSec 10 -ErrorAction Stop
            if ($response.StatusCode -eq 200) {
                Write-Host "  ✅ $url - OK" -ForegroundColor Green
                $passed++
            } else {
                Write-Host "  ❌ $url - Status: $($response.StatusCode)" -ForegroundColor Red
                $failed++
            }
        } catch {
            Write-Host "  ❌ $url - Error: $($_.Exception.Message)" -ForegroundColor Red
            $failed++
        }
    }
    
    Write-Host ""
    Write-Host "📊 Test Results:" -ForegroundColor Cyan
    Write-Host "   ✅ Passed: $passed" -ForegroundColor Green
    Write-Host "   ❌ Failed: $failed" -ForegroundColor Red
    Write-Host ""
    
    if ($failed -eq 0) {
        Write-Host "🎉 All tests passed!" -ForegroundColor Green
    } else {
        Write-Host "⚠️  Some tests failed. Please check the URLs manually." -ForegroundColor Yellow
    }
}

Write-Host ""
Write-Host "📋 Next Steps:" -ForegroundColor Cyan
Write-Host "   1. Visit: $siteUrl/diagnostic.html" -ForegroundColor White
Write-Host "   2. Click 'Test All Pages'" -ForegroundColor White
Write-Host "   3. Clear cache if needed" -ForegroundColor White
Write-Host "   4. Test from another device" -ForegroundColor White
Write-Host ""

# Ask to open browser
$openBrowser = Read-Host "Open diagnostic page in browser? (y/n)"
if ($openBrowser -eq "y" -and -not [string]::IsNullOrWhiteSpace($siteUrl)) {
    Start-Process "$siteUrl/diagnostic.html"
}

Write-Host ""
Write-Host "✅ Deployment complete!" -ForegroundColor Green
Write-Host "================================" -ForegroundColor Cyan
