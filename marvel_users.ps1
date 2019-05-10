#Jonathan Johnson
#github:https://github.com/jsecurity101

Write-Output "
   _____                            _              __  __                      _  
 |_   _|                          | |            |  \/  |                    | | 
   | |  _ __ ___  _ __   ___  _ __| |_   ______  | \  / | __ _ _ ____   _____| | 
   | | | '_ ` _ \| '_ \ / _ \| '__| __| |______| | |\/| |/ _` | '__\ \ / / _ \ | 
  _| |_| | | | | | |_) | (_) | |  | |_           | |  | | (_| | |   \ V /  __/ | 
 |_____|_| |_| |_| .__/ \___/|_|   \__|          |_|  |_|\__,_|_|    \_/ \___|_| 
                 | |                                                             
                 |_|                                                             
"  

Function Import-Marvel()


{

Import-Module activedirectory
  
#Update the path to where the .csv file is stored. 

$ADUsers = Import-csv C:\marvel_users.csv

foreach ($User in $ADUsers)

{
	#Read in data from .csv and assign it to the variable. This is done to import attributes in the New-ADUser.
		
	$username 	= $User.username
	$password 	= $User.password
	$firstname 	= $User.firstname
	$lastname 	= $User.lastname
	$ou 		= $User.ou 
    $province   = $User.province
    $department = $User.department
    $password = $User.Password


	#Runs check against AD to verify User doesn't already exist inside of Active Directory

	if (Get-ADUser -F {SamAccountName -eq $Username })
	{
		 Write-Warning "$Username already exists."
	}


#If User doesn't exist, New-ADUser will add $Username to AD based on the objects specified specified in the .csv file. 

	else


	{
        #Update to UserPrincipalName to match personal domain. Ex: If domain is: example.com. Should read as - $Username@example.com
		
		New-ADUser `
            -SamAccountName $Username `
            -UserPrincipalName "$Username@windomain.local" `
            -Name "$firstname $lastname" `
            -GivenName $firstname `
            -Surname $lastname `
            -Enabled $True `
            -DisplayName "$lastname, $firstname" `
            -Path $ou `
            -state $province `
            -Department $department `
            -AccountPassword (convertto-securestring $password -AsPlainText -Force) -PasswordNeverExpires $True
            Write-Output "User that has been added: $username"
	    }
    }
}
Import-Marvel
