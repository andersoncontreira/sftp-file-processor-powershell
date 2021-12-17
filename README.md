# sftp-file-processor-powershell
Simple script to send files to a server by sftp


# Prerequisites
- Putty-tools
- Powershell

## Installation

### Powershell
#### Ubuntu 18.04
Execute the follow command:
```
wget -q https://packages.microsoft.com/config/ubuntu/18.04/packages-microsoft-prod.deb
sudo dpkg -i packages-microsoft-prod.deb
```
#### Ubuntu 16.04
Execute the follow command:
```
wget -q https://packages.microsoft.com/config/ubuntu/16.04/packages-microsoft-prod.deb
sudo dpkg -i packages-microsoft-prod.deb
```
#### All
Execute the follow command:
```
 sudo apt-get update
 sudo add-apt-repository universe
 sudo apt-get install -y powershell
```

### Putty 
Under linux, execute the follow command:
```
sudo apt install putty-tools
```

## Running the script

### Getting help
Execute the follow command:
```
pwsh ./sftp-file-processor.ps1 -h
```

### To execute uploads in a test folder
```
pwsh ./sftp-file-processor.ps1 -Source ./test-folder/ -SFTPHost 10.1.1.123 -SFTPUser root -SFTPPassword pass -QATest 0
```

### To upload a single file
Execute the follow command:
```
pwsh ./sftp-file-processor.ps1 -Source ./test-file.txt -SFTPHost 10.1.1.123 -SFTPUser root -SFTPPassword pass
```
### To upload files in a folder
Execute the follow command:
```
pwsh ./sftp-file-processor.ps1 -Source ./test-folder/ -SFTPHost 10.1.1.123 -SFTPUser root -SFTPPassword pass
```



## Program details

Parameters                |   Value/Type | Example             | Description
--------------------------|--------------|---------------------|------------------------------------------
**Main params**           |              |                     |  
-Source                   | String       | ./test-file.txt     | File or folder that will be the source 
-SFTPHost                 | String       | 10.1.1.123          | Host to connect
-SFTPUser                 | String       | root                | User to connect
-SFTPPassword             | String       | somepass            | Password to connect
-SFTPProdPath             | String       | /home/prod/target   | Production target path
-SFTPQAPath               | String       | /home/test/target   | Test target path
**Control flags**         |              |                     |
-AutoConfirm              | Integer      | 1                   | Define if the script must auto confirm the programs request
-QATest                   | Integer      | 1                   | Define if the script must appoint to the test target
**Info params**           |              |                     |
-h                        | void         |                     | Print the help screen
-v                        | void         |                     | Print version info          
    