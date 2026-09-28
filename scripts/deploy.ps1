param(
    [Parameter(Mandatory=$true)]
    [string]$Environment,
    
    [Parameter(Mandatory=$true)]
    [string]$ResourceGroupName
)

$ErrorActionPreference = "Stop"

Write-Host "Starting deployment for environment: $Environment" -ForegroundColor Cyan

# Check Azure Login
$azContext = az account show --query name -o tsv
if (-not $azContext) {
    Write-Error "Not logged into Azure. Please run 'az login' first."
    exit 1
}

Write-Host "Using Azure Subscription: $azContext" -ForegroundColor Green

# Terraform Init & Apply
Push-Location ../terraform
Write-Host "Initializing Terraform..." -ForegroundColor Cyan
terraform init

Write-Host "Applying Terraform configuration..." -ForegroundColor Cyan
terraform apply -var="environment=$Environment" -auto-approve
Pop-Location

Write-Host "Infrastructure deployment completed." -ForegroundColor Green
Write-Host "Please proceed to deploy the application containers via GitHub Actions." -ForegroundColor Yellow
