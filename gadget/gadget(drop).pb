;XIncludeFile "gadgets.pbi" : UseModule gadget

CompilerIf Not Defined( PB_EventType_Drop, #PB_Constant )
  #PB_EventType_Drop = #PB_EventType_FirstCustomValue 
CompilerEndIf


#Window = 0

Enumeration   1 ; Images
  #ImageSource
  #ImageTarget
EndEnumeration

Global SourceText,
       SourceImage,
       SourceFiles,
       SourcePrivate,
       TargetText,
       TargetImage,
       TargetFiles,
       TargetPrivate1,
       TargetPrivate2

Global i, Event, font = LoadFont( 0, "Aria", 13 )

Procedure Events( )
  Protected EventGadget.i = EventGadget( ),
            EventType.i = EventType( ),
            ;EventItem.i = GetGadgetState( EventGadget ), 
            EventData.i = EventData( )
  
  Protected i, Text$, Files$, Count
  
  ; DragStart event on the source s, initiate a drag & drop
  ;
  Select EventType
    Case #PB_EventType_DragStart
      Debug  "Drag - " + EventGadget
      
      Select EventGadget
          
        Case SourceText
          Text$ = GetGadgetItemText( SourceText, GetGadgetState( SourceText ) )
          DragText( Text$ )
          
        Case SourceImage
          DragImage( ImageID( #ImageSource ) )
          
        Case SourceFiles
          Files$ = ""       
          For i = 0 To CountGadgetItems( SourceFiles )-1
            If GetGadgetItemState( SourceFiles, i ) & #PB_Explorer_Selected
              ;; i = GetState( SourceFiles )
              Files$ + GetGadgetText( SourceFiles ) + GetGadgetItemText( SourceFiles, i ) ; + Chr( 10 )
            EndIf
          Next i 
          
          If Files$ <> ""
            DragFiles( Files$ )
          EndIf
          
          ; "Private" Drags only work within the program, everything else
          ; also works with other applications ( Explorer, Word, etc )
          ;
        Case SourcePrivate
          If GetGadgetState( SourcePrivate ) = 0
            DragPrivate( 1 )
          Else
            DragPrivate( 2 )
          EndIf
          
      EndSelect
      
      ; Drop event on the target gadgets, receive the EventDrop data
      ;
    Case #PB_EventType_Drop
      Debug  "Drop - " + EventGadget
      
      Select EventGadget
          
        Case TargetText
          ;;Debug "EventDropText - "+ EventDropText( )
          If GetGadgetState( TargetText ) >= 0
            AddGadgetItem( TargetText, GetGadgetState( TargetText ), EventDropText( ) )
          Else
            AddGadgetItem( TargetText, - 1, EventDropText( ) )
          EndIf
          
        Case TargetImage
          If EventDropImage( #ImageTarget )
            If StartDrawing( ImageOutput( #ImageTarget ) )
              DrawingFont( font )
              
              Box( 5,5,OutputWidth(),30, $FFFFFF)
              DrawText( 5, 5, "EventDrop image", $000000, $FFFFFF )        
              
              StopDrawing( )
            EndIf  
            
            SetGadgetState( TargetImage, ImageID( #ImageTarget ) )
          EndIf
          
        Case TargetFiles
          Files$ = EventDropFiles( )
          Count  = CountString( Files$, Chr( 10 ) ) + 1
          
          For i = 1 To Count
            AddGadgetItem( TargetFiles, -1, StringField( Files$, i, Chr( 10 ) ) )
          Next i
          
        Case TargetPrivate1
          AddGadgetItem( TargetPrivate1, -1, "Private type 1 EventDrop" )
          
        Case TargetPrivate2
          AddGadgetItem( TargetPrivate2, -1, "Private type 2 EventDrop" )
          
      EndSelect
      
  EndSelect
  
EndProcedure

If OpenWindow( #Window, 0, 0, 760, 310, "Drag & Drop", #PB_Window_SystemMenu|#PB_Window_ScreenCentered )       
  ;
  ; Create some images for the image demonstration
  ; 
  CreateImage( #ImageSource, 136, 136 )
  If StartDrawing( ImageOutput( #ImageSource ) )
    DrawingFont( font )
    
    Box( 0, 0, 136, 136, $FFFFFF )
    DrawText( 5, 5, "Drag this image", $000000, $FFFFFF )        
    For i = 45 To 1 Step -1
      Circle( 70, 80, i, Random( $FFFFFF ) )
    Next i        
    
    StopDrawing( )
  EndIf  
  
  CreateImage( #ImageTarget, 136, 136 )
  If StartDrawing( ImageOutput( #ImageTarget ) )
    DrawingFont( font )
    
    Box( 0, 0, 136, 136, $FFFFFF )
    DrawText( 5, 5, "Drop images here", $000000, $FFFFFF )
    StopDrawing( )
  EndIf  
  
  ; Create and fill the source s
  ;
  SourceText = ListIconGadget(#PB_Any, 10, 10, 140, 140, "Drag Text here", 130 )   
  SourceImage = ImageGadget(#PB_Any, 160, 10, 140, 140, ImageID( #ImageSource ), #PB_Image_Border ) 
  SourceFiles = ExplorerListGadget(#PB_Any, 310, 10, 290, 140, GetHomeDirectory( ), #PB_Explorer_MultiSelect )
  SourcePrivate = ListIconGadget(#PB_Any, 610, 10, 140, 140, "Drag private stuff here", 260 )
  
  AddGadgetItem( SourceText, -1, "hello world" )
  AddGadgetItem( SourceText, -1, "The quick brown fox jumped over the lazy dog" )
  AddGadgetItem( SourceText, -1, "abcdefg" )
  AddGadgetItem( SourceText, -1, "123456789" )
  AddGadgetItem( SourceText, -1, "123456789" )
  AddGadgetItem( SourceText, -1, "123456789" )
  AddGadgetItem( SourceText, -1, "123456789" )
  AddGadgetItem( SourceText, -1, "123456789" )
  AddGadgetItem( SourceText, -1, "123456789" )
  AddGadgetItem( SourceText, -1, "123456789" )
  AddGadgetItem( SourceText, -1, "123456789" )
  
  AddGadgetItem( SourcePrivate, -1, "Private type 1" )
  AddGadgetItem( SourcePrivate, -1, "Private type 2" )
  
  ; Create the target s
  ;
  TargetText = ListIconGadget(#PB_Any, 10, 160, 140, 140, "Drop Text here", 130 )
  TargetImage = ImageGadget(#PB_Any, 160, 160, 140, 140, ImageID( #ImageTarget ), #PB_Image_Border ) 
  TargetFiles = ListIconGadget(#PB_Any, 310, 160, 140, 140, "Drop Files here", 130 )
  TargetPrivate1 = ListIconGadget(#PB_Any, 460, 160, 140, 140, "Drop Private Type 1 here", 130 )
  TargetPrivate2 = ListIconGadget(#PB_Any, 610, 160, 140, 140, "Drop Private Type 2 here", 130 )
  
;   AddGadgetItem( TargetText, -1, "hello world" )
;   AddGadgetItem( TargetText, -1, "The quick brown fox jumped over the lazy dog" )
;   AddGadgetItem( TargetText, -1, "abcdefg" )
;   AddGadgetItem( TargetText, -1, "123456789" )
;   AddGadgetItem( TargetText, -1, "123456789" )
;   AddGadgetItem( TargetText, -1, "123456789" )
;   AddGadgetItem( TargetText, -1, "123456789" )
;   AddGadgetItem( TargetText, -1, "123456789" )
;   AddGadgetItem( TargetText, -1, "123456789" )
;   AddGadgetItem( TargetText, -1, "123456789" )
;   AddGadgetItem( TargetText, -1, "123456789" )
  
  ; Now enable the dropping on the target s
  ;
  EnableGadgetDrop( TargetText,     #PB_Drop_Text,    #PB_Drag_Copy )
  EnableGadgetDrop( TargetImage,    #PB_Drop_Image,   #PB_Drag_Copy )
  EnableGadgetDrop( TargetFiles,    #PB_Drop_Files,   #PB_Drag_Copy )
  EnableGadgetDrop( TargetPrivate1, #PB_Drop_Private, #PB_Drag_Copy, 1 )
  EnableGadgetDrop( TargetPrivate2, #PB_Drop_Private, #PB_Drag_Copy, 2 )
  
  
  BindGadgetEvent( SourceImage, @Events( ), #PB_EventType_DragStart )
  BindGadgetEvent( TargetImage, @Events( ), #PB_EventType_Drop )
  
  BindGadgetEvent( SourceText, @Events( ), #PB_EventType_DragStart )
  BindGadgetEvent( TargetText, @Events( ), #PB_EventType_Drop )
  
  BindGadgetEvent( SourcePrivate, @Events( ), #PB_EventType_DragStart )
  BindGadgetEvent( TargetPrivate1, @Events( ), #PB_EventType_Drop )
  BindGadgetEvent( TargetPrivate2, @Events( ), #PB_EventType_Drop )
  
  Repeat
    Event = WaitWindowEvent( )
    
    If event = #PB_Event_GadgetDrop
      PostEvent( #PB_Event_Gadget, EventWindow(), EventGadget(), #PB_EventType_Drop, EventData( ) )
      
    EndIf
  Until Event = #PB_Event_CloseWindow
EndIf

End
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 199
; FirstLine = 130
; Folding = --9
; EnableXP