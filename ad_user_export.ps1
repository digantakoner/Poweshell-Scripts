$List = Get-ADUser -Filter * -SearchBase "OU=AGSC,DC=APAC,DC=CORPDIR,DC=NET" -properties samaccountname, givenname, surname, memberof | 
    ForEach-Object {
        $User = $_ 
        $usm = $User.memberOf
        if($usm) {
        $usm | 
        
            ForEach-Object {
                [PSCustomObject]@{
                    userid = $User.samaccountname
                    firstname = $User.givenname
                    lastname = $User.surname
                    #Group = Get-ADGroup -Identity $_  | Select -ExpandProperty Name
                    Group = Get-ADPrincipalGroupMembership $User -Server apac.corpdir.net | Select-Object -Property Name
                    
                }  # end of PSCustomObject
            }  # end of Foreach-Object #2
        }
        else {
        
        $usm |
            New-Object PSObject -Property @{
                userid = $User.samaccountname
                firstname = $User.givenname
                lastname = $User.surname
                Group = ""
            }
        }   
        
    }  # end of Foreach-Object #1
    
$List  | Export-Csv -Path "C:\test2\ad_users.csv" -NoTypeInformation -Append
