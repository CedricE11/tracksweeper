# Robust OsmAnd Import Script with URL validation

param(
    [string]$OsmandUrl = "http://localhost:5155",
    [string]$PositionsFile = ".\production_positions_simple.json",
    [string]$DeviceUniqueId = "S24B000002"
)

Write-Host "=== Robust OsmAnd Import ===" -ForegroundColor Green

# Function to safely convert values for URL
function Get-SafeUrlValue {
    param($value)
    
    if ($null -eq $value -or $value -eq "") {
        return $null
    }
    
    # Convert to string and clean
    $stringValue = $value.ToString().Trim()
    
    # Remove any non-printable characters
    $cleanValue = $stringValue -replace '[^\x20-\x7E]', ''
    
    return $cleanValue
}

# Function to convert timestamp
function Convert-ToUnixTimestamp {
    param($timestamp)
    
    try {
        $fixTimeDate = [datetime]::Parse($timestamp, $null, [System.Globalization.DateTimeStyles]::RoundtripKind)
        return [int64]($fixTimeDate.ToUniversalTime() - (Get-Date "1970-01-01")).TotalSeconds
    }
    catch {
        Write-Host "    WARNING: Failed to parse timestamp '$timestamp'" -ForegroundColor Yellow
        return [int64]((Get-Date).ToUniversalTime() - (Get-Date "1970-01-01")).TotalSeconds
    }
}

# Step 1: Load and validate position data
Write-Host "Step 1: Loading position data..." -ForegroundColor Cyan

if (-not (Test-Path $PositionsFile)) {
    Write-Host "  ERROR: Positions file not found: $PositionsFile" -ForegroundColor Red
    exit 1
}

try {
    $positions = Get-Content $PositionsFile | ConvertFrom-Json
    Write-Host "  SUCCESS: Loaded $($positions.Count) position records" -ForegroundColor Green
} catch {
    Write-Host "  ERROR: Failed to parse positions file: $($_.Exception.Message)" -ForegroundColor Red
    exit 1
}

# Step 2: Test with first position to validate URL construction
Write-Host "Step 2: Testing URL construction with first position..." -ForegroundColor Cyan

$testPos = $positions[0]
$testTimestamp = Convert-ToUnixTimestamp -timestamp $testPos.fixTime

# Clean values
$cleanLat = Get-SafeUrlValue -value $testPos.latitude
$cleanLon = Get-SafeUrlValue -value $testPos.longitude
$cleanSpeed = Get-SafeUrlValue -value $testPos.speed
$cleanAlt = Get-SafeUrlValue -value $testPos.altitude
$cleanCourse = Get-SafeUrlValue -value $testPos.course

Write-Host "  Test position values:" -ForegroundColor Gray
Write-Host "    Latitude: '$cleanLat'" -ForegroundColor Gray
Write-Host "    Longitude: '$cleanLon'" -ForegroundColor Gray
Write-Host "    Timestamp: $testTimestamp" -ForegroundColor Gray

# Build test URL using explicit string formatting
$testUrl = "{0}?id={1}&lat={2}&lon={3}&timestamp={4}" -f $OsmandUrl, $DeviceUniqueId, $cleanLat, $cleanLon, $testTimestamp
Write-Host "  Test URL: $testUrl" -ForegroundColor Gray

try {
    $testResponse = Invoke-WebRequest -Uri $testUrl -Method GET -TimeoutSec 5
    Write-Host "  SUCCESS: Test URL works (Status: $($testResponse.StatusCode))" -ForegroundColor Green
} catch {
    Write-Host "  ERROR: Test URL failed: $($_.Exception.Message)" -ForegroundColor Red
    Write-Host "  Cannot proceed with import. Please check the URL construction." -ForegroundColor Red
    exit 1
}

# Step 3: Import positions
Write-Host "Step 3: Importing positions..." -ForegroundColor Cyan

# Sort positions chronologically
$sortedPositions = $positions | Sort-Object { [datetime]::Parse($_.fixTime) }

$successCount = 0
$errorCount = 0
$totalCount = [Math]::Min($sortedPositions.Count, 100)  # Limit to first 100 for testing

Write-Host "  Processing first $totalCount positions for testing..." -ForegroundColor Gray

for ($i = 0; $i -lt $totalCount; $i++) {
    $pos = $sortedPositions[$i]
    
    try {
        $unixTimestamp = Convert-ToUnixTimestamp -timestamp $pos.fixTime
        
        # Clean all values
        $lat = Get-SafeUrlValue -value $pos.latitude
        $lon = Get-SafeUrlValue -value $pos.longitude
        $speed = Get-SafeUrlValue -value $pos.speed
        $altitude = Get-SafeUrlValue -value $pos.altitude
        $course = Get-SafeUrlValue -value $pos.course
        
        # Build minimal URL with only required parameters using explicit formatting
        $url = "{0}?id={1}&lat={2}&lon={3}&timestamp={4}" -f $OsmandUrl, $DeviceUniqueId, $lat, $lon, $unixTimestamp
        
        # Add optional parameters only if they're valid
        if ($speed -and $speed -ne "0" -and $speed -ne "") {
            $url += "&speed=$speed"
        }
        if ($altitude -and $altitude -ne "0" -and $altitude -ne "") {
            $url += "&altitude=$altitude"
        }
        if ($course -and $course -ne "0" -and $course -ne "") {
            $url += "&bearing=$course"
        }
        
        # Add ignition if available
        if ($pos.attributes -and $pos.attributes.ignition -ne $null) {
            $ignitionValue = $pos.attributes.ignition.ToString().ToLower()
            $url += "&ignition=$ignitionValue"
        }
        
        # Send request
        $response = Invoke-WebRequest -Uri $url -Method GET -TimeoutSec 5
        $successCount++
        
        # Show progress every 10 positions
        if (($i + 1) % 10 -eq 0) {
            Write-Host "    Progress: $($i + 1)/$totalCount positions processed" -ForegroundColor Gray
        }
        
    } catch {
        $errorCount++
        if ($errorCount -le 5) {  # Only show first 5 errors
            Write-Host "    WARNING: Position $($i + 1) failed: $($_.Exception.Message)" -ForegroundColor Yellow
        }
    }
    
    # Small delay
    Start-Sleep -Milliseconds 100
}

# Summary
Write-Host "Step 4: Import Summary" -ForegroundColor Cyan
Write-Host "  Device: $DeviceUniqueId" -ForegroundColor Gray
Write-Host "  Positions processed: $totalCount" -ForegroundColor Gray
Write-Host "  Successful imports: $successCount" -ForegroundColor Gray
Write-Host "  Errors: $errorCount" -ForegroundColor Gray

$successRate = [Math]::Round($successCount / $totalCount * 100, 1)
if ($successRate -gt 90) {
    Write-Host "SUCCESS: Import completed successfully ($successRate% success rate)" -ForegroundColor Green
} elseif ($successRate -gt 50) {
    Write-Host "PARTIAL SUCCESS: Most data imported ($successRate% success rate)" -ForegroundColor Yellow
} else {
    Write-Host "WARNING: Low success rate ($successRate%)" -ForegroundColor Red
}

Write-Host "Check the Traccar web interface at http://localhost:8082" -ForegroundColor Cyan
