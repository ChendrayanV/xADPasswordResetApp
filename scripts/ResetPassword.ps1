<#Function Set-AdUserPwd { 
    Param( 
    [string]$user, 
    [string]$pwd 
    ) #end param 
    $oUser = [adsi]"LDAP://$user" 
    $ouser.psbase.invoke("SetPassword",$pwd) 
    $ouser.psbase.CommitChanges() 
} # end function Set-AdUserPwd 
Set-AdUserPwd -user "cn=bob,ou=HSG_TestOU,dc=nwtraders,dc=com" -pwd P@ssword1