''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'
'  FBConfigReport.vbs  
'  Copyright FineBuild Team © 2013 - 2018.  Distributed under Ms-Pl License
'
'  Purpose:      Script to produce report showing:
'                a) Options specified for what is to be installed
'                b) Confirmation of what has been installed
'
'  Author:       Ed Vassie
'
'  Change History
'  Version  Author        Date         Description
'  1.0      Ed Vassie     20 Dec 2013  Initial version
'
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
Option Explicit
Dim SQLBuild : Set SQLBuild = New FineBuild

Class FineBuild

Dim colPrcEnvVars
Dim intIndex
Dim objApp, objAutoUpdate, objFSO, objReportFile, objShell, objWMI, objWMIREG
Dim strClusterName, strEdType, strFileArc, strHKLMSQL, strInstance, strInstNode
Dim strMainInstance, strOSType, strOSVersion
Dim strPathFB, strRebootStatus, strReportFile, strReportOnly
Dim strSQLVersion, strStatusComplete, strStatusBypassed, strStopAt
Dim strType, strUserName, strValidateError

Private Sub Class_Initialize
' Perform FineBuild processing

  err.Clear
  Call Initialisation()

  Select Case True
    Case err.Number <> 0 
      ' Nothing
    Case Else
      Call ProcessReport()
  End Select

End Sub


Private Sub Class_Terminate
' Error handling and termination

  Select Case True
    Case strPathFB = "%SQLFBFOLDER%"
      ' Nothing
    Case strProcessId > "7ZZ"
      ' Nothing
    Case err.Number = 0 
      ' Nothing
    Case Else
      Call FBLog("***** Error has occurred *****")
      If strProcessIdLabel <> "" Then
        Call FBLog(" Process    : " & strProcessIdLabel & ": " & strProcessIdDesc)
      End If
      If err.Number <> "" Then
        Call FBLog(" Error code : " & err.Number)
      End If
      If err.Source <> "" Then
        Call FBLog(" Source     : " & err.Source)
      End If
      If err.Description <> "" Then
        Call FBLog(" Description: " & err.Description)
      End If
      If strDebugDesc <> "" And strDebugDesc <> err.Description Then
        Call FBLog(" Last Action: " & strDebugDesc)
      End If
      If strDebugMsg1 <> "" Then
        Call FBLog(" " & strDebugMsg1)
      End If
      If strDebugMsg2 <> "" Then
        Call FBLog(" " & strDebugMsg2)
      End If
      Call FBLog(" Configuration Report failed")
    End Select

  Wscript.quit(err.Number)

End Sub


Sub Initialisation ()
' Perform initialisation procesing

  Set objShell      = WScript.CreateObject ("Wscript.Shell")
  strPathFB         = objShell.ExpandEnvironmentStrings("%SQLFBFOLDER%")
  Include "FBManageBuildfile.vbs"
  Include "FBManageLog.vbs"
  Include "FBUtils.vbs"
  Call SetProcessIdCode("FBCR")

  Set objApp        = CreateObject ("Shell.Application")
  Set objAutoUpdate = CreateObject("Microsoft.Update.AutoUpdate") 
  Set objFSO        = CreateObject ("Scripting.FileSystemObject")
  Set objWMI        = GetObject("winmgmts:{impersonationLevel=impersonate}!\\.\root\cimv2")
  Set objWMIReg     = GetObject("winmgmts:{impersonationLevel=impersonate}!\\.\root\default:StdRegProv")
  Set colPrcEnvVars = objShell.Environment("Process")

  strHKLMSQL        = GetBuildfileValue("HKLMSQL")
  strClusterName    = GetBuildfileValue("ClusterName")
  strEdType         = GetBuildfileValue("EdType")
  strFileArc        = GetBuildfileValue("FileArc")
  strInstance       = GetBuildfileValue("Instance")
  strInstNode       = GetBuildfileValue("InstNode")
  strMainInstance   = GetBuildfileValue("MainInstance")
  strOSType         = GetBuildfileValue("OSType")
  strOSVersion      = GetBuildfileValue("OSVersion")
  strRebootStatus   = GetBuildfileValue("RebootStatus")
  strReportFile     = GetBuildfileValue("ReportFile")
  strReportOnly     = GetBuildfileValue("ReportOnly")
  strSQLVersion     = GetBuildfileValue("AuditVersion")
  strStatusComplete = GetBuildfileValue("StatusComplete")
  strStatusBypassed = GetBuildfileValue("StatusBypassed")
  strStopAt         = GetBuildfileValue("StopAt")
  strType           = GetBuildfileValue("Type")
  strUserName       = GetBuildfileValue("AuditUser")
  strValidateError  = GetBuildfileValue("ValidateError")

  Set objReportFile = objFSO.CreatetextFile(strReportFile, 1, 0)

End Sub


Sub ProcessReport()
  Call DebugLog("Configuration Report Processing (FBConfigReport.vbs)")

  Call DisplayHeader

  Call DisplayEnvironment

  Select Case True
    Case strRebootStatus = "Done"
      ' Nothing
    Case Else
      Call DisplayMessages
  End Select

  Select Case True
    Case strRebootStatus = "Done"
      ' Nothing
    Case Else
      Call DisplaySetupParms
  End Select

  Select Case True
    Case strRebootStatus = "Done"
      ' Nothing
    Case Else
      Call DisplayRunTimeParms
  End Select

  Select Case True
    Case strRebootStatus = "Done"
      ' Nothing
    Case strType = "FIX"
      Call VerifyStatus
    Case strProcessId < "6Z"
      ' Nothing
    Case Else
      Call VerifyStatus
  End Select

  Select Case True
    Case strRebootStatus = "Done"
      ' Nothing
    Case Else
      Call CheckValidate
  End Select

  Call ReportClose

  Call DebugLog("  Configuration Report processing" & strStatusComplete)

End Sub


Sub DisplayHeader()
  Call DebugLog("DisplayHeader:")

  Call FBReport("SQL FineBuild Configuration Report")

  Call FormatHeader("")
  Call FormatHeader("SQL FineBuild process started " & GetBuildfileValue("AuditStartDate") & " at " & GetBuildfileValue("AuditStartTime"))
  Call FormatHeader("Configuration Report produced " & Cstr(Date()) & " at " & CStr(Time()))

  Call FormatHeader("")
  Select Case True
    Case  strProcessId = "" 
      ' Nothing
    Case  strProcessId = "1" 
      ' Nothing
    Case strReportOnly = "YES"
      ' Nothing
    Case strRebootStatus = "Done"
      Call FormatHeader("********************************************")
      Call FormatHeader("*")
      Call FormatHeader("* REBOOT in Progress")
      Call FormatHeader("* Reboot triggered at      " & strProcessId)
      Call FormatHeader("*")
      Call FormatHeader("********************************************")
    Case (strProcessId = "6Z") Or (strProcessId = "3Z" And strType = "FIX")
      Call FormatHeader("********************************************")
      Call FormatHeader("*")
      Call FormatHeader("* " & strSQLVersion & " FineBuild Install Complete")
      Call FormatHeader("*")
      Call FormatHeader("********************************************")
    Case (strStopAt <> "") And (strProcessId >= strStopAt)
      Call FormatHeader("********************************************")
      Call FormatHeader("*")
      Call FormatHeader("* " & strSQLVersion & " FineBuild STOPPED AT " & strProcessId)
      Call FormatHeader("*")
      Call FormatHeader("********************************************")
    Case Else
      Call FormatHeader("********************************************")
      Call FormatHeader("*")
      Call FormatHeader("* " & strSQLVersion & " FineBuild has FAILED")
      Call FormatHeader("* Process Id at failure    " & strProcessId)
      Call FormatHeader("*")
      Call FormatHeader("********************************************")
  End Select
  Call FormatHeader("")

End Sub

Sub FormatHeader(strMessage)

  Call FBReport("  " & strMessage)

End Sub


Sub DisplayEnvironment()
  Call DebugLog("DisplayEnvironment:")

  Call FBReport("SQL FineBuild Execution Environment")

  Call FormatEnvText("", "")
  Call FormatEnvText("SQL FineBuild Version",     GetBuildfileValue("VersionFB"))
  Call FormatEnvText("Server Name",               GetBuildfileValue("AuditServer"))
  If strClusterName <> "" Then
    Call FormatEnvText("Cluster Name",            strClusterName)
  End If
  Call FormatEnvText("Operating System Name",     GetBuildfileValue("OSName"))
  Call FormatEnvText("Operating System Level",    GetBuildfileValue("OSLevel"))
  Call FormatEnvText("Operating System Platform", strFileArc)
  Call FormatEnvText("SQL Server Version",        strSQLVersion)
  Call FormatEnvText("", "")

  Call FormatEnvText("/Type:",                    strType)
  Call FormatEnvText("/Action:",                  GetBuildfileValue("InstSQL"))
  Select Case True
    Case strEdType = ""
      Call FormatEnvText("/Edition:",             GetBuildfileValue("AuditEdition"))
    Case Else
      Call FormatEnvText("/Edition:",             GetBuildfileValue("AuditEdition") & " (" & strEdType & ")")
  End Select
  Call FormatEnvText("/Instance:",                GetBuildfileValue("InstSQL"))
  Select Case True
    Case GetBuildfileValue("SetupSlipstream") = "YES"
      Call FormatEnvText("/SPLevel:",             GetBuildfileValue("SPLevel"))
    Case GetBuildfileValue("SetupSP") = "YES"
      Call FormatEnvText("/SPLevel:",             GetBuildfileValue("SPLevel"))
    Case strSQLVersion >= "SQL2012"
      Call FormatEnvText("/SPLevel:",             GetBuildfileValue("SPLevel"))
  End Select
  Select Case True
    Case GetBuildfileValue("SetupSlipstream") = "YES"
      Call FormatEnvText("/SPCULevel:",           GetBuildfileValue("SPCULevel"))
    Case strSQLVersion >= "SQL2012"
      ' Nothing
    Case GetBuildfileValue("SetupSPCU") = "YES"
      Call FormatEnvText("/SPCULevel:",           GetBuildfileValue("SPCULevel"))
  End Select

  Call FormatEnvText("", "")
  Call FormatEnvText(GetBuildfileValue("LicenseMsg1"), "")
  Call FormatEnvText(GetBuildfileValue("LicenseMsg2"), "")

  Call FormatEnvText("", "")
  Call FormatEnvText("SQL FineBuild Log File", objShell.ExpandEnvironmentStrings("%SQLLOGTXT%"))
  Call FormatEnvText("", "")

End Sub


Sub FormatEnvText(strText, strValue)
  Dim strEnv

  strEnv            = "  " & strText

  Select Case True
    Case strValue = ""
      ' Nothing
    Case Else
      strEnv        = Left(strEnv & Space(29), 29) & strValue
  End Select

  Call FBReport(strEnv)

End Sub


Sub DisplayMessages()
  Call DebugLog("DisplayMessages:")

  Call FBReport("")
  Call FBReport("SQL FineBuild Messages")

  Call GetMessages(strMsgError)
  Call GetMessages(strMsgWarning)
  Call GetMessages(strMsgInfo)

  Call FBReport("")

End Sub


Sub GetMessages(strType)
  Call DebugLog("GetMessages: " & strType)
  Dim colMessage
  Dim objMessages
  Dim intMessage, intFound
  Dim strMessage, strMsgXtra

  strMsgXtra        = GetBuildfileValue("MsgXtra")
  Call FBReport("")
  Call FBReport("  " & strType & " Messages")

  Set colMessage    = objBuildfile.documentElement.selectSingleNode("Message")
  Set objMessages   = colMessage.attributes
  intFound          = 0
  intMessage        = 0
  While intMessage  < objMessages.length
    intMessage      = intMessage + 1
    strMessage      = colMessage.getAttribute("Msg" & CStr(intMessage))
    Select Case True
      Case strType = strMsgError And Left(strMessage, Len(strType)) = strMsgError
        intFound    = 1
        Call FBReport("    " & strMessage)
      Case strType = strMsgWarning And Left(strMessage, Len(strType)) = strMsgWarning
        intFound    = 1
        Call FBReport("    " & strMessage)
      Case strType = strMsgInfo And Left(strMessage, Len(strType)) = strMsgInfo
        intFound    = 1
        strMessage = Mid(strMessage, Len(strType) + 3)
        Call FBReport("    " & strMessage)
    End Select
  WEnd

  Select Case True
    Case intFound = 0 
      Call FBReport("    None")
    Case strType = strMsgError
      Call FBReport("    ")
      Call FBReport("    " & "For generic troubleshooting see https://github.com/SQL-FineBuild/Common/wiki/FineBuild-Generic-Troubleshooting")
      If strMsgXtra <> "" Then
        Call FBReport("    " & strMsgXtra)
      End If
  End Select

End Sub


Sub DisplaySetupParms()
  Call DebugLog("DisplaySetupParms:")
  Dim strMessage

  Call FBReport("SQL FineBuild Setup Parameters")
  Call FBReport("")
  Call FBReport("  Parameters are described at https://github.com/SQL-FineBuild/Common/wiki/FineBuild-Setup-Parameters")
  Call FBReport("")
  Call FBReport("  Parameter                  Value     Status")

  Select Case True ' Parameters used by FineBuild1Preparation
    Case strType = "FIX"
      ' Nothing
    Case Else
      Call FBReport("")
      Call FormatSetupParm("SetupPowerCfg",      "")
      Call FormatSetupParm("SetupNoDefrag",      "")
      Call FormatSetupParm("SetupWinAudit",      "")
      Call FormatSetupParm("SetupFirewall",      "")
      Call FormatSetupParm("SetupNetName",       "")
      Call FormatSetupParm("SetupNetBind",       "")
      Call FormatSetupParm("SetupNoTCPNetBios",  "")
      Call FormatSetupParm("SetupNoTCPOffload",  "")
      Call FormatSetupParm("SetupTLS12",         "")
      Call FormatSetupParm("SetupNoSSL3",        "")
      Call FormatSetupParm("SetupSPN",           "")
      Call FormatSetupParm("SetupNoWinGlobal",   "")
      Call FormatSetupParm("SetupNoDriveIndex",  "")
      Call FormatSetupParm("SetupShares",        "")
      Call FormatSetupParm("SetupTempWin",       "")
  End Select 

  Select Case True ' Parameters used by FineBuild2InstallSQL
    Case strType = "FIX"
      ' Nothing
    Case Else
      Call FBReport("")
      ' Parameters for 2A processes
      Call FormatSetupParm("SetupSlipstream",    "")
      Call FormatSetupParm("SetupKB2919442",     "")
      Call FormatSetupParm("SetupKB2919355",     "")
      Call FormatSetupParm("SetupDTCCID",        "")
      Call FormatSetupParm("SetupDTCNetAccess",  "")
      Call FormatSetupParm("SetupDTCCluster",    "")
      Call FormatSetupParm("SetupKB3090973",     "")
      Call FormatSetupParm("SetupJRE",           "")
      Call FormatSetupParm("SetupNet3",          "")
      Call FormatSetupParm("SetupIIS",           "")
      Call FormatSetupParm("SetupMSI45",         "")
      Call FormatSetupParm("SetupPS1",           "")
      Call FormatSetupParm("SetupPS2",           "")
      Call FormatSetupParm("SetupKB925336",      "")
      Call FormatSetupParm("SetupKB933789",      "")
      Call FormatSetupParm("SetupKB937444",      "")
      Call FormatSetupParm("SetupKB956250",      "")
      Call FormatSetupParm("SetupNet4",          "")
      Call FormatSetupParm("SetupKB4019990",     "")
      Call FormatSetupParm("SetupNet4x",         "")
      Call FormatSetupParm("SetupRSAT",          "")
      Call FormatSetupParm("SetupPSRemote",      "")
      ' Parameters for 2B processes
      Call FormatSetupParm("SetupSQLDB",         "")
      Call FormatSetupParm("SetupSQLDBCluster",  "")
      Call FormatSetupParm("SetupSQLDBAG",       "")
      Call FormatSetupParm("SetupSQLDBRepl",     "")
      If strSQLVersion >= "SQL2012" Then
        Call FormatSetupParm("SetupSQLDBFS",     "")
      End If
      Call FormatSetupParm("SetupSQLDBFT",       "")
      If strSQLVersion >= "SQL2012" Then
        Call FormatSetupParm("SetupDQC",         "")
      End If
      Call FormatSetupParm("SetupSQLAS",         "")
      Call FormatSetupParm("SetupSQLASCluster",  "")
      Call FormatSetupParm("SetupSQLIS",         "")
      If strSQLVersion >= "SQL2017" Then
        Call FormatSetupParm("SetupISMaster",    "")
        Call FormatSetupParm("SetupISWorker",    "")
      End If
      If (strSQLVersion <= "SQL2016") And (GetBuildfileValue("SetupPowerBI") <> "YES") Then
        Call FormatSetupParm("SetupSQLRS",       "")
      End If
      Call FormatSetupParm("SetupSQLNS",         "")
      If strSQLVersion = "SQL2005" Then
        Call FormatSetupParm("SetupSQLBC",       "")
      End If
      If strSQLVersion < "SQL2016" Then
        Call FormatSetupParm("SetupSSMS",        "")
      End If
      Call FormatSetupParm("SetupBIDS",          "")
      If strSQLVersion >= "SQL2012" Then
        Call FormatSetupParm("SetupDRUClt",      "")
        Call FormatSetupParm("SetupDRUCtlr",     "")
      End If
      If strSQLVersion >= "SQL2016" Then
        Call FormatSetupParm("SetupPolyBase",    "")
        Call FormatSetupParm("SetupAnalytics",   "")
        Call FormatSetupParm("SetupRServer",     "")
      End If
      If strSQLVersion >= "SQL2017" Then
        Call FormatSetupParm("SetupPython",      "")
      End If
      ' Parameters for 2C processes
      Call FormatSetupParm("SetupClusterShares", "")
      If strSQLVersion >= "SQL2016" Then
        Call FormatSetupParm("SetupPolyBaseCluster",  "")
      End If
      Call FormatSetupParm("SetupSSISCluster",   "")
'      If strSQLVersion >= "SQL2017" Then
'        Call FormatSetupParm("SetupISMasterCluster",  "")
'      End If
  End Select 

  Select Case True ' Parameters used by FineBuild3InstallFixes
    Case Else
      Call FBReport("")
      Call FormatSetupParm("SetupSP",            "")
      Call FormatSetupParm("SetupSPCU",          "")
      Call FormatSetupParm("SetupSPCUSNAC",      "")
      Call FormatSetupParm("SetupBOL",           "")
  End Select

  Select Case True ' Parameters used by FineBuild4InstallXtras
    Case strType = "FIX"
      ' Nothing
    Case Else
      Call FBReport("")
      ' Parameters for Pre-Reqs
      Call FormatSetupParm("SetupVS2005SP1",     "")
      Call FormatSetupParm("SetupKB932232",      "")
      Call FormatSetupParm("SetupKB954961",      "")
      Call FormatSetupParm("SetupVS2010SP1",     "")
      Call FormatSetupParm("SetupMBCA",          "")
      Call FormatSetupParm("SetupReportViewer",  "")
      If strSQLVersion > "SQL2005" Then
        Call FormatSetupParm("SetupSQLBC",       "")
      End If
      Call FormatSetupParm("SetupSQLCE",         "")
      If strSQLVersion >= "SQL2016" Then
        Call FormatSetupParm("SetupSSMS",        "")
        Call FormatSetupParm("SetupKB2862966",   "")
      End If
      Call FormatSetupParm("SetupVC2010",        "")
      If strSQLVersion >= "SQL2012" Then
        Call FormatSetupParm("SetupAlwaysOn",    "")
      End If
      ' Parameters for BI Xtras
      Call FormatSetupParm("SetupSSDTBI",        "")
      Call FormatSetupParm("SetupMDXStudio",     "")
      Call FormatSetupParm("SetupBIDSHelper",    "")
      ' Parameters for IS Xtras
      Call FormatSetupParm("SetupDTSDesigner",   "")
      Call FormatSetupParm("SetupDTSBackup",     "")
      Call FormatSetupParm("SetupDimensionSCD",  "")
      Call FormatSetupParm("SetupRawReader",     "")
      ' Parameters for Report Xtras
      Select Case True
        Case GetBuildfileValue("SetupPowerBI") = "YES"
          Call FormatSetupParm("SetupPowerBI",   "")
        Case strSQLVersion >= "SQL2017"
          Call FormatSetupParm("SetupSQLRS",     "")
      End Select
      Call FormatSetupParm("SetupRSIndexes",     "")
      Call FormatSetupParm("SetupRSAdmin",       "")
      Call FormatSetupParm("SetupRSExec",        "")
      Call FormatSetupParm("SetupSQLRSCluster",  "")
      Call FormatSetupParm("SetupRSAlias",       "")
      Call FormatSetupParm("SetupRptTaskPad",    "")
      Call FormatSetupParm("SetupRSScripter",    "")
      Call FormatSetupParm("SetupRSLinkGen",     "")
      Call FormatSetupParm("SetupPowerBIDesktop","")
      ' Parameters for SQL Xtras
      Call FormatSetupParm("SetupBPAnalyzer",    "")
      Call FormatSetupParm("SetupJavaDBC",       "")
      Call FormatSetupParm("SetupDB2OLE",        "")
      Call FormatSetupParm("SetupCacheManager",  "")
      Call FormatSetupParm("SetupIntViewer",     "")
      If strSQLVersion >= "SQL2008R2" Then
        Call FormatSetupParm("SetupMDS",         "")
      End If
      Call FormatSetupParm("SetupPerfDash",      "")
      Call FormatSetupParm("SetupSystemViews",   "")
      If strSQLVersion > "SQL2005" Then
        Call FormatSetupParm("SetupSQLNS",       "")
      End If
      Call FormatSetupParm("SetupStreamInsight", "")
'      Call FormatSetupParm("SetupSamples",       "")
      Call FormatSetupParm("SetupSemantics",     "")
      If strSQLVersion >= "SQL2012" Then
        Call FormatSetupParm("SetupDQ",          "")
      End If
      Call FormatSetupParm("SetupDistributor",   "")
      ' Parameters for Tools Xtras
      Call FormatSetupParm("SetupABE",           "")
      Call FormatSetupParm("SetupXEvents",       "")
      Call FormatSetupParm("SetupPDFReader",     "")
      Call FormatSetupParm("SetupProcExp",       "")
      Call FormatSetupParm("SetupProcMon",       "")
      Call FormatSetupParm("SetupRMLTools",      "")
      Call FormatSetupParm("SetupSQLNexus",      "")
      Call FormatSetupParm("SetupTrouble",       "")
      Call FormatSetupParm("SetupXMLNotepad",    "")
      Call FormatSetupParm("SetupPlanExplorer",  "")
      Call FormatSetupParm("SetupPlanExpAddin",  "")
      Call FormatSetupParm("SetupZoomIt",        "")
      Call FormatSetupParm("SetupSQLTools",      "")
  End Select

  Select Case True ' Parameters used by FineBuild5ConfigureSQL
    Case strType = "FIX"
      ' Nothing
    Case Else
      Call FBReport("")
      ' Parameters for 5A
      Call FormatSetupParm("SetupDCom",          "")
      Call FormatSetupParm("SetupNetwork",       "")
      Call FormatSetupParm("SetupParam",         "")
      Call FormatSetupParm("SetupServices",      "")
      Call FormatSetupParm("SetupServiceRights", "")
      Call FormatSetupParm("SetupAPCluster",     "")
      ' Parameters for 5B
      Call FormatSetupParm("SetupSQLServer",     "")
      Call FormatSetupParm("SetupDBMail",        "")
      Call FormatSetupParm("SetupSQLMail",       "")
      Call FormatSetupParm("SetupSQLInst",       "")
      Call FormatSetupParm("SetupSQLAgent",      "")
      Call FormatSetupParm("SetupOLAPAPI",       "")
      Call FormatSetupParm("SetupOLAP",          "")
      Call FormatSetupParm("SetupSSISDB",        "")
      Call FormatSetupParm("SetupRSKeepAlive",   "")
      ' Parameters for 5C
      Call FormatSetupParm("SetupStdAccounts",   "")
      Call FormatSetupParm("SetupSAAccounts",    "")
      Call FormatSetupParm("SetupNonSAAccounts", "")
      Call FormatSetupParm("SetupDisableSA",     "")
      Call FormatSetupParm("SetupCmdshell",      "")
      ' Parameters for 5D
      Call FormatSetupParm("SetupSysDB",         "")
      Call FormatSetupParm("SetupTempDb",        "")
      Call FormatSetupParm("SetupSysIndex",      "")
      ' Parameters for 5E
      Call FormatSetupParm("SetupSysManagement", "")
      Call FormatSetupParm("SetupBPE",           "")
      Call FormatSetupParm("SetupDBAManagement", "")
      Call FormatSetupParm("SetupManagementDW",  "")
      Call FormatSetupParm("SetupPBM",           "")
      Call FormatSetupParm("SetupGenMaint",      "")
      Call FormatSetupParm("SetupGovernor",      "")
      Call FormatSetupParm("SetupDBOpts",        "")
      If strSQLVersion >= "SQL2012" Then
        Call FormatSetupParm("SetupAODB",        "")
      End If
      ' Parameters for 5F
      Call FormatSetupParm("SetupMenus",         "")
      ' Parameters for 5G
      Call FormatSetupParm("SetupOldAccounts",   "")
  End Select

  Select Case True ' Parameters used by FineBuild6ConfigureUsers
    Case strType = "FIX"
      ' Nothing
    Case Else
      Call FBReport("")
      Call FormatSetupParm("SetupCMD",           "")
      Call FormatSetupParm("SetupVS",            "")
      Call FormatSetupParm("SetupNetTrust",      "")
      Call FormatSetupParm("SetupWindows",       "")
      Call FormatSetupParm("SetupMyDocs",        "")
  End Select 
  Call FBReport("")

End Sub


Sub FormatSetupParm(strParam, strParamStatus)
  Dim strStatus

  Select Case True
    Case Left(strParam, 5) = "Setup"
      strStatus     = Left("  /" & strParam & ":" & Space(29), 29)
    Case Else
      strStatus     = Left("  " & strParam & Space(29), 29)
  End Select

  strStatus         = Left(strStatus & GetBuildfileValue(strParam) & Space(15), 38)

  Select Case True
    Case strParamStatus = ""
      strStatus     = strStatus & GetBuildfileValue(strParam & "Status")
    Case strParamStatus = "--"
      strStatus     = strStatus & " --"
    Case Else
      strStatus     = strStatus & GetBuildfileValue(strParamStatus)
  End Select

  Call FBReport(strStatus)

End Sub


Sub DisplayRunTimeParms()
  Call DebugLog("DisplayRunTimeParms:")

  Call FBReport("SQL FineBuild Run Time Parameters")
  Call FBReport("")
  Call FBReport("  Parameters are described at https://github.com/SQL-FineBuild/Common/wiki/FineBuild-Run-Time-Parameters")
  Call FBReport("  Note: Not all Run Time parameters are shown on this report")
  Call FBReport("")
  Call FBReport("  Parameter                  Value")

  Call FBReport("")
  Call FBReport(FormatRunTimeParm("PathSQLMedia",        "PathSQLMediaOrig"))
  Call FBReport(FormatRunTimeParm("PathSQLSP",           "PathSQLSPOrig"))
  Call FBReport(FormatRunTimeParm("PathAddComp",         "PathAddCompOrig"))

  Call FBReport("")
  Call FBReport(FormatVolParm("VolSys",                  "DirSys"))
  Call FBReport(FormatVolParm("VolProg",                 "DirProg"))
  Call FBReport(FormatVolParm("VolTempWin",              "PathTemp"))
  Call FBReport(FormatVolParm("VolDBA",                  "DirDBA"))
  If GetBuildfileValue("SetupDTCCluster") = "YES" Then 
    Call FBReport(FormatVolParm("VolDTC",             ""))
  End If
  If GetBuildfileValue("SetupSQLDB") = "YES" Then
    Call FBReport(FormatVolParm("VolData",               "DirData"))
    Select Case True
      Case GetBuildfileValue("SetupSQLDBFS") <> "YES"
        ' Nothing
      Case GetBuildfileValue("FSLevel") < "2"
        ' Nothing
      Case Else
        Call FBReport(FormatVolParm("VolDataFS",         "DirDataFS"))
    End Select
    Select Case True
      Case GetBuildfileValue("SetupSQLDBFT") <> "YES"
        ' Nothing
      Case Else
        Call FBReport(FormatVolParm("VolDataFT",         "DirDataFT"))
    End Select
    Call FBReport(FormatVolParm("VolSysDB",              "DirSysDB"))
    Call FBReport(FormatVolParm("VolLog",                "DirLog"))
    Call FBReport(FormatVolParm("VolLogTemp",            "DirLogTemp"))
    Call FBReport(FormatVolParm("VolTemp",               "DirTemp"))
    Call FBReport(FormatVolParm("VolBackup",             "DirBackup"))
    If GetBuildfileValue("SetupBPE") = "YES" Then
      Call FBReport(FormatVolParm("VolBPE",              "DirBPE"))
    End If
  End If
  If GetBuildfileValue("SetupSQLAS") = "YES" Then  
    Call FBReport(FormatVolParm("VolDataAS",             "DirDataAS"))
    Call FBReport(FormatVolParm("VolLogAS",              "DirLogAS"))
    Call FBReport(FormatVolParm("VolTempAS",             "DirTempAS"))
    Call FBReport(FormatVolParm("VolBackupAS",           "DirBackupAS"))
  End If

  Call FBReport("")
  If GetBuildfileValue("SetupSQLDB") = "YES" Then
    Call FBReport(FormatAccountParm("SqlAccount",        "SqlSvcAccount",     "SqlAccount"))
    If GetBuildfileValue("SetupSQLDBAG") = "YES" Then
      Call FBReport(FormatAccountParm("AgtAccount",      "AgtSvcAccount",     "AgtAccount"))
    End If
    Call FBReport(FormatAccountParm("SqlBrowserAccount", "BrowserSvcAccount", "SqlBrowserAccount"))
  End If
  If GetBuildfileValue("SetupSQLAS") = "YES" Then 
    Call FBReport(FormatAccountParm("AsAccount",         "AsSvcAccount",      "AsAccount"))
  End If
  If GetBuildfileValue("SetupSQLIS") = "YES" Then 
    Call FBReport(FormatAccountParm("IsAccount",         "IsSvcAccount",      "IsAccount"))
  End If
  If GetBuildfileValue("SetupSQLRS") = "YES" Then 
    Call FBReport(FormatAccountParm("RsAccount",         "RsSvcAccount",      "RsAccount"))
    If GetBuildfileValue("SetupRSExec") = "YES" Then
      Call FBReport(FormatAccountParm("RsExecAccount",   "RsExecAccount",     ""))
    End If
  End If
  If GetBuildfileValue("SetupCmdshell") = "YES" Then 
    Call FBReport(FormatAccountParm("CmdShellAccount",   "CmdShellAccount",   ""))
  End If
  If GetBuildfileValue("SetupDRU") = "YES" Then 
    Call FBReport(FormatAccountParm("DRUCtlrAccount",    "CtlrSvcAccount",    ""))
    Call FBReport(FormatAccountParm("DRUCltAccount",     "CltSvcAccount",     ""))
  End If
  If GetBuildfileValue("SetupMDW") = "YES" Then 
    Call FBReport(FormatAccountParm("MDWAccount",        "MDWAccount",        ""))
  End If
  Call FBReport(FormatAccountParm("GroupDBA",            "GroupDBA",          ""))
  Call FBReport(FormatAccountParm("GroupDBANonSA",       "GroupDBANonSA",     ""))
  Call FBReport("")

End Sub


Function FormatRunTimeParm(strParam, strAltParam)
  Dim strParameter

  strParameter      = Left("  /" & strParam & ":" & Space(29), 29)
  Select Case True
    Case strAltParam <> "" And GetBuildfileValue(strParam) = ""
      strParameter  = strParameter & GetBuildfileValue(strAltParam)
      strParameter  = Left(strParameter & Space(10), Max(Len(strParameter), 38)) & " Not Found"
    Case strAltParam <> ""
      strParameter  = strParameter & GetBuildfileValue(strAltParam)
      strParameter  = Left(strParameter & Space(10), Max(Len(strParameter), 38)) & " (" & GetBuildfileValue(strParam) & ")"
    Case Else
      strParameter  = Left(strParameter & Space(10), Max(Len(strParameter), 38)) & " (" & GetBuildfileValue(strParam) & ")"
  End Select

  FormatRunTimeParm = strParameter

End Function


Function FormatVolParm(strVolParam, strFolderParam)
  Dim strParameter, strFolderValue

  strFolderValue    = ""
  strParameter      = Left("  /" & strVolParam & ":" & Space(29), 29)
  strParameter      = strParameter & GetBuildfileValue(strVolParam)
  strParameter      = Left(strParameter & Space(10), Max(Len(strParameter), 38))
  If strFolderParam <> "" Then
    strFolderValue  = GetBuildfileValue(strFolderParam)
  End If
  If strFolderValue <> "" Then
    strParameter    = strParameter & " (" & strFolderValue & ") "
  End If

  FormatVolParm     = strParameter

End Function


Function FormatAccountParm(strAccount, strNewName, strOldName)
  Dim strParameter

  Select Case True
    Case strOldName = ""
      strParameter  = Left("  /" & strNewName & ":" & Space(29), 28)
    Case strSQLVersion = "SQL2005"
      strParameter  = Left("  /" & strOldName & ":" & Space(29), 28)
    Case Else
      strParameter  = Left("  /" & strNewName & ":" & Space(29), 28)
  End Select
  strParameter      = strParameter & " " & GetBuildfileValue(strAccount)

  FormatAccountParm = strParameter

End Function


Sub VerifyStatus()
  Call DebugLog("Verify install status")

  Select Case True
    Case strType = "CLIENT"
      Call VerifyClientStatus
    Case strType = "FIX"
      Call VerifyFixStatus
    Case Else
      Call VerifyFullStatus
  End Select

End Sub


Sub VerifyClientStatus()
  Call DebugLog("Verify install status for CLIENT build")

  ' To be completed

End Sub


Sub VerifyFixStatus()
  Call DebugLog("Verify install status for FIX build")

  ' To be completed

End Sub


Sub VerifyFullStatus()
  Call DebugLog("Verify install status for FULL or WORKSTATION build")

  ' To be completed

End Sub


Sub CheckValidate()
  Call DebugLog("Check Validation Status")

  If strValidateError <> "" Then
    err.Raise 8, "SQL FineBuild Validation", "Error found during SQL FineBuild validation"
  End If

End Sub


Sub ReportClose()
  Call DebugLog("ReportClose:")
  Dim strFineBuildStatus

  strFineBuildStatus = GetBuildfileValue("FineBuildStatus")
  Select Case True
    Case strFineBuildStatus = ""
      ' Nothing
    Case strFineBuildStatus <> GetBuildfileValue("StatusComplete")
      ' Nothing
    Case Else
      Call LogClose()
  End Select

  Call FBReport("")
  Call FBReport("End of Report")

  objReportFile.Close

End Sub


Sub FBReport(strText)

  objReportFile.Writeline(strText)

End Sub


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
