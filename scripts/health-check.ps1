param(
    [Parameter(Mandatory=$true)]
    [string]$ApiUrl,

    [Parameter(Mandatory=$true)]
    [string]$FrontendUrl
)

$ErrorActionPreference = "Stop"

Write-Host "Running post-deployment health checks..." -ForegroundColor Cyan

# Check Backend API Health
Write-Host "Checking API at $ApiUrl..."
try {
    # Assuming FastAPI has a /health or root endpoint
    $apiResponse = Invoke-RestMethod -Uri "$ApiUrl/" -Method Get -TimeoutSec 10
    Write-Host "API Health Check Passed." -ForegroundColor Green
} catch {
    Write-Error "API Health Check Failed: $_"
    exit 1
}

# Check Frontend Health
Write-Host "Checking Frontend at $FrontendUrl..."
try {
    $frontendResponse = Invoke-WebRequest -Uri $FrontendUrl -Method Get -UseBasicParsing -TimeoutSec 10
    if ($frontendResponse.StatusCode -eq 200) {
        Write-Host "Frontend Health Check Passed." -ForegroundColor Green
    } else {
        throw "Status code: $($frontendResponse.StatusCode)"
    }
} catch {
    Write-Error "Frontend Health Check Failed: $_"
    exit 1
}

Write-Host "All health checks passed successfully!" -ForegroundColor Green
