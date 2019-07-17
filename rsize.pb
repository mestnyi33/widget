;{
;   Software:     AutoGadgetResize.pbi
;   Description:  Window, Container and Gadget  auto-resize
;   Autor:        minimy
;   Date:         30/06/2019
;   License:      Free.. like solar energy? :P
;}

;--- autoresize
;{
;{ AutoGadgetResize Estructura
  Structure AutoGadgetResizeStructure
    window.i
    conten.i
    gadget.i
    parent.b ;0=gadget, 1=window
    ;posición gadget original
    origx.i
    origy.i
    origw.i
    origh.i
    ;posición gadget nueva
    x.i
    y.i
    w.i
    h.i
    ;posición ventana original
    winorigx.i
    winorigy.i
    winorigw.i
    winorigh.i
    ;posición ventana original
    wx.i
    wy.i
    ww.i
    wh.i
    ;magnetico
    top.b
    right.b
    down.b
    left.b
  EndStructure
  Global NewList AgadRes.AutoGadgetResizeStructure()
;}
  Procedure AutoGadgetResize(gadget.i, left.b, top.b, right.b, down.b, window.i=-1,conten.i=-1)
    ; gagdet=               gadget to apply
    ; left,top,right,down=  magnetic stick to zone
    ; window=               window parent
    ; conten=               contenedor parent (if exist, else -1)
    
    ; gagdet=               gadget al que se le aplica el autoresize
    ; left,top,right,down=  zona a la que se pega magneticamente
    ; window=               ventana padre del gadget
    ; conten=               contenedor padre del gadget (solo si existe, sino -1 o dejarlo sin definir)
    AddElement(AgadRes())
    AgadRes()\conten=   conten
    If conten= -1
      ; es window
      AgadRes()\window=   window
      AgadRes()\winorigx= WindowX(window)
      AgadRes()\winorigy= WindowY(window)
      AgadRes()\winorigw= WindowWidth(window)
      AgadRes()\winorigh= WindowHeight(window)
      AgadRes()\wx=       WindowX(window)
      AgadRes()\wy=       WindowY(window)
      AgadRes()\wh=       WindowWidth(window)
      AgadRes()\ww=       WindowHeight(window)
    Else
      ;es contenedor
      AgadRes()\window=   pariente
      window= conten
      AgadRes()\winorigx= GadgetX(conten)
      AgadRes()\winorigy= GadgetY(conten)
      AgadRes()\winorigw= GadgetWidth(conten)
      AgadRes()\winorigh= GadgetHeight(conten)
      AgadRes()\wx=       GadgetX(conten)
      AgadRes()\wy=       GadgetY(conten)
      AgadRes()\wh=       GadgetWidth(conten)
      AgadRes()\ww=       GadgetHeight(conten)
    EndIf
    ;datos comundes
    AgadRes()\gadget=   gadget
    AgadRes()\x=        GadgetX(gadget)
    AgadRes()\y=        GadgetY(gadget)
    AgadRes()\w=        GadgetWidth(gadget)
    AgadRes()\h=        GadgetHeight(gadget)
    AgadRes()\origx=    GadgetX(gadget)
    AgadRes()\origy=    GadgetY(gadget)
    AgadRes()\origw=    GadgetWidth(gadget)
    AgadRes()\origh=    GadgetHeight(gadget)
    AgadRes()\top=      top
    AgadRes()\right=    right
    AgadRes()\down=     down
    AgadRes()\left=     left
    
    ProcedureReturn window
  EndProcedure
  Procedure AutoGadgetResizeEvent()
    Protected.i left,right,top,down
    ForEach AgadRes()
      If AgadRes()\conten= -1
        ;es window
        ;left y right
        If AgadRes()\right And AgadRes()\left=0
          right=        AgadRes()\winorigw-(AgadRes()\origw+AgadRes()\origx)
          AgadRes()\x=  WindowWidth(AgadRes()\window) - (AgadRes()\w+right)
;           Debug "right"
        EndIf
        If AgadRes()\left And AgadRes()\right=0
          left=         AgadRes()\origx
          AgadRes()\x=  left
;           Debug "left"
        EndIf
        If AgadRes()\left And AgadRes()\right
          left=         AgadRes()\origx
          right=        WindowWidth(AgadRes()\window)- (AgadRes()\winorigw-(AgadRes()\origw+AgadRes()\origx))
          AgadRes()\x=  left
          AgadRes()\w=  right-left
;           Debug "left+right"
        EndIf
        ;top y down
        If AgadRes()\down And AgadRes()\top=0
          down=        AgadRes()\winorigh-(AgadRes()\origh+AgadRes()\origy)
          AgadRes()\y=  WindowHeight(AgadRes()\window) - (AgadRes()\h+down)
;           Debug "down"
        EndIf
        If AgadRes()\top And AgadRes()\down=0
          top=         AgadRes()\origy
          AgadRes()\y=  top
;           Debug "top"
        EndIf
        If AgadRes()\down And AgadRes()\top
          top=         AgadRes()\origy
          down=        WindowHeight(AgadRes()\window)- (AgadRes()\winorigh-(AgadRes()\origh+AgadRes()\origy))
          AgadRes()\y=  top
          AgadRes()\h=  down-top
;           Debug "top+down"
        EndIf
      Else
        ;es gadget
        ;left y right
        If AgadRes()\right And AgadRes()\left=0
          right=        AgadRes()\winorigw-(AgadRes()\origw+AgadRes()\origx)
          AgadRes()\x=  GadgetWidth(AgadRes()\conten) - (AgadRes()\w+right)
;           Debug "right"
        EndIf
        If AgadRes()\left And AgadRes()\right=0
          left=         AgadRes()\origx
          AgadRes()\x=  left
;           Debug "left"
        EndIf
        If AgadRes()\left And AgadRes()\right
          left=         AgadRes()\origx
          right=        GadgetWidth(AgadRes()\conten)- (AgadRes()\winorigw-(AgadRes()\origw+AgadRes()\origx))
          AgadRes()\x=  left
          AgadRes()\w=  right-left
;           Debug "left+right"
        EndIf
        ;top y down
        If AgadRes()\down And AgadRes()\top=0
          down=        AgadRes()\winorigh-(AgadRes()\origh+AgadRes()\origy)
          AgadRes()\y=  GadgetHeight(AgadRes()\conten) - (AgadRes()\h+down)
;           Debug "down"
        EndIf
        If AgadRes()\top And AgadRes()\down=0
          top=         AgadRes()\origy
          AgadRes()\y=  top
;           Debug "top"
        EndIf
        If AgadRes()\down And AgadRes()\top
          top=         AgadRes()\origy
          down=        GadgetHeight(AgadRes()\conten)- (AgadRes()\winorigh-(AgadRes()\origh+AgadRes()\origy))
          AgadRes()\y=  top
          AgadRes()\h=  down-top
;           Debug "top+down"
        EndIf
      EndIf
      
      ResizeGadget(AgadRes()\gadget,AgadRes()\x,AgadRes()\y,AgadRes()\w,AgadRes()\h)
    Next
  EndProcedure
;}

CompilerIf Not #PB_Compiler_IsIncludeFile
  W_main.i = OpenWindow(#PB_Any ,0,0,600,600,"AutoGadgetResize",#PB_Window_SystemMenu|#PB_Window_MaximizeGadget|#PB_Window_ScreenCentered)
    S_text = TextGadget(#PB_Any,430,100,160,60,"Im a text sticky right."+#CRLF$+"Maximice window please.")
    B_boton = ButtonGadget(#PB_Any,10,10,180,30,"Im a button and will grow up")
    B_boton2 = ButtonGadget(#PB_Any,10,50,180,130,"Im a button and keep my position")
    C_cont1= ContainerGadget(#PB_Any,290,300,300,100,#PB_Container_Flat)
      S_string = StringGadget(#PB_Any,10,10,150,60,"Im string into container")
      B_boton3 = ButtonGadget(#PB_Any,170,10,120,60,"Im button still position and size",#PB_Button_MultiLine)
    CloseGadgetList()
    
    ;apply autoresize to objetcs (gadgets and containers)
    AutoGadgetResize(S_text,0,0,1,0,W_main)
    AutoGadgetResize(B_boton,1,1,1,1,W_main)
    AutoGadgetResize(B_boton2,1,0,0,1,W_main)
    AutoGadgetResize(C_cont1,1,1,1,1,W_main)
    AutoGadgetResize(S_string,1,1,1,1,W_main,C_cont1)
    AutoGadgetResize(B_boton3,0,0,1,1,W_main,C_cont1)
    
  Repeat
    event = WaitWindowEvent(1)
    Select event
      Case #PB_Event_SizeWindow
        ;check window change
        AutoGadgetResizeEvent()
      Case #PB_Event_Gadget
        
    EndSelect
    
  Until event = #PB_Event_CloseWindow
CompilerEndIf
; IDE Options = PureBasic 5.70 LTS (MacOS X - x64)
; Folding = ----
; EnableXP