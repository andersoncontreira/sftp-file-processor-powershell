
# Example: https://github.com/clymb3r/PowerShell/blob/master/Get-ComputerDetails/Get-ComputerDetails.ps1
# https://docs.microsoft.com/pt-br/powershell/scripting/learn/ps101/09-functions?view=powershell-7.2
# http://dewin.me/powershellref/100-the-basics/500-formatting-output.html#color-formatting

# script parameter
$Target = $args[0]
$ScriptName = "sftp-file-processor"
$ScriptVersion = "1.0.0"

function Initialize
{

    param (
        $Target
    )

    $Now = Get-Date -Format "dddd dd/MM/yyyy HH:mm K"
    
    Write-Host '---------------------------------------------------------'
    Write-Host ("{0} - {1} - Beginning at {2}" -f $ScriptName, $ScriptVersion, $Now)
    Write-Host '---------------------------------------------------------'
    
    
    if ($Target) 
    {
        Write-Host ("Current target to process: {0}" -f $Target)
        
        # check if is dir
        if (Test-Path -Path $Target -PathType Container) {
            Write-Host ("Current target is a folder")

        # check if is file
        } elseif (Test-Path -Path $Target -PathType Leaf) {
            Write-Host ("Current target is a file")
            
        } else {
            Write-Error ("Target not found {0}" -f $Target)
        }

    } else {
        Write-Error "Target must be informad, it can be a folder path or file path! Example: sftp-file-processor.ps1 test-file.txt"
        
    }

}

Initialize -Target $target