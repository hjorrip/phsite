# For Windows

## 1. Getting Started
Clone this repository or directly download the `create_phsite.ps1` script to your local machine.

## 2. Prepare PowerShell
Open PowerShell and navigate to the directory containing the `create_phsite.ps1` script.

## 3. Set Execution Policy
To allow the script to run, you must temporarily modify the execution policy for the current PowerShell session:

```powershell
Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope Process
```

## 4. Execute 
To Execute the script, type 
```powershell
.\create_phsite.ps1 -Email test@tesla.com
```
Replace the email with any email for any domain. The script will create an output.html, which you can open up in any browser. 
To change the portal "clone", rerun the script with a different email address, and the script will overwrite the current output.html. To view it, it's enough
to refresh your browser after rerunninng the powershell command. 

# For MacOS
## Dependency: 
jq (for json parsing)

## OS issues
Tool written and tested on macOS. Some issues have been showing when running on other OS because of \r\n formatting. Running 'dos2unix ./create_phsite.sh' should resolve it. 

## Usage
./create_phsite.sh <email> 
The username in the email field does not have to be valid. The phsite will be using the branding from the domain contained in the email address.

Use responsibly. 
