# Fixed Restore Database and Import
# Simple, working version

param(
    [string]$LocalServerUrl = "http://localhost:8082",
    [string]$OsmandUrl = "http://localhost:5155",
    [string]$PositionsFile = ".\production_positions_simple.json",
    [string]$DeviceUniqueId = "S24B000002"
)

Write-Host "=== Restore Database and Import ===" -ForegroundColor Green

# Function to convert timestamp
function Convert-ToUnixTimestamp {
    param($timestamp)
    try {
        $fixTimeDate = [datetime]::Parse($timestamp, $null, [System.Globalization.DateTimeStyles]::RoundtripKind)
        return [int64]($fixTimeDate.ToUniversalTime() - (Get-Date "1970-01-01")).TotalSeconds
    }
    catch {
        return [int64]((Get-Date).ToUniversalTime() - (Get-Date "1970-01-01")).TotalSeconds
    }
}

Write-Host "Step 1: Stopping server..." -ForegroundColor Cyan
try {
    taskkill /F /IM java.exe 2>$null | Out-Null
    Write-Host "  Server stopped" -ForegroundColor Green
    Start-Sleep -Seconds 3
} catch {
    Write-Host "  No server running" -ForegroundColor Yellow
}

Write-Host "Step 2: Restoring clean database..." -ForegroundColor Cyan
try {
    Copy-Item ".\target\backup_h2_database\database.mv.db" ".\target\database.mv.db" -Force
    Copy-Item ".\target\backup_h2_database\database.trace.db" ".\target\database.trace.db" -Force
    Write-Host "  Database restored" -ForegroundColor Green
} catch {
    Write-Host "  ERROR: $($_.Exception.Message)" -ForegroundColor Red
    exit 1
}

Write-Host "Step 3: Starting server..." -ForegroundColor Cyan
$serverProcess = Start-Process -FilePath "java" -ArgumentList "-jar", "target/tracker-server.jar", "debug.xml" -PassThru -WindowStyle Hidden
Write-Host "  Server starting..." -ForegroundColor Gray

# Wait for server
$waited = 0
do {
    Start-Sleep -Seconds 2
    $waited += 2
    try {
        $testResponse = Invoke-WebRequest -Uri "$LocalServerUrl/api/server" -TimeoutSec 5
        if ($testResponse.StatusCode -eq 200) {
            Write-Host "  Server ready!" -ForegroundColor Green
            break
        }
    } catch {
        # Not ready yet
    }
    
    if ($waited -ge 30) {
        Write-Host "  ERROR: Server timeout" -ForegroundColor Red
        exit 1
    }
    
    Write-Host "    Waiting... ($waited/30 seconds)" -ForegroundColor Gray
} while ($waited -lt 30)

Write-Host "Step 4: Creating device..." -ForegroundColor Cyan
$AuthHeader = @{ 
    "Authorization" = "Basic " + [System.Convert]::ToBase64String([System.Text.Encoding]::ASCII.GetBytes("admin:admin"))
    "Content-Type" = "application/json" 
}

try {
    $devicePayload = @{
        name = "Device $DeviceUniqueId"
        uniqueId = $DeviceUniqueId
    } | ConvertTo-Json
    
    $device = Invoke-RestMethod -Uri "$LocalServerUrl/api/devices" -Headers $AuthHeader -Method Post -Body $devicePayload
    Write-Host "  Device created: $($device.name)" -ForegroundColor Green
} catch {
    Write-Host "  ERROR: $($_.Exception.Message)" -ForegroundColor Red
    exit 1
}

Write-Host "Step 5: Loading positions..." -ForegroundColor Cyan
$positions = Get-Content $PositionsFile | ConvertFrom-Json

# Filter to time range
$startTime = "2025-01-11T20:12:00.000+00:00"
$endTime = "2025-01-11T20:16:00.000+00:00"

$filteredPositions = $positions | Where-Object { 
    $posTime = [datetime]::Parse($_.fixTime, $null, [System.Globalization.DateTimeStyles]::RoundtripKind)
    $startTimeObj = [datetime]::Parse($startTime, $null, [System.Globalization.DateTimeStyles]::RoundtripKind)
    $endTimeObj = [datetime]::Parse($endTime, $null, [System.Globalization.DateTimeStyles]::RoundtripKind)
    $posTime -ge $startTimeObj -and $posTime -le $endTimeObj
}

$sortedPositions = $filteredPositions | Sort-Object { [datetime]::Parse($_.fixTime) }
Write-Host "  Found $($sortedPositions.Count) positions" -ForegroundColor Gray

Write-Host "Step 6: Importing positions..." -ForegroundColor Cyan
$successCount = 0

foreach ($pos in $sortedPositions) {
    try {
        $unixTimestamp = Convert-ToUnixTimestamp -timestamp $pos.fixTime
        
        $lat = $pos.latitude
        $lon = $pos.longitude
        $speed = $pos.speed
        
        $url = "$OsmandUrl" + "?id=$DeviceUniqueId&lat=$lat&lon=$lon&timestamp=$unixTimestamp"
        
        if ($speed -and $speed -ne "0") { $url += "&speed=$speed" }
        
        if ($pos.attributes) {
            if ($pos.attributes.ignition -ne $null) {
                $url += "&ignition=$($pos.attributes.ignition.ToString().ToLower())"
            }
            if ($pos.attributes.motion -ne $null) {
                $url += "&motion=$($pos.attributes.motion.ToString().ToLower())"
            }
        }
        
        $response = Invoke-WebRequest -Uri $url -Method GET -TimeoutSec 5
        $successCount++
        
        $posTime = [datetime]::Parse($pos.fixTime).ToString("HH:mm:ss")
        Write-Host "    $posTime - Imported" -ForegroundColor Gray
        
    } catch {
        Write-Host "    ERROR: $($_.Exception.Message)" -ForegroundColor Yellow
    }
    
    Start-Sleep -Milliseconds 1000
}

Write-Host "Step 7: Checking results..." -ForegroundColor Cyan
try {
    $fromParam = [System.Web.HttpUtility]::UrlEncode("2025-01-11T20:00:00.000+00:00")
    $toParam = [System.Web.HttpUtility]::UrlEncode("2025-01-12T00:00:00.000+00:00")
    
    $events = Invoke-RestMethod -Uri "$LocalServerUrl/api/reports/events?deviceId=$($device.id)&from=$fromParam&to=$toParam" -Headers $AuthHeader -Method Get
    
    Write-Host "  Events found: $($events.Count)" -ForegroundColor Gray
    
    $eventTypes = $events | Group-Object -Property type
    foreach ($group in $eventTypes) {
        Write-Host "    $($group.Name): $($group.Count) events" -ForegroundColor Gray
    }
    
} catch {
    Write-Host "  Could not check events: $($_.Exception.Message)" -ForegroundColor Yellow
}

Write-Host "Summary:" -ForegroundColor Cyan
Write-Host "  Positions imported: $successCount/$($sortedPositions.Count)" -ForegroundColor Gray
Write-Host "  Server: $LocalServerUrl (admin/admin)" -ForegroundColor Gray

if ($successCount -gt 0) {
    Write-Host "SUCCESS! Check the web interface for trips and events." -ForegroundColor Green
} else {
    Write-Host "ERROR: No positions imported" -ForegroundColor Red
}
