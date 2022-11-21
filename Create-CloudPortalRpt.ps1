#Parametros entrada

$rptName        = "XX_CLOUDPORTAL_TELEFONICATECH_COM"
$rptMetadataUrl = "https://XX.cloudportal.telefonicatech.com/?morequest=metadata"
$NTDSDomain     = ""
$mfaGroup       = "GR_MFA_ENABLED"
$mfaGroupSID	= ""



$mfaFullGroup = "$NTDSDomain\$mfaGroup"
 
# CloudPortal RPT Transform Rules
$transformRules  = "@RuleTemplate = `"LdapClaims`"
@RuleName = `"Send Attributes`"
c:[Type == `"http://schemas.microsoft.com/ws/2008/06/identity/claims/windowsaccountname`", Issuer == `"AD AUTHORITY`"]
 => issue(store = `"Active Directory`", types = (`"http://schemas.xmlsoap.org/ws/2005/05/identity/claims/nameidentifier`", `"http://schemas.xmlsoap.org/ws/2005/05/identity/claims/name`"), query = `";sAMAccountName,displayName;{0}`", param = c.Value);

@RuleName = `"Groups`"
c:[Type == `"http://schemas.microsoft.com/ws/2008/06/identity/claims/windowsaccountname`", Issuer == `"AD AUTHORITY`"]
 => issue(store = `"Active Directory`", types = (`"Groups`"), query = `";tokenGroups;{0}`", param = c.Value);

@RuleName = `"ClaimMail`"
c:[Type == `"http://schemas.microsoft.com/ws/2008/06/identity/claims/windowsaccountname`"]
 => issue(store = `"Active Directory`", types = (`"http://schemas.xmlsoap.org/ws/2005/05/identity/claims/emailaddress`"), query = `";mail;{0}`", param = c.Value);

@RuleName = `"CheckMailExists`"
NOT EXISTS([Type == `"http://schemas.xmlsoap.org/ws/2005/05/identity/claims/emailaddress`"])
 => add(Type = `"http://temp.org/system/claims/eMailAddressExistance`", Value = `"False`");

@RuleName = `"Push_email_or_upn`"
c1:[Type == `"http://temp.org/system/claims/eMailAddressExistance`", Value == `"False`"]
 && c2:[Type == `"http://schemas.xmlsoap.org/ws/2005/05/identity/claims/upn`"]
 => issue(Type = `"http://schemas.xmlsoap.org/ws/2005/05/identity/claims/emailaddress`", Value = c2.Value);

@RuleTemplate = `"EmitGroupClaims`"
@RuleName = `"Send_1_IF_mfa_enabled`"
c:[Type == `"http://schemas.microsoft.com/ws/2008/06/identity/claims/groupsid`", Value == `"$mfaGroupSID`", Issuer == `"AD AUTHORITY`"]
 => issue(Type = `"MFA_Enabled`", Value = `"1`", Issuer = c.Issuer, OriginalIssuer = c.OriginalIssuer, ValueType = c.ValueType);

@RuleName = `"If_MFA_Not_Exists_mark_Flag_as_false`"
NOT EXISTS([Type == `"http://schemas.microsoft.com/ws/2008/06/identity/claims/groupsid`", Value == `"$mfaGroupSID`", Issuer == `"AD AUTHORITY`"])
 => add(Type = `"http://temp.org/system/claims/MFAAddressExistance`", Value = `"False`");

@RuleName = `"Send_0_IF_Flag_False`"
c1:[Type == `"http://temp.org/system/claims/MFAAddressExistance`", Value == `"False`"]
 => issue(Type = `"MFA_Enabled`", Value = `"0`");

@RuleName = `"Send Password Expiration date`"
c1:[Type == `"http://schemas.microsoft.com/ws/2012/01/passwordexpirationtime`"]
 => issue(Type = `"Password_Expiration_Date`", Value = regexreplace(c1.Value, `"(?<start>^.{1,10}).+$`", `"${start}`"));
"



# Create RPT
Add-AdfsRelyingPartyTrust -Name $rptName -MetadataUrl $rptMetadataUrl `
                          -MonitoringEnabled $true -AutoUpdateEnabled $true `
                          -AccessControlPolicyName "Permit everyone and require MFA for specific group" `
                          -AccessControlPolicyParameters $mfaFullGroup -IssuanceTransformRules $transformRules