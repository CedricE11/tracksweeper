$auth = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes("admin:admin"))
$headers = @{"Authorization" = "Basic $auth"}

try {
    $events = Invoke-RestMethod -Uri "http://localhost:8082/api/reports/events?deviceId=1&from=2025-01-01T00:00:00.000Z&to=2025-12-31T23:59:59.999Z" -Headers $headers
    Write-Host "Total events: $($events.Count)"
    
    $moving = ($events | Where-Object {$_.type -eq "deviceMoving"}).Count
    $stopped = ($events | Where-Object {$_.type -eq "deviceStopped"}).Count
    
    Write-Host "deviceMoving: $moving"
    Write-Host "deviceStopped: $stopped"
    
    if ($moving -eq 0 -or $stopped -eq 0) {
        Write-Host "ISSUE: Missing motion events needed for trips!" -ForegroundColor Red
    }
    
} catch {
    Write-Host "Error: $($_.Exception.Message)"
}
