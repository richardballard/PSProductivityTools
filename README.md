# Pomodoro Timer - PSProductivityTools

This is a fork of the [PSProductivityTools PowerShell repository](https://github.com/janegilring/PSProductivityTools) by [Jan Egil Ring](https://twitter.com/JanEgilRing) and [Ståle Hansen](https://twitter.com/StaleHansen).

This is a striped down version of their great work, limiting the features to only a configurable timer and If This Then That webhook integration.

## Overview

This is a tool that allows for a Pomodoro timer to be started from via a PowerShell script. The timer will enable Windows Presentation Mode that will suppress notifications for the period the timer is running. The optional IFTTT webhook integration allows for the other actions to be triggered by the service such as muting your phone (sadly not for iOS devices :disappointed:) or any other actions on IFTTT.

## Installation

This module can be installed locally by pulling the repo, copying the `PSProductivityTools` folder into your local WindowsPowerShell Modules folder. This can be found `%UserProfile%\Documents\WindowsPowerShell\Modules`

## Usage

- **Start-Pomodoro** - Start a new Pomodoro 25 minute timer and enable presentation mode which will suppress windows notifications

- **Start-Pomodoro -Minutes 50** - Start a new timer with a custom duration

- **Start-Pomodoro -IFTTStartTrigger pomodoro_start -IFTTStopTrigger pomodoro_stop -IFTTWebhookKey xxx** - Start a timer that triggers a IFTTT webhook

- **Ctrl + C** - Stops the current Pomodoro timer and sends the stop trigger to IFTTT, if used

## Configure IFTTT

In order to use IFTTT you need to have configured the service to listen for a webhook trigger and perform your desired action. The script needs two webhook actions creating, a _start_ and _stop_ trigger.

Details can be found at [IFTTT Webhook](https://ifttt.com/maker_webhooks). Once you have set up the triggers use these values and the Webhook key in the `-IFTTStartTrigger`,  `-IFTTStopTrigger` and `-IFTTWebhookKey` options show in the usage example above.