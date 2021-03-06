''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'
'  FBConfigBuild.vbs  
'  Copyright FineBuild Team © 2008 - 2018.  Distributed under Ms-Pl License
'
'  Purpose:      Build FineBuild Configuration 
'
'  Author:       Ed Vassie
'
'  Date:         23 Sep 2008
'
'  Change History
'  Version  Author        Date         Description
'  1.0      Ed Vassie     23 Sep 2008  Initial version
'
''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
Option Explicit
Dim SQLBuild : Set SQLBuild = New FineBuild

Class FineBuild

Dim arrClusInstances(26)
Dim colArgs, colBuild, colFiles, colFlags, colGlobal, colStrings, colSysEnvVars, colUsrEnvVars
Dim objAccount, objADOCmd, objADOConn, objADRoot, objCluster, objConfig, objDrive, objFile, objFolder, objFSO, objNetwork, objRE, objShell, objSysInfo, objWMI, objWMIDNS, objWMIReg
Dim intIdx, intProcNum, intSpeedTest, intTimer
Dim strAction, strActionAO, strActionDTC, strActionSQLDB, strActionSQLAS, strActionSQLIS, strActionSQLRS, strActionSQLTools, strActionClusInst, strAdminPassword, strADRoot, strAgentJobHistory, strAgentMaxHistory, strAgtDomainGroup, strAllowUpgradeForRSSharePointMode, strAllUserProf, strAllUserDTop, strAlphabet, strAnyKey, strASDomainGroup, strASProviderMSOlap, strAsServerMode, strAsSvcStartuptype, strAGTSvcStartuptype, strWriterSvcStartupType, strAuditLevel, strAutoLogonCount, strAVCmd
Dim strBackupStart, strBackupRetain, strBackupLogFreq, strBackupLogRetain, strBPEFile, strBuiltinDom
Dim strCatalogServer, strCatalogServerName, strCatalogInstance, strCollationAS, strCollationSQL, strCompatFlags, strCSVFound, strCSVRoot, strConfig, strConfirmIPDependencyChange, strCmd, strCmdPS, strCmdRS, strCmdSQL
Dim strCLSIdDTExec, strCLSIdNetCon, strCLSIdRunBroker, strCLSIdSQL, strCLSIdSQLSetup, strCLSIdSSIS, strCLSIdVS, strClusNetworkId, strClusStorage, strClusSubnet, strClusSuffix, strClusterAction, strClusterBase, strClusterHost, strClusterName, strClusterNameAS, strClusterNameDTC, strClusterNameIS, strClusterNamePE, strClusterNamePM, strClusterNameRS, strClusterNetworkAS, strClusterNetworkDTC, strClusterNetworkSQL, strClusterPath, strClusterGroupAO, strClusterGroupAS, strClusterGroupDTC, strClusterGroupFS, strClusterGroupRS, strClusterGroupSQL, strClusterNameSQL, strClusterNode, strClusterReport, strClusterTCP, strClusAASuffix, strClusAOSuffix, strClusASSuffix, strClusDTCSuffix, strClusDBSuffix, strClusFSSuffix, strClusIMSuffix, strClusISSuffix, strClusMRSuffix, strClusPESuffix, strClusPMSuffix, strClusWinSuffix, strClusRSSuffix, strClusIPAddress, strClusIPVersion, strClusIPV4Address, strClusIPV4Mask, strClusIPV4Network, strClusIPV6Address, strClusIPV6Mask, strClusIPV6Network, strClusterPassive
Dim strDiscoverFile, strDiscoverFolder, strClusterAOFound, strClusterASFound, strClusterDTCFound, strDTCClusterRes, strDTCMultiInstance, strDC, strDfltDoc, strDfltProf, strDfltRoot, strDQPassword, strDRUCltStartupType, strDRUCtlrStartupType
Dim strDBA_DB, strDBAEmail, strDefaultAccount, strDefaultPassword, strDefaultUser, strDNSIPIM, strDNSNameIM, strDomain, strDomainSID, strDirASDLL, strDirDBA, strDirDRU, strDirProg, strDirProgSys, strDirProgSysX86, strDirProgX86, strDirServInst, strDirSQL, strDirSys, strDirSysData, strDirTempWin, strDirTempUser, strDisableNetworkProtocols, strDistDatabase, strDistPassword, strDriveList
Dim strEdition, strEditionEnt, strEdType, strEnableRANU, strEncryptAO, strENU, strErrorReporting, strExpVersion, strExtSvcAccount, strExtSvcPassword
Dim strFailoverClusterRollOwnership, strFarmAccount, strFarmPassword, strFarmAdminIPort, strFBCmd, strFBParm, strFeatures, strFileArc, strFilePerm, strFineBuildStatus, strFirewallStatus, strFSInstLevel, strFSLevel, strFSShareName, strFTSDomainGroup, strFTUpgradeOption, strOptCLREnabled, strOptCostThreshold, strOptMaxServerMemory, strOptOptimizeForAdHocWorkloads, strOptRemoteAdminConnections, strOptRemoteProcTrans, strOptxpCmdshell, strOptions
Dim strPBDMSSvcAccount, strPBDMSSvcPassword, strPBDMSSvcStartup, strPBEngSvcAccount, strPBEngSvcPassword, strPBEngSvcStartup, strPBPortRange, strPBScaleout, strPID, strPowerBIexe, strPowerBIPID, strPreferredOwner, strProfDir, strProfileName, strProgCacls, strProgNTRights, strProgSetSPN, strProgReg, strPSInstall
Dim strGroupAdmin, strGroupDBA, strGroupDBANonSA, strGroupMSA, strDBMailProfile, strDBOwnerAccount
Dim strGroupDistComUsers, strGroupPerfLogUsers, strGroupPerfMonUsers, strGroupRDUsers, strGroupUsers
Dim strHKLMFB, strHKLMSQL, strHKU, strHTTP
Dim strIsInstallDBA, strInstance, strInstAO, strInstMR, strInstRegAS, strInstRegSQL, strInstRegRS, strInstPE, strInstPM, strInstRS, strInstRSDir, strInstRSHost, strInstRSSQL, strInstRSURL, strInstRSWMI, strInstADHelper, strIsSvcStartuptype
Dim strInstAgent, strInstAnal, strInstAS, strInstASCon, strInstASSQL, strInstFT, strInstIS, strInstISMaster, strInstISWorker, strInstNode, strInstNodeAS, strInstNodeIS, strInstLog, strInstTel, strIISAccount, strIISRoot, strIsMasterAccount, strIsMasterPassword, strIsMasterStartupType, strIsMasterPort, strIsMasterThumbprint, strIsWorkerAccount, strIsWorkerPassword, strIsWorkerStartupType, strIsWorkerMaster, strIsWorkerCert
Dim strJobCategory, strKeepAliveCab
Dim strLabBackup, strLabBackupAS, strLabBPE, strLabData, strLabDataAS, strLabDataFS, strLabDataFT, strLabDTC, strLabLog, strLabLogAS, strLabLogTemp, strLabPrefix, strLabProg, strLabSysDB, strLabSystem, strLabTemp, strLabTempAS, strLabTempWin, strLabDBA, strLanguage, strLocalDomain, strLogFile, strListAddNode, strListType, strListCluster, strListCompliance, strListCore, strListEdition, strListMain, strListOSVersion, strListSQLAS, strListSQLDB, strListSQLRS, strListSQLVersion, strListSQLTools, strListSSAS, strListSSIS
Dim strMainInstance, strMaxDop, strMailServer, strMailServerType, strManagementAlias, strManagementDW, strManagementServer, strManagementServerRes, strManagementServerName, strManagementInstance, strMDSAccount, strMDSPassword, strMDSDB, strMDSPort, strMDSSite, strMembersDBA, strMode, strMountRoot, strMSSupplied
Dim strNativeOS, strNetNameSource, strNet4Xexe, strNetworkGUID, strNPEnabled, strNTAuth, strNTAuthAccount, strNTAuthOSName, strNTService, strNumErrorLogs, strNumLogins, strNumTF
Dim strPath, strPathBOL, strPathAddComp, strPathAddCompOrig, strPathCScript, strPathFB, strPathFBStart, strPathFBScripts, strPathNew, strPathSQLCmd, strPathSQLDefault, strPathSQLMedia, strPathSQLMediaOrig, strPathSQLSP, strPathSQLSPOrig, strPathSSMS, strPathSSMSX86, strPathSys, strPathTools, strPathVS, strPassphrase, strProcArc
Dim strRebootLoop, strRegasmExe, strRemoteRoot, strReportOnly, strReportViewerVersion, strRoleDBANonSA, strRSAlias, strRsFxVersion, strRSDBAccount, strRSDBPassword, strRSDBName, strRSEmail, strRSFullURL, strRsHeaderLength, strRSInstallMode, strRSShpInstallMode, strRSSQLLocal, strRSVersion, strRole, strResSuffixAS, strResSuffixDB, strRsSvcStartuptype, strRSVersionNum, strRSWMIPath
Dim strSchedLevel, strSecMain, strSecDBA, strSecTemp, strSecurityMode, strSIDDistComUsers, strSSISDB, strSSISPassword, strSSISRetention, strSSMSexe, strSNACFile, strSPFile, strSPLevel, strSPCULevel, strStreamInsightPID
Dim strStatusAssumed, strStatusBypassed, strStatusComplete, strStatusFail, strStatusManual, strStatusPreConfig, strStatusProgress, strStatusKB2919355, strStatusRobocopy, strStatusXcopy, strStopAt, strSQLAdminAccounts, strSSASAdminAccounts
Dim strSetupAlwaysOn, strSetupAODB, strSetupAPCluster, strSetupCmdshell, strSetupCompliance, strSetupClusterShares, strSetupDBAManagement, strSetupDBOpts, strSetupDisableSA, strSetupFT, strSetupNetBind, strSetupNetName, strSetupNoDefrag, strSetupNonSAAccounts, strSetupNoSSL3, strSetupNoTCPNetBios, strSetupNoTCPOffload, strSetupNoWinGlobal, strSetupOLAP, strSetupOLAPAPI, strSetupSAAccounts, strSetupSAPassword, strSetupServices, strSetupServiceRights, strSetupSnapshot, strSetupSQLAgent, strSetupSQLInst, strSetupSQLServer, strSetupSSL, strSetupStdAccounts, strSetupSysDB, strSetupSysIndex, strSetupSysManagement, strSetupAnalytics, strSetupPowerBI, strSetupPowerBIDesktop, strSetupPSRemote, strSetupPython, strSetupRServer, strSetupRSAdmin, strSetupRSAlias, strSetupRSDB, strSetupRSExec, strSetupRSIndexes, strSetupRSKeepAlive, strSetupRSShare, strSetupRSAT
Dim strSetupABE, strSetupPDFReader, strSetupPerfDash, strSetupPolyBase, strSetupPolyBaseCluster, strSetupProcExp, strSetupProcMon, strSetupRawReader, strSetupRptTaskPad, strSetupRSScripter, strSetupSamples, strSetupSemantics, strSetupIntViewer, strSetupISMaster, strSetupISMasterCluster, strSetupISWorker, strSetupJavaDBC, strSetupJRE, strSetupMDS, strSetupMDSC, strSetupMDXStudio, strInstSQL
Dim strSetupShares, strSetupSPN, strSetupSQLAS, strSetupSQLASCluster, strSetupSQLDB, strSetupSQLDBCluster, strSetupSQLDBAG, strSetupSQLDBFS, strSetupSQLDBFT, strSetupSQLDBRepl, strSetupSQLNS, strSetupSQLTools, strInstStream, strSetupStreamInsight, strSetupStretch, strSetupSystemViews
Dim strSetupBIDS, strSetupBOL, strSetupBPAnalyzer, strSetupBPE, strSetupCmd
Dim strSetupDBMail, strSetupDB2OLE, strSetupDCom, strSetupDimensionSCD, strSetupDistributor, strSetupNoDriveIndex, strSetupDTCCluster, strSetupDTCNetAccess, strSetupDTCNetAccessStatus, strSetupDTSDesigner, strSetupDTSBackup, strSetupDQ, strSetupDQC, strSetupDRUCtlr, strSetupDRUClt, strSetupDTCCID
Dim strSetupFirewall, strSetupGenMaint, strSetupGovernor, strSetupIIS, strSetupKB925336, strSetupKB932232, strSetupKB933789, strSetupKB937444, strSetupKB954961, strSetupKB956250, strSetupKB2781514, strSetupKB2862966, strSetupKB2919355, strSetupKB2919442, strSetupKB3090973, strSetupKB4019990, strSetupManagementDW, strSetupMenus, strSetupMBCA, strSetupMSI45, strSetupMSMPI, strSetupMyDocs
Dim strSetupNet3, strSetupNet4, strSetupNet4x, strSetupNetTrust, strSetupNetwork, strSetupOldAccounts, strSetupParam, strSetupPBM, strSetupPlanExplorer, strSetupPlanExpAddin, strSetupPowerCfg, strSetupPS1, strSetupPS2
Dim strSetupReportViewer, strSetupRMLTools, strSetupRSLinkGen, strSetupSQLBC, strSetupSQLCE, strSetupSQLMail, strSetupSQLIS, strSetupSQLRS, strSetupSQLRSCluster, strSetupSQLNexus
Dim strSetupSlipstream, strSetupSP, strSetupSPCU, strSetupSPCUSNAC, strSetupSSDTBI, strSetupSSMS, strSetupSSISCluster, strSetupSSISDB, strSetupBIDSHelper, strSetupCacheManager
Dim strSetupTelemetry, strSetupTempDb, strSetupTempWin, strSetupTLS12, strSetupTrouble, strSetupVC2010, strSetupVS, strSetupVS2005SP1, strSetupVS2010SP1, strSetupWindows, strSetupWinAudit, strSetupXEvents, strSetupXMLNotepad, strSetupZoomIt
Dim strSKUUpgrade, Server, strClusterSQLFound, strSQLDomainGroup, strSQLEmail, strSQLExe, strSQLLanguage, strSQLLogReinit, strSQLOperator, strSQLProgDir, strSQLMediaArc, strSQLTempdbFileCount, strPCUSource, strCUFile, strCUSource, strRebootStatus, strRegSSIS, strRegSSISSetup, strRegTools, strServInst,  strServIP, strServName, strServParm, strSQLRecoveryComplete, strSQLRSStart, strSQLSharedMR, strSQLSvcStartuptype, strSQLSupportMsi
Dim strSqlBrowserStartup, strSQLList, strSQMReporting
Dim strAgtAccount, strASAccount, strSqlBrowserAccount, strCmdShellAccount, strDRUCtlrAccount, strDRUCltAccount, strFtAccount, strIsAccount, strMDWAccount, strRsAccount, strRsExecAccount, strRsShareAccount, strSqlAccount, strSQLAcDomain, strSQLAgentStart, strLocalAdmin
Dim strAgtPassword, strASPassword, strSqlBrowserPassword, strCmdShellPassword, strDRUCtlrPassword, strDRUCltPassword, strFtPassword, strIsPassword, strMDWPassword, strRsPassword, strRsExecPassword, strRsSharePassword, strSqlPassword, strsaName, strsaPwd
Dim strOSBuild, strOSName, strOSLanguage, strOSLevel, strOSRegPath, strOSType, strOSVersion, strServer, strServerAO, strService, strSQLBinRoot
Dim strTallyCount, strTelSvcAcct, strTelSvcPassword, strTelSvcStartup, strtempdbFile, strtempdbLogFile, strValidate, strValidateError, strListSQL, strSQLVersion, strSQLVersionNet, strSQLVersionNum, strSQLVersionWMI, strTCPEnabled, strTCPPort, strTCPPortAO, strTCPPortAS, strTCPPortDAC, strTCPPortDTC, strTemp, strType, strTypeList
Dim strVarName, strVersionFB, strVSVersionPath, strVSVersionNum, strWaitLong, strWaitMed, strWaitShort, strWOWX86, strXMLNode
Dim strUCServer, strUnknown, strUseFreeSSMS, strUserConfiguration, strUserConfigurationvbs, strUserPreparation, strUserPreparationvbs, strUserProfile, strUserReg, strUpdateSource, strUserDNSDomain, strUserDNSServer, strUserDTop, strUserProf, strUserAdmin, strUserSID, strUseSysDB, strUserAccount, strUserName
Dim strVersionNet3, strVersionNet4,strVolErrorList, strVolFoundList, strVolFBLog, strVolBackup, strVolBackupAS, strVolBPE, strVolData, strVolDataAS, strVolDataFS, strVolDataFT, strVolDTC, strVolLog, strVolLogAS, strVolRoot, strVolRootAS, strVolSysDB, strVolLogTemp, strVolTemp, strVolTempAS, strVolTempWin, strVolProg, strVolSys, strVolDBA, strVolDRU, strVolMDW

Private Sub Class_Initialize
' Perform FineBuild processing

  err.Clear
  Call Initialisation()
 
  Call Process()

End Sub


Private Sub Class_Terminate
' Error handling and termination

  Select Case True
    Case strPathFB = "%SQLFBFOLDER%"
      ' Nothing
    Case err.Number = 0 
      ' Nothing
    Case Else
      Call FBLog("***** Error has occurred *****")
      If err.Number > "" Then
        Call FBLog(" Error code : " & err.Number)
      End If
      If err.Source > "" Then
        Call FBLog(" Source     : " & err.Source)
      End If
      If err.Description > "" Then
        Call FBLog(" Description: " & err.Description)
      End If
      If (strDebugDesc > "") And (strDebugDesc <> err.Description) Then
        Call FBLog(" Last Action: " & strDebugDesc)
      End If
      If strDebugMsg1 <> "" Then
        Call FBLog(" " & strDebugMsg1)
      End If
      If strDebugMsg2 <> "" Then
        Call FBLog(" " & strDebugMsg2)
      End If
      Call FBLog("FineBuild Configuration failed")
    End Select

  Wscript.quit(err.Number)

End Sub


Sub Initialisation ()
' Perform initialisation processing

  Set objShell      = WScript.CreateObject ("Wscript.Shell")
  strPathFB         = objShell.ExpandEnvironmentStrings("%SQLFBFOLDER%")
  Include "FBManageBuildfile.vbs"
  Include "FBManageLog.vbs"
  strProcessIdLabel = "0"
  Call SetProcessIdCode("FBCB")
  Include "FBManageBoot.vbs"
  Include "FBManageCluster.vbs"
  Include "FBUtils.vbs"
  strSQLVersion     = GetBuildfileValue("AuditVersion")

  Set objADOConn    = CreateObject("ADODB.Connection")
  Set objADOCmd     = CreateObject("ADODB.Command")
  Set objConfig     = CreateObject("Microsoft.XMLDOM")
  Set objFSO        = CreateObject("Scripting.FileSystemObject")
  Set objNetwork    = WScript.CreateObject("Wscript.Network")
  Set objSysInfo    = CreateObject("ADSystemInfo")
  Set objWMI        = GetObject("winmgmts:{impersonationLevel=impersonate}!\\.\root\cimv2")
  Set objWMIReg     = GetObject("winmgmts:{impersonationLevel=impersonate}!\\.\root\default:StdRegProv")
  Set colArgs       = Wscript.Arguments.Named
  Set colSysEnvVars = objShell.Environment("System")
  Set colUsrEnvVars = objShell.Environment("User")

  strType           = GetBuildfileValue("Type")
  strTypeList       = " CLIENT CONFIG DISCOVER FIX FULL UPGRADE WORKSTATION "
  strXMLNode        = GetBuildfileValue("TypeNode")
  strConfig         = strPathFB & "\" & GetBuildfileValue("Config")
  strDebugMsg1      = "Config: " & strConfig
  objConfig.async   = "false"
  objConfig.load(strConfig)
  Set colGlobal     = objConfig.documentElement.selectSingleNode("Global")
  Set colBuild      = objConfig.documentElement.selectSingleNode(strXMLNode)
  Set colFiles      = objConfig.documentElement.selectSingleNode("Files")
  Set colFlags      = objConfig.documentElement.selectSingleNode(strXMLNode + "/Flags")
  Set colStrings    = objConfig.documentElement.selectSingleNode("Global/Strings")

  Set objRE         = New RegExp
  objRE.Global      = True
  objRE.IgnoreCase  = True

  objADOConn.Provider            = "ADsDSOObject"
  objADOConn.Open "ADs Provider"
  Set objADOCmd.ActiveConnection = objADOConn

  strHKLMFB         = "HKLM\SOFTWARE\FineBuild\"
  strHKLMSQL        = "HKLM\SOFTWARE\Microsoft\Microsoft SQL Server\"
  strHKU            = &H80000003
  strInstance       = GetBuildfileValue("Instance")
  strsaPwd          = GetParam(Null,                  "saPwd",              "",                    "")
  strPath           = "SOFTWARE\Microsoft\Windows\CurrentVersion\explorer\Shell Folders\"
  objWMIReg.GetStringValue strHKLM,strPath,"Common Desktop",strAllUserDTop
  objWMIReg.GetStringValue strHKLM,strPath,"Common Start Menu",strAllUserProf
  strActionClusInst = "INSTALLFAILOVERCLUSTER"
  strAdminPassword  = GetParam(Null,                  "AdminPassword",      "",                    "")
  strAgentJobHistory  = GetParam(colGlobal,           "AgentJobHistory",    "",                    "500")
  strAgentMaxHistory  = GetParam(colGlobal,           "AgentMaxHistory",    "",                    "20000")
  strAgtDomainGroup = GetParam(Null,                  "AgtDomainGroup",     "AgtClusterGroup",     "")
  strEncryptAO      = UCase(GetParam(colStrings,      "EncryptAO",          "",                    "AES"))
  strAlphabet       = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
  strAnyKey         = GetParam(colStrings,            "AnyKey",             "",                    "Press any key")
  strASDomainGroup  = GetParam(Null,                  "ASDomainGroup",      "ASClusterGroup",      "")
  strASProviderMSOlap = GetParam(colGlobal,           "ASProviderMSOlap",   "",                    "1")
  strAsServerMode   = UCase(GetParam(colGlobal,       "ASServerMode",       "",                    "MultiDimensional"))
  strAuditLevel     = GetParam(colGlobal,             "AuditLevel",         "",                    "2")
  strAVCmd          = GetParam(colStrings,            "AVCmd",              "",                    "POWERSHELL Add-MpPreference -ExclusionPath ")
  strBackupStart    = GetParam(colStrings,            "BackupStart",        "",                    "21:01:00")
  strBackupRetain   = GetParam(colStrings,            "BackupRetain",       "",                    "23")
  strBackupLogFreq  = GetParam(colStrings,            "BackupLogFreq",      "",                    "60")
  strBackupLogRetain  = GetParam(colStrings,          "BackupLogRetain",    "",                    "24")
  strBPEFile        = GetParam(colGlobal,             "BPEFile",            "",                    "100 GB")
  strCatalogInstance  = ""
  strCatalogServer  = Ucase(GetParam(colGlobal,       "CatalogServer",      "",                    ""))
  strCLSIdDTExec    = GetParam(colStrings,            "CLSIdDTExec",        "",                    "")
  strCLSIdNetCon    = GetParam(colStrings,            "CLSIdNetCon",        "",                    "")
  strCLSIdRunBroker = GetParam(colStrings,            "CLSIdRunBroker",     "",                    "")
  strCLSIdSQL       = GetParam(colStrings,            "CLSIdSQL",           "",                    "")
  strCLSIdSQLSetup  = GetParam(colStrings,            "CLSIdSQLSetup",      "",                    "")
  strCLSIdSSIS      = GetParam(colStrings,            "CLSIdSSIS",          "",                    "")
  strCLSIdVS        = GetParam(colStrings,            "CLSIdVS",            "",                    "")
  strClusterDTCFound  = ""
  strClusterTCP     = Ucase(GetParam(colGlobal,       "ClusterTCP",         "",                    "IPv4"))
  strClusAASuffix   = UCase(GetParam(colStrings,      "ClusAASuffix",       "",                    "AA"))
  strClusAOSuffix   = UCase(GetParam(colStrings,      "ClusAOSuffix",       "",                    "AO"))
  strClusASSuffix   = Ucase(GetParam(colStrings,      "ClusASSuffix",       "",                    "AS"))
  strClusDBSuffix   = Ucase(GetParam(colStrings,      "ClusDBSuffix",       "",                    "DB"))
  strClusDTCSuffix  = UCase(GetParam(colStrings,      "ClusDTCSuffix",      "",                    "TC"))
  strClusFSSuffix   = UCase(GetParam(colStrings,      "ClusFSSuffix",       "",                    "FS"))
  strClusISSuffix   = UCase(GetParam(colStrings,      "ClusISSuffix",       "",                    "IS"))
  strClusIMSuffix   = UCase(GetParam(colStrings,      "ClusIMSuffix",       "",                    "IM"))
  strClusMRSuffix   = UCase(GetParam(colStrings,      "ClusMRSuffix",       "",                    "MR"))
  strClusPESuffix   = UCase(GetParam(colStrings,      "ClusPESuffix",       "",                    "PE"))
  strClusPMSuffix   = UCase(GetParam(colStrings,      "ClusPMSuffix",       "",                    "PM"))
  strClusRSSuffix   = UCase(GetParam(colStrings,      "ClusRSSuffix",       "",                    "RS"))
  strClusWinSuffix  = UCase(GetParam(colStrings,      "ClusWinSuffix",      "",                    ""))
  strClusStorage    = "Unknown"
  strCollationAS    = GetParam(colGlobal,             "ASCollation",        "",                    "Latin1_General_CI_AS")
  strCollationSQL   = GetParam(colGlobal,             "SQLCollation",       "",                    "Latin1_General_CI_AS")
  strCompatFlags    = "HKCU\Software\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\"
  strConfirmIPDependencyChange = GetParam(colGlobal,  "ConfirmIPDependencyChange",             "", "0")
  strCSVFound       = ""
  strDBA_DB         = GetParam(colGlobal,             "DBA_DB",             "",                    "DBA_Data")
  strDBAEmail       = GetParam(colGlobal,             "DBAEmail",           "",                    "")
  strDBMailProfile  = GetParam(colGlobal,             "DBMailProfile",      "",                    "Public DB Mail")
  strDBOwnerAccount = GetParam(colGlobal,             "DBOwnerAccount",     "",                    "DBOwner")
  strDirDBA         = GetParam(colGlobal,             "DirDBA",             "",                    "DBA Files")
  strDirProgSys     = objFSO.GetAbsolutePathName(objShell.ExpandEnvironmentStrings("%PROGRAMFILES%"))
  strDirSQL         = GetParam(colGlobal,             "DirSQL",             "",                    "MSSQL")
  strDirSys         = objFSO.GetAbsolutePathName(objShell.ExpandEnvironmentStrings("%WINDIR%"))
  strDirSysData     = objFSO.GetAbsolutePathName(objShell.ExpandEnvironmentStrings("%PROGRAMDATA%"))
  strDirTempWin     = GetParam(colGlobal,             "DirTempWin",         "",                    "Temp")
  strDirTempUser    = GetParam(colGlobal,             "DirTempUser",        "",                    "Temp")
  strDisableNetworkProtocols = GetParam(colGlobal,    "DisableNetworkProtocols",               "", "0")
  strDistDatabase   = GetParam(colGlobal,             "DistributorDatabase","",                    "Distribution")
  strDistPassword   = GetParam(Null,                  "DistributorPassword","",                    strsaPwd)
  strDomain         = objShell.ExpandEnvironmentStrings("%USERDOMAIN%")
  strDQPassword     = GetParam(Null,                  "DQPassword",         "",                    strsaPwd)
  strDriveList      = ""
  strDTCMultiInstance = Ucase(GetParam(colFlags,      "DTCMultiInstance",   "",                    "Yes"))
  strEdition        = GetBuildfileValue("AuditEdition")
  strEditionEnt    = ""
  strEdType         = ""
  strEnableRANU     = GetParam(Null,                  "EnableRANU",         "",                    "1")
  strErrorReporting = GetParam(colGlobal,             "ErrorReporting",     "",                    "0")
  strFailoverClusterRollOwnership = UCase(GetParam(Null, "FailoverClusterRollOwnership","",        ""))
  strFarmAccount    = GetParam(Null,                  "FarmAccount",        "",                    "")
  strFarmPassword   = GetParam(Null,                  "FarmPassword",       "",                    "")
  strFarmAdminIPort = GetParam(Null,                  "FarmAdminIPort",     "",                    "")
  strFBCmd          = objShell.ExpandEnvironmentStrings("%SQLFBCMD%")
  strFBParm         = objShell.ExpandEnvironmentStrings("%SQLFBPARM%")
  strFeatures       = GetParam(colBuild,              "Features",           "",                    "") 
  strFilePerm       = GetBuildfileValue("FilePerm")
  strFineBuildStatus  = GetBuildfileValue("FineBuildStatus")
  strFSLevel        = GetParam(colGlobal,             "FileStreamLevel",    "",                    "2")
  strFSShareName    = UCase(GetParam(Null,            "FileStreamShareName","",                    "FS" & strInstance))
  strFTSDomainGroup = GetParam(Null,                  "FTSClusterGroup",    "",                    "")
  strFTUpgradeOption  = GetParam(Null,                "FTUpgradeOption",    "",                    "")
  strPath           = "SYSTEM\CurrentControlSet\Services\SharedAccess\Parameters\FirewallPolicy\DomainProfile"
  objWMIReg.GetDwordValue strHKLM, strPath, "EnableFirewall", strFirewallStatus
  strInstADHelper   = GetParam(colStrings,            "InstADHelper",       "",                    "")
  strInstIS         = GetParam(colStrings,            "InstIS",             "",                    "")
  strInstISMaster   = GetParam(colStrings,            "InstISMaster",       "",                    "")
  strInstISWorker   = GetParam(colStrings,            "InstISWorker",       "",                    "")
  strInstMR         = GetParam(colStrings,            "InstMR",             "",                    "")
  strInstRegAS      = GetBuildfileValue("InstRegAS")
  strInstRegSQL     = GetBuildfileValue("InstRegSQL")
  strInstRegRS      = GetBuildfileValue("InstRegRS")
  strIsMasterPort   = GetParam(colGlobal,             "TCPPortISMaster",    "",                    "8391")
  strIsMasterThumbprint = GetParam(Null,              "ISMasterSvcThumbprint",  "",                "")
  strIsWorkerMaster = GetParam(Null,                  "ISWorkerSvcMaster",  "",                    "")
  strIsWorkerCert   = GetParam(Null,                  "ISWorkerSvcCert",    "",                    "")
  strJobCategory    = GetParam(colGlobal,             "JobCategory",        "",                    "Database Maintenance")
  strLabBackup      = GetParam(colStrings,            "LabBackup",          "",                    "Backup")
  strLabBackupAS    = GetParam(colStrings,            "LabBackupAS",        "",                    "AS Backup")
  strLabBPE         = GetParam(colStrings,            "LabBPE",             "",                    "BPE")
  strLabData        = GetParam(colStrings,            "LabData",            "",                    "SQL Data")
  strLabDataAS      = GetParam(colStrings,            "LabDataAS",          "",                    "AS Data")
  strLabDataFS      = GetParam(colStrings,            "LabDataFS",          "",                    "FS Data")
  strLabDataFT      = GetParam(colStrings,            "LabDataFT",          "",                    "FT Data")
  strLabDBA         = GetParam(colStrings,            "LabDBA",             "",                    "DBA Misc")
  strLabDTC         = GetParam(colStrings,            "LabDTC",             "",                    "MSDTC")
  strLabLog         = GetParam(colStrings,            "LabLog",             "",                    "SQL Log")
  strLabLogAS       = GetParam(colStrings,            "LabLogAS",           "",                    "AS Log")
  strLabLogTemp     = GetParam(colStrings,            "LabLogTemp",         "",                    "Temp Log")
  strLabPrefix      = UCase(GetParam(Null,            "LabPrefix",          "",                    ""))
  strLabSysDB       = GetParam(colStrings,            "LabSysDB",           "",                    "SQL SysDB")
  strLabProg        = GetParam(colStrings,            "LabProg",            "",                    "Programs")
  strLabSystem      = GetParam(colStrings,            "LabSystem",          "",                    "System")
  strLabTemp        = GetParam(colStrings,            "LabTemp",            "",                    "SQL Temp")
  strLabTempAS      = GetParam(colStrings,            "LabTempAS",          "",                    "AS Temp")
  strLabTempWin     = GetParam(colStrings,            "LabTempWin",         "",                    "Temp")
  strLanguage       = UCase(GetParam(colStrings,      "Language",           "",                    "ENU"))
  strListAddNode    = ""
  strListCluster    = ""
  strListCompliance = ""
  strListCore       = ""
  strListEdition    = ""
  strListMain       = ""
  strListSQLDB      = ""
  strListOSVersion  = ""
  strListSQLTools   = ""
  strListSQLRS      = ""
  strListSQLVersion = ""
  strListSSAS       = ""
  strListSSIS       = ""
  strListType       = ""
  strLocalAdmin     = GetBuildfileValue("LocalAdmin")
  strMailServer     = GetParam(colGlobal,             "MailServer",         "",                    "")
  strMailServerType = ""
  strMainInstance   = GetBuildfileValue("MainInstance")
  strManagementDW   = GetParam(colGlobal,             "ManagementDW",       "",                    "ManagementDW")
  strManagementServer = Ucase(GetParam(colGlobal,     "ManagementServer",   "",                    ""))
  strPath           = Mid(strHKLMFB, 6)
  objWMIReg.GetStringValue strHKLM,strPath,"ManagementServer",strManagementServerRes
  strMaxDop         = GetParam(Null,                  "MaxDop",             "",                    "0")
  strMDSDB          = GetParam(colGlobal,             "MDSDB",              "",                    "MDSData")
  strMDSPort        = GetParam(colGlobal,             "MDSPort",            "",                    "5091")
  strMDSSite        = GetParam(colGlobal,             "MDSSite",            "",                    "MDS")
  strMode           = Ucase(GetParam(Null,            "Mode",               "",                    "QUIET"))
  strMountRoot      = GetParam(colStrings,            "MountRoot",          "",                    "MountPoints")
  strNativeOS       = GetParam(colStrings,            "NativeOS",           "",                    "")
  strNetNameSource  = UCase(GetParam(colStrings,      "NetNameSource",      "",                    "CLUSTER"))
  strNetworkGUID    = "4D36E972-E325-11CE-BFC1-08002BE10318"
  strNPEnabled      = GetParam(colGlobal,             "NPEnabled",          "",                    "1")
  strNTAuthAccount  = GetParam(colStrings,            "NTAuthAccount",      "",                    "")
  strNTService      = GetParam(colStrings,            "NTService",          "",                    "NT SERVICE")
  strNumErrorLogs   = GetParam(colGlobal,             "NumErrorLogs",       "",                    "31")
  strNumLogins      = GetParam(colGlobal,             "NumLogins",          "",                    "20")
  strNumTF          = GetParam(colStrings,            "NumTF",              "",                    "20")
  strOptCLREnabled  = GetParam(colBuild,              "spConfigureCLREnabled",                 "", "1")
  strOptCostThreshold             = GetParam(colBuild,"spConfigureCostThreshold",              "", "20")
  strOptMaxServerMemory           = GetParam(colBuild,"spConfigureMaxServerMemory",            "", "")
  strOptOptimizeForAdHocWorkloads = GetParam(colBuild,"spConfigureOptimizeForAdHocWorkloads",  "", "1")
  strOptRemoteAdminConnections    = GetParam(colBuild,"spConfigureRemoteAdminConnections",     "", "1")
  strOptRemoteProcTrans           = GetParam(colBuild,"spConfigureRemoteProcTrans",            "", "0")
  strOptxpCmdshell  = GetParam(colBuild,              "spConfigurexpCmdshell",                 "", "0")
  strOptions        = GetParam(colBuild,              "Options",            "",                    "") 
  strOSRegPath      = "SOFTWARE\Microsoft\Windows NT\CurrentVersion\"
  strOSName         = objShell.RegRead("HKLM\" & strOSRegPath & "ProductName")
  strOSVersion      = objShell.RegRead("HKLM\" & strOSRegPath & "CurrentVersion")
  strPassphrase     = GetParam(Null,                  "Passphrase",         "",                    "")
  strPathFBStart    = objShell.ExpandEnvironmentStrings("%SQLFBSTART%")
  strPathSQLDefault = "..\SQLMedia"
  strPathSQLMediaOrig = GetParam(colStrings,          "PathSQLMedia",       "",                    "")
  strPathSys        = GetParam(colStrings,            "PathSys",            "",                    strDirSys & "\system32\")
  strPBPortrange    = GetParam(colGlobal,             "PBPortRange",        "",                    "16450-16460")
  strPBScaleout     = UCase(GetParam(colGlobal,       "PBScaleout",         "",                    "True"))
  strPID            = Ucase(GetParam(Null,            "PID",                "PIDKEY",              ""))
  strPowerBIPID     = Ucase(GetParam(colStrings,      "PowerBIPID",         "",                    ""))
  strPreferredOwner = UCase(GetParam(Null,            "PreferredOwner",     "",                    ""))
  strProcArc        = Ucase(objShell.ExpandEnvironmentStrings("%PROCESSOR_ARCHITECTURE%"))
  strProcessId      = GetBuildfileValue("ProcessId")
  strPath           = objShell.RegRead("HKLM\" & strOSRegPath & "ProfileList\ProfilesDirectory")
  strProfDir        = objShell.ExpandEnvironmentStrings(strPath)
  strProfileName    = objShell.ExpandEnvironmentStrings("%USERPROFILE%")
  strProfileName    = Mid(strProfileName, InStrRev(strProfileName, "\") + 1)
  intProcNum        = objShell.ExpandEnvironmentStrings("%NUMBER_OF_PROCESSORS%")
  strProgCacls      = UCase(GetParam(colFiles,        "ProgCacls",          "",                    "cacls"))
  strProgNTRights   = UCase(GetParam(colFiles,        "ProgNtrights",       "",                    "ntrights"))
  strProgSetSPN     = UCase(GetParam(colFiles,        "ProgSetSPN",         "",                    "setspn"))
  strProgReg        = UCase(GetParam(colFiles,        "ProgReg",            "",                    "reg"))
  strReportOnly     = GetBuildfileValue("ReportOnly")
  strResponseNo     = UCase(GetParam(colStrings,      "ResponseNo",         "",                    "N"))
  strResponseYes    = UCase(GetParam(colStrings,      "ResponseYes",        "",                    "Y"))
  strRole           = GetParam(colGlobal,             "Role",               "",                    "")
  strRoleDBANonSA   = GetParam(colStrings,            "RoleDBANonSA",       "",                    "DBA_NonAdmin")
  strRSAlias        = GetParam(Null,                  "RSAlias",            "",                    "")
  strRsFxVersion    = GetParam(colStrings,            "RsFxVersion",        "",                    "")
  strRSDBAccount    = GetParam(Null,                  "RSUpgradeDatabaseAccount",              "", "")
  strRSDBPassword   = GetParam(Null,                  "RSUpgradePassword",  "",                    "")
  strRsHeaderLength = GetParam(colStrings,            "RsHeaderLength",     "",                    "65534")
  strRSSQLLocal     = GetParam(colGlobal,             "RSSQLLocal",         "",                    "1")
  strRSVersionNum   = GetParam(colStrings,            "RSVersionNum",       "",                    "")
  strsaName         = GetParam(colGlobal,             "saName",             "",                    "sa")
  strSecMain        = GetParam(colGlobal,             "SecMain",            "",                    """Administrators"":F ""Users"":R")
  strSecTemp        = GetParam(colGlobal,             "SecTemp",            "",                    """NETWORK SERVICE"":F ""SYSTEM"":F ""Users"":F")
  strSecurityMode   = GetParam(colGlobal,             "SecurityMode",       "",                    "")
  strServer         = GetBuildfileValue("AuditServer")
  strServParm       = UCase(GetParam(Null,            "Server",             "",                    strServer))
  strSetupABE       = Ucase(GetParam(colFlags,        "SetupABE",           "InstABE",             "Yes"))
  strSetupAlwaysOn  = Ucase(GetParam(colFlags,        "SetupAlwaysOn",      "",                    "No"))
  strSetupAODB      = Ucase(GetParam(colFlags,        "SetupAODB",          "",                    "No"))
  strSetupAnalytics = Ucase(GetParam(colFlags,        "SetupAnalytics",     "",                    ""))
  strSetupAPCluster = Ucase(GetParam(colFlags,        "SetupAPCluster",     "",                    "No"))
  strSetupBIDS      = UCase(GetParam(colFlags,        "SetupBIDS",          "InstBIDS",            "Yes"))
  strSetupBIDSHelper  = Ucase(GetParam(colFlags,      "SetupBIDSHelper",    "InstBIDSHelper",      "Yes"))
  strSetupBPAnalyzer  = Ucase(GetParam(colFlags,      "SetupBPAnalyzer",    "InstBPAnalyzer",      "Yes"))
  strSetupBOL       = UCase(GetParam(colFlags,        "SetupBOL",           "InstBOL",             "Yes"))
  strSetupBPE       = Ucase(GetParam(colFlags,        "SetupBPE",           "",                    "No"))
  strSetupCacheManager  = Ucase(GetParam(colFlags,    "SetupCacheManager",  "InstCacheManager",    "Yes"))
  strSetupClusterShares = Ucase(GetParam(colFlags,    "SetupClusterShares", "",                    "No"))
  strSetupCMD       = UCase(GetParam(colFlags,        "SetupCMD",           "",                    "Yes"))
  strSetupCmdshell  = Ucase(GetParam(colFlags,        "SetupCmdshell",      "ConfigCmdshell",      "No"))
  strSetupCompliance  = Ucase(GetParam(colFlags,      "SetupCompliance",    "",                    "No"))
  strSetupDB2OLE    = Ucase(GetParam(colFlags,        "SetupDB2OLE",        "InstDB2OLE",          "Yes"))
  strSetupDBAManagement = Ucase(GetParam(colFlags,    "SetupDBAManagement", "ConfigDBAManagement", "Yes"))
  strSetupDBMail    = UCase(GetParam(colFlags,        "SetupDBMail",        "ConfigDBMail",        "Yes"))
  strSetupDBOpts    = Ucase(GetParam(colFlags,        "SetupDBOpts",        "ConfigDBOpts",        "Yes"))
  strSetupDCom      = Ucase(GetParam(colFlags,        "SetupDCom",          "ConfigDCom",          "Yes"))
  strSetupDimensionSCD = Ucase(GetParam(colFlags,     "SetupDimensionSCD",  "InstDimensionSCD",    "Yes"))
  strSetupDisableSA = Ucase(GetParam(colFlags,        "SetupDisableSA",     "ConfigDisableSA",     "Yes"))
  strSetupDistributor = Ucase(GetParam(colFlags,      "SetupDistributor",   "",                    "No"))
  strSetupDTSDesigner = Ucase(GetParam(colFlags,      "SetupDTSDesigner",   "InstDTSDesigner",     "Yes"))
  strSetupDTSBackup = Ucase(GetParam(colFlags,        "SetupDTSBackup",     "InstDTSBackup",       "Yes"))
  strSetupNoDriveIndex  = UCase(GetParam(colFlags,    "SetupNoDriveIndex",  "",                    "Yes"))
  strSetupNoSSL3    = UCase(GetParam(colFlags,        "SetupNoSSL3",        "",                    "Yes"))
  strSetupNoTCPNetBios  = UCase(GetParam(colFlags,    "SetupNoTCPNetBios",  "",                    "Yes"))
  strSetupNoTCPOffload  = UCase(GetParam(colFlags,    "SetupNoTCPOffload",  "",                    "Yes"))
  strSetupNoWinGlobal   = UCase(GetParam(colFlags,    "SetupNoWinGlobal",   "",                    "Yes"))
  strSetupDQ        = Ucase(GetParam(colFlags,        "SetupDQ",            "",                    ""))
  strSetupDQC       = Ucase(GetParam(colFlags,        "SetupDQC",           "",                    "Yes"))
  strSetupDRUClt    = Ucase(GetParam(colFlags,        "SetupDRUClt",        "",                    "Yes"))
  strSetupDRUCtlr   = Ucase(GetParam(colFlags,        "SetupDRUCtlr",       "",                    ""))
  strSetupDTCCID    = Ucase(GetParam(colFlags,        "SetupDTCCID",        "",                    "Yes"))
  strSetupDTCCluster  = Ucase(GetParam(colFlags,      "SetupDTCCluster",    "",                    ""))
  strSetupDTCNetAccess = UCase(GetParam(colFlags,     "SetupDTCNetAccess",  "",                    "No"))
  strSetupFirewall  = Ucase(GetParam(colFlags,        "SetupFirewall",      "",                    "Yes"))
  strSetupFT        = Ucase(GetParam(colFlags,        "SetupFT",            "ConfigFT",            "Yes"))
  strSetupGenMaint  = UCase(GetParam(colFlags,        "SetupGenMaint",      "ConfigGenMaint",      "Yes"))
  strSetupGovernor  = UCase(GetParam(colFlags,        "SetupGovernor",      "",                    ""))
  strSetupIIS       = Ucase(GetParam(colFlags,        "SetupIIS",           "InstIIS",             "No"))
  strSetupIntViewer = Ucase(GetParam(colFlags,        "SetupIntViewer",     "InstIntViewer",       "Yes"))
  strSetupISMaster  = Ucase(GetParam(colFlags,        "SetupISMaster",      "",                    ""))
  strSetupISMasterCluster = Ucase(GetParam(colFlags,  "SetupISMasterCluster", "",                  ""))
  strSetupISWorker  = Ucase(GetParam(colFlags,        "SetupISWorker",      "",                    ""))
  strSetupJavaDBC   = Ucase(GetParam(colFlags,        "SetupJavaDBC",       "InstJavaDBC",         "Yes"))
  strSetupJRE       = Ucase(GetParam(colFlags,        "SetupJRE",           "",                    "No"))
  strSetupKB925336  = UCase(GetParam(colFlags,        "SetupKB925336",      "",                    ""))
  strSetupKB932232  = UCase(GetParam(colFlags,        "SetupKB932232",      "",                    "")) 
  strSetupKB933789  = UCase(GetParam(colFlags,        "SetupKB933789",      "",                    ""))
  strSetupKB937444  = UCase(GetParam(colFlags,        "SetupKB937444",      "",                    ""))
  strSetupKB954961  = UCase(GetParam(colFlags,        "SetupKB954961",      "",                    "")) 
  strSetupKB956250  = UCase(GetParam(colFlags,        "SetupKB956250",      "",                    ""))
  strSetupKB2781514 = UCase(GetParam(colFlags,        "SetupKB2781514",     "",                    ""))
  strSetupKB2862966 = UCase(GetParam(colFlags,        "SetupKB2862966",     "",                    ""))
  strSetupKB2919355 = UCase(GetParam(colFlags,        "SetupKB2919355",     "",                    ""))
  strSetupKB2919442 = UCase(GetParam(colFlags,        "SetupKB2919442",     "",                    ""))
  strSetupKB3090973 = UCase(GetParam(colFlags,        "SetupKB3090973",     "",                    ""))
  strSetupKB4019990 = UCase(GetParam(colFlags,        "SetupKB4019990",     "",                    ""))
  strSetupManagementDW = Ucase(GetParam(colFlags,     "SetupManagementDW",  "ConfigManagementDW",  ""))
  strSetupMBCA      = Ucase(GetParam(colFlags,        "SetupMBCA",          "",                    ""))
  strSetupMDS       = Ucase(GetParam(colFlags,        "SetupMDS",           "InstMDS",             ""))
  strSetupMDSC      = Ucase(GetParam(colFlags,        "SetupMDSC",          "",                    ""))
  strSetupMDXStudio = Ucase(GetParam(colFlags,        "SetupMDXStudio",     "InstMDXStudio",       "Yes"))
  strSetupMenus     = UCase(GetParam(colFlags,        "SetupMenus",         "ConfigMenus",         "Yes"))
  strSetupMyDocs    = UCase(GetParam(colFlags,        "SetupMyDocs",        "",                    "Yes"))
  strSetupMSI45     = Ucase(GetParam(colFlags,        "SetupMSI45",         "InstMSI45",           "Yes"))
  strSetupMSMPI     = Ucase(GetParam(colFlags,        "SetupMSMPI",         "",                    ""))
  strSetupNet3      = Ucase(GetParam(colFlags,        "SetupNet3",          "InstNet3",            ""))
  strSetupNet4      = Ucase(GetParam(colFlags,        "SetupNet4",          "InstNet4",            "Yes"))
  strSetupNet4x     = Ucase(GetParam(colFlags,        "SetupNet4x",         "SetupNet45",          "Yes"))
  strSetupNetBind   = UCase(GetParam(colFlags,        "SetupNetBind",       "",                    ""))
  strSetupNetName   = UCase(GetParam(colFlags,        "SetupNetName",       "",                    ""))
  strSetupNetTrust  = UCase(GetParam(colFlags,        "SetupNetTrust",      "",                    "Yes"))
  strSetupNetwork   = Ucase(GetParam(colFlags,        "SetupNetwork",       "ConfigNetwork",       "Yes"))
  strSetupNoDefrag  = UCase(GetParam(colFlags,        "SetupNoDefrag",      "",                    ""))
  strSetupNonSAAccounts = Ucase(GetParam(colFlags,    "SetupNonSAAccounts", "ConfigNonSAAccounts", "Yes"))
  strSetupOLAP      = Ucase(GetParam(colFlags,        "SetupOLAP",          "ConfigOLAP",          "Yes"))
  strSetupOLAPAPI   = Ucase(GetParam(colFlags,        "SetupOLAPAPI",       "ConfigOLAPAPI",       "Yes"))
  strSetupOldAccounts = UCase(GetParam(colFlags,      "SetupOldAccounts",   "ConfigOldAccounts",   "Yes"))
  strSetupParam     = Ucase(GetParam(colFlags,        "SetupParam",         "ConfigParam",         "Yes"))
  strSetupPBM       = Ucase(GetParam(colFlags,        "SetupPBM",           "ConfigPBM",           "Yes"))
  strSetupPDFReader = Ucase(GetParam(colFlags,        "SetupPDFReader",     "InstPDFReader",       "Yes"))
  strSetupPerfDash  = Ucase(GetParam(colFlags,        "SetupPerfDash",      "InstPerfDash",        "Yes"))
  strSetupPlanExpAddin = Ucase(GetParam(colFlags,     "SetupPlanExpAddin",  "InstPlanExpAddin",    "Yes"))
  strSetupPlanExplorer = Ucase(GetParam(colFlags,     "SetupPlanExplorer",  "InstPlanExplorer",    "Yes"))
  strSetupPolyBase  = Ucase(GetParam(colFlags,        "SetupPolyBase",      "",                    ""))
  strSetupProcExp   = Ucase(GetParam(colFlags,        "SetupProcExp",       "InstProcExp",         "Yes"))
  strSetupProcMon   = Ucase(GetParam(colFlags,        "SetupProcMon",       "InstProcMon",         "Yes"))
  strSetupPowerCfg  = Ucase(GetParam(colFlags,        "SetupPowerCfg",      "",                    ""))
  strSetupPS1       = Ucase(GetParam(colFlags,        "SetupPS1",           "",                    ""))
  strSetupPS2       = Ucase(GetParam(colFlags,        "SetupPS2",           "InstPS2",             "Yes"))
  strSetupPowerBI   = Ucase(GetParam(colFlags,        "SetupPowerBI",       "",                    ""))
  strSetupPowerBIDesktop = Ucase(GetParam(colFlags,   "SetupPowerBIDesktop","",                    ""))
  strSetupPSRemote  = Ucase(GetParam(colFlags,        "SetupPSRemote",      "",                    "Yes"))
  strSetupPython    = Ucase(GetParam(colFlags,        "SetupPython",        "",                    ""))
  strSetupRawReader = Ucase(GetParam(colFlags,        "SetupRawReader",     "InstRawReader",       "Yes"))
  strSetupReportViewer = Ucase(GetParam(colFlags,     "SetupReportViewer",  "",                    ""))
  strSetupRMLTools  = Ucase(GetParam(colFlags,        "SetupRMLTools",      "InstRMLTools",        "Yes"))
  strSetupRptTaskPad  = Ucase(GetParam(colFlags,      "SetupRptTaskPad",    "InstRptTaskPad",      "Yes"))
  strSetupRServer   = Ucase(GetParam(colFlags,        "SetupRServer",       "",                    ""))
  strSetupRSAT      = UCase(GetParam(colFlags,        "SetupRSAT",          "",                    ""))
  strSetupRSAdmin   = Ucase(GetParam(colFlags,        "SetupRSAdmin",       "ConfigRSAdmin",       "Yes"))
  strSetupRSExec    = Ucase(GetParam(colFlags,        "SetupRSExec",        "ConfigRSExec",        "Yes"))
  strSetupRSAlias   = Ucase(GetParam(colFlags,        "SetupRSAlias",       "",                    "No"))
  strSetupRSIndexes = Ucase(GetParam(colFlags,        "SetupRSIndexes",     "",                    ""))
  strSetupRSKeepAlive = Ucase(GetParam(colFlags,      "SetupRSKeepAlive",   "",                    ""))
  strSetupRSLinkGen = Ucase(GetParam(colFlags,        "SetupRSLinkGen",     "",                    "Yes"))
  strSetupRSScripter  = Ucase(GetParam(colFlags,      "SetupRSScripter",    "InstRSScripter",      "Yes"))
  strSetupSAAccounts  = Ucase(GetParam(colFlags,      "SetupSAAccounts",    "ConfigSAAccounts",    "Yes"))
  strSetupSAPassword  = Ucase(GetParam(colFlags,      "SetupSAPassword",    "ConfigSAPassword",    "Yes"))
  strSetupSamples   = Ucase(GetParam(colFlags,        "SetupSamples",       "InstSamples",         "No"))
  strSetupSemantics = Ucase(GetParam(colFlags,        "SetupSemantics",     "InstSemantics",       "Yes"))
  strSetupServices  = Ucase(GetParam(colFlags,        "SetupServices",      "ConfigServices",      "Yes"))
  strSetupServiceRights = Ucase(GetParam(colFlags,    "SetupServiceRights", "",                    "Yes"))
  strSetupShares    = Ucase(GetParam(colFlags,        "SetupShares",        "",                    "Yes"))
  strSetupSlipstream  = Ucase(GetParam(colFlags,      "SetupSlipstream",    "",                    "Yes"))
  strSetupSnapshot  = Ucase(GetParam(colFlags,        "SetupSnapshot",      "",                    "Yes"))
  strSetupSP        = UCase(GetParam(colFlags,        "SetupSP",            "InstSP",              "Yes"))
  strSetupSPCU      = UCase(GetParam(colFlags,        "SetupSPCU",          "InstSPCU",            "Yes"))
  strSetupSPCUSNAC  = UCase(GetParam(colFlags,        "SetupSPCUSNAC",      "InstSPCUSNAC",        "Yes"))
  strSetupSPN       = Ucase(GetParam(colFlags,        "SetupSPN",           "",                    "Yes"))
  strSetupSQLAgent  = Ucase(GetParam(colFlags,        "SetupSQLAgent",      "ConfigSQLAgent",      "Yes"))
  strSetupSQLAS     = Ucase(GetParam(colFlags,        "SetupSQLAS",         "InstSQLAS",           ""))
  strSetupSQLASCluster = Ucase(GetParam(Null,         "SetupSQLASCluster",  "",                    ""))
  strSetupSQLBC     = UCase(GetParam(colFlags,        "setupSQLBC",         "InstSQLBC",           "Yes"))
  strSetupSQLCE     = UCase(GetParam(colFlags,        "SetupSQLCE",         "",                    ""))
  strSetupSQLDB     = Ucase(GetParam(colFlags,        "SetupSQLDB",         "InstSQLDB",           ""))
  strSetupSQLDBCluster = Ucase(GetParam(Null,         "SetupSQLDBCluster",  "",                    ""))
  strSetupSQLDBAG   = Ucase(GetParam(colFlags,        "SetupSQLDBAG",       "",                    "Yes"))
  strSetupSQLDBRepl = Ucase(GetParam(colFlags,        "SetupSQLDBRepl",     "InstSQLDBRepl",       "Yes"))
  strSetupSQLDBFS   = UCase(GetParam(colFlags,        "SetupSQLDBFS",       "",                    "Yes"))
  strSetupSQLDBFT   = Ucase(GetParam(colFlags,        "SetupSQLDBFT",       "InstSQLDBFT",         "Yes"))
  strSetupSQLInst   = Ucase(GetParam(colFlags,        "SetupSQLInst",       "ConfigSQLInst",       "Yes"))
  strSetupSQLIS     = Ucase(GetParam(colFlags,        "SetupSQLIS",         "InstSQLIS",           ""))
  strSetupSQLMail   = UCase(GetParam(colFlags,        "SetupSQLMail",       "ConfigSQLMail",       "No"))
  strSetupSQLNexus  = Ucase(GetParam(colFlags,        "SetupSQLNexus",      "InstSQLNexus",        "Yes"))
  strSetupSQLNS     = Ucase(GetParam(colFlags,        "SetupSQLNS",         "InstSQLNS",           "No"))
  strSetupSQLRS     = Ucase(GetParam(colFlags,        "SetupSQLRS",         "InstSQLRS",           ""))
  strSetupSQLRSCluster = Ucase(GetParam(colFlags,     "SetupSQLRSCluster",  "",                    ""))
  strSetupSQLServer = Ucase(GetParam(colFlags,        "SetupSQLServer",     "ConfigSQLServer",     "Yes"))
  strSetupSSL       = Ucase(GetParam(colFlags,        "SetupSSL",           "",                    "No"))
  strSetupSQLTools  = Ucase(GetParam(colFlags,        "SetupSQLTools",      "InstSQLTools",        "Yes"))
  strSetupSSDTBI    = Ucase(GetParam(colFlags,        "SetupSSDTBI",        "SetupSSDT",           ""))
  strSetupSSMS      = Ucase(GetParam(colFlags,        "SetupSSMS",          "InstSSMS",            "Yes"))
  strSetupSSISCluster = Ucase(GetParam(colFlags,      "SetupSSISCluster",   "SetupSQLISCluster",   "No"))
  strSetupSSISDB    = Ucase(GetParam(colFlags,        "SetupSSISDB",        "",                    "Yes"))
  strSetupStdAccounts = Ucase(GetParam(colFlags,      "SetupStdAccounts",   "ConfigStdAccounts",   "Yes"))
  strSetupStreamInsight = Ucase(GetParam(colFlags,    "SetupStreamInsight", "InstStreamInsight",   "No"))
  strSetupStretch   = Ucase(GetParam(colFlags,        "SetupStretch",       "",                    "No"))
  strSetupSysDB     = Ucase(GetParam(colFlags,        "SetupSysDB",         "ConfigSysDB",         "Yes"))
  strSetupSysIndex  = Ucase(GetParam(colFlags,        "SetupSysIndex",      "ConfigSysIndex",      "Yes"))
  strSetupSysManagement = Ucase(GetParam(colFlags,    "SetupSysManagement", "ConfigSysManagement", "Yes"))
  strSetupSystemViews   = Ucase(GetParam(colFlags,    "SetupSystemViews",   "InstSystemViews",     "Yes"))
  strSetupTelemetry = Ucase(GetParam(colFlags,        "SetupTelemetry",     "",                    ""))
  strSetupTempDb    = Ucase(GetParam(colFlags,        "SetupTempDb",        "",                    "Yes"))
  strSetupTempWin   = Ucase(GetParam(colFlags,        "SetupTempWin",       "",                    "Yes"))
  strSetupTLS12     = Ucase(GetParam(colFlags,        "SetupTLS12",         "",                    ""))
  strSetupTrouble   = Ucase(GetParam(colFlags,        "SetupTrouble",       "InstTrouble",         "Yes"))
  strSetupVC2010    = UCase(GetParam(colFlags,        "SetupVC2010",        "",                    ""))
  strSetupVS        = UCase(GetParam(colFlags,        "SetupVS",            "",                    "Yes"))
  strSetupVS2005SP1 = Ucase(GetParam(colFlags,        "SetupVS2005SP1",     "InstVS2005SP1",       ""))
  strSetupVS2010SP1 = Ucase(GetParam(colFlags,        "SetupVS2010SP1",     "",                    ""))
  strSetupWindows   = UCase(GetParam(colFlags,        "SetupWindows",       "",                    "Yes"))
  strSetupWinAudit  = UCase(GetParam(colFlags,        "SetupWinAudit",      "",                    ""))
  strSetupXEvents   = Ucase(GetParam(colFlags,        "SetupXEvents",       "InstXEvents",         "Yes"))
  strSetupXMLNotepad  = Ucase(GetParam(colFlags,      "SetupXMLNotepad",    "InstXMLNotepad",      "Yes"))
  strSetupZoomIt    = Ucase(GetParam(colFlags,        "SetupZoomIt",        "InstZoomIt",          "Yes"))
  intSpeedTest      = GetParam(colGlobal,             "SpeedTest",          "",                    "5.0")
  strSQLAdminAccounts  = GetParam(Null,               "SQLSysadminAccounts", "",                   "")
  strSQLOperator    = GetParam(Null,                  "SQLOperator",        "",                    "SQL Alerts")
  strSQLTempdbFileCount = GetParam(colGlobal,         "SQLTempdbFileCount", "",                    "")
  strSSASAdminAccounts = GetParam(Null,               "ASSysadminAccounts", "",                    "")
  strClusterAOFound = ""
  strClusterASFound = ""
  Server            = ""
  strClusterSQLFound  = ""
  strPath           = Mid(strHKLMFB, 6)
  objWMIReg.GetStringValue strHKLM,strPath,"DTCClusterRes",strDTCClusterRes
  objWMIReg.GetStringValue strHKLM,strPath,"SetupDTCNetAccessStatus",strSetupDTCNetAccessStatus
  strSPLevel        = UCase(GetParam(colGlobal,       "SPLevel",            "",                    "RTM"))
  strSPCULevel      = UCase(GetParam(colGlobal,       "SPCULevel",          "",                    ""))
  strSQLAgentStart  = GetParam(colStrings,            "SQLAgentStart",      "",                    "SQLSERVERAGENT starting under Windows NT service control")
  strSQLList        = "SQL2005 SQL2008 SQL2008R2 SQL2012 SQL2014 SQL2016 SQL2017 SQL2019"
  strSQLLogReinit   = GetParam(colGlobal,             "SQLLogReinit",       "",                    "The error log has been reinitialized")
  strSQLDomainGroup = GetParam(Null,                  "SQLDomainGroup",     "SQLClusterGroup",     "")
  strSQLProgDir     = GetParam(colStrings,            "SQLProgDir",         "",                    "Microsoft SQL Server")
  strSQLRecoveryComplete = GetParam(colStrings,       "SQLRecoveryComplete","",                    "Recovery is complete")
  strSQMReporting   = GetParam(colGlobal,             "SQMReporting",       "",                    "0")
  strSQLSharedMR    = GetParam(colStrings,            "SQLSharedMR",        "SQL_Shared_MR",       "YES")
  strSQLRSStart     = GetParam(colStrings,            "SQLRSStartComplete", "",                    "INFO: Total Physical memory:")
  strSQLVersionNet  = GetParam(colStrings,            "SQLVersionNet",      "",                    "")
  strSQLVersionNum  = GetParam(colStrings,            "SQLVersionNum",      "",                    "")
  strSQLVersionWMI  = GetParam(colStrings,            "SQLVersionWMI",      "",                    "")
  strSSISDB         = Ucase(GetParam(colStrings,      "SSISDB",             "",                    "SSISDB"))
  strSSISPassword   = GetParam(Null,                  "SSISPassword",       "",                    strsaPwd)
  strSSISRetention  = GetParam(colStrings,            "SSISRetention",      "",                    "30")
  strStatusAssumed  = GetParam(colStrings,            "StatusAssumed",      "",                    "Assumed")
  strStatusBypassed = " " & GetParam(colStrings,      "StatusBypassed",     "",                    "Bypassed")
  strStatusComplete = " " & GetParam(colStrings,      "StatusComplete",     "",                    "Complete")
  strStatusFail     = " " & GetParam(colStrings,      "StatusFail",         "",                    "Install Failed")
  strStatusManual   = " " & GetParam(colStrings,      "StatusManual",       "",                    "Configure Manually")
  strStatusPreConfig  = " " & GetParam(colStrings,    "StatusPreConfig",    "",                    "Already Configured")
  strStatusProgress = " " & GetParam(colStrings,      "StatusProgress",     "",                    "In Progress")
  strStopAt         = Ucase(GetParam(Null,            "StopAt",             "",                    ""))
  strStreamInsightPID = GetParam(colStrings,          "StreamInsightPID",   "",                    "")
  strTallyCount     = GetParam(colStrings,            "TallyCount",         "",                    "1000000")
  strtempdbFile     = GetParam(colGlobal,             "SqlTempdbFileSize",  "tempdbFile",          "200 MB")
  strtempdbLogFile  = GetParam(colGlobal,             "SqlTempdbLogFileSize", "",                  "50 MB")
  strTCPEnabled     = GetParam(colGlobal,             "TCPEnabled",         "",                    "1")
  strTCPPort        = GetParam(colGlobal,             "TCPPort",            "",                    "1433")
  strTCPPortAO      = GetParam(colGlobal,             "TCPPortAO",          "",                    "5022")
  strTCPPortAS      = GetParam(colGlobal,             "TCPPortAS",          "",                    "2383")
  strTCPPortDAC     = GetParam(colGlobal,             "TCPPortDAC",         "",                    "1434")
  strTCPPortDTC     = GetParam(colGlobal,             "TCPPortDTC",         "",                    "13300")
  strUCServer       = UCase(strServer)
  strUnknown        = "Unknown"
  strUpdateSource   = GetParam(Null,                  "UpdateSource",       "",                    "")
  strUseFreeSSMS    = UCase(GetParam(colGlobal,       "UseFreeSSMS",        "",                    ""))
  strUserDNSDomain  = objShell.ExpandEnvironmentStrings("%USERDNSDOMAIN%")
  strUserAdmin      = GetBuildfileValue("UserAdmin")
  strUserName       = GetBuildfileValue("AuditUser")
  strUserProfile    = objShell.ExpandEnvironmentStrings("%USERPROFILE%")
  strUserSID        = GetBuildfileValue("UserSID")
  strUserConfiguration    = Ucase(GetParam(colFlags,  "UserConfiguration",  "",                    "No"))
  strUserConfigurationvbs = GetParam(colFiles,        "UserConfigurationvbs","",                   "")
  strUserReg        = "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders\"
  strUserDTop       = objShell.RegRead(strUserReg & "Desktop")
  strUserProf       = objShell.RegRead(strUserReg & "Start Menu")
  strUserPreparation      = Ucase(GetParam(colFlags,  "UserPreparation",    "",                    "No"))
  strUserPreparationvbs   = GetParam(colFiles,        "UserPreparationvbs", "",                    "")
  strUseSysDB       = GetParam(Null,                  "UseSysDB",           "",                    "")
  strValidate       = GetParam(Null,                  "Validate",           "",                    "YES")
  strValidateError  = ""
  strVersionFB      = objShell.ExpandEnvironmentStrings("%SQLFBVERSION%")
  strVolErrorList   = ""
  strVSVersionNum   = GetParam(colStrings,            "VSVersionNum",       "",                    "")
  strVSVersionPath  = GetParam(colStrings,            "VSVersionPath",      "",                    "")
  strWaitLong       = GetParam(colStrings,            "WaitLong",           "",                    "10000")
  strWaitMed        = GetParam(colStrings,            "WaitMed",            "",                    "2000")
  strWaitShort      = GetParam(colStrings,            "WaitShort",          "",                    "500")

  Select Case True
    Case strSetupAnalytics = "N/A"
      strSetupPython  = "N/A"
      strSetupRServer = "N/A"
    Case strSetupAnalytics = "NO"
      strSetupPython  = "N/A"
      strSetupRServer = "N/A"
    Case strSetupPython = "YES"
      strSetupAnalytics = "YES"
    Case strSetupRServer = "YES"
      strSetupAnalytics = "YES"
    Case strSQLVersion >= "SQL2017"
      ' Nothing
    Case strSetupAnalytics = "YES"
      strSetupRServer = "YES"
  End Select

  Select Case True
    Case strSQLVersion >= "SQL2019"
      ' Nothing
    Case strSetupSQLDBCluster <> "YES"
      ' Nothing
    Case strSetupAnalytics <> "YES"
      ' Nothing
    Case Else
      Call SetParam("SQLSharedMR",       strSQLSharedMR,           "NO",  "Analytics must be installed as separate instance for SQL Cluster", "")
  End Select

  If strFineBuildStatus = "" Then
    strFineBuildStatus = strStatusProgress
  End If

  strPath           = "SOFTWARE\Microsoft\Windows\CurrentVersion\Component Based Servicing\PackageDetect\Microsoft-Windows-Common-Foundation-Package~31bf3856ad364e35~" & LCase(strProcArc) & "~~0.0.0.0\"
  objWMIReg.GetDwordValue strHKLM,strPath,"Package_for_KB2919355~31bf3856ad364e35~" & LCase(strProcArc) & "~~6.3.1.14",strStatusKB2919355
  Select Case True
    Case IsNull(strStatusKB2919355)
      strStatusKB2919355 = ""
    Case Else
      strStatusKB2919355 = CStr(strStatusKB2919355)
  End Select

  objWMIReg.GetStringValue strHKLM,"SYSTEM\CurrentControlSet\Services\W3SVC\","ObjectName",strIISAccount
  Select Case True
    Case IsNull(strIISAccount)
      strIISAccount = ""
  End Select

  Select Case True
    Case UCase(strDomain) = UCase(strServer)
      strADRoot     = ""
    Case Else
      Set objADRoot = GetObject("LDAP://RootDSE")
      strADRoot     = "LDAP://" & objADRoot.Get("defaultNamingContext") 
  End Select

  If Not colArgs.Exists("Edition") Then
    strEdType       = strStatusAssumed
  End If

  strRebootLoop     = GetBuildfileValue("RebootLoop") 
  If strRebootLoop = "" Then
    strRebootLoop   = "0"
  End If

  If colArgs.Exists("X86") Then
    strWOWX86       = "TRUE"
    strHKLMSQL      = "HKLM\SOFTWARE\Wow6432Node\Microsoft\Microsoft SQL Server\"
  End If

  Select Case True
    Case strProcArc = "X86"
      strFileArc     = "X86"
    Case Else
      strFileArc     = "X64"
  End Select

  Select Case True
    Case strSetupSSL = "YES"
      strHTTP       = "https"
    Case Else
      strHTTP       = "http"
  End Select

  strPath           = "SOFTWARE\Microsoft\NET Framework Setup\NDP\v3.5\"
  objWMIReg.GetStringValue strHKLM,strPath,"Version",strVersionNet3
  If IsNull(strVersionNet3) Then
    strVersionNet3  = ""
  End If

  strPath           = "SOFTWARE\Microsoft\NET Framework Setup\NDP\v4\Full\"
  objWMIReg.GetStringValue strHKLM,strPath,"Version",strVersionNet4
  If IsNull(strVersionNet4) Then
    strVersionNet4  = ""
  End If

  Select Case True
    Case (strSQLVersion = "SQL2005") And (strFileArc = "X86")
      strPathCScript  = "CSCRIPT"
      strRegasmExe    = "%COMSPEC% /D /C ""%WINDIR%\Microsoft.Net\Framework\v2.0.50727\regasm.exe"" "
    Case strSQLVersion = "SQL2005"
      strPathCScript = strDirSys & "\SysWOW64\CSCRIPT.EXE"
      strRegasmExe    = "%COMSPEC% /D /C ""%WINDIR%\Microsoft.Net\Framework\v2.0.50727\regasm.exe"" "
    Case (strFileArc = "X86") Or (strWOWX86 = "TRUE")
      strPathCScript = strDirSys & "\SysWOW64\CSCRIPT.EXE"
      strRegasmExe    = "%COMSPEC% /D /C ""%WINDIR%\Microsoft.Net\Framework\v2.0.50727\regasm.exe"" "
    Case strOSVersion >= "6.2"
      strPathCScript  = "CSCRIPT"
      strRegasmExe    = "%COMSPEC% /D /C ""%WINDIR%\Microsoft.NET\Framework64\v4.0.30319\regasm.exe"" "
    Case Else
      strPathCScript  = "CSCRIPT"
      strRegasmExe    = "%COMSPEC% /D /C ""%WINDIR%\Microsoft.Net\Framework\v2.0.50727\regasm.exe"" "
  End Select

  objWMIReg.GetStringValue strHKLM,"Cluster\","SharedVolumesRootBase",strCSVRoot
  Select Case True
    Case IsNull(strCSVRoot)
      strCSVRoot    = "Unknown"
    Case Right(strCSVRoot, 1) <> "\"
      strCSVRoot    = strCSVRoot & "\"
  End Select
  strCSVRoot        = UCase(strCSVRoot)

  Select Case True
    Case strSQLVersion <= "SQL2014"
      strReportViewerVersion = GetParam(colStrings,   "ReportViewerVersion","",                    "10.0.40219.1")
    Case Else
      strReportViewerVersion = GetParam(colStrings,   "ReportViewerVersion","",                    "12.0.2402.15")
  End Select

  If strUserDnsDomain = "%USERDNSDOMAIN%" Then
    strUserDnsDomain = ""
  End If

  Call DebugLog("Current ProcessId: " & strProcessId)

End Sub


Function GetParam(colParam, strParam, strAltParam, strDefault) 
  Call DebugLog("Get parameter value: " & strParam)
  Dim strValue

  strDebugMsg1      = "Find parameter value in XML configuration file"
  Select Case True
    Case IsNull(colParam)
      strValue      = strDefault
    Case IsNull(colParam.getAttribute(strParam))
      strValue      = strDefault
    Case Else
      strValue      = colParam.getAttribute(strParam)
  End Select

  strDebugMsg1      = "Apply any parameter overide from Alternative parameter"
  Select Case True
    Case strAltParam = ""
      ' Nothing
    Case Not colArgs.Exists(strAltParam)
      ' Nothing
    Case Else
      strValue      = colArgs.Item(strAltParam)
  End Select

  strDebugMsg1      = "Apply any parameter overide from CSCRIPT arguments"
  Select Case True
    Case Not colArgs.Exists(strParam)
      ' Nothing
    Case Else
      strValue      = colArgs.Item(strParam)
  End Select

  GetParam    = strValue

End Function


Sub Process()
  Call SetProcessId("0","Prepare FineBuild Configuration (FBConfigBuild.vbs)")

  Call SetupBuild()

  Call GetBuildfileData()

  Call SetBuildfileData()

  Call CheckUtils()

  Call FineBuild_Validate()

End Sub


Sub SetupBuild()
  Call SetProcessId("0A", "Setup FineBuild Environment")

  Call SetOSFlags()

  Call SetPrimaryFlags()

  Call LogEnvironment()

  Call CheckBootTime()

  If strClusterHost = "YES" Then
    Call ClusterConnect()
  End If

  Call SetInstanceData()

  Call SetSetupFlags()

  Call EarlyValidate()

  Call CheckRebootStatus()

  Call GetUserDNSServer()

End Sub


Sub SetOSFlags()
  Call SetProcessId("0AA", "Set flags for Windows OS")

  objWMIReg.GetStringValue strHKLM,strOSRegPath,"InstallationType",strOSType
  Select Case True
    Case strOSType > ""
      ' Nothing
    Case Instr(LCase(strOSName), "windows server") > 0
      strOSType     = "Server"
    Case Instr(LCase(strOSName), "windows xp") > 0
      strOSType     = "Client"
    Case Instr(LCase(strOSName), "windows vista") > 0
      strOSType     = "Client"
  End Select
  strOSType         = Ucase(strOSType)

  objWMIReg.GetStringValue strHKLM,strOSRegPath,"CurrentBuild",strOSBuild
  Select Case True
    Case strOSVersion <> "6.3"
      ' Nothing
    Case Instr(LCase(strOSName), "windows 10") > 0
      strOSVersion = "6.3X"
    Case Instr(LCase(strOSName), "windows server 2016") > 0
      strOSVersion = "6.3X"
    Case strOSBuild >= "17677"
      strOSVersion = "6.3Y"
  End Select

  Select Case True
    Case strOSVersion < "6.3"
      strAutoLogonCount = "1"
    Case Else
      strAutoLogonCount = "2"
  End Select

  objWMIReg.GetStringValue strHKLM,strOSRegPath,"CSDVersion",strOSLevel
  Select Case True
    Case IsNull(strOSLevel) 
      strOSLevel    = "RTM"
    Case strOSLevel = "" 
      strOSLevel    = "RTM"
  End Select

  objWMIReg.GetStringValue strHKLM,"Cluster\","ClusterName",strClusterName
  Select Case True
    Case strClusterName > "" 
      strClusterHost = "YES"
    Case Else
      strClusterHost = ""
  End Select

  Select Case True
    Case strOSType <> "CLIENT"
      strCmdPS      = "POWERSHELL "
    Case strOSVersion < "6"
      strCmdPS      = strPathSys & "WindowsPowershell\V1.0\POWERSHELL.exe "
    Case Else
      strCmdPS      = "POWERSHELL "
  End Select
  Call SetBuildfileValue("CmdPS", strCmdPS)

End Sub


Sub SetPrimaryFlags()
  Call SetProcessId("0AB", "Set Primary Install Flags")
  Dim arrNames, arrTypes

  Select Case True
    Case strType = "UPGRADE"
      strAction     = Ucase(GetParam(Null,            "Action",             "",                    "UPGRADE"))
    Case Else
      strAction     = Ucase(GetParam(Null,            "Action",             "",                    "INSTALL"))
  End Select

  Select Case True
    Case strAction = strActionClusInst
      strClusterAction  = strAction
    Case strAction = "ADDNODE"
      strClusterAction  = strAction
    Case Else
      strClusterAction = ""
  End Select

  strPath           = Mid(strHKLMSQL, 6) & "Instance Names\SQL"
  objWMIReg.EnumValues strHKLM, strPath, arrNames, arrTypes
  Select Case True
    Case strMainInstance <> ""
      ' Nothing
    Case IsNull(arrNames)
      strMainInstance = "YES"
    Case Ubound(arrNames) > 0
      strMainInstance = "NO"
    Case arrNames(0) = strInstance
      strMainInstance = "YES"
    Case Else
      strMainInstance = "NO"
  End Select

End Sub


Sub LogEnvironment()
  Call SetProcessId("0AC", "Log FineBuild Environment")

  Call SetBuildfileValue("OSName",             strOSName)
  Call SetBuildfileValue("OSLevel",            strOSLevel)
  Call SetBuildfileValue("FileArc",            strFileArc)
  Call SetBuildfileValue("Instance",           strInstance)

  Call FBLog("**************************************************")
  Call FBLog("*")
  Call FBLog("* SQL FineBuild Version         " & strVersionFB)
  Call FBLog("* Server Name                   " & strServer)
  Call FBLog("* Operating System Name         " & strOSName)
  Call FBLog("* Operating System Level        " & strOSLevel)
  Call FBLog("* Operating System Platform     " & strFileArc)
  Call FBLog("* SQL Server Version            " & strSQLVersion)
  Call FBLog("* SQL Server Instance           " & strInstance)
  Call FBLog("* SQL Server Edition            " & strEdition)
  Call FBLog("* FineBuild run on              " & CStr(Date()))
  Call FBLog("*")
  Call FBLog("**************************************************")

End Sub


Sub CheckBootTime()
  Call SetProcessId("0AD", "Check Time since Reboot")
  Dim colOS
  Dim objOS
  Dim intDelay
  Dim strAccount, strBootUpTime, strBuildfileTime, strClusService, strClusStatus

  strBuildfileTime  = GetBuildfileValue("BuildFileTime")
  Select Case True
    Case strClusterAction = "" ' If not Cluster Install then only delay long enough for services to start
      intTimer      = 30
    Case strBuildfileTime = ""
      intTimer      = 350
    Case CLng(strBuildfileTime) < 0 ' W2016 CTP sometimes loses track of time
      intTimer      = 350
    Case CLng(strBuildfileTime) > 150
      intTimer      = 350
    Case Else
      intTimer      = 200 + CLng(strBuildfileTime)
  End Select

  Set colOS         = objWMI.InstancesOf("Win32_OperatingSystem")
  For Each objOS In colOS
    strBootUpTime   = CStr(objOS.LastBootUpTime)
  Next
  strBootUpTime     = Left(strBootUpTime, Instr(strBootUpTime, ".") -1)
  strBootUpTime     = Mid(strBootUpTime, 1, 4) & "/" & Mid(strBootUpTime, 5, 2) & "/" & Mid(strBootUpTime, 7, 2) & " " & Mid(strBootUpTime, 9, 2) & ":" & Mid(strBootUpTime, 11, 2) & ":" & Mid(strBootUpTime, 13, 2)
  intDelay          = DateDiff("s", CDate(strBootUpTime), Now())

  strPath           = "SYSTEM\CurrentControlSet\Services\ClusSvc"
  objWMIReg.GetDWordValue strHKLM,strPath,"DisplayName",strClusService
  objWMIReg.GetDWordValue strHKLM,strPath,"Start",strClusStatus
  Select Case True
    Case IsNull(strClusService)
      ' Nothing
    Case strOSVersion >= "6.0"
      ' Nothing
    Case strClusStatus = 2
      ' Nothing
    Case Else
      intDelay      = 0
      objWMIReg.GetStringValue strHKLM,strPath,"ObjectName",strAccount
      strCmd        = "NET LOCALGROUP """ & Mid(strLocalAdmin, Instr(strLocalAdmin, "\") + 1) & """ """ & strDomain & Mid(strAccount, Instr(strAccount, "\")) & """ /ADD"
      Call Util_RunExec(strCmd, "", strResponseYes, -1)
      strCmd        = "NET START ClusSvc"
      Call Util_RunExec(strCmd, "", strResponseYes, -1)
  End Select

  Call DebugLog("Boot Time: " & strBootUpTime & ", Required delay: " & Cstr(intTimer) & " sec")
  If CLng(intDelay) < CLng(intTimer) Then
    intDelay        = CLng(intTimer - intDelay)
    Call DebugLog(" Waiting " & CStr(intDelay) & " seconds before proceeding") ' Wait at least 2m 30s following reboot to allow services to start
    Wscript.Sleep CStr(intDelay * 1000)
  End If

End Sub


Sub ClusterConnect()
  Call SetProcessId("0AE", "Setup Connection to Cluster")

  Select Case true
    Case GetBuildfileValue("SetupClusterCmdStatus") = strStatusComplete
      ' Nothing
    Case strOSVersion < "6.2" 
      ' Nothing
    Case Else
      Call SetupClusterCmd()
  End Select

  Call ClusterOpen()
  Call CheckClusterNodes()
  Call SetClusterData()

End Sub


Sub SetupClusterCmd()
  Call SetProcessId("0AEA", "Install legacy Cluster Command interface")

  strCmd            = strCmdPS & " -Command Install-WindowsFeature -Name RSAT-Clustering-AutomationServer"
  Call Util_RunExec(strCmd, "", "", 0)
  strCmd            = strCmdPS & " -Command Install-WindowsFeature -Name RSAT-Clustering-CmdInterface"
  Call Util_RunExec(strCmd, "", "", 0)

  Call SetBuildfileValue("SetupClusterCmdStatus", strStatusComplete)

End Sub


Sub ClusterOpen()
  Call SetProcessId("0AEB", "Open Connection to Cluster")
  On Error Resume Next

  strClusterName    = ""
  Set objCluster    = CreateObject("MSCluster.Cluster")
  objCluster.Open ""
  Select Case True
    Case err.Number = 0
      Wscript.Sleep strWaitLong
    Case Else ' Network stack must be ready when Cluster Service starts, otherwise RPC error (often 1722) given.  Restart Cluster and wait so it can become ready.
      Call Util_RunExec("NET STOP  ""Cluster Service""", "", strResponseYes, 0)
      Wscript.Sleep strWaitLong
      Call Util_RunExec("NET START ""Cluster Service""", "", strResponseYes, 0)
      Wscript.Sleep strWaitLong
      Wscript.Sleep strWaitLong
      Wscript.Sleep strWaitLong
      objCluster.Open ""
  End Select

  intErrSave        = err.Number
  Select Case True
    Case IsNull(objCluster)
      ' Nothing
    Case Else
      strClusterName = UCase(objCluster.Name)
  End Select

  On Error GoTo 0

  Select Case True
    Case strClusterName = ""
      Call SetBuildMessage(strMsgError, "Unable to connect to cluster for " & strAction & ", error " & Cstr(intErrSave))
    Case strClusWinSuffix <> ""
      strClusterBase = Left(strClusterName, Len(strClusterName) - Len(strClusWinSuffix))
    Case Else
      strClusterBase = strClusterName
  End Select
  Call DebugLog("Connected to Cluster: " & strClusterName)
  Wscript.Sleep strWaitShort

End Sub


Sub CheckClusterNodes()
  Call SetProcessId("0AEC", "Check Cluster Node details")
  Dim colClusNodes, colResources
  Dim objClusNode, objResource

' Ensure Cluster Network Name is online
  Set colResources = objCluster.Resources
  For Each objResource In colResources
    Select Case True
      Case Left(objResource.Name, 18) <> "Cluster IP Address" 
        ' Nothing
      Case Else
        strCmd      = "CLUSTER """ & strClusterName & """ RESOURCE """ & objResource.Name & """ /ON"
        Call Util_RunExec(strCmd, "", strResponseYes, -1)
        Wscript.Sleep strWaitShort
        If objResource.State <> 2 Then
          Wscript.Sleep strWaitLong
          Wscript.Sleep strWaitLong
          Wscript.Sleep strWaitLong
          Call Util_RunExec(strCmd, "", strResponseYes, -1)
          Wscript.Sleep strWaitShort
          If objResource.State <> 2 Then
            Call SetBuildMessage(strMsgError, "Cluster Resource """ & objResource.Name & """ is not operational, state: " & objResource.State)
          End If
        End If
    End Select
  Next

' Ensure Cluster Node is online
  Set colClusNodes  = objCluster.Nodes
  For Each objClusNode In colClusNodes
    Select Case True
      Case Ucase(objClusNode.Name) = UCase(strServer)
        strClusterNode = objClusNode.NodeId
        If objClusNode.State = 1 Then
          strCmd    = "CLUSTER """ & strClusterName & """ NODE """ & strClusterNode & """ /START"
          Call Util_RunExec(strCmd, "", strResponseYes, -1)
        End If
        If objClusNode.State = 2 Then
          strCmd    = "CLUSTER """ & strClusterName & """ NODE """ & strClusterNode & """ /RESUME"
          Call Util_RunExec(strCmd, "", strResponseYes, -1)
        End If
        If objClusNode.State <> 0 Then
          Call DebugLog("Cluster Node state: " & CStr(objClusNode.State))
        End If
      Case strClusterAction <> strActionClusInst
        ' Nothing
      Case objClusNode.State <> 0
        '
      Case strSQLVersion <= "SQL2005"
        Call SetBuildMessage(strMsgError, "Cluster Node """ & Ucase(objClusNode.Name) & """ must be shut down when installing first SQL node on this cluster")
    End Select
  Next

End Sub


Sub SetClusterData()
  Call SetProcessId("0AED", "Set Cluster data for SQL Instance")

  strClusSuffix      = GetClusSuffix()

  strClusterNameAS   = GetClusterName("ClusterNameAS",  strClusterBase & strClusASSuffix & strClusSuffix)
  strClusterNameIS   = strClusterBase & strClusISSuffix
  strClusterNamePE   = strClusterBase & strClusPESuffix
  strClusterNamePM   = strClusterBase & strClusPMSuffix
  strClusterNameRS   = GetClusterName("ClusterNameRS",  strClusterBase & strClusRSSuffix)
  strClusterNameSQL  = GetClusterName("ClusterNameSQL", strClusterBase & strClusDBSuffix & strClusSuffix)

  strClusterGroupAO  = GetClusterName("ClusterNameAO",  strClusterBase & strClusAOSuffix & strClusSuffix)
  strClusterGroupFS  = GetClusterName("ClusterNameFS",  strClusterBase & strClusFSSuffix)
  strClusterGroupRS  = strClusterNameRS
  strClusterGroupSQL = strClusterNameSQL & " (" & strInstance & ")"
  strClusterNetworkAS  = "SSAS Network Name (" & strInstASSQL & ")"
  strClusterNetworkSQL = "SQL Network Name (" & strInstance & ")"

  Call SetClusIPDetails("AA")
  Call SetClusIPDetails("AO")
  Call SetClusIPDetails("AS")
  Call SetClusIPDetails("DB")
  Call SetClusIPDetails("DTC")
  Call SetClusIPDetails("IS")
  Call SetClusIPDetails("RS")

End Sub


Function GetClusterName(strName, strDefault)
  Call DebugLog("GetClusterName: " & strName)

  GetClusterName    = GetParam(Null,                 strName,          "",                    "")

  If GetClusterName = "" Then
    GetClusterName  = GetBuildfileValue(strName)
  End If

  If GetClusterName = "" Then
    GetClusterName  = strDefault
  End If

End Function


Function GetClusSuffix()
  Call DebugLog("GetClusSuffix:")
  Dim colClusGroups
  Dim objClusGroup
  Dim strGroupName

  strClusSuffix     = ""
  Set colClusGroups = objCluster.ResourceGroups
  For Each objClusGroup In colClusGroups
    strGroupName    = objClusGroup.Name
    Select Case True
      Case Left(strGroupName, Len(strClusterBase & strClusDBSuffix)) = strClusterBase & strClusDBSuffix
        strClusSuffix = FindClusSuffix(strGroupName, strClusDBSuffix)
      Case Left(strGroupName, Len(strClusterBase & strClusDTCSuffix)) = strClusterBase & strClusDTCSuffix
        strClusSuffix = FindClusSuffix(strGroupName, strClusDTCSuffix)
    End Select
  Next

  For intIdx = 1 To Len(strAlphabet)
    Select Case True
      Case arrClusInstances(intIdx) > ""
        ' Nothing
      Case strClusSuffix <> ""
        ' Nothing
      Case Else
        strClusSuffix = Mid(strAlphabet, intIdx, 1)
    End Select
  Next

  GetClusSuffix     = strClusSuffix

End Function


Function FindClusSuffix(strGroupName, strGroupSuffix)
  Call DebugLog("FindClusSuffix:")
  Dim intIdx
  Dim strTempSuffix, strTempInstance

  strTempSuffix     = Mid(strGroupName, Len(strClusterBase & strGroupSuffix) + 1, 1)
  strTempInstance   = Mid(strGroupName, Len(strClusterBase & strGroupSuffix) + 4)
  intIdx            = Instr(strAlphabet, strTempSuffix)
  arrClusInstances(intIdx) = strTempInstance
  If strTempInstance = strInstance & ")" Then
    FindClusSuffix  = strTempSuffix
  End If

End Function


Sub SetClusIPDetails(strClusType)
  Call DebugLog("SetClusIPDetails: " & strClusType)
  Dim strClusIPExtra,strClusIPSuffix

  strClusIPExtra    = GetParam(Null,                  "Clus" & strClusType & "IPExtra",      "", "")
  If strClusIPExtra <> "" Then
    Call SetBuildfileValue("Clus" & strClusType & "IPExtra", strClusIPExtra)
  End If

  strClusIPSuffix   = GetParam(Null,                  "Clus" & strClusType & "IPSuffix",     "", "")
  If strClusIPSuffix <> "" Then
    Call SetBuildfileValue("Clus" & strClusType & "IPSuffix", strClusIPSuffix)
  End If

End Sub


Sub SetInstanceData()
  Call SetProcessId("0AG", "Set data for SQL Instance")

  Select Case True
    Case strtype = "CLIENT"
      ' Nothing
    Case strSQLVersion < "SQL2017"
      ' Nothing
    Case strSetupSQLRS = "YES"
      Call SetParam("SetupPowerBI",      strSetupPowerBI,          "YES", "PowerBI recommended for " & strSQLVersion, "")
    Case strSetupPowerBI = "YES"
      strSetupSQLRS = "YES"
    Case strSetupPowerBI = ""
      Call SetParam("SetupPowerBI",      strSetupPowerBI,          "YES", "PowerBI recommended for " & strSQLVersion, "")
      strSetupSQLRS = "YES"
  End Select

  Select Case True
    Case strType = "CLIENT"
      strInstNode   = "CLIENT"
      strInstLog    = ""
    Case strInstance = "MSSQLSERVER"
      strInstAgent  = "SQLSERVERAGENT"
      strInstAnal   = "MSSQLLaunchpad"
      strInstAO     = strServer & "\" & "DEFAULT"
      strInstASSQL  = strInstance
      strInstASCon  = strServer
      strInstAS	    = "MSSQLServerOLAPService"
      strInstFT	    = "MSSQLFDLauncher"
      strInstPE     = "SQLPBENGINE"
      strInstPM     = "SQLPBDMS"
      strInstSQL    = "MSSQLSERVER"
      strInstStream = "Default"
      strServInst   = strServer
      strServName   = "SQL Server (" & strInstance & ")"
      strInstNode   = "MSSQL.MSSQLSERVER"
      strInstNodeAS = "MSAS.MSSQLSERVER"
      strInstNodeIS = "MSIS.MSSQLSERVER"
      strInstLog    = ""
      strInstTel    = "SQLTELEMETRY"
    Case Else
      strInstAgent  = "SQLAgent$" & strInstance
      strInstAnal   = "MSSQLLaunchpad$" & strInstance
      strInstAO     = strServer & "\" & strInstance
      strInstASSQL  = strInstance
      strInstASCon  = strServer & "\" & strInstASSQL
      strInstAS	    = "MSOLAP$" & strInstance
      strInstPE     = "SQLPBENGINE"
      strInstPM     = "SQLPBDMS"
      strInstSQL    = "MSSQL$" & strInstance
      strInstStream = strInstance
      strServInst   = strServer & "\" & strInstance
      strServName   = "SQL Server (" & strInstance & ")"
      strInstNode   = "MSSQL." & strInstance
      strInstNodeAS = "MSAS."  & strInstance
      strInstNodeIS = "MSIS.MSSQLSERVER"
      strInstLog    = strInstance & " "
      strInstFT	    = "MSSQLFDLauncher"
      If strSQLVersion > "SQL2005" Then
        strInstFT   = "MSSQLFDLauncher$" & strInstance
      End If
      strInstTel    = "SQLTELEMETRY"
  End Select

  Select Case True
    Case strSetupISMasterCluster = "YES"
      strDNSNameIM  = strClusterBase & strClusIMSuffix
      strDNSIPIM    = ""
    Case Else
      strDNSNameIM  = strServer
      strDNSIPIM    = GetAddress(strServer, "", "")
  End Select

  Select Case True
    Case strSQLSharedMR = "YES"
      ' Nothing
    Case strInstMR <> ""
      ' Nothing
    Case strClusterHost = "YES"
      strInstMR     = strClusterBase & strClusMRSuffix
    Case Else
      strInstMR     = "MSRService"
  End Select

  Call SetupInstRS()

  strDirServInst    = Replace(strServinst, "\", "$")

End Sub


Sub SetSetupFlags()
  Call SetProcessId("0AH","Set Setup flags for install")

  Select Case True
    Case strSetupSQLDB <> ""
      ' Nothing
    Case Else
      strSetupSQLDB  = "YES"
  End Select
  Select Case True
    Case strClusterHost <> "YES"
      Call SetParam("SetupSQLDBCluster",     strSetupSQLDBCluster,     "N/A", "", strListCluster)
      Call SetParam("SetupAlwaysOn",         strSetupAlwaysOn,         "N/A", "", strListCluster)
    Case strSetupSQLDB <> "YES"
      Call SetParam("SetupSQLDBCluster",     strSetupSQLDBCluster,     "N/A", "", strListSQLDB)
    Case (strClusterAction <> "") And (strSetupSQLDBCluster = "")
      strSetupSQLDBCluster = "YES"
    Case strSetupSQLDBCluster = ""
      strSetupSQLDBCluster = "NO"
  End Select
  Select Case True
    Case strSetupSQLDBCluster <> "YES"
      strServerAO    = strServer
    Case strInstance = "MSSQLSERVER"
      strInstAO      = strClusterNameSQL & "\" & "DEFAULT"
      strResSuffixDB = ""
      strServInst    = strClusterNameSQL
      strServerAO    = strClusterNameSQL
    Case Else
      strInstAO      = strClusterNameSQL & "\" & strInstance
      strResSuffixDB = " (" & strInstance & ")"
      strServInst    = strClusterNameSQL & "\" & strInstance
      strServerAO    = strClusterNameSQL
  End Select
  strActionSQLDB    = GetItemAction(strType, strAction, "SQLDB", strSetupSQLDBCluster)

  strActionAO       = GetItemAction(strType, strAction, "AO",    strClusterHost)

  Select Case True
    Case strSetupSQLAS <> ""
      ' Nothing
    Case strMainInstance = "YES"
      strSetupSQLAS = "YES"
    Case strSetupSQLASCluster = "YES"
      strSetupSQLAS = "YES"
    Case Else   
      Call SetParam("SetupSQLAS",            strSetupSQLAS,            "NO",  "SSAS not installed by default with secondary SQL Instances on server", "")
  End Select
  Select Case True
    Case strClusterHost <> "YES"
      Call SetParam("SetupSQLASCluster",     strSetupSQLASCluster,     "N/A", "", strListCluster)
    Case strSetupSQLAS <> "YES"
      Call SetParam("SetupSQLASCluster",     strSetupSQLASCluster,     "N/A", "", strListSQLAS)
    Case (strClusterAction <> "") And (strSetupSQLASCluster = "")
      strSetupSQLASCluster = "YES"
    Case strSetupSQLASCluster = ""
      strSetupSQLASCluster = "NO"
  End Select
  Select Case True
    Case strSetupSQLASCluster <> "YES"
      ' Nothing
    Case strInstance <> "MSSQLSERVER"
      strClusterGroupAS = strClusterNameAS & " (" & strInstASSQL & ")"
      strInstASCon      = strClusterNameAS & "\" & strInstASSQL
      strResSuffixAS    = " (" & strInstance & ")"
    Case Else
      strInstASSQL      = strClusterNameAS
      strInstASCon      = strClusterNameAS
      strInstAS	        = "MSOLAP$" & strClusterNameAS
      strInstNodeAS     = "MSAS."  & strClusterNameAS
      strClusterGroupAS = strClusterNameAS & " (" & strInstASSQL & ")"
      strResSuffixAS    = " (" & strClusterNameAS & ")"
  End Select
  strActionSQLAS    = GetItemAction(strType, strAction, "SQLAS", strSetupSQLASCluster)

  Select Case True
    Case strSetupSQLIS <> ""
      ' Nothing
    Case strMainInstance = "YES"
      strSetupSQLIS = "YES"
    Case Else
      Call SetParam("SetupSQLIS",            strSetupSQLIS,            "NO",  "SSIS not required for secondary SQL Instances on server", "")
  End Select
  Select Case True
    Case strClusterHost <> "YES"
      Call SetParam("SetupSSISCluster",      strSetupSSISCluster,      "N/A", "", strListCluster)
    Case strSetupSQLDBCluster <> "YES"
      Call SetParam("SetupSSISCluster",      strSetupSSISCluster,      "N/A", "", strListCluster)
    Case strSetupSQLIS <> "YES"
      Call SetParam("SetupSSISCluster",      strSetupSSISCluster,      "N/A", "", strListCluster)
    Case strSetupAPCluster = "YES"
      Call SetParam("SetupSSISCluster",      strSetupSSISCluster,      "YES", "SSIS Cluster mandatory for /SetupAPCluster value: " & strSetupAPCluster, "")
    Case strSetupSSISCluster = ""
      strSetupSSISCluster = "NO"
  End Select
  strActionSQLIS    = GetItemAction(strType, strAction, "SQLIS", "NO")

  Select Case True
    Case Instr(strOSType, "CORE") > 0
      Call SetParam("SetupSQLRS",            strSetupSQLRS,            "N/A", "", strListCore)
    Case strSetupSQLRS <> ""
      ' Nothing
    Case strMainInstance = "YES"
      strSetupSQLRS = "YES"
    Case strSetupSQLRSCluster = "YES"
      strSetupSQLRS = "YES"
    Case Else
      Call SetParam("SetupSQLRS",            strSetupSQLRS,            "NO",  "SSRS not installed by default with secondary SQL Instances on server", "")
  End Select
  Select Case True
    Case strClusterHost <> "YES"
      Call SetParam("SetupSQLRSCluster",     strSetupSQLRSCluster,     "N/A", "", strListCluster)
    Case strSetupSQLRS <> "YES"
      Call SetParam("SetupSQLRSCluster",     strSetupSQLRSCluster,     "N/A", "", strListSQLRS)
    Case (strClusterAction <> "") And (strSetupSQLRSCluster = "")
      strSetupSQLRSCluster = "YES"
    Case strSetupSQLRSCluster = ""
      strSetupSQLRSCluster = "NO"
  End Select
  Call SetupInstRS()
  strActionSQLRS    = GetItemAction(strType, strAction, "SQLRS", strSetupSQLRSCluster)

  Select Case True
    Case strClusterHost <> "YES"
      Call SetParam("SetupDTCCluster",       strSetupDTCCluster,       "N/A", "", strListCluster)
    Case strSetupDTCCluster <> ""
      ' Nothing
    Case strSetupSQLDBCluster = "YES"
      strSetupDTCCluster = "YES"
    Case Else
      strSetupDTCCluster = "NO"
  End Select
  strActionDTC      = GetItemAction(strType, strAction, "DTC", strSetupDTCCluster)
  If strClusterDTCFound = "" Then
    strDTCClusterRes = ""
  End If
  Select Case True
    Case strOSVersion < "6.0"
      Call SetParam("DTCMultiInstance",      strDTCMultiInstance,      "N/A", "", strListOSVersion)
    Case strDTCMultiInstance <> "YES"
      ' Nothing
    Case Else
      strLabDTC      = strLabDTC & strClusSuffix
  End Select

  strActionSQLTools = GetItemAction(strType, strAction, "SQLTools", "NO")

End Sub


Function GetItemAction(strType, strAction, strItem, strItemCluster)
  Call DebugLog("GetItemAction:" & strItem)

  Select Case True
    Case strItemCluster = "YES"
      GetItemAction = GetItemActionCluster(strItem, strAction)
    Case strType = "UPGRADE"
      GetItemAction = "UPGRADE"
    Case Else
      GetItemAction = "INSTALL"
 End Select
 Call DebugLog(" Action: " & GetItemAction)

End Function


Function GetItemActionCluster(strItem, strAction)
  Call DebugLog("GetItemActionCluster:" & strItem)
  Dim colResources
  Dim objResource
  Dim strCurrentAction, strItemAction

  strCurrentAction  = GetBuildfileValue("Action" & strItem)
  strItemAction     = strActionClusInst
  Set colResources  = objCluster.Resources
  For Each objResource In colResources
    Select Case True
      Case (strItem = "DTC") And (objResource.TypeName = "Distributed Transaction Coordinator")
        Select Case True
          Case strCurrentAction <> ""
            strItemAction      = strCurrentAction
            strClusterDTCFound = "Y"
          Case Else
            strItemAction      = "ADDNODE"
            strClusterDTCFound = "Y"
        End Select
        Call SetResourceOnline(objResource, strItemAction, strClusterGroupDTC)
      Case (strItem = "SQLDB") And (objResource.Name = "SQL Server")
        Select Case True
          Case objResource.PrivateProperties("InstanceName") <> strInstance
            Exit For
          Case strCurrentAction <> ""
            strItemAction      = strCurrentAction
            strClusterSQLFound = "Y"
          Case Else
            strItemAction      = "ADDNODE"
            strClusterSQLFound = "Y"
        End Select
        Call SetResourceOnline(objResource, strItemAction, strClusterGroupSQL)
      Case (strItem = "SQLAS") And (objResource.Name = "Analysis Services" & strResSuffixAS)
        Select Case True
          Case objResource.PrivateProperties("ServiceName") <> strInstAS
            Exit For
          Case strCurrentAction <> ""
            strItemAction = strCurrentAction
            Server = "Y"
          Case Else
            strItemAction = "ADDNODE"
            Server = "Y"
        End Select
        Call SetResourceOnline(objResource, strItemAction, strClusterGroupAS)
      Case (strItem = "SQLRS") And (objResource.Name = "Reporting Services")
        Select Case True
          Case objResource.PrivateProperties("ServiceName") <> strInstRS
            Exit For
          Case strCurrentAction <> ""
            strItemAction = strCurrentAction
          Case Else
            strItemAction = "ADDNODE"
        End Select
        Call SetResourceOnline(objResource, strItemAction, strClusterGroupRS)
      Case (strItem = "AO") And (objResource.TypeName = "SQL Server Availability Group") And (objResource.Name = strClusterGroupAO)
        Select Case True
          Case strCurrentAction <> ""
            strItemAction = strCurrentAction
          Case Else
            strItemAction = "ADDNODE"
        End Select
    End Select
  Next
 
  strClusterAction     = strItemAction
  GetItemActionCluster = strItemAction

End Function


Sub SetResourceOnline(objResource, strItemAction, strItemGroup)
  Call DebugLog("SetResourceOnline: " & objResource.Name)

  Select Case True
    Case objResource.State = 0 ' Resource Inherited
      ' Nothing
    Case objResource.State = 2 ' Resource Operational
      ' Nothing
    Case strItemAction = "ADDNODE"
      strCmd        = "CLUSTER """ & strClusterName & """ RESOURCE """ & objResource.Name & """ /ON"
      Call Util_RunExec(strCmd, "", strResponseYes, -1)
    Case Else
      strCmd        = "CLUSTER """ & strClusterName & """ GROUP """ & strItemGroup & """ /MOVETO:""" & strServer & """" 
      Call Util_RunExec(strCmd, "", strResponseYes, -1)
      strCmd        = "CLUSTER """ & strClusterName & """ RESOURCE """ & objResource.Name & """ /ON"
      Call Util_RunExec(strCmd, "", strResponseYes, -1)
  End Select

End Sub


Sub EarlyValidate()
  Call SetProcessId("0AI","Perform high-priority validation")
  Dim objExec

  Select Case True
    Case strServParm = ""
      ' Nothing
    Case strServParm = UCase(strServer)
      ' Nothing
    Case Else
      Call SetBuildMessage(strMsgError, "Requested server " & strServParm & " does not match actual server")
  End Select

  Select Case True
    Case strUserAdmin = "YES"
      ' Nothing
    Case Else
      Call SetBuildMessage(strMsgError, "SQL FineBuild must be run using Administrator priviliges")
  End Select

  Select Case True
    Case Instr(strTypeList, strType) > 0 
      ' Nothing
    Case Else
      Call SetBuildMessage(strMsgError, "Unknown /Type:" & strType)
  End Select

  If strClusterHost <> "" Then
    Call CheckClusterResources()
  End If

End Sub


Sub CheckClusterResources()
  Call SetProcessId("0AIA", "Check state of cluster resources")
  Dim colResources
  Dim objResource

  Select Case True
    Case strOSVersion < "6.2"
      strClusStorage = GetParam(colStrings,            "ClusStorage",        "",                    "Available Storage")
    Case Else
      objWMIReg.GetStringValue strHKLM,"Cluster\","AvailableStorage",strPath
      objWMIReg.GetStringValue strHKLM,"Cluster\Groups\" & strPath & "\","Name",strClusStorage
  End Select

  If strProcessId < "2C" Then
    strCmd          = "CLUSTER """ & strClusterName & """ GROUP """ & strClusStorage & """ /MOVETO:""" & strServer & """" 
    Call Util_RunExec(strCmd, "", strResponseYes, -1)
    If intErrSave <> 0 Then
      Wscript.Sleep strWaitLong
      Wscript.Sleep strWaitLong
      Wscript.Sleep strWaitLong
      Call Util_RunExec(strCmd, "", strResponseYes, 0)
    End If
  End If

  Set colResources  = objCluster.Resources
  For Each objResource In colResources
    Select Case True
      Case objResource.State = 0 ' Resource Inherited
        ' Nothing
      Case objResource.State = 2 ' Resource Operational
        ' Nothing
      Case Else
        strCmd      = "CLUSTER """ & strClusterName & """ RESOURCE """ & objResource.Name & """ /ON"
        Call Util_RunExec(strCmd, "", strResponseYes, -1)
    End Select
  Next

' Cluster Services sometimes slow to get going, so repeat check and give error is not Online
  Wscript.Sleep strWaitShort
  For Each objResource In colResources
    Select Case True
      Case objResource.State = 0 ' Resource Inherited
        ' Nothing
      Case objResource.State = 2 ' Resource Operational
        ' Nothing
      Case Else
        Wscript.Sleep strWaitLong
        strCmd      = "CLUSTER """ & strClusterName & """ RESOURCE """ & objResource.Name & """ /ON"
        Call Util_RunExec(strCmd, "", strResponseYes, -1)
        Wscript.Sleep strWaitShort
        If objResource.State <> 2 Then
          Call SetBuildMessage(strMsgError, "Cluster Resource """ & objResource.Name & """ is not operational, state: " & objResource.State)
        End If
    End Select
  Next

End Sub


Sub CheckRebootStatus()
  Call SetProcessId("0AJ", "Check if Reboot is required")
  Dim arrOperations
  Dim objKey
  Dim strPathReg

  strRebootStatus   = GetBuildfileValue("RebootStatus")
  Select Case True
    Case strRebootStatus = ""
      strRebootStatus = "N/A"
    Case strRebootStatus = "Done"
      strRebootStatus = "N/A"
      If strAdminPassword <> "" Then
        strPath     = "HKLM\" & strOSRegPath & "Winlogon\AutoAdminLogon"
        Call Util_RegWrite(strPath, "0", "REG_SZ")
        strPath     = strOSRegPath & "Winlogon"
        objWMIReg.DeleteValue strHKLM, strPath, "DefaultPassword"
      End If
  End Select

  Select Case True
    Case (strType = "FIX") And (strProcessId > "3")
      ' Nothing
    Case strProcessId > "1"
      ' Nothing
    Case CheckReboot() = "Pending" 
      Call DebugLog("Reboot is pending")
  End Select

End Sub


Sub GetUserDNSServer()
  Call SetProcessId("0AK","Get User DNS Server Name")
' Code based on sample published by Christian Dunn http://www.chrisdunn.name/jm/software/scriptsandcode/227-retrieve-dns-records
  On Error Resume Next
  Dim colAdapters
  Dim objAdapter

  strUserDNSServer  = ""
  Set colAdapters   = objWMI.ExecQuery ("SELECT * from Win32_NetworkAdapterConfiguration WHERE IPEnabled = True AND DNSDomain = '" & strUserDNSDomain & "'")
  For Each objAdapter In colAdapters
    Select Case True
      Case IsNull(objAdapter.DNSServerSearchOrder)
        ' Nothing
      Case IsNull(objAdapter.DNSServerSearchOrder(0))
        ' Nothing
      Case objAdapter.DNSServerSearchOrder(0) = ""
        ' Nothing
      Case objAdapter.DNSServerSearchOrder(0) = "0.0.0.0"
        ' Nothing
      Case Else
        For intIdx = 0 To UBound(objAdapter.DNSServerSearchOrder(0))
          strUserDNSServer = objAdapter.DNSServerSearchOrder(intIdx)
          strDebugMsg1    = "DNS Server: " & strUserDNSServer
          Set objWMIDNS   = GetObject("winmgmts:{impersonationLevel=impersonate}!\\" & strUserDNSServer & "\root\MicrosoftDNS")
          If IsObject(objWMIDNS) Then
            Exit For
          End If
        Next
        Exit For
    End Select
  Next

  On Error GoTo 0
  If Not IsObject(objWMIDNS) Then
    strUserDNSServer = ""
  End If

End Sub


Sub GetBuildfileData()

  Call SetProcessId("0B", "Get data needed for Buildfile")

  Call GetLanguageData()

  Call GetSQLPath()

  Call GetEditionData()

  Call GetAccountData()

  Call GetDBAGroups()

  Call GetVolumeData()

  If strClusterHost = "YES" Then
    Call GetClusterData()
  End If

  Select Case True
    Case strPID <> ""
      ' Nothing
    Case strSQLVersion <= "SQL2005"
      ' Nothing
    Case strEdition = "EXPRESS"
      ' Nothing
    Case Else
      Call GetPIDData()
  End Select

  Call GetMenuData()

  Call GetPathData()

  Call GetServerData()

  Call GetFileData()

  Call GetSetupData()

  Call GetMiscData()

End Sub


Sub GetLanguageData()
  Call SetProcessId("0BA", "Get data for OS and SQL Languages")

  strOSLanguage     = strLanguage

  Select Case True
    Case colArgs.Exists("ENU")
      strEnu         = "YES"
      strSQLLanguage = "ENU"
    Case Else
      strEnu         = "NO"
      strSQLLanguage = strLanguage
  End Select  

End Sub


Sub GetSQLPath()
  Call SetProcessId("0BB", "Get SQL Media paths")
  Dim strPathSQL
 
  strPathSQL        =  GetSQLMediaPath(strSQLVersion, strPathSQLMediaOrig)
  Select Case True
    Case strPathSQL = strPathSQLDefault
      strPathSQLMediaOrig = strPathSQL
    Case strPathSQLMediaOrig <> strPathSQL
      strPathSQLMediaOrig = ""
  End Select
  strPathSQLMedia   = GetMediaPath(strPathSQL)

  strPathSQLSPOrig  = GetParam(colStrings,         "PathSQLSP",          "",                    "..\Service Packs")
  Select Case True
    Case GetMediaPath(strPathSQLSPOrig) <> ""
      ' Nothing
    Case GetMediaPath(Replace(strPathSQLSPOrig, " ", "")) <> ""
      strPathSQLSPOrig = Replace(strPathSQLSPOrig, " ", "")
  End Select

End Sub


Function GetSQLMediaPath(strSQLVersion, strPathSQLMediaOrig)
  Call DebugLog("GetSQLMediaPath: " & strSQLVersion)
  Dim strPathSQL, strSuffix

  Select Case True
    Case strEdition = "BUSINESS INTELLIGENCE"
      strSuffix     = "_BI"
    Case strEdition = "DATA CENTER"
      strSuffix     = "_DC"
    Case strEdition = "DEVELOPER"
      strSuffix     = "_Dev"
    Case strEdition = "EXPRESS"
      strSuffix     = "_Exp"
    Case strEdition = "ENTERPRISE"
      strSuffix     = "_Ent"
    Case strEdition = "ENTERPRISE EVALUATION"
      strSuffix     = "_Eval"
    Case strEdition = "STANDARD"
      strSuffix     = "_Std"
    Case strEdition = "WEB"
      strSuffix     = "_Web"
    Case strEdition = "WORKGROUP"
      strSuffix     = "_Wkg"
    Case Else
      strSuffix     = ""
  End Select

  If Instr(strOSType, "CORE") > 0 Then
    strPathSQL      =  GetPathSQL(strSQLVersion, strSuffix & "_Core", strPathSQLMediaOrig)
  End If
  If strPathSQL = "" Then
    strPathSQL      =  GetPathSQL(strSQLVersion, strSuffix, strPathSQLMediaOrig)
  End If

  GetSQLMediaPath   = strPathSQL

End Function


Function GetPathSQL(strSQLVersion, strSuffix, strPathSQLMediaOrig)
  Call DebugLog("GetSQLPath: " & strSuffix)
  Dim strPathSQL

  Select Case True
    Case (strPathSQLMediaOrig <> strPathSQLDefault) And (strPathSQLMediaOrig <> "")
      strPathSQL    = strPathSQLMediaOrig
    Case strSuffix = ""
      strPathSQL    = strPathDefault
    Case GetMediaPath("..\" & strSQLVersion & strSuffix & "_" & strFileArc & "_" & strLanguage) <> ""
      strPathSQL    = "..\" & strSQLVersion & strSuffix & "_" & strFileArc & "_" & strLanguage
    Case GetMediaPath("..\" & strSQLVersion & strSuffix & "_" & strFileArc) <> ""
      strPathSQL    = "..\" & strSQLVersion & strSuffix & "_" & strFileArc
    Case GetMediaPath("..\" & strSQLVersion & strSuffix & "_" & strLanguage) <> ""
      strPathSQL    = "..\" & strSQLVersion & strSuffix & "_" & strLanguage
    Case GetMediaPath("..\" & strSQLVersion & strSuffix) <> ""
      strPathSQL    = "..\" & strSQLVersion & strSuffix
    Case Instr(strSuffix, "Core") > 0
      strPathSQL    = ""
    Case Else
      strPathSQL    = strPathSQLDefault
  End Select

  GetPathSQL        = strPathSQL

End Function


Sub GetEditionData()
  Call SetProcessId("0BC", "Setup Install flags depending on Edition")

  Select Case True                   
    Case Instr(strOSType, "CORE") > 0
      Call SetParam("SetupSQLTools",      strSetupSQLTools,      "N/A", "", strListCore)
  End Select

  Select Case True
    Case Instr("DATA CENTER ENTERPRISE EVALUATION DEVELOPER", strEdition) > 0
      strEditionEnt  = "YES"
  End Select

  Select Case True
    Case strEdition = "EXPRESS"
      Call GetExpressEditionData
    Case strSQLVersion = "SQL2005"
      strSQLExe     = GetParam(colFiles,    "SQLFullExe",         "",                    "Servers\SETUP.EXE")
    Case Else
      strSQLExe     = GetParam(colFiles,    "SQLFullExe",         "",                    "SETUP.EXE")
  End Select

  Select Case True
    Case strSQLVersion < "SQL2008" 
      Call SetParam("SetupPowerBI",          strSetupPowerBI,          "N/A", "", strListSQLVersion)
      Call SetParam("SetupPowerBIDesktop",   strSetupPowerBIDesktop,   "N/A", "", strListSQLVersion)
    Case strSQLVersion < "SQL2016"
      Call SetParam("SetupAnalytics",        strSetupAnalytics,        "N/A", "", strListSQLVersion)
      Call SetParam("SetupRServer",          strSetupRServer,          "N/A", "", strListSQLVersion)
      Call SetParam("SetupPolyBase",         strSetupPolyBase,         "N/A", "", strListSQLVersion)
      Call SetParam("SetupPolyBaseCluster",  strSetupPolyBaseCluster,  "N/A", "", strListSQLVersion)
    Case strSQLVersion < "SQL2017"
      Call SetParam("SetupISMaster",         strSetupISMaster,         "N/A", "", strListSQLVersion)
      Call SetParam("SetupISWorker",         strSetupISWorker,         "N/A", "", strListSQLVersion)
      Call SetParam("SetupISMasterCluster",  strSetupISMasterCluster,  "N/A", "", strListSQLVersion)
      Call SetParam("SetupPython",           strSetupPython,           "N/A", "", strListSQLVersion)
  End Select

  Select Case True
    Case strtype = "CLIENT"
      Call SetParam("SetupSQLTools",         strSetupSQLTools,         "YES", "SQL Tools mandatory for CLIENT build", "")
      Call SetParam("SetupAnalytics",        strSetupAnalytics,        "N/A", "", strListType)
      Call SetParam("SetupAPCluster",        strSetupAPCluster,        "N/A", "", strListType)
      Call SetParam("SetupBPE",              strSetupBPE,              "N/A", "", strListType)
      Call SetParam("SetupDBMail",           strSetupDBMail,           "N/A", "", strListType)
      Call SetParam("SetupDBAManagement",    strSetupDBAManagement,    "N/A", "", strListType)
      Call SetParam("SetupDBOpts",           strSetupDBOpts,           "N/A", "", strListType)
      Call SetParam("SetupDCom",             strSetupDCom,             "N/A", "", strListType)
      Call SetParam("SetupDisableSA",        strSetupDisableSA,        "N/A", "", strListType)
      Call SetParam("SetupDQ",               strSetupDQ,               "N/A", "", strListType)
      Call SetParam("SetupDTCCluster",       strSetupDTCCluster,       "N/A", "", strListType)
      Call SetParam("SetupGenMaint",         strSetupGenMaint,         "N/A", "", strListType)
      Call SetParam("SetupGovernor",         strSetupGovernor,         "N/A", "", strListType)
      Call SetParam("SetupISMaster",         strSetupISMaster,         "N/A", "", strListType)
      Call SetParam("SetupISMasterCluster",  strSetupISMasterCluster,  "N/A", "", strListType)
      Call SetParam("SetupISWorker",         strSetupISWorker,         "N/A", "", strListType)
      Call SetParam("SetupManagementDW",     strSetupManagementDW,     "N/A", "", strListType)
      Call SetParam("SetupMDS",              strSetupMDS,              "N/A", "", strListType)
      Call SetParam("SetupNetwork",          strSetupNetwork,          "N/A", "", strListType)
      Call SetParam("SetupNonSAAccounts",    strSetupNonSAAccounts,    "N/A", "", strListType)
      Call SetParam("SetupOldAccounts",      strSetupOldAccounts,      "N/A", "", strListType)
      Call SetParam("SetupParam",            strSetupParam,            "N/A", "", strListType)
      Call SetParam("SetupPBM",              strSetupPBM,              "N/A", "", strListType)
      Call SetParam("SetupPolyBase",         strSetupPolyBase,         "N/A", "", strListType)
      Call SetParam("SetupPolyBaseCluster",  strSetupPolyBaseCluster,  "N/A", "", strListType)
      Call SetParam("SetupPowerBI",          strSetupPowerBI,          "N/A", "", strListType)
      Call SetParam("SetupRSAdmin",          strSetupRSAdmin,          "N/A", "", strListType)
      Call SetParam("SetupRSAlias",          strSetupRSAlias,          "N/A", "", strListType)
      Call SetParam("SetupRSExec",           strSetupRSExec,           "N/A", "", strListType)
      Call SetParam("SetupRSIndexes",        strSetupRSIndexes,        "N/A", "", strListType)
      Call SetParam("SetupRSKeepAlive",      strSetupRSKeepAlive,      "N/A", "", strListType)
      Call SetParam("SetupSAAccounts",       strSetupSAAccounts,       "N/A", "", strListType)
      Call SetParam("SetupServices",         strSetupServices,         "N/A", "", strListType)
      Call SetParam("SetupServiceRights",    strSetupServiceRights,    "N/A", "", strListType)
      Call SetParam("SetupSPN",              strSetupSPN,              "N/A", "", strListType)
      Call SetParam("SetupSQLAS",            strSetupSQLAS,            "N/A", "", strListType)
      Call SetParam("SetupSQLASCluster",     strSetupSQLASCluster,     "N/A", "", strListType)
      Call SetParam("SetupSQLDB",            strSetupSQLDB,            "N/A", "", strListType)
      Call SetParam("SetupSQLDBAG",          strSetupSQLDBAG,          "N/A", "", strListType)
      Call SetParam("SetupSQLDBCluster",     strSetupSQLDBCluster,     "N/A", "", strListType)
      Call SetParam("SetupSQLDBRepl",        strSetupSQLDBRepl,        "N/A", "", strListType)
      Call SetParam("SetupSQLDBFS",          strSetupSQLDBFS,          "N/A", "", strListType)
      Call SetParam("SetupSQLDBFT",          strSetupSQLDBFT,          "N/A", "", strListType)
      Call SetParam("SetupSQLIS",            strSetupSQLIS,            "N/A", "", strListType)
      Call SetParam("SetupSQLRS",            strSetupSQLRS,            "N/A", "", strListType)
      Call SetParam("SetupSQLRSCluster",     strSetupSQLRSCluster,     "N/A", "", strListType)
      Call SetParam("SetupSQLMail",          strSetupSQLMail,          "N/A", "", strListType)
      Call SetParam("SetupSSISDB",           strSetupSSISDB,           "N/A", "", strListType)
      Call SetParam("SetupStdAccounts",      strSetupStdAccounts,      "N/A", "", strListType)
      Call SetParam("SetupSysDB",            strSetupSysDB,            "N/A", "", strListType)
      Call SetParam("SetupSysIndex",         strSetupSysIndex,         "N/A", "", strListType)
      Call SetParam("SetupSysManagement",    strSetupSysManagement,    "N/A", "", strListType)
    Case strEdition = "STANDARD"
      Call SetParam("SetupDQ",               strSetupDQ,               "N/A", "", strListEdition)
      Call SetParam("SetupDQC",              strSetupDQC,              "N/A", "", strListEdition)
      Call SetParam("SetupGovernor",         strSetupGovernor,         "N/A", "", strListEdition)
      Call SetParam("SetupMDS",              strSetupMDS,              "N/A", "", strListEdition)
      If (strSQLVersion = "SQL2016") And (strSPLevel < "SP1") Then
        Call SetParam("SetupAnalytics",      strSetupAnalytics,        "N/A", "", strListEdition)
        Call SetParam("SetupRServer",        strSetupRServer,          "N/A", "", strListEdition)
        Call SetParam("SetupPolyBase",       strSetupPolyBase,         "N/A", "", strListEdition)
        Call SetParam("SetupPolyBaseCluster",  strSetupPolyBaseCluster,"N/A", "", strListEdition)
      End If
    Case strEdition = "WEB"
      Call SetParam("SetupAPCluster",        strSetupAPCluster,        "N/A", "", strListEdition)
      Call SetParam("SetupDQ",               strSetupDQ,               "N/A", "", strListEdition)
      Call SetParam("SetupDQC",              strSetupDQC,              "N/A", "", strListEdition)
      Call SetParam("SetupGovernor",         strSetupGovernor,         "N/A", "", strListEdition)
      Call SetParam("SetupMDS",              strSetupMDS,              "N/A", "", strListEdition)
      Call SetParam("SetupDRUCtlr",          strSetupDRUCtlr,          "N/A", "", strListEdition)
      Call SetParam("SetupSQLAS",            strSetupSQLAS,            "N/A", "", strListEdition)
      Call SetParam("SetupSQLASCluster",     strSetupSQLASCluster,     "N/A", "", strListEdition)
      Call SetParam("SetupSQLIS",            strSetupSQLIS,            "N/A", "", strListEdition)
      Call SetParam("SetupSQLNS",            strSetupSQLNS,            "N/A", "", strListEdition)
      Call SetParam("SetupStreamInsight",    strSetupStreamInsight,    "N/A", "", strListEdition)
      If (strSQLVersion = "SQL2016") And (strSPLevel < "SP1") Then
        Call SetParam("SetupAnalytics",      strSetupAnalytics,        "N/A", "", strListEdition)
        Call SetParam("SetupRServer",        strSetupRServer,          "N/A", "", strListEdition)
        Call SetParam("SetupPolyBase",       strSetupPolyBase,         "N/A", "", strListEdition)
      End If
      Call SetParam("SetupISMasterCluster",  strSetupISMasterCluster,  "N/A", "", strListEdition)
      Call SetParam("SetupPolyBaseCluster",  strSetupPolyBaseCluster,  "N/A", "", strListEdition)
    Case strEdition = "WORKGROUP"
      Call SetParam("SetupAPCluster",        strSetupAPCluster,        "N/A", "", strListEdition)
      Call SetParam("SetupDQ",               strSetupDQ,               "N/A", "", strListEdition)
      Call SetParam("SetupDQC",              strSetupDQC,              "N/A", "", strListEdition)
      Call SetParam("SetupGovernor",         strSetupGovernor,         "N/A", "", strListEdition)
      Call SetParam("SetupMDS",              strSetupMDS,              "N/A", "", strListEdition)
      Call SetParam("SetupDRUCtlr",          strSetupDRUCtlr,          "N/A", "", strListEdition)
      Call SetParam("SetupSQLAS",            strSetupSQLAS,            "N/A", "", strListEdition)
      Call SetParam("SetupSQLASCluster",     strSetupSQLASCluster,     "N/A", "", strListEdition)
      Call SetParam("SetupSQLDBCluster",     strSetupSQLDBCluster,     "N/A", "", strListEdition)
      Call SetParam("SetupSQLIS",            strSetupSQLIS,            "N/A", "", strListEdition)
      Call SetParam("SetupSQLNS",            strSetupSQLNS,            "N/A", "", strListEdition)
      Call SetParam("SetupSQLRSCluster",     strSetupSQLRSCluster,     "N/A", "", strListEdition)
      Call SetParam("SetupStreamInsight",    strSetupStreamInsight,    "N/A", "", strListEdition)
      Call SetParam("SetupStretch",          strSetupStretch,          "N/A", "", strListEdition)
      If (strSQLVersion = "SQL2016") And (strSPLevel < "SP1") Then
        Call SetParam("SetupAnalytics",      strSetupAnalytics,        "N/A", "", strListEdition)
        Call SetParam("SetupRServer",        strSetupRServer,          "N/A", "", strListEdition)
        Call SetParam("SetupPolyBase",       strSetupPolyBase,         "N/A", "", strListEdition)
      End If
      Call SetParam("SetupISMasterCluster",  strSetupISMasterCluster,  "N/A", "", strListEdition)
      Call SetParam("SetupPolyBaseCluster",  strSetupPolyBaseCluster,  "N/A", "", strListEdition)
  End Select

End Sub


Sub GetExpressEditionData
  Call SetProcessId("0BCA", "Setup details for SQL Express Edition")

  Call GetExpressExe

  Call SetParam("SetupAPCluster",            strSetupAPCluster,        "N/A", "", strListEdition)
  Call SetParam("SetupNoDriveIndex",         strSetupNoDriveIndex,     "N/A", "", strListEdition)
  Call SetParam("SetupSQLAgent",             strSetupSQLAgent,         "N/A", "", strListEdition)
  Call SetParam("SetupSQLAS",                strSetupSQLAS,            "N/A", "", strListEdition)
  Call SetParam("SetupSQLDBAG",              strSetupSQLDBAG,          "N/A", "", strListEdition)
  Call SetParam("SetupSQLIS",                strSetupSQLIS,            "N/A", "", strListEdition)
  Call SetParam("SetupSQLNS",                strSetupSQLNS,            "N/A", "", strListEdition)
  Call SetParam("SetupDistributor",          strSetupDistributor,      "N/A", "", strListEdition)
  Call SetParam("SetupDQ",                   strSetupDQ,               "N/A", "", strListEdition)
  Call SetParam("SetupDQC",                  strSetupDQC,              "N/A", "", strListEdition)
  Call SetParam("SetupGovernor",             strSetupGovernor,         "N/A", "", strListEdition)
  Call SetParam("SetupMDS",                  strSetupMDS,              "N/A", "", strListEdition)
  Call SetParam("SetupDRUCtlr",              strSetupDRUCtlr,          "N/A", "", strListEdition)
  Call SetParam("SetupDRUClt",               strSetupDRUClt,           "N/A", "", strListEdition)
  Call SetParam("SetupManagementDW",         strSetupManagementDW,     "N/A", "", strListEdition)
  Call SetParam("SetupSlipstream",           strSetupSlipstream,       "N/A", "", strListEdition)
  Call SetParam("SetupSSDTBI",               strSetupSSDTBI,           "N/A", "", strListEdition)
  Call SetParam("SetupStreamInsight",        strSetupStreamInsight,    "N/A", "", strListEdition)

  Select Case True
    Case strSQLVersion <= "SQL2005"
      Call SetParam("SetupSQLBC",            strSetupSQLBC,            "N/A", "", strListEdition)
      Call SetParam("SetupBIDS",             strSetupBIDS,             "N/A", "", strListEdition)
      Call SetParam("SetupSQLRS",            strSetupSQLRS,            "N/A", "", strListEdition)
    Case (strSQLVersion = "SQL2016") And (strSPLevel < "SP1")
      Call SetParam("SetupAnalytics",        strSetupAnalytics,        "N/A", "", strListEdition)
      Call SetParam("SetupRServer",          strSetupRServer,          "N/A", "", strListEdition)
      Call SetParam("SetupPolyBase",         strSetupPolyBase,         "N/A", "", strListEdition)
      Call SetParam("SetupPolyBaseCluster",  strSetupPolyBaseCluster,  "N/A", "", strListEdition)
  End Select

  Select Case True
    Case strExpVersion = "Basic" 
      Call SetParam("SetupBIDS",             strSetupBIDS,             "N/A", "", strListEdition)
      Call SetParam("SetupSQLDBFT",          strSetupSQLDBFT,          "N/A", "", strListEdition)
      Call SetParam("SetupSQLRS",            strSetupSQLRS,            "N/A", "", strListEdition)
      Call SetParam("SetupSSMS",             strSetupSSMS,             "N/A", "", strListEdition)
    Case strExpVersion = "With Tools" 
      Call SetParam("SetupBIDS",             strSetupBIDS,             "N/A", "", strListEdition)
      Call SetParam("SetupSQLDBFT",          strSetupSQLDBFT,          "N/A", "", strListEdition)
      Call SetParam("SetupSQLRS",            strSetupSQLRS,            "N/A", "", strListEdition)
  End Select

End Sub


Sub GetExpressExe()
  Call SetProcessId("0BCAA", "Get File Name for SQL Express")
  Dim colMediaFiles
  Dim strFileName

  strExpVersion     = ""
  strSQLExe         = GetParam(colFiles,              "SQLExpExe",          "",                    "")
  Set objFolder     = objFSO.GetFolder(strPathSQLMedia)
  Set colMediaFiles = objFolder.Files
  For Each objFile In colMediaFiles
    strFileName     = objFile.name
    If strSQLExe <> "" Then
      strFileName   = strSQLExe
    End If
    Select Case True
      Case CheckExpressExe("Advanced",   strFileName)
        strSQLExe   = strFileName
      Case CheckExpressExe("With Tools", strFileName)
        strSQLExe   = strFileName
      Case CheckExpressExe("Basic",      strFileName)
        strSQLExe   = strFileName
    End Select
  Next

  strSQLExe         = Replace(strSQLExe, "ENU", strSQLLanguage, 1, -1, 1)
  Call DebugLog("File Name for SQL Express: " & strSQLExe)
  If strSQLExe = "" Then
    Call SetBuildMessage(strMsgError, "No EXPRESS Edition install file found")
  End If

End Sub


Function CheckExpressExe(strVersion, strFileName)
  Call DebugLog("CheckExpressExe: " & strFileName & " for " & strVersion)
  Dim strExpExe
  Dim intExpFound

  intExpFound       = False
  Select Case True
    Case (strVersion = "Advanced") And (strSQLVersion = "SQL2005")
      strExpExe     = "SQLEXPR_ADV"
    Case strVersion = "Advanced"
      strExpExe     = "SQLEXPRADV"
    Case (strVersion = "With Tools") And (strSQLVersion = "SQL2005")
      strExpExe     = "UNKNOWN"
    Case strVersion = "With Tools"
      strExpExe     = "SQLEXPRWT"
    Case strVersion = "Basic"  
      strExpExe     = "SQLEXPR"
  End Select

  Select case True
    Case strExpExe = "UNKNOWN"
      ' Nothing
    Case UCase(Left(strFileName, Len(strExpExe))) <> UCase(strExpExe)
      ' Nothing
    Case UCase(Right(strFileName, 4)) <> ".EXE"
      ' Nothing
    Case strSQLVersion = "SQL2005"
      intExpFound = True
    Case (Instr(UCase(strFileName), "X86") > 0) And (strWOWX86 = "TRUE")
      intExpFound = True
    Case Instr(UCase(strFileName), strFileArc) > 0
      intExpFound = True
  End Select

  If intExpFound Then
    strExpVersion   = strVersion
    strEdType       = strVersion
  End If
  CheckExpressExe   = intExpFound

End Function


Sub GetAccountData()
  Call SetProcessId("0BD", "Get details of Windows accounts")

  Call GetLocalAccounts()

  Call GetServiceAccounts()

End Sub


Sub GetLocalAccounts()
  Call SetProcessId("0BDA", "Get Local Account details")

  Set objAccount    = objWMI.Get("Win32_SID.SID='S-1-5-32-544'") ' Local Administrators
  strGroupAdmin     = objAccount.AccountName
  strBuiltinDom     = objAccount.ReferencedDomainName
  Call SetBuildfileValue("BuiltinDom",              strBuiltinDom)
  strLocalAdmin     = UCase(strBuiltinDom & "\" & strGroupAdmin)
  Set objAccount    = objWMI.Get("Win32_SID.SID='S-1-5-32-545'") ' Local Users
  strGroupUsers     = objAccount.AccountName
  Set objAccount    = objWMI.Get("Win32_SID.SID='S-1-5-32-559'") ' Performance Log Users
  strGroupPerfLogUsers = objAccount.AccountName
  Set objAccount    = objWMI.Get("Win32_SID.SID='S-1-5-32-558'") ' Performance Monitor Users
  strGroupPerfMonUsers = objAccount.AccountName
  Set objAccount    = objWMI.Get("Win32_SID.SID='S-1-5-32-555'") ' Remote Desktop Users
  strGroupRDUsers   = objAccount.AccountName

  strSIDDistComUsers = GetBuildfileValue("SIDDistComUsers")
  If strSIDDistComUsers = "" Then
    strSIDDistComUsers = "S-1-5-32-562"
  End If
  Set objAccount       = objWMI.Get("Win32_SID.SID='" & strSIDDistComUsers & "'") ' Distributed Com Users
  strGroupDistComUsers = objAccount.AccountName

  If strNTAuthAccount = "" Then
    Set objAccount  = objWMI.Get("Win32_SID.SID='S-1-5-20'") ' Network Service
    strNTAuthAccount = objAccount.ReferencedDomainName & "\" & objAccount.AccountName
  End If 
  Select Case True
    Case strNTAuthAccount = objWMI.Get("Win32_SID.SID='S-1-5-18'").ReferencedDomainName & "\" & objWMI.Get("Win32_SID.SID='S-1-5-18'").AccountName
      strNTAuthOSName = "LocalSystem"
    Case strNTAuthAccount = objWMI.Get("Win32_SID.SID='S-1-5-19'").ReferencedDomainName & "\" & objWMI.Get("Win32_SID.SID='S-1-5-19'").AccountName
      strNTAuthOSName = "NT AUTHORITY\LocalService"
    Case strNTAuthAccount = objWMI.Get("Win32_SID.SID='S-1-5-20'").ReferencedDomainName & "\" & objWMI.Get("Win32_SID.SID='S-1-5-20'").AccountName
      strNTAuthOSName = "NT AUTHORITY\NetworkService"
    Case Else
      strNTAuthOSName = strNTAuthAccount
  End Select 

  strNTAuthAccount  = UCase(strNTAuthAccount)
  strNTAuthOSName   = UCase(strNTAuthOSName)
  strNTAuth         = Left(strNTAuthAccount, Instr(strNTAuthAccount, "\") - 1)
  Call SetBuildfileValue("NTAuth",                  strNTAuth)

End Sub


Sub GetServiceAccounts()
  Call SetProcessId("0BDB", "Get Service Account details")
  Dim objAccountParm
  Dim strInst

  strDomainSID      = GetUserAttr(strUserName, strUserDnsDomain, "objectSID")
  If strDomainSID > "" Then
    strDomainSID    = Mid(strDomainSid, Instr(strDomainSid, "-") + 1)
    strDomainSID    = Mid(strDomainSid, Instr(strDomainSid, "-") + 1)
    strDomainSID    = Mid(strDomainSid, Instr(strDomainSid, "-") + 1)
    strDomainSID    = Mid(strDomainSid, Instr(strDomainSid, "-") + 1)
    strDomainSID    = Left(strDomainSid, InstrRev(strDomainSid, "-") - 1)
  End If

  Call SetXMLParm(objAccountParm, "AccountParm",     "SqlSvcAccount")
  Call SetXMLParm(objAccountParm, "AccountParmAlt",  "SqlAccount")
  Call SetXMLParm(objAccountParm, "NTServiceAC",     strNTService & "\" & strInstSQL)
  Call SetXMLParm(objAccountParm, "Instance",        strInstSQL)
  Call SetXMLParm(objAccountParm, "PasswordParm",    "SqlSvcPassword")
  Call SetXMLParm(objAccountParm, "PasswordParmAlt", "SqlPassword")
  Call GetAccount("SQLDB",        "YES",             strSqlAccount,        strSqlPassword,         objAccountParm)

  intIdx            = Instr(strSqlAccount, "\")
  If intIdx > 0 Then
    strSqlAcDomain  = Left(strSqlAccount, IntIdx - 1)
  Else
    strSqlAcDomain  = ""
  End If

  Call SetXMLParm(objAccountParm, "AccountParm",     "AgtSvcAccount")
  Call SetXMLParm(objAccountParm, "AccountParmAlt",  "AgtAccount")
  Call SetXMLParm(objAccountParm, "DefaultAC",       strDefaultAccount)
  Call SetXMLParm(objAccountParm, "DefaultPassword", strDefaultPassword)
  Call SetXMLParm(objAccountParm, "NTServiceAC",     strNTService & "\" & strInstAgent)
  Call SetXMLParm(objAccountParm, "Instance",        strInstAgent)
  Call SetXMLParm(objAccountParm, "PasswordParm",    "AgtSvcPassword")
  Call SetXMLParm(objAccountParm, "PasswordParmAlt", "AgtPassword")
  Call GetAccount("SQLDBAG",      strSetupSQLDBAG,   strAgtAccount,        strAgtPassword,         objAccountParm)

  Call SetXMLParm(objAccountParm, "AccountParm",     "AsSvcAccount")
  Call SetXMLParm(objAccountParm, "AccountParmAlt",  "AsAccount")
  Call SetXMLParm(objAccountParm, "DefaultAC",       strDefaultAccount)
  Call SetXMLParm(objAccountParm, "DefaultPassword", strDefaultPassword)
  Call SetXMLParm(objAccountParm, "NTServiceAC",     strNTService & "\" & strInstAS)
  Call SetXMLParm(objAccountParm, "Instance",        strInstAS)
  Call SetXMLParm(objAccountParm, "PasswordParm",    "AsSvcPassword")
  Call SetXMLParm(objAccountParm, "PasswordParmAlt", "AsPassword")
  Call GetAccount("SQLAS",        strSetupSQLAS,     strAsAccount,         strAsPassword,          objAccountParm)

  Call SetXMLParm(objAccountParm, "AccountParm",     "BrowserSvcAccount")
  Call SetXMLParm(objAccountParm, "AccountParmAlt",  "SqlBrowserAccount")
  Call SetXMLParm(objAccountParm, "DefaultAC",       strNTAuthAccount)
  Call SetXMLParm(objAccountParm, "NTServiceAC",     strNTService & "\" & "SQLBrowser")
  Call SetXMLParm(objAccountParm, "Instance",        "SQLBrowser")
  Call SetXMLParm(objAccountParm, "PasswordParm",    "BrowserSvcPassword")
  Call SetXMLParm(objAccountParm, "PasswordParmAlt", "SqlBrowserPassword")
  Call GetAccount("SQLBrowser",   "YES",             strSqlBrowserAccount, strSqlBrowserPassword,  objAccountParm)

  Call SetXMLParm(objAccountParm, "AccountParm",     "CmdshellAccount")
  Call SetXMLParm(objAccountParm, "PasswordParm",    "CmdshellPassword")
  Call SetXMLParm(objAccountParm, "NoAccount",       "IGNORE")
  Call GetAccount("CmdShell",     strSetupCmdShell,  strCmdshellAccount,   strCmdshellPassword,    objAccountParm)

  Call SetXMLParm(objAccountParm, "AccountParm",     "CltSvcAccount")
  Call SetXMLParm(objAccountParm, "DefaultAC",       strDefaultAccount)
  Call SetXMLParm(objAccountParm, "DefaultPassword", strDefaultPassword)
  Call SetXMLParm(objAccountParm, "NTServiceAC",     strNTAuthAccount)
  Call SetXMLParm(objAccountParm, "Instance",        "SQL Server Distributed Replay Client")
  Call SetXMLParm(objAccountParm, "PasswordParm",    "CltScvPassword")
  Call GetAccount("DRUClt",       strSetupDRUClt,    strDRUCltAccount,     strDRUCltPassword,      objAccountParm)

  Call SetXMLParm(objAccountParm, "AccountParm",     "CtlrSvcAccount")
  Call SetXMLParm(objAccountParm, "DefaultAC",       strDefaultAccount)
  Call SetXMLParm(objAccountParm, "DefaultPassword", strDefaultPassword)
  Call SetXMLParm(objAccountParm, "NTServiceAC",     strNTService & "\" & "DRUCtlr")
  Call SetXMLParm(objAccountParm, "PasswordParm",    "CtlrSvcPassword")
  Call GetAccount("DRUCtlr",      strSetupDRUCtlr,   strDRUCtlrAccount,    strDRUCtlrPassword,     objAccountParm)

  Call SetXMLParm(objAccountParm, "AccountParm",     "ExtSvcAccount")
  Call SetXMLParm(objAccountParm, "DefaultAC",       strNTService & "\" & strInstAnal)
  Call SetXMLParm(objAccountParm, "NTServiceAC",     strNTService & "\" & strInstAnal)
  Call SetXMLParm(objAccountParm, "Instance",        strInstAnal)
  Call SetXMLParm(objAccountParm, "PasswordParm",    "ExtSvcPassword")
  Call GetAccount("Analytics",    strSetupAnalytics, strExtSvcAccount,     strExtSvcPassword,      objAccountParm)

  Call SetXMLParm(objAccountParm, "AccountParm",     "FTSvcAccount")
  Call SetXMLParm(objAccountParm, "DefaultAC",       strNTAuthAccount)
  Call SetXMLParm(objAccountParm, "NTServiceAC",     strNTService & "\" & strInstFT)
  Call SetXMLParm(objAccountParm, "Instance",        strInstFT)
  Call SetXMLParm(objAccountParm, "PasswordParm",    "FTSvcPassword")
  Call GetAccount("SQLDBFT",      strSetupSQLDBFT,   strFTAccount,         strFTPassword,          objAccountParm)
 
  Call SetXMLParm(objAccountParm, "AccountParm",     "IsSvcAccount")
  Call SetXMLParm(objAccountParm, "AccountParmAlt",  "IsAccount")
  Call SetXMLParm(objAccountParm, "DefaultAC",       strDefaultAccount)
  Call SetXMLParm(objAccountParm, "DefaultPassword", strDefaultPassword)
  Select Case True
    Case strSQLVersion <= "SQL2014"
      Call SetXMLParm(objAccountParm, "NTServiceAC", strNTAuthAccount)
    Case Else
      Call SetXMLParm(objAccountParm, "NTServiceAC", strNTService & "\" & strInstIS)
  End Select
  Call SetXMLParm(objAccountParm, "Instance",        strInstIS)
  Call SetXMLParm(objAccountParm, "PasswordParm",    "IsSvcPassword")
  Call SetXMLParm(objAccountParm, "PasswordParmAlt", "IsPassword")
  Call GetAccount("SQLIS",        strSetupSQLIS,     strIsAccount,         strIsPassword,          objAccountParm)

  Call SetXMLParm(objAccountParm, "AccountParm",     "ISMasterSvcAccount")
  Call SetXMLParm(objAccountParm, "DefaultAC",       strIsAccount)
  Call SetXMLParm(objAccountParm, "DefaultPassword", strIsPassword)
  Call SetXMLParm(objAccountParm, "NTServiceAC",     strNTService & "\" & strInstISMaster)
  Call SetXMLParm(objAccountParm, "Instance",        strInstIsMaster)
  Call SetXMLParm(objAccountParm, "PasswordParm",    "ISMasterSvcPassword")
  Call GetAccount("ISMaster",     strSetupISMaster,  strIsMasterAccount,   strIsMasterPassword,    objAccountParm)

  Call SetXMLParm(objAccountParm, "AccountParm",     "ISWorkerSvcAccount")
  Call SetXMLParm(objAccountParm, "DefaultAC",       strIsAccount)
  Call SetXMLParm(objAccountParm, "DefaultPassword", strIsPassword)
  Call SetXMLParm(objAccountParm, "NTServiceAC",     strNTService & "\" & strInstISWorker)
  Call SetXMLParm(objAccountParm, "Instance",        strInstIsWorker)
  Call SetXMLParm(objAccountParm, "PasswordParm",    "ISWorkerSvcPassword")
  Call GetAccount("ISWorker",     strSetupISWorker,  strIsWorkerAccount,   strIsWorkerPassword,    objAccountParm)

  Call SetXMLParm(objAccountParm, "AccountParm",     "MDSAccount")
  Call SetXMLParm(objAccountParm, "NoAccount",       "IGNORE") ' "ERROR") ' Temporary until next phase of MDS configuration added to FineBuild
  Call SetXMLParm(objAccountParm, "NTServiceAC",     strNTAuthAccount)
  Call SetXMLParm(objAccountParm, "PasswordParm",    "MDSPassword")
  Call GetAccount("MDS",          strSetupMDS,       strMDSAccount,        strMDSPassword,         objAccountParm)

  Call SetXMLParm(objAccountParm, "AccountParm",     "MDWAccount")
  Call SetXMLParm(objAccountParm, "DefaultAC",       strAgtAccount)
  Call SetXMLParm(objAccountParm, "DefaultPassword", strAgtPassword)
  Call SetXMLParm(objAccountParm, "PasswordParm",    "MDWPassword")
  Call GetAccount("MDW",          strSetupManagementDW, strMDWAccount,     strMDWPassword,         objAccountParm)

  Call SetXMLParm(objAccountParm, "AccountParm",     "PBDMSSvcAccount")
  Call SetXMLParm(objAccountParm, "DefaultAC",       strDefaultAccount)
  Call SetXMLParm(objAccountParm, "DefaultPassword", strDefaultPassword)
  Call SetXMLParm(objAccountParm, "NTServiceAC",     strNTService & "\" & "PBDMSSvc")
  Call SetXMLParm(objAccountParm, "Instance",        strInstPM)
  Call SetXMLParm(objAccountParm, "PasswordParm",    "PBDMSSvcPassword")
  Call GetAccount("PolyBase",     strSetupPolyBase,  strPBDMSSvcAccount,   strPBDMSSvcPassword,    objAccountParm)

  Call SetXMLParm(objAccountParm, "AccountParm",     "PBEngSvcAccount")
  Call SetXMLParm(objAccountParm, "DefaultAC",       strPBDMSSvcAccount)
  Call SetXMLParm(objAccountParm, "DefaultPassword", strPBDMSSvcPassword)
  Call SetXMLParm(objAccountParm, "NTServiceAC",     strNTService & "\" & "PBEngSvc")
  Call SetXMLParm(objAccountParm, "Instance",        strInstPE)
  Call SetXMLParm(objAccountParm, "PasswordParm",    "PBEngSvcPassword")
  Call GetAccount("PolyBase",     strSetupPolyBase,  strPBEngSvcAccount,   strPBEngSvcPassword,    objAccountParm)

  Call SetXMLParm(objAccountParm, "AccountParm",     "RsSvcAccount")
  Call SetXMLParm(objAccountParm, "AccountParmAlt",  "RsAccount")
  Call SetXMLParm(objAccountParm, "DefaultAC",       strDefaultAccount)
  Call SetXMLParm(objAccountParm, "DefaultPassword", strDefaultPassword)
  Call SetXMLParm(objAccountParm, "NTServiceAC",     strNTService & "\" & strInstRS)
  Call SetXMLParm(objAccountParm, "Instance",        strInstRS)
  Call SetXMLParm(objAccountParm, "PasswordParm",    "RsSvcPassword")
  Call SetXMLParm(objAccountParm, "PasswordParmAlt", "RsPassword")
  Select Case True
    Case strOSVersion <> "6.2"
      Call GetAccount("SQLRS",    strSetupSQLRS,     strRsAccount,         strRsPassword,          objAccountParm)
    Case strRsPassword <> ""
      Call GetAccount("SQLRS",    strSetupSQLRS,     strRsAccount,         strRsPassword,          objAccountParm)
    Case strSetupPowerBI <> "YES"
      Call GetAccount("SQLRS",    strSetupSQLRS,     strRsAccount,         strRsPassword,          objAccountParm)
    Case Else
      strRsAccount   = strNTService & "\" & strInstRS
      strRsPassword  = ""
      objAccountParm = ""
  End Select

  Call SetXMLParm(objAccountParm, "AccountParm",     "RsExecAccount")
  Call SetXMLParm(objAccountParm, "NoAccount",       "NOSETUP")
  Call SetXMLParm(objAccountParm, "PasswordParm",    "RsExecPassword")
  Call GetAccount("RSExec",       strSetupRSExec,    strRSExecAccount,     strRSExecPassword,      objAccountParm)

  Call SetXMLParm(objAccountParm, "AccountParm",     "RsShareAccount")
  Call SetXMLParm(objAccountParm, "NoAccount",       "NOSETUP")
  Call SetXMLParm(objAccountParm, "DefaultAC",       strRSExecAccount)
  Call SetXMLParm(objAccountParm, "DefaultPassword", strRSExecPassword)
  Call SetXMLParm(objAccountParm, "PasswordParm",    "RsSharePassword")
  Call GetAccount("RSShare",      strSetupRSShare,   strRsShareAccount,    strRsSharePassword,     objAccountParm)

  Call SetXMLParm(objAccountParm, "AccountParm",     "TelSvcAcct")
  Call SetXMLParm(objAccountParm, "DefaultAC",       strNTService & "\" & strInstTel)
  Call SetXMLParm(objAccountParm, "NTServiceAC",     strNTService & "\" & strInstTel)
  Call SetXMLParm(objAccountParm, "Instance",        strInstTel)
  Call SetXMLParm(objAccountParm, "PasswordParm",    "TelSvcPassword")
  Call GetAccount("ISWorker",     "YES",             strTelSvcAcct,        strTelSvcPassword,      objAccountParm)

End Sub


Sub GetAccount(strSetupName, strSetup, strAccount, strPassword, objAccountParm)
  Call DebugLog("GetAccount: " & strSetupName)
  Dim strAccountParm, strAccountParmAlt, strAccountReqd, strDefaultAC, strDefaultPswd, strNTServiceAC, strInstance, strNoAccount, strPasswordParm, strPasswordParmAlt

  strAccountParm    = GetXMLParm(objAccountParm, "AccountParm",     "")
  strAccountParmAlt = GetXMLParm(objAccountParm, "AccountParmAlt",  "")
  strDefaultAC      = GetXMLParm(objAccountParm, "DefaultAC",       "")
  strDefaultPswd    = GetXMLParm(objAccountParm, "DefaultPassword", "")
  strInstance       = GetXMLParm(objAccountParm, "Instance",        "")
  strNoAccount      = GetXMLParm(objAccountParm, "NoAccount",       "ERROR")
  strNTServiceAC    = GetXMLParm(objAccountParm, "NTServiceAC",     "")
  strPasswordParm   = GetXMLParm(objAccountParm, "PasswordParm",    "")
  strPasswordParmAlt= GetXMLParm(objAccountParm, "PasswordParmAlt", "")

  strAccount        = ""
  strPassword       = ""
  Select Case True	' Get Account details from Parameter or Service Discovery
    Case colArgs.Exists(strAccountParm) OR colArgs.Exists(strAccountParmAlt)
      strAccount    = GetParam(Null,                  strAccountParm,       strAccountParmAlt,     strDefaultAC)
      strPassword   = GetParam(Null,                  strPasswordParm,      strPasswordParmAlt,    "")
    Case strInstance <> ""
      strPath       = "SYSTEM\CurrentControlSet\Services\" & strInstance & "\"
      objWMIReg.GetStringValue strHKLM,strPath,"ObjectName",strAccount
      If IsNull(strAccount) Then
        strAccount  = ""
      End If
  End Select

  Select Case True	' Initial check on Account
    Case strSetupName = "SQLDB" 
      Call CheckSqlAccount(strAccountParm, strAccountParmAlt, strAccount)
    Case strAccount > ""
      ' Nothing
    Case Else
      strAccount    = strDefaultAC
      strPassword   = strDefaultPswd
  End Select

  If strAccount = strNTService Then
    strAccount      = strNTServiceAC
    strPassword     = ""
  End If

  Select Case True	' Force Setup for CONFIG or DISCOVER process
    Case strAccount = ""
      ' Nothing
    Case Instr("CONFIG DISCOVER", strType) > 0
      strSetup      = "YES"
  End Select

  Select Case True	' Check account details
    Case strSetup <> "YES"
      ' Nothing
    Case strAccount <> ""
      strAccount    = CheckAccount(strAccountParm, strAccountParmAlt, strAccount, "Y")
    Case strNoAccount = "IGNORE"
      ' Nothing
    Case strNoAccount = "NOSETUP"
      strSetup      = "NO"
    Case Else
      Call SetBuildMessage(strMsgError, "/" & strAccountParm & " must be specified")
  End Select

  objAccountParm    = ""

End Sub


Sub CheckSqlAccount(strAccountParm, strAccountParmAlt, strSqlAccount)
  Call DebugLog("CheckSqlAccount:")

  Select Case True
    Case (strSQLVersion <= "SQL2008R2") And (strSQLAccount = "")
      strSqlAccount      = strNTAuthAccount
      strSqlPassword     = ""
      strDefaultAccount  = strSqlAccount
      strDefaultPassword = strSQLPassword
    Case (strOSVersion < "6.1") And (strSQLAccount = "")
      strSqlAccount      = strNTAuthAccount
      strSqlPassword     = ""
      strDefaultAccount  = strSqlAccount
      strDefaultPassword = strSQLPassword
    Case strOSVersion < "6.1" 
      strDefaultAccount  = strSqlAccount
      strDefaultPassword = strSQLPassword
    Case strSqlAccount = ""
      strSqlAccount      = strNTService & "\" & strInstSQL  ' Local Virtual Account
      strSqlPassword     = ""
      strDefaultAccount  = strNTService
      strDefaultPassword = strSQLPassword
    Case Left(strSQLAccount, Len(strNTService) + 1) = strNTService & "\" ' Local Virtual Account
      strSqlPassword     = ""
      strDefaultAccount  = strNTService
      strDefaultPassword = strSQLPassword
    Case Else
      strDefaultAccount  = strSqlAccount
      strDefaultPassword = strSqlPassword
  End Select

  strSqlAccount     = CheckAccount(strAccountParm, strAccountParmAlt, strSqlAccount, "N")

  If GetBuildfileValue("SqlAccountType") = "M" Then        ' Domain Managed Account
    strSqlPassword     = ""
    strDefaultAccount  = strSqlAccount
    strDefaultPassword = strSQLPassword
  End If

End Sub


Function CheckAccount(strAccountParm, strAltParm, strUserAccount, strVerify)
  Call DebugLog("CheckAccount: " & strAccountParm & " Account: " & strUserAccount)
  Dim intIdx
  Dim strAccount, strAccountDom, strAccountVar
' AccountType: S=Local Service,L=Local User,M=Domain Managed,G=Domain User

  strAccount        = strUserAccount
  intIdx            = Instr(strAccount, "\")
  Select Case True
    Case intIdx = 0 
      strAccountDom = ""
    Case Left(strAccount, intIdx) = ".\"
      strAccountDom = strServer
      strAccount    = strAccountDom & Mid(strAccount, 2)
    Case Else
      strAccountDom = Left(strAccount, intIdx - 1)
  End Select

  Select Case True
    Case strAltParm = ""
      strAccountVar = strAccountParm
      Call SetBuildfileValue(strAccountVar & "Name", strAccountParm)
    Case strSQLVersion <= "SQL2005"
      strAccountVar = strAltParm
      Call SetBuildfileValue(strAccountVar & "Name", strAltParm)
    Case Else
      strAccountVar = strAltParm
      Call SetBuildfileValue(strAccountVar & "Name", strAccountParm)
  End Select

  Select Case True
    Case strAccount = ""
      Call SetBuildfileValue(strAccountVar & "Type", "")
    Case GetUserAttr(strAccount, strUserDnsDomain, "msDS-GroupMSAMembership") <> ""
      Call CheckMSAAccount(strAccountVar, strAccount)
      Call SetBuildfileValue(strAccountVar & "Type", "M")
    Case StrComp(strAccountDom, strNTAuth, vbTextCompare) = 0
      Call SetBuildfileValue(strAccountVar & "Type", "S")
    Case StrComp(strAccountDom, strNTService, vbTextCompare) = 0
      Call SetBuildfileValue(strAccountVar & "Type", "S")
    Case StrComp(strAccountDom, strServer, vbTextCompare) = 0
      If GetUserAttr(strAccount, strAccountDom, "name") = "" Then
        Call SetBuildMessage(strMsgError, "Account " & strUserAccount & " can not be found")
      End If
      Call SetBuildfileValue(strAccountVar & "Type", "L")
    Case Else
      If GetUserAttr(strAccount, strUserDnsDomain, "name") = "" Then
        Call SetBuildMessage(strMsgError, "Account " & strUserAccount & " can not be found")
      End If
      Call SetBuildfileValue(strAccountVar & "Type", "D")
  End Select

  Select Case True
    Case strVerify <> "Y"
      ' Nothing
    Case GetBuildfileValue(strAccountVar & "Type") <> "M"
      ' Nothing
    Case strOSVersion <= "6.1"
      Call SetBuildMessage(strMsgError, strAccountVar & " - Domain Managed Account can not be used on " & strOSName)
    Case strSQLVersion <= "SQL2008R2"
      Call SetBuildMessage(strMsgError, strAccountVar & " - Domain Managed Account can not be used on " & strSQLVersion)
  End Select

  Call DebugLog(" Account found: " & strAccount)
  CheckAccount      = strAccount

End Function


Function GetUserAttr(strUserAccount, strUserDnsDomain, strUserAttr)
  Call DebugLog("GetUserAttr: " & strUserAccount)
  Dim objField, objRecordSet
  Dim strAccount,strAttrObject, strAttrSearch, strAttrValue
  Dim intIdx
 
  strAttrValue      = ""
  strAttrSearch     = strUserAttr
  intIdx            = Instr(strUserAccount, "\") + 1
  strAccount        = Mid(strUserAccount, intIdx)
  Select Case True
    Case strUserAttr = "msDS-GroupMSAMembership"
      strAttrObject = "objectClass=msDS-GroupManagedServiceAccount"
    Case Else
      strAttrObject = "objectClass=user"
  End Select

  On Error Resume Next 
  objADOCmd.CommandText          = "<LDAP://DC=" & Replace(strUserDnsDomain, ".", ",DC=") & ">;(&(" & strAttrObject & ")(CN=" & strAccount & "));CN," & strAttrSearch
  Set objRecordSet  = objADOCmd.Execute
  Select Case True
    Case objRecordset Is Nothing
      ' Nothing
    Case IsNull(objRecordset)
      ' Nothing
    Case objRecordset.RecordCount = 0 
      ' Nothing
    Case Else
      objRecordset.MoveFirst
      Select Case True
        Case IsNull(objRecordset.Fields(1).Value)
          ' Nothing
        Case strUserAttr = "msDS-GroupMSAMembership"
          strAttrValue = OctetToHexStr(objRecordset.Fields(1).Value)
        Case Else
          strAttrValue = objRecordset.Fields(1).Value
      End Select
  End Select

  If Instr(strUserAttr, "SID") > 0 Then
    strAttrValue    = OctetToHexStr(strAttrValue)
    strAttrValue    = HexStrToSIDStr(strAttrValue)
  End If

  err.Number        = 0
  GetUserAttr       = strAttrValue

End Function


Function OctetToHexStr(strValue)
  Dim strHexStr
  Dim intIdx

  strHexStr         = ""
  For intIdx = 1 To Lenb(strValue)
    strHexStr       = strHexStr & Right("0" & Hex(Ascb(Midb(strValue, intIdx, 1))), 2)
  Next

  OctetToHexStr     = strHexStr

End Function


Function HexStrToSIDStr(strValue)
  Dim arrSID
  Dim strSIDStr
  Dim intIdx, intUB, intWork

  intUB             = (Len(strValue) / 2) - 1
  ReDim arrSID(intUB)  
  For intIdx = 0 To intUB
    arrSID(intIdx)  = CInt("&H" & Mid(strValue, (intIdx * 2) + 1, 2))
  Next

  strSIDStr         = "S-" & arrSID(0) & "-" & arrSID(1) & "-" & arrSID(8)
  If intUB >= 15 Then
    intWork         = arrSID(15)
    intWork         = (intWork * 256) + arrSID(14)
    intWork         = (intWork * 256) + arrSID(13)
    intWork         = (intWork * 256) + arrSID(12)
    strSIDStr       = strSIDStr & "-" & CStr(intWork)
    If intUB >= 22 Then
      intWork       = arrSID(19)
      intWork       = (intWork * 256) + arrSID(18)
      intWork       = (intWork * 256) + arrSID(17)
      intWork       = (intWork * 256) + arrSID(16)
      strSIDStr     = strSIDStr & "-" & CStr(intWork)
      intWork       = arrSID(23)
      intWork       = (intWork * 256) + arrSID(22)
      intWork       = (intWork * 256) + arrSID(21)
      intWork       = (intWork * 256) + arrSID(20)
      strSIDStr     = strSIDStr & "-" & CStr(intWork)
    End If
    If intUB >= 25 Then
      intWork       = arrSID(25)
      intWork       = (intWork * 256) + arrSID(24)
      strSIDStr     = strSIDStr & "-" & CStr(intWork)
    End If
  End If

  HexStrToSIDStr    = strSIDStr

End Function


Sub CheckMSAAccount(strAccountParm, strAccount)
  Call DebugLog("CheckMSAAccount: " & strAccount)
  Dim intIdx
  Dim strAccountName

  intIdx            = Instr(strAccount, "\") + 1
  strAccountName    = Mid(strAccount, intIdx)

  Select Case True
    Case strSQLVersion < "SQL2012"
      Call SetBuildMessage(strMsgError, "Domain Managed Accounts cannot be used with " & strSQLVersion)
    Case Len(strAccountName) > 15
      Call SetBuildMessage(strMsgError, "/" & strAccountParm & " must be 15 characters or less")
    Case strSQLVersion >= "SQL2016"
      ' Nothing
    Case Right(strAccount, 1) <> "$" 
      Call SetBuildMessage(strMsgError, "/" & strAccountParm & " MSA Account must end with $")
  End Select

  strGroupMSA       = GetUserAttr(strAccount, strUserDnsDomain, "msDS-GroupMSAMembership")
 
End Sub


Sub GetDBAGroups()
  Call SetProcessId("0BE", "Get DBA Groups")

  strGroupDBA       = UCase(GetParam(colGlobal,       "GroupDBA",           "",                    ""))
  strSecDBA         = strSecMain & " """ & FormatAccount(strGroupDBA) & """:F "
  strGroupDBA       = CheckGroup(strGroupDBA) 
  Select Case True
    Case strGroupDBA <> ""
      ' Nothing
    Case Else
      Call SetBuildMessage(strMsgWarning, "/GroupDBA value can not be found so using local Administators")
      strGroupDBA   = CheckGroup(strLocalAdmin)
      strSecDBA     = Replace(strSecMain, " ", "  ") ' Add extra space into SecDBA so it is different to SecMain
  End Select

  Call Util_RunExec("WHOAMI /GROUPS /FO CSV | FIND /C """ & strGroupDBA & """", "", "", -1)
  strIsInstallDBA   = CStr(intErrSave)
  If strSQLVersion >= "SQL2012" Then
    strMembersDBA   = GetGroupMembers(strGroupDBA, 1)
  End If

  Select Case True
    Case strUserDNSDomain = ""
      strUserAccount = strServer & "\" & strUserName
    Case Else
      strUserAccount = strDomain & "\" & strUserName
  End Select

  strGroupDBANonSA  = UCase(GetParam(colGlobal,       "GroupDBANonSA",      "",                    ""))
  strGroupDBANonSA  = CheckGroup(strGroupDBANonSA) 

End Sub


Function CheckGroup(strGroupParm)
  Call DebugLog("CheckGroup: " & strGroupParm)
  Dim intFound
  Dim strGroup, strGroupDom, strGroupName

  strGroup          = ""
  intFound          = False
  intIdx            = Instr(strGroupParm, "\")
  Select Case True
    Case intIdx = 0
      strGroupDom   = strDomain
      strGroupName  = strGroupParm
      intFound      = CheckGroupExists(strGroupDom, strGroupName)
    Case Left(strGroupParm, intIdx) = ".\"
      strGroupDom   = strServer
      strGroupName  = Mid(strGroupParm,  intIdx + 1)
      intFound      = CheckGroupExists(strGroupDom, strGroupName)
    Case Else
      strGroupDom   = Left(strGroupParm, intIdx - 1)
      strGroupName  = Mid(strGroupParm,  intIdx + 1)
      intFound      = CheckGroupExists(strGroupDom, strGroupName)
  End Select

  If intFound = False Then
    strGroupDom     = strServer
    intFound        = CheckGroupExists(strGroupDom, strGroupName)
  End If

  Select Case True
    Case intFound = True
      strGroup      = strGroupDom & "\" & strGroupName
    Case Else
      strGroup      = ""
  End Select

  CheckGroup = strGroup 

End Function


Function CheckGroupExists(strGroupDom, strGroupName)
  Call DebugLog("CheckGroupExists: " & strGroupDom & " " & strGroupName)
  Dim intFound

  intFound          = -1
  Select Case True
    Case strGroupName = ""
      ' Nothing
    Case strGroupDom = "BUILTIN"
      Call DebugLog("Check BUILTIN for " & strServer)
      Call Util_RunExec("NET LOCALGROUP """ & strGroupName & """ ", "", "", -1)
      intFound      = intErrSave
      strGroupDom   = strBuiltinDom
    Case strGroupDom = strServer
      Call DebugLog("Check Server " & strServer)
      Call Util_RunExec("NET LOCALGROUP """ & strGroupName & """ ", "", "", -1)
      intFound      = intErrSave
    Case strUserDNSDomain <> ""
      Call DebugLog("Check Domain " & strUserDNSDomain)
      Call Util_RunExec("NET GROUP """ & strGroupName & """ /Domain", "", "", -1)
      intFound      = intErrSave
    Case Else
      Call DebugLog("Check Workgroup")
      Call Util_RunExec("NET LOCALGROUP """ & strGroupName & """ ", "", "", -1)
      intFound      = intErrSave
      strGroupDom   = strServer
  End Select

  Select Case True
    Case intFound = 0
      CheckGroupExists = True
    Case Else
      CheckGroupExists = False
  End Select

End Function


Function GetGroupMembers(strGroup, intLevel)
  Call DebugLog("GetGroupMembers: " & strGroup)
  Dim strGroupDom, strGroupName, strMembers

  intIdx            = Instr(strGroup, "\")
  strGroupDom       = Left(strGroup, intIdx - 1)
  strGroupName      = Mid(strGroup,  intIdx + 1)
  If strGroupDom = "BUILTIN" Then
    strGroupDom     = strServer
  End If

  Select Case True
    Case UCase(strGroupDom) = UCase(strServer)
      strMembers    = GetLocalMembers(strGroupDom, strGroupName, intLevel)
    Case Else
      strMembers    = GetADMembers(strGroupDom, strGroupName, intLevel)
  End Select

  Call DebugLog("Members of Group " & strGroup & ": " & strMembers)
  GetGroupMembers   = strMembers

End Function


Function GetLocalMembers(strGroupDom, strGroupName, intLevel)
  Call DebugLog("GetLocalMembers: " & strGroupDom & "\" & strGroupName)
  Dim objGroup, objMember
  Dim strMembers, strMemberName

  strMembers        = ""
  Set objGroup      = GetObject("WinNT://" & strGroupDom & "/" & strGroupName)
  Select Case True
    Case objGroup.Class = "User"
      strMembers = strGroup
    Case objGroup.Class = "Group"
      For Each objMember In objGroup.Members
        strMemberName = Mid(objMember.Parent, InstrRev(objMember.Parent, "/") + 1) & "\" & objMember.Name
        Select Case True
          Case (objMember.Class = "Group") And (intLevel <= 5)
            strMembers = strMembers & " " & GetGroupMembers(strMemberName, intLevel + 1)
          Case objMember.Class <> "User" 
            ' Nothing
          Case CheckUser(strGroupDom, strMemberName) = True
            strMembers = strMembers & """" & strMemberName & """ "
        End Select
      Next
  End Select

  Set objMember     = Nothing
  Set objGroup      = Nothing
  GetLocalMembers   = RTrim(strMembers)

End Function


Function GetADMembers(strGroupDom, strGroupName, intLevel)
  Call DebugLog("GetADMembers: " & strGroupDom & "\" & strGroupName)
' Based on: https://gallery.technet.microsoft.com/scriptcenter/b160d928-fb9e-4c49-a194-f2e5a3e806ae
  Dim objAdsPath, objMember, objADRecords
  Dim strMemberDom, strMembers

  strCmd            = "SELECT AdsPath FROM '" & strADRoot & "' WHERE sAMAccountName='" & strGroupName & "'"
  Set objADRecords  = WScript.CreateObject("ADODB.Recordset")
  objADRecords.Open strCmd, objADOConn, 3
  Set objAdsPath    = GetObject(objADRecords("AdsPath"))
  For Each objMember In objAdsPath.Members
    strMemberDom    = UCase(objMember.AdsPath)
    strMemberDom    = Mid(strMemberDom, Instr(strMemberDom, "DC=") + 3)
    intIdx          = Instr(strMemberDom, ",")
    If intIdx > 0 Then
      strMemberDom  = Left(strMemberDom, IntIdx - 1)
    End If
    Select Case True
      Case (objMember.Class = "Group") And (intLevel <= 5) 
        strMembers  = strMembers & " " & GetGroupMembers(strMemberDom & "\" & objMember.sAMAccountName, intLevel + 1)
      Case objMember.Class <> "User" 
        ' Nothing
      Case CheckUser(strGroupDom, objMember.sAMAccountName) = True
        strMembers  = strMembers & " " & strMemberDom & "\" & objMember.sAMAccountName
    End Select
  Next

  Set objADRecords  = Nothing
  Set objAdsPath    = Nothing
  Set objMember     = Nothing
  GetADMembers      = RTrim(strMembers)

End Function


Function CheckUser(strGroupDom, strUser)
  Call DebugLog("CheckUser: " & strGroupDom & "\" &  strUser)
  On Error Resume Next

  Set objUser       = GetObject("WinNT://" & strGroupDom & "/" & strUser)
  Select Case True
    Case Err.Number = 0
      CheckADUser   = True
    Case Else
      CheckADUser   = False
  End Select

  On Error GoTo 0

End Function


Sub GetVolumeData()
  Call SetProcessId("0BF", "Get data for Storage Volumes")

  Call SetLocalVolCodes()

  If strClusterHost <> "" Then
    Call SetClusterVolCodes()
  End If

  Call SetNetworkVolCodes()

  Call GetInstallVolumes()

End Sub


Sub SetLocalVolCodes()
  Call SetProcessId("0BFA", "Set Local Volume codes")
  Dim colVol
  Dim objVol
  Dim strVolume, strVolSource, strVolType
' VolSource: C=CSV, D=Disk, M=Mount Point, N=Mapped Network Drive, S=Share
' VolType:   C=Clustered, L=Local, X=Either

  strCmd            = "SELECT * FROM Win32_LogicalDisk"
  Set colVol        = objWMI.ExecQuery(strCmd)
  For Each objVol In colVol
    strVolume       = UCase(Left(objVol.DeviceId, 1))
    strVolSource    = GetBuildfileValue("Vol" & strVolume & "Source")
    strVolType      = GetBuildfileValue("Vol" & strVolume & "Type")
    If strVolType = "" Then
      strVolType    = "L"
    End If
    Select Case True
      Case strVolSource = "M"
        ' Nothing
      Case objVol.DriveType = 3 ' Local Disk
        strDriveList = strDriveList & strVolume
        Call SetBuildfileValue("Vol" & strVolume & "Source",  "D")
        Call SetBuildfileValue("Vol" & strVolume & "Type",    strVolType)
      Case objVol.DriveType = 4 ' Network Share
        strDriveList = strDriveList & strVolume
        Call SetBuildfileValue("Vol" & strVolume & "Source",  "N")
        Call SetBuildfileValue("Vol" & strVolume & "Type",    strVolType)
        Call SetBuildfileValue("Vol" & strVolume & "Path",    objVol.ProviderName)
      Case objVol.DriveType = 6 ' RAM Disk
        strDriveList = strDriveList & strVolume
        Call SetBuildfileValue("Vol" & strVolume & "Source",  "D")
        Call SetBuildfileValue("Vol" & strVolume & "Type",    strVolType)
    End Select
    Call CheckDriveSize (objVol, objVol.DeviceId)
    Call CheckDriveSpace(objVol, objVol.DeviceId)
  Next

End Sub


Sub SetClusterVolCodes()
  Call SetProcessId("0BFB", "Set Cluster Volume codes")
  Dim colClusPartitions, colResources
  Dim objClusDisk, objClusPartition, objResource
  Dim strResName, strVolName, strVolSource
' VolSource: C=CSV, D=Disk, M=Mount Point, N=Mapped Network Drive, S=Share
' VolType:   C=Clustered, L=Local, X=Either

  Set colResources  = objCluster.Resources
  For Each objResource In colResources
    If objResource.TypeName = "Physical Disk" Then
      Set objClusDisk       = objResource.Disk
      Set colClusPartitions = objClusDisk.Partitions
      For Each objClusPartition In colClusPartitions
        Select Case True
          Case objClusPartition.FileSystem = "CSVFS"
            strResName   = objResource.Name
            strVolName   = GetCSVFolder(strResName)
            strVolSource = "C"
          Case Left(objClusPartition.DeviceName, 11) = "\\?\Volume{"
            strResName   = Mid(objClusPartition.DeviceName, InStr(objClusPartition.DeviceName, "{") + 1)
            strResName   = Left(strResName, Instr(strResName, "}") - 1)
            strVolName   = strResName
            strVolSource = "M"
          Case Else
            strResName   = objResource.Name
            strVolName   = Left(objClusPartition.DeviceName, 1)
            strVolSource = "D"
        End Select
        strDebugMsg1 = "Vol Name:   " & strVolName
        strDebugMsg2 = "Vol Source: " & strVolSource
        Call SetBuildfileValue("Vol_" & UCase(strVolName) & "Name",  strResName)
        Call SetBuildfileValue("Vol" & UCase(strVolName) & "Source",  strVolSource)
        Call SetBuildfileValue("Vol" & UCase(strVolName) & "Type",    "C")
        strCmd       = "CLUSTER """ & strClusterName & """ RESOURCE """ & strResName & """ /ON"
        Call Util_RunExec(strCmd, "", strResponseYes, "5023")
        If intErrSave = 5023 Then
          WScript.Sleep strWaitLong
          Call Util_RunExec(strCmd, "", strResponseYes, 0)
        End If
      Next
    End If
  Next

End Sub


Function GetCSVFolder(strResName)
  Call DebugLog("GetCSVFolder: " & strResName)
  Dim arrResources, arrVolumeNames, arrVolumeParts
  Dim colResource
  Dim strName, strPathREsource, strPathResources, strResFolder, strType

  strResFolder      = Replace(strResName, " ", "")
  strPathResources  = "HKLM\Cluster\Resources\"
  objWMIReg.EnumKey strHKLM, Mid(strPathResources, 6), arrResources
  For Each colResource In arrResources
    strPathResource = strPathResources & colResource
    strType         = objShell.RegRead(strPathResource & "\Type")
    strName         = objShell.RegRead(strPathResource & "\Name")
    Select Case True
      Case strType <> "Physical Disk"
        ' Nothing
      Case strName <> strResName
        ' Nothing
      Case Else
        objWMIReg.GetMultiStringValue strHKLM, Mid(strPathResource, 6), "VolumeNames", arrVolumeNames
        arrVolumeParts = Split(arrVolumeNames(0), " ")
        strResFolder   = arrVolumeParts(3)
    End Select
  Next 

  GetCSVFolder      = strResFolder

End Function


Sub CheckDriveSize(objVol, strVol)
  Call DebugLog("CheckDriveSize: " & strVol)
  Dim strSizeParm, strSizeUnits
  Dim intSizeReq, intSizeVol

  strSizeParm       = Ucase(GetParam(Null,            "VolSize" & Left(strVol, 1), "DrvSize" & Left(strVol, 1), ""))
  If strSizeParm > "" Then
    strSizeUnits    = Right(strSizeParm, 2)
    If Instr("MB GB TB", strSizeUnits) > 0 Then
      intSizeReq    = RTrim(Left(strSizeParm, Len(strSizeParm) - 2))
    Else
      strSizeUnits  = "MB"
      intSizeReq    = RTrim(strSizeParm)
    End If
    intSizeVol      = objVol.Size + 1
    Select Case True
      Case strSizeUnits = "MB"
        intSizeVol  = intSizeVol / 1024 / 1024
      Case strSizeUnits = "GB"
        intSizeVol  = intSizeVol / 1024 / 1024 / 1024
      Case strSizeUnits = "TB"
        intSizeVol  = intSizeVol / 1024 / 1024 / 1024 / 1024
    End Select
    Select Case True
      Case strClusterAction = "ADDNODE"
        ' Nothing
      Case (strProcessId >= "2") And (strProcessId <> "7")
        ' Nothing
      Case IsNumeric(intSizeReq) = False
        ' Nothing
      Case Int(intSizeVol * 0.99) < Int(intSizeReq)
        Call SetBuildMessage(strMsgError, "Volume " & strVol & ": size is too small. " & Cstr(Int(intSizeReq)) & strSizeUnits & " required, " & Cstr(Int(intSizeVol)) & strSizeUnits & " found.")
      Case Else
        Call SetBuildMessage(strMsgInfo,  "Volume " & strVol & ": OK, Size required " & Cstr(Int(intSizeReq)) & strSizeUnits & ", Size found " & Cstr(Int(intSizeVol)) & strSizeUnits)
    End Select
  End If

End Sub


Sub CheckDriveSpace(objVol, strVol)
  Call DebugLog("CheckDriveSpace: " & strVol)
  Dim strSpaceParm, strSpaceUnits
  Dim intSpaceReq, intSpaceVol

  strSpaceParm      = Ucase(GetParam(Null,            "VolSpace" & Left(strVol, 1), "DrvSpace" & Left(strVol, 1),""))
  If strSpaceParm > "" Then
    strSpaceUnits   = Right(strSpaceParm, 2)
    If Instr("MB GB TB", strSpaceUnits) > 0 Then
      intSpaceReq   = RTrim(Left(strSpaceParm, Len(strSpaceParm) - 2))
    Else
      strSpaceUnits = "MB"
      intSpaceReq   = RTrim(strSpaceParm)
    End If
    intSpaceVol     = objVol.FreeSpace + 1
    Select Case True
      Case strSpaceUnits = "MB"
        intSpaceVol = intSpaceVol / 1024 / 1024
      Case strSpaceUnits = "GB"
        intSpaceVol = intSpaceVol / 1024 / 1024 / 1024
      Case strSpaceUnits = "TB"
        intSpaceVol = intSpaceVol / 1024 / 1024 / 1024 / 1024
    End Select
    Select Case True
      Case strClusterAction = "ADDNODE"
        ' Nothing
      Case (strProcessId >= "2") And (strProcessId <> "7")
        ' Nothing
      Case IsNumeric(intSpaceReq) = False
        ' Nothing
      Case Int(intSpaceVol * 0.99) < Int(intSpaceReq)
        Call SetBuildMessage(strMsgError, "Volume " & strVol & ": does not have enough free space. " & Cstr(Int(intSpaceReq)) & strSpaceUnits & " required, " & Cstr(Int(intSpaceVol)) & strSpaceUnits & " found.")
      Case Else
        Call SetBuildMessage(strMsgInfo,  "Volume " & strVol & ": OK, space required " & Cstr(Int(intSpaceReq)) & strSpaceUnits & ", space found " & Cstr(Int(intSpaceVol)) & strSpaceUnits)
    End Select
  End If

End Sub


Sub SetNetworkVolCodes()
  Call SetProcessId("0BFC", "Set Network Volume codes")
  Dim arrDrives
  Dim objDrive
  Dim strDrive, strRemotePath

  strPath           = strUserSID & "\Network"
  objWMIReg.EnumKey strHKU, strPath, arrDrives
  Select Case True
    Case IsNull(arrDrives)
      ' Nothing
    Case Else
      For Each objDrive In arrDrives
        strDriveList = strDriveList & objDrive
        objWMIReg.GetStringValue strHKU,strPath & "\" & objDrive,"RemotePath",strRemotePath
        strDrive     = UCase(objDrive)
        Call SetBuildfileValue("Vol" & strDrive & "Source",  "N")
        Call SetBuildfileValue("Vol" & strDrive & "Type",    "L")
        Call SetBuildfileValue("Vol" & strDrive & "Path",    strRemotePath)
      Next      
    End Select

End Sub


Sub GetInstallVolumes()
  Call SetProcessId("0BFD", "Get volumes needed for SQL install")

  strVolSys         = GetVolumes("VolSys",       "L", "N", objShell.ExpandEnvironmentStrings("%SYSTEMDRIVE%"), 1, "")

  Select Case True
    Case strClusterAction <> ""
      strVolProg    = GetVolumes("VolProg",      "L", "N", strVolSys,  1, "")
    Case Else  
      strVolProg    = GetVolumes("VolProg",      "L", "Y", strVolSys,  1, "")
  End Select

  strVolRoot        = GetVolumes("VolRoot",      "",  "Y", strVolProg, 1, strClusterAction)
  strMountRoot      = strVolRoot & ":\" & strMountRoot & "\"
  strVolDBA         = GetVolumes("VolDBA",       "X", "Y", strVolProg, 1, "")
  strVolDRU         = GetVolumes("VolDRU",       "X", "Y", strVolDBA,  1, "")
  strVolMDW         = GetVolumes("VolMDW",       "X", "Y", strVolDBA,  1, "")
  strVolTempWin     = GetVolumes("VolTempWin",   "L", "Y", strVolProg, 1, "")

  Select Case True
    Case strSetupSQLDB <> "YES"
      ' Nothing
    Case Else
      Call GetSQLDBVolumes()
  End Select

  Select Case True
    Case strSetupSQLAS <> "YES"
      ' Nothing
    Case Else
      Call GetSQLASVolumes()
  End Select

  Call SetupInstDTC()
  strVolDTC         = GetVolumes("VolDTC",       "",  "Y", strVolSys,  1, strActionDTC)

End Sub


Sub GetSQLDBVolumes()
  Call SetProcessId("0BFDA", "Get SQL DB Volumes")

  strVolBackup      = GetVolumes("VolBackup",    "X", "Y", strVolRoot, 0, strActionSQLDB)
  strVolData        = GetVolumes("VolData",      "",  "Y", strVolRoot, 0, strActionSQLDB)
  Select Case True
    Case strSQLVersion < "SQL2008"
      ' Nothing
    Case strFSLevel = "0"
      ' Nothing
    Case Else
      strVolDataFS  = GetVolumes("VolDataFS",    "",  "Y", strVolData, 1, strActionSQLDB)
  End Select
  strVolDataFT      = GetVolumes("VolDataFT",    "",  "Y", strVolData, 1, strActionSQLDB)
  strVolLog         = GetVolumes("VolLog",       "",  "Y", strVolProg, 0, strActionSQLDB)
  strVolSysDB       = GetVolumes("VolSysDB",     "",  "Y", strVolData, 1, strActionSQLDB)
  Select Case True
    Case (strSetupSQLDBCluster = "YES") And (strSQLVersion >= "SQL2012")
      strVolTemp    = GetVolumes("VolTemp",      "X", "Y", strVolData, 0, strActionSQLDB)
      strVolLogTemp = GetVolumes("VolLogTemp",   "X", "Y", strVolLog,  1, strActionSQLDB)
    Case Else
      strVolTemp    = GetVolumes("VolTemp",      "",  "Y", strVolData, 0, strActionSQLDB)
      strVolLogTemp = GetVolumes("VolLogTemp",   "",  "Y", strVolLog,  1, strActionSQLDB)
  End Select
  If strSQLVersion >= "SQL2014" Then
    strVolBPE       = GetVolumes("VolBPE",       "L", "Y", strVolTemp, 1, strActionSQLDB)
  End If

End Sub


Sub GetSQLASVolumes()
  Call SetProcessId("0BFDB", "Get SQL AS Volumes")

  strVolRootAS      = GetVolumes("VolRootAS",    "",  "Y", "",           1, strActionSQLAS)
  Select Case True
    Case strVolRootAS <> ""
      strVolBackupAS = GetVolumes("VolBackupAS", "X", "Y", strVolRootAS, 0, strActionSQLAS)
      strVolDataAS  = GetVolumes("VolDataAS",    "",  "Y", strVolRootAS, 0, strActionSQLAS)
      strVolLogAS   = GetVolumes("VolLogAS",     "",  "Y", strVolRootAS, 0, strActionSQLAS)
      strVolTempAS  = GetVolumes("VolTempAS",    "",  "Y", strVolDataAS, 1, strActionSQLAS)
    Case Else
      strVolBackupAS = GetVolumes("VolBackupAS", "X", "Y", strVolBackup, 0, strActionSQLAS)
      strVolDataAS  = GetVolumes("VolDataAS",    "",  "Y", strVolData,   0, strActionSQLAS)
      strVolLogAS   = GetVolumes("VolLogAS",     "",  "Y", strVolLog,    0, strActionSQLAS)
      strVolTempAS  = GetVolumes("VolTempAS",    "",  "Y", strVolTemp,   1, strActionSQLAS)
  End Select

End Sub


Function GetVolumes(strVolParam, strVolReq, strGetParam, strVolDefault, intVolNum, strItemAction)
  Call DebugLog("GetVolumes: " & strVolParam)
  Dim arrItems
  Dim intIdx, intUBound
  Dim strItem, strReq, strVolList
' Req: C=Must be Cluster volume, L=Must be Local volume, X=Either type of volume
' Source: C=CSV, D=Disk, M=Mount Point, N=Mapped Network Drive, S=Share
' Type:   C=Clustered, L=Local, X=Either

  Select Case True
    Case strVolReq <> ""
      strReq        = strVolReq
    Case strItemAction = strActionClusInst
      strReq        = "C"
    Case strItemAction = "ADDNODE"
      strReq        = "C"
    Case Else  
      strReq        = "L"
  End Select

  Select Case True
    Case strGetParam = "N"
      strVolList    = strVolDefault
    Case strType = "FULLPROG"
      strVolList    = strVolDefault
    Case Else
      strVolList    = GetParam(colBuild, strVolParam, "Drv" & Mid(strVolParam, 4), strVolDefault)
  End Select
  arrItems          = Split(strVolList, ",")
  intUBound         = UBound(arrItems)
  Call SetBuildfileValue(strVolParam & "Req", strReq)
  strVolFoundList   = ""
  For intIdx = 0 To intUBound
    strItem         = Trim(arrItems(intIdx))
    Select Case True
      Case (intVolNum > 0) And (intIdx + 1 > intVolNum)
        arrItems(intIdx) = ""
      Case strVolParam = "VolSys"
        If intVolNum > 0 Then
          strItem   = Left(strItem, intVolNum)
          arrItems(intIdx) = strItem
        End If
        Call CheckDriveLetter(strVolParam, strItem, intVolNum, "")
      Case CheckCSV(strVolParam, strItem) <> 0
        Call SetBuildfileValue(strVolParam & "Source",  "C")
        Call SetBuildfileValue(strVolParam & "Type",    "C")
        strCSVFound = "Y"
      Case CheckMountPoint(strVolParam, strItem) <> 0
        Call SetBuildfileValue(strVolParam & "Source",  "M")
        Call SetBuildfileValue(strVolParam & "Type",    "L")
      Case CheckShare(strVolParam, strItem) <> 0
        Call SetBuildfileValue(strVolParam & "Source",  "S")
        Call SetBuildfileValue(strVolParam & "Type",    "L")
      Case Else
        Call CheckDriveLetter(strVolParam, strItem, intVolNum, strItemAction)
        arrItems(intIdx) = strItem
    End Select
  Next

  strVolList        = Join(arrItems, ",")
  If Right(strVolList, 1) = "," Then
    strVolList      = Left(strVolList, Len(strVolList) - 1)
  End If
  Call SetBuildfileValue(strVolParam, strVolList)
  GetVolumes        = strVolList

End Function


Function CheckCSV(strVolParam, strVolume)
  Call DebugLog("CheckCSV: " & strVolParam & " for " & strVolume)
  Dim intCSVFound
  Dim strCSVFolder

  intCSVFound       = 0
  strCSVFolder      = UCase(strVolume)
  If Right(strCSVFolder, 1) = "\" Then
    strCSVFolder    = Left(strCSVFolder, Len(strCSVFolder) - 1)
  End If
  If Left(strCSVFolder, Len(strCSVRoot)) = strCSVRoot Then
    strCSVFolder    = Mid(strCSVFolder, Len(strCSVRoot) + 1)
    If InStr(strCSVFolder, "\") > 0 Then
      strCSVFolder  = Left(strCSVFolder, InStr(strCSVFolder, "\") - 1)
    End If
  End If

  Select Case True
    Case strOSVersion < "6.1"
      ' Nothing
    Case Instr(strCSVFolder, "\") > 0
      ' Nothing
    Case GetBuildfileValue("Vol" & UCase(strCSVFolder) & "Source") = "C" 
      intCSVFound   = 1
  End Select

  CheckCSV          = intCSVFound

End Function


Function CheckMountPoint(strVolParam, strVolume)
  Call DebugLog("CheckMountPoint: " & strVolParam & " for " & strVolume)
  Dim colMountPoints
  Dim objMountPoint
  Dim intMPFound
  Dim strMPDir, strMPVol

  intMPFound        = 0
  Select Case True
    Case Len(strVolume) = 1
      ' Nothing
    Case Left(strVolume, 2) = "\\"
      ' Nothing
    Case Instr(Ucase(strOSName), " XP") <> 0 
      ' Nothing
    Case Else
      Set colMountPoints = objWMI.ExecQuery("SELECT * FROM Win32_MountPoint")
      For Each objMountPoint In colMountPoints
        strMPDir    = objMountPoint.Directory
        strMPDir    = Replace(strMPDir, "\\", "\")
        strMPVol    = Mid(objMountPoint.Volume, InStr(objMountPoint.Volume, "{") + 1)
        strMPVol    = Left(strMPVol, InStr(strMPVol, "}") - 1)
        strDebugMsg1  = strMPVol
        strDebugMsg2  = strVolume
        If StrComp(strMPVol, strVolume, 1) = 0 Then
          intMPFound  = 1
        End If
      Next
  End Select

  CheckMountPoint   = intMPFound

End Function


Function CheckShare(strVolParam, strVolume)
  Call DebugLog("CheckShare: " & strVolParam & " for " & strVolume)

  Select Case True
    Case Left(strVolume, 2) = "\\"
      CheckShare    = BuildShareList(strVolume)
    Case Else
      CheckShare    = 0
  End Select

End Function


Function BuildShareList(strVolume)
  Call DebugLog("BuildShareList: " & strVolume)
  Dim strShare, strShareList, strReadAll, strRemoteServer, strRemoteShare
  Dim intFound, intDelim

  intDelim          = Instr(3, strVolume, "\")
  If intDelim = 0 Then
    Call SetBuildMessage(strMsgError, "Unable to find Share for " & strVolume)
  End If

  strRemoteServer   = Left(strVolume, intDelim - 1)
  strRemoteShare    = Mid(strVolume, intDelim + 1)
  If Instr(strRemoteShare, "\") > 0 Then
    strRemoteShare  = Left(strRemoteShare, Instr(strRemoteShare, "\") - 1)
  End If
  strRemoteRoot     = strRemoteServer & "\" & strRemoteShare

  intFound          = 0
  strShare          = ""
  strShareList      = GetBuildfileValue("ShareList")
  intFound          = GetShare(strRemoteServer, strRemoteShare, strShare)
  If intFound = 0 Then
    WScript.Sleep strWaitShort
    intFound        = GetShare(strRemoteServer, strRemoteShare, strShare)
  End If

  Select Case True
    Case intFound = 0
      Call SetBuildMessage(strMsgError, "Unable to find Share on " & strRemoteRoot & " for " & strVolume)
    Case strShare <> strRemoteRoot
      ' Nothing
    Case Instr(strShareList, strRemoteRoot) > 0
      ' Nothing
    Case Else
      strShareList  = LTrim(strShareList & " " & strShare)
  End Select

  Call SetBuildfileValue("ShareList", strShareList)
  BuildShareList    = intFound

End Function


Function GetShare(strRemoteServer, strRemoteShare, strShare)
  Call DebugLog("GetShare: " & strRemoteServer)
  Dim arrReadAll
  Dim objExec
  Dim strReadAll, strShareWork
  Dim intFound, intLines

  intFound          = 0
  strDebugMsg1      = "Remote Server:" & strRemoteServer
  strDebugMsg2      = "Remote Share:" & strRemoteShare

  strCmd            = "NET VIEW " & strRemoteServer
  Call DebugLog(strCmd)
  Set objExec       = objShell.Exec(strCmd)
  strReadAll        = Replace(objExec.StdOut.ReadAll, vbLf, "")
  arrReadAll        = Filter(Split(strReadAll, vbCr), " ")
  intLines          = UBound(arrReadAll)
  Call DebugLog("NET VIEW output:" & Cstr(intLines) & ">" & Join(arrReadAll, "< >") & "<")

  If intLines > 2 Then
    For intIdx = 2 To intLines - 1
      strShareWork  = arrReadAll(intIdx)
      strShareWork  = Left(strShareWork, Instr(strShareWork, " ") - 1)
      Select Case True
        Case strShareWork = strRemoteShare
          intFound  = 1
          strShare  = strRemoteRoot
        Case "\\" & strShareWork = strRemoteServer
          intFound  = 1
      End Select
    Next
  End If

  GetShare          = intFound

End Function


Sub CheckDriveLetter(strVolParam, strVolList, intVolNum, strItemAction)
  Call DebugLog("CheckDriveLetter: " & strVolList)
  Dim intIdx, intShare
  Dim strVolume, strVolPath, strVolSource, strVolType

  strVolume         = UCase(Left(strVolList, 1))
  strVolSource      = GetBuildfileValue("Vol" & strVolume & "Source")
  strVolType        = GetBuildfileValue("Vol" & strVolume & "Type")
  Select Case True
    Case StrComp(strCSVRoot, Left(strVolList, Len(strCSVRoot)), 1) = 0
      Call SetBuildMessage(strMsgError, "/" & strVolParam & ": can not be found: " & strVolList)
    Case strVolSource = "N"
      strVolPath    = GetBuildfileValue("Vol" & strVolume & "Path")
      strVolList    = strVolPath & Mid(strVolList, 3)
    Case strItemAction = "ADDNODE"
      ' Nothing
    Case Else
      Call CheckVolExists(strVolParam, strVolList, intVolNum, strItemAction)
  End Select

  Call SetBuildfileValue(strVolParam & "Source",  strVolSource)
  Call SetBuildfileValue(strVolParam & "Type",    strVolType)

End Sub


Sub CheckVolExists(strVolParam, strVolList, intVolNum, strItemAction)
  Call DebugLog("CheckVolExists: " & strVolList)
  Dim strVolume, strVolReq

  strVolReq         = GetBuildFileValue(strVolParam & "Req")
  For intIdx = 1 To Len(strVolList)
    strVolume       = UCase(Mid(strVolList, intIdx, 1))
    strPath         = strVolume & ":\"
    Select Case True
      Case InStr(strVolErrorList, strVolume) > 0
        ' Nothing
      Case objFSO.FolderExists(strPath)
        strVolFoundList = strVolFoundList & strVolume
      Case (strVolReq = "C") And (strItemAction = "ADDNODE")
        strVolFoundList = strVolFoundList & strVolume
      Case (strVolReq = "X") And (strItemAction = "ADDNODE")
        strVolFoundList = strVolFoundList & strVolume
      Case GetBuildfileValue("Vol" & strVolume & "Source") = "D"
        strVolFoundList = strVolFoundList & strVolume
      Case Else
        strVolErrorList = strVolErrorList & strVolume
        Call SetBuildMessage(strMsgError, "Drive for /" & strVolParam & ": can not be found: " & strPath)
    End Select
  Next

  If intVolNum > 0 Then
    strVolFoundList = Left(strVolFoundList, intVolNum)
  End If
  strVolList        = strVolFoundList

End Sub


Sub GetClusterData()
  Call SetProcessId("0BG", "Get details of Windows cluster if it exists")

  Call SetClusterVars()
  Call CheckClusterGroups()
  Call CheckClusterSubnet()
  Call CheckClusterNetwork()
  Call CheckNetworkAdapters()

End Sub


Sub SetClusterVars()
  Call SetProcessId("0BGA", "Set Cluster variables")

  Select Case True
    Case strOSVersion >= "6.3X"
      strClusterPath = strDirSys & "\Cluster\Reports"
      Call SetFileData("ClusterReport",    strClusterPath,      "", "Validation Report*.htm")
    Case strOSVersion >= "6.0"
      strClusterPath = strDirSys & "\Cluster\Reports"
      Call SetFileData("ClusterReport",    strClusterPath,      "", "Validation Report*.mht")
    Case Else
      strClusterPath = strPathSys & "LogFiles\Cluster"
      Call SetFileData("ClusterReport",    strClusterPath,      "", "ClCfgSrv.log")
  End Select
  strClusterReport  = GetBuildfileValue("ClusterReport")
  strClusterPath    = strClusterPath & "\" & strClusterReport

  If strSetupNetBind = "" Then
    Call SetParam("SetupNetBind",       strSetupNetBind,       "YES", "NetBind processing recommended for Cluster", "")
  End If
  If strSetupNetName = "" Then
    Call SetParam("SetupNetName",       strSetupNetName,       "YES", "NetName processing recommended for Cluster", "")
  End If

End Sub


Sub CheckClusterGroups()
  Call SetProcessId("0BGC", "Check Cluster Group details")
  Dim colClusGroups
  Dim objClusGroup
  Dim strGroupName

  Set colClusGroups = objCluster.ResourceGroups
  For Each objClusGroup In colClusGroups
    strGroupName    = objClusGroup.Name
    Select Case True
      Case strGroupName = "Cluster Group"
        ' Nothing
      Case Else
        Call SetClusterFound(strGroupName)
    End Select
  Next

End Sub


Sub SetClusterFound(strGroupName)
  Call SetProcessId("0BGCA", "Set Cluster Found Flag for: " & strGroupName)

  Select Case True
    Case strGroupName = strClusterGroupAO
      strClusterAOFound = "Y"
    Case strGroupName = strClusterGroupAS
      strClusterASFound = "Y"
    Case strGroupName = strClusterGroupSQL
      strClusterSQLFound = "Y"
  End Select

  If GetGroupAction(strGroupName) = strActionClusInst Then
    strCmd          = "CLUSTER """ & strClusterName & """ GROUP """ & strGroupName & """ /MOVETO:""" & strServer & """" 
    Call Util_RunExec(strCmd, "", strResponseYes, 0)
  End If

End Sub


Sub CheckClusterSubNet()
  Call SetProcessId("0BGD", "Get Cluster Subnet Details")
  Dim arrDependencies, arrAddresses
  Dim colDependent
  Dim strNameResource, strPathAddresses, strPathDependent, strPathDependencies, strPathName

' ClusSubnet: S=Single subnet, M=Multiple subnets
  strClusSubnet     = "S"
  If strOSVersion < "6.2" Then
    Exit Sub
  End If

  strPathName       = "HKLM\Cluster\ClusterNameResource"
  strNameResource   = objShell.RegRead(strPathName)
  strDebugMsg1      = "Name Resource: " & strNameResource

  strPathDependencies  = "HKLM\Cluster\Dependencies\"
  objWMIReg.EnumKey strHKLM, Mid(strPathDependencies, 6), arrDependencies
  For Each colDependent In arrDependencies
    strPathDependent   = strPathDependencies & colDependent
    strDebugMsg2       = "Dependent: " & colDependent
    If objShell.RegRead(strPathDependent & "\Dependent") = strNameResource Then
      strPathAddresses = strPathDependent & "\"
      objWMIReg.GetMultiStringValue strHKLM, Mid(strPathAddresses, 6), "Provider List", arrAddresses
      If UBound(arrAddresses) > 0 Then
        strClusSubnet  = "M"
      End If
    End If
  Next

End Sub


Sub CheckClusterNetwork()
  Call SetProcessId("0BGE", "Get details for Cluster Network")
  Dim colClusNetworks, colCommonProps
  Dim objClusNetwork
  Dim intClient, intCluster
  Dim strClusNetworkRole, strClusRole

  Call GetClusterIP()

  intClient           = 0
  intCluster          = 0
  strClusNetworkRole  = ""
  Set colClusNetworks = objCluster.Networks

  For Each objClusNetwork In colClusNetworks
    Set colCommonProps   = objClusNetwork.CommonProperties
    strClusRole          = colCommonProps.Item("Role").Value
    Select Case True
      Case (strClusIPV4Network = objClusNetwork.Name) And (strClusIPVersion = "IPv4")
        strClusNetworkRole = strClusRole
        If strClusNetworkRole >= "2" Then
          intClient   = 1
        End If
      Case (strClusIPV6Network = objClusNetwork.Name) And (strClusIPVersion = "IPv6")
        strClusNetworkRole = strClusRole
        If strClusNetworkRole >= "2" Then
          intClient   = 1
        End If
      Case strClusRole = "1"
        intCluster    = 1
      Case strClusRole = "2" 
        intClient     = 1
      Case strClusRole = "3"
        intClient     = 1
        intCluster    = 1
    End Select
  Next

  If strClusIPVersion = "" Then
    Call SetBuildMessage(strMsgError, "No Cluster IP Address found")
  End If
  If strClusNetworkRole < "2" Then
    Call SetBuildMessage(strMsgError, "Primary Cluster Network must not be 'Cluster Only'")
  End If
  If intCluster = 0 Then
    Call SetBuildMessage(strMsgWarning, "No 'Cluster Only' Network found.  Best practice recommends that a network is dedicated to Cluster traffic only")
  End If
  If intClient = 0 Then
    Call SetBuildMessage(strMsgError, "No Client Cluster Network found")
  End If

End Sub


Sub GetClusterIP()
  Call SetProcessId("0BGEA", "Get Cluster IP Details")
  Dim colClusNetworks, colResources, colNetInterfaces, colNetCProps, colNetIProps, colResourceProps
  Dim objResource, objNetInterface, objNetwork
  Dim strClusIPV4NetRole, strClusIPV6NetRole

  strClusIPVersion     = ""
  strClusIPV4Address   = ""
  strClusIPV4Network   = ""
  strClusIPV4NetRole   = ""
  strClusIPV6Address   = ""
  strClusIPV6Network   = ""
  strClusIPV6NetRole   = ""
  Set colClusNetworks  = objCluster.Networks
  Set colResources = objCluster.Resources
  Set colNetInterfaces = objCluster.NetInterfaces

  For Each objResource In colResources
    Select Case True
      Case Left(objResource.Name, 18) <> "Cluster IP Address" 
        ' Nothing
      Case objResource.CommonProperties.Item("Type").Value = "IP Address"
        Set colResourceProps = objResource.PrivateProperties
        For Each objNetInterface In colNetInterfaces
          strDebugMsg1       = "Interface: " & objNetInterface.Name
          Set colNetIProps   = objNetInterface.CommonROProperties
          Set colNetCProps   = Nothing
          For Each objNetwork In colClusNetworks
            If objNetwork.Name = colNetIProps.Item("Network").Value Then
              Set colNetCProps = objNetwork.CommonProperties
            End If
          Next
          Select Case True
            Case colResourceProps.Item("Network").Value <> colNetIProps.Item("Network").Value
              ' Nothing
            Case UCase(colNetIProps.Item("Node").Value) <> UCase(strServer)
              ' Nothing
            Case strClusIPV4NetRole >= CStr(colNetCProps.Item("Role").Value)
              ' Nothing
            Case Else
              strClusIPV4Network = colResourceProps.Item("Network").Value
              strClusIPV4Address = colResourceProps.Item("Address").Value
              strClusIPV4Mask    = colResourceProps.Item("SubnetMask").Value
              strClusIPV4NetRole = CStr(colNetCProps.Item("Role").Value)
          End Select
        Next
      Case strSQLVersion <= "SQL2005"
        ' Nothing
      Case objResource.CommonProperties.Item("Type").Value = "IPv6 Address"
        Set colResourceProps = objResource.PrivateProperties
        For Each objNetInterface In colNetInterfaces
          strDebugMsg1       = "Interface: " & objNetInterface.Name
          Set colNetIProps   = objNetInterface.CommonROProperties
          Set colNetCProps   = Nothing
          For Each objNetwork In colClusNetworks
            If objNetwork.Name = colNetIProps.Item("Network").Value Then
              Set colNetCProps = objNetwork.CommonProperties
            End If
          Next
          Select Case True
            Case colResourceProps.Item("Network").Value <> colNetIProps.Item("Network").Value
              ' Nothing
            Case UCase(colNetIProps.Item("Node").Value) <> UCase(strServer)
              ' Nothing
            Case strClusIPV6NetRole >= CStr(colNetCProps.Item("Role").Value)
              ' Nothing
            Case Else
              strClusIPV6Network = colResourceProps.Item("Network").Value
              strClusIPV6Address = colResourceProps.Item("Address").Value
              strClusIPV6Mask    = colResourceProps.Item("PrefixLength").Value
              strClusIPV6NetRole = CStr(colNetCProps.Item("Role").Value)
          End Select
        Next
    End Select
  Next

  Select Case True
    Case (strClusterTCP = "IPV4") And (strClusIPV4Network <> "")
      strClusIPVersion = "IPv4"
      strClusIPAddress = strClusIPV4Address
    Case (strClusterTCP = "IPV4") And (strClusIPV6Network <> "")
      strClusIPVersion = "IPv6"
      strClusIPAddress = strClusIPV6Address
    Case (strClusterTCP = "IPV6") And (strClusIPV6Network <> "")
      strClusIPVersion = "IPv6"
      strClusIPAddress = strClusIPV6Address
    Case (strClusterTCP = "IPV6") And (strClusIPV4Network <> "")
      strClusIPVersion = "IPv4"
      strClusIPAddress = strClusIPV4Address
  End Select

End Sub


Sub CheckNetworkAdapters()
  Call SetProcessId("0BGG", "Check Network Adapter Status")
  Dim colAdapters
  Dim objAdapter

  Set colAdapters   = objWMI.ExecQuery ("SELECT NetConnectionId from Win32_NetworkAdapter WHERE NetConnectionStatus >= 0 AND NetConnectionStatus <> 2")
  For Each objAdapter In colAdapters
    Call SetBuildMessage(strMsgError, "Cannot install SQL Cluster because Network Adapter is not useable: " & objAdapter.NetConnectionId)
  Next

End Sub


Sub GetPIDData()
  Call SetProcessId("0BH", "Get SQL Server PID")

  strPID            = GetPID(strPathSQLMedia)

  Select Case True
    Case strSetupStreamInsight <> "YES"
      ' Nothing
    Case strStreamInsightPID <> ""
      ' Nothing
    Case strSQLVersion <= "SQL2014"
      strStreamInsightPID = strPID
    Case Else
      strStreamInsightPID = GetPID(GetMediaPath(GetSQLMediaPath("SQL2014", "")))
  End Select

End Sub


Function GetPID(strPathSQLMedia)
  Call DebugLog("GetPID: " & strPathSQLMedia)
  Dim strFile, strFileText, strPID

  strFile           = FormatFolder(strPathSQLMedia & "x64") & "\DefaultSetup.ini"
  strPID            = ""

  If objFSO.FileExists(strFile) Then
    Set objFile     = objFSO.OpenTextFile(strFile, 1, False, GetFileType(strFile))
    strFileText     = objFile.ReadAll()
    objFile.Close
    intIdx          = Instr(strFileText, "PID=")
    If intIdx > 0 Then
      strPid        = Mid(strFileText, intIdx + 5, 29)
    End If
  End If

  Select Case True
    Case strPID <> ""
      Call DebugLog("PID Found")
    Case Else
      Call DebugLog("Using Evaluation PID")
      strPID        = "00000-00000-00000-00000-00000"
  End Select

  GetPID            = strPID

End Function


Function GetFileType(strFile)
  Call DebugLog("GetFileType: " & strFile)
' Adapted from https://groups.google.com/forum/#!topic/microsoft.public.scripting.vbscript/Yo-T-EMAAKU
  Dim objFile
  Dim strC1, strC2

  Set objFile       = objFSO.OpenTextFile(strFile)
  strC1             = objFile.Read(1)
  strC2             = objFile.Read(1)
  objFile.Close

  Select Case True
    Case Asc(strC1) <> 255
      GetFileType   = False ' ASCII
    Case Asc(strC2) <> 254
      GetFileType   = False ' ASCII
    Case Else
      GetFileType   = True  ' Unicode
  End Select

End Function


Sub GetMenuData()
  Call SetProcessId("0BI", "Get data for SQL Menus")

  Call GetSQLVersionMenus()

  Call SetBuildfileValue("MenuAdminTools",  GetMenu("MenuAdminTools",      "Administrative Tools"))
  Call SetBuildfileValue("MenuBOL",         GetMenu("MenuBOL",             "SQL Server Books Online"))
  Call SetBuildfileValue("MenuConfigTools", GetMenu("MenuConfigTools",     "Configuration Tools"))
  Call SetBuildfileValue("MenuPerfTools",   GetMenu("MenuPerfTools",       "Performance Tools"))
  Call SetBuildfileValue("MenuPrograms",    GetMenu("MenuPrograms",        "Programs"))
  Call SetBuildfileValue("MenuSQLAS",       GetMenu("MenuSQLAS",           "Analysis Services"))
  Call SetBuildfileValue("MenuSQLIS",       GetMenu("MenuSQLIS",           "Integration Services"))
  Call SetBuildfileValue("MenuSQLNS",       GetMenu("MenuSQLNS",           "Notification Services Command Prompt"))
  Call SetBuildfileValue("MenuSQLRS",       GetMenu("MenuSQLRS",           "Reporting Services"))

  Select Case True
    Case strOSVersion < "6.2"
      Call SetBuildfileValue("MenuAccessories", GetMenu("MenuAccessories", "Accessories"))
      Call SetBuildfileValue("MenuSystem",      GetMenu("MenuSystem",      "Accessories"))
    Case Else
      Call SetBuildfileValue("MenuAccessories", GetMenu("MenuAccessories", "Windows Accessories"))
      Call SetBuildfileValue("MenuSystem",      GetMenu("MenuSystem",      "Windows System"))
  End Select

  Select Case True
    Case strSQLVersion < "SQL2012"
      Call SetBuildfileValue("MenuSQLDocs", GetMenu("MenuSQLDocs",         "Documentation and Tutorials"))
    Case Else
      Call SetBuildfileValue("MenuSQLDocs", GetMenu("MenuSQLDocs",         "Documentation & Community"))
  End Select

  If strEdition = "EXPRESS" Then
    Call SetBuildfileValue("MenuSSMS", GetMenu("MenuSSMSExp",              "SQL Server Management Studio Express"))
  Else
    Call SetBuildfileValue("MenuSSMS", GetMenu("MenuSSMS",                 "SQL Server Management Studio"))
  End If

End Sub


Sub GetSQLVersionMenus()
  Call DebugLog("GetSQLVersionMenus:")
  Dim arrSQL
  Dim intUBound
  Dim strDefaultMenu, strVersion, strVersionMenu

  arrSQL            = Split(strSQLList, " ", -1)
  intUBound         = UBound(arrSQL)
  For intIdx = 0 To intUBound
    strVersion      = arrSQL(intIdx)
    strDefaultMenu  = Mid(strVersion, 4)
    If Len(strDefaultMenu) > 4 Then
      strDefaultMenu = Left(strDefaultMenu, 4) & " " & Mid(strDefaultMenu, 5)
    End If
    strVersionMenu  = GetMenu("Menu" & strVersion, "Microsoft SQL Server " & strDefaultMenu)
    Call SetBuildfileValue("Menu" & strVersion, strVersionMenu)
    Call SetBuildfileValue("Menu" & strVersion & "Flag",  CheckMenuExists("Menu" & strVersion, strVersionMenu))
    If strSQLVersion = strVersion Then
      Call SetBuildfileValue("MenuSQL", strVersionMenu)
    End If
  Next

End Sub


Function GetMenu(strMenu, strDefault)
  Call DebugLog("GetMenu: " & strMenu)
  Dim strMenuText

  strMenuText       = GetBuildfileValue(strMenu)
  If strMenuText = "" Then
    strMenuText     = GetParam(colStrings,            strMenu,              "",                    strDefault)
  End If

  GetMenu           = strMenuText

End Function


Function CheckMenuExists(strMenu, strMenuText)
  Call DebugLog("CheckMenuExists: " & strMenu)
  Dim strFlag

  strFlag           = GetBuildfileValue(strMenu & "Flag")
  strPath           = strAllUserProf & "\" & GetBuildfileValue("MenuPrograms") & "\" & strMenuText

  Select Case True
    Case strFlag <> ""
      ' Nothing
    Case objFSO.FileExists(strPath) 
      strFlag       = "Y"
    Case Else
      strFlag       = "N"
  End Select

  CheckMenuExists   = strFlag

End Function


Sub GetPathData()
  Call SetProcessId("0BJ", "Get data for Folder paths")
  Dim strRegPath, strWorkPathl, strWorkVol

  Select Case True
    Case strVolProg = strVolSys
      strDirProg    = strVolProg & Mid(strDirProgSys, 2) & "\" & strSQLProgDir
    Case Else
      strPath       = GetParam(colStrings,            "DirProg",            "",                    Mid(strDirProgSys, 4))
      strDirProg    = strVolProg & ":\" & strPath & "\" & strSQLProgDir
  End Select
  Call SetFolderPath("DirProg",           "VolProg",     "",           "",         strDirProg,                   "")

  strPathAddCompOrig  = GetParam(colStrings,          "PathAddComp",        "",                    "..\Additional Components")
  strPathAddComp    = GetMediaPath(strPathAddCompOrig)
  Select Case True
    Case strPathAddComp <> ""
      ' Nothing
    Case strPathAddCompOrig <> "..\Additional Components"
      ' Nothing
    Case Else
      strPathAddComp = GetMediaPath("..\..\Additional Components")
  End Select

  strPathFB         = GetMediaPath(strPathFB)
  strPathFBScripts  = strPathFB & "Build Scripts\"

  Select Case True
    Case strSQLVersion = "SQL2008"
      If (strClusterAction <> "") And (strSetupSlipstream <> "DONE") Then
        Call SetParam("SetupSlipstream",     strSetupSlipstream,       "YES", "Slipstream Media must be configured for Cluster installs", "")
      End If 
    Case strSQLVersion = "SQL2008R2"
      Select Case True
        Case (strClusterAction <> "") And (strSetupSlipstream <> "DONE") 
          Call SetParam("SetupSlipstream",   strSetupSlipstream,       "YES", "Slipstream Media must be configured for Cluster installs", "")
        Case Instr(strOSType, "CORE") > 0  
          Call SetParam("SetupSlipstream",   strSetupSlipstream,       "N/A", "", strListCore)
      End Select
    Case strSQLVersion >= "SQL2012"
      Call SetParam("SetupSlipstream",       strSetupSlipstream,       "N/A", "", strListSQLVersion)
  End Select
  
  Select Case True
    Case strSetupSlipstream = "DONE"
      strPathSQLSP  = ""
      strPCUSource  = GetMediaPath(GetParam(colStrings,   "PCUSource",      "",                    strPathSQLMedia & "PCU"))
      If strPCUSource = "" Then
        strPCUSource  = GetMediaPath(GetParam(colStrings, "PCUSource",      "",                    strPathSQLMedia & strSPLevel))
      End If
      strCUSource   = GetMediaPath(GetParam(colStrings,   "CUSource",       "",                    strPathSQLMedia & "CU"))
      If strCUSource = "" Then
        strCUSource  = GetMediaPath(GetParam(colStrings,  "CUSource",       "",                    strPathSQLMedia & strSPCULevel))
      End If
    Case Else
      strPathSQLSP  = GetMediaPath(strPathSQLSPOrig)
      strPCUSource  = ""
      strCUSource   = ""
  End Select

  If strUpdateSource = "" Then
    strUpdateSource = strPathSQLSP
  End If

  Select Case True
    Case strProcArc = "X86"
      Select Case True
        Case strClusterAction = ""
          strPathSSMS    = strDirProg & "\" & strSQLVersionNum & "\Tools\"
        Case Else
          strPathSSMS    = strDirProgSys & "\" & strSQLProgDir & "\" & strSQLVersionNum & "\Tools\"
      End Select
      strDirProgX86 = strDirProg
      strDirProgSysX86 = strDirProgSys
      strPathSSMSx86 = strPathSSMS
      strPathBOL     = strPathSSMS
      Select Case True
        Case strSQLVersion = "SQL2005"
          strSQLMediaArc = strPathSQLMedia
        Case Else
          strSQLMediaArc = strPathSQLMedia & strFileArc & "\"
      End Select
    Case strProcArc = "AMD64"
      strDirProgSysX86 = objFSO.GetAbsolutePathName(objShell.ExpandEnvironmentStrings("%ProgramFiles(x86)%"))
      strDirProgX86 = strVolProg & Mid(strDirProgSysX86, 2) & "\" & strSQLProgDir
      Select Case True
        Case strClusterAction = ""
          strPathSSMS    = strDirProg & "\" & strSQLVersionNum & "\Tools\"
          strPathSSMSx86 = strDirProgX86 & "\" & strSQLVersionNum & "\Tools\"
        Case Else
          strPathSSMS    = strDirProgSys & "\" & strSQLProgDir & "\" & strSQLVersionNum & "\Tools\"
          strPathSSMSx86 = strDirProgSysX86 & "\" & strSQLVersionNum & "\Tools\"
      End Select
      Select Case True
        Case strSQLVersion <= "SQL2005"
          If strVolProg = strVolsys Then
            strPathSSMSx86 = strDirProgX86 & "\" & strSQLVersionNum & "\Tools\"
          Else 
            strPathSSMSx86 = strDirProg & " (x86)\" & strSQLVersionNum & "\Tools\"
          End If
          strPathBOL     = strPathSSMSx86
          strSQLMediaArc = strPathSQLMedia
        Case strSQLVersion = "SQL2008"
          strPathBOL     = strPathSSMSx86
          strSQLMediaArc = strPathSQLMedia & strFileArc & "\"
        Case strSQLVersion = "SQL2008R2"
          strPathBOL     = strPathSSMSx86
          strSQLMediaArc = strPathSQLMedia & strFileArc & "\"
        Case strSQLVersion >= "SQL2012"
          strPathBOL     = strPathSSMS
          strSQLMediaArc = strPathSQLMedia & strFileArc & "\"
      End Select
  End Select
  Call SetFolderPath("DirProgX86",        "VolProg",     "",           "",         strDirProgX86,                "")

  Select Case True
    Case strInstRegAS <> ""
      ' Nothing
    Case strType = "CLIENT"
      strInstRegAS = strSQLVersionNum & "\Tools"
    Case Else
      strPath       = Mid(strHKLMSQL, 6) & "Instance Names\OLAP\"
      objWMIReg.GetStringValue strHKLM, strPath, strInstASSQL, strInstRegAS
      If IsNull(strInstRegAS) Then
        strInstRegAS  = ""
      End If
  End Select

  Select Case True
    Case strInstRegRS <> ""
      ' Nothing
    Case strType = "CLIENT"
      strInstRegRS = strSQLVersionNum & "\Tools"
    Case Else
      strPath       = Mid(strHKLMSQL, 6) & "Instance Names\RS\"
      objWMIReg.GetStringValue strHKLM, strPath, strInstance, strInstRegRS
      If IsNull(strInstRegRS) Then
        strInstRegRS  = ""
      End If
  End Select

  Select Case True
    Case strInstRegSQL <> ""
      ' Nothing
    Case strType = "CLIENT"
      strInstRegSQL = strSQLVersionNum & "\Tools"
    Case Else
      strPath       = Mid(strHKLMSQL, 6) & "Instance Names\SQL\"
      objWMIReg.GetStringValue strHKLM, strPath, strInstance, strInstRegSQL
      If IsNull(strInstRegSQL) Then
        strInstRegSQL = ""
      End If
  End Select

  If Right(strDirDBA, 1) = "\" Then
    strDirDBA       = Left(strDirDBA, Len(strDirDBA) - 1)
  End If
  strPathVS         = strDirProgSysX86 & "\Microsoft Visual Studio " & strVSVersionPath & "\Common7\"
  strPSInstall      = """" & strDirSys & "\Microsoft.NET\Framework\v4.0.30319\InstallUtil.exe"""
  strRegPath        = GetRegPath(strHKLMSQL, strInstRegSQL)

  strDiscoverFile   = GetParam(Null,                  "DiscoverFile",       "",                    strDirServInst)
  strDiscoverFolder = GetParam(Null,                  "DiscoverFolder",     "",                    strPathFBStart)

  Call SetFolderPath("DirDBA",            "VolDBA",      "",           "",         strDirDBA,                    "")
  Call SetFolderPath("DirDRU",            "VolDRU",      "",           strDirSQL,  "",                           "")
  Call SetFolderPath("DirMDW",            "VolMDW",      "",           strDirDBA,  "MDW.Cache",                  "")

  Select Case True
    Case strSetupTempWin = "YES"
      Call SetFolderPath("PathTemp",      "VolTempWin",  "",           "",         strDirTempWin,                "")
      Call SetFolderPath("PathTempUser",  "VolTempWin",  "",           "",         strDirTempUser,               "")
    Case Else
      Call SetFolderPath("PathTemp",      "VolTempWin",  "",           "",         "",                           objShell.ExpandEnvironmentStrings(colSysEnvVars("TEMP")))
      Call SetFolderPath("PathTempUser",  "VolTempWin",  "",           "",         "",                           objShell.ExpandEnvironmentStrings(colUsrEnvVars("TEMP")))
  End Select

  If strSetupSQLDB = "YES" Then
    Call SetFolderPath("DirData",         "VolData",     "SqlAccount", strDirSQL,  strInstNode & ".Data",        GetRegValue(GetRegPath(strRegPath, "\MSSQLServer\DefaultData")))
    Call SetFolderPath("DirDataIS",       "VolData",     "IsAccount",  strDirSQL,  strInstNodeIS & ".Data",      "")
    Call SetFolderPath("DirLog",          "VolLog",      "SqlAccount", strDirSQL,  strInstNode & ".Log",         GetRegValue(GetRegPath(strRegPath, "\MSSQLServer\DefaultLog")))
    Select Case True
      Case GetBuildfileValue("VolBackupSource") = "S"
        Call SetFolderPath("DirBackup",   "VolBackup",   "",           strDirSQL,  "",                           GetRegValue(GetRegPath(strRegPath, "\MSSQLServer\BackupDirectory")))
      Case Else
        Call SetFolderPath("DirBackup",   "VolBackup",   "",           strDirSQL,  strInstNode & ".Backup",      GetRegValue(GetRegPath(strRegPath, "\MSSQLServer\BackupDirectory")))
    End Select
    Select Case True
      Case strVolSysDB = strVolProg 
        Call SetFolderPath("DirSysDB",    "VolSysDB",    "SqlAccount", "",         strDirProg,                   GetRegValue(GetRegPath(strRegPath, "\Setup\SQLDataRoot")))
      Case Else
        Call SetFolderPath("DirSysDB",    "VolSysDB",    "SqlAccount", "",         strDirSQL,                    GetRegValue(GetRegPath(strRegPath, "\Setup\SQLDataRoot")))
    End Select
    Call SetFolderPath("DirTemp",         "VolTemp",     "SqlAccount", strDirSQL,  strInstNode & ".Data",        "")
    Call SetFolderPath("DirLogTemp",      "VolLogTemp",  "SqlAccount", strDirSQL,  strInstNode & ".Log",         "")
    If strSQLVersion >= "SQL2014" Then
      Call SetFolderPath("DirBPE",        "VolBPE",      "",           strDirSQL,  strInstNode & ".BPE",         "")
    End If
    Select Case True
      Case strSQLVersion < "SQL2008"
        ' Nothing
      Case strFSLevel = "0"
        ' Nothing
      Case Else
        Call SetFolderPath("DirDataFS",   "VolDataFS",   "",           strDirSQL,  strInstNode & ".Filestream",  "")
    End Select
    Call SetFolderPath("DirDataFT",       "VolDataFT",   "FtAccount",  strDirSQL,  strInstNode & ".FTData",      "")
    Call SetSystemDataBackup()
  End If

  If strSetupSQLAS = "YES" Then
    strRegPath      = GetRegPath(strHKLMSQL, strInstRegAS)
    Call SetFolderPath("DirDataAS",       "VolDataAS",   "AsAccount",  strDirSQL,  strInstNodeAS & ".Data",      GetRegValue(GetRegPath(strRegPath, "\Setup\DataDir")))
    Call SetFolderPath("DirLogAS",        "VolLogAS",    "AsAccount",  strDirSQL,  strInstNodeAS & ".Log",       "")
    Call SetFolderPath("DirTempAS",       "VolTempAS",   "AsAccount",  strDirSQL,  strInstNodeAS & ".Temp",      "")
    Select Case True
      Case GetBuildfileValue("VolBackupASSource") = "S"
        Call SetFolderPath("DirBackupAS", "VolBackupAS", "AsAccount",  strDirSQL,  "SSAS",                       "")
      Case Else
        Call SetFolderPath("DirBackupAS", "VolBackupAS", "AsAccount",  strDirSQL,  strInstNodeAS & ".Backup",    "")
    End Select
    Select Case True
      Case (strSQLVersion >= "SQL2012") And (strSPLevel < "RTM")
        strDirASDLL = strDirProg & "\" & strSQLVersionNum & "\Setup Bootstrap\" & strSQLVersion & strSPLevel & "\" & strFileArc
      Case strSQLVersion >= "SQL2017"
        strDirASDLL = strDirProg & "\" & strSQLVersionNum & "\Setup Bootstrap\" & strSQLVersion & "\" & strFileArc
      Case strSQLVersion >= "SQL2012"
        strDirASDLL = strDirProg & "\" & strSQLVersionNum & "\Setup Bootstrap\SQLServer" & Mid(strSQLVersion, 4) & "\" & strFileArc
      Case strSQLVersion >= "SQL2008"
        strDirASDLL = strDirProgX86 & "\" & strSQLVersionNum & "\Setup Bootstrap\Release\" & strFileArc
    End Select
  End If

  strRegPath        = GetRegPath(strHKLMSQL, strInstRegRS)
  Select Case True
    Case strSetupSQLRS <> "YES"
      ' Nothing
    Case strSetupPowerBI = "YES"
      Call SetFolderPath("PathSSRS",      "VolProg",     "RsAccount",  "",         strDirProgSys & "\Microsoft Power BI Report Server\" & strInstRSSQL, GetRegValue(GetRegPath(strRegPath, "\Setup\InstallRootDirectory")) & "\" & strInstRSSQL)
    Case Else
      Call SetFolderPath("PathSSRS",      "VolProg",     "RsAccount",  "",         strDirProg & "\" & strInstRegRS & "\Reporting Services", GetRegValue(GetRegPath(strRegPath, "\Setup\SQLPath")))
  End Select

  Select Case True
    Case strSetupMDS <> "YES"
      ' Nothing
    Case strSQLVersion = "SQL2008R2"
      Call SetFolderPath("PathMDS",       "VolProg",     "MDSAccount", "",         strDirProg & "\Master Data Services", "")
    Case Else
      Call SetFolderPath("PathMDS",       "VolProg",     "MDSAccount", "",         strDirProg & "\" & strSQLVersionNum & "\Master Data Services", "")
  End Select
  
End Sub


Function GetMediaPath(strMedia)
  Call DebugLog("GetMediaPath: " & strMedia)
  Dim strPath, strPathAlt

  strPath           = strMedia
  Select Case True
    Case Len(strPath) = 1
      strPath       = strPath & ":"
    Case Right(strPath, 1) = "\" 
      strPath       = Left(strPath, Len(strPath) - 1)
  End Select

  strPathAlt        = strPath
  Select Case True
    Case Left(strPath, 2) = "\\"
      ' Nothing
    Case (Left(strPath, 3) = "..\") And (Right(strPathFB, 1) = "\")
      strPath       = strPathFB & strPath
      Select Case True
        Case Instr(strPathAlt, "_") > 0
          strPathAlt = strPathFB & "..\" & Left(strPathAlt, Instr(strPathAlt, "_") - 1) & Mid(strPathAlt, 3)
        Case Else
          strPathAlt = strPath
      End Select
    Case Left(strPath, 3) = "..\"
      strPath       = strPathFB & "\" & strPath
      Select Case True
        Case Instr(strPathAlt, "_") > 0
          strPathAlt = strPathFB & "\..\" & Left(strPathAlt, Instr(strPathAlt, "_") - 1) & Mid(strPathAlt, 3)
        Case Else
          strPathAlt = strPath
      End Select
    Case (Mid(strPath, 2, 1) = ":") And (GetBuildfileValue("Vol" & Left(strPath, 1) & "Source") = "N")
      strPath       = GetBuildfileValue("Vol" & Left(strPath, 1) & "Path") & Mid(strPath, 3)
      strPathAlt    = strPath
  End Select

  strPath           = CheckMediaPath(strPath)
  If strPath = "" Then
    strPath         = CheckMediaPath(strPathAlt)
  End If

  Call DebugLog(" Path found: " & strPath)
  GetMediaPath      = strPath

End Function


Function CheckMediaPath(strPath)
  Call DebugLog("CheckMediaPath:" & strPath)
  Dim strPathWork

  strPathWork       = strPath
  Select Case True
    Case objFSO.FolderExists(strPathWork)
      Set objFolder = objFSO.GetFolder(strPathWork)
      strPathWork   = objFolder.Path
      Select Case True
        Case Left(strPathWork, 2) = "\\"
          ' Nothing
        Case GetBuildfileValue("Vol" & Left(strPathWork, 1) & "Source") = "N" 
          strPathWork = GetBuildfileValue("Vol" & Left(strPathWork, 1) & "Path") & Mid(strPathWork, 3)
      End Select
    Case Else
      strPathWork   = ""
  End Select

  Select Case True
    Case strPathWork = ""
      ' Nothing
    Case Right(strPathWork, 1) <> "\" 
      strPathWork   = strPathWork & "\"
  End Select

  CheckMediaPath    = strPathWork

End Function


Function GetRegPath(strRegBase, strRegItem)
  Call DebugLog("GetRegPath: " & strRegItem)
  Dim strRegPath

  Select Case True
    Case (strRegBase = "") Or (IsNull(strRegBase))
      strRegPath    = ""
    Case (strRegItem = "") Or (IsNull(strRegItem))
      strRegPath    = ""
    Case Else
      strRegPath    = strRegBase & strRegItem
  End Select

  Call DebugLog("Reg path: " & strRegPath)
  GetRegPath       = strRegPath

End Function


Function GetRegValue(strRegPath)
  Call DebugLog("GetRegValue: " & strRegPath)
  Dim strRegBase, strRegItem, strRegValue

  Select Case True
    Case strRegPath = ""
      strRegValue   = ""
    Case Else
      strRegBase    = Left(strRegPath, InStrRev(strRegPath, "\") - 1)
      strRegItem    = Mid(strRegPath, InStrRev(strRegPath, "\") + 1)
      If Left(strRegBase, 5) = "HKLM\" THen
        strRegBase  = Mid(strRegBase, 6)
      End If
      objWMIReg.GetStringValue strHKLM,strRegBase,strRegItem,strRegValue
      If IsNull(strRegValue) Then
        strRegValue = ""
      End If
  End Select

  Call DebugLog("Reg value: " & strRegValue)
  GetRegValue       = strRegValue

End Function


Sub SetFolderPath(strVarName, strVolVar, strAccountVar, strRoot, strPath, strAltPath)
  Call DebugLog("SetFolderPath: " & strVarName & " for " & strPath)
  Dim arrVolumes
  Dim strAccountParm, strAccountType, strPathBase, strPathWork, strPathDir, strRootWork, strVolSource, strVolWork

  strAccountParm    = "/" & UCase(GetBuildfileValue(strAccountVar & "Name")) & ":"
  strAccountType    = GetBuildfileValue(strAccountVar & "Type")
  strVolSource      = GetBuildfileValue(strVolVar & "Source")

  Select Case True
    Case strAltPath = ""
      strPathWork   = strPath
      strRootWork   = "\" & strRoot
      strVolWork    = GetBuildfileValue(strVolVar)
    Case CheckCSV(strVarName, strAltPath) <> 0
      strPathWork   = Mid(strAltPath, Len(strCSVRoot) + 1)
      strVolWork    = strCSVRoot & Left(strPathWork, Instr(strPathWork, "\") - 1)
      strPathWork   = Mid(strPathWork, Instr(strPathWork, "\") + 1)
      strRootWork   = "\" & Left(strPathWork, Instr(strPathWork, "\"))
      strPathWork   = Mid(strPathWork, Instr(strPathWork, "\") + 1)
    Case CheckShare(strVarName, strAltPath) <> 0
      strPathWork   = Mid(strAltPath, Len(strRemoteRoot) + 2)
      strVolWork    = strRemoteRoot
      strRootWork   = ""
    Case Else
      strPathWork   = strAltPath
      strVolWork    = ""
      strRootWork   = ""
      If Mid(strPathWork, 2, 2) = ":\" Then
        strVolWork  = Left(strPathWork, 1)
        strRootWork = "\"
      End If
  End Select
  Select Case True
    Case strRootWork = ""
      ' Nothing
    Case Right(strRootWork, 1) = "\"
      ' Nothing
    Case Else
      strRootWork   = strRootWork & "\"
  End Select
  If Mid(strPathWork, 2, 2) = ":\" Then
    strPathWork     = Mid(strPathWork, 4)
  End If

  arrVolumes        = Split(strVolWork, ",")
  Select Case True
    Case strVolSource = "D"
      strPathBase   = ":" & strRootWork & strPathWork
      strPathDir    = Left(strVolWork, 1) & strPathBase
    Case strVolSource = "C"
      strPathBase   = strRootWork & strPathWork
      strPathDir    = Trim(arrVolumes(0)) & strPathBase
      Select Case True
        Case Instr(UCase(" VolDataAS VolLogAS VolTempAS "), UCase(" " & strVolVar & " ")) > 0
          Call SetBuildMessage(strMsgError, "Analysis Services can not be installed to a Cluster Shared Volume (CSV): " & strVolVar)
        Case strSQLVersion <= "SQL2008"
          Call SetBuildMessage(strMsgError, "Cluster Shared Volume cannot be used for " & strSQLVersion)
        Case strSetupSQLDBCluster = "YES"
          ' Nothing
        Case (strSetupAlwaysOn = "YES") And (Instr(UCase(" VolDataFS VolSysDB VolTemp VolLogTemp "), UCase(" " & strVolVar & " ")) > 0)
          Call SetBuildMessage(strMsgError, "Cluster Shared Volume cannot be used for /" & strVolVar & ": with Always On")
      End Select
    Case (strVolSource = "M") And (strVolVar = strVolRootAS)
      strPathBase   = Mid(strMountRoot, 2) & strPathWork
      strPathDir    = strRootAS & strPathBase
    Case strVolSource = "M" 
      strPathBase   = strRootWork & strPathWork
      strPathDir    = strMountRoot & strPathBase
    Case strVolSource = "N" 
      strPathBase   = strRootWork & strPathWork
      strPathDir    = strMountRoot & strPathBase
      Select Case True
        Case Instr(UCase(" VolDataAS VolLogAS VolTempAS "), UCase(" " & strVolVar & " ")) > 0
          Call SetBuildMessage(strMsgError, "Analysis Services can not be installed to a Network Drive: " & strVolVar)
        Case strSQLVersion > "SQL2008R2"
          ' Nothing
        Case (Instr(UCase(" VolData VolLog VolTemp VolTempLog "), UCase(" " & strVolVar & " ")) > 0)
          Call SetBuildMessage(strMsgError, strSQLVersion & " can not be installed to a Network Drive: " & strVolVar)
        Case strAccountVar = "FtAccount"
          ' Nothing
        Case (strAccountType = "L") Or (strAccountType = "S")
          Call SetBuildMessage(strMsgError, strAccountParm & " parameter must be a domain account")
      End Select
    Case Else ' VolSource "S"
      strPathBase   = "\" & strPathWork
      strVolWork    = Trim(arrVolumes(0))
      If Len(strVolWork) = 1 Then
        strVolWork  = strVolWork & ":"
      End If
      strPathDir    = strVolWork & strPathBase
      Select Case True
        Case Instr(UCase(" VolDataAS VolLogAS VolTempAS "), UCase(" " & strVolVar & " ")) > 0 
          Call SetBuildMessage(strMsgError, "Analysis Services can not be installed to a File Share: " & strVolVar)
        Case strSQLVersion > "SQL2008R2"
          ' Nothing
        Case (Instr(UCase(" VolData VolLog VolTemp VolTempLog "), UCase(" " & strVolVar & " ")) > 0) 
          Call SetBuildMessage(strMsgError, strSQLVersion & " can not be installed to a File Share " & strVolVar)
        Case strAccountVar = "FtAccount"
          ' Nothing
        Case (strAccountType = "L") Or (strAccountType = "S")
          Call SetBuildMessage(strMsgError, strAccountParm & " parameter must be a domain account")
      End Select
  End Select

  If Right(strPathBase, 1) = "\" Then
    strPathBase     = Left(strPathBase, Len(strPathBase) - 1)
    strPathDir      = Left(strPathDir, Len(strPathDir) - 1)
  End If

  Call SetBuildfileValue(strVarName, strPathDir)
  Call SetBuildfileValue(strVarName & "Base", strPathBase)

End Sub


Sub SetSystemDataBackup()
  Call DebugLog("SetSystemDataBackup:")

  strPath           = GetBuildfileValue("DirBackup")

  If Instr(strPath, "AdHocBackup") > 0 Then
    strPath         = Left(strPath, Instr(strPath, "AdHocBackup") - 1)
  End If
  If Right(strPath, 1) <> "\" Then
    strPath         = strPath & "\"
  End If

  Select Case True
    Case strSetupSQLDBCluster = "YES"
      Call SetBuildfileValue("DirSystemDataBackup", strPath & "SystemDataBackup\" & strClusterNameSQL)
    Case Else
      Call SetBuildfileValue("DirSystemDataBackup", strPath & "SystemDataBackup\" & strDirServInst)
  End Select

  Select Case True
    Case strSetupAlwaysOn = "YES"
      Call SetBuildfileValue("DirSystemDataShared", strPath & "SystemDataBackup\" & strClusterGroupAO)
    Case strSetupSQLDBCluster = "YES"
      Call SetBuildfileValue("DirSystemDataShared", strPath & "SystemDataBackup\" & strClusterNameSQL)
    Case Else
      Call SetBuildfileValue("DirSystemDataShared", strPath & "SystemDataBackup\" & strDirServInst)
  End Select

End Sub


Sub GetServerData()
  Call SetProcessId("0BK", "Get data for Role Servers")

  Call ParseRoleServer(strCatalogServer, strCatalogServerName, strCatalogInstance)

  Select Case True
    Case strManagementServer = "" 
      strMSSupplied    = ""
    Case UCase(strManagementServer) = "YES"
      strManagementServer = strServer & "\" & strInstance
      strMSSupplied    = "Y"
    Case Else
      strMSSupplied    = "Y"
  End Select

  Select Case True
    Case IsNull(strManagementServerRes) 
      ' Nothing
    Case strManagementServerRes = ""
      ' Nothing
    Case Else
      strMSSupplied       = "Y"
      strManagementServer = strManagementServerRes
  End Select

  Call ParseRoleServer(strManagementServer, strManagementServerName, strManagementInstance)

  Select Case True
    Case strMSSupplied = ""
      SetManagementServerOptions("NO")
    Case (strManagementServerName = strUCServer)       And (strManagementInstance = strInstance)
      SetManagementServerOptions("YES")
    Case (strManagementServerName = strClusterNameSQL) And (strManagementInstance = strInstance)
      SetManagementServerOptions("YES")
    Case Else
      SetManagementServerOptions("NO")
  End Select

  Call SetupInstDTC()
  Call SetupInstRS()

End Sub


Sub ParseRoleServer(ByRef strRoleServer, ByRef strRoleServerName, ByRef strRoleInstance)
  Call SetProcessId("0BKA", "Parse role server " & strRoleServer)
  Dim strPort

  strPort           = strTCPPort
  intIdx            = Instr(strRoleServer, "\")
  Select Case True
    Case intIdx > 0
      strRoleServerName = Left(strRoleServer, intIdx - 1)
      strRoleInstance   = Mid(strRoleServer, intIdx + 1)
    Case strRoleServer <> ""
      strRoleServerName = strRoleServer
      strRoleInstance   = strInstance
    Case strSetupAlwaysOn = "YES"
      strRoleServerName = strClusterGroupAO
      strRoleInstance   = ""
    Case strSetupSQLDBCluster = "YES"
      strRoleServerName = strClusterNameSQL
      strRoleInstance   = strInstance
    Case Else
      strRoleServerName = strUCServer
      strRoleInstance   = strInstance
  End Select

  Select Case True
    Case Not (strRoleServerName = strClusterName Or strRoleServerName = strClusterBase) 
      ' Nothing
    Case strSetupAlwaysOn = "YES"
      strRoleServerName = strClusterGroupAO
      strRoleInstance   = ""
    Case strSetupSQLDBCluster = "YES"
      strRoleServerName = strClusterNameSQL
    Case Else
      strRoleServerName = strUCServer
  End Select
  intIdx            = Instr(strRoleInstance, ":")
  If intIdx > 0 Then
    strPort         = Mid(strRoleInstance, intIdx + 1)
    strRoleInstance = Left(strRoleInstance, (intIdx - 1))
  End If

  Select Case True
    Case strRoleInstance <> ""
      strRoleServer = strRoleServerName & "\" & strRoleInstance
    Case Else
      strRoleServer = strRoleServerName
  End Select
  If (strPort > "") And (strPort <> "1433") Then
    strRoleServer   = strRoleServer & ":" & strPort
  End If

  strRoleServerName = GetAddress(strRoleServerName, "", "Y")

End Sub


Sub SetManagementServerOptions(strMSOption)
  Call SetProcessId("0BKB", "Set Management Server Options: " & strMSOption)
  Dim strMessage

  Select Case True
    Case strMSOption = "YES"
      strMessage    = "installed by default with Management Server"
    Case Else
      strMessage    = "not installed by default except with Management Server"
  End Select

  Select Case True
    Case strSQLVersion < "SQL2012"
      Call SetParam("SetupDRUCtlr",          strSetupDRUCtlr,          "N/A",    "", strListSQLVersion)
    Case strSetupDRUCtlr = ""
      Call SetParam("SetupDRUCtlr",          strSetupDRUCtlr,          strMSOption,"Distributed Replay Controller " & strMessage, "")
  End Select

  Select Case True
    Case strSQLVersion < "SQL2012"
      Call SetParam("SetupDQ",               strSetupDQ,               "N/A",    "", strListSQLVersion)
    Case strSetupSQLDB <> "YES"
      Call SetParam("SetupDQ",               strSetupDQ,               "N/A",    "", strListSQLDB)
    Case strSetupDQ = ""
      Call SetParam("SetupDQ",               strSetupDQ,               strMSOption,"Data Quality Services " & strMessage, "")
  End Select

  Select Case True
    Case strSQLVersion < "SQL2017"
      Call SetParam("SetupISMaster",         strSetupISMaster,         "N/A",    "", strListSQLVersion)
    Case strSetupISMaster = ""
      Call SetParam("SetupISMaster",         strSetupISMaster,         strMSOption,"SSIS Scaleout Master " & strMessage, "")
  End Select

  Select Case True
    Case strSetupISMaster <> "YES"
      ' Nothing
    Case strIsWorkerMaster <> ""
      ' Nothing
    Case Else
      strIsWorkerMaster = strManagementServerName
  End Select    

  Select Case True
    Case Instr(strOSType, "CORE") > 0
      Call SetParam("SetupMDS",              strSetupMDS,              "N/A",    "", strListCore)
    Case strSQLVersion < "SQL2008R2"
      Call SetParam("SetupMDS",              strSetupMDS,              "N/A",    "", strListSQLVersion)
    Case strSetupSQLDB <> "YES"
      Call SetParam("SetupMDS",              strSetupMDS,              "N/A",    "", strListSQLDB)
    Case strSetupMDS = ""
      Call SetParam("SetupMDS",              strSetupMDS,              strMSOption,"Master Data Services " & strMessage, "")
  End Select

  Select Case True
    Case strSQLVersion < "SQL2008"
      Call SetParam("SetupManagementDW",     strSetupManagementDW,     "N/A",    "", strListSQLVersion)
    Case strSetupSQLDB <> "YES"
      Call SetParam("SetupManagementDW",     strSetupManagementDW,     "N/A",    "", strListSQLDB)
    Case strSetupManagementDW = "" 
      Call SetParam("SetupManagementDW",     strSetupManagementDW,     strMSOption,"Management Data Warehouse " & strMessage, "")
  End Select

  Select Case True
    Case strSQLVersion < "SQL2016"
      Call SetParam("SetupAnalytics",        strSetupAnalytics,        "N/A",    "", strListSQLVersion)
    Case strSetupSQLDB <> "YES"
      Call SetParam("SetupAnalytics",        strSetupAnalytics,        "N/A",    "", strListSQLDB)
    Case strSetupAnalytics = ""
      Call SetParam("SetupAnalytics",        strSetupAnalytics,        strMSOption,"Advanced Analytics " & strMessage, "")
    Case strSetupAnalytics <> "YES"
      ' Nothing
    Case strExtSvcAccount = ""
      Call SetBuildMessage(strMsgError, "/EXTSVCACCOUNT: parameter must be supplied")
    Case strSetupSQLDBCluster <> "YES"
      ' Nothing 
    Case GetBuildfileValue("ExtSvcAccountType") = "L"
      Call SetBuildMessage(strMsgError, "/EXTSVCACCOUNT: parameter must be a domain account")
    Case GetBuildfileValue("ExtSvcAccountType") = "S"
      Call SetBuildMessage(strMsgError, "/EXTSVCACCOUNT: parameter must be a domain account")
  End Select

  Select Case True
    Case Instr(strOSType, "CORE") > 0
      Call SetParam("SetupPolyBase",         strSetupPolyBase,         "N/A",    "", strListCore)
    Case strSQLVersion < "SQL2016"
      Call SetParam("SetupPolyBase",         strSetupPolyBase,         "N/A",    "", strListSQLVersion)
    Case strSetupSQLDB <> "YES"
      Call SetParam("SetupPolyBase",         strSetupPolyBase,         "N/A",    "", strListSQLDB)
    Case strSetupPolyBase <> "YES"
      ' Nothing
    Case strPBEngSvcAccount = ""
      Call SetParam("SetupPolyBase",         strSetupPolyBase,         "NO",     "PolyBase Service Accounts not supplied", "")
    Case Else
      Call SetParam("SetupPolyBase",         strSetupPolyBase,         strMSOption,"PolyBase " & strMessage, "")
  End Select

  Select Case True
    Case strSetupPowerBI = ""
      Call SetParam("SetupPowerBI",          strSetupPowerBI,          strMSOption,"Power BI Server " & strMessage, "")
      Call SetupInstRS()
  End Select

  Select Case True
    Case strSetupAnalytics <> "YES"
      ' Nothing
    Case strSetupPython = ""
      Call SetParam("SetupPython",           strSetupPython,           strMSOption,"Python " & strMessage, "")
  End Select

  Select Case True
    Case strSetupAnalytics <> "YES"
      ' Nothing
    Case strSetupRServer = ""
      Call SetParam("SetupRServer",          strSetupRServer,          strMSOption,"R Server " & strMessage, "")
  End Select

End Sub


Sub SetupInstDTC()
  Call DebugLog("SetupInstDTC:")
  Dim strGroup

  strGroup          = GetBuildfileValue("ClusterGroupDTC")
  strClusterNameDTC = GetClusterName("ClusterNameDTC", strClusterBase & strClusDTCSuffix & strClusSuffix)
  Select Case True
    Case strGroup = strClusterGroupSQL
      strClusterGroupDTC   = strClusterGroupSQL
      strClusterNetworkDTC = strClusterNetworkSQL
      strLabDTC            = strLabData
    Case strGroup = strClusterGroupAS
      strClusterGroupDTC   = strClusterGroupAS
      strClusterNetworkDTC = strClusterNetworkAS
      strLabDTC            = strLabDataAS
    Case strVolDTC = GetVolumes("VolData",      "",  "Y", strVolData,   1, strActionSQLDB) 
      strClusterGroupDTC   = strClusterGroupSQL
      strClusterNetworkDTC = strClusterNetworkSQL
      strLabDTC            = strLabData
    Case strVolDTC = GetVolumes("VolDataAS",    "",  "Y", strVolDataAS, 1, strActionSQLAS) 
      strClusterGroupDTC   = strClusterGroupAS
      strClusterNetworkDTC = strClusterNetworkAS
      strLabDTC            = strLabDataAS
    Case Else
      strClusterGroupDTC   = strClusterNameDTC
      strClusterNetworkDTC = "DTC " & strClusterNameDTC
  End Select

End Sub


Sub SetupInstRS()
  Call DebugLog("SetupInstRS:")
  Dim strItemReg

  strSetupRSDB  = CheckRSDBSetup()

  Select Case True
    Case strType = "CLIENT"
      ' Nothing
    Case strSetupPowerBI = "YES"
      Call SetFileData("SQLRSexe",     "PowerBIexe",                        "", "")
      strRSVersionNum = CheckRSVersion()
      strInstRSDir  = "\Setup\InstallRootDirectory"
      strInstRSSQL  ="PBIRS"
      strInstRS     = "PowerBIReportServer"
      strInstRSURL  = "ReportServer"
      strRSFullURL  = strHTTP & "://" & strServer & "/Reports" & "/Pages/Folder.aspx"
    Case strSQLVersion >= "SQL2017"
      Call SetFileData("SQLRSexe",     "",                                  "", "SQLServerReportingServices.exe")
      strInstRSDir  = "\Setup\InstallRootDirectory"
      strInstRSSQL  ="SSRS"
      strInstRS     = "SQLServerReportingServices"
      strInstRSURL  = "ReportServer"
      strRSFullURL  = strHTTP & "://" & strServer & "/Reports" & "/Pages/Folder.aspx"
    Case (strSetupSQLRSCluster = "YES") And (strSQLVersion <= "SQL2005")
      strInstRSDir  = "\Setup\SQLPath"
      strInstRSSQL  = strClusterBase & strClusRSSuffix
      strInstRS     = "ReportServer$" & strInstRSSQL
      strInstRSURL  = "ReportServer"
      strRSFullURL  = strHTTP & "://" & strClusterNameRS & "/Reports/Pages/Folder.aspx"
    Case strSetupSQLRSCluster = "YES"
      strInstRSDir  = "\Setup\SQLPath"
      strInstRSSQL  = strClusterBase & strClusRSSuffix
      strInstRS     = "ReportServer$" & strInstRSSQL
      strInstRSURL  = "ReportServer_" & strInstRSSQL
      strRSFullURL  = strHTTP & "://" & strClusterNameRS & "/Reports_" & strInstRSSQL & "/Pages/Folder.aspx"
    Case strInstance = "MSSQLSERVER"
      strInstRSDir  = "\Setup\SQLPath"
      strInstRSSQL  = strInstance
      strInstRS     = "ReportServer"
      strInstRSURL  = "ReportServer"
      strRSFullURL  = strHTTP & "://" & strServer & "/Reports" & "/Pages/Folder.aspx"
    Case Else
      strInstRSDir  = "\Setup\SQLPath"
      strInstRSSQL  = strInstance
      strInstRS     = "ReportServer$" & strInstRSSQL
      strInstRSURL  = "ReportServer_" & strInstRSSQL
      strRSFullURL  = strHTTP & "://" & strServer & "/Reports_" & strInstRSSQL & "/Pages/Folder.aspx"
  End Select

  Select Case True
    Case strInstRegRS = ""
      ' Nothing
    Case (strSQLVersion >= "SQL2017") Or (strSetupPowerBI = "YES")
      strPath       = strHKLMSQL & strInstRegRS & strInstRSDir
      strItemReg    = Right(strPath, Len(strPath) -  InstrRev(strPath, "\"))
      strPath       = Left(strPath, InstrRev(strPath, "\"))
      objWMIReg.GetStringValue strHKLM,Mid(strPath, 6),strItemReg,strPathNew
      strPathNew    = strPathNew & "\Shared Tools\"
    Case Else
      strPath       = "SOFTWARE\Wow6432Node\Microsoft\Microsoft SQL Server\" & strSQLVersionNum & "\Tools\ClientSetup\"
      objWMIReg.GetStringValue strHKLM,strPath,"Path",strPathNew
      If IsNull(strPathNew) Then
        strPath     = "SOFTWARE\Microsoft\Microsoft SQL Server\" & strSQLVersionNum & "\Tools\ClientSetup\"
        objWMIReg.GetStringValue strHKLM,strPath,"Path",strPathNew
      End If
  End Select
  If Right(strPathNew, 1) <> "\" Then
    strPathNew      = strPathNew & "\"
  End If
  strCmdRS          = strPathNew
  Call SetBuildfileValue("CmdRS",  strCmdRS)

End Sub


Function CheckRSDBSetup()
  Call DebugLog("CheckRSDBSetup:")
  Dim strSetup

  Select Case True
    Case strActionSQLRS = strActionClusInst
      strSetup      = "YES"
    Case strSQLVersion >= "SQL2017"
      strSetup      = "YES"
    Case strSetupPowerBI = "YES"
      strSetup      = "YES"
    Case Else
      strSetup      = "NO"
  End Select

  Select Case True
    Case (strCatalogServerName = strClusterNameSQL) And (strClusterNameSQL <> "") And (strCatalogInstance = strInstance)
      strSetup      = strSetup
    Case (strCatalogServerName = strClusterGroupAO) And (strClusterGroupAO <> "")
      strSetup      = strSetup
    Case (strCatalogServerName = strServer) And (strCatalogInstance = strInstance)
      strSetup      = strSetup
    Case Else
      strSetup      = "NO"
  End Select

  CheckRSDBSetup    = strSetup

End Function


Function CheckRSVersion()
  Call DebugLog("CheckRSVersion:")
  Dim strRSVersion

  strRSVersion      = strRSVersionNum
  strPath           = FormatFolder(strPathAddComp) & "\" & GetBuildfileValue("SQLRSexe")
  Select Case True
    Case strSetupPowerBI <> "YES"
      ' Nothing
    Case Not objFSO.FileExists(strPath)
      ' Nothing
    Case objFSO.GetFileVersion(strPath) > "1.2"
      strRSVersion  = Max(strRSVersion, "15")
    Case Else
      strRSVersion  = Max(strRSVersion, "14")
  End Select

  CheckRSVersion    = strRSVersion

End Function


Sub GetFileData()
  Call SetProcessId("0BL", "Get data for Install files")

  Select Case True
    Case strWOWX86 = "TRUE"
      strSPFile     = strSPLevel & "X86"
      strCUFile     = strSPLevel & "X86" & strSPCULevel
    Case Else
      strSPFile     = strSPLevel & strFileArc
      strCUFile     = strSPLevel & strFileArc & strSPCULevel
  End Select
  If (strSQLVersion = "SQL2005") And (strEdition = "EXPRESS") Then
    strSPFile       = strSPFile & "Exp"
  End If

  Call SetFileData("ABEmsi",           "ABE" & strFileArc & "msi",          "", "")
  Call SetFileData("AccidentalDBAzip", "AccidentalDBAzip",                  "", "")
  Call SetFileData("BIDSexe",          "BIDSexe",                           "", "")
  Call SetFileData("BOLexe",           "BOLexe",                            "", "")
  Call SetFileData("BOLmsi",           "BOLmsi",                            "", "")
  Call SetFileData("BPAmsi",           "BPA" & strFileArc & "msi",          "", "")
  Call SetFileData("CacheManagerZip",  "CacheManagerZip",                   "", "")
  Call SetFileData("CUFile",           strCUFile,                           "", "")
  Call SetFileData("DB2exe",           "DB2exe",                            "", "")
  Call SetFileData("DB2OLEmsi",        "DB2OLE" & strFileArc & "msi",       "", "")
  Call SetFileData("DBAManagementbat", "DBAManagementbat",                  "", "")
  Call SetFileData("DBAManagementCab", "DBAManagementCab",                  "", "")
  Call SetFileData("DimensionSCDZip",  "DimensionSCDZip",                   "", "")
  Call SetFileData("DimensionSCDmsi",  "DimensionSCD" & strFileArc & "msi", "", "")
  Call SetFileData("DTSBackupmsi",     "DTSBackupmsi",                      "", "")
  Call SetFileData("DTSmsi",           "DTSmsi",                            "", "")
  Call SetFileData("DTSFix",           "DTSFix",                            "", "")
  Call SetFileData("GenMaintCab",      "GenMaintCab",                       "", "")
  Call SetFileData("GenMaintSql",      "GenMaintSql",                       "", "MaintenanceSolution.sql")
  Call SetFileData("GenMaintVbs",      "GenMaintVbs",                       "", "")
  Call SetFileData("GovernorSql",      "GovernorSql",                       "", "")
  Call SetFileData("IntViewermsi",     "IntViewermsi",                      "", "")
  Call SetFileData("Javaexe",          "Javaexe",                           "", "")
  Call SetFileData("JREexe",           "JRE" & strFileArc & "exe",          "", "")
  Call SetFileData("RSKeepAliveCab",   "RSKeepAliveCab",                    "", "")
  Call SetFileData("KB925336exe",      "KB925336" & strFileArc & "exe",     "", "")
  Call SetFileData("KB932232exe",      "KB932232exe",                       "", "")
  Call SetFileData("KB933789exe",      "KB933789" & strFileArc & "exe",     "", "")
  Call SetFileData("KB937444exe",      "KB937444" & strFileArc & "exe",     "", "")
  Call SetFileData("KB954961exe",      "KB954961exe",                       "", "")
  Call SetFileData("KB956250msu",      "KB956250" & strFileArc & "msu",     "", "")
  Call SetFileData("KB2781514exe",     "KB2781514exe",                      "", "")
  Call SetFileData("KB2919355msu",     "KB2919355" & strFileArc & "msu",    "", "")
  Call SetFileData("KB2919442msu",     "KB2919442" & strFileArc & "msu",    "", "")
  Call SetFileData("KB3090973msu",     "KB3090973" & strFileArc & "msu",    "", "")
  Call SetFileData("MBCAmsi",          "MBCA" & strFileArc & "msi",         "", "")
  If strOSVersion >= "6.2" Then
    Call SetFileData("MBCAmsi",        "MBCAWin8" & strFileArc & "msi",     "", "")
  End If
  Call SetFileData("MDXexe",           "MDXexe",                            "", "")
  Call SetFileData("MDXZip",           "MDXZip",                            "", "")
  Select Case True
    Case strOSVersion <= "6" 
      ' Nothing
    Case strOSVersion = "6.0" 
      Call SetFileData("Net4Xexe",     "Net4Xexe",                          "NDP461-KB3151800-x86-x64-AllOS-ENU.exe", "")
    Case (strSQLVersion = "SQL2016") And (Instr(strOSType, "CORE") > 0)
      Call SetFileData("Net4Xexe",     "Net4Xexe",                          "NDP462-KB3151800-x86-x64-AllOS-ENU.exe", "")
    Case Else
      Call SetFileData("Net4Xexe",     "Net4Xexe",                          "", "")
  End Select
  Call SetFileData("PBMBat",           "PBMBat",                            "", "")
  Call SetFileData("PBMCab",           "PBMCab",                            "", "")
  Call SetFileData("PDFexe",           "PDFexe",                            "", "")
  Call SetFileData("PDFreg",           "PDFreg",                            "", "SumatraPDF")
  Call SetFileData("PerfDashmsi",      "PerfDashmsi",                       "", "")
  Call SetFileData("PlanExpexe",       "PlanExp" & strFileArc & "exe",      "", "")
  Call SetFileData("PlanExpAddinmsi",  "PlanExpAddinmsi",                   "", "")
  Call SetFileData("ProcExpDir",       "ProcExpDir",                        "", "ProcessExplorer")
  Call SetFileData("ProcExpexe",       "ProcExpexe",                        "", "")
  Call SetFileData("ProcExpZip",       "ProcExpZip",                        "", "")
  Call SetFileData("ProcMonDir",       "ProcMonDir",                        "", "ProcessMonitor")
  Call SetFileData("ProcMonexe",       "ProcMonexe",                        "", "")
  Call SetFileData("ProcMonZip",       "ProcMonZip",                        "", "")
  Select Case True
    Case (Instr(Ucase(strOSName), " XP") > 0) And (strProcArc  = "X86")    ' Windows XP and 32-bit
      Call SetFileData("PS1File",      "PS1XPX86",                          "", "")
      Call SetFileData("PS2File",      "PS2XPX86",                          "", "")
    Case (strOSVersion < "6.0") And (strProcArc  = "X86")                  ' Windows 2003 32-bit
      Call SetFileData("PS1File",      "PS1W2003X86",                       "", "")
      Call SetFileData("PS2File",      "PS2W2003" & strFileArc,             "", "")
    Case strOSVersion < "6.0"                                              ' Windows 2003 or XP 64-bit
      Call SetFileData("PS1File",      "PS1XPW2003X64",                     "", "")
      Call SetFileData("PS2File",      "PS2W2003" & strFileArc,             "", "")
    Case (strOSVersion = "6.0") And (Instr(Ucase(strOSName), "VISTA") > 0) ' Windows Vista
      Call SetFileData("PS1File",      "PS1Vista" & strFileArc,             "", "")
      Call SetFileData("PS2File",      "PS2W2008" & strFileArc,             "", "")
      Call SetFileData("KB2862966File","KB2862966W2008" & strFileArc & "msu", "", "")
    Case strOSVersion = "6.0"                                              ' Windows 2008
      Call SetFileData("PS1File",      "",                                  "", "PKGMGR")
      Call SetFileData("PS2File",      "PS2W2008" & strFileArc,             "", "")
      Call SetFileData("KB2862966File","KB2862966W2008" & strFileArc & "msu", "", "")
    Case strOSVersion = "6.1"  
      Call SetFileData("PS1File",      "",                                  "", "PKGMGR")
      Call SetFileData("PS2File",      "",                                  "", "PKGMGR")
      Call SetFileData("KB2862966File","KB2862966W2008R2" & strFileArc & "msu", "", "")
    Case Else
      Call SetFileData("PS1File",      "",                                  "", "PKGMGR")
      Call SetFileData("PS2File",      "",                                  "", "PKGMGR")
      Call SetFileData("KB2862966File","KB2862966" & strFileArc & "msu",    "", "")
  End Select
  Call SetFileData("RawReaderexe",     "RawReaderexe",                      "", "")
  Call SetFileData("ReportViewerexe",  "ReportViewerexe",                   "", "")
  Call SetFileData("RMLToolsmsi",      "RMLTools" & strFileArc & "msi",     "", "")
  Call SetFileData("RptTaskPadRdl",    "RptTaskPadRdl",                     "", "")
  Call SetFileData("RSScripterZip",    "RSScripterZip",                     "", "")
  Call SetFileData("RSLinkGenZip",     "RSLinkGenZip",                      "", "")
  Call SetFileData("Samplesmsi",       "Samples" & strFileArc & "msi",      "", "")
  strSNACFile       = strSPLevel & strFileArc & strSPCULevel & "SNAC"
  Call SetFileData("SNACFile",         strSNACFile,                         "", "SQLNCLI*" & strFileArc & ".msi")
  Call SetFileData("SPFile",           strSPFile,                           "", "")
  Call SetFileData("SQLBCmsi",         "SQLBC" & strFileArc & "msi",        "", "")
  Call SetFileData("SQLCEexe",         "SQLCE" & strFileArc & "exe",        "", "")
  Call SetFileData("SQLNexuszip",      "SQLNexuszip",                       "", "")
  Call SetFileData("SQLNSmsi",         "SQLNS" & strFileArc & "msi",        "", "")
  Call SetFileData("SSDTBIexe",        "SSDTBIexe",                         "", "")
  Call SetFileData("SSMSexe",          "SSMSexe",                           "", "")
  Call SetFileData("SysManagementbat", "SysManagementbat",                  "", "")
  Call SetFileData("SysManagementCab", "SysManagementCab",                  "", "")
  Call SetFileData("SystemViewsPDF",   "SystemViewsPDF",                    "", "")
  Call SetFileData("TroublePDF",       "TroublePDF",                        "", "")
  Call SetFileData("VS2005SP1exe",     "VS2005SP1exe",                      "", "")
  Call SetFileData("VS2010SP1exe",     "VS2010SP1exe",                      "", "Setup.exe")
  Call SetFileData("XEventsmsi",       "XEventsmsi",                        "", "")
  Call SetFileData("XMLmsi",           "XMLmsi",                            "", "")
  Call SetFileData("ZoomItDir",        "ZoomItDir",                         "", "ZoomIt")
  Call SetFileData("ZoomItExe",        "ZoomItExe",                         "", "")
  Call SetFileData("ZoomItZip",        "ZoomItZip",                         "", "")

  strSSMSexe        = GetBuildfileValue("SSMSexe")

End Sub


Sub SetFileData(strBuild, strParam, strMaxFile, strDefault)
  Call DebugLog("SetFileData: " & strBuild)
  Dim colREFiles
  Dim objFolder
  Dim strFolder, strREPath, strStorePath

  Select Case True
    Case strDefault = ""
      strDefault    = strUnknown
  End Select

  Select Case True
    Case strParam = ""
      strFolder     = ""
      strPath       = strDefault
    Case Mid(strParam, 2, 1) = ":"
      strFolder     = strParam
      strPath       = strDefault
    Case Else
      strFolder     = strPathAddComp
      strPath       = GetParam(colFiles,              strParam,            "",                     strDefault)
  End Select

  Select Case True
    Case strFolder = ""
      ' Nothing
    Case Instr(strPath, "*") > 0 
      strREPath     = "^" & Replace(strPath, "*", ".*") & "$"
      strPath       = ""
      objRE.Pattern = strREPath
      Set objFolder = objFSO.GetFolder(strFolder)
      Set colREFiles = objFolder.Files
      For Each objFile In colREFiles
        Select Case True
          Case Not objRE.Test(objFile.Name)
            ' Nothing
          Case (UCase(objFile.Name) > UCase(strMaxFile)) And (strMaxFile <> "")
            ' Nothing
          Case strPath < objFile.name
            strPath = objFile.name
        End Select
      Next
      If strPath = "" Then
        strPath     = strUnknown
      End If
  End Select

  Call SetBuildfileValue(strBuild, strPath)
  Set colREFiles    = Nothing
  Set objFolder     = Nothing

End Sub


Sub GetSetupData()
  Call SetProcessId("0BM", "Get Setup Parameter data")

  If strSetupCompliance = "YES" Then
    Call SetupDataCompliance
  End If

  Call SetupDataDep0

  Call SetupDataDep1

  Call SetupDataDep2

  Call SetupDataDep3

End Sub


Sub SetupDataCompliance()
  Call SetProcessId("0BMA", "Setup Parameter Data for Compliance")

  If strOSVersion <"6.3X" Then
    Call SetParam("SetupABE",                strSetupABE,              "YES", "", strListCompliance)
  End If
  Call SetParam("SetupDCOM",                 strSetupDCOM,             "YES", "", strListCompliance)
  Call SetParam("SetupFirewall",             strSetupFirewall,         "YES", "", strListCompliance)
  Call SetParam("SetupNetwork",              strSetupNetwork,          "YES", "", strListCompliance)
  Call SetParam("SetupNoSSL3",               strSetupNoSSL3,           "YES", "", strListCompliance)
  Call SetParam("SetupNoTCPNetBios",         strSetupNoTCPNetBios,     "YES", "", strListCompliance)
  Call SetParam("SetupNoWinGlobal",          strSetupNoWinGlobal,      "YES", "", strListCompliance)
  Call SetParam("SetupWinAudit",             strSetupWinAudit,         "YES", "", strListCompliance)

  If strSQLVersion >= "SQL2008" Then
    Call SetParam("SetupTLS12",              strSetupTLS12,            "YES", "", strListCompliance)
  End If

  If strType <> "CLIENT" Then
'    Call SetParam("SetupSSL",                strSetupSSL,              "YES", "", strListCompliance)
    Call SetParam("SetupSPN",                strSetupSPN,              "YES", "", strListCompliance)
  End If

  If strSetupSQLAS = "YES" Then
    Call SetParam("SetupOLAP",               strSetupOLAP,             "YES", "", strListCompliance)
  End If

  If strSetupSQLDB = "YES" Then
    Call SetParam("SetupDisableSA",          strSetupDisableSA,        "YES", "", strListCompliance)
    Call SetParam("SetupNonSAAccounts",      strSetupNonSAAccounts,    "YES", "", strListCompliance)
    Call SetParam("SetupOldAccounts",        strSetupOldAccounts,      "YES", "", strListCompliance)
    Call SetParam("SetupStdAccounts",        strSetupStdAccounts,      "YES", "", strListCompliance)
    Call SetParam("SetupSAAccounts",         strSetupSAAccounts,       "YES", "", strListCompliance)
    Call SetParam("SetupSAPassword",         strSetupSAPassword,       "YES", "", strListCompliance)
    Call SetParam("SetupSQLTools",           strSetupSQLTools,         "NO",  "SQL Tools must not be installed for SQL Compliance", "")
    Call SetParam("AuditLevel",              strAuditLevel,            "3",   "Audit Level must be FULL for SQL Compliance", "")
  End If

  If strSetupSQLRS = "YES" Then
    Call SetParam("SetupRSAdmin",            strSetupRSAdmin,          "YES", "", strListCompliance)
  End If

End Sub


Sub SetupDataDep0()
  Call SetProcessId("0BMB", "Setup Parameter Data for Dependency Level 0")

  Select Case True
    Case strType = "CLIENT"
      Call SetParam("SetupSQLDBAG",          strSetupSQLDBAG,          "N/A", "", strListType)
    Case strSetupSQLDB <> "YES"
      Call SetParam("SetupSQLDBAG",          strSetupSQLDBAG,          "N/A", "", strListSQLDB)
      Call SetParam("SetupSQLAgent",         strSetupSQLAgent,         "N/A", "", strListSQLDB)
    Case strEdition <> "EXPRESS"
      Call SetParam("SetupSQLDBAG",          strSetupSQLDBAG,          "YES", "SQL Agent always installed for Edition " & strEdition, "")
  End Select

  Select Case True 
    Case strSetupSQLDB <> "YES"
      Call SetParam("SetupCmdshell",         strSetupCmdshell,         "N/A", "", strListSQLDB)
  End Select

  Select Case True
    Case strActionSQLDB = "ADDNODE"
      Call SetParam("SetupDBMail",           strSetupDBMail,           "N/A", "", strListAddNode)
    Case strSetupSQLDB <> "YES"
      Call SetParam("SetupDBMail",           strSetupDBMail,           "N/A", "", strListSQLDB)
  End Select

  Select Case True 
    Case strSetupSQLDB <> "YES"
      Call SetParam("SetupDisableSA",        strSetupDisableSA,        "N/A", "", strListSQLDB)
  End Select

  Select Case True
    Case strFileArc <> "X86"
      Call SetParam("SetupSQLMail",          strSetupSQLMail,          "N/A", "", strListOSVersion)
    Case strSQLVersion >= "SQL2012"
      Call SetParam("SetupSQLMail",          strSetupSQLMail,          "N/A", "", strListSQLVersion)
    Case strSetupSQLDB <> "YES"
      Call SetParam("SetupSQLMail",          strSetupSQLMail,          "N/A", "", strListSQLDB)
  End Select

  Select Case True 
    Case strOSVersion <= "5.1"               ' Windows XP
      Call SetParam("SetupABE",              strSetupABE,              "N/A", "", strListOSVersion)
'    Case strOSVersion >= "6.3X"              ' Windows 2016
'      Call SetParam("SetupABE",              strSetupABE,              "N/A", "", strListOSVersion)
    Case Instr(strOSType, "CORE") > 0
      Call SetParam("SetupABE",              strSetupABE,              "N/A", "", strListCore)
  End Select

  Select Case True 
    Case strClusterAction = ""
      Call SetParam("SetupClusterShares",    strSetupClusterShares,    "N/A", "", strListCluster)
    Case strSetupClusterShares = ""
      strSetupClusterShares = "NO"
  End Select

  Select Case True 
    Case strClusterAction = ""
      Call SetParam("SetupAPCluster",        strSetupAPCluster,        "N/A", "", strListCluster)
    Case strSetupAPCluster = ""
      strSetupAPCluster = "NO"
  End Select

  Select Case True 
    Case strSetupAlwaysOn = "YES"
      ' Nothing
    Case strSetupSQLDBCluster <> "YES"
      Call SetParam("SetupDTCCluster",       strSetupDTCCluster,       "N/A", "", strListCluster)
      Call SetParam("SetupPolyBaseCluster",  strSetupPolyBaseCluster,  "N/A", "", strListCluster)
    Case strSetupAPCluster = "YES"
      Call SetParam("SetupPolyBaseCluster",  strSetupPolyBaseCluster,  "YES", "PolyBase Cluster mandatory for /SetupAPCluster value: " & strSetupAPCluster, "")
  End Select

  Select Case True
    Case strSetupPolyBase <> "YES"
      strSetupPolyBaseCluster = "N/A"
    Case strSetupPolyBaseCluster <> ""
      ' Nothing
    Case strSetupSQLDBCluster = "YES"
      strSetupPolyBaseCluster = "YES"
    Case strSetupAlwaysOn = "YES"
      strSetupPolyBaseCluster = "YES"
  End Select

  Select Case True
    Case strSQLVersion >= "SQL2016"
      Call SetParam("SetupNet4",             strSetupNet4,             "YES", ".Net4 mandatory for " & strSQLVersion, "")
      Call SetParam("SetupNet4x",            strSetupNet4x,            "YES", ".Net4.5 or above mandatory for " & strSQLVersion, "")
      Call SetParam("SetupBIDS",             strSetupBIDS,             "N/A", "", strListSQLVersion)
      If strSetupSQLRS = "YES" Then
        Call SetParam("SetupNet3",           strSetupNet3,             "YES", ".Net3 mandatory for configuration of SSRS", "")
      End If
      If strSetupNet3 = "" Then
        Call SetParam("SetupNet3",           strSetupNet3,             "N/A", "", strListSQLVersion)
      End If
    Case strSQLVersion = "SQL2014"
      Call SetParam("SetupNet3",             strSetupNet3,             "YES", ".Net3 mandatory for " & strSQLVersion, "")
      Call SetParam("SetupNet4",             strSetupNet4,             "YES", ".Net4 mandatory for " & strSQLVersion, "")
      Call SetParam("SetupNet4x",            strSetupNet4x,            "YES", ".Net4.5 or above mandatory for " & strSQLVersion, "")
      Call SetParam("SetupBIDS",             strSetupBIDS,             "N/A", "", strListSQLVersion)
    Case strSQLVersion = "SQL2012"
      Call SetParam("SetupNet3",             strSetupNet3,             "YES", ".Net3 mandatory for " & strSQLVersion, "")
      Call SetParam("SetupNet4",             strSetupNet4,             "YES", ".Net4 mandatory for " & strSQLVersion, "")
      Call SetParam("SetupNet4x",            strSetupNet4x,            "YES", ".Net4.5 or above is recommended for " & strSQLVersion, "")
    Case strSQLVersion = "SQL2008"
      Call SetParam("SetupNet3",             strSetupNet3,             "YES", ".Net3 mandatory for " & strSQLVersion, "")
    Case strSQLVersion = "SQL2008R2"
      Call SetParam("SetupNet3",             strSetupNet3,             "YES", ".Net3 mandatory for " & strSQLVersion, "")
    Case strSQLVersion <= "SQL2005"
      If strOSVersion >= "6.1" Then
        Call SetParam("SetupNet3",           strSetupNet3,             "YES", ".Net3 mandatory for " & strSQLVersion, "")
      End If 
  End Select

  Select Case True
    Case strOSVersion > "6.0"
      ' Nothing
    Case strVersionNet3 > ""
      ' Nothing
    Case strVersionNet4 > ""
      Call SetBuildMessage(strMsgError, ".Net3 must be installed before .Net 4")
  End Select

  Select Case True
    Case strSetupAlwaysOn <> "YES"
      ' Nothing
    Case strSQLVersion < "SQL2012"
      Call SetParam("SetupAlwaysOn",         strSetupAlwaysOn,         "N/A", "", strListSQLVersion)
    Case strEditionEnt <> "YES"
      Call SetParam("SetupAlwaysOn",         strSetupAlwaysOn,         "N/A", "", strListEdition)
    Case strOSVersion < "6.2"
      Call SetParam("SetupAlwaysOn",         strSetupAlwaysOn,         "N/A", "", strListOSVersion)
    Case strSQLVersion >= "SQL2017"
      ' Nothing
    Case strClusterHost <> "YES"
      Call SetParam("SetupAlwaysOn",         strSetupAlwaysOn,         "N/A", "", strListCluster)
  End Select
  If strSetupAlwaysOn = "" Then
    strSetupAlwaysOn = "NO"
  End If
  If strSetupAlwaysOn <> "YES" Then
    strSetupAODB   = "NO"
  End If

  Select Case True
    Case strSetupAnalytics <> "YES"
      ' Nothing
    Case strSQLVersion < "SQL2016"
      Call SetParam("SetupAnalytics",        strSetupAnalytics,        "N/A", "", strListSQLVersion)
    Case strExtSvcAccount = "" 
      Call SetBuildMessage(strMsgError, "/EXTSVCACCOUNT: parameter must be specified for Analytics")
  End Select

  Select Case True
    Case strSetupSQLTools <> "YES"
      Call SetParam("SetupBIDS",             strSetupBIDS,             "N/A", "", strListSQLTools)
      Call SetParam("SetupBOL",              strSetupBOL,              "N/A", "", strListSQLTools)
  End Select

  Select Case True
    Case strSetupSQLTools <> "YES"
      Call SetParam("SetupBPAnalyzer",       strSetupBPAnalyzer,       "N/A", "", strListSQLTools)
    Case strSQLVersion = "SQL2008" 
      Call SetParam("SetupBPAnalyzer",       strSetupBPAnalyzer,       "N/A", "", strListSQLVersion)
  End Select

  Select Case True
    Case strSQLVersion < "SQL2014" 
      Call SetParam("SetupBPE",              strSetupBPE,              "N/A", "", strListSQLVersion)
    Case strSetupSQLDB <> "YES"
      Call SetParam("SetupBPE",              strSetupBPE,              "N/A", "", strListSQLDB)
  End Select
  If strSetupBPE <> "YES" Then
    Call SetBuildfileValue("DirBPE", "")
  End If

  Select Case True
    Case strSetupSQLTools <> "YES"
      Call SetParam("SetupCacheManager",     strSetupCacheManager,     "N/A", "", strListSQLTools)
  End Select

  Select Case True
   Case strSetupSQLDB <> "YES"
      Call SetParam("SetupDB2OLE",           strSetupDB2OLE,           "N/A", "", strListSQLDB)
    Case strEditionEnt <> "YES"
      Call SetParam("SetupDB2OLE",           strSetupDB2OLE,           "N/A", "", strListEdition)
    Case (strSQLVersion <= "SQL2008R2") And (strOSVersion >= "6.3X")
      Call SetParam("SetupDB2OLE",           strSetupDB2OLE,           "N/A", "", strListOSVersion)
    Case Instr(strOSType, "CORE") > 0
      Call SetParam("SetupDB2OLE",           strSetupDB2OLE,           "N/A", "", strListOSVersion)
  End Select

  Select Case True 
    Case strSetupSQLDB <> "YES"
      Call SetParam("SetupDBAManagement",    strSetupDBAManagement,    "N/A", "", strListSQLDB)
  End Select

  Select Case True 
    Case strSetupSQLDB <> "YES"
      Call SetParam("SetupDBOpts",           strSetupDBOpts,           "N/A", "", strListSQLDB)
  End Select

  Select Case True
   Case strSetupSQLDB <> "YES"
      Call SetParam("SetupDistributor",      strSetupDistributor,      "N/A", "", strListSQLDB)
    Case strType = "CLIENT"
      Call SetParam("SetupDistributor",      strSetupDistributor,      "N/A", "", strListType)
    Case strActionSQLDB = "ADDNODE"
      Call SetParam("SetupDistributor",      strSetupDistributor,      "N/A", "", strListAddNode)
  End Select

  Select Case True  
   Case strSetupSQLDB <> "YES"
      Call SetParam("SetupDQ",               strSetupDQ,               "N/A", "", strListSQLDB)
   Case strSQLVersion < "SQL2012"
      Call SetParam("SetupDQ",               strSetupDQ,               "N/A", "", strListSQLVersion)
    Case Instr(strOSType, "CORE") > 0
      Call SetParam("SetupDQ",               strSetupDQ,               "N/A", "", strListCore)
    Case strMainInstance <> "YES"
      Call SetParam("SetupDQ",               strSetupDQ,               "NO",  "", strListMain)
    Case strEdition = "EXPRESS"
      Call SetParam("SetupDQ",               strSetupDQ,               "N/A", "", strListEdition)
    Case strEdition = "WORKGROUP"
      Call SetParam("SetupDQ",               strSetupDQ,               "N/A", "", strListEdition)
    Case strType = "CLIENT"
      Call SetParam("SetupDQ",               strSetupDQ,               "N/A", "", strListType)
  End Select

  Select Case True               
    Case strSQLVersion < "SQL2012"
      Call SetParam("SetupDQC",              strSetupDQC,              "N/A", "", strListSQLVersion)
    Case Instr(strOSType, "CORE") > 0
      Call SetParam("SetupDQC",              strSetupDQC,              "N/A", "", strListCore)
    Case strEdition = "EXPRESS"
      Call SetParam("SetupDQC",              strSetupDQC,              "N/A", "", strListEdition)
    Case strSetupSQLTools <> "YES"
      Call SetParam("SetupDQC",              strSetupDQC,              "N/A", "", strListSQLTools)
  End Select

  Select Case True
    Case strSQLVersion < "SQL2012"
      Call SetParam("SetupDRUClt",           strSetupDRUClt,           "N/A", "", strListSQLVersion)
    Case Instr(strOSType, "CORE") > 0
      Call SetParam("SetupDRUClt",           strSetupDRUClt,           "N/A", "", strListCore)
    Case strSetupDRUClt <> "YES"
      strSetupDRUClt = "NO"
  End Select
  If strSetupDRUClt <> "YES" Then
    Call SetBuildfileValue("DirDRU", "")
  End If

  Select Case True
    Case strSQLVersion < "SQL2012"
      Call SetParam("SetupDRUCtlr",          strSetupDRUCtlr,          "N/A", "", strListSQLVersion)
   Case strSetupDRUCtlr = "N/A"
      ' Nothing
   Case strSetupDRUCtlr <> "YES"
      strSetupDRUCtlr = "NO"
  End Select

  Select Case True
    Case strClusterAction = ""
      Call SetParam("SetupDTCCluster",       strSetupDTCCluster,       "N/A", "", strListCluster)
    Case strOSVersion >= "6.0"
      ' Nothing
    Case (strProcessId > "1") And (strProcessId <> "7")
      ' Nothing
    Case strDTCClusterRes > ""
      Call SetParam("SetupDTCCluster",       strSetupDTCCluster,       "N/A", "DTC Cluster already exists", "")
    Case Else
      Call SetParam("SetupDTCCluster",       strSetupDTCCluster,       "YES", "DTC Cluster is mandatory for Cluster install", "")
  End Select

  Select Case True
    Case (strOSVersion < "6.0") And (strDTCClusterRes > "")
      ' Nothing
    Case strSetupDTCCluster = "YES"
      Call SetParam("SetupDTCNetAccess",     strSetupDTCNetAccess,     "YES", "DTC Network Access mandatory for Cluster install", "")
    Case strSQLVersion <= "SQL2005"
      Call SetParam("SetupDTCNetAccess",     strSetupDTCNetAccess,     "YES", "DTC Network Access mandatory for " & strSQLVersion & " install", "")
  End Select

  Select Case True
    Case strSetupDTCNetAccess = "YES"
      ' Nothing
    Case strSetupDTCNetAccessStatus = strStatusComplete
      strSetupDTCNetAccessStatus = strStatusPreConfig
  End Select

  Select Case True
    Case strSetupSQLTools <> "YES"
      Call SetParam("SetupDTSDesigner",      strSetupDTSDesigner,      "N/A", "", strListSQLTools)
    Case strSQLVersion >= "SQL2012" 
      Call SetParam("SetupDTSDesigner",      strSetupDTSDesigner,      "N/A", "", strListSQLVersion)
    Case strOSVersion >= "6.3X"
      Call SetParam("SetupDTSDesigner",      strSetupDTSDesigner,      "N/A", "", strListOSVersion)
  End Select

  Select Case True
    Case strSetupSQLIS <> "YES"
      Call SetParam("SetupDimensionSCD",     strSetupDimensionSCD,     "N/A", "", strListSSIS)
    Case Instr(strOSType, "CORE") > 0
      Call SetParam("SetupDimensionSCD",     strSetupDimensionSCD,     "N/A", "", strListCore)
  End Select

  Select Case True
    Case strSQLVersion <= "SQL2005"
      Call SetParam("SetupGovernor",         strSetupGovernor,         "N/A", "", strListSQLVersion)
    Case strSetupSQLDB <> "YES"
      Call SetParam("SetupGovernor",         strSetupGovernor,         "N/A", "", strListSQLDB)
    Case strSetupGovernor <> ""
      ' Nothing
    Case Else
      Call SetParam("SetupGovernor",         strSetupGovernor,         "YES", "Resource Governor recommended for " & strEdition & " Edition", "")
  End Select

  Select Case True
    Case (Instr(Ucase(strOSName), " XP") > 0) And (Instr(strOSType, "STARTER") > 0)
      Call SetParam("SetupGenMaint",         strSetupGenMaint,         "N/A", "", strListOSVersion)
    Case strSetupSQLDB <> "YES"
      Call SetParam("SetupGenMaint",         strSetupGenMaint,         "N/A", "", strListSQLDB)
  End Select

  Select Case True
    Case strSetupSQLTools <> "YES"
      Call SetParam("SetupIntViewer",        strSetupIntViewer,        "N/A", "", strListSQLTools)
    Case strSQLVersion >= "SQL2008R2" 
      Call SetParam("SetupIntViewer",        strSetupIntViewer,        "N/A", "", strListSQLVersion)
  End Select

  Select Case True
    Case strType = "CLIENT"
      Call SetParam("SetupISMaster",         strSetupISMaster,         "N/A", "", strListType)
    Case strSQLVersion < "SQL2017" 
      Call SetParam("SetupISMaster",         strSetupISMaster,         "N/A", "", strListSQLVersion)
    Case strSetupISMaster = ""
      strSetupISMaster = "NO"
    Case strSetupISMaster <> "YES"
      ' Nothing
    Case Else
      Call SetParam("SecurityMode",          strSecurityMode,          "SQL", "/SecurityMode:SQL mandatory for ISMaster", "")
  End Select

  Select Case True
    Case strType = "CLIENT"
      Call SetParam("SetupISWorker",         strSetupISWorker,         "N/A", "", strListType)
    Case strSQLVersion < "SQL2017" 
      Call SetParam("SetupISWorker",         strSetupISWorker,         "N/A", "", strListSQLVersion)
    Case strSetupISWorker <> ""
      ' Nothing
    Case strSetupISMaster = "YES"
      strSetupISWorker = "YES"
    Case Else
      strSetupISWorker = "NO"
  End Select
  Select Case True
    Case strSetupISWorker <> "YES"
      ' Nothing
    Case Else
      Call SetParam("SecurityMode",          strSecurityMode,          "SQL", "/SecurityMode:SQL mandatory for ISWorker", "")
  End Select

  Select Case True
    Case strSetupSQLDB <> "YES"
      Call SetParam("SetupJavaDBC",          strSetupJavaDBC,          "N/A", "", strListSQLDB)
  End Select

  Select Case True               
    Case Instr(strOSType, "CORE") > 0
      Call SetParam("SetupJRE",              strSetupJRE,              "N/A", "", strListCore)
    Case strSetupPolyBase = "YES"
      Call SetParam("SetupJRE",              strSetupJRE,              "YES", "JRE mandatory if PolyBase is installed", "")
  End Select

  Select Case True
    Case strOSVersion >= "6.0"
      Call SetParam("SetupKB925336",         strSetupKB925336,         "N/A", "", strListOSVersion)
    Case (Instr(Ucase(strOSName), " XP") > 0) And (strFileArc = "X86")
      Call SetParam("SetupKB925336",         strSetupKB925336,         "N/A", "", strListOSVersion)
    Case Else
      Call SetParam("SetupKB925336",         strSetupKB925336,         "YES", "KB925336 mandatory on " & strOSName, "")
  End Select

  Select Case True
    Case strOSVersion >= "6.0"
      Call SetParam("SetupKB933789",         strSetupKB933789,         "N/A", "", strListOSVersion)
    Case (Instr(Ucase(strOSName), " XP") > 0) And (strFileArc = "X86")
      Call SetParam("SetupKB933789",         strSetupKB933789,         "N/A", "", strListOSVersion)
    Case Else
      Call SetParam("SetupKB933789",         strSetupKB933789,         "YES", "KB933789 mandatory on " & strOSName, "")
  End Select

  Select Case True
    Case strType = "CLIENT"
      Call SetParam("SetupKB937444",         strSetupKB937444,         "N/A", "", strListType)
    Case strOSVersion >= "6.0"
      Call SetParam("SetupKB937444",         strSetupKB937444,         "N/A", "", strListOSVersion)
    Case (Instr(Ucase(strOSName), " XP") > 0) And (strFileArc = "X86")
      Call SetParam("SetupKB937444",         strSetupKB937444,         "N/A", "", strListOSVersion)
    Case strSQLVersion <= "SQL2005" 
      Call SetParam("SetupKB937444",         strSetupKB937444,         "N/A", "", strListSQLVersion)
    Case Else
      Call SetParam("SetupKB937444",         strSetupKB937444,         "YES", "KB937444 mandatory on " & strOSName, "")
  End Select

  Select Case True
    Case strOSVersion <> "6.3"
      Call SetParam("SetupKB2919355",        strSetupKB2919355,        "N/A", "", strListOSVersion)
      Call SetParam("SetupKB2919442",        strSetupKB2919442,        "N/A", "", strListOSVersion)
    Case Else
      Call SetParam("SetupKB2919355",        strSetupKB2919355,        "YES", "KB92919355 mandatory on " & strOSName, "")
      Call SetParam("SetupKB2919442",        strSetupKB2919442,        "YES", "KB92919422 mandatory on " & strOSName, "")
  End Select

  Select Case True
    Case strSQLVersion < "SQL2008R2"
      Call SetParam("SetupMDS",              strSetupMDS,              "N/A", "", strListSQLVersion)
      Call SetParam("SetupMDSC",             strSetupMDSC,             "N/A", "", strListSQLVersion)
    Case Instr(strOSType, "CORE") > 0
      Call SetParam("SetupMDS",              strSetupMDS,              "N/A", "", strListCore)
      Call SetParam("SetupMDSC",             strSetupMDSC,             "N/A", "", strListCore)
    Case strFileArc <> "X64"
      Call SetParam("SetupMDS",              strSetupMDS,              "NO",  "Master Data Services can only installed on X64", "")
   Case strSetupSQLDB <> "YES"
      Call SetParam("SetupMDS",              strSetupMDS,              "N/A", "", strListSQLDB)
    Case strMainInstance <> "YES"
      Call SetParam("SetupMDS",              strSetupMDS,              "NO",  "", strListMain)
  End Select
  Select Case True
    Case strSetupMDS <> "YES"
      ' Nothing
    Case Else
      If strMDSPort = "" Then
        Call SetBuildMessage(strMsgError, "/MDSPort: parameter must be specified for MDS")
      End If
      If strMDSSite = "" Then
        Call SetBuildMessage(strMsgError, "/MDSSite: parameter must be specified for MDS")
      End If
  End Select

  Select Case True
    Case strSetupSQLTools <> "YES"
      Call SetParam("SetupMDXStudio",        strSetupMDXStudio,        "N/A", "", strListSQLTools)
    Case strType = "CLIENT"
      ' Nothing
    Case strSetupSQLAS <> "YES"
      Call SetParam("SetupMDXStudio",        strSetupMDXStudio,        "N/A", "", strListSSAS)
  End Select

  Select Case True 
    Case strType = "CLIENT"
      Call SetParam("SetupManagementDW",     strSetupManagementDW,     "N/A", "", strListType)
    Case strSQLVersion <= "SQL2005"
      Call SetParam("SetupManagementDW",     strSetupManagementDW,     "N/A", "", strListSQLVersion)
    Case strActionSQLDB = "ADDNODE"
      Call SetParam("SetupManagementDW",     strSetupManagementDW,     "N/A", "", strListAddNode)
  End Select

  Select Case True
    Case strSetupSQLTools <> "YES"
      Call SetParam("SetupMyDocs",           strSetupMyDocs,           "N/A", "", strListSQLTools)
    Case strEdition = "EXPRESS"
      Call SetParam("SetupMyDocs",           strSetupMyDocs,           "N/A", "", strListEdition)
  End Select

  If strSetupNetBind = "" Then
    Call SetParam("SetupNetBind",            strSetupNetBind,          "N/A", "NetBind processing not required", "")
  End If

  If strSetupNetName = "" Then
    Call SetParam("SetupNetName",            strSetupNetName,          "N/A", "NetName processing not required", "")
  End If

  Select Case True
    Case strOSVersion < "6.0"
      Call SetParam("SetupNet4x",            strSetupNet4x,            "N/A", "", strListOSVersion)
    Case strSetupPlanExplorer = "YES"
      Call SetParam("SetupNet4x",            strSetupNet4x,            "YES", ".Net4.5 or above mandatory for Plan Explorer", "")
  End Select

  Select Case True 
    Case strOSVersion < "6.0"
      Call SetParam("SetupNoDefrag",         strSetupNoDefrag,         "N/A", "", strListOSVersion)
    Case strSetupNoDefrag <> ""
      ' Nothing
    Case strType = "WORKSTATION"
      Call SetParam("SetupNoDefrag",         strSetupNoDefrag,         "N/A", "", strListType)
    Case Else
      strSetupNoDefrag = "YES"
  End Select

  Select Case True 
    Case strType = "CLIENT"
      Call SetParam("SetupNonSAAccounts",    strSetupNonSAAccounts,    "N/A", "", strListType)
    Case strSetupSQLDB <> "YES"
      Call SetParam("SetupNonSAAccounts",    strSetupNonSAAccounts,    "N/A", "", strListSQLDB)
    Case strGroupDBANonSA = ""
      Call SetParam("SetupNonSAAccounts",    strSetupNonSAAccounts,    "NO",  "Non-sa Accounts can not be configured when /GroupDBANonSA: is blank", "")
  End Select

  Select Case True
    Case strType = "CLIENT"
      Call SetParam("SetupOLAP",             strSetupOLAP,             "N/A", "", strListType)
    Case strSetupSQLAS <> "YES"
      Call SetParam("SetupOLAP",             strSetupOLAP,             "N/A", "", strListSSAS)
    Case strActionSQLAS = "ADDNODE"
      Call SetParam("SetupOLAP",             strSetupOLAP,             "N/A", "", strListAddNode)
  End Select

  Select Case True
    Case strType = "CLIENT"
      Call SetParam("SetupOLAPAPI",          strSetupOLAPAPI,          "N/A", "", strListType)
    Case strSetupSQLAS <> "YES"
      Call SetParam("SetupOLAPAPI",          strSetupOLAPAPI,          "N/A", "", strListSSAS)
    Case strSQLVersion <= "SQL2005"
      Call SetParam("SetupOLAPAPI",          strSetupOLAPAPI,          "N/A", "", strListSQLVersion)
  End Select

  Select Case True
    Case strSetupSQLDB <> "YES"
      Call SetParam("SetupOldAccounts",      strSetupOldAccounts,      "N/A", "", strListSQLDB)
  End Select

  Select Case True
    Case strSetupSQLDB <> "YES"
      Call SetParam("SetupParam",            strSetupParam,            "N/A", "", strListSQLDB)
    Case strActionSQLDB = "ADDNODE"
      Call SetParam("SetupParam",            strSetupParam,            "N/A", "", strListAddNode)
  End Select

  Select Case True
    Case strSQLVersion <= "SQL2005"
      Call SetParam("SetupPBM",              strSetupPBM,              "N/A", "", strListSQLVersion)
    Case strSetupSQLDB <> "YES"
      Call SetParam("SetupPBM",              strSetupPBM,              "N/A", "", strListSQLDB)
  End Select

  Select Case True
    Case strSetupSQLTools <> "YES"
      Call SetParam("SetupPDFReader",        strSetupPDFReader,        "N/A", "", strListSQLTools)
  End Select

  Select Case True
    Case strSetupSQLTools <> "YES"
      Call SetParam("SetupPerfDash",         strSetupPerfDash,         "N/A", "", strListSQLTools)
    Case strSQLVersion >= "SQL2016"
      Call SetParam("SetupPerfDash",         strSetupPerfDash,         "N/A", "", strListSQLVersion)
    Case strUseFreeSSMS = "YES"
      Call SetParam("SetupPerfDash",         strSetupPerfDash,         "N/A", "Performance Dashboard included with Free SSMS", "")
  End Select

  Select Case True
    Case strOSVersion < "6"
      Call SetParam("SetupPlanExplorer",     strSetupPlanExplorer,     "N/A", "", strListOSVersion)
    Case strSetupSQLTools <> "YES"
      Call SetParam("SetupPlanExplorer",     strSetupPlanExplorer,     "N/A", "", strListSQLTools)
  End Select

  Select Case True
    Case strSetupSQLTools <> "YES"
      Call SetParam("SetupPlanExpAddin",     strSetupPlanExpAddin,     "N/A", "", strListSQLTools)
  End Select

  Select Case True
    Case strSetupPowerCfg <> ""
      ' Nothing
    Case Instr(Ucase(strOSName), " XP") > 0
      Call SetParam("SetupPowerCfg",         strSetupPowerCfg,         "N/A", "", strListOSVersion)
    Case Instr(Ucase(strOSName), "Vista") > 0
      Call SetParam("SetupPowerCfg",         strSetupPowerCfg,         "N/A", "", strListOSVersion)
    Case Instr(Ucase(strOSName), "Windows 7") > 0
      Call SetParam("SetupPowerCfg",         strSetupPowerCfg,         "N/A", "", strListOSVersion)
    Case Instr(Ucase(strOSName), "Windows 8") > 0
      Call SetParam("SetupPowerCfg",         strSetupPowerCfg,         "N/A", "", strListOSVersion)
    Case Else
      Call SetParam("SetupPowerCfg",         strSetupPowerCfg,         "YES", "Power Configuration recommended with " & strOSName, "")
  End Select

  Select Case True
    Case Instr(strOSType, "CORE") > 0
      Call SetParam("SetupProcExp",          strSetupProcExp,          "N/A", "", strListCore)
  End Select

  Select Case True
    Case Instr(strOSType, "CORE") > 0
      Call SetParam("SetupProcMon",          strSetupProcMon,          "N/A", "", strListCore)
  End Select

  Select Case True
    Case strSQLVersion < "SQL2008"
      Call SetParam("SetupPowerBI",          strSetupPowerBI,          "N/A", "", strListSQLVersion)
    Case strSetupSQLRS <> "YES"
      Call SetParam("SetupPowerBI",          strSetupPowerBI,          "N/A", "", strListSQLRS)
    Case strOSVersion < "6.2"
      Call SetParam("SetupPowerBI",          strSetupPowerBI,          "N/A", "", strListOSVersion)
    Case strFileArc = "X86"
      Call SetParam("SetupPowerBI",          strSetupPowerBI,          "N/A", "", strListOSVersion)
    Case strSetupPowerBI <> ""
      ' Nothing
    Case Else
      strSetupPowerBI = "NO"
  End Select

  Select Case True
    Case strSetupSQLTools <> "YES"
      Call SetParam("SetupPowerBIDesktop",   strSetupPowerBIDesktop,   "N/A", "", strListSQLTools)
    Case strSQLVersion < "SQL2008"
      Call SetParam("SetupPowerBIDesktop",   strSetupPowerBIDesktop,   "N/A", "", strListSQLVersion)
    Case strOSVersion < "6.2"
      Call SetParam("SetupPowerBIDesktop",   strSetupPowerBIDesktop,   "N/A", "", strListOSVersion)
    Case strFileArc = "X86"
      Call SetParam("SetupPowerBIDesktop",   strSetupPowerBIDesktop,   "N/A", "", strListOSVersion)
    Case strSetupPowerBIDesktop <> ""
      ' Nothing
    Case Else
      strSetupPowerBIDesktop = "NO"
  End Select

  Select Case True
    Case strSQLVersion < "SQL2017"
      Call SetParam("SetupPython",           strSetupPython,           "N/A", "", strListSQLVersion)
    Case strSetupSQLDB <> "YES"
      Call SetParam("SetupPython",           strSetupPython,           "N/A", "", strListSQLDB)
    Case strSetupPython <> ""
      ' Nothing
    Case Else
      strSetupPython = "NO"
  End Select

  Select Case True
    Case strSQLVersion >= "SQL2012" 
      Call SetParam("SetupRawReader",        strSetupRawReader,        "N/A", "", strListSQLVersion)
    Case strSetupSQLTools <> "YES"
      Call SetParam("SetupRawReader",        strSetupRawReader,        "N/A", "", strListSQLTools)
    Case strSetupSQLIS <> "YES"
      Call SetParam("SetupRawReader",        strSetupRawReader,        "N/A", "", strListSSIS)
    Case strSetupBIDS <> "YES"
      Call SetParam("SetupRawReader",        strSetupRawReader,        "NO",  "SSIS Raw File Reader can not be installed when BIDS is not installed", "")
  End Select

  Select Case True
    Case strSetupSQLTools <> "YES"
      Call SetParam("SetupRMLTools",         strSetupRMLTools,         "N/A", "", strListSQLTools)
  End Select

  Select Case True
    Case strSetupSQLTools <> "YES"
      Call SetParam("SetupRptTaskPad",       strSetupRptTaskPad,       "N/A", "", strListSQLTools)
  End Select

  Select Case True
    Case strSetupSQLRS <> "YES"
      Call SetParam("SetupRSAdmin",          strSetupRSAdmin,          "N/A", "", strListSQLRS)
      Call SetParam("SetupRSAlias",          strSetupRSAlias,          "N/A", "", strListSQLRS)
      Call SetParam("SetupRSExec",           strSetupRSExec,           "N/A", "", strListSQLRS)
      Call SetParam("SetupRSIndexes",        strSetupRSIndexes,        "N/A", "", strListSQLRS)
      Call SetParam("SetupRSKeepAlive",      strSetupRSKeepAlive,      "N/A", "", strListSQLRS)
    Case strSetupSQLDB <> "YES"
      Call SetParam("SetupRSIndexes",        strSetupRSIndexes,        "N/A", "", strListSQLDB)
      Call SetParam("SetupRSKeepAlive",      strSetupRSKeepAlive,      "N/A", "", strListSQLDB)
    Case Else
      If strSetupRSIndexes = "" Then
        Call SetParam("SetupRSIndexes",      strSetupRSIndexes,        "YES", "RSIndexes Recommended when SSRS installed", "")
      End If
      If strSetupRSKeepAlive = "" Then
        Call SetParam("SetupRSKeepAlive",    strSetupRSKeepAlive,      "YES", "RSKeepAlive Recommended when SSRS installed", "")
      End If
  End Select

  Select Case True
    Case Instr(strOSType, "SERVER") > 0
      Call SetParam("SetupRSAT",             strSetupRSAT,             "N/A", "", strListOSVersion)
    Case strOSVersion < "6.0"
      Call SetParam("SetupRSAT",             strSetupRSAT,             "N/A", "", strListOSVersion)
   Case strSetupRSAT > ""
      ' Nothing
   Case Else
      Call SetParam("SetupRSAT",             strSetupRSAT,             "YES", "RSAT is recommended for Client OS", "")
  End Select

  Select Case True
    Case strSetupSQLTools <> "YES"
      Call SetParam("SetupRSLinkGen",        strSetupRSLinkGen,        "N/A", "", strListSQLTools)
    Case strType = "CLIENT"
      ' Nothing
    Case strSetupSQLRS <> "YES"
      Call SetParam("SetupRSLinkGen",        strSetupRSLinkGen,        "N/A", "", strListSQLRS)
  End Select

  Select Case True
    Case strSetupSQLTools <> "YES"
      Call SetParam("SetupRSScripter",       strSetupRSScripter,       "N/A", "", strListSQLTools)
    Case strType = "CLIENT"
      ' Nothing
    Case strSetupSQLRS <> "YES"
      Call SetParam("SetupRSScripter",       strSetupRSScripter,       "N/A", "", strListSQLRS)
  End Select

  Select Case True
    Case strSQLVersion < "SQL2016"
      Call SetParam("SetupRServer",          strSetupRServer,          "N/A", "", strListSQLVersion)
    Case strSetupSQLDB <> "YES"
      Call SetParam("SetupRServer",          strSetupRServer,          "N/A", "", strListSQLDB)
    Case strSetupRServer <> ""
      ' Nothing
    Case Else
      strSetupRServer = "NO"
  End Select

  Select Case True
    Case strSQLVersion < "SQL2012"
      Call SetParam("SetupSemantics",        strSetupSemantics,        "N/A", "", strListSQLVersion)
    Case strType = "CLIENT"
      Call SetParam("SetupSemantics",        strSetupSemantics,        "N/A", "", strListType)
    Case strSetupSQLDB <> "YES"
      Call SetParam("SetupSemantics",        strSetupSemantics,        "N/A", "", strListSQLDB)
  End Select

  Select Case True
    Case strType = "CLIENT"
      Call SetParam("SetupSQLAgent",         strSetupSQLAgent,         "N/A", "", strListType)
    Case strSetupSQLDBAG <> "YES"
      Call SetParam("SetupSQLAgent",         strSetupSQLAgent,         "NO",  "SQL Agent can not be configured when it is not installed", "")
  End Select

  Select Case True 
    Case strSQLVersion >= "SQL2012" 
      Call SetParam("SetupSQLBC",            strSetupSQLBC,            "N/A", "", strListSQLVersion)     
    Case Instr(strOSType, "CORE") > 0
      Call SetParam("SetupSQLBC",            strSetupSQLBC,            "N/A", "", strListCore)
   End Select

  Select Case True
    Case strSetupSQLDB <> "YES"
      Call SetParam("SetupSQLDBFS",          strSetupSQLDBFS,          "N/A", "", strListSQLDB)
    Case strSQLVersion < "SQL2008"
      Call SetParam("SetupSQLDBFS",          strSetupSQLDBFS,          "N/A", "", strListSQLVersion)
    Case strSetupSQLDBFS <> "YES"
      strSetupSQLDBFS  = "NO"
    Case strFSLevel = "0"
      strSetupSQLDBFS  = "NO"
    Case (strFileArc = "X64") And (strWOWX86 = "TRUE")
      Call SetParam("SetupSQLDBFS",          strSetupSQLDBFS,          "NO",  "Filestream not available on WOW install", "")
    Case strSetupSQLDBCluster <> "YES"
      ' Nothing
    Case strActionSQLDB = "ADDNODE"
      ' Nothing
    Case GetBuildfileValue("VolDataFSType") <> "C" 
      Call SetBuildMessage(strMsgError, "/VolDataFS: parameter must specify a clustered disk")
  End Select

  Select Case True
    Case strSetupSQLDB <> "YES"
      Call SetParam("SetupSQLDBFT",          strSetupSQLDBFT,          "N/A", "", strListSQLDB)
    Case strSetupSQLDBCluster <> "YES"
      ' Nothing
    Case strSetupSQLDBFT <> ""
      ' Nothing
    Case Else
      Call SetParam("SetupSQLDBFT",          strSetupSQLDBFT,          "YES", "SQL Full Text is recommended for Cluster install", "")
  End Select

  Select Case True
    Case strType = "CLIENT"
      Call SetParam("SetupSQLInst",          strSetupSQLInst,          "N/A", "", strListType)
    Case strActionSQLDB = "ADDNODE"
      Call SetParam("SetupSQLInst",          strSetupSQLInst,          "N/A", "", strListAddNode)
    Case strSetupSQLDB <> "YES"
      Call SetParam("SetupSQLInst",          strSetupSQLInst,          "N/A", "", strListSQLDB)
  End Select

  Select Case True
    Case strOSVersion >= "6.2"
      Call SetParam("SetupSQLNS",            strSetupSQLNS,            "N/A", "", strListOSVersion)
    Case strMainInstance <> "YES"
      Call SetParam("SetupSQLNS",            strSetupSQLNS,            "NO",  "", strListMain)
  End Select

  Select Case True
    Case strSetupSQLDB <> "YES"
      Call SetParam("SetupSQLDBRepl",        strSetupSQLDBRepl,        "N/A", "", strListSQLDB)
    Case strSetupSQLDBCluster <> "YES"
      ' Nothing
    Case strSetupSQLDBRepl <> ""
      ' Nothing
    Case Else
      Call SetParam("SetupSQLDBRepl",        strSetupSQLDBRepl,        "YES", "SQL Replication is recommended for Cluster install", "")
  End Select

  Select Case True
    Case strSetupSQLTools <> "YES"
      Call SetParam("SetupSQLNexus",         strSetupSQLNexus,         "N/A", "", strListSQLTools)
  End Select

  Select Case True
    Case strSetupSQLRS <> "YES"
      Call SetParam("SetupSQLRSCluster",     strSetupSQLRSCluster,     "N/A", "", strListSQLRS)
    Case strClusterAction = ""
      Call SetParam("SetupSQLRSCluster",     strSetupSQLRSCluster,     "N/A", "", strListCluster)
    Case strSetupSQLRSCluster <> ""
      ' Nothing
    Case Else
      Call SetParam("SetupSQLRSCluster",     strSetupSQLRSCluster,     "YES", "SSRS Cluster will be installed automatically", "")
  End Select

  Select Case True
    Case strType = "CLIENT"
      Call SetParam("SetupSQLServer",        strSetupSQLServer,        "N/A", "", strListType)
    Case strActionSQLDB = "ADDNODE"
      Call SetParam("SetupSQLServer",        strSetupSQLServer,        "N/A", "", strListAddNode)
    Case strSetupSQLDB <> "YES"
      Call SetParam("SetupSQLServer",        strSetupSQLServer,        "N/A", "", strListSQLDB)
  End Select

  Select Case True 
    Case strSetupSQLTools <> "YES"
      Call SetParam("SetupSSDTBI",           strSetupSSDTBI,           "N/A", "", strListSQLTools)
    Case strSQLVersion < "SQL2012"
      Call SetParam("SetupSSDTBI",           strSetupSSDTBI,           "N/A", "", strListSQLVersion)
    Case Instr(strOSType, "CORE") > 0
      Call SetParam("SetupSSDTBI",           strSetupSSDTBI,           "N/A", "", strListCore)
    Case strSetupSSDTBI = ""
      Call SetParam("SetupSSDTBI",           strSetupSSDTBI,           "YES", "SSDTBI Recommended for " & strSQLVersion, "")
  End Select

  Select Case True 
    Case strSetupSQLDB <> "YES"
      Call SetParam("SetupSSISDB",           strSetupSSISDB,           "N/A", "", strListSQLDB)
    Case strSetupSQLIS <> "YES"
      Call SetParam("SetupSSISDB",           strSetupSSISDB,           "N/A", "", strListSSIS)
    Case strSQLVersion <= "SQL2008R2"
      Call SetParam("SetupSSISDB",           strSetupSSISDB,           "N/A", "", strListSQLVersion)
    Case strActionSQLDB = "ADDNODE"
      Call SetParam("SetupSSISDB",           strSetupSSISDB,           "N/A", "", strListAddNode)
  End Select

  Select Case True
    Case strSetupSQLTools <> "YES"
      Call SetParam("SetupSSMS",             strSetupSSMS,             "N/A", "", strListSQLTools)
    Case strSetupSSMS <> ""
      ' Nothing
    Case Else
      Call SetParam("SetupSSMS",             strSetupSSMS,             "YES", "SSMS is recommended for " & strSQLVersion, "")
  End Select

  Select Case True
    Case strSetupSSMS <> "YES"
      ' Nothing
    Case strOSVersion <= "6.0"
      Call SetParam("UseFreeSSMS",           strUseFreeSSMS,           "N/A", "", strListOSVersion)
    Case strSSMSexe = ""
      Call SetParam("UseFreeSSMS",           strUseFreeSSMS,           "NO",  "SSMS install file not found", "")
    Case strUseFreeSSMS <> ""
      ' Nothing
    Case strSQLVersion >= "SQL2016"
      Call SetParam("UseFreeSSMS",           strUseFreeSSMS,           "YES", "Free SSMS is required for " & strSQLVersion, "")
  End Select

  Select Case True
    Case strSetupSSMS <> "YES"
      ' Nothing
    Case strUseFreeSSMS <> "YES"
      ' Nothing
    Case Else
      Call SetParam("SetupNet4",             strSetupNet4,             "YES", ".Net4.0 or above mandatory for SSMS", "")
      Call SetParam("SetupNet4x",            strSetupNet4x,            "YES", ".Net4.5 or above mandatory for SSMS", "")
  End Select

  Select Case True 
    Case strSetupSQLDB <> "YES"
      Call SetParam("SetupSAAccounts",       strSetupSAAccounts,       "N/A", "", strListSQLDB)
  End Select

  Select Case True 
    Case strSetupSQLDB <> "YES"
      Call SetParam("SetupStdAccounts",      strSetupStdAccounts,      "N/A", "", strListSQLDB)
  End Select

  Select Case True
    Case strSQLVersion < "SQL2008R2"
      Call SetParam("SetupStreamInsight",    strSetupStreamInsight,    "N/A", "", strListSQLVersion)
    Case strSetupStreamInsight <> "YES"
      ' Nothing
    Case strOSVersion < "6.0"
      Call SetParam("SetupStreamInsight",    strSetupStreamInsight,    "N/A", "", strListOSVersion)
    Case strEdition = "ENTERPRISE EVALUATION"
      ' Nothing
    Case strType = "CLIENT"
      ' Nothing
    Case strPID = ""
      Call SetBuildMessage(strMsgError, "/PID: is mandatory for StreamInsight")
  End Select

  Select Case True
    Case strSQLVersion < "SQL2016"
      Call SetParam("SetupStretch",          strSetupStretch,          "N/A", "", strListSQLVersion)
    Case strSetupSQLDB <> "YES"
      Call SetParam("SetupStretch",          strSetupStretch,          "N/A", "", strListSQLDB)
    Case strSetupStretch = ""
      Call SetParam("SetupStretch",          strSetupStretch,          "NO",  "Stretch Database default is No", "")
  End Select

  Select Case True 
    Case strSetupSQLDB <> "YES"
      Call SetParam("SetupSysDB",            strSetupSysDB,            "N/A", "", strListSQLDB)
  End Select

  Select Case True 
    Case strSetupSQLDB <> "YES"
      Call SetParam("SetupSysIndex",         strSetupSysIndex,         "N/A", "", strListSQLDB)
  End Select

  Select Case True 
    Case strSetupSQLDB <> "YES"
      Call SetParam("SetupSysManagement",    strSetupSysManagement,    "N/A", "", strListSQLDB)
  End Select

  Select Case True
    Case strSetupSQLTools <> "YES"
      Call SetParam("SetupSystemViews",      strSetupSystemViews,      "N/A", "", strListSQLTools)
  End Select

  Select Case True 
    Case strSetupSQLDB <> "YES"
      Call SetParam("SetupTempDB",           strSetupTempDB,           "N/A", "", strListSQLDB)
  End Select

  Select Case True
    Case strSQLVersion <= "SQL2005"
      Call SetParam("SetupTLS12",            strSetupTLS12,            "N/A", "", strListSQLVersion)
   Case strSetupTLS12 = ""
      strSetupTLS12 = "YES"
  End Select

  Select Case True
    Case strSetupSQLTools <> "YES"
      Call SetParam("SetupTrouble",          strSetupTrouble,          "N/A", "", strListSQLTools)
  End Select

  Select Case True
    Case strOSVersion < "6.0"
      Call SetParam("SetupVC2010",           strSetupVC2010,           "N/A", "", strListOSVersion)
    Case strSetupDB2OLE = "YES"
      Call SetParam("SetupVC2010",           strSetupVC2010,           "YES", "Visual C 2010 is mandatory for DB2OLEDB", "")
    Case strSetupVC2010 <> ""
      ' Nothing
    Case Else
      strSetupVC2010 = "NO"
  End Select

  Select Case True
    Case strSetupSQLTools <> "YES"
      Call SetParam("SetupVS",               strSetupVS,               "N/A", "", strListSQLTools)
    Case strType = "CLIENT"
      ' Nothing
    Case strSetupSQLIS <> "YES"
      Call SetParam("SetupVS",               strSetupVS,               "N/A", "", strListSSIS)
  End Select

  Select Case True 
    Case strSetupWinAudit <> ""
      ' Nothing
    Case strType = "WORKSTATION"
      Call SetParam("SetupWinAudit",         strSetupWinAudit,         "N/A", "", strListType)
    Case Else
      strSetupWinAudit = "YES"
  End Select

  Select Case True
    Case strSetupSQLTools <> "YES"
      Call SetParam("SetupWindows",          strSetupWindows,          "N/A", "", strListSQLTools)
  End Select

  Select Case True
    Case strSetupSQLTools <> "YES"
      Call SetParam("SetupXEvents",          strSetupXEvents,          "N/A", "", strListSQLTools)
    Case strSQLVersion < "SQL2008"
      Call SetParam("SetupXEvents",          strSetupXEvents,          "N/A", "", strListSQLVersion)
    Case strSQLVersion >= "SQL2012" 
      Call SetParam("SetupXEvents",          strSetupXEvents,          "N/A", "", strListSQLVersion)
  End Select

  Select Case True
    Case strSetupSQLTools <> "YES"
      Call SetParam("SetupXMLNotepad",       strSetupXMLNotepad,       "N/A", "", strListSQLTools)
  End Select

  Select Case True
    Case strSetupSQLTools <> "YES"
      Call SetParam("SetupZoomIt",           strSetupZoomIt,           "N/A", "", strListSQLTools)
  End Select

End Sub


Sub SetupDataDep1()
  Call SetProcessId("0BMC", "Setup Parameter Data for Dependency Level 1")

  Select Case True
    Case strSetupSQLTools <> "YES"
      Call SetParam("SetupBIDSHelper",       strSetupBIDSHelper,       "N/A", "", strListSQLTools)
    Case (strSQLVersion <= "SQL2008R2") And (strSetupBIDS <> "YES")
      Call SetParam("SetupBIDSHelper",       strSetupBIDSHelper,       "NO",  "BIDS Helper can not be installed when BIDS is not installed", "")
    Case (strSQLVersion >= "SQL2012") And (strSetupSSDTBI <> "YES")
      Call SetParam("SetupBIDSHelper",       strSetupBIDSHelper,       "NO",  "BIDS Helper can not be installed when SSDTBI is not installed", "")
    Case strType = "CLIENT"
      ' Nothing
    Case strSetupSQLIS <> "YES"
      Call SetParam("SetupBIDSHelper",       strSetupBIDSHelper,       "N/A", "", strListSSIS)
  End Select

  Select Case True
    Case strSetupSQLTools <> "YES"
      Call SetParam("SetupDTSBackup",        strSetupDTSBackup,        "N/A", "", strListSQLTools)
    Case strSetupDTSDesigner <> "YES"
      Call SetParam("SetupDTSBackup",        strSetupDTSBackup,        "NO",  "DTS Backup can not be installed when DTS Designer is not installed", "")
  End Select

  strFSInstLevel   = strFSLevel
  Select Case True
    Case strSetupSQLDBFS <> "YES"
      strFSLevel     = "0"
      strFSInstLevel = strFSLevel
      strFSShareName = ""
    Case strSetupSQLDBCluster <> "YES"
      ' Nothing
    Case strFSLevel > "0"
      Call SetParam("FSLevel",               strFSLevel,               "3",   "Required level for Filestream for " & strSQLVersion & " Cluster install", "")
      strFSInstLevel   = "0"
  End Select

  Select Case True 
    Case strSetupDTSDesigner = "YES"
      Call SetParam("SetupSQLBC",            strSetupSQLBC,            "YES", "Backward Compatibility mandatory for DTS Designer", "")
  End Select

  Select Case True
    Case (strProcessId > "1") And (strProcessId <> "7")
      strSetupDTCCID = GetBuildfileValue("SetupDTCCID")
    Case strSetupDTCNetAccessStatus = strStatusComplete
      Call SetParam("SetupDTCCID",           strSetupDTCCID,           "NO",  "MSDTC CID is already configured", "")
    Case strActionSQLDB = "ADDNODE"
      Call SetParam("SetupDTCCID",           strSetupDTCCID,           "N/A", "", strListAddnode)
    Case strSetupDTCNetAccess = "YES" 
      Call SetParam("SetupDTCCID",           strSetupDTCCID,           "YES", "New MSDTC CID mandatory for DTC Net Access", "")
  End Select

  Select Case True
    Case strSQLVersion <> "SQL2005"
      ' Nothing
    Case strSetupSQLRS = "YES" 
      Call SetParam("SetupIIS",              strSetupIIS,              "YES", "IIS mandatory for Reporting Services", "")
  End Select

  Select Case True
    Case strOSVersion < "6"
      Call SetParam("SetupKB2862966",        strSetupKB2862966,        "N/A", "", strListOSVersion)
    Case strOSVersion > "6.2"
      Call SetParam("SetupKB2862966",        strSetupKB2862966,        "N/A", "", strListOSVersion)
    Case strUseFreeSSMS = "YES"
      Call SetParam("SetupKB2862966",        strSetupKB2862966,        "YES",  "KB2862966 is recommended for SSMS", "")
    Case strSetupKB2862966 = ""
      strSetupKB2862966 = "NO"
  End Select

  Select Case True
    Case strSQLVersion < "SQL2008R2"
      Call SetParam("SetupMDSC",             strSetupMDSC,             "N/A", "", strListSQLVersion)
    Case strSetupSQLTools <> "YES"
      Call SetParam("SetupMDSC",             strSetupMDSC,             "N/A", "", strListSQLTools)
    Case strSetupMDSC <> ""
      ' Nothing
    Case Else 
      Call SetParam("SetupMDSC",             strSetupMDSC,             "YES", "MDS Client is recommended", "")
  End Select

  Select Case True
    Case strSetupRSAlias = "YES" 
      Call SetParam("SetupIIS",              strSetupIIS,              "YES", "IIS mandatory for Reporting Services Alias", "")
  End Select

  Select Case True
    Case strSQLVersion < "SQL2008R2"
      ' Nothing
    Case strSetupMDS = "YES" 
      Call SetParam("SetupIIS",              strSetupIIS,              "YES", "IIS mandatory for Master Data Services", "")
      Call SetParam("OptCLREnabled",         strOptCLREnabled,         "1",   "CLR mandatory for Master Data Services", "")
  End Select

  Select Case True
    Case strSetupSQLRS <> "YES"
      ' Nothing
    Case strSetupIIS <> "YES" 
      ' Nothing
    Case Else
      Call SetParam("SetupRSAlias",          strSetupRSAlias,          "YES", "RS Alias required if IIS installed", "")
  End Select    

  Select Case True
    Case strSQLVersion <= "SQL2005"
      Call SetParam("SetupKB954961",         strSetupKB954961,         "N/A", "", strListSQLVersion)
    Case GetBuildfileValue("MenuSQL2005Flag") <> "Y"
      Call SetParam("SetupKB954961",         strSetupKB954961,         "N/A", "", strListSQLVersion)
    Case strSetupBIDS <> "YES"
      Call SetParam("SetupKB954961",         strSetupKB954961,         "NO",  "KB954961 can not be installed when BIDS is not installed", "")
    Case Else
      Call SetParam("SetupKB954961",         strSetupKB954961,         "YES", "KB954961 is recommended when SQL2005 previously installed", "")
  End Select

  Select Case True
    Case strSetupNet4 <> "YES"
      Call SetParam("SetupKB956250",         strSetupKB956250,         "NO",  "KB956250 can not be installed when .Net v4 is not installed", "")
    Case strOSVersion <> "6.0"
      Call SetParam("SetupKB956250",         strSetupKB956250,         "N/A", "", strListOSVersion)
    Case Else
      Call SetParam("SetupKB956250",         strSetupKB956250,         "YES", "KB956250 mandatory for .Net v4 on " & strOSName, "")
  End Select

  Select Case True
    Case strSetupSQLTools <> "YES"
      Call SetParam("SetupKB2781514",        strSetupKB2781514,        "N/A", "", strListSQLTools)
    Case strSQLVersion < "SQL2012"
      Call SetParam("SetupKB2781514",        strSetupKB2781514,        "N/A", "", strListSQLVersion)
    Case strSetupBPAnalyzer <> "YES" 
      Call SetParam("SetupKB2781514",        strSetupKB2781514,        "NO",  "KB2781514 can not be installed when Best Practice Analyzer is not installed", "")
    Case strSetupKB2781514 = ""
      Call SetParam("SetupKB2781514",        strSetupKB2781514,        "YES", "KB2781514 recommended if Best Practice Analyzer installed", "")
   End Select

  Select Case True
    Case strOSVersion <> "6.3" ' Windows 2012 R2
      Call SetParam("SetupKB3090973",        strSetupKB3090973,        "N/A", "", strListOSVersion)
    Case strStatusKB2919355 = ""
      Call SetParam("SetupKB3090973",        strSetupKB3090973,        "N/A", "", strListOSVersion)
    Case Else
      Call SetParam("SetupKB3090973",        strSetupKB3090973,        "YES", "KB3090973 recommended for Windows 2012 R2 MSDTC", "")
  End Select

  Select Case True
    Case strOSVersion < "6.1" ' Windows 2008 R2
      Call SetParam("SetupKB4019990",        strSetupKB4019990,        "N/A", "", strListOSVersion)
    Case strOSVersion > "6.2" ' Windows 2012
      Call SetParam("SetupKB4019990",        strSetupKB4019990,        "N/A", "", strListOSVersion)
    Case GetBuildfileValue("Net4Xexe") < "NDP462"
      Call SetParam("SetupKB4019990",        strSetupKB4019990,        "N/A", "", strListOSVersion)
    Case Else
      Call SetParam("SetupKB4019990",        strSetupKB4019990,        "YES", "KB4019990 mandatory for .Net 4.x", "")
  End Select

  Select Case True
    Case strSetupSQLTools <> "YES"
      Call SetParam("SetupMBCA",             strSetupMBCA,             "N/A", "", strListSQLTools)
    Case (strSetupBPAnalyzer = "YES") And (strSQLVersion = "SQL2005")
      If strSetupMBCA = "" Then
        strSetupMBCA = "NO"
      End If
    Case (strSetupBPAnalyzer = "YES") And (Instr(Ucase(strOSName), " XP") > 0 )
      Call SetParam("SetupBPAnalyzer",       strSetupBPAnalyzer,       "N/A", "", strListOSVersion)
      Call SetParam("SetupMBCA",             strSetupMBCA,             "N/A", "", strListOSVersion)
    Case (strSetupBPAnalyzer = "YES") And (Instr(Ucase(strOSName), "VISTA") > 0 )
      Call SetParam("SetupBPAnalyzer",       strSetupBPAnalyzer,       "N/A", "", strListOSVersion)
      Call SetParam("SetupMBCA",             strSetupMBCA,             "N/A", "", strListOSVersion)
    Case strSetupBPAnalyzer = "YES" 
      Call SetParam("SetupMBCA",             strSetupMBCA,             "YES", "Microsoft Baseline Configuration Analyzer mandatory for SQL BPA", "")
    Case strSetupMBCA = ""
      strSetupMBCA  = "NO"
  End Select
  If strSetupMBCA = "YES" Then
    Call SetParam("SetupNet3",               strSetupNet3,             "YES", ".Net3 mandatory for Microsoft Baseline Configuration Analyzer", "")
  End If

  Select Case True
    Case strOSVersion > "6.1"
      Call SetParam("SetupPS2",              strSetupPS2,              "N/A", "", strListOSVersion)
    Case strSetupPS2 <> ""
      ' Nothing
    Case strSQLVersion >= "SQL2008"
      Call SetParam("SetupPS2",              strSetupPS2,              "YES", "PS2 is mandatory for " & strSQLVersion, "")
  End Select

  Select Case True
    Case strOSVersion > "6.0"
      Call SetParam("SetupPS1",              strSetupPS1,              "N/A", "", strListOSVersion)
    Case strSetupPS2 = "YES"
      Call SetParam("SetupPS1",              strSetupPS1,              "No",  "PS1 not required when PS2 being installed", "")
    Case strSQLVersion <= "SQL2008"
      Call SetParam("SetupPS1",              strSetupPS1,              "YES", "PS1 is mandatory for " & strSQLVersion, "")
  End Select

  Select Case True
    Case strSetupSQLTools <> "YES"
      Call SetParam("SetupReportViewer",     strSetupReportViewer,     "N/A", "", strListSQLTools)
    Case Else
      If strSetupRMLTools = "YES" Then
        Call SetParam("SetupReportViewer",   strSetupReportViewer,     "YES", "Report Viewer mandatory for RML Tools", "")
      End If
      If strSetupSQLNexus = "YES" Then
        Call SetParam("SetupReportViewer",   strSetupReportViewer,     "YES", "Report Viewer mandatory for SQL Nexus", "")
      End If
  End Select

  Select Case True
    Case strSetupSQLRSCluster = "YES"
      Call SetParam("SetupRSAdmin",          strSetupRSAdmin,          "YES", "RS Administration Configuration mandatory for SSRS Cluster", "")
      Call SetParam("SetupRSExec",           strSetupRSExec,           "YES", "RS Report Execution Account mandatory for SSRS Cluster", "")
  End Select

  Select Case True
    Case strSetupStreamInsight = "YES"
      Call SetParam("SetupNet4",             strSetupNet4,             "YES", ".Net4.0 or above mandatory for StreamInsight", "")
      Call SetParam("SetupSQLCE",            strSetupSQLCE,            "YES", "SQL Compact Edition mandatory for StreamInsight", "")
    Case strSetupSQLCE <> ""
      ' Nothing
    Case Else
      strSetupSQLCE = "NO"
  End Select

  Select Case True    
    Case strSQLVersion > "SQL2005"
      Call SetParam("SetupVS2005SP1",        strSetupVS2005SP1,        "N/A", "", strListSQLVersion)
    Case strSetupSQLTools <> "YES"
      Call SetParam("SetupVS2005SP1",        strSetupVS2005SP1,        "N/A", "", strListSQLTools)
    Case strSetupBIDS <> "YES"
      Call SetParam("SetupVS2005SP1",        strSetupVS2005SP1,        "N/A", "Visual Studio 2005 SP1 can not be installed when BIDS is not installed", "")
    Case strSetupVS2005SP1 <> ""
      ' Nothing
    Case Else
      Call SetParam("SetupVS2005SP1",        strSetupVS2005SP1,        "YES", "Visual Studio 2005 SP1 recommended when BIDS is installed", "")
  End Select

  Select Case True
    Case strSQLVersion < "SQL2012"
      Call SetParam("SetupVS2010SP1",        strSetupVS2010SP1,        "N/A", "", strListSQLVersion)
    Case strSQLVersion > "SQL2014"
      Call SetParam("SetupVS2010SP1",        strSetupVS2010SP1,        "N/A", "", strListSQLVersion)
    Case strSetupSQLTools <> "YES"
      Call SetParam("SetupVS2010SP1",        strSetupVS2010SP1,        "N/A", "", strListSQLTools)
    Case strSetupSSMS <> "YES"
      Call SetParam("SetupVS2010SP1",        strSetupVS2010SP1,        "N/A", "", strListSQLVersion)
    Case strSSMSexe <> ""
      Call SetParam("SetupVS2010SP1",        strSetupVS2010SP1,        "N/A", "", strListSQLVersion)
    Case strSetupVS2010SP1 <> ""
      ' Nothing
    Case Else
      Call SetParam("SetupVS2010SP1",        strSetupVS2010SP1,        "YES", "Visual Studio 2010 SP1 recommended for " & strSQLVersion, "")
  End Select

End Sub


Sub SetupDataDep2()
  Call SetProcessId("0BMD", "Setup Parameter Data for Dependency Level 2")  

  Select Case True
    Case strSetupSSISDB = "YES"
      Call SetParam("OptCLREnabled",         strOptCLREnabled,         "1",  "CLR Required for SSIS Catalog DB", "")
  End Select

  Select Case True
    Case strOSVersion <> "6.0"
      Call SetParam("SetupKB932232",         strSetupKB932232,         "N/A", "", strListOSVersion)
    Case strSQLVersion > "SQL2005"
      Call SetParam("SetupKB932232",         strSetupKB932232,         "N/A", "", strListSQLVersion)
    Case strSetupVS2005SP1 <> "YES"
      Call SetParam("SetupKB932232",         strSetupKB932232,         "NO",  "KB932232 can not be installed when Visual Studio 2005 SP1 is not installed", "")
    Case Else
      Call SetParam("SetupKB932232",         strSetupKB932232,         "YES", "KB932232 recommended when Visual Studio 2005 SP1 is installed", "")
  End Select

  Select Case True
    Case strSetupMBCA = "YES"
      Call SetParam("SetupPS2",              strSetupPS2,              "YES", "Powershell V2 mandatory for Microsoft Baseline Configuration Analyzer", "")
    Case strSQLVersion >= "SQL2012"
      Call SetParam("SetupPS2",              strSetupPS2,              "YES", "Powershell V2 mandatory for " & strSQLVersion, "")
  End Select

  Select Case True
    Case strSetupReportViewer = "YES"
      Call SetParam("SetupNet3",             strSetupNet3,             "YES", ".Net3 mandatory for Report Viewer", "")
    Case strSetupReportViewer = ""
      strSetupReportViewer = "NO"
  End Select

  Select Case True
    Case strSetupSQLNexus = "YES"
      Call SetParam("SetupNet4",             strSetupNet4,             "YES", ".Net4 mandatory for SQL Nexus", "")
  End Select

End Sub


Sub SetupDataDep3()
  Call SetProcessId("0BME", "Setup Parameter Data for Dependency Level 3")  

  Select Case True
    Case strOSVersion >= "6.1"
      ' Nothing
    Case strSQLVersion >= "SQL2008"
      Call SetParam("SetupMSI45",            strSetupMSI45,            "YES", "Installer v4.5 mandatory for " & strSQLVersion, "")
    Case (strSetupPS2 = "YES") And (strOSVersion >= "6.0")
      Call SetParam("SetupMSI45",            strSetupMSI45,            "YES", "Installer v4.5 mandatory for Powershell", "")
  End Select

  Select Case True
    Case strSetupPS2 = "YES"
      Call SetParam("SetupNet3",              strSetupNet3,            "YES", ".Net3 mandatory for Powershell", "")
  End Select

End Sub


Sub GetMiscData()
  Call SetProcessId("0BN", "Get Miscellaneous data for Buildfile")
  Dim strTF, strExchServer, strLogin, strPassword, strWorkRSMode

  intIdx            = Int((intProcNum / 1.5) + 1)
  Select Case True
    Case strMaxDop = ""
      strMaxDop     = intIdx
    Case strMaxDop = 0
      strMaxDop     = intIdx
  End Select
  If strMaxDop > 8 Then
    strMaxDop       = 8
  End If
  If strSQLTempdbFileCount = "" Then
    strSQLTempdbFileCount = strMaxDop
  End If

  Select Case True
    Case colArgs.Exists("AllowUpgradeForRSSharePointMode")
      strAllowUpgradeForRSSharePointMode = "YES"
    Case Else
      strAllowUpgradeForRSSharePointMode = "NO"
  End Select

  Select Case True
    Case colArgs.Exists("CLUSTERPASSIVE")
      strClusterPassive = "YES"
    Case Else
      strClusterPassive = "NO"
  End Select

  Select Case True
    Case strOSVersion < "6.0"
      strDefaultUser = "Default User"
    Case Else
      strDefaultUser = "Default"
  End Select 
  strPath           = strProfDir & "\" & strDefaultUser 
  strDfltDoc        = Replace(objShell.RegRead(strUserReg & "Personal"),   "%USERPROFILE%", strPath)
  strDfltProf       = Replace(objShell.RegRead(strUserReg & "Start Menu"), "%USERPROFILE%", strPath)
  strDfltRoot       = Replace(objShell.RegRead(strUserReg & "AppData"),    "%USERPROFILE%", strPath)

  strExchServer     = GetUserAttr(strSQLAccount, strUserDnsDomain, "msExchHomeServerName")
  strDebugMsg1      = "Mail Server: " & strMailServer
  strDebugMsg2      = "Exch Server: " & strExchServer
  Select Case True
    Case strMailServer <> ""
      ' Nothing
    Case strExchServer = ""
      ' Nothing
    Case Else
      strMailServer     = Mid(strExchServer, InstrRev(strExchServer, "=") + 1)
      strMailServerType = "E"
  End Select

  strIISRoot        = strVolSys & ":\inetpub\wwwroot"

  Select Case True
    Case (strSQLVersion = "SQL2005") And (strWOWX86 = "TRUE")
      strRegSSIS      = "HKLM\SOFTWARE\Wow6432Node\Microsoft\MSDTS\ServiceConfigFile\"
      strRegSSISSetup = "HKLM\SOFTWARE\Wow6432Node\Microsoft\MSDTS\Setup\DTSPath\"
    Case strSQLVersion = "SQL2005" 
      strRegSSIS      = "HKLM\SOFTWARE\Microsoft\MSDTS\ServiceConfigFile\"
      strRegSSISSetup = "HKLM\SOFTWARE\Microsoft\MSDTS\Setup\DTSPath\"
    Case Else
      strRegSSIS      = strHKLMSQL & strSQLVersionNum & "\SSIS\ServiceConfigFile\"
      strRegSSISSetup = strHKLMSQL & strSQLVersionNum & "\SSIS\Setup\DTSPath\"
  End Select

  strRegTools       = strHKLMSQL & strSQLVersionNum & "\Tools\ClientSetup\"
  Select Case True
    Case strSQLVersion = "SQL2005"
      objWMIReg.GetStringValue strHKLM,Mid(strRegTools, 6),"Path",strPathTools
    Case strSQLVersion <= "SQL2012"
      objWMIReg.GetStringValue strHKLM,Mid(strRegTools, 6),"SQLPath",strPathTools
    Case Else
      objWMIReg.GetStringValue strHKLM,Mid(strRegTools, 6),"ODBCToolsPath",strPathTools
  End Select
  If IsNull(strPathTools) Then
    strPathTools    = ""
  End If

  Select Case True
    Case strPathTools = ""
      strPathSQLCmd = ""
    Case strSQLVersion = "SQL2005"
      strPathSQLCmd = strPathTools & "SQLCMD.EXE"
    Case strSQLVersion <= "SQL2012"
      strPathSQLCmd = strPathTools & "\Binn\SQLCMD.EXE"
    Case Else
      strPathSQLCmd = strPathTools & "SQLCMD.EXE"
  End Select
  If strPath <> "" Then
    strCmdSQL       = """" & strPathSQLCmd & """ -S """ & strServInst & """ -E -b -e "
    Call SetBuildfileValue("CmdSQL", strCmdSQL)
  End If

  Select Case True
    Case strOSLevel >= "6"
      strSchedLevel = "2"
    Case (Instr(Ucase(strOSName), " XP") > 0) And (Instr(strOSType, "STARTER") > 0)
      strSchedLevel = "0"
    Case Else
      strSchedLevel = "1"
  End Select

  Select Case True
    Case strInstance = "MSSQLSERVER"
      strRSDBName   = "ReportServer"
    Case Else
      strRSDBName   = "ReportServer" & "$" & strInstance
  End Select

  strInstRSWMI      = "RS_" & Replace(Replace(Replace(strInstRSSQL, "_", "_5f"), "$", "_24"), "@", "_40")

  Select Case True
    Case strEdition = "EXPRESS" 
      strInstRSHost = strServer & ":80"
    Case Else
      strInstRSHost = strServer
  End Select

  Select Case True
    Case strRSExecAccount = ""
      ' Nothing
    Case Instr(strRSExecAccount, "\") = 0 
      strRSExecAccount = strDomain & "\" & strRSExecAccount
  End Select
  strRSEmail        = GetParam(Null,                  "RSEmail",            "",                    strRSExecAccount)
  intIdx            = Instr(strRSEmail, "\")
  Select Case True
    Case strRSEmail = ""
      ' Nothing
    Case strUserDNSDomain = ""
      strRSEmail    = ""
    Case intIdx > 0
      strRSEmail    = Mid(strRSEmail, intIdx + 1) & "@" & strUserDNSDomain
    Case Instr(strRSEmail, "@") = 0
      strRSEmail    = strRSEmail & "@" & strUserDNSDomain
  End Select

  Select Case True
    Case strRsShareAccount = ""
      ' Nothing
    Case Instr(strRsShareAccount, "\") = 0 
      strRsShareAccount = strDomain & "\" & strRsShareAccount
  End Select

  strRSVersion      = Left(strSQLVersionNet, Instr(strSQLVersionNet, ".") - 1)

  Select Case True
    Case strSQLVersion <= "SQL2005"
      strRSWMIPath  = "winmgmts:{impersonationLevel=impersonate}!\\.\root\Microsoft\SqlServer\ReportServer\v" & strRSVersionNum & "\Admin"
    Case strSQLVersion >= "SQL2017"
      strRSWMIPath  = "winmgmts:{impersonationLevel=impersonate}!\\.\root\Microsoft\SqlServer\ReportServer\" & strInstRSWMI & "\V" & strRSVersionNum & "\Admin"
    Case strSetupPowerBI = "YES"
      strRSWMIPath  = "winmgmts:{impersonationLevel=impersonate}!\\.\root\Microsoft\SqlServer\ReportServer\" & strInstRSWMI & "\V" & strRSVersionNum & "\Admin"
    Case Else
      strRSWMIPath  = "winmgmts:{impersonationLevel=impersonate}!\\.\root\Microsoft\SqlServer\ReportServer\" & strInstRSWMI & "\v" & strRSVersionNum & "\Admin"
  End Select

  strSQLEmail       = GetParam(Null,                  "SQLEmail",           "",                    strDBAEmail)
  If strSQLEmail = "" Then
    strSQLEmail     = strSQLAccount
  End If
  intIdx            = Instr(strSQLEmail, "\")
  Select Case True
    Case intIdx > 0
      strSQLEmail   = Mid(strSQLEmail, intIdx + 1) & "@" & strUserDNSDomain
    Case Instr(strSQLEmail, "@") = 0
      strSQLEmail   = strSQLEmail & "@" & strUserDNSDomain
  End Select

  strSQLSupportMsi  = strFileArc & "\Setup\SqlSupport.msi"

  strLocalDomain    = strServer
  Select Case True
    Case strUserDnsDomain = ""
      ' Nothing
    Case Else
      strDC         = objSysInfo.GetAnyDCName
      strDC         = Left(strDC, Instr(strDC, ".") - 1)  
      If strServer = strDC Then
        strLocalDomain = strDomain
      End If
  End Select

  Select Case True
    Case strSQLVersion <= "SQL2005"
      strWorkRSMode        = GetParam(colGlobal,      "RSConfiguration",    "",                    "Default")
    Case strSQLVersion < "SQL2012"
      strWorkRSMode        = GetParam(colGlobal,      "RSInstallMode",      "",                    "DefaultNativeMode")
    Case strSQLVersion < "SQL2017"
      strWorkRSMode        = GetParam(colGlobal,      "RSInstallMode",      "",                    "DefaultNativeMode")
      strRSShpInstallMode  = GetParam(colGlobal,      "RSShpInstallMode",   "",                    "DefaultSharePointMode")
    Case Else
      strWorkRSMode        = GetParam(colGlobal,      "RSInstallMode",      "",                    "DefaultNativeMode")
  End Select
  strRSInstallMode   = GetBuildfileValue("RSInstallMode")
  If strRSInstallMode = "" Then
    strRSInstallMode = strWorkRSMode
  End If

  Select Case True
    Case strSQLVersion = "SQL2005"
      strSQLSvcStartupType = GetParam(colGlobal,      "SQLAutoStart",       "",                    "1")
      strAGTSvcStartupType = GetParam(colGlobal,      "AGTAutoStart",       "",                    "1")
      strASSvcStartupType  = GetParam(colGlobal,      "ASAutoStart",        "",                    "0")
      strIsSvcStartupType  = GetParam(colGlobal,      "ISAutoStart",        "IsSvcStartupType",    "1")
      strRSSvcStartupType  = GetParam(colGlobal,      "RSAutoStart",        "",                    "0")
      strSqlBrowserStartup = GetParam(colGlobal,      "SQLBrowserAutoStart","",                    "0")
      strWriterSvcStartupType = GetParam(colGlobal,   "SQLWriterAutoStart", "",                    "0")
    Case Else
      strSQLSvcStartupType = UCase(GetParam(colGlobal,"SQLSvcStartupType",  "",                    "Automatic"))
      strAGTSvcStartupType = UCase(GetParam(colGlobal,"AGTSvcStartupType",  "",                    "Automatic"))
      strASSvcStartupType  = Ucase(GetParam(colGlobal,"ASSvcStartupType",   "",                    "Manual"))
      strIsSvcStartupType  = Ucase(GetParam(colGlobal,"IsSvcStartupType",   "",                    "Automatic"))
      strIsMasterStartupType = Ucase(GetParam(colGlobal,"ISMasterSvcStartupType", "",              "Automatic"))
      strIsWorkerStartupType = Ucase(GetParam(colGlobal,"ISWorkerSvcStartupType", "",              "Automatic"))
      strRSSvcStartupType  = UCase(GetParam(colGlobal,"RSSvcStartupType",   "",                    "Automatic"))
      strSqlBrowserStartup = UCase(GetParam(colGlobal,"BrowserSvcStartupType","",                  "Manual"))
      strTelSvcStartup     = UCase(GetParam(colGlobal,"TelSvcSvcStartupType", "",                  "Manual"))
      strWriterSvcStartupType = Ucase(GetParam(colGlobal, "WriterSvcStartupMode", "",              "Manual"))
      If strSQLVersion >= "SQL2016" Then
        strPBEngSvcStartup = UCase(GetParam(colGlobal, "PBEngSvcStartupType","",                   "Automatic"))
        strPBDMSSvcStartup = UCase(GetParam(colGlobal, "PBDMSSvcStartupType","",                   "Automatic"))
      End If
  End Select
  strDRUCtlrStartupType    = UCase(GetParam(colGlobal, "CtlrStartupType",  "",                    "Manual"))
  strDRUCltStartupType     = UCase(GetParam(colGlobal, "CltStartupType",   "",                    "Manual"))

  Select Case true
    Case strClusterAction = ""
      ' Nothing
    Case strSQLVersion <= "SQL2005"
      strSqlBrowserStartup = "1"
    Case Else
      strSqlBrowserStartup = UCase("Automatic")
  End Select

  Select Case True
    Case CInt(strNumLogins) > 99
      Call SetParam("NumLogins",             strNumLogins,             "99",  "Maximum of 99 Logins allowed", "")
  End Select

  For intIdx = 1 To strNumLogins
    strLogin        = GetParam(Null,                  "WinLogin" & Right("0" & CStr(intIdx), 2),     "",  "")
    If strLogin <> "" Then
      Call SetBuildfileValue("WinLogin" & Right("0" & CStr(intIdx), 2), strLogin)
    End If
    strLogin        = GetParam(Null,                  "UserLogin" & Right("0" & CStr(intIdx), 2),    "",  "")
    strPassword     = GetParam(Null,                  "UserPassword" & Right("0" & CStr(intIdx), 2), "",  "")
    If strLogin <> "" Then
      Call SetBuildfileValue("UserLogin" & Right("0" & CStr(intIdx), 2),    strLogin)
      Call SetBuildfileValue("UserPassword" & Right("0" & CStr(intIdx), 2), strPassword)
    End If
  Next

  Select Case True
    Case CInt(strNumTF) > 99
      Call SetParam("NumTF",                 strNumTF,                 "99",  "Maximum of 99 Trace Flags allowed", "")
  End Select

  For intIdx = 1 To strNumTF
    strTF           = GetParam(colGlobal,             "TF" & Right("0" & CStr(intIdx), 2),"TF" & CStr(intIdx),  "")
    If strTF <> "" Then
      Call SetBuildfileValue("TF" & Right("0" & CStr(intIdx), 2), strTF)
    End If
  Next

  Select Case True
    Case colArgs.Exists("SKUUpgrade")
      strSKUUpgrade = "YES"
    Case Else
      strSKUUpgrade = "NO"
  End Select

  If Left(strUserConfigurationvbs, 16) = ".\Build Scripts\" Then
    strUserConfigurationvbs = strPathFBScripts & Mid(strUserConfigurationvbs, 17)
  End If
  If Left(strUserPreparationvbs, 16) = ".\Build Scripts\" Then
    strUserPreparationvbs = strPathFBScripts & Mid(strUserPreparationvbs, 17)
  End If

End Sub


Sub SetBuildfileData()
  Call SetProcessId("0C", "Set values for Buildfile")

  Call SetSQLMediaValues()

  Call SetBuildfileValue("DirASDLL",                strDirASDLL)
  Call SetBuildfileValue("DirServInst",             strDirServInst)
  Call SetBuildfileValue("DirSQL",                  strDirSQL)
  Call SetBuildfileValue("DirSys",                  strDirSys)
  Call SetBuildfileValue("DirSysData",              strDirSysData)
  Call SetBuildfileValue("DirProg",                 strDirProg)
  Call SetBuildfileValue("DirProgX86",              strDirProgX86)
  Call SetBuildfileValue("DirProgSys",              strDirProgSys)
  Call SetBuildfileValue("DirProgSysX86",           strDirProgSysX86)
  Call SetBuildfileValue("DiscoverFile",            strDiscoverFile)
  Call SetBuildfileValue("DiscoverFolder",          strDiscoverFolder)
  Call SetBuildfileValue("DriveList",               strDriveList)
  Call SetBuildfileValue("LabBackup",               strLabBackup)
  Call SetBuildfileValue("LabBackupAS",             strLabBackupAS)
  Call SetBuildfileValue("LabBPE",                  strLabBPE)
  Call SetBuildfileValue("LabData",                 strLabData)
  Call SetBuildfileValue("LabDataAS",               strLabDataAS)
  Call SetBuildfileValue("LabDataFS",               strLabDataFS)
  Call SetBuildfileValue("LabDataFT",               strLabDataFT)
  Call SetBuildfileValue("LabDBA",                  strLabDBA)
  Call SetBuildfileValue("LabDTC",                  strLabDTC)
  Call SetBuildfileValue("LabLog",                  strLabLog)
  Call SetBuildfileValue("LabLogAS",                strLabLogAS)
  Call SetBuildfileValue("LabLogTemp",              strLabLogTemp)
  Call SetBuildfileValue("LabPrefix",               strLabPrefix)
  Call SetBuildfileValue("LabProg",                 strLabProg)
  Call SetBuildfileValue("LabSysDB",                strLabSysDB)
  Call SetBuildfileValue("LabSystem",               strLabSystem)
  Call SetBuildfileValue("LabTemp",                 strLabTemp)
  Call SetBuildfileValue("LabTempAS",               strLabTempAS)
  Call SetBuildfileValue("LabTempWin",              strLabTempWin)
  Call SetBuildfileValue("PathAddComp",             strPathAddComp)
  Call SetBuildfileValue("PathAddCompOrig",         strPathAddCompOrig)
  Call SetBuildfileValue("PathBOL",                 strPathBOL)
  Call SetBuildfileValue("PathFB",                  strPathFB)
  Call SetBuildfileValue("PathFBStart",             strPathFBStart)
  Call SetBuildfileValue("PathFBScripts",           strPathFBScripts)
  Call SetBuildfileValue("PathCScript",             strPathCScript)
  Call SetBuildfileValue("PathSQLCmd",              strPathSQLCmd)
  Call SetBuildfileValue("PathSQLSP",               strPathSQLSP)
  Call SetBuildfileValue("PathSQLSPOrig",           strPathSQLSPOrig)
  Call SetBuildfileValue("PathSSMS",                strPathSSMS)
  Call SetBuildfileValue("PathSSMSX86",             strPathSSMSX86)
  Call SetBuildfileValue("PathSys",                 strPathSys)
  Call SetBuildfileValue("PathVS",                  strPathVS)
  Call SetBuildfileValue("ProfDir",                 strProfDir)
  Call SetBuildfileValue("SQLProgDir",              strSQLProgDir)
  Call SetBuildfileValue("WinDir",                  strDirSys)

  intTimer          = Timer()

  Call SetBuildfileValue("AgentJobHistory",         strAgentJobHistory)
  Call SetBuildfileValue("AgentMaxHistory",         strAgentMaxHistory)
  Call SetBuildfileValue("AllowUpgradeForRSSharePointMode", strAllowUpgradeForRSSharePointMode)
  Call SetBuildfileValue("AllUserDTop",             strAllUserDTop)
  Call SetBuildfileValue("AllUserProf",             strAllUserProf)
  Call SetBuildfileValue("AnyKey",                  strAnyKey)
  Call SetBuildfileValue("ASProviderMSOlap",        strASProviderMSOlap)
  Call SetBuildfileValue("ASServerMode",            strAsServerMode)
  Call SetBuildfileValue("BPEFile",                 strBPEFile) 
  Call SetBuildfileValue("CatalogServer",           strCatalogServer)
  Call SetBuildfileValue("CatalogServerName",       strCatalogServerName)
  Call SetBuildfileValue("CatalogInstance",         strCatalogInstance)
  Call SetBuildfileValue("CollationAS",             strCollationAS)
  Call SetBuildfileValue("CollationSQL",            strCollationSQL)
  Call SetBuildfileValue("DBA_DB",                  strDBA_DB)
  Call SetBuildfileValue("DBAEmail",                strDBAEmail)
  Call SetBuildfileValue("DBMailProfile",           strDBMailProfile)
  Call SetBuildfileValue("DBOwnerAccount",          strDBOwnerAccount)
  Call SetBuildfileValue("DefaultUser",             strDefaultUser)
  Call SetBuildfileValue("DfltDoc" ,                strDfltDoc)
  Call SetBuildfileValue("DfltProf",                strDfltProf)
  Call SetBuildfileValue("DfltRoot",                strDfltRoot)
  Call SetBuildfileValue("Domain",                  strDomain)
  Call SetBuildfileValue("DomainSID",               strDomainSID)
  Call SetBuildfileValue("Debug",                   strDebug)
  Call SetBuildfileValue("EnableRANU",              strEnableRANU)
  Call SetBuildfileValue("Enu",                     strEnu)
  Call SetBuildfileValue("ErrorReporting",          strErrorReporting)
  Call SetBuildfileValue("ExpVersion",              strExpVersion) 
  Call SetBuildfileValue("FBCmd",                   strFBCmd)
  Call SetBuildfileValue("FBParm",                  strFBParm)
  Call SetBuildfileValue("Features",                strFeatures)
  Call SetBuildfileValue("FilePerm",                strFilePerm)
  Call SetBuildfileValue("FirewallStatus",          strFirewallStatus)
  Call SetBuildfileValue("FSLevel",                 strFSLevel)
  Call SetBuildfileValue("FSInstLevel",             strFSInstLevel)
  Call SetBuildfileValue("FSShareName",             strFSShareName)
  Call SetBuildfileValue("GroupAdmin",              strGroupAdmin)
  Call SetBuildfileValue("GroupDBA",                strGroupDBA)
  Call SetBuildfileValue("GroupDBANonSA",           strGroupDBANonSA)
  Call SetBuildfileValue("GroupDistComUsers",       strGroupDistComUsers)
  Call SetBuildfileValue("GroupMSA",                strGroupMSA)
  Call SetBuildfileValue("GroupPerfLogUsers",       strGroupPerfLogUsers)
  Call SetBuildfileValue("GroupPerfMonUsers",       strGroupPerfMonUsers)
  Call SetBuildfileValue("GroupRDUsers",            strGroupRDUsers)
  Call SetBuildfileValue("GroupUsers",              strGroupUsers)
  Call SetBuildfileValue("HKLMFB",                  strHKLMFB)
  Call SetBuildfileValue("HKLMSQL",                 strHKLMSQL)
  Call SetBuildfileValue("HTTP",                    strHTTP)
  Call SetBuildfileValue("InstRegAS",               strInstRegAS)
  Call SetBuildfileValue("InstRegRS",               strInstRegRS)
  Call SetBuildfileValue("InstRegSQL",              strInstRegSQL)
  Call SetBuildfileValue("MailServer",              strMailServer)
  Call SetBuildfileValue("MailServerType",          strMailServerType)
  Call SetBuildfileValue("MainInstance",            strMainInstance)
  Call SetBuildfileValue("ManagementDW",            strManagementDW)
  Call SetBuildfileValue("ManagementServer",        strManagementServer)
  Call SetBuildfileValue("ManagementServerRes",     strManagementServerRes)
  Call SetBuildfileValue("ManagementServerName",    strManagementServerName)
  Call SetBuildfileValue("ManagementInstance",      strManagementInstance)
  Call SetBuildfileValue("MaxDop",                  strMaxDop)
  Call SetBuildfileValue("NumTF",                   strNumTF)
  Call SetBuildfileValue("MDSAccount",              strMDSAccount)
  Call SetBuildfileValue("MDSPassword",             strMDSPassword)
  Call SetBuildfileValue("MDSDB",                   strMDSDB)
  Call SetBuildfileValue("MDSPort",                 strMDSPort)
  Call SetBuildfileValue("MDSSite",                 strMDSSite)
  Call SetBuildfileValue("MembersDBA",              strMembersDBA)
  Call SetBuildfileValue("Mode",                    strMode)
  Call SetBuildfileValue("MSSupplied",              strMSSupplied)
  Call SetBuildfileValue("NumErrorLogs",            strNumErrorLogs)
  Call SetBuildfileValue("NumLogins",               strNumLogins)
  Call SetBuildfileValue("OptCLREnabled",           strOptCLREnabled)
  Call SetBuildfileValue("OptCostThreshold",        strOptCostThreshold)
  Call SetBuildfileValue("OptMaxServerMemory",      strOptMaxServerMemory)
  Call SetBuildfileValue("OptOptimizeForAdHocWorkloads", strOptOptimizeForAdHocWorkloads)
  Call SetBuildfileValue("OptRemoteAdminConnections",    strOptRemoteAdminConnections)
  Call SetBuildfileValue("OptRemoteProcTrans",      strOptRemoteProcTrans)
  Call SetBuildfileValue("OptxpCmdshell",           strOptxpCmdshell)
  Call SetBuildfileValue("Options",                 strOptions)
  Call SetBuildfileValue("OSLanguage",              strOSLanguage)
  Call SetBuildfileValue("OSName",                  strOSName)
  Call SetBuildfileValue("OSLevel",                 strOSLevel)
  Call SetBuildfileValue("OSType",                  strOSType)
  Call SetBuildfileValue("OSVersion",               strOSVersion)
  Call SetBuildfileValue("PID",                     strPID)
  Call SetBuildfileValue("ProcArc",                 strProcArc)
  Call SetBuildfileValue("ProcNum",                 intProcNum)
  Call SetBuildfileValue("ProfileName",             strProfileName)
  Call SetBuildfileValue("ProgCacls",               strProgCacls)
  Call SetBuildfileValue("ProgNTRights",            strProgNTRights)
  Call SetBuildfileValue("ProgSetSPN",              strProgSetSPN)
  Call SetBuildfileValue("ProgReg",                 strProgReg)
  Call SetBuildfileValue("PSInstall",               strPsInstall)
  Call SetBuildfileValue("RebootStatus",            strRebootStatus)
  Call SetBuildfileValue("RegSSIS",                 strRegSSIS)
  Call SetBuildfileValue("RegSSISSetup",            strRegSSISSetup)
  Call SetBuildfileValue("ResponseNo",              strResponseNo)
  Call SetBuildfileValue("ResponseYes",             strResponseYes)
  Call SetBuildfileValue("ReportOnly",              strReportOnly)
  Call SetBuildfileValue("RSInstallMode",           strRSInstallMode)
  Call SetBuildfileValue("RSShpInstallMode",        strRSShpInstallMode)
  Call SetBuildfileValue("RSSQLLocal",              strRSSQLLocal)
  Call SetBuildfileValue("RSVersion",               strRSVersion)
  Call SetBuildfileValue("SQLRSStart",              strSQLRSStart)
  Call SetBuildfileValue("SecDBA",                  strSecDBA)
  Call SetBuildfileValue("SecMain",                 strSecMain)
  Call SetBuildfileValue("SecTemp",                 strSecTemp)
  Call SetBuildfileValue("SecurityMode",            strSecurityMode)
  Call SetBuildfileValue("ServInst",                strServInst)
  Call SetBuildfileValue("ServName",                strServName)
  Call SetBuildfileValue("SIDDistComUsers",         strSIDDistComUsers)
  Call SetBuildfileValue("SKUUpgrade",              strSKUUpgrade)
  Call SetBuildfileValue("SpeedTest",               intSpeedTest) 

  intTimer          = Timer() - intTimer          ' Get timing data for about 100 items

  Call SetBuildfileValue("Action",                  strAction)
  Call SetBuildfileValue("ActionAO",                strActionAO)
  Call SetBuildfileValue("ActionDTC",               strActionDTC)
  Call SetBuildfileValue("ActionSQLDB",             strActionSQLDB)
  Call SetBuildfileValue("ActionSQLAS",             strActionSQLAS)
  Call SetBuildfileValue("ActionSQLIS",             strActionSQLIS)
  Call SetBuildfileValue("ActionSQLRS",             strActionSQLRS)
  Call SetBuildfileValue("ActionSQLTools",          strActionSQLTools)
  Call SetBuildfileValue("ActionClusInst",          strActionClusInst)
  Call SetBuildfileValue("AgtDomainGroup",          strAgtDomainGroup)
  Call SetBuildfileValue("Alphabet",                strAlphabet)
  Call SetBuildfileValue("ASDomainGroup",           strASDomainGroup)
  Call SetBuildfileValue("AutoLogonCount",          strAutoLogonCount)
  Call SetBuildfileValue("AVCmd",                   strAVCmd)
  Call SetBuildfileValue("CLSIdDTExec",             strCLSIdDTExec)
  Call SetBuildfileValue("CLSIdNetCon",             strCLSIdNetCon)
  Call SetBuildfileValue("CLSIdRunBroker",          strCLSIdRunBroker)
  Call SetBuildfileValue("CLSIdSQL",                strCLSIdSQL)
  Call SetBuildfileValue("CLSIdSQLSetup",           strCLSIdSQLSetup)
  Call SetBuildfileValue("CLSIdSSIS",               strCLSIdSSIS)
  Call SetBuildfileValue("CLSIdVS",                 strCLSIdVS)
  Call SetBuildfileValue("ClusStorage",             strClusStorage)
  Call SetBuildfileValue("ClusSubnet",              strClusSubnet)
  Call SetBuildfileValue("ClusterAction",           strClusterAction)
  Call SetBuildfileValue("ClusterGroupAO",          strClusterGroupAO)
  Call SetBuildfileValue("ClusterGroupAS",          strClusterGroupAS)
  Call SetBuildfileValue("ClusterGroupDTC",         strClusterGroupDTC)
  Call SetBuildfileValue("ClusterGroupFS",          strClusterGroupFS)
  Call SetBuildfileValue("ClusterGroupRS",          strClusterGroupRS)
  Call SetBuildfileValue("ClusterGroupSQL",         strClusterGroupSQL)
  Call SetBuildfileValue("ClusterHost",             strClusterHost)
  Call SetBuildfileValue("ClusterName",             strClusterName)
  Call SetBuildfileValue("ClusterNameAS",           strClusterNameAS)
  Call SetBuildfileValue("ClusterNameDTC",          strClusterNameDTC)
  Call SetBuildfileValue("ClusterNameIS",           strClusterNameIS)
  Call SetBuildfileValue("ClusterNamePE",           strClusterNamePE)
  Call SetBuildfileValue("ClusterNamePM",           strClusterNamePM)
  Call SetBuildfileValue("ClusterNameRS",           strClusterNameRS)
  Call SetBuildfileValue("ClusterNameSQL",          strClusterNameSQL)
  Call SetBuildfileValue("ClusterNetworkDTC",       strClusterNetworkDTC)
  Call SetBuildfileValue("ClusterNode",             strClusterNode)
  Call SetBuildfileValue("ClusIPAddress",           strClusIPAddress)
  Call SetBuildfileValue("ClusIPVersion",           strClusIPVersion)
  Call SetBuildfileValue("ClusIPV4Address",         strClusIPV4Address)
  Call SetBuildfileValue("ClusIPV4Mask",            strClusIPV4Mask)
  Call SetBuildfileValue("ClusIPV4Network",         strClusIPV4Network)
  Call SetBuildfileValue("ClusIPV6Address",         strClusIPV6Address)
  Call SetBuildfileValue("ClusIPV6Mask",            strClusIPV6Mask)
  Call SetBuildfileValue("ClusIPV6Network",         strClusIPV6Network)
  Call SetBuildfileValue("ClusterPassive",          strClusterPassive)
  Call SetBuildfileValue("CompatFlags",             strCompatFlags)
  Call SetBuildfileValue("ConfirmIPDependencyChange",    strConfirmIPDependencyChange) 
  Call SetBuildfileValue("CSVRoot",                 strCSVRoot)
  Call SetBuildfileValue("DisableNetworkProtocols", strDisableNetworkProtocols)
  Call SetBuildfileValue("DNSIPIM",                 strDNSIPIM)
  Call SetBuildfileValue("DNSNameIM",               strDNSNameIM)
  Call SetBuildfileValue("DTCClusterRes",           strDTCClusterRes)
  Call SetBuildfileValue("DTCMultiInstance",        strDTCMultiInstance)
  Call SetBuildfileValue("EditionEnt",              strEditionEnt)
  Call SetBuildfileValue("EdType",                  strEdType)
  Call SetBuildfileValue("EncryptAO",               strEncryptAO)
  Call SetBuildfileValue("FailoverClusterRollOwnership", strFailoverClusterRollOwnership)
  Call SetBuildfileValue("FarmAccount",             strFarmAccount)
  Call SetBuildfileValue("FarmPassword",            strFarmPassword)
  Call SetBuildfileValue("FarmAdminIPort",          strFarmAdminIPort)
  Call SetBuildfileValue("FineBuildStatus",         strFineBuildStatus)
  Call SetBuildfileValue("FTSDomainGroup",          strFTSDomainGroup)
  Call SetBuildfileValue("FTUpgradeOption",         strFTUpgradeOption)
  Call SetBuildfileValue("IsInstallDBA",            strIsInstallDBA)
  Call SetBuildfileValue("InstADHelper",            strInstADHelper)
  Call SetBuildfileValue("InstAgent",               strInstAgent)
  Call SetBuildfileValue("InstAnal",                strInstAnal)
  Call SetBuildfileValue("InstAO",                  strInstAO)
  Call SetBuildfileValue("InstAS",                  strInstAS)
  Call SetBuildfileValue("InstASCon",               strInstASCon)
  Call SetBuildfileValue("InstASSQL",               strInstASSQL)
  Call SetBuildfileValue("InstFT",                  strInstFT)
  Call SetBuildfileValue("InstIS",                  strInstIS)
  Call SetBuildfileValue("InstISMaster",            strInstISMaster)
  Call SetBuildfileValue("InstISWorker",            strInstISWorker)
  Call SetBuildfileValue("InstLog",                 strInstLog)
  Call SetBuildfileValue("InstMR",                  strInstMR)
  Call SetBuildfileValue("InstNode",                strInstNode)
  Call SetBuildfileValue("InstNodeAS",              strInstNodeAS)
  Call SetBuildfileValue("InstNodeIS",              strInstNodeIS)
  Call SetBuildfileValue("InstPE",                  strInstPE)
  Call SetBuildfileValue("InstPM",                  strInstPM)
  Call SetBuildfileValue("InstRS",                  strInstRS)
  Call SetBuildfileValue("InstRSDir",               strInstRSDir)
  Call SetBuildfileValue("InstRSSQL",               strInstRSSQL)
  Call SetBuildfileValue("InstRSHost",              strInstRSHost)
  Call SetBuildfileValue("InstRSURL",               strInstRSURL)
  Call SetBuildfileValue("InstRSWMI",               strInstRSWMI)
  Call SetBuildfileValue("InstSQL",                 strInstSQL)
  Call SetBuildfileValue("InstStream",              strInstStream)
  Call SetBuildfileValue("InstTel",                 strInstTel)
  Call SetBuildfileValue("IISRoot",                 strIISRoot)
  Call SetBuildfileValue("MountRoot",               strMountRoot)
  Call SetBuildfileValue("NativeOS",                strNativeOS)
  Call SetBuildfileValue("NetNameSource",           strNetNameSource)
  Call SetBuildfileValue("NetworkGUID",             strNetworkGUID)
  Call SetBuildfileValue("PreferredOwner",          strPreferredOwner)
  Call SetBuildfileValue("RebootLoop",              strRebootLoop)
  Call SetBuildfileValue("RegTools",                strRegTools)
  Call SetBuildfileValue("ReportViewerVersion",     strReportViewerVersion)
  Call SetBuildfileValue("ResSuffixAS",             strResSuffixAS)
  Call SetBuildfileValue("ResSuffixDB",             strResSuffixDB)
  Call SetBuildfileValue("Role",                    strRole)
  Call SetBuildfileValue("RoleDBANonSA",            strRoleDBANonSA)
  Call SetBuildfileValue("SchedLevel",              strSchedLevel)
  Call SetBuildfileValue("Server",                  strServer)
  Call SetBuildfileValue("ServerAO",                strServerAO)
  Call SetBuildfileValue("SPLevel",                 strSPLevel) 
  Call SetBuildfileValue("SPCULevel",               strSPCULevel) 
  Call SetBuildfileValue("SQLAgentStart",           strSQLAgentStart)
  Call SetBuildfileValue("SQLExe",                  strSQLExe)
  Call SetBuildfileValue("SQLLanguage",             strSQLLanguage)
  Call SetBuildfileValue("SQLLogReinit",            strSQLLogReinit)
  Call SetBuildfileValue("SQLRecoveryComplete",     strSQLRecoveryComplete)
  Call SetBuildfileValue("SQLSupportMsi",           strSQLSupportMsi)
  Call SetBuildfileValue("SQLVersion",              strSQLVersion)
  Call SetBuildfileValue("SQLVersionNum",           strSQLVersionNum)
  Call SetBuildfileValue("SQLVersionNet",           strSQLVersionNet)
  Call SetBuildfileValue("SQLVersionWMI",           strSQLVersionWMI)
  Call SetBuildfileValue("SQLDomainGroup",          strSQLDomainGroup)
  Call SetBuildfileValue("SQLTempdbFileCount",      strSQLTempdbFileCount)
  Call SetBuildfileValue("SQLList",                 strSQLList)
  Call SetBuildfileValue("StatusAssumed",           strStatusAssumed)
  Call SetBuildfileValue("StatusBypassed",          strStatusBypassed)
  Call SetBuildfileValue("StatusComplete",          strStatusComplete)
  Call SetBuildfileValue("StatusFail",              strStatusFail)
  Call SetBuildfileValue("StatusManual",            strStatusManual)
  Call SetBuildfileValue("StatusPreConfig",         strStatusPreConfig)
  Call SetBuildfileValue("StatusProgress",          strStatusProgress)
  Call SetBuildfileValue("StatusKB2919355",         strStatusKB2919355)
  Call SetBuildfileValue("StatusRobocopy",          strStatusRobocopy)
  Call SetBuildfileValue("StatusXcopy",             strStatusXcopy)
  Call SetBuildfileValue("StreamInsightPID",        strStreamInsightPID)
  Call SetBuildfileValue("StopAt",                  strStopAt)

  Call SetBuildfileValue("AdminPassword",           strAdminPassword)
  Call SetBuildfileValue("AgtAccount",              strAgtAccount)
  Call SetBuildfileValue("AgtPassword",             strAgtPassword)
  Call SetBuildfileValue("AgtSvcStartupType",       strAgtSvcStartupType)
  Call SetBuildfileValue("AsAccount",               strAsAccount)
  Call SetBuildfileValue("AsPassword",              strAsPassword)
  Call SetBuildfileValue("AsSvcStartupType",        strAsSvcStartupType)
  Call SetBuildfileValue("AuditLevel",              strAuditLevel)
  Call SetBuildfileValue("AuditVersion",            strSQLVersion)
  Call SetBuildfileValue("AuditEdition",            strEdition) 
  Call SetBuildfileValue("BackupStart",             strBackupStart)
  Call SetBuildfileValue("BackupRetain",            strBackupRetain)
  Call SetBuildfileValue("BackupLogFreq",           strBackupLogFreq)
  Call SetBuildfileValue("BackupLogRetain",         strBackupLogRetain)
  Call SetBuildfileValue("BuildFileTime",           intTimer)  
  Call SetBuildfileValue("CmdShellAccount",         strCmdShellAccount)
  Call SetBuildfileValue("CmdShellPassword",        strCmdShellPassword)
  Call SetBuildfileValue("SqlBrowserAccount",       strSqlBrowserAccount)
  Call SetBuildfileValue("SqlBrowserPassword",      strSqlBrowserPassword)
  Call SetBuildfileValue("SqlBrowserStartup",       strSqlBrowserStartup)
  Call SetBuildfileValue("SqlWriterStartupType",    strWriterSvcStartupType)
  Call SetBuildfileValue("DistDatabase",            strDistDatabase)
  Call SetBuildfileValue("DistPassword",            strDistPassword)
  Call SetBuildfileValue("DQPassword",              strDQPassword)
  Call SetBuildfileValue("DRUCtlrAccount",          strDRUCtlrAccount)
  Call SetBuildfileValue("DRUCtlrPassword",         strDRUCtlrPassword)
  Call SetBuildfileValue("DRUCtlrStartupType",      strDRUCtlrStartupType)
  Call SetBuildfileValue("DRUCltAccount",           strDRUCltAccount)
  Call SetBuildfileValue("DRUCltPassword",          strDRUCltPassword)
  Call SetBuildfileValue("DRUCltStartupType",       strDRUCltStartupType)
  Call SetBuildfileValue("ExtSvcAccount",           strExtSvcAccount)
  Call SetBuildfileValue("ExtSvcPassword",          strExtSvcPassword)
  Call SetBuildfileValue("FtAccount",               strFtAccount)
  Call SetBuildfileValue("FtPassword",              strFtPassword)
  Call SetBuildfileValue("IsAccount",               strIsAccount)
  Call SetBuildfileValue("IsPassword",              strIsPassword)
  Call SetBuildfileValue("IsSvcStartupType",        strIsSvcStartupType)
  Call SetBuildfileValue("IsMasterAccount",         strIsMasterAccount)
  Call SetBuildfileValue("IsMasterPassword",        strIsMasterPassword)
  Call SetBuildfileValue("IsMasterStartupType",     strIsMasterStartupType)
  Call SetBuildfileValue("IsMasterPort",            strIsMasterPort)
  Call SetBuildfileValue("IsMasterThumbprint",      strIsMasterThumbprint)
  Call SetBuildfileValue("IsWorkerAccount",         strIsWorkerAccount)
  Call SetBuildfileValue("IsWorkerPassword",        strIsWorkerPassword)
  Call SetBuildfileValue("IsWorkerStartupType",     strIsWorkerStartupType)
  Call SetBuildfileValue("IsWorkerMaster",          strIsWorkerMaster)
  Call SetBuildfileValue("IsWorkerCert",            strIsWorkerCert)
  Call SetBuildfileValue("JobCategory",             strJobCategory)
  Call SetBuildfileValue("LocalAdmin",              strLocalAdmin)
  Call SetBuildfileValue("LocalDomain",             strLocalDomain)
  Call SetBuildfileValue("MDWAccount",              strMDWAccount)
  Call SetBuildfileValue("MDWPassword",             strMDWPassword)
  Call SetBuildfileValue("NPEnabled",               strNPEnabled) 
  Call SetBuildfileValue("NTAuthAccount",           strNTAuthAccount)
  Call SetBuildfileValue("NTAuthOSName",            strNTAuthOSName)
  Call SetBuildfileValue("NTService",               strNTService)
  Call SetBuildfileValue("Passphrase",              strPassphrase)
  Call SetBuildfileValue("PBEngSvcAccount",         strPBEngSvcAccount)
  Call SetBuildfileValue("PBEngSvcPassword",        strPBEngSvcPassword)
  Call SetBuildfileValue("PBEngSvcStartup",         strPBEngSvcStartup)
  Call SetBuildfileValue("PBDMSSvcAccount",         strPBDMSSvcAccount)
  Call SetBuildfileValue("PBDMSSvcPassword",        strPBDMSSvcPassword)
  Call SetBuildfileValue("PBDMSSvcStartup",         strPBDMSSvcStartup)
  Call SetBuildfileValue("PBPortRange",             strPBPortRange)
  Call SetBuildfileValue("PBScaleout",              strPBScaleout)
  Call SetBuildfileValue("PowerBIPID",              strPowerBIPID)
  Call SetBuildfileValue("RegasmExe",               strRegasmExe)
  Call SetBuildfileValue("RSAlias",                 strRSAlias)
  Call SetBuildfileValue("RsAccount",               strRsAccount)
  Call SetBuildfileValue("RsPassword",              strRsPassword)
  Call SetBuildfileValue("RSDBAccount",             strRSDBAccount)
  Call SetBuildfileValue("RSDBPassword",            strRSDBPassword)
  Call SetBuildfileValue("RSDBName",                strRSDBName)
  Call SetBuildfileValue("RSEmail",                 strRSEmail)
  Call SetBuildfileValue("RsExecAccount",           strRsExecAccount)
  Call SetBuildfileValue("RsExecPassword",          strRsExecPassword)
  Call SetBuildfileValue("RsFxVersion",             strRsFxVersion)
  Call SetBuildfileValue("RsHeaderLength",          strRsHeaderLength)
  Call SetBuildfileValue("RsShareAccount",          strRsShareAccount)
  Call SetBuildfileValue("RsSharePassword",         strRsSharePassword)
  Call SetBuildfileValue("RSFullURL",               strRSFullURL)
  Call SetBuildfileValue("RsSvcStartupType",        strRsSvcStartupType)
  Call SetBuildfileValue("RSVersionNum",            strRSVersionNum)
  Call SetBuildfileValue("RSWMIPath",               strRSWMIPath)
  Call SetBuildfileValue("saName",                  strsaName)
  Call SetBuildfileValue("saPwd",                   strsaPwd)
  Call SetBuildfileValue("SqlAccount",              strSqlAccount)
  Call SetBuildfileValue("SQLAdminAccounts",        strSQLAdminAccounts)
  Call SetBuildfileValue("ClusterAOFound",          strClusterAOFound)
  Call SetBuildfileValue("ClusterASFound",          strClusterASFound)
  Call SetBuildfileValue("ClusterDTCFound",         strClusterDTCFound)
  Call SetBuildfileValue("ClusterSQLFound",         strClusterSQLFound)
  Call SetBuildfileValue("SQLOperator",             strSQLOperator)
  Call SetBuildfileValue("SqlPassword",             strSqlPassword)
  Call SetBuildfileValue("SQLEmail",                strSQLEmail)
  Call SetBuildfileValue("SQLSharedMR",             strSQLSharedMR)
  Call SetBuildfileValue("SqlSvcStartupType",       strSqlSvcStartupType)
  Call SetBuildfileValue("SQMReporting",            strSQMReporting)
  Call SetBuildfileValue("SSASAdminAccounts",       strSSASAdminAccounts)
  Call SetBuildfileValue("SSISDB",                  strSSISDB)
  Call SetBuildfileValue("SSISPassword",            strSSISPassword)
  Call SetBuildfileValue("SSISRetention",           strSSISRetention)
  Call SetBuildfileValue("SSMSexe",                 strSSMSexe)
  Call SetBuildfileValue("TallyCount",              strTallyCount)  
  Call SetBuildfileValue("TCPEnabled",              strTCPEnabled) 
  Call SetBuildfileValue("TCPPort",                 strTCPPort) 
  Call SetBuildfileValue("TCPPortAS",               strTCPPortAS)
  Call SetBuildfileValue("TCPPortDAC",              strTCPPortDAC)
  Call SetBuildfileValue("TCPPortDTC",              strTCPPortDTC)
  Call SetBuildfileValue("TCPPortAO",               strTCPPortAO)
  Call SetBuildfileValue("tempdbFile",              strtempdbFile)
  Call SetBuildfileValue("tempdbLogFile",           strtempdbLogFile)
  Call SetBuildfileValue("Type",                    strType) 
  Call SetBuildfileValue("TypeNode",                strXMLNode)
  Call SetBuildfileValue("UpdateSource",            strUpdateSource)
  Call SetBuildfileValue("UseFreeSSMS",             strUseFreeSSMS)
  Call SetBuildfileValue("UserAccount",             strUserAccount)
  Call SetBuildfileValue("UserConfiguration",       strUserConfiguration)
  Call SetBuildfileValue("UserConfigurationvbs",    strUserConfigurationvbs)
  Call SetBuildfileValue("UserDNSDomain",           strUserDNSDomain)
  Call SetBuildfileValue("UserDNSServer",           strUserDNSServer)
  Call SetBuildfileValue("UserDTop",                strUserDTop)
  Call SetBuildfileValue("UserProf",                strUserProf)
  Call SetBuildfileValue("UserPreparation",         strUserPreparation)
  Call SetBuildfileValue("UserPreparationvbs",      strUserPreparationvbs)
  Call SetBuildfileValue("UseSysDB",                strUseSysDB)
  Call SetBuildfileValue("VersionNet3",             strVersionNet3)  
  Call SetBuildfileValue("VersionNet4",             strVersionNet4)  
  Call SetBuildfileValue("VolProgX86",              strVolProg)
  Call SetBuildfileValue("VolProgX86Source",        GetBuildfileValue("VolProgSource"))
  Call SetBuildfileValue("VSVersionNum",            strvsVersionNum)  
  Call SetBuildfileValue("WaitLong",                strWaitLong)
  Call SetBuildfileValue("WaitMed",                 strWaitMed)
  Call SetBuildfileValue("WaitShort",               strWaitShort)
  Call SetBuildfileValue("WOWX86",                  strWOWX86)
 
  Call SetBuildfileValue("SetupABE",                strSetupABE)
  Call SetBuildfileValue("SetupAlwaysOn",           strSetupAlwaysOn)
  Call SetBuildfileValue("SetupAODB",               strSetupAODB)
  Call SetBuildfileValue("SetupAnalytics",          strSetupAnalytics)
  Call SetBuildfileValue("SetupAPCluster",          strSetupAPCluster)
  Call SetBuildfileValue("SetupBIDS",               strSetupBIDS)
  Call SetBuildfileValue("SetupBIDSHelper",         strSetupBIDSHelper)
  Call SetBuildfileValue("SetupBOL",                strSetupBOL)
  Call SetBuildfileValue("SetupBPAnalyzer",         strSetupBPAnalyzer)
  Call SetBuildfileValue("SetupBPE",                strSetupBPE)
  Call SetBuildfileValue("SetupCacheManager",       strSetupCacheManager)
  Call SetBuildfileValue("SetupClusterShares",      strSetupClusterShares) 
  Call SetBuildfileValue("SetupCMD",                strSetupCMD) 
  Call SetBuildfileValue("SetupCmdshell",           strSetupCmdshell)
  Call SetBuildfileValue("SetupCompliance",         strSetupCompliance)
  Call SetBuildfileValue("SetupDB2OLE",             strSetupDB2OLE)
  Call SetBuildfileValue("SetupDBAManagement",      strSetupDBAManagement)
  Call SetBuildfileValue("SetupDBMail",             strSetupDBMail)
  Call SetBuildfileValue("SetupDBOpts",             strSetupDBOpts)
  Call SetBuildfileValue("SetupDCom",               strSetupDCom)
  Call SetBuildfileValue("SetupDimensionSCD",       strSetupDimensionSCD)
  Call SetBuildfileValue("SetupDisableSA",          strSetupDisableSA)
  Call SetBuildfileValue("SetupDistributor",        strSetupDistributor)
  Call SetBuildfileValue("SetupDQ",                 strSetupDQ)
  Call SetBuildfileValue("SetupDQC",                strSetupDQC)
  Call SetBuildfileValue("SetupDRUCtlr",            strSetupDRUCtlr) 
  Call SetBuildfileValue("SetupDRUClt",             strSetupDRUClt)
  Call SetBuildfileValue("SetupDTCCID",             strSetupDTCCID) 
  Call SetBuildfileValue("SetupDTCCluster",         strSetupDTCCluster) 
  Call SetBuildfileValue("SetupDTCNetAccess",       strSetupDTCNetAccess)
  Call SetBuildfileValue("SetupDTCNetAccessStatus", strSetupDTCNetAccessStatus)
  Call SetBuildfileValue("SetupDTSDesigner",        strSetupDTSDesigner)
  Call SetBuildfileValue("SetupDTSBackup",          strSetupDTSBackup)
  Call SetBuildfileValue("SetupFirewall",           strSetupFirewall) 
  Call SetBuildfileValue("SetupFT",                 strSetupFT)
  Call SetBuildfileValue("SetupGenMaint",           strSetupGenMaint) 
  Call SetBuildfileValue("SetupGovernor",           strSetupGovernor) 
  Call SetBuildfileValue("SetupIIS",                strSetupIIS)
  Call SetBuildfileValue("SetupIntViewer",          strSetupIntViewer)
  Call SetBuildfileValue("SetupISMaster",           strSetupISMaster)
  Call SetBuildfileValue("SetupISMasterCluster",    strSetupISMasterCluster)
  Call SetBuildfileValue("SetupISWorker",           strSetupISWorker)
  Call SetBuildfileValue("SetupJavaDBC",            strSetupJavaDBC)
  Call SetBuildfileValue("SetupJRE",                strSetupJRE)
  Call SetBuildfileValue("SetupKB925336",           strSetupKB925336)
  Call SetBuildfileValue("SetupKB932232",           strSetupKB932232)
  Call SetBuildfileValue("SetupKB933789",           strSetupKB933789)
  Call SetBuildfileValue("SetupKB937444",           strSetupKB937444)
  Call SetBuildfileValue("SetupKB954961",           strSetupKB954961)
  Call SetBuildfileValue("SetupKB956250",           strSetupKB956250)
  Call SetBuildfileValue("SetupKB2781514",          strSetupKB2781514)
  Call SetBuildfileValue("SetupKB2862966",          strSetupKB2862966)
  Call SetBuildfileValue("SetupKB2919355",          strSetupKB2919355)
  Call SetBuildfileValue("SetupKB2919442",          strSetupKB2919442)
  Call SetBuildfileValue("SetupKB3090973",          strSetupKB3090973)
  Call SetBuildfileValue("SetupKB4019990",          strSetupKB4019990)
  Call SetBuildfileValue("SetupManagementDW",       strSetupManagementDW)
  Call SetBuildfileValue("SetupMBCA",               strSetupMBCA)
  Call SetBuildfileValue("SetupMDS",                strSetupMDS)
  Call SetBuildfileValue("SetupMDSC",               strSetupMDSC)
  Call SetBuildfileValue("SetupMDXStudio",          strSetupMDXStudio)
  Call SetBuildfileValue("SetupMenus",              strSetupMenus)
  Call SetBuildfileValue("SetupMyDocs",             strSetupMyDocs) 
  Call SetBuildfileValue("SetupMSI45",              strSetupMSI45) 
  Call SetBuildfileValue("SetupMSMPI",              strSetupMSMPI)
  Call SetBuildfileValue("SetupNet3",               strSetupNet3)
  Call SetBuildfileValue("SetupNet4",               strSetupNet4)
  Call SetBuildfileValue("SetupNet4x",              strSetupNet4x)
  Call SetBuildfileValue("SetupNetBind",            strSetupNetBind)
  Call SetBuildfileValue("SetupNetName",            strSetupNetName)
  Call SetBuildfileValue("SetupNetTrust",           strSetupNetTrust)
  Call SetBuildfileValue("SetupNetwork",            strSetupNetwork) 
  Call SetBuildfileValue("SetupNoDefrag",           strSetupNoDefrag)
  Call SetBuildfileValue("SetupNoDriveIndex",       strSetupNoDriveIndex)
  Call SetBuildfileValue("SetupNoSSL3",             strSetupNoSSL3)
  Call SetBuildfileValue("SetupNoTCPNetBios",       strSetupNoTCPNetBios)
  Call SetBuildfileValue("SetupNoTCPOffload",       strSetupNoTCPOffload)
  Call SetBuildfileValue("SetupNoWinGlobal",        strSetupNoWinGlobal)
  Call SetBuildfileValue("SetupNonSAAccounts",      strSetupNonSAAccounts)
  Call SetBuildfileValue("SetupOLAP",               strSetupOLAP)
  Call SetBuildfileValue("SetupOLAPAPI",            strSetupOLAPAPI)
  Call SetBuildfileValue("SetupOldAccounts",        strSetupOldAccounts) 
  Call SetBuildfileValue("SetupParam",              strSetupParam) 
  Call SetBuildfileValue("SetupPBM",                strSetupPBM)
  Call SetBuildfileValue("SetupPDFReader",          strSetupPDFReader)
  Call SetBuildfileValue("SetupPerfDash",           strSetupPerfDash)
  Call SetBuildfileValue("SetupPolyBase",           strSetupPolyBase)
  Call SetBuildfileValue("SetupPolyBaseCluster",    strSetupPolyBaseCluster)
  Call SetBuildfileValue("SetupPlanExplorer",       strSetupPlanExplorer) 
  Call SetBuildfileValue("SetupPlanExpAddin",       strSetupPlanExpAddin) 
  Call SetBuildfileValue("SetupPowerCfg",           strSetupPowerCfg)
  Call SetBuildfileValue("SetupProcExp",            strSetupProcExp)
  Call SetBuildfileValue("SetupProcMon",            strSetupProcMon)
  Call SetBuildfileValue("SetupPS1",                strSetupPS1)
  Call SetBuildfileValue("SetupPS2",                strSetupPS2)
  Call SetBuildfileValue("SetupPowerBI",            strSetupPowerBI)
  Call SetBuildfileValue("SetupPowerBIDesktop",     strSetupPowerBIDesktop)
  Call SetBuildfileValue("SetupPSRemote",           strSetupPsRemote)
  Call SetBuildfileValue("SetupPython",             strSetupPython)
  Call SetBuildfileValue("SetupRawReader",          strSetupRawReader)
  Call SetBuildfileValue("SetupReportViewer",       strSetupReportViewer)
  Call SetBuildfileValue("SetupRMLTools",           strSetupRMLTools)
  Call SetBuildfileValue("SetupRptTaskPad",         strSetupRptTaskPad)
  Call SetBuildfileValue("SetupRServer",            strSetupRServer)
  Call SetBuildfileValue("SetupRSAdmin",            strSetupRSAdmin)
  Call SetBuildfileValue("SetupRSAlias",            strSetupRSAlias)
  Call SetBuildfileValue("SetupRSDB",               strSetupRSDB)
  Call SetBuildfileValue("SetupRSAT",               strSetupRSAT)
  Call SetBuildfileValue("SetupRSExec",             strSetupRSExec)
  Call SetBuildfileValue("SetupRSIndexes",          strSetupRSIndexes)
  Call SetBuildfileValue("SetupRSKeepAlive",        strSetupRSKeepAlive)
  Call SetBuildfileValue("SetupRSLinkGen",          strSetupRSLinkGen) 
  Call SetBuildfileValue("SetupRSScripter",         strSetupRSScripter)
  Call SetBuildfileValue("SetupRSShare",            strSetupRSShare)
  Call SetBuildfileValue("SetupSAAccounts",         strSetupSAAccounts)
  Call SetBuildfileValue("SetupSAPassword",         strSetupSAPassword)
  Call SetBuildfileValue("SetupSamples",            strSetupSamples)
  Call SetBuildfileValue("SetupSemantics",          strSetupSemantics)
  Call SetBuildfileValue("SetupServices",           strSetupServices)
  Call SetBuildfileValue("SetupServiceRights",      strSetupServiceRights)
  Call SetBuildfileValue("SetupShares",             strSetupShares) 
  Call SetBuildfileValue("SetupSlipstream",         strSetupSlipstream)
  Call SetBuildfileValue("SetupSnapshot",           strSetupSnapshot)
  Call SetBuildfileValue("SetupSPN",                strSetupSPN)
  Call SetBuildfileValue("SetupSQLAgent",           strSetupSQLAgent)
  Call SetBuildfileValue("SetupSQLAS",              strSetupSQLAS) 
  Call SetBuildfileValue("SetupSQLASCluster",       strSetupSQLASCluster) 
  Call SetBuildfileValue("SetupSQLBC",              strSetupSQLBC)
  Call SetBuildfileValue("SetupSQLCE",              strSetupSQLCE)
  Call SetBuildfileValue("SetupSQLDB",              strSetupSQLDB)
  Call SetBuildfileValue("SetupSQLDBCluster",       strSetupSQLDBCluster)
  Call SetBuildfileValue("SetupSQLDBAG",            strSetupSQLDBAG)
  Call SetBuildfileValue("SetupSQLDBFS",            strSetupSQLDBFS)
  Call SetBuildfileValue("SetupSQLDBFT",            strSetupSQLDBFT)
  Call SetBuildfileValue("SetupSQLDBRepl",          strSetupSQLDBRepl)
  Call SetBuildfileValue("SetupSQLInst",            strSetupSQLInst)
  Call SetBuildfileValue("SetupSQLIS",              strSetupSQLIS)
  Call SetBuildfileValue("SetupSQLMail",            strSetupSQLMail)
  Call SetBuildfileValue("SetupSQLNexus",           strSetupSQLNexus)
  Call SetBuildfileValue("SetupSQLNS",              strSetupSQLNS)
  Call SetBuildfileValue("SetupSQLRS",              strSetupSQLRS)
  Call SetBuildfileValue("SetupSQLRSCluster",       strSetupSQLRSCluster)
  Call SetBuildfileValue("SetupSQLServer",          strSetupSQLServer)
  Call SetBuildfileValue("SetupSQLTools",           strSetupSQLTools)
  Call SetBuildfileValue("SetupSP",                 strSetupSP) 
  Call SetBuildfileValue("SetupSPCU",               strSetupSPCU)
  Call SetBuildfileValue("SetupSPCUSNAC",           strSetupSPCUSNAC)
  Call SetBuildfileValue("SetupSSDTBI",             strSetupSSDTBI)
  Call SetBuildfileValue("SetupSSISCluster",        strSetupSSISCluster)
  Call SetBuildfileValue("SetupSSISDB",             strSetupSSISDB) 
  Call SetBuildfileValue("SetupSSL",                strSetupSSL)
  Call SetBuildfileValue("SetupSSMS",               strSetupSSMS)
  Call SetBuildfileValue("SetupStdAccounts",        strSetupStdAccounts)
  Call SetBuildfileValue("SetupStreamInsight",      strSetupStreamInsight)
  Call SetBuildfileValue("SetupStretch",            strSetupStretch)
  Call SetBuildfileValue("SetupSysDB",              strSetupSysDB)
  Call SetBuildfileValue("SetupSysIndex",           strSetupSysIndex)
  Call SetBuildfileValue("SetupSysManagement",      strSetupSysManagement)
  Call SetBuildfileValue("SetupSystemViews",        strSetupSystemViews)
  Call SetBuildfileValue("SetupTelemetry",          strSetupTelemetry)
  Call SetBuildfileValue("SetupTempDb",             strSetupTempDb)
  Call SetBuildfileValue("SetupTempWin",            strSetupTempWin)
  Call SetBuildfileValue("SetupTLS12",              strSetupTLS12)
  Call SetBuildfileValue("SetupTrouble",            strSetupTrouble)
  Call SetBuildfileValue("SetupVC2010",             strSetupVC2010)
  Call SetBuildfileValue("SetupVS",                 strSetupVS)
  Call SetBuildfileValue("SetupVS2005SP1",          strSetupVS2005SP1)
  Call SetBuildfileValue("SetupVS2010SP1",          strSetupVS2010SP1)
  Call SetBuildfileValue("SetupWinAudit",           strSetupWinAudit)
  Call SetBuildfileValue("SetupWindows",            strSetupWindows) 
  Call SetBuildfileValue("SetupXEvents",            strSetupXEvents)
  Call SetBuildfileValue("SetupXMLNotepad",         strSetupXMLNotepad)
  Call SetBuildfileValue("SetupZoomIt",             strSetupZoomIt) 

End Sub


Sub SetSQLMediaValues()
  Call SetProcessId("0CA", "Set Buildfile values for SQL Media folders")
  Dim strFBPathLocal, strFBPathLocalPrev, strPathSQLMediaPrev

  strFBPathLocal      = GetBuildfileValue("FBPathLocal")
  strFBPathLocalPrev  = GetBuildfileValue("FBPathLocalPrev")
  strPathSQLMediaPrev = GetBuildFileValue("PathSQLMedia")

  Select Case True
    Case strPathSQLMediaPrev = ""
      Call SetBuildfileValue("PathSQLMedia",     strPathSQLMedia)
      Call SetBuildfileValue("PathSQLMediaBase", strPathSQLMedia)
      Call SetBuildfileValue("PathSQLMediaOrig", strPathSQLMediaOrig)
      Call SetBuildfileValue("SQLMediaArc",      strSQLMediaArc)
      Call SetBuildfileValue("PCUSource",        strPCUSource)
      Call SetBuildfileValue("CUSource",         strCUSource)
      Call SetBuildfileValue("GroupDBAAlt",      strGroupDBA)
      Call SetBuildfileValue("GroupDBANonSAAlt", strGroupDBANonSA)
    Case strFBPathLocalPrev = ""
      ' Nothing
    Case strFBPathLocal <> strFBPathLocalPrev
      Call ResetMediaPath("PathSQLMedia",        strFBPathLocal, strFBPathLocalPrev)
      Call ResetMediaPath("PathSQLMediaBase",    strFBPathLocal, strFBPathLocalPrev)
      Call ResetMediaPath("PathSQLMediaOrig",    strFBPathLocal, strFBPathLocalPrev)
      Call ResetMediaPath("SQLMediaArc",         strFBPathLocal, strFBPathLocalPrev)
      Call ResetMediaPath("PCUSource",           strFBPathLocal, strFBPathLocalPrev)
      Call ResetMediaPath("CUSource",            strFBPathLocal, strFBPathLocalPrev)
  End Select

End Sub


Sub ResetMediaPath(strPathVar, strFBPathLocal, strFBPathLocalPrev)
  Call DebugLog("ResetMediaPath: " & strPathVar)
  Dim strPath

  strPath           = GetBuildfileValue(strPathVar)
  If Left(strPath, Len(strFBPathLocalPrev)) = strFBPathLocalPrev Then
    strPath         = strFBPathLocal & Mid(strPath, Len(strFBPathLocalPrev) + 1)
    Call SetBuildfileValue(strPathVar, strPath)
  End If

End Sub


Sub CheckUtils()
  Call SetProcessId("0D", "Check Utility Programs")
  Dim strStatusTemp

  strStatusTemp     = SetupUtil(strProgCacls)
  strStatusTemp     = SetupUtil(strProgNtrights)
  strStatusTemp     = SetupUtil("REG")
  strStatusTemp     = SetupUtil(strProgSetSPN)
  strStatusRobocopy = SetupUtil("ROBOCOPY")
  strStatusXcopy    = SetupUtil("XCOPY")

End Sub


Function SetupUtil(strUtil)
  Call DebugLog("SetupUtil: Check " & strUtil & ".EXE exists in Windows folder")
  Dim strUtilStatus

  strPathNew        = strPathFBScripts & strUtil & ".EXE"
  strCmd            = strUtil & " /?"
  strUtilStatus     = ""
  Call Util_RunExec(strCmd, "EOF", "", -1)
  Select Case True
    Case intErrsave = 0
      strUtilStatus = "OK"
    Case intErrsave = 1
      strUtilStatus = "OK"
    Case intErrSave = 160 ' Deprecated command
      strUtilStatus = "OK"
    Case objFSO.FileExists(strPathSys & strUtil & ".EXE")
      strUtilStatus = "OK"
    Case objFSO.FileExists(strPathNew)
      Call DebugLog("Copy " & strPathNew & " to Windows folder")
      Set objFile   = objFSO.GetFile(strPathNew)
      strDebugMsg1  = "Source: " & objFile.Path
      strDebugMsg2  = "Target: " & strPathSys
      objFile.Copy strPathSys
      strUtilStatus = "OK"
  End Select

  SetupUtil         = strUtilStatus

End Function


Sub FineBuild_Validate()
  Call SetProcessId("0E", "Validation processing for FineBuild for " & strSQLVersion)

  Select Case True
    Case err.Number <> 0 
      ' Nothing
    Case strValidate = "NO" 
      ' Nothing
    Case strType = "CLIENT"
      Call Validate_Client()
    Case strType = "CONFIG"
      Call Validate_Config()
    Case strType = "DISCOVER"
      Call Validate_Discover()
    Case strType = "WORKSTATION"
      Call Validate_Workstation()
    Case strType = "FIX"
      Call Validate_Fix()
    Case Else
      Call Validate_Full()
  End Select

  Select Case True
    Case strValidate = "NO" 
      ' Nothing
    Case strClusterAction = ""
      ' Nothing
    Case Else
      Call Validate_Cluster()
  End Select

  Select Case True
    Case strValidate = "NO" 
      ' Nothing
    Case Else
      Call Validate_Common()
  End Select

  Select Case True
    Case strValidate = "NO" 
      ' Nothing
    Case Else
      Call Output_Lists()
  End Select

  Call Validate_License()

  Call SetBuildfileValue("ValidateError",      strValidateError)
  If (err.Number <> 0) Or (strValidateError <> "") Then
    Call DebugLog("FineBuild stopping due to validation error")
  End If

End Sub


Sub Validate_Full()
  Call SetProcessId("0EA", "Validation processing for build type FULL")
  Dim strAccountType

  strPath           = "SYSTEM\CurrentControlSet\Services\" & strInstSQL
  objWMIReg.GetStringValue strHKLM,strPath,"DisplayName",strService

  Select Case True
    Case strSetupSQLDB <> "YES"
      ' Nothing
    Case (strService = "") Or (IsNull(strService))
      ' Nothing
    Case (strProcessId >= "1Z") And (strProcessId <> "7")
      ' Nothing
    Case strType = "UPGRADE"
      ' Nothing
    Case strReportOnly = "YES"
      ' Nothing
    Case Else
      Call SetBuildMessage(strMsgError, "FineBuild cancelled - Requested SQL instance " & strInstSQL & " already exists")
  End Select

  Select Case True
    Case strSetupSQLDB <> "YES"
      ' Nothing
    Case strService > ""
      ' Nothing
    Case strType <> "UPGRADE"
      ' Nothing
    Case strReportOnly = "YES"
      ' Nothing
    Case Else
      Call SetBuildMessage(strMsgError, "FineBuild cancelled - Requested SQL instance " & strInstSQL & " does not exist")
  End Select

  Select Case True
    Case strSetupSQLDB <> "YES"
      ' Nothing
    Case strService > ""
      ' Nothing
    Case (strProcessId < "2C") Or (strProcessId = "7")
      ' Nothing
    Case strReportOnly = "YES"
      ' Nothing
    Case Else
      Call SetBuildMessage(strMsgError, "FineBuild cancelled - Requested SQL instance " & strInstSQL & " does not exist")
  End Select

  strAccountType    = GetBuildfileValue("SqlAccountType")
  Select Case True
    Case strSetupSQLDB <> "YES"
      ' Nothing
    Case InStr("FULL FULLPROG", strType) = 0
      ' Nothing
    Case strEdition = "WORKGROUP"
      ' Nothing
    Case (strSQLVersion <= "SQL2005") And (strAccountType = "L")
      Call SetBuildMessage(strMsgError, "/SQLACCOUNT: parameter must be a domain account")
  End Select

  Select Case True
    Case strSetupSQLDB <> "YES"
      ' Nothing
    Case Left(strSqlAccount, Len(strNTAuth)) = strNTAuth
      ' Nothing
    Case Left(strSqlAccount, Len(strNTService)) = strNTService
      ' Nothing
    Case strAccountType = "M"
      Select Case True
        Case strSQLVersion >= "SQL2016"
          ' Nothing
        Case Right(strSqlAccount, 1) = "$" 
          ' Nothing
        Case Else
          Call SetBuildMessage(strMsgError, "/SQLSVCACCOUNT: parameter must end with '$'")
      End Select
    Case strSqlPassword > ""
      ' Nothing
    Case strSQLVersion <= "SQL2005" 
      Call SetBuildMessage(strMsgError, "/SQLPASSWORD: parameter must be supplied")
    Case Else
      Call SetBuildMessage(strMsgError, "/SQLSVCPASSWORD: parameter must be supplied")
  End Select

  Select Case True
    Case strSetupISMaster <> "YES"
      ' Nothing
    Case strIsMasterAccount = ""
      Call SetBuildMessage(strMsgError, "/ISMasterSvcAccount: parameter must be supplied")
    Case Else
      ' Nothing
  End Select

  Select Case True
    Case strSetupISWorker <> "YES"
      ' Nothing
    Case strIsWorkerAccount = ""
      Call SetBuildMessage(strMsgError, "/ISWorkerSvcAccount: parameter must be supplied")
    Case Else
      ' Nothing
  End Select

  Select Case True
    Case strSetupManagementDW <> "YES"
      ' Nothing
    Case (strMDWAccount = "") And (strMSSupplied = "Y")
      Call SetBuildMessage(strMsgError, "/MDWACCOUNT: and /MDWPASSWORD: parameters must be supplied")
    Case strMDWAccount = ""
      ' Nothing
    Case Instr(strMDWAccount, "\") = 0
      Call SetBuildMessage(strMsgError, "/MDWACCOUNT: parameter must be a domain account")
    Case strMDWAccount = strAgtAccount
      ' Nothing
    Case strMDWPassword <> ""
      ' Nothing
    Case Else
      Call SetBuildMessage(strMsgError, "/MDWPASSWORD: parameter must be supplied")
  End Select

  Select case True
    Case strSetupCmdshell <> "YES"
      ' Nothing
    Case (strCmdshellAccount > "") And (strCmdshellPassword > "")
      ' Nothing
    Case Else
      Call SetBuildMessage(strMsgError, "/CmdshellAccount: and /CmdshellPassword: parameters must be supplied")
  End Select

  If strsaPwd = "" Then
    Call SetBuildMessage(strMsgError, "/saPwd: parameter must be supplied")
  End If

  Select Case True
    Case strSetupSQLDB <> "YES"
      ' Nothing
    Case strActionSQLDB = strActionClusInst
      ' Nothing
    Case strActionSQLDB = "ADDNODE"
      ' Nothing
    Case strInstance = "MSSQLSERVER"
      ' Nothing
    Case strMainInstance = "YES"
      ' Nothing
    Case strTCPPort <> "1433"
      ' Nothing
    Case Else
      Call SetBuildMessage(strMsgError, "/TCPPort: with value other than 1433 must be supplied for a named instance install")
  End Select

End Sub


Sub Validate_Client()
  Call SetProcessId("0EB", "Validation processing for build type CLIENT")

  If Instr(strOSType, "CORE") > 0 Then
    Call SetBuildMessage(strMsgError, "CLIENT install not supported on Core OS")
  End If

End Sub


Sub Validate_Config()
  Call SetProcessId("0EC", "Validation processing for build type CONFIG")

  strPath           = "SYSTEM\CurrentControlSet\Services\" & strInstSQL
  objWMIReg.GetStringValue strHKLM,strPath,"DisplayName",strService

  Select Case True
    Case strSetupSQLDB <> "YES"
      ' Nothing
    Case strService > ""
      ' Nothing
    Case strReportOnly = "YES"
      ' Nothing
    Case Else
      Call SetBuildMessage(strMsgError, "FineBuild cancelled - Requested SQL instance " & strInstSQL & " does not exist")
  End Select

End Sub


Sub Validate_Discover()
  Call SetProcessId("0ED", "Validation processing for build type DISCOVER")

  strPath           = "SYSTEM\CurrentControlSet\Services\" & strInstSQL
  objWMIReg.GetStringValue strHKLM,strPath,"DisplayName",strService

  Select Case True
    Case strSetupSQLDB <> "YES"
      ' Nothing
    Case strService > ""
      ' Nothing
    Case strReportOnly = "YES"
      ' Nothing
    Case Else
      Call SetBuildMessage(strMsgError, "FineBuild cancelled - Requested SQL instance " & strInstSQL & " does not exist")
  End Select

End Sub


Sub Validate_Fix()
  Call SetProcessId("0EE", "Validation processing for build type FIX")

' No validation at present

End Sub


Sub Validate_Workstation()
  Call SetProcessId("0EF", "Validation processing for build type WORKSTATION")

  strPath           = "SYSTEM\CurrentControlSet\Services\" & strInstSQL
  objWMIReg.GetStringValue strHKLM,strPath,"DisplayName",strService

  Select Case True
    Case strSetupSQLDB <> "YES"
      ' Nothing
    Case (strService = "") Or (IsNull(strService))
      ' Nothing
    Case (strProcessId >= "1Z") And (strProcessId <> "7")
      ' Nothing
    Case strType = "UPGRADE"
      ' Nothing
    Case strReportOnly = "YES" 
      ' Nothing
    Case Else
      Call SetBuildMessage(strMsgError, "FineBuild cancelled - Requested SQL instance " & strInstSQL & " already exists")
  End Select

  Select Case True
    Case strSetupSQLDB <> "YES"
      ' Nothing
    Case strService > ""
      ' Nothing
    Case strType <> "UPGRADE"
      ' Nothing
    Case strReportOnly = "YES" 
      ' Nothing
    Case Else
      Call SetBuildMessage(strMsgError, "FineBuild cancelled - Requested SQL instance " & strInstSQL & " does not exist")
  End Select

  Select Case True
    Case strSetupSQLDB <> "YES"
      ' Nothing
    Case strService > ""
      ' Nothing
    Case (strProcessId < "2C") Or (strProcessId = "7")
      ' Nothing
    Case strReportOnly = "YES" 
      ' Nothing
    Case Else
      Call SetBuildMessage(strMsgError, "FineBuild cancelled - Requested SQL instance " & strInstSQL & " does not exist")
  End Select

  Select Case True
    Case strSetupManagementDW <> "YES"
      ' Nothing
    Case (strMDWAccount = "") And (strMSSupplied = "Y")
      Call SetBuildMessage(strMsgError, "/MDWACCOUNT: and /MDWPASSWORD: parameters must be supplied")
    Case strMDWAccount = ""
      ' Nothing
    Case Instr(strMDWAccount, "\") = 0
      Call SetBuildMessage(strMsgError, "/MDWACCOUNT: parameter must be a domain account")
    Case strMDWAccount = strAgtAccount
      ' Nothing
    Case strMDWPassword <> ""
      ' Nothing
    Case Else
      Call SetBuildMessage(strMsgError, "/MDWPASSWORD: parameter must be supplied")
  End Select

  If strsaPwd = "" Then
    Call SetBuildMessage(strMsgError, "/saPwd: parameter must be supplied")
  End If

  Select Case True
    Case strSetupSQLDB <> "YES"
      ' Nothing
    Case strSetupSQLDBCluster = "YES"
      ' Nothing
    Case strInstance = "MSSQLSERVER"
      ' Nothing
    Case strMainInstance = "YES"
      ' Nothing
    Case strTCPPort <> "1433"
      ' Nothing
    Case Else
      Call SetBuildMessage(strMsgError, "/TCPPort: with value other than 1433 must be supplied for a named instance install")
  End Select

End Sub


Sub Validate_Cluster()
  Call SetProcessId("0EG", "Validation processing for Cluster installs")

  Select Case True
    Case strClusterTCP = "IPV4"
      ' Nothing
    Case (strClusterTCP = "IPV6") And (strSQLVersion <= "SQL2005")
      Call SetBuildMessage(strMsgError, "/ClusterTCP:IPV6 not valid for " & strSQLVersion)
    Case strClusterTCP = "IPV6"
      ' Nothing
    Case Else
      Call SetBuildMessage(strMsgError, "Invalid /ClusterTCP: value " & strClusterTCP)
  End Select

  Select Case True
    Case strClusterAction = "ADDNODE"
      ' Nothing
    Case strOSVersion < "6.0"                ' Installing on W2003 or below
      ' Nothing
    Case Instr(strOSType, "CORE") > 0        ' Installing on Core OS
      ' Nothing
    Case strClusterReport = ""
      Call SetBuildMessage(strMsgError, "Cluster Validation Report can not be found.  Validate the Cluster to produce the report")
    Case CheckReport(strClusterPath, "Testing has completed successfully and the configuration is suitable for clustering")
      ' Nothing
    Case CheckReport(strClusterPath, "Testing has completed successfully. The configuration appears to be suitable for clustering")
      ' Nothing
    Case (strOSVersion >= "6.3X") And CheckReport(strClusterPath, "Testing has completed for the tests you selected")
      ' Nothing
    Case Else
      Call SetBuildMessage(strMsgError, "Cluster must have clean Validation Report for all tests")
  End Select

  Select Case True
    Case strSQLVersion > "SQL2005"
      ' Nothing
    Case strAdminPassword <> ""
      ' Nothing
    Case Else
      Call SetBuildMessage(strMsgError, "/AdminPassword: must be supplied and contain the password for the account running SQL FineBuild")
  End Select

  Select Case True
    Case strSetupSQLASCluster <> "YES" 
      ' Nothing
    Case Len(strClusterNameAS) > 15
      Call SetBuildMessage(strMsgError, "SQL AS Cluster name """ & strClusterNameAS & """ is longer than 15 characters")
    Case strActionSQLAS = "ADDNODE"
      ' Nothing
    Case (strProcessId < "2B") And (CheckClusterExists(strClusterNameAS) <> "")
      Call SetBuildMessage(strMsgError, "SSAS Cluster name """ & strClusterNameAS & """ already exists")
    Case strReportOnly = "YES"
      ' Nothing
    Case (strProcessId > "2CA") And (strProcessId <> "7") And (CheckClusterExists(strClusterNameAS) = "")
      Call SetBuildMessage(strMsgError, "SSAS Cluster name """ & strClusterNameAS & """ does not exist")
  End Select

  Select Case True
    Case strSetupSQLDBCluster <> "YES" 
      ' Nothing
    Case Len(strClusterNameSQL) > 15
      Call SetBuildMessage(strMsgError, "SQL DB Cluster name """ & strClusterNameSQL & """ is longer than 15 characters")
    Case strActionSQLDB = "ADDNODE"
      ' Nothing
    Case (strProcessId > "2ACZ") And (strProcessId <> "7") And (CheckClusterExists(strClusterNameSQL) = "") And (strClusterGroupDTC = strClusterGroupSQL)
      Call SetBuildMessage(strMsgError, "SQL DB Cluster name """ & strClusterNameSQL & """ does not exist")
    Case (strProcessId < "2B") And (CheckClusterExists(strClusterNameSQL) <> "") And (strClusterGroupDTC <> strClusterGroupSQL)
      Call SetBuildMessage(strMsgError, "SQL DB Cluster name """ & strClusterNameSQL & """ already exists")
    Case strReportOnly = "YES"
      ' Nothing
    Case (strProcessId > "2CA") And (strProcessId <> "7") And (CheckClusterExists(strClusterNameSQL) = "")
      Call SetBuildMessage(strMsgError, "SQL DB Cluster name """ & strClusterNameSQL & """ does not exist")
  End Select

  Select Case True
    Case strSetupSSISCluster <> "YES" 
      ' Nothing
    Case Len(strClusterNameIS) > 15
      Call SetBuildMessage(strMsgError, "SQL IS Cluster name """ & strClusterNameIS & """ is longer than 15 characters")
    Case strActionSQLDB = "ADDNODE"
      ' Nothing
    Case (strProcessId < "2B") And (CheckChildClusterExists(strClusterNameIS) <> "")
      Call SetBuildMessage(strMsgError, "SSIS Cluster name """ & strClusterNameIS & """ already exists")
    Case strReportOnly = "YES"
      ' Nothing
    Case (strProcessId > "2CCZ") And (strProcessId <> "7") And (CheckChildClusterExists(strClusterNameIS) = "")
      Call SetBuildMessage(strMsgError, "SSIS Cluster name """ & strClusterNameIS & """ does not exist")
  End Select

  Select Case True
    Case strSetupSQLRSCluster <> "YES" 
      ' Nothing
    Case Len(strClusterNameRS) > 15
      Call SetBuildMessage(strMsgError, "SQL RS Cluster name """ & strClusterNameRS & """ is longer than 15 characters")
    Case strActionSQLRS = "ADDNODE"
      ' Nothing
    Case (strProcessId < "4RA") And (CheckClusterExists(strClusterNameRS) <> "")
      Call SetBuildMessage(strMsgError, "SSRS Cluster name """ & strClusterNameRS & """ already exists")
    Case strReportOnly = "YES"
      ' Nothing
    Case (strProcessId > "4RAZ") And (strProcessId <> "7") And (CheckClusterExists(strClusterNameRS) = "")
      Call SetBuildMessage(strMsgError, "SSRS Cluster name """ & strClusterNameRS & """ does not exist")
  End Select

  Select Case True
    Case strActionDTC = "ADDNODE"
      ' Nothing
    Case strSetupDTCCluster <> "YES" 
      ' Nothing
    Case Len(strClusterNameDTC) > 15
      Call SetBuildMessage(strMsgError, "MSDTC Cluster name """ & strClusterNameDTC & """ is longer than 15 characters")
    Case GetBuildfileValue("VolDTCSource") = "C"
      Call SetBuildMessage(strMsgError, "Invalid value for /VolDTC:" & strVolDTC & ", MSDTC can not be installed to a CSV")
    Case GetBuildfileValue("VolDTCSource") = "S"
      Call SetBuildMessage(strMsgError, "Invalid value for /VolDTC:" & strVolDTC & ", MSDTC can not be installed to a network share")
    Case GetBuildfileValue("VolDTCType") <> "C"
      Call SetBuildMessage(strMsgError, "Invalid value for /VolDTC:" & strVolDTC & ", MSDTC must be installed to a cluster volume")
  End Select

  Select Case True
    Case strSQLVersion >= "SQL2014"
      ' Nothing
    Case strCSVFound = ""
      ' Nothing
    Case Else
      Call SetBuildMessage(strMsgError, strSQLVersion & " does not support use of CSV storage in a SQL Cluster")
  End Select

End Sub


Function CheckReport(strReport, strText)
  Call DebugLog("CheckReport: " & strReport)
  Dim bFound

  bFound            = False
  strCmd            = "%COMSPEC% /D /C FIND /C """ & strText & """ """ & strReport & """"
  Call Util_RunExec(strCmd, "", "", 1)
  If intErrSave = 0 Then
    bFound          = True
  End If

  CheckReport       = bFound

End Function


Function CheckClusterExists(strClusterName)
  Call DebugLog("CheckClusterExists:" & strClusterName)
  Dim strClusWork

  CheckClusterExists = ""
  strClusWork        = GetAddress(strClusterName, "", "N")

  If UCase(strClusterName) = strClusWork Then
    CheckClusterExists = "Y"
  End If

End Function


Function CheckChildClusterExists(strClusterName)
  Call DebugLog("CheckChildClusterExists:" & strClusterName)
  Dim colResources
  Dim objResource

  CheckChildClusterExists = ""
  Set colResources = objCluster.Resources
  For Each objResource In colResources
    Select Case True
      Case objResource.Name = strClusterName
        CheckChildClusterExists = "Y"
        Exit Function
    End Select
  Next

End Function


Sub Validate_Common()
  Call SetProcessId("0EH", "Validation processing for all build types")

  Select Case True
    Case Instr("X86 AMD64", strProcArc) > 0
      ' Nothing
    Case Else
      Call SetBuildMessage(strMsgError, "Unsupported processor architecture " & strProcArc)
  End Select

  Select Case True
    Case Instr(strSQLList, strSQLVersion) > 0
      ' Nothing
    Case Else
      Call SetBuildMessage(strMsgError, "Unsupported SQL Server version: " & strSQLVersion)
  End Select

  Select Case True
    Case Instr(" CONFIG DISCOVER ", strType) > 0
      ' Nothing
    Case strPathSQLMedia = ""
      Call SetBuildMessage(strMsgError, "Folder for /PATHSQLMEDIA: for Edition " & strEdition & " can not be found: " & strPathSQLMediaOrig)
    Case (strSQLVersion <> "SQL2008") And (strSQLVersion <> "SQL2008R2")
      ' Nothing
    Case strSetupSlipstream <> "DONE"
      ' Nothing
    Case Instr(strPathSQLMedia, " ") = 0
      ' Nothing
    Case Else
      Call SetBuildMessage(strMsgError, "SQL Media folder name must not contain spaces")
  End Select

  If (strOSVersion < "6.1") And (Instr(strOSType, "CORE") > 0) Then
    Call SetBuildMessage(strMsgError, strSQLVersion & " install not supported on this operating system")
  End If
 
  Select Case True
    Case strSQLVersion <> "SQL2005"
      ' Nothing
    Case Left(strOSVersion, 1) < "5" ' NT4 or below
      Call SetBuildMessage(strMsgError, strSQLVersion & " install not supported on this operating system")
    Case (strOSVersion = "5.0") And (strOSLevel < "Service Pack 4") ' W2000
      Call SetBuildMessage(strMsgError, strSQLVersion & " install not supported on this operating system.  Service Pack 4 is needed.")
    Case (strOSVersion = "5.1") And (strOSLevel < "Service Pack 2") ' XP
      Call SetBuildMessage(strMsgError, strSQLVersion & " install not supported on this operating system.  Service Pack 2 is needed.")
    Case (strOSVersion < "6.0") And (strOSLevel < "Service Pack 1") ' W2003
      Call SetBuildMessage(strMsgError, strSQLVersion & " install not supported on this operating system.  Service Pack 1 is needed.")
    Case strOSVersion >= "6.2" ' Windows 2012
      Call SetBuildMessage(strMsgError, strSQLVersion & " can not be installed on this operating system")
  End Select

  Select Case True
    Case strSQLVersion <> "SQL2008"
      ' Nothing
    Case strOSVersion < "5.1" ' W2000 or below
      Call SetBuildMessage(strMsgError, strSQLVersion & " install not supported on this operating system")
    Case (strOSVersion < "6.0") And (strOSLevel < "Service Pack 2") ' W2003 and below
      Call SetBuildMessage(strMsgError, strSQLVersion & " install not supported on this operating system.  Service Pack 2 is needed.")
    Case strOSVersion >= "6.3X" ' Windows 2016, Windows 10
      Call SetBuildMessage(strMsgWarning, strSQLVersion & " install not supported on this operating system")
  End Select

  Select Case True
    Case strSQLVersion <> "SQL2008R2"
      ' Nothing
    Case strOSVersion < "5.1" ' W2000 or below
      Call SetBuildMessage(strMsgError, strSQLVersion & " install not supported on this operating system")
    Case (strOSVersion = "5.1") And (strOSLevel < "Service Pack 3") ' XP
      Call SetBuildMessage(strMsgError, strSQLVersion & " install not supported on this operating system.  Service Pack 3 is needed.")
    Case (strOSVersion < "6.1") And (strOSLevel < "Service Pack 2") ' W2008 RTM, Vista, W2003
      Call SetBuildMessage(strMsgError, strSQLVersion & " install not supported on this operating system.  Service Pack 2 is needed.")
    Case strOSVersion >= "6.3X" ' Windows 2016, Windows 10
      Call SetBuildMessage(strMsgWarning, strSQLVersion & " install not supported on this operating system")
  End Select

  Select Case True
    Case strSQLVersion <> "SQL2012"
      ' Nothing
    Case Left(strOSVersion, 1) <= "5" ' W2003 or below
      Call SetBuildMessage(strMsgError, strSQLVersion & " install not supported on this operating system")
    Case (strOSVersion < "6.1") And (strOSLevel < "Service Pack 2") ' W2008 RTM or Vista
      Call SetBuildMessage(strMsgError, strSQLVersion & " install not supported on this operating system.  Service Pack 2 is needed.")
    Case (strOSVersion = "6.1") And (strOSLevel < "Service Pack 1") ' W2008 R2 RTM 
      Call SetBuildMessage(strMsgError, strSQLVersion & " install not supported on this operating system.  Service Pack 1 is needed.")
  End Select

  Select Case True
    Case strSQLVersion <> "SQL2014"
      ' Nothing
    Case Left(strOSVersion, 1) <= "5" ' W2003 or below
      Call SetBuildMessage(strMsgError, strSQLVersion & " install not supported on this operating system")
    Case (strOSVersion < "6.1") And (strOSLevel < "Service Pack 2") ' W2008 RTM or Vista
      Call SetBuildMessage(strMsgError, strSQLVersion & " install not supported on this operating system.  Service Pack 2 is needed.")
    Case (strOSVersion = "6.1") And (strOSLevel < "Service Pack 1") ' W2008 R2 RTM 
      Call SetBuildMessage(strMsgError, strSQLVersion & " install not supported on this operating system.  Service Pack 1 is needed.")
  End Select

  Select Case True
    Case strSQLVersion < "SQL2016"
      ' Nothing
    Case (strOSVersion <= "6.1") ' W2008 R2 or below
      Call SetBuildMessage(strMsgError, strSQLVersion & " install not supported on this operating system")
  End Select

  Select Case True
    Case Instr(" CON PRN AUX NUL COM1 COM2 COM3 COM4 COM5 COM6 COM7 COM8 COM9 LPT1 LPT2 LPT3 LPT4 LPT5 LPT6 LPT7 LPT8 and LPT9 ", " " & strInstance & " ") = 0
      ' Nothing
    Case Else
      Call SetBuildMessage(strMsgError, strInstance & " is a Windows reserved word")
      ' See https://blogs.msdn.com/b/sqlserverfaq/archive/2011/11/02/sql-server-service-pack-installation-may-fail-if-your-instance-name-is-a-windows-reserved-word.aspx
  End Select

  If strUserName = strServer Then
    Call SetBuildMessage(strMsgError, "User name and Server name must not be the same")
  End If

  Select Case True
    Case strSQLProgDir = ""
      Call SetBuildMessage(strMsgError, "/SQLProgDir: parameter must be supplied")
    Case Instr(strSQLProgDir, "\") > 0
      Call SetBuildMessage(strMsgError, "/SQLProgDir: value must not contain a '\': " & strSQLProgDir)
  End Select

  Select Case True
    Case strProcessId > "1TZ"
      ' Nothing
    Case strFirewallstatus <> "1"
      Call SetBuildMessage(strMsgWarning, "Firewall is OFF.  Best practice recommends that Firewall is set to ON")
  End Select

  Select Case True
    Case Instr(" INSTALL UPGRADE ADDNODE INSTALLFAILOVERCLUSTER " , " " & strAction & " ") > 0
      ' Nothing
    Case Instr(" PREPAREIMAGE COMPLETEIMAGE REPAIR REBUILDDATABASE UNINSTALL PREPAREFAILOVERCLUSTER COMPLETEFAILOVERCLUSTER REMOVENODE " , " " & strAction & " ") > 0
      Call SetBuildMessage(strMsgError, "Value for /Action: is not supported " & strAction)
    Case Else
      Call SetBuildMessage(strMsgError, "Invalid value for /Action: " & strAction)
  End Select

  Select Case True
    Case strSetupDRUCtlr <> "YES"
      ' Nothing
    Case GetBuildfileValue("DRUCtlrAccount" & "Type") = "L"
      Call SetBuildMessage(strMsgError, "/CtlrSvcAccount: parameter must be a domain account")
    Case GetBuildfileValue("DRUCtlrAccount" & "Type") = "S"
      Call SetBuildMessage(strMsgError, "/CtlrSvcAccount: parameter must be a domain account")
  End Select

  Select Case True
    Case strSetupDQ <> "YES"
      ' Nothing
    Case Len(strDQPassword) < 8  
      Call SetBuildMessage(strMsgError,  "/DQPassword: value must be at least 8 characters")
  End Select

  Select Case True
    Case strSQLVersion < "SQL2016"
      ' Nothing
    Case strSetupPolyBase <> "YES"
      ' Nothing
    Case strPBEngSvcAccount <> strPBDMSSvcAccount
      Call SetBuildMessage(strMsgError, "/PBEngSvcAccount: and /PBDMSSvcAccount: must be the same")
    Case GetBuildfileValue("PBEngSvcAccount" & "Type") = "L"
      Call SetBuildMessage(strMsgError, "/PBEngSvcAccount: parameter must be a domain account")
    Case GetBuildfileValue("PBEngSvcAccount" & "Type") = "S"
      Call SetBuildMessage(strMsgError, "/PBEngSvcAccount: parameter must be a domain account")
  End Select
  If strSetupPolyBase = "YES" Then
    Call SetParam("TCPEnabled",              strTCPEnabled,            "1",     "TCP is mandatory for PolyBase", "")
  End If

  Select Case True
    Case strSetupRSExec <> "YES"
      ' Nothing
    Case Else
      If GetBuildfileValue("RsExecAccount") = "" Then
        Call SetBuildMessage(strMsgError, "/RsExecAccount: parameter must be supplied")
      End If
      If GetBuildfileValue("RsExecPassword") = "" Then
        Call SetBuildMessage(strMsgError, "/RsExecPassword: parameter must be supplied")
      End If
      If GetBuildfileValue("RSEmail") = "" Then
        Call SetBuildMessage(strMsgError, "/RSEmail: parameter must be supplied")
      End If
  End Select

  Select Case True
    Case strSetupRSShare <> "YES"
      ' Nothing
    Case Else
      If GetBuildfileValue("RsShareAccount") = "" Then
        Call SetBuildMessage(strMsgError, "/RsShareAccount: parameter must be supplied")
      End If
      If GetBuildfileValue("RsSharePassword") = "" Then
        Call SetBuildMessage(strMsgError, "/RsSharePassword: parameter must be supplied")
      End If
  End Select

  Select Case True
    Case strSetupCompliance <> "YES"
      ' Nothing
    Case strGroupDBA = ""
      Call SetBuildMessage(strMsgError, "/GroupDBA must be specified for /SetupCompliance:YES")
    Case strGroupDBANonSA = ""
      Call SetBuildMessage(strMsgError, "/GroupDBANonSA must be specified for /SetupCompliance:YES")
    Case strGroupDBANonSA = strGroupDBA
      Call SetBuildMessage(strMsgError, "/GroupDBANonSA must be different to /GroupDBA for /SetupCompliance:YES")
  End Select

  Select Case True
    Case strSetupSQLAS <> "YES"
      ' Nothing
    Case Else
      If GetBuildfileValue("VolDataASSource") = "C" Then
        Call SetBuildMessage(strMsgError, "Invalid value for /VolDataAS:" & strVolDataAS & ", Analysis Services can not be installed to a CSV")
      End If
      If GetBuildfileValue("VolLogASSource") = "C" Then
        Call SetBuildMessage(strMsgError, "Invalid value for /VolLogAS:" & strVolLogAS & ", Analysis Services can not be installed to a CSV")
      End If
      If GetBuildfileValue("VolTempASSource") = "C" Then
        Call SetBuildMessage(strMsgError, "Invalid value for /VolTempAS:" & strVolTempAS & ", Analysis Services can not be installed to a CSV")
      End If
      If GetBuildfileValue("VolDataASSource") = "S" Then
        Call SetBuildMessage(strMsgError, "Invalid value for /VolDataAS:" & strVolDataAS & ", Analysis Services can not be installed to a network share")
      End If
      If GetBuildfileValue("VolLogASSource") = "S" Then
        Call SetBuildMessage(strMsgError, "Invalid value for /VolLogAS:" & strVolLogAS & ", Analysis Services can not be installed to a network share")
      End If
      If GetBuildfileValue("VolTempASSource") = "S" Then
        Call SetBuildMessage(strMsgError, "Invalid value for /VolTempAS:" & strVolTempAS & ", Analysis Services can not be installed to a network share")
      End If
  End Select

  Select Case True
    Case strSetupSQLDB <> "YES"
      ' Nothing
    Case strFSLevel = "0"
      ' Nothing
    Case Else
      If GetBuildfileValue("VolDataFSSource") = "S" Then
        Call SetBuildMessage(strMsgError, "Invalid value for /VolDataFS:, Filestream can not be installed to a network share")
      End If
  End Select

End Sub


Sub Output_Lists()
  Call SetProcessId("0EI", "Output Parameter lists")

  Select Case True
    Case (strProcessId > "1") And (strProcessId <> "7")
      ' Nothing
    Case strListType = ""
      ' Nothing
    Case Else
      Call SetBuildMessage(strMsgInfo, "The following Parameters set to N/A due to " & strType & " build")
      Call FormatList("ListType", strListType)
  End Select

  Select Case True
    Case (strProcessId > "1") And (strProcessId <> "7")
      ' Nothing
    Case strListOSVersion = ""
      ' Nothing
    Case Else
      Call SetBuildMessage(strMsgInfo, "The following Parameters set to N/A due to OS " & strOSName)
      Call FormatList("ListOSVersion", strListOSVersion)
  End Select

  Select Case True
    Case (strProcessId > "1") And (strProcessId <> "7")
      ' Nothing
    Case strListCore = ""
      ' Nothing
    Case Else
      Call SetBuildMessage(strMsgInfo, "The following Parameters set to N/A on Server Core OS")
      Call FormatList("ListCore", strListCore)
  End Select

  Select Case True
    Case (strProcessId > "1") And (strProcessId <> "7")
      ' Nothing
    Case strListAddNode = ""
      ' Nothing
    Case Else
      Call SetBuildMessage(strMsgInfo, "The following Parameters set to N/A due to /Action: value ADDNODE")
      Call FormatList("ListAddNode", strListAddNode)
  End Select

  Select Case True
    Case (strProcessId > "1") And (strProcessId <> "7")
      ' Nothing
    Case strListSQLVersion = ""
      ' Nothing
    Case Else
      Call SetBuildMessage(strMsgInfo, "The following Parameters set to N/A due to SQL Version " & strSQLVersion)
      Call FormatList("ListSQLVersion", strListSQLVersion)
  End Select

  Select Case True
    Case (strProcessId > "1") And (strProcessId <> "7")
      ' Nothing
    Case strListEdition = ""
      ' Nothing
    Case strEdType <> ""
      Call SetBuildMessage(strMsgInfo, "The following Parameters set to N/A due to Edition " & strEdition & " (" & strEdType & ")")
      Call FormatList("ListEdition", strListEdition)
    Case Else
      Call SetBuildMessage(strMsgInfo, "The following Parameters set to N/A due to Edition " & strEdition)
      Call FormatList("ListEdition", strListEdition)
  End Select

  Select Case True
    Case (strProcessId > "1") And (strProcessId <> "7")
      ' Nothing
    Case strListCompliance = ""
      ' Nothing
    Case Else
      Call SetBuildMessage(strMsgInfo, "The following Parameters set to YES due to /SetupCompliance: value " & strSetupCompliance)
      Call FormatList("ListCompliance", strListCompliance)
  End Select

  Select Case True
    Case (strProcessId > "1") And (strProcessId <> "7")
      ' Nothing
    Case strListSQLTools = ""
      ' Nothing
    Case Else
      Call SetBuildMessage(strMsgInfo, "The following Parameters set to N/A due to /SetupSQLTools: value " & strSetupSQLTools)
      Call FormatList("ListSQLTools", strListSQLTools)
  End Select

  Select Case True
    Case (strProcessId > "1") And (strProcessId <> "7")
      ' Nothing
    Case strListCluster = ""
      ' Nothing
    Case Else
      Call SetBuildMessage(strMsgInfo, "The following Parameters set to N/A due to not a SQL DB Cluster install")
      Call FormatList("ListCluster", strListCluster)
  End Select

  Select Case True
    Case (strProcessId > "1") And (strProcessId <> "7")
      ' Nothing
    Case strListSQLDB = ""
      ' Nothing
    Case Else
      Call SetBuildMessage(strMsgInfo, "The following Parameters set to N/A due to /SetupSQLDB: value " & strSetupSQLDB)
      Call FormatList("ListSQLDB", strListSQLDB)
  End Select

  Select Case True
    Case (strProcessId > "1") And (strProcessId <> "7")
      ' Nothing
    Case strListSSAS = ""
      ' Nothing
    Case Else
      Call SetBuildMessage(strMsgInfo, "The following Parameters set to N/A due to /SetupSQLAS: value " & strSetupSQLAS)
      Call FormatList("ListSSAS", strListSSAS)
  End Select

  Select Case True
    Case (strProcessId > "1") And (strProcessId <> "7")
      ' Nothing
    Case strListSQLRS = ""
      ' Nothing
    Case Else
      Call SetBuildMessage(strMsgInfo, "The following Parameters set to N/A due to /SetupSQLRS: value " & strSetupSQLRS)
      Call FormatList("ListSQLRS", strListSQLRS)
  End Select

  Select Case True
    Case (strProcessId > "1") And (strProcessId <> "7")
      ' Nothing
    Case strListSSIS = ""
      ' Nothing
    Case Else
      Call SetBuildMessage(strMsgInfo, "The following Parameters set to N/A due to /SetupSQLIS: value " & strSetupSQLIS)
      Call FormatList("ListSSIS", strListSSIS)
  End Select

  Select Case True
    Case (strProcessId > "1") And (strProcessId <> "7")
      ' Nothing
    Case strListMain = ""
      ' Nothing
    Case Else
      Call SetBuildMessage(strMsgInfo, "The following Parameters set to NO due to /MainInstance: value " & strMainInstance)
      Call FormatList("ListMain", strListMain)
  End Select

End Sub


Sub FormatList(strListType, strList)
  Call DebugLog("FormatList: " & strListType)
  Dim strWorkList, strLine

  strWorkList       = RTrim(LTrim(strList))
  While LTrim(strWorkList) > ""
    strLine         = RTrim(Left(strWorkList, 76))
    Select Case True
      Case Len(strLine) = 76
        strLine     = Left(strLine, InstrRev(strLine, " "))
        strWorkList = LTrim(Mid(strWorkList & " ", Len(strLine)))
      Case Else
        strWorkList = " "
    End Select
    Call SetBuildMessage(strMsgInfo, "  " & strLine)
  WEnd

End Sub


Sub Validate_License()
  Call SetProcessId("0EJ", "Validate License details")
  Dim strMessage

  Call FBLog(" ")
  Select Case True
    Case colArgs.Exists("IAcceptLicenseTerms") 
      strMessage    = "/IAcceptLicenseTerms is present."
      Call FBLog(strMessage)
      Call SetBuildfileValue("LicenseMsg1", strMessage)
      strMessage    = "  This means that you accept the license terms of FineBuild and the licence terms of all products that FineBuild installs"
      Call FBLog(strMessage)
      Call SetBuildfileValue("LicenseMsg2", strMessage)
      Call SetBuildfileValue("IAcceptLicenseTerms", "YES")
    Case Else
      strMessage    = strMsgError & ": /IAcceptLicenseTerms is not found"
      Call FBLog(strMessage)
      Call SetBuildfileValue("LicenseMsg1", strMessage)
      strMessage    = strMsgError & ":  /IAcceptLicenseTerms must be given to show you accept the license terms of FineBuild and of all products that FineBuild installs"
      Call FBLog(strMessage)
      Call SetBuildfileValue("LicenseMsg2", strMessage)
      Call SetBuildfileValue("IAcceptLicenseTerms", "NO")
  End Select
  Call FBLog(" ")

End Sub


Function GetGroupAction(strGroupName)
  Call DebugLog("GetGroupAction:" & strGroupName)

  Select Case True
    Case strGroupName = strClusterGroupSQL
      GetGroupAction = strActionSQLDB
    Case strGroupName = strClusterGroupAS
      GetGroupAction = strActionSQLAS
    Case strGroupName = strClusterGroupDTC
      GetGroupAction = strActionDTC
    Case Else
      GetGroupAction = strAction
  End Select

End Function


Function Include(strFile)
  Dim objFSO, objFile
  Dim strFilePath, strFileText

  Select Case True
    Case strPathFB = "%SQLFBFOLDER%"
      err.Raise 8, "", "ERROR: This process must be run by SQLFineBuild.bat"
    Case Else
      Set objFSO        = CreateObject("Scripting.FileSystemObject")
      strFilePath       = strPathFB & "Build Scripts\" & strFile
      Set objFile       = objFSO.OpenTextFile(strFilePath)
      strFileText       = objFile.ReadAll()
      objFile.Close 
      ExecuteGlobal strFileText
  End Select

End Function


End Class