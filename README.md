:cop: VDC RPT CloudPortal
=======================
![PSVersion](https://img.shields.io/static/v1?label=PSVersion&message=%3E%3D5.1&color=blue&style=flat-square&logo=powershell)

## Descripción

Script creación RPT CloudPortal

## Prerequisitos

Powershell

## Ficheros

El presente desarrollo se compone de dos ficheros. Ambos ficheros deberán estar en el mismo directorio:

- Create-CloudPortalRpt.ps1

- claimrules.txt

## Ejecución

1.	Como paso inicial será necesario obtener el SID del grupo “GR_MFA_ENABLED”. 
Para ello se deberá conectar con un usuario de dominio a la VM de Active Directory y lanzar el siguiente comando:
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
-	` $mfaGroupSID` :	_SID obtenido en la sección 1_

3.	Una vez rellenados los campos correspondientes, se guardará el archivo y mediante powershell, con permisos de administrador, se ejecutará el script.
```powerhell
.\Create-CloudPortalRpt.ps1 
```
