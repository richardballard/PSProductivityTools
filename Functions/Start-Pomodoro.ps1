Function Start-Pomodoro {

<#
    .SYNOPSIS
    Start-Pomodoro is a command to start a new Pomodoro session with additional actions.
    
    .DESCRIPTION
    By MVP Ståle Hansen (http://msunified.net) with modifications by Jan Egil Ring
    Pomodoro function by Nathan.Run() http://nathanhoneycutt.net/blog/a-pomodoro-timer-in-powershell/
    Lync Custom states by Jan Egil Ring http://blog.powershell.no/2013/08/08/automating-microsoft-lync-using-windows-powershell/
    Note: for desktops you need to enable presentation settings in order to suppress email alerts, by MVP Robert Sparnaaij: https://msunified.net/2013/11/25/lock-down-your-lync-status-and-pc-notifications-using-powershell/

    Required version: Windows PowerShell 3.0 or later 

    .EXAMPLE
    Start-Pomodoro
    .EXAMPLE
    Start-Pomodoro -Minutes 50 -IFTTStartTrigger start_pomodoro -IFTTStopTrigger stop_pomodoro -IFTTWebhookKey XXXXXXXXX
#>

    [CmdletBinding()]
    Param (
        #Duration of your Pomodoro Session
        [int]$Minutes = 25,                
        [string]$IFTTStartTrigger, #your_IFTTT_maker_start_trigger
        [string]$IFTTStopTrigger, #your_IFTTT_maker_stop_trigger
        [string]$IFTTWebhookKey #your_IFTTT_webhook_key
    )
        
    try {
        #Setting computer to presentation mode, will suppress most types of popups
        presentationsettings /start

        # Trigger start IFTTT webhook
        if ($IFTTStartTrigger -ne '' -and $IFTTWebhookKey -ne '') {        
            try {                      
                $null = Invoke-RestMethod -Uri https://maker.IFTTT.com/trigger/$IFTTStartTrigger/with/key/$IFTTWebhookKey -Method POST -ErrorAction Stop           
                Write-Host -Object "IFTT start trigger invoked successfully" -ForegroundColor Green
            }
            catch  {
                Write-Host -Object "An error occured while invoking IFTT start trigger: $($_.Exception.Message)" -ForegroundColor Yellow
            }
        }
    
        #Counting down to end of Pomodoro
        $seconds = $Minutes * 60
        $delay = 1 #seconds between ticks
        for ($i = $seconds; $i -gt 0; $i = $i - $delay) {
            $percentComplete = 100 - (($i / $seconds) * 100)
            Write-Progress -SecondsRemaining $i `
                -Activity "Pomodoro Focus sessions" `
                -Status "Time remaining:" `
                -PercentComplete $percentComplete            
            Start-Sleep -Seconds $delay
        } 
    }
    catch {
        Write-Host -Object "ERROR with Pomodoro sprint session $($_.Exception.Message)" -ForegroundColor Yellow
    }
    finally {
        #Stopping presentation mode to re-enable outlook popups and other notifications
        presentationsettings /stop

        # Trigger stop IFTTT webhook
        if ($IFTTStopTrigger -ne '' -and $IFTTWebhookKey -ne '') {
            try {                      
                    $null = Invoke-RestMethod -Uri https://maker.IFTTT.com/trigger/$IFTTStopTrigger/with/key/$IFTTWebhookKey -Method POST -ErrorAction Stop           
                    Write-Host -Object "IFTT stop trigger invoked successfully" -ForegroundColor Green
            }
            catch  {
                Write-Host -Object "An error occured while invoking IFTT stop trigger: $($_.Exception.Message)" -ForegroundColor Yellow
            }   
        }

        Write-Host -Object "Pomodoro sprint session ended" -ForegroundColor Red   
    }    
}
