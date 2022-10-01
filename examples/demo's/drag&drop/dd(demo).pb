;XIncludeFile "../../../widgets.pbi" 
XIncludeFile "../../../widget-events.pbi" 

EnableExplicit
Uselib( Widget )

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

Procedure Events( )
  Protected EventWidget.i = EventWidget( ),
            EventType.i = WidgetEventType( );,
                                            ;EventItem.i = this( )\item, 
                                            ;EventData.i = this( )\data
  
  Protected i, Text$, Files$, Count
  
  ; DragStart event on the source s, initiate a drag & drop
  ;
  Select EventType
    Case #PB_EventType_DragStart
      Debug  "Drag - " + EventWidget
      
      Select EventWidget
          
        Case SourceText
          Text$ = GetItemText( SourceText, GetState( SourceText ) )
          DragText( Text$ )
          
        Case SourceImage
          DragImage( #ImageSource )
          
        Case SourceFiles
          Files$ = ""       
          For i = 0 To CountItems( SourceFiles )-1
            If GetItemState( SourceFiles, i ) & #PB_Explorer_Selected
              ;; i = GetState( SourceFiles )
              Files$ + GetText( SourceFiles ) + GetItemText( SourceFiles, i ) ; + Chr( 10 )
            EndIf
          Next i 
          
          If Files$ <> ""
            DragFiles( Files$ )
          EndIf
          
          ; "Private" Drags only work within the program, everything else
          ; also works with other applications ( Explorer, Word, etc )
          ;
        Case SourcePrivate
          If GetState( SourcePrivate ) = 0
            DragPrivate( 1 )
          Else
            DragPrivate( 2 )
          EndIf
          
      EndSelect
      
      ; Drop event on the target gadgets, receive the EventDrop data
      ;
    Case #PB_EventType_Drop
      Debug  "Drop - " + EventWidget
      ; clearitems(EventWidget)
      
      Select EventWidget
          
        Case TargetText
          ;;Debug "EventDropText - "+ EventDropText( )
          If EnteredItem( )
            AddItem( TargetText, EnteredItem( )\index, EventDropText( ) )
          Else
            AddItem( TargetText, - 1, EventDropText( ) )
          EndIf
          
        Case TargetImage
          If EventDropImage( #ImageTarget )
            If StartDrawing( ImageOutput( #ImageTarget ) )
              DrawingFont( font )
              
              Box( 5,5,OutputWidth(),30, $FFFFFF)
              DrawText( 5, 5, "EventDrop image", $000000, $FFFFFF )        
              
              StopDrawing( )
            EndIf  
            
            SetState( TargetImage, ( #ImageTarget ) )
          EndIf
          
        Case TargetFiles
          Files$ = EventDropFiles( )
          Count  = CountString( Files$, Chr( 10 ) ) + 1
          
          For i = 1 To Count
            AddItem( TargetFiles, -1, StringField( Files$, i, Chr( 10 ) ) )
          Next i
          
        Case TargetPrivate1
          AddItem( TargetPrivate1, -1, "Private type 1 EventDrop" )
          
        Case TargetPrivate2
          AddItem( TargetPrivate2, -1, "Private type 2 EventDrop" )
          
      EndSelect
      
      ;       If EventWidget = DD_DropPrivate( )
      ;         AddItem( DD_DropPrivate( ), -1, "Private type 2 EventDrop" )
      ;       EndIf
      
  EndSelect
  
EndProcedure

If Open( #PB_Any, 0, 0, 760, 310, "Drag & Drop", #PB_Window_SystemMenu|#PB_Window_ScreenCentered )   
  ;Bind(, #PB_Default )
  ; Create and fill the source s
  ;
  SourceText = ListIcon( 10, 10, 140, 140, "Drag Text here", 130 )   
  SourceImage = Image( 160, 10, 140, 140, ( #ImageSource ), #PB_Image_Border ) 
  SourceFiles = ExplorerList( 310, 10, 290, 140, GetHomeDirectory( ), #PB_Explorer_MultiSelect )
  SourcePrivate = ListIcon( 610, 10, 140, 140, "Drag private stuff here", 260 )
  
  ;
  ;
  SetCursor( SourceText, #PB_Cursor_Hand )
  SetCursor( SourceImage, #PB_Cursor_Hand )
  SetCursor( SourceFiles, #PB_Cursor_Hand )
  SetCursor( SourcePrivate, #PB_Cursor_Hand )
  
  ;
  AddItem( SourceText, -1, "hello world" )
  AddItem( SourceText, -1, "The quick brown fox jumped over the lazy dog" )
  AddItem( SourceText, -1, "abcdefg" )
  AddItem( SourceText, -1, "123456789" )
  AddItem( SourceText, -1, "123456789" )
  AddItem( SourceText, -1, "123456789" )
  AddItem( SourceText, -1, "123456789" )
  AddItem( SourceText, -1, "123456789" )
  AddItem( SourceText, -1, "123456789" )
  AddItem( SourceText, -1, "123456789" )
  AddItem( SourceText, -1, "123456789" )
  
  AddItem( SourcePrivate, -1, "Private type 1" )
  AddItem( SourcePrivate, -1, "Private type 2" )
  
  ; Create the target s
  ;
  TargetText = ListIcon( 10, 160, 140, 140, "Drop Text here", 130 )
  TargetImage = Image( 160, 160, 140, 140, ( #ImageTarget ), #PB_Image_Border ) 
  TargetFiles = ListIcon( 310, 160, 140, 140, "Drop Files here", 130 )
  TargetPrivate1 = ListIcon( 460, 160, 140, 140, "Drop Private Type 1 here", 130 )
  TargetPrivate2 = ListIcon( 610, 160, 140, 140, "Drop Private Type 2 here", 130 )
  
  ; Now enable the dropping on the target s
  ;
  EnableDrop( TargetText,     #PB_Drop_Text,    #PB_Drag_Copy )
  EnableDrop( TargetImage,    #PB_Drop_Image,   #PB_Drag_Copy )
  EnableDrop( TargetFiles,    #PB_Drop_Files,   #PB_Drag_Copy )
  EnableDrop( TargetPrivate1, #PB_Drop_Private, #PB_Drag_Copy, 1 )
  EnableDrop( TargetPrivate2, #PB_Drop_Private, #PB_Drag_Copy, 2 )
  
  ; Bind( -1, @Events( ) )
  ;
  Bind( SourceImage, @Events( ), #PB_EventType_DragStart )
  Bind( TargetImage, @Events( ), #PB_EventType_Drop )
  
  Bind( SourceText, @Events( ), #PB_EventType_DragStart )
  Bind( TargetText, @Events( ), #PB_EventType_Drop )
  
  Bind( SourcePrivate, @Events( ), #PB_EventType_DragStart )
  Bind( TargetPrivate1, @Events( ), #PB_EventType_Drop )
  Bind( TargetPrivate2, @Events( ), #PB_EventType_Drop )
  
  ; main loop
  ;
  WaitClose( )
  ;   ReDraw( Root( ) )
  ;   
  ;   Repeat
  ;     Event = WaitWindowEvent( )
  ;   Until Event = #PB_Event_CloseWindow
EndIf

End
; IDE Options = PureBasic 5.73 LTS (MacOS X - x64)
; Folding = ---
; EnableXP