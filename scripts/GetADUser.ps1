param (
    $sAMAccountName
)

try {
    function GetRandomPassword() {
        $Password = ([char[]]([char]33..[char]95) + ([char[]]([char]97..[char]126)) + 0..9 | 
                Sort-Object {Get-Random})[0..8] -join ''
        $Password = "Welcome" + $Password
        $Password
    }
    $adsi = New-Object adsisearcher
    $adsi.Filter = "(&(ObjectCategory=User)(samaccountname=$sAMAccountName))"
    $PropsToLoad = @('givenname' , 'sn' , 'mail' , 'cn')
    $adsi.PropertiesToLoad.AddRange($PropsToLoad)
    if ($adsi.FindOne()) {
        $UserProperties = $adsi.FindOne().Properties 
        [pscustomobject]@{
            sAMAccountName = $UserProperties['cn'] -as [string]
            FirstName      = $UserProperties['givenname'] -as [string]
            LastName       = $UserProperties['sn'] -as [string]
            Email          = $UserProperties['mail'] -as [string]
            NewPassword    = GetRandomPassword
        } | ConvertTo-Json -Compress
    }
    else {
        [pscustomobject]@{
            sAMAccountName = "No Data"
            FirstName      = "No Data"
            LastName       = "No Data"
            Email          = "No Data"
            NewPassword    = "No Data"
        } | ConvertTo-Json -Compress
    }
}
catch {
    $_.Exception 
}