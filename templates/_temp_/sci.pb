Define Text.s
  Procedure.s get_text(m.s=#LF$)
    Protected Text.s = "This is a long line." + m.s +
                       "Who should show." + 
                       m.s +
                       m.s +
                       m.s +
                       m.s +
                       "I have to write the text in the box or not." + 
                       m.s +
                       m.s +
                       m.s +
                       m.s +
                       "The string must be very long." + m.s +
                       "Otherwise it will not work." ;+ m.s; +
    
    ProcedureReturn Text
  EndProcedure
  
  Enumeration
    #SYNTAX_Text
    #SYNTAX_Keyword  
    #SYNTAX_Comment
    #SYNTAX_Constant
    #SYNTAX_String
    #SYNTAX_Function
    #SYNTAX_Asm
    #SYNTAX_Operator
    #SYNTAX_Structure
    #SYNTAX_Number
    #SYNTAX_Pointer
    #SYNTAX_Separator
    #SYNTAX_Label  
    #SYNTAX_Module
  EndEnumeration
  
  Procedure settext(gadget, Text$)
     ; Enable line numbers
      ScintillaSendMessage(gadget, #SCI_SETMARGINTYPEN, #True, #SC_MARGIN_NUMBER)
        
      ; Output set to red color
      ScintillaSendMessage(gadget, #SCI_STYLESETFORE, 0, RGB(255, 0, 0))
      
      
;       ; Set the initial text to the ScintillaGadget
;       Protected *Text=UTF8("This is a simple ScintillaGadget with text...")
;       ScintillaSendMessage(gadget, #SCI_SETTEXT, 0, *Text)
;       FreeMemory(*Text) ; The buffer made by UTF8() has to be freed, to avoid memory leak
      
      ; Adding a second line of text with linebreak before
      *Text=UTF8(Text$)
      ScintillaSendMessage(gadget, #SCI_APPENDTEXT, Len(Text$), *Text)
      FreeMemory(*Text)
      
        ; Set caret line colour
            ScintillaSendMessage(gadget, #SCI_SETCARETLINEBACK, $eeeeff) 
            ScintillaSendMessage(gadget, #SCI_SETCARETLINEVISIBLE, #True)
            
            
            ScintillaSendMessage(gadget, #SCI_SETPRINTWRAPMODE, #True)
            
      
      ScintillaSendMessage(Gadget, #SCI_STYLESETSIZE, #STYLE_DEFAULT, 10) 
        ScintillaSendMessage(Gadget, #SCI_STYLESETBACK, #SCI_STYLESETFORE, 0)
        ScintillaSendMessage(Gadget, #SCI_STYLESETBACK, #STYLE_DEFAULT, $DFFFFF)
        ScintillaSendMessage(Gadget, #SCI_STYLECLEARALL)
        
        ; Set individual colors
        ScintillaSendMessage(Gadget, #SCI_STYLESETFORE, #SYNTAX_Text, 0)
        ScintillaSendMessage(Gadget, #SCI_STYLESETFORE, #SYNTAX_Keyword, $666600)
        ScintillaSendMessage(Gadget, #SCI_STYLESETFORE, #SYNTAX_Comment, $AAAA00)
        ScintillaSendMessage(Gadget, #SCI_STYLESETFORE, #SYNTAX_Constant, $724B92)
        ScintillaSendMessage(Gadget, #SCI_STYLESETFORE, #SYNTAX_String, $FF8000)
        ScintillaSendMessage(Gadget, #SCI_STYLESETFORE, #SYNTAX_Function, $666600)
        ScintillaSendMessage(Gadget, #SCI_STYLESETFORE, #SYNTAX_Asm, $DFFFFF)
        ScintillaSendMessage(Gadget, #SCI_STYLESETFORE, #SYNTAX_Operator, $8000FF)
        ScintillaSendMessage(Gadget, #SCI_STYLESETFORE, #SYNTAX_Structure, $0080FF)
        ScintillaSendMessage(Gadget, #SCI_STYLESETFORE, #SYNTAX_Number, $8080FF)
        ScintillaSendMessage(Gadget, #SCI_STYLESETFORE, #SYNTAX_Pointer, $FF0080)
        ScintillaSendMessage(Gadget, #SCI_STYLESETFORE, #SYNTAX_Separator, $FF0000)
        ScintillaSendMessage(Gadget, #SCI_STYLESETFORE, #SYNTAX_Label, $C864FF)
        ScintillaSendMessage(Gadget, #SCI_STYLESETFORE, #SYNTAX_Module, $433740)
        ScintillaSendMessage(Gadget, #SCI_STYLESETBOLD, #SYNTAX_Keyword, #True)
        
        ;                     ScintillaSendMessage(Gadget, #SCI_SETMARGINTYPEN, 0, #SC_MARGIN_NUMBER) ; Добавляем поле автонумерации
        ;                     ScintillaSendMessage(Gadget, #SCI_SETMARGINWIDTHN, 0, 60 )     ; AntoNumWidth Ширина поля автонумерации
        ;                     ScintillaSendMessage(Gadget, #SCI_STYLESETFORE,#STYLE_LINENUMBER,$6D8E91) ; ColorFontNumber Цвет цифр автонумерации
        ;                     ScintillaSendMessage(Gadget, #SCI_STYLESETBACK,#STYLE_LINENUMBER,$CFDADB) ; ColorBackNumber Цвет фона области автонумерации
        
        
        
        
        
        
        
        
        
        
        ScintillaSendMessage(Gadget,#SCI_STARTSTYLING,5,$FF);x=début de la coloration y=??
  ScintillaSendMessage(Gadget,#SCI_SETSTYLING,9,1) ;x=nombre de caractère y : numéro de couleur dans le dico
;   ScintillaSendMessage(Gadget,#SCI_STARTSTYLING,29,$FF)
;   ScintillaSendMessage(Gadget,#SCI_SETSTYLING,7,2)
;   ScintillaSendMessage(Gadget,#SCI_STARTSTYLING,40,$FF)
;   ScintillaSendMessage(Gadget,#SCI_SETSTYLING,213,4)
;   ScintillaSendMessage(Gadget,#SCI_STARTSTYLING,266,$FF)
;   ScintillaSendMessage(Gadget,#SCI_SETSTYLING,7,4)
; 
; ScintillaSendMessage(Gadget,#SCI_SETMARGINSENSITIVEN,1,#True); active le folding
; ScintillaSendMessage(Gadget,#SCI_SETMARGINMASKN,1,~#SC_MASK_FOLDERS);masque la couleur différente du folding
; ScintillaSendMessage(Gadget,#SCI_MARKERDEFINE,0,#SC_MARK_ARROW) ; définit la fleche pour le droite (replié)
; ScintillaSendMessage(Gadget,#SCI_MARKERDEFINE,1,#SC_MARK_ARROWDOWN) ; définti la fleche pour le bas (déplié)
; 
; ScintillaSendMessage(Gadget,#SCI_SETFOLDFLAGS,16,0)
; ScintillaSendMessage(Gadget,#SCI_SETFOLDLEVEL,0,#SC_FOLDLEVELHEADERFLAG)
; ScintillaSendMessage(Gadget,#SCI_MARKERADD,0,0) ; ajoute le petit triangle : y0 triangle pointé vers la gauche 1vers le bas
; ScintillaSendMessage(Gadget,#SCI_HIDELINES,1,6); Cacher des lignes : ligne de départ, ombre de lignes
; ScintillaSendMessage(Gadget,#SCI_SETFOLDEXPANDED,1,1); x ? y fait une ligne endessous du folder

  EndProcedure
  
  
  If OpenWindow(0, 0, 0, 616, 316, "ScintillaGadget", #PB_Window_SystemMenu | #PB_Window_ScreenCentered)
    
    If InitScintilla()
      ScintillaGadget(11, 10, 10, 320, 70, 0)
      ScintillaGadget(12, 10, 10, 320, 70, 0)
    EndIf
    
    
    EditorGadget(1, 0,0,0,0)
    EditorGadget(2, 0,0,0,0, #PB_Editor_WordWrap)
    
;     Editor::Gadget(11, 0,0,0,0)
;     Editor::Gadget(12, 0,0,0,0, #__editor_wordwrap)
    
    SetGadgetText(1, get_text(#LF$))
    SetGadgetText(2, get_text(""))
    
    SetText((11), get_text(#LF$))
    SetText((12), get_text(""))
    
    SplitterGadget(3, 0,0,0,0, 1,11 )
    SplitterGadget(13, 0,0,0,0, 2,12 )
    
    SplitterGadget(5, 8,8,600, 300, 13,3, #PB_Splitter_Vertical )
    
    Repeat : Until WaitWindowEvent() = #PB_Event_CloseWindow
  EndIf
; IDE Options = PureBasic 5.71 LTS (MacOS X - x64)
; Folding = -
; EnableXP