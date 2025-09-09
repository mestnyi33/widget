XIncludeFile "../../../widgets.pbi" 

CompilerIf #PB_Compiler_IsMainFile
  EnableExplicit
  UseWidgets( )
  ;
  Procedure.i _a_set( *this._s_WIDGET, mode.i = #PB_Default, size.l = #PB_Default, position.l = #PB_Default )
         Protected result
         ;
         If *this
            If *this\anchors
               If mode >= 0
                  *this\anchors\mode = mode
               EndIf
               ;
;                If size >= 0
;                   size = DPIScaled(size)
;                   If *this\anchors\size <> size
;                      *this\anchors\size = size
;                      *this\bs - *this\anchors\pos
;                      *this\anchors\pos = size / 2
;                      *this\bs + *this\anchors\pos
;                      a_size( *this\anchors\id, *this\anchors\size, *this\anchors\mode )
;                      Resize( *this, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore )
;                   EndIf
;                EndIf
;                
;                If position >= 0
;                   position = DPIScaled(position)
;                   If *this\anchors\pos <> position
;                      *this\bs - *this\anchors\pos
;                      *this\anchors\pos = position
;                      *this\bs + *this\anchors\pos 
;                      a_size( *this\anchors\id, *this\anchors\size, *this\anchors\mode )
;                      Resize( *this, #PB_Ignore, #PB_Ignore, #PB_Ignore, #PB_Ignore )
;                   EndIf
;                EndIf
               ;
               ;\\
               If a_anchors( ) 
                  
                  If a_show( *this )
                        *this\root\repaint = 1
                     EndIf
                     
                     *this\anchors\show = 1
                     ;Debug  ""+ *this\anchors +" "+ *this\anchors\mode
                          
                     a_focused( ) = *this
               EndIf
            EndIf
         EndIf
         ;
         ProcedureReturn result
      EndProcedure
      
  Procedure _events( )
     If is_root_(EventWidget())
        If #__event_MouseMove = WidgetEvent()
           
           
        EndIf
        If #__event_LeftUp = WidgetEvent()
           
           If mouse( )\selector
              ClearDebugOutput()
              ForEach widgets()
                 If is_intersect_( widgets( ), mouse( )\selector, [#__c_frame] )
                    
                    Debug widgets()\text\string 
                    _a_set( widgets())
                    
                 EndIf
              Next
           EndIf
        
        EndIf
        ProcedureReturn 0
     EndIf
     If #__event_MouseMove = WidgetEvent()
        ProcedureReturn 0
     EndIf
     
    ; Debug "" + Index( EventWidget()) +" "+ ClassFromEvent( WidgetEvent()) 
  EndProcedure
  
  If Open(0, 0, 0, 800, 450, "Example 1: Creation of a basic objects.", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
    SetColor(root( ), #PB_Gadget_BackColor, RGBA(245, 245, 245, 255))
    ;
    ;\\
    a_init(root( ))
    ;a_init(Window(40,40,720,370,"window", #PB_Window_systemmenu))
    ;a_init(MDI(40,40,720,370)) : OpenList(widget())
    ;a_init(Container(40,40,720,370))
    ;a_init(ScrollArea(40,40,720,370, 800,500))
    ;a_init(Panel(40,40,720,370)) : AddItem(widget(), -1, "panel")
    ;
    ;\\
    a_object(50, 50, 200, 100, "Layer = 1", RGBA(128, 192, 64, 125))
    a_object(300, 50, 200, 100, "Layer = 2", RGBA(192, 64, 128, 125))
    a_object(50, 200, 200, 100, "Layer = 3", RGBA(92, 64, 128, 125))
    a_object(300, 200, 200, 100, "Layer = 4", RGBA(192, 164, 128, 125))
    ;
    ;\\
    Bind( root( ), @_events( ))
    WaitClose( )
  EndIf
CompilerEndIf
; IDE Options = PureBasic 6.20 (Windows - x64)
; CursorPosition = 66
; FirstLine = 57
; Folding = ---
; EnableXP
; DPIAware