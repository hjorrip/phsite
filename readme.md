# Dependency: 
jq (for json parsing)

# OS issues
Tool written and tested on macOS. Some issues have been showing when running on other OS because of \r\n formatting. Running 'dos2unix ./create_phsite.sh' should resolve it. 

# Usage
./create_phsite.sh <email> 
The username in the email field does not have to be valid. The phsite will be using the branding from the domain contained in the email address.

Use responsibly. 
