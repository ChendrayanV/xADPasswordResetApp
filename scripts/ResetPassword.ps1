#Using AD Module
param (
    $LoginID,

    $uPhoneNumber,

    $newPassword
)

try {
    Import-Module ActiveDirectory
    Set-ADAccountPassword -Identity $LoginID -Reset -NewPassword (ConvertTo-SecureString -AsPlainText $newPassword -Force)
    Set-ADUser -Identity $LoginID -ChangePasswordAtLogon:$true
    #Start-Sleep -Seconds 5
    $sid = ""
    $token = ""
    $number = "FromNumber"

    # Twilio API endpoint and POST params
    $url = "https://api.twilio.com/2010-04-01/Accounts/$sid/Messages.json"
    $params = @{ To = $uPhoneNumber; From = $number; Body = "Your new AD Password in $($newPassword)" }

    # Create a credential object for HTTP basic auth
    $p = $token | ConvertTo-SecureString -asPlainText -Force
    $credential = New-Object System.Management.Automation.PSCredential($sid, $p)

    # Make API request, selecting JSON properties from response
    Invoke-WebRequest $url -Method Post -Credential $credential -Body $params -UseBasicParsing |
        ConvertFrom-Json | Select sid, body
}
catch {
    $_.Exception 
}
