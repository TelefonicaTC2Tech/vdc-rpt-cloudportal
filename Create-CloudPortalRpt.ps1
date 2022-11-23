#Parametros entrada

$rptName        = "XX_CLOUDPORTAL_TELEFONICATECH_COM"
$rptMetadataUrl = "https://XX.cloudportal.telefonicatech.com/?morequest=metadata"
$NTDSDomain     = ""
$mfaGroup       = "GR_MFA_ENABLED"
$mfaGroupSID	 = ""



$mfaFullGroup = "$NTDSDomain\$mfaGroup"
$currentDir = Get-Location

# Create RPT
Add-AdfsRelyingPartyTrust -Name $rptName -MetadataUrl $rptMetadataUrl `
                          -MonitoringEnabled $true -AutoUpdateEnabled $true `
                          -AccessControlPolicyName "Permit everyone and require MFA for specific group" `
                          -AccessControlPolicyParameters $mfaFullGroup

# CloudPortal RPT Transform Rules
Set-ADFSRelyingPartyTrust -TargetName $rptName -IssuanceTransformRulesFile $currentDir\claimrules.txt
