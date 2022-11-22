#Parametros entrada

$rptName        = "ES_CLOUDPORTAL_TELEFONICATECH_COM"
$rptMetadataUrl = "https://des.es.cloudportal.telefonicatech.com/?morequest=metadata"
$NTDSDomain     = "VD2"
$mfaGroup       = "GR_MFA_ENABLED"
$mfaGroupSID	= "S-1-5-21-2388592060-2084579570-450829506-7105"



$mfaFullGroup = "$NTDSDomain\$mfaGroup"
$currentDir = Get-Location

# Create RPT
Add-AdfsRelyingPartyTrust -Name $rptName -MetadataUrl $rptMetadataUrl `
                          -MonitoringEnabled $true -AutoUpdateEnabled $true `
                          -AccessControlPolicyName "Permit everyone and require MFA for specific group" `
                          -AccessControlPolicyParameters $mfaFullGroup

# CloudPortal RPT Transform Rules
Set-ADFSRelyingPartyTrust -TargetName $rptName -IssuanceTransformRulesFile $currentDir\claimrules.txt