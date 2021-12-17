# Script Params
param(
    # Source file or folder
    [string]$Source = "",
    [string]$SFTPHost = "",
    [string]$SFTPUser = "",
    [string]$SFTPPassword = "",
    [string]$SFTPProdPath = "/home/oracle/mastersaf/msafdb",
    [string]$SFTPQAPath = "/home/oracle/mastersaf/msaf",
    # Flags
    [int]$AutoConfirm = 1,
    [int]$QATest = 0
)

# Script variables
$ScriptName = "sftp-file-processor"
$ScriptVersion = "1.0.0"

try {
  $AutoConfirm = [System.Convert]::ToBoolean($AutoConfirm) 
} catch [FormatException] {
  $AutoConfirm = 1
}

try {
  $QATest = [System.Convert]::ToBoolean($QATest) 
} catch [FormatException] {
  $QATest = 0
}


$FileList = [System.Collections.ArrayList]::new()




function Initialize
{
<#
.SYNOPSIS
    Short description
.DESCRIPTION
    Long description
.EXAMPLE
    PS C:\> <example usage>
    Explanation of what the example does
.INPUTS
    Inputs (if any)
.OUTPUTS
    Output (if any)
.NOTES
    General notes
#>

    param (
        $Source
    )

    $Now = Get-Date -Format "dddd dd/MM/yyyy HH:mm K"
    
    Write-Host '---------------------------------------------------------'
    Write-Host ("{0} - {1} - Beginning at {2}" -f $ScriptName, $ScriptVersion, $Now)
    Write-Host '---------------------------------------------------------'
    
    Write-Host ("Script Params:")
    Write-Host ("Source: $Source")
    Write-Host ("SFTPHost: $SFTPHost")
    Write-Host ("SFTPUser: $SFTPUser")
    
    Write-Host ("Script Flags:")
    Write-Host ("Auto Confirm mode: {0}" -f $AutoConfirm)
    Write-Host ("QATest mode: {0}" -f $QATest)
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
        Write-Error "Source must be informed, it can be a folder path or file path! Example: sftp-file-processor.ps1 test-file.txt"
        
    }

    $Now = Get-Date -Format "dddd dd/MM/yyyy HH:mm K"
    
    Write-Host '---------------------------------------------------------'
    Write-Host ("{0} - {1} - Finishing at {2}" -f $ScriptName, $ScriptVersion, $Now)
    Write-Host '---------------------------------------------------------'

}

function Publish-Data
{
<#
.SYNOPSIS
    Short description
.DESCRIPTION
    Long description
.EXAMPLE
    PS C:\> <example usage>
    Explanation of what the example does
.INPUTS
    Inputs (if any)
.OUTPUTS
    Output (if any)
.NOTES
    General notes
#>
    param(
        [Parameter()]
        [string]$Source
    )

    [bool]$Error = 0

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

        Write-Host "pscp -sftp -pw ******** ${Source} ${SFTPUser}@${SFTPHost}:${Target}"
        pscp -sftp -pw ${SFTPPassword} ${Source} ${SFTPUser}@${SFTPHost}:${Target}

        # if ($AutoConfirm) {
        #     Write-Host "pscp -sftp -pw ******** ${Source} ${SFTPUser}@${SFTPHost}:${Target} -y"
        #     pscp -sftp -pw ${SFTPPassword} ${Source} ${SFTPUser}@${SFTPHost}:${Target} -y
        # } else {
        #     Write-Host "pscp -sftp -pw ******** ${Source} ${SFTPUser}@${SFTPHost}:${Target}"
        #     pscp -sftp -pw ${SFTPPassword} ${Source} ${SFTPUser}@${SFTPHost}:${Target}
        # }
        
        
        
    } else {
        Write-Error $ErrorMessage
    }

    
} 

function Info
{
<#
.SYNOPSIS
    Short description
.DESCRIPTION
    Long description
.EXAMPLE
    PS C:\> <example usage>
    Explanation of what the example does
.INPUTS
    Inputs (if any)
.OUTPUTS
    Output (if any)
.NOTES
    General notes
#>
    Write-Host "$ScriptName $ScriptVersion"
    Write-Host "Release under the MIT."
}
function Help
{
<#
.SYNOPSIS
    Short description
.DESCRIPTION
    Long description
.EXAMPLE
    PS C:\> <example usage>
    Explanation of what the example does
.INPUTS
    Inputs (if any)
.OUTPUTS
    Output (if any)
.NOTES
    General notes
#>
    Info
    Write-Host ""
    Write-Host "usage: ./sftp-file-processor.ps1 -Source [source] -SFTPHost [host] -SFTPUser [user] -SFTPPassword ******** -AutoConfirm 0"
    Write-Host ""
    Write-Host "example: ./sftp-file-processor.ps1 -Source ./test-file.txt -SFTPHost 10.1.1.123 -SFTPUser root -SFTPPassword ******** -AutoConfirm 0"
    Write-Host ""
    Write-Host "-Source                     File or folder that will be the source"
    Write-Host "-SFTPHost                   Host to connect"
    Write-Host "-SFTPUser                   User to connect"
    Write-Host "-SFTPPassword               Password to connect"
    Write-Host "-SFTPProdPath               Production target path"
    Write-Host "-SFTPQAPath                 Test target path"
    Write-Host ""
    Write-Host "-AutoConfirm                Define if the script must auto confirm the programs request"
    Write-Host "-QATest                     Define if the script must appoint to the test target"
    Write-Host ""
    Write-Host "-h                          Print this help screen"
    Write-Host "-v                          Print version info"
}
# Write-Host ("args: $args")
if ($args[0]) {
        
    if ($args[0] -eq "-v") 
    {
        Info
        exit
    } elseif ($args[0] -eq "-h") 
    {
        Help    
        exit
    }
}



Initialize -Source $Source

