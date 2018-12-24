CompilerIf #PB_Compiler_IsMainFile
  XIncludeFile "module_draw.pbi"
  XIncludeFile "module_macros.pbi"
  XIncludeFile "module_constants.pbi"
  XIncludeFile "module_structures.pbi"
  XIncludeFile "module_procedures.pbi"
  
  CompilerIf #VectorDrawing
    UseModule Draw
  CompilerEndIf
CompilerEndIf

;-
DeclareModule Procedures
  
  EnableExplicit
  UseModule Macros
  UseModule Constants
  UseModule Structures
  
  
  Declare.i GridSpacing(Value.i, Grid.i, Max.i=$7FFFFFFF)
  Declare.i Arrow(X.i,Y.i, Size.i, Direction.i, Color.i, Thickness.i = 1, Length.i = 1)
  Declare.s Font_GetNameFromGadgetID(GadgetID)
  Declare.i GetCurrentDpi()
  Declare.i IsHideGadget(Gadget)
EndDeclareModule 

Module Procedures
  CompilerSelect #PB_Compiler_OS
    CompilerCase #PB_OS_Linux
      ImportC ""
        pango_context_list_families(*context, *families, *n_families); PangoFontFamily
        pango_context_get_font_description(*context)
        pango_font_description_get_family(*desc)
        pango_font_family_get_name(*family)
        pango_font_family_is_monospace(*family)
        pango_font_description_from_string(str.p-utf8)
        
        ;  gtk_widget_modify_font_(GadgetID, pango_font_description_from_string("Monospace bold 10")) ; gtk2
				;; for reset use ...
        ;  gtk_widget_modify_font_(GadgetID, #Null)
        
        ;  gtk_widget_override_font(GadgetID, pango_font_description_from_string("Monospace bold 10")) ; gtk3
		    ;; for reset use ...
        ;  gtk_widget_override_font(GadgetID, #Null)

;       EndImport
;       ImportC ""
        g_object_get_property(*object.GObject, property.p-utf8, *gval)
        
        
        gtk_widget_set_visible(*widget.GtkWidget, visible)
        gtk_widget_get_visible(*widget.GtkWidget)
      EndImport
  CompilerEndSelect
  
  Procedure.i IsHideGadget(Gadget)
    Protected.i Ret
    
    CompilerSelect #PB_Compiler_OS
      CompilerCase #PB_OS_Linux
        ret = gtk_widget_get_visible(GadgetID(Gadget))
      CompilerCase #PB_OS_MacOS
        ret = CocoaMessage(0, GadgetID(Gadget), "isHidden")
    CompilerEndSelect
    
    ProcedureReturn Ret
  EndProcedure

  
  #G_TYPE_INT  = 24
  
  Procedure.i GetCurrentDpi()
    Protected.i Ret
    ; "Current dpi value: " + Str(GetCurrentDpi()/1024)
    CompilerSelect #PB_Compiler_OS
      CompilerCase #PB_OS_Linux
        Protected gVal.GValue
        
        g_value_init_(@gval, #G_TYPE_INT)
        g_object_get_property(gtk_settings_get_default_(), "gtk-xft-dpi", @gval)
        Ret = g_value_get_int_(@gval)
        g_value_unset_(@gval)
    CompilerEndSelect
    
    ProcedureReturn Ret
  EndProcedure

  Procedure Arrow(X,Y, Size, Direction, Color, Thickness = 1, Length = 1)
    Protected I
    
    If Length=0
      Thickness = - 1
    EndIf
    Length = (Size+2)/2
    
    
    If Direction = 1 ; top
      If Thickness > 0 : x-1 : y+2
        Size / 2
        For i = 0 To Size 
          LineXY((X+1+i)+Size,(Y+i-1)-(Thickness),(X+1+i)+Size,(Y+i-1)+(Thickness),Color)         ; Левая линия
          LineXY(((X+1+(Size))-i),(Y+i-1)-(Thickness),((X+1+(Size))-i),(Y+i-1)+(Thickness),Color) ; правая линия
        Next
      Else : x-1 : y-1
        For i = 1 To Length 
          If Thickness =- 1
            LineXY(x+i, (Size+y), x+Length, y, Color)
            LineXY(x+Length*2-i, (Size+y), x+Length, y, Color)
          Else
            LineXY(x+i, (Size+y)-i/2, x+Length, y, Color)
            LineXY(x+Length*2-i, (Size+y)-i/2, x+Length, y, Color)
          EndIf
        Next 
        i = Bool(Thickness =- 1) 
        LineXY(x, (Size+y)+Bool(i=0), x+Length, y+1, Color) 
        LineXY(x+Length*2, (Size+y)+Bool(i=0), x+Length, y+1, Color) ; bug
      EndIf
    ElseIf Direction = 3 ; bottom
      If Thickness > 0 : x-1 : y+2
        Size / 2
        For i = 0 To Size
          LineXY((X+1+i),(Y+i)-(Thickness),(X+1+i),(Y+i)+(Thickness),Color) ; Левая линия
          LineXY(((X+1+(Size*2))-i),(Y+i)-(Thickness),((X+1+(Size*2))-i),(Y+i)+(Thickness),Color) ; правая линия
        Next
      Else : x-1 : y+1
        For i = 0 To Length 
          If Thickness =- 1
            LineXY(x+i, y, x+Length, (Size+y), Color)
            LineXY(x+Length*2-i, y, x+Length, (Size+y), Color)
          Else
            LineXY(x+i, y+i/2-Bool(i=0), x+Length, (Size+y), Color)
            LineXY(x+Length*2-i, y+i/2-Bool(i=0), x+Length, (Size+y), Color)
          EndIf
        Next
      EndIf
    ElseIf Direction = 0 ; в лево
      If Thickness > 0 : y-1
        Size / 2
        For i = 0 To Size 
          ; в лево
          LineXY(((X+1)+i)-(Thickness),(((Y+1)+(Size))-i),((X+1)+i)+(Thickness),(((Y+1)+(Size))-i),Color) ; правая линия
          LineXY(((X+1)+i)-(Thickness),((Y+1)+i)+Size,((X+1)+i)+(Thickness),((Y+1)+i)+Size,Color)         ; Левая линия
        Next  
      Else : x-1 : y-1
        For i = 1 To Length
          If Thickness =- 1
            LineXY((Size+x), y+i, x, y+Length, Color)
            LineXY((Size+x), y+Length*2-i, x, y+Length, Color)
          Else
            LineXY((Size+x)-i/2, y+i, x, y+Length, Color)
            LineXY((Size+x)-i/2, y+Length*2-i, x, y+Length, Color)
          EndIf
        Next 
        i = Bool(Thickness =- 1) 
        LineXY((Size+x)+Bool(i=0), y, x+1, y+Length, Color) 
        LineXY((Size+x)+Bool(i=0), y+Length*2, x+1, y+Length, Color)
      EndIf
    ElseIf Direction = 2 ; в право
      If Thickness > 0 : y-1
        Size / 2
        For i = 0 To Size 
          ; в право
          LineXY(((X+2)+i)-(Thickness),((Y+1)+i),((X+2)+i)+(Thickness),((Y+1)+i),Color) ; Левая линия
          LineXY(((X+2)+i)-(Thickness),(((Y+1)+(Size*2))-i),((X+2)+i)+(Thickness),(((Y+1)+(Size*2))-i),Color) ; правая линия
        Next
      Else : y-1 : x+1
        For i = 0 To Length 
          If Thickness =- 1
            LineXY(x, y+i, Size+x, y+Length, Color)
            LineXY(x, y+Length*2-i, Size+x, y+Length, Color)
          Else
            LineXY(x+i/2-Bool(i=0), y+i, Size+x, y+Length, Color)
            LineXY(x+i/2-Bool(i=0), y+Length*2-i, Size+x, y+Length, Color)
          EndIf
        Next
      EndIf
    EndIf
    
  EndProcedure
  
  Procedure.i GridSpacing(Value.i, Grid.i, Max.i=$7FFFFFFF)
    ;Value = (Bool(Grid) * (Round((Value/Grid), #PB_Round_Nearest) * Grid) + Bool(Not Grid) * Value)
    Value = (Round((Value/((Grid) + Bool(Not (Grid)))), #PB_Round_Nearest) * (Grid))
    If Value>Max : Value=Max : EndIf
    
    ProcedureReturn Value
  EndProcedure
  
  Procedure.s Font_GetNameFromGadgetID(GadgetID)
    ; http://www.chabba.de/
    Protected Name.s
    
    CompilerSelect #PB_Compiler_OS
      CompilerCase #PB_OS_Linux
        Protected Description.i, Family.i
        
        Description = pango_context_get_font_description(gtk_widget_get_pango_context_(GadgetID))
        Family = pango_font_description_get_family(Description)
        
        If Family
          Name = PeekS(Family, -1, #PB_UTF8)
        EndIf
    CompilerEndSelect
    
    ProcedureReturn Name
  EndProcedure
  
  Procedure.i Font_IsMonospace(FontName.s)
    Protected IsMonospace = #False
    
    CompilerSelect #PB_Compiler_OS
      CompilerCase #PB_OS_Linux
        Protected   PangoContext = gdk_pango_context_get_()
        Protected.i PangoFamilies, PangoFamily, pFamilyName
        Protected.i pPangoFamily
        Protected.i I, nFamilies
        
        pango_context_list_families(PangoContext, @PangoFamilies, @nFamilies)
        pPangoFamily= PangoFamilies
        For I= 1 To nFamilies
          PangoFamily= PeekI(pPangoFamily);                    not sure about 'long', but yet no error
          If PangoFamily
            pFamilyName= pango_font_family_get_name(PangoFamily)
            If pFamilyName
              If PeekS(pFamilyName, -1, #PB_UTF8) = FontName;  compare names
                IsMonospace= pango_font_family_is_monospace(PangoFamily)
                Break
              EndIf
            EndIf
          EndIf
          pPangoFamily+ SizeOf(PangoFamily)
        Next I
        g_free_(PangoFamilies)
    CompilerEndSelect
    
    ProcedureReturn IsMonospace
  EndProcedure


EndModule 

UseModule Procedures
; IDE Options = PureBasic 5.62 (MacOS X - x64)
; Folding = f+f--
; EnableXP