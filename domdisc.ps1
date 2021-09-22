<#Begin Header#>
#requires -version 2
<#
.SYNOPSIS
  FIT Domain Discovery
.DESCRIPTION
  <Brief description of script>
.PARAMETER <Parameter_Name>
    <Brief description of parameter input required. Repeat this attribute if required>
.INPUTS
  Customer Domain Name
.OUTPUTS
  <Outputs if any, otherwise state None - example: Log file stored in C:\Windows\Temp\<name>.log>
.NOTES
  Version:        1.0
  Author:         <Name>
  Creation Date:  <Date>
  Purpose/Change: Initial script development
  
.EXAMPLE
  <Example goes here. Repeat this attribute for more than one example>
#>
<#End Header#>

#Debugging
#$DebugPreference = "Continue"
#Logging feature
#$ErrorActionPreference="SilentlyContinue"

# TimeStamps
$Date = Get-Date -format "yyyy-MM-dd"
$Time = Get-Date -format "yyyy-MM-dd-hh-mm-ss"

#Compress Example
#Compress-Archive -Path C:\Reference\* -DestinationPath C:\Archives\Draft.zip

#Path variables https://docs.microsoft.com/en-us/dotnet/api/system.environment.getfolderpath?view=net-5.0
$DesktopPath = [Environment]::GetFolderPath("Desktop")
$AllUsersDesktopPath = [Environment]::GetFolderPath("CommonDesktopDirectory")

#current script directory
$scriptPath = split-path -parent $MyInvocation.MyCommand.Definition
#current script name
$path = Get-Location
$scriptName = $MyInvocation.MyCommand.Name
$scriptLog = "$scriptPath\log\$scriptName.log"

#stop extra transcripts
try { Stop-Transcript | out-null } catch { }

#start a transcript file
try { Start-Transcript -path $scriptLog } catch { }

<#Functions#>
#checks if powershell is in Administrator mode, if not powershell will fix it  
<#Run-AsAdmin#>
Function Run-AsAdmin
{
	if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {     
		$arguments = "& '" + $myinvocation.mycommand.definition + "'"  
		Start-Process powershell -Verb runAs -ArgumentList $arguments  
		Break  
	}
}
#Example
#Run-AsAdmin

<#Pause#>
#Pause
Function Pause($M="Press any key to continue . . . "){If($psISE){$S=New-Object -ComObject "WScript.Shell";$B=$S.Popup("Click OK to continue.",0,"Script Paused",0);Return};Write-Host -NoNewline $M;$I=16,17,18,20,91,92,93,144,145,166,167,168,169,170,171,172,173,174,175,176,177,178,179,180,181,182,183;While($K.VirtualKeyCode -Eq $Null -Or $I -Contains $K.VirtualKeyCode){$K=$Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")};Write-Host}
#Example
#Pause


<#SimplePrompt#>
Function SimplePrompt($title, $msg)
{
    [void][Reflection.Assembly]::LoadWithPartialName('Microsoft.VisualBasic')
    $text = [Microsoft.VisualBasic.Interaction]::InputBox($msg, $title)
    return $text
	
}
#Example
#$sptest = SimplePrompt "Title of dialog" "Enter your name"
#$sptest

<# Begin Program #>


$domain = SimplePrompt "Enter domain name to check" "Enter your domain"
#$domain

$url = 'https://builtwith.com/' + $domain
Start-Process $url
$url = 'https://mxtoolbox.com/SuperTool.aspx?action=dns%3a' + $domain + '&run=toolpage'
Start-Process $url
$url = 'https://mxtoolbox.com/SuperTool.aspx?action=whois%3a' + $domain + '&run=toolpage'
Start-Process $url
$url = 'https://mxtoolbox.com/SuperTool.aspx?action=mx%3a' + $domain + '&run=toolpage'
Start-Process $url
$url = 'https://mxtoolbox.com/SuperTool.aspx?action=dmarc%3a' + $domain + '&run=toolpage'
Start-Process $url
$url = 'https://mxtoolbox.com/SuperTool.aspx?action=spf%3a' + $domain + '&run=toolpage'


<# End Program #>

<#Begin Footer#>
#Close all open sessions
try
{
	Remove-PSSession $Session
}
catch
{
   #Just suppressing Error Dialogs
}

Get-PSSession | Remove-PSSession
#Close Transcript log
try { Stop-Transcript | out-null } catch { }
<#End Footer#>