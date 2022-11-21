:cop: VDC RPT CloudPortal
=======================
![PSVersion](https://img.shields.io/static/v1?label=PSVersion&message=%3E%3D5.1&color=blue&style=flat-square&logo=powershell)

## Descripción

Script creación RPT CloudPortal

## Prerequisitos

Powershell

## Ficheros

Create-CloudPortalRpt.ps1

## Ejecución

1.	Como paso inicial es necesario obtener el SID del grupo “GR_MFA_ENABLED”. 
Para ello se deberá conectar con un usuario de dominio al Active Directory y lanzar el siguiente comando:
```powerhell
Get-ADGroup -Filter * | Where Name -eq GR_MFA_ENABLED | Select-Object -Property SID
```


2.	Una vez obtenido el SID, acceder a la VM de ADFS y editar el script:
```powerhell
Create-CloudPortalRpt.ps1 
```

Dicho script tiene una sección inicial con las siguientes variables:
-	` $rptName` :	_Nombre de la RPT_
-	` $rptMetadataUrl` :	_URL donde se ofrece el metadato_
-	` $NTDSDomain` :	_Dominio del AD_
-	` $mfaGroup` :	_Grupo del AD correspondiente con el MFA_
-	` $mfaGroupSID` :	_SID obtenido en la sección anterior_

3.	Una vez rellenados los campos correspondientes, se guardará el archivo y mediante powershell, con permisos de administrador, se ejecutará el script.
```powerhell
.\Create-CloudPortalRpt.ps1 
```
