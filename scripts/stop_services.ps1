# Stop-Services.ps1
# Run as Administrator

$services = @(
    "OracleOraDB19Home3MTSRecoveryService",
    "OracleOraDB19Home3TNSListener",
    "OracleServiceORCL"
)

$logFile = "$env:TEMP\ServiceStopLog_$(Get-Date -Format 'yyyyMMdd_HHmmss').txt"

"=== Service Stop Run: $(Get-Date) ===" | Tee-Object -FilePath $logFile

foreach ($svc in $services) {
    $s = Get-Service -Name $svc -ErrorAction SilentlyContinue

    if (!$s) {
        "Service NOT FOUND: $svc" | Tee-Object -FilePath $logFile -Append
        continue
    }

    if ($s.Status -eq "Stopped") {
        "Already stopped: $svc" | Tee-Object -FilePath $logFile -Append
    } else {
        "Stopping: $svc ..." | Tee-Object -FilePath $logFile -Append
        try {
            Stop-Service -Name $svc -Force -ErrorAction Stop
            (Get-Service -Name $svc).Status | % {
                "Stopped [$($s.DisplayName)]: $_" | Tee-Object -FilePath $logFile -Append
            }
        } catch {
            "FAILED to stop $svc → $($_.Exception.Message)" | Tee-Object -FilePath $logFile -Append
        }
    }
}

"Log saved to: $logFile"
