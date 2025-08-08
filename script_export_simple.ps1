# Simplified Production Data Export Script
# Avoids compression issues by using simpler HTTP handling

param(
    [string]$ProdApiUrl = "https://trac.cognoquest.org/api",
    [string]$ProdUser = "trac@cognoquest.com",
    [string]$ProdPass = "Moncoco.2",
    [string]$DeviceUniqueId = "S24B000002"
)

Write-Host "=== Simplified Production Data Export ===" -ForegroundColor Green

# Create authentication header
$base64AuthInfo = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes("$($ProdUser):$($ProdPass)"))
$headers = @{ 
    Authorization = "Basic $base64AuthInfo"
    "Accept" = "application/json"
    "User-Agent" = "PowerShell"
}

# Step 1: Get Device ID
Write-Host "Step 1: Fetching device ID for '$DeviceUniqueId'..." -ForegroundColor Cyan

try {
    $devicesResponse = Invoke-RestMethod -Uri "$ProdApiUrl/devices" -Method Get -Headers $headers -TimeoutSec 30
    $device = $devicesResponse | Where-Object { $_.uniqueId -eq $DeviceUniqueId }

    if ($device) {
        $deviceId = $device.id
        Write-Host "  SUCCESS: Found device ID: $deviceId" -ForegroundColor Green
    } else {
        Write-Host "  ERROR: Device with uniqueId '$DeviceUniqueId' not found" -ForegroundColor Red
        Write-Host "  Available devices:" -ForegroundColor Gray
        $devicesResponse | ForEach-Object { Write-Host "    - $($_.uniqueId) (ID: $($_.id))" -ForegroundColor Gray }
        exit 1
    }
} catch {
    Write-Host "  ERROR: Failed to connect to production server" -ForegroundColor Red
    Write-Host "  Details: $($_.Exception.Message)" -ForegroundColor Red
    exit 1
}

# Step 2: Export Position Data
Write-Host "Step 2: Exporting position data..." -ForegroundColor Cyan

$from = "2025-01-01T00:00:00Z"
$to = "2025-12-31T23:59:59Z"
$positionsUrl = "$ProdApiUrl/reports/route?deviceId=$deviceId&from=$from&to=$to"

try {
    Write-Host "  Fetching from: $positionsUrl" -ForegroundColor Gray
    $positions = Invoke-RestMethod -Uri $positionsUrl -Method Get -Headers $headers -TimeoutSec 60
    
    if ($positions -and $positions.Count -gt 0) {
        $outputFile = ".\production_positions_simple.json"
        Write-Host "  SUCCESS: Found $($positions.Count) position records" -ForegroundColor Green
        
        # Convert to JSON and save
        $jsonContent = $positions | ConvertTo-Json -Depth 10
        $jsonContent | Out-File -FilePath $outputFile -Encoding UTF8
        
        Write-Host "  Data saved to: $outputFile" -ForegroundColor Green
        
        # Quick validation
        $testContent = Get-Content $outputFile -Raw
        if ($testContent.Trim().StartsWith('[') -and $testContent.Trim().EndsWith(']')) {
            Write-Host "  VERIFIED: Valid JSON array format" -ForegroundColor Green
            
            # Show sample data
            $sampleData = $positions | Select-Object -First 1
            Write-Host "  Sample position data:" -ForegroundColor Gray
            Write-Host "    Device ID: $($sampleData.deviceId)" -ForegroundColor Gray
            Write-Host "    Latitude: $($sampleData.latitude)" -ForegroundColor Gray
            Write-Host "    Longitude: $($sampleData.longitude)" -ForegroundColor Gray
            Write-Host "    Fix Time: $($sampleData.fixTime)" -ForegroundColor Gray
        } else {
            Write-Host "  WARNING: File format may be incorrect" -ForegroundColor Yellow
        }
    } else {
        Write-Host "  INFO: No position data found" -ForegroundColor Yellow
    }
} catch {
    Write-Host "  ERROR: Failed to fetch position data" -ForegroundColor Red
    Write-Host "  Details: $($_.Exception.Message)" -ForegroundColor Red
}

# Step 3: Export Event Data
Write-Host "Step 3: Exporting event data..." -ForegroundColor Cyan

$eventsUrl = "$ProdApiUrl/reports/events?deviceId=$deviceId&from=$from&to=$to"

try {
    Write-Host "  Fetching from: $eventsUrl" -ForegroundColor Gray
    $events = Invoke-RestMethod -Uri $eventsUrl -Method Get -Headers $headers -TimeoutSec 60
    
    if ($events -and $events.Count -gt 0) {
        $outputFile = ".\production_events_simple.json"
        Write-Host "  SUCCESS: Found $($events.Count) event records" -ForegroundColor Green
        
        # Convert to JSON and save
        $jsonContent = $events | ConvertTo-Json -Depth 10
        $jsonContent | Out-File -FilePath $outputFile -Encoding UTF8
        
        Write-Host "  Data saved to: $outputFile" -ForegroundColor Green
        
        # Quick validation
        $testContent = Get-Content $outputFile -Raw
        if ($testContent.Trim().StartsWith('[') -and $testContent.Trim().EndsWith(']')) {
            Write-Host "  VERIFIED: Valid JSON array format" -ForegroundColor Green
            
            # Show sample data
            $sampleData = $events | Select-Object -First 1
            Write-Host "  Sample event data:" -ForegroundColor Gray
            Write-Host "    Device ID: $($sampleData.deviceId)" -ForegroundColor Gray
            Write-Host "    Event Type: $($sampleData.type)" -ForegroundColor Gray
            Write-Host "    Event Time: $($sampleData.eventTime)" -ForegroundColor Gray
        } else {
            Write-Host "  WARNING: File format may be incorrect" -ForegroundColor Yellow
        }
    } else {
        Write-Host "  INFO: No event data found" -ForegroundColor Yellow
    }
} catch {
    Write-Host "  ERROR: Failed to fetch event data" -ForegroundColor Red
    Write-Host "  Details: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host "=== Export Complete ===" -ForegroundColor Green
Write-Host "Generated files:" -ForegroundColor Gray
Write-Host "  - production_positions_simple.json" -ForegroundColor Gray
Write-Host "  - production_events_simple.json" -ForegroundColor Gray
