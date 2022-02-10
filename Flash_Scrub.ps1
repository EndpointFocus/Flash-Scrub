$exitcode = 0
$CriticalError = $false
$global:Log = $Log
$global:CurrentUser = [Environment]::UserName
$global:TZbias = (Get-WmiObject -Query "Select Bias from Win32_TimeZone").bias
$global:StartDateTime = Get-Date -Format "HHmmss"
$global:WorkingPath = (Get-Item -Path ".\").FullName
IF ($MyInvocation.MyCommand.Name)
{
    $global:LogFileName = ($MyInvocation.MyCommand.Name).Replace(".ps1","")
}
ELSE
{
    $global:LogFileName = "ScriptLog"
}
# Function - Output to log file #####################################################################################################################################################################################

function OutputToLog($LogText,$Type)
{
    ##Output to Log
    $ErrorActionPreference = "SilentlyContinue"
    $Time = Get-Date -Format "HH:mm:ss.fff"
    $Date = Get-Date -Format "MM-dd-yyyy"
    $LogOutput = "<![LOG[$($LogText)]LOG]!><time=`"$($Time)+$($global:TZBias)`" date=`"$($Date)`" component=`"$global:LogFileName`" context=`"$($Context)`" type=`"$($Type)`" thread=`"$($global:StartDateTime)`" file=`"$($global:CurrentUser)`">"
    IF ((Get-Content "$global:WorkingPath\$global:LogFileName.log" -ErrorAction SilentlyContinue).Count -gt 1000)
    {
        Do
        {
            $ReadCurrentLog = Get-Content "$global:WorkingPath\$global:LogFileName.log"
            $FirstLine = $ReadCurrentLog[0]
            $ReadCurrentLog | where {$_ -ne $FirstLine} | out-file "$global:WorkingPath\$global:LogFileName.log" -Encoding Default
        }
        While((Get-Content "$global:WorkingPath\$global:LogFileName.log").Count -gt 1000)
    }    
    Out-File -InputObject $LogOutput -Append -NoClobber -Encoding Default –FilePath "$global:WorkingPath\$global:LogFileName.log"
}

#####################################################################################################################################################################################################################

# Function - End Script #############################################################################################################################################################################################

Function End-Script
{
    Param
    (
        # Argument: ExitCode
        [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$true)]
        [int]$ExitCode
    )

    IF ($global:Log){OutputToLog -LogText "+++End thread+++" -Type 1}
    $host.SetShouldExit($ExitCode)
    exit
}

#####################################################################################################################################################################################################################
IF ($global:Log){OutputToLog -LogText "+++Starting thread+++" -Type 1}

$ProgressPreference = 'SilentlyContinue'

IF ($global:Log){OutputToLog -LogText "Running Flash Uninstaller" -Type 1}
TRY
{
    Start-Process "$($global:WorkingPath)\uninstall_flash_player.exe" -Argumentlist "-uninstall" -Wait -PassThru -ErrorAction SilentlyContinue
    IF ($global:Log){OutputToLog -LogText "Rann Flash Uninstaller successfully" -Type 1}
}
CATCH
{
    IF ($global:Log){OutputToLog -LogText "Failed to run Flash Uninstaller, continuing" -Type 2}
}


$FlashFolders = @(
"C:\Windows\System32\Macromed\Flash",
"C:\Windows\SysWOW64\Macromed\Flash"
)

$FlashRegistrys = @(
"HKLM:\Software\Macromedia\FlashPlayer",
"HKLM:\Software\Macromedia\FlashPlayerActiveX",
"HKLM:\Software\Macromedia\FlashPlayerPlugin",
"HKLM:\Software\Macromedia\FlashPlayerPepper",
"HKLM:\SOFTWARE\MozillaPlugins\@adobe.com*",
"HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Adobe Flash Player PPAPI",
"HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Adobe Flash Player Pepper",
"HKLM:\Software\Microsoft\Windows\CurrentVersion\RunOnce/FlashPlayerUpdate",

"HKLM:\Software\WOW6432Node\Macromedia\FlashPlayer",
"HKLM:\Software\WOW6432Node\Macromedia\FlashPlayerActiveX",
"HKLM:\Software\WOW6432Node\Macromedia\FlashPlayerPlugin",
"HKLM:\Software\WOW6432Node\Macromedia\FlashPlayerPepper",
"HKLM:\SOFTWARE\WOW6432Node\MozillaPlugins\@adobe.com*",
"HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\Adobe Flash Player PPAPI",
"HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\Adobe Flash Player Pepper",
"HKLM:\Software\WOW6432Node\Microsoft\Windows\CurrentVersion\RunOnce/FlashPlayerUpdate"
)


IF ($global:Log){OutputToLog -LogText "Searching for Flash Player ActiveX 32-Bit" -Type 1}

IF (Test-Path C:\Windows\system32\Macromed\Flash\FlashUtil_ActiveX.exe)
{
    TRY
    {
        $ActiveX32BitOutput = Start-Process -FilePath "C:\Windows\system32\Macromed\Flash\FlashUtil_ActiveX.exe" -Argumentlist "-uninstall" -ErrorAction SilentlyContinue
        IF ($global:Log){OutputToLog -LogText "Successfully ran ActiveX 32-Bit Uninstaller" -Type 1}
    }
    CATCH
    {
        IF ($global:Log){OutputToLog -LogText "Failed to run Flash 32-Bit Uninstaller, continuing" -Type 2}
    }
}

IF ($global:Log){OutputToLog -LogText "Searching for Flash Player ActiveX 64-Bit" -Type 1}

IF (Test-Path C:\Windows\SysWOW64\Macromed\Flash\FlashUtil_ActiveX.exe)
{
    TRY
    {
        $ActiveX32BitOutput = Start-Process -FilePath "C:\Windows\SysWOW64\Macromed\Flash\FlashUtil_ActiveX.exe" -Argumentlist "-uninstall" -ErrorAction SilentlyContinue
        IF ($global:Log){OutputToLog -LogText "Successfully ran ActiveX 64-Bit Uninstaller" -Type 1}
    }
    CATCH
    {
        IF ($global:Log){OutputToLog -LogText "Failed to run Flash ActiveX 64-Bit Uninstaller, continuing" -Type 2}
    }
}

IF ($global:Log){OutputToLog -LogText "Searching for Flash Player Plugin 32-Bit" -Type 1}

IF (Test-Path C:\Windows\system32\Macromed\Flash\FlashUtil_Plugin.exe)
{
    TRY
    {
        $ActiveX32BitOutput = Start-Process -FilePath "C:\Windows\system32\Macromed\Flash\FlashUtil_Plugin.exe" -Argumentlist "-uninstall" -ErrorAction SilentlyContinue
        IF ($global:Log){OutputToLog -LogText "Successfully ran Plugin 32-Bit Uninstaller" -Type 1}
    }
    CATCH
    {
        IF ($global:Log){OutputToLog -LogText "Failed to run Plugin 32-Bit Uninstaller, continuing" -Type 2}
    }
}

IF ($global:Log){OutputToLog -LogText "Searching for Flash Player Plugin 64-Bit" -Type 1}

IF (Test-Path C:\Windows\SysWOW64\Macromed\Flash\FlashUtil_Plugin.exe)
{
    TRY
    {
        $ActiveX32BitOutput = Start-Process -FilePath "C:\Windows\SysWOW64\Macromed\Flash\FlashUtil_Plugin.exe" -Argumentlist "-uninstall" -ErrorAction SilentlyContinue
        IF ($global:Log){OutputToLog -LogText "Successfully ran Plugin 64-Bit Uninstaller" -Type 1}
    }
    CATCH
    {
        IF ($global:Log){OutputToLog -LogText "Failed to run Flash Plugin 64-Bit Uninstaller, continuing" -Type 2}
    }
}


IF ($global:Log){OutputToLog -LogText "Removing folders" -Type 1}

ForEach ($FlashFolder in $FlashFolders)
{
    IF (Test-Path $FlashFolder)
    {
        TRY
        {
            Remove-Item -Path $FlashFolder -Force -Recurse

            IF (Test-Path $FlashFolder)
            {
                { NonsenseString }
            }
            ELSE
            {
                IF ($global:Log){OutputToLog -LogText "Removed `"$FlashFolder`"" -Type 1}
            }
        }
        CATCH
        {
            IF ($global:Log){OutputToLog -LogText "Failed to remove `"$FlashFolder`", taking ownership and trying again" -Type 2}
            TRY
            {
                takeown /a /r /d Y /f $FlashFolder
                cmd.exe /c "cacls $FlashFolder /E /T /G Everyone:F"
                Remove-Item -Path $FlashFolder -Force -Recurse
                IF (Test-Path $FlashFolder)
                {
                    { NonsenseString }
                }
                ELSE
                {
                    IF ($global:Log){OutputToLog -LogText "Removed `"$FlashFolder`"" -Type 1}
                }
            }
            CATCH
            {
                IF ($global:Log){OutputToLog -LogText "Failed to take ownership and remove `"$FlashFolder`"" -Type 3}
                $CriticalError = $true
            }
        }
    }
}

IF ($global:Log){OutputToLog -LogText "Removing Registry items" -Type 1}


ForEach ($FlashRegistry in $FlashRegistrys)
{
    IF (Test-Path $FlashRegistry)
    {
        TRY
        {
            Remove-Item -Path $FlashRegistry -Force -Recurse

            IF (Test-Path $FlashRegistry)
            {
                { NonsenseString }
            }
            ELSE
            {
                IF ($global:Log){OutputToLog -LogText "Removed `"$FlashRegistry`"" -Type 1}
            }
        }
        CATCH
        {
            IF ($global:Log){OutputToLog -LogText "Failed to remove Registry key `"$FlashRegistry`", taking ownership and trying again" -Type 2}
            TRY
            {
                takeown /a /r /d Y /f $FlashRegistry
                cmd.exe /c "cacls $FlashRegistry /E /T /G Everyone:F"
                Remove-Item -Path $FlashRegistry -Force -Recurse
                IF (Test-Path $FlashRegistry)
                {
                    { NonsenseString }
                }
                ELSE
                {
                    IF ($global:Log){OutputToLog -LogText "Removed `"$FlashRegistry`"" -Type 1}
                }
            }
            CATCH
            {
                IF ($global:Log){OutputToLog -LogText "Failed to take ownership and remove `"$FlashRegistry`"" -Type 3}
                $CriticalError = $true
            }
        }
    }
}

IF ($CriticalError)
{
    End-Script 1
}
ELSE
{
    End-Script 0
}