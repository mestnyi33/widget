
XIncludeFile "../../widgets.pbi"

CompilerIf #PB_Compiler_IsMainFile
   UseWidgets( )
   
  Global NewMap buttons()
   
   Procedure SetGadget(*this._s_WIDGET, *parent._s_WIDGET, mode)
      AddMapElement(buttons( ), Str(*parent+mode)) : buttons( ) = *this
      SetParent(*this, *parent)
   EndProcedure
   
   Procedure GetGadget(*parent._s_WIDGET, mode)
     ProcedureReturn buttons( Str(*parent+mode))
   EndProcedure
   
   Procedure ListIcon_(X,Y,Width,Height,firstcolumntitle.s, firstcolumnwidth, flags.q=0 )
      Protected *g1 = Button(0,0,30,30,"1") ; Tree(0,0,0,0)
      Protected *g2 = Button(90,0,30,30,"_2") ; Tree(0,0,0,0)
      
      Protected *g._s_WIDGET = Container( X,Y,Width,Height ) : CloseList()
      
      SetGadget(*g1, *g, 1) 
      SetGadget(*g2, *g, 2) 
      
      ProcedureReturn *g
   EndProcedure
   
   Procedure AddColumn_( *this._s_WIDGET, position.l, Text.s, Width.l, Image.i = -1 )
      Static count = 2
      count + 1
      Protected._s_WIDGET *g2 = GetGadget(*this, 2)
      Protected._s_WIDGET *g, *g1 = Button(0,0,30,30,Str(count)) ; Tree(0,0,0,0)
        ; SetParent(*g2, *this\parent)
   
       Static X = 190
      
      *g = Container( X,0,*this\width,70 ) : CloseList()
      SetGadget(*g2, *g, 2) 
      SetGadget(*g1, *g, 1) 
      
      SetGadget(*g, *this, 1) 
      X + Width
    
   EndProcedure
 
   If Open(0, 0, 0, 800, 450, "ListiconGadget", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
     
      
     a_init(Root())
       g = 13
      *g = ListIcon_(10, 230, 700, 210, "Column_0",190, #__Flag_GridLines|#__Flag_CheckBoxes|#__flag_RowFullSelect);|: *g = GetGadgetData(g)                                          
      
      i=1 : AddColumn_(*g, i,"Column_"+Str(i),90)
         
         i=2 : AddColumn_(*g, i,"Column_"+Str(i),90)
         
         i=3 : AddColumn_(*g, i,"Column_"+Str(i),90)
         
         
         If StartEnum(Root())
               Debug "" + widgets()\class +" > "+ widgets()\parent\class
         
           StopEnum() 
         EndIf
         
         
      WaitClose( )
  EndIf
CompilerEndIf
; IDE Options = PureBasic 6.21 - C Backend (MacOS X - x64)
; CursorPosition = 34
; FirstLine = 16
; Folding = --
; EnableXP
; DPIAware