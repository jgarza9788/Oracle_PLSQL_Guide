# Start-Services.ps1
# Run as Administrator

$services = @(
    "OracleOraDB19Home3MTSRecoveryService",
    "OracleOraDB19Home3TNSListener",
    "OracleServiceORCL"
)

$logFile = "$env:TEMP\ServiceStartLog_$(Get-Date -Format 'yyyyMMdd_HHmmss').txt"

"=== Service Start Run: $(Get-Date) ===" | Tee-Object -FilePath $logFile

foreach ($svc in $services) {
    $s = Get-Service -Name $svc -ErrorAction SilentlyContinue

    if (!$s) {
        "Service NOT FOUND: $svc" | Tee-Object -FilePath $logFile -Append
        continue
    }

    if ($s.Status -eq "Running") {
        "Already running: $svc" | Tee-Object -FilePath $logFile -Append
    } else {
        "Starting: $svc ..." | Tee-Object -FilePath $logFile -Append
        try {
            Start-Service -Name $svc -ErrorAction Stop
            (Get-Service -Name $svc).Status | % {
                "Started [$($s.DisplayName)]: $_" | Tee-Object -FilePath $logFile -Append
            }
        } catch {
            "FAILED to start $svc → $($_.Exception.Message)" | Tee-Object -FilePath $logFile -Append
        }
    }
}

"Log saved to: $logFile"
