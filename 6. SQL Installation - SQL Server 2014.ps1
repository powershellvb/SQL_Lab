﻿# Input Variables
$SqlSetupInventoryPath = 'G:\SQL_Server_Setups';
$SqlEdition = 'Enterprise';
$pInstanceName = 'SQL2014';
$pSqlDatabaseEngineAgentServiceAccount = 'Contso\SQLServices'
$pSqlDatabaseEngineAgentServiceAccountPassword = 'Pa$$w0rd'
$SqlSysAdminAccounts = @('Contso\SQLDBA', 'Contso\SQLServices')
$FeatureParameters = @('SQLEngine', 'Replication', 'FullText', 'BC', 'Conn', 'SSMS', 'ADV_SSMS', 'SNAC_SDK', 'SDK')
$InstanceRootDirectory = 'E:\SysDbs'
$SqlDataDirectory = "E:\Data\$pInstanceName"
$SqlLogDirectory = "E:\Log\$pInstanceName"
$SqlBackupDirectory = "E:\Backup\$pInstanceName"
$SqlTempDbDirectory = "E:\TempDb\$pInstanceName"
$pSqlSAPassword = 'Pa$$w0rd'

# Derived Variables
$SetupISOImagePath = "$SqlSetupInventoryPath\2014\$SqlEdition\SqlServer_2014_$SqlEdition.ISO";
$pSqlSysAdminAccounts = '';
$SqlSysAdminAccounts | foreach {$pSqlSysAdminAccounts += '"' + $_ + '" '}
$pFeatureParameters = '';
$FeatureParameters | foreach {$pFeatureParameters += '"' + $_ + '" '}
$pInstanceRootDirectory = '"' + $InstanceRootDirectory + '"';
$pSqlDataDirectory = '"' + $SqlDataDirectory + '"';
$pSqlBackupDirectory = '"' + $SqlBackupDirectory + '"';
$pSqlTempDbDirectory = '"' + $SqlTempDbDirectory + '"';
$pSqlLogDirectory = '"' + $SqlLogDirectory + '"';
if ($SqlEdition -eq 'Standard') {
  $productKey = 'P7FRV-Y6X6Y-Y8C6Q-TB4QR-DMTTK';
}
elseif ($SqlEdition -eq 'Developer') {
  $productKey = '82YJF-9RP6B-YQV9M-VXQFR-YJBGX';
}
elseif ($SqlEdition -eq 'Enterprise') {
  $productKey = '27HMJ-GH7P9-X2TTB-WPHQC-RG79R';
}

$mountResult = Mount-DiskImage $SetupISOImagePath -PassThru;
$setupDriveLetter = ($mountResult | Get-Volume).DriveLetter + ':\';

$sqlSetupPath
Set-Location $setupDriveLetter;

$OutputVariable = cmd.exe /c "Setup.exe /QS /ACTION=Install /IACCEPTSQLSERVERLICENSETERMS /FEATURES=$pFeatureParameters /INSTANCENAME=$pInstanceName /SQLSVCACCOUNT=$pSqlDatabaseEngineAgentServiceAccount /SQLSVCPASSWORD=$pSqlDatabaseEngineAgentServiceAccountPassword /AGTSVCACCOUNT=$pSqlDatabaseEngineAgentServiceAccount /AGTSVCPASSWORD=$pSqlDatabaseEngineAgentServiceAccountPassword /AGTSVCSTARTUPTYPE=Automatic /SQLSYSADMINACCOUNTS=$pSqlSysAdminAccounts /PID=27HMJ-GH7P9-X2TTB-WPHQC-RG79R /INSTALLSQLDATADIR=$pInstanceRootDirectory /SQLUSERDBDIR=$pSqlDataDirectory /SQLUSERDBLOGDIR=$pSqlLogDirectory /SQLTEMPDBDIR=$pSqlTempDbDirectory /SQLTEMPDBLOGDIR=$pSqlTempDbDirectory /SQLBACKUPDIR=$pSqlBackupDirectory /BROWSERSVCSTARTUPTYPE=Automatic /SECURITYMODE=SQL /SAPWD=$pSqlSAPassword /SQLCOLLATION=SQL_Latin1_General_CP1_CI_AS /TCPENABLED=1 /HIDECONSOLE" | Out-String;

Write-Host $OutputVariable -ForegroundColor DarkRed;
<# # Message in case of Failure
The following error occurred:
No features were installed during the setup execution. The requested features m
ay already be installed. Please review the summary.txt log for further details.

Error result: -2068643838
Result facility code: 1203
Result error code: 2

Please review the summary.txt log for further details
Microsoft (R) SQL Server 2014 12.00.2000.08

Copyright (c) Microsoft Corporation.  All rights reserved.

#>

<# # Message in case of Success
Microsoft (R) SQL Server 2014 12.00.2000.08

Copyright (c) Microsoft Corporation.  All rights reserved.

#>

# Eject/Unmount ISO Image
Dismount-DiskImage -ImagePath $SetupISOImagePath;