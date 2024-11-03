;-TOP ProgramData and CheckWindowPosition, by mk-soft, v0.7

EnableExplicit

; Change names
#CompanyName = "mk-soft"
#ApplicationName = "MyApp"

Structure udtWindowPosition
  x.i
  y.i
  Width.i
  Height.i
  State.i
EndStructure

Structure udtProgramData
  Window.udtWindowPosition
  DataPath.s
  LastPath.s
  List LastFiles.s()
EndStructure

Structure udtProjectData
  Version.i
  Date.s
  ; Data
  ;TODO
  List Text.s() 
EndStructure

Global ProgramData.udtProgramData
Global ProjectData.udtProjectData

; ----

Enumeration
  #MainWindow
EndEnumeration

Enumeration
  #MainMenu
EndEnumeration

Enumeration
  #MainMenuItem_Exit
  #MainMenuItem_LoadProject
  #MainMenuItem_SaveProject
EndEnumeration

Enumeration
  #MainStatusBar
EndEnumeration

; ----

Procedure GetWindowPosition(Window)
  With ProgramData\Window
    ; Get window state mode 
    \State = GetWindowState(Window)
    ; Set window state to normal
    SetWindowState(Window, #PB_Window_Normal)
    ; Get window postion and size
    \x = WindowX(Window)
    \y = WindowY(Window)
    \Width = WindowWidth(Window)
    \Height = WindowHeight(Window)
  EndWith
EndProcedure

Procedure SetWindowPosition(Window)
  Protected cnt, i
  
  With ProgramData\Window
    ; Check the position and size of the program is aviable
    If \Width <= 0 Or \Height <= 0
      ProcedureReturn #False
    EndIf
    ; Checks that the position and size of the program fits on the available desktop.
    cnt = ExamineDesktops()
    For i = 0 To cnt - 1
      If \x >= DesktopX(i) And \x < DesktopX(i) + DesktopWidth(i)
        If \y >= DesktopY(i) And \y < DesktopY(i) + DesktopHeight(i)
          If \x - DesktopX(i) + \Width <= DesktopWidth(i) And \y - DesktopY(i) + \Height <= DesktopHeight(i)
            ResizeWindow(Window, \x, \y, \Width, \Height)
            SetWindowState(Window, \State)
            ProcedureReturn #True
          EndIf
        EndIf
      EndIf
    Next
    ProcedureReturn #False
  EndWith
EndProcedure

; ----

Procedure LoadProgramData(FileName.s = "ProgramData.xml")
  Protected basepath.s, subpath.s, datapath.s, filepath.s, xml
  
  CompilerIf #PB_Compiler_OS = #PB_OS_Linux
    basepath = GetHomeDirectory()
    subpath = basepath + "." + #CompanyName + #PS$
  CompilerElse
    basepath = GetUserDirectory(#PB_Directory_ProgramData)
    subpath = basepath + #CompanyName + #PS$
  CompilerEndIf
  datapath = subpath  + #ApplicationName + #PS$
  filepath = datapath + FileName
  If FileSize(filepath) > 0
    xml = LoadXML(#PB_Any, filepath)
    If xml And XMLStatus(xml) = #PB_XML_Success
      ExtractXMLStructure(MainXMLNode(xml), @ProgramData, udtProgramData, #PB_XML_NoCase)
      FreeXML(xml)
      ProgramData\DataPath = datapath
      ProcedureReturn #True
    EndIf
  EndIf
  ProgramData\DataPath = ""
  ProcedureReturn #False
EndProcedure

; ----

Procedure SaveProgramData(FileName.s = "ProgramData.xml")
  Protected basepath.s, subpath.s, datapath.s, filepath.s, xml
  
  CompilerIf #PB_Compiler_OS = #PB_OS_Linux
    basepath = GetHomeDirectory()
    subpath = basepath + "." + #CompanyName + #PS$
  CompilerElse
    basepath = GetUserDirectory(#PB_Directory_ProgramData)
    subpath = basepath + #CompanyName + #PS$
  CompilerEndIf
  datapath = subpath  + #ApplicationName + #PS$
  If FileSize(datapath) <> -2
    If FileSize(subpath) <> -2
      CreateDirectory(subpath)
    EndIf
    If FileSize(datapath) <> -2
      CreateDirectory(datapath)
    EndIf
  EndIf
  filepath = datapath + FileName
  xml = CreateXML(#PB_Any)
  If xml
    If InsertXMLStructure(RootXMLNode(xml), @ProgramData, udtProgramData)
      FormatXML(xml, #PB_XML_ReFormat)
      SaveXML(xml, filepath)
    EndIf
    FreeXML(xml)
  EndIf
EndProcedure

; ----

Procedure LoadProjectData(FileName.s, *ProjectData.udtProjectData)
  Protected xml
  
  If FileSize(FileName) > 0
    xml = LoadXML(#PB_Any, FileName)
    If xml And XMLStatus(xml) = #PB_XML_Success
      ExtractXMLStructure(MainXMLNode(xml), *ProjectData, udtProjectData, #PB_XML_NoCase)
      FreeXML(xml)
      ProcedureReturn #True
    EndIf
  EndIf
  ProcedureReturn #False
EndProcedure

; ----

Procedure SaveProjectData(FileName.s, *ProjectData.udtProjectData)
  Protected r1, xml
  
  xml = CreateXML(#PB_Any)
  If xml
    *ProjectData\Version = 101
    *ProjectData\Date = FormatDate("%YYYY-%MM-%DD %HH.%II.%SS", Date())
    If InsertXMLStructure(RootXMLNode(xml), *ProjectData, udtProjectData)
      FormatXML(xml, #PB_XML_ReFormat)
      If SaveXML(xml, FileName)
        r1 = #True
      Else
        r1 = #False
      EndIf
    EndIf
    FreeXML(xml)
  EndIf
  ProcedureReturn r1
EndProcedure

; ----

Procedure Main()
  Protected state, file.s
  
  LoadProgramData()
  
  #MainStyle = #PB_Window_SystemMenu | #PB_Window_SizeGadget | #PB_Window_MinimizeGadget | #PB_Window_MaximizeGadget | #PB_Window_Invisible
  
  OpenWindow(#MainWindow, #PB_Ignore, #PB_Ignore, 800, 600, "Program-Data", #MainStyle)
    
  SetWindowPosition(#MainWindow)
  
  CreateMenu(#MainMenu, WindowID(#MainWindow))
  MenuTitle("&File")
  MenuItem(#MainMenuItem_LoadProject, "&Load Project")
  MenuItem(#MainMenuItem_SaveProject, "&Save Project")
  MenuBar()
  MenuItem(#MainMenuItem_Exit, "E&xit")
  
  CreateStatusBar(#MainStatusBar, WindowID(#MainWindow))
  AddStatusBarField(#PB_Ignore)
  StatusBarText(#MainStatusBar, 0, "ProgramDataPath: " + ProgramData\DataPath)
  
  HideWindow(#MainWindow, #False)
  
  Repeat
    Select WaitWindowEvent()
      Case #PB_Event_Menu
        Select EventMenu()
          CompilerIf #PB_Compiler_OS = #PB_OS_MacOS
          Case #PB_Menu_Quit
            Break
          CompilerEndIf
          
        Case #MainMenuItem_LoadProject
          file = OpenFileRequester("Load Project", ProgramData\LastPath, "", 0)
          If file
            If Not LoadProjectData(file, @ProjectData)
              MessageRequester("Error", "Load Projekt" + #LF$ + file)
            Else
              ProgramData\LastPath = GetFilePart(file)
            EndIf
          EndIf
          
        Case #MainMenuItem_SaveProject
          file = SaveFileRequester("Save Project", ProgramData\LastPath + "project.xml", "", 0)
          If file
            If Not SaveProjectData(file, @ProjectData)
              MessageRequester("Error", "Save Projekt" + #LF$ + file)
            Else
              ProgramData\LastPath = GetFilePart(file)
            EndIf
          EndIf
          
        Case #MainMenuItem_Exit
          Break
          
      EndSelect
      
      Case #PB_Event_CloseWindow
        Break
    EndSelect
  ForEver
  
  GetWindowPosition(#MainWindow)
  
  SaveProgramData()
  
EndProcedure : Main()

; IDE Options = PureBasic 5.73 LTS (MacOS X - x64)
; Folding = ------
; EnableXP