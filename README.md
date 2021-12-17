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
 1977  apt-get update
 1978  sudo apt-get update
 1979  add-apt-repository universe
 1980  sudo add-apt-repository universe
 1981  apt-get install -y powershell
 1982  sudo apt-get install -y powershell
```

### Putty 
Under linux, execute the follow command:
```
sudo apt install putty-tools
```

## Running the script

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