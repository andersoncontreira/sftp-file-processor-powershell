
# script parameter
$Source = $args[0]
$ScriptName = "sftp-file-processor"
$ScriptVersion = "1.0.0"
[bool]$AutoConfirm = 1
[bool]$QATest = 1
$SFTPHost = ""
$SFTPUser = ""
$SFTPPassword = ""

$SFTPProdPath = "/home/oracle/mastersaf/msafdb"
$SFTPQAPath = "/home/oracle/mastersaf/msaf"

$FileList = [System.Collections.ArrayList]::new()

function Initialize
{

    param (
        $Source
    )

    $Now = Get-Date -Format "dddd dd/MM/yyyy HH:mm K"
    
    Write-Host '---------------------------------------------------------'
    Write-Host ("{0} - {1} - Beginning at {2}" -f $ScriptName, $ScriptVersion, $Now)
    Write-Host '---------------------------------------------------------'
    Write-Host ("Auto Confirm mode: {0}" -f $AutoConfirm)
    Write-Host '---------------------------------------------------------'

    # $pwd_secure_string = Read-Host "Enter a Password" -AsSecureString
    # $pwd_string = Read-Host "Enter a Password" -MaskInput
    
    if ($Source) 
    {
        Write-Host ("Current Source to process: {0}" -f $Source)
        
        # check if is dir
        if (Test-Path -Path $Source -PathType Container) {
            Write-Host ("Current Source is a folder")
            if ($Source -match '/$') {
                $Source = "${Source}*"
            } else {
                $Source = "${Source}/*"
            }
            
            # mount the list of files to be processed
            $Files = Get-ChildItem -Path $Source
            
            foreach ($file in $Files)
            {
                #Write-Host $file
                [void]$FileList.Add($file)
            }

        # check if is file
        } elseif (Test-Path -Path $Source -PathType Leaf) {
            Write-Host ("Current Source is a file")
            # add file to list to be processed
            [void]$FileList.Add($Source)

            
            
        } else {
            Write-Error ("Source not found {0}" -f $Source)
        }

        Write-Host '---------------------------------------------------------'
        Write-Host "Files to be processed:"
        Write-Host '---------------------------------------------------------'
        Write-Host $FileList
        

        if ($AutoConfirm) {
            $ConfirmList = "y"
        } else {
            $ConfirmList = Read-Host "Please confirm the file list, before continue with [y] or [n]"
        }
        

        if ($ConfirmList -eq "y") 
        {
            Publish-Data -Source $Source

        } else {
            Write-Host "Cancelled by user"    
        }

    } else {
        Write-Error "Source must be informad, it can be a folder path or file path! Example: sftp-file-processor.ps1 test-file.txt"
        
    }

    $Now = Get-Date -Format "dddd dd/MM/yyyy HH:mm K"
    
    Write-Host '---------------------------------------------------------'
    Write-Host ("{0} - {1} - Finishing at {2}" -f $ScriptName, $ScriptVersion, $Now)
    Write-Host '---------------------------------------------------------'

}

function Publish-Data
{
    param(
        [Parameter()]
        [string]$Source
    )

    [boll]$Error = 0

    Write-Host '---------------------------------------------------------'
    Write-Host "Processing data via putty-tools..."
    Write-Host '---------------------------------------------------------'

    Write-Host "QA Test target: $SFTPQAPath"
    Write-Host "Production target: $SFTPProdPath"

    if ($QATest) {    
        $Target = $SFTPQAPath
    } else {
        $Target = $SFTPProdPath
    }

    Write-Host ("Source: localhost - {0}" -f $Source)
    Write-Host ("Target: {0} - {1}" -f $SFTPHost,$Target)
    
    if ($SFTPHost -eq "")
    {
        $ErrorMessage = "The SFTP Host must be informed"
        $Error = 1
    }

    if ($SFTPUser -eq "")
    {
        $ErrorMessage = "The SFTP User must be informed"
        $Error = 1
    }

    if ($SFTPPassword -eq "")
    {
        $ErrorMessage = "The SFTP User password must be informed"
        $Error = 1
    }

    if ($Source -eq "")
    {
        $ErrorMessage = "The Source must be informed"
        $Error = 1
    }

    if ($Target -eq "")
    {
        $ErrorMessage = "The Target must be informed"
        $Error = 1
    }

    

    if ($Error -ne 1) 
    {
        # Command structure
        # pscp [options] source [source...] [user@]host:target

        # Print the command info
        # Write-Host "pscp -sftp -pw ${SFTPPassword} ${Source} ${SFTPUser}@${SFTPHost}:${Target}"
        Write-Host "pscp -sftp -pw ******** ${Source} ${SFTPUser}@${SFTPHost}:${Target} -y"
        
        # pscp -sftp -pw ${SFTPPassword} ${Source} ${SFTPUser}@${SFTPHost}:${Target} -y
    } else {
        Write-Error $ErrorMessage
    }

    
} 

# function Debug-Data 
# {

#     param(
#         $FileListToProcess
#     )

    
#     if ($FileListToProcess.count -ge 0) 
#     {
#         Write-Host '---------------------------------------------------------'
#         Write-Host "Processing file list..."
#         Write-Host '---------------------------------------------------------'
        
#         foreach ( $file in $FileListToProcess )
#         {
#             Write-Host ("Processing file: {0}" -f $file)
#         }

#     } else {
#         Write-Host "There is no files to be processed"
#     }

#     Write-Host $FileListToProcess
# }


# Example: https://github.com/clymb3r/PowerShell/blob/master/Get-ComputerDetails/Get-ComputerDetails.ps1
# http://dewin.me/powershellref/100-the-basics/500-formatting-output.html#color-formatting
# https://docs.microsoft.com/pt-br/powershell/scripting/learn/ps101/09-functions?view=powershell-7.2#naming


Initialize -Source $Source