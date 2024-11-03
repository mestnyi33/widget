; https://www.purebasic.fr/english/viewtopic.php?t=82338
Prototype TObjDrawFunc(*Obj)

Enumeration EObj2D
  #Obj2D_none
  #Obj2D_Line
  #Obj2D_Rect
  #Obj2D_Circle
EndEnumeration

EnumerationBinary EObj3DFlags
  #Obj_Flag_Hidden
  #Obj_Flag_Locked 
EndEnumeration

Structure TObjBase
  *This                     ; Pointer to itself; for plausiblity checks
  *Draw.TObjDrawFunc        ; Function to Draw
  ObjType.l                 ; Object-Type     
  ObjSubType.l              ; Object-SubType
  ObjFlags.l                ; Flags
  GroupID.l                 ; if the Object is grouped with others, the Group-ID
  LayerID.l                 ; Drawing layer ID
EndStructure

Structure TLine2D Extends TObjBase
  X1.d
  Y1.d
  X2.d
  Y2.d
EndStructure

Structure TRect2D Extends TObjBase
  X.d
  Y.d
  W.d
  H.d
EndStructure

Structure TCircle2D Extends TObjBase
  X.d
  Y.d
  R.d
EndStructure

NewList ObjList.i()

Procedure Obj_Draw_Line(*Obj.TLine2D)
  ; Code!
  Debug "Line"
EndProcedure

Procedure Obj_Draw_Rect(*Obj.TRect2D)
  ; Code!
  Debug "Rect"
EndProcedure

Procedure Obj_Draw_Circle(*Obj.TCircle2D)
  ; Code!
  Debug "Circle"
EndProcedure

Procedure.i Obj2D_NEW(ObjType = #Obj2D_Line)
  Protected *Func 
  Protected *This.TObjBase
  
  Select ObjType
      
    Case #Obj2D_Line
      *Func = @Obj_Draw_Line()
      *This = AllocateStructure(TLine2D)  
      ;       If *This 
      ;         *This\This = *This
      ;         *This\ObjType = ObjType
      ;         *This\Draw = @Obj_Draw_Line()
      ;       EndIf
      
    Case #Obj2D_Rect
      *Func = @Obj_Draw_Rect()
      *This = AllocateStructure(TRect2D)
      ;       If *This 
      ;         *This\This = *This
      ;         *This\ObjType = ObjType
      ;         *This\Draw = @Obj_Draw_Rect()
      ;       EndIf
      
    Case #Obj2D_Circle
      ;*Func = @Obj_Draw_Circle()
      *This = AllocateStructure(TCircle2D)  
      ;       If *This 
      ;         *This\This = *This
      ;         *This\ObjType = ObjType
      ;         *This\Draw = @Obj_Draw_Circle()
      ;       EndIf
      
  EndSelect
  
  If *This 
    *This\This = *This
    *This\Draw = *Func
    *This\ObjType = ObjType
  EndIf
  
  ProcedureReturn *This
EndProcedure

Procedure Obj2D_Kill(*Obj.TObjBase)
  
  If *Obj
    If *Obj = *Obj\This   ; if it is a correct 2D Obj, it has a pointer on itself
      FreeStructure(*Obj)
      ProcedureReturn *Obj
    EndIf
  EndIf
  
  MessageRequester("Object 2D Error", "Object to kill is not a valid 2D Object - can't kill it")
  ProcedureReturn 0
EndProcedure

; Demo
; Create a ObjectList by using only the Pointers

Define I
Define *Obj.TObjBase


For I=0 To 10
  
  ; add 10 Lines
  *Obj = Obj2D_NEW(#Obj2D_Line)
  If *Obj
    AddElement(ObjList())
    ObjList() = *Obj
  EndIf
  
  ; add 10 Circles
  *Obj = Obj2D_NEW(#Obj2D_Circle)
  If *Obj
    AddElement(ObjList())
    ObjList() = *Obj
  EndIf
  
  ; add 10 Rect
  *Obj = Obj2D_NEW(#Obj2D_Rect)
  If *Obj
    AddElement(ObjList())
    ObjList() = *Obj
  EndIf
  
Next

; How to draw
ForEach ObjList()
  *Obj = ObjList()
  
  If Not (*Obj\ObjFlags & #Obj_Flag_Hidden)
    ; now dereferencing the ObjectType
    If *obj\Draw
      *obj\Draw(*Obj)
    EndIf
    ;     Select *Obj\ObjType
    ;       Case #Obj2D_Line
    ;         Obj_Draw_Line(*Obj)
    ;         
    ;       Case #Obj2D_Rect
    ;         Obj_Draw_Rect(*Obj)
    ;         
    ;       Case #Obj2D_Circle
    ;         Obj_Draw_Circle(*Obj)
    ;         
    ;     EndSelect 
    ;     
  EndIf
  
Next

ForEach ObjList()
  Obj2D_Kill(ObjList())
Next
ClearList(ObjList())

; IDE Options = PureBasic 6.00 LTS (MacOS X - x64)
; Folding = ----
; EnableXP