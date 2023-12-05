;-
CompilerIf #PB_Compiler_OS = #PB_OS_Windows
   Procedure winCloseHandler(WindowID,message,wParam,lParam)
      Protected Text$
      Protected Result = #PB_ProcessPureBasicEvents
      
      Select message
         Case #WM_CLOSE : Text$ = "Close"
         Case #WM_DESTROY : Text$ = "Destroy"
         Case #WM_QUIT : Text$ = "Quit"
      EndSelect
      Debug "winCloseHandler "+message +" "+ Text$+" "+Str(wParam)+" "+Str(lParam)
      
      ProcedureReturn Result
   EndProcedure
   
CompilerElseIf #PB_Compiler_OS = #PB_OS_Linux
   ProcedureC winCloseHandler(*Widget.GtkWidget, *Event.GdkEventAny, UserData.I)
      Debug "winCloseHandler"
      gtk_main_quit_( )
   EndProcedure
   
CompilerElseIf #PB_Compiler_OS = #PB_OS_MacOS
   ProcedureC winCloseHandler(obj.i, sel.i, win.i) 
      Debug "winShouldClose"
      CocoaMessage(0, CocoaMessage(0, 0, "NSApplication sharedApplication"), "stop:", win)
      ProcedureReturn #YES
   EndProcedure
   
CompilerEndIf

Procedure WaitEvents( window )
   Protected win = WindowID( window )
   
   CompilerIf #PB_Compiler_OS = #PB_OS_MacOS
      ;\\
      Protected NSObjectClass = objc_getClass_("NSObject")
      Protected myWindowDelegateClass = objc_allocateClassPair_(NSObjectClass, "myWindowDelegate", 0)
      class_addProtocol_(myWindowDelegateClass, objc_getProtocol_("NSWindowDelegate"))
      class_addMethod_(myWindowDelegateClass, sel_registerName_("windowShouldClose:"), @winCloseHandler(), "c@:@")
      Protected myWindowDelegate = class_createInstance_(myWindowDelegateClass, 0)
      CocoaMessage(0, win, "setDelegate:", myWindowDelegate)
      
      ;\\
      CocoaMessage(0, CocoaMessage(0, 0, "NSApplication sharedApplication"), "run")
      
   CompilerElseIf #PB_Compiler_OS = #PB_OS_Linux
      ;\\ https://www.purebasic.fr/english/viewtopic.php?p=570200&hilit=move+items#p570200
      g_signal_connect_(win, "delete-event", @winCloseHandler( ), 0)
      g_signal_connect_(win, "destroy", @winCloseHandler( ), 0)
      
      ;\\
      gtk_main_( )
      
   CompilerElseIf #PB_Compiler_OS = #PB_OS_Windows
      Protected msg.MSG
      
      SetWindowCallback( @winCloseHandler( ), window )
      
      ; While PeekMessage_(@msg,0,0,0,1)
      While GetMessage_(@msg, #Null, 0, 0 )
         TranslateMessage_(msg) ; - генерирует дополнительное сообщение если произошёл ввод с клавиатуры (клавиша с символом была нажата или отпущена)
         DispatchMessage_(msg)  ; посылает сообщение в функцию WindowProc.
         
         If msg\message = #WM_NCMOUSEMOVE
            Debug "" + #PB_Compiler_Procedure + " " + msg\message + " " + msg\hwnd + " " + msg\lParam + " " + msg\wParam
         EndIf
         
         ;   If msg\wParam = #WM_QUIT
         ;     Debug "#WM_QUIT "
         ;   EndIf
       Wend
       
       
;        ; While GetMessage_(@msg, win, 0, 0 )
;             ; While PeekMessage_(@msg,0,0,0,1) ; функция PeekMessage не ждет, когда предыдущее помещенное в очередь сообщение возвратит значение.
;             While GetMessage_(@msg, #Null, 0, 0 ) ; Функция GetMessage извлекает сообщение из очереди сообщений вызывающего потока и помещает его в заданную структуру.
;                TranslateMessage_(msg) ; - генерирует дополнительное сообщение если произошёл ввод с клавиатуры (клавиша с символом была нажата или отпущена)
;                DispatchMessage_(msg)  ; посылает сообщение в функцию WindowProc.
;                
; ;                ;If msg\message <> #WM_NCMOUSEMOVE
; ;                Debug "" + #PB_Compiler_Procedure + " " + msg\message + " " + msg\hwnd + " " + msg\lParam + " " + msg\wParam
; ;                ; EndIf
; ;                
; ;                If msg\wParam = #WM_QUIT
; ;                  Debug "#WM_QUIT1 "
; ;                EndIf
; ;                If msg\message = #WM_QUIT
; ;                  Debug "#WM_QUIT2 "
; ;                EndIf
;             Wend
      
   CompilerEndIf
EndProcedure

Procedure MessageEvents( )
   Protected *ew = EventGadget( )
   Protected *message = EventWindow( )
   
   Select EventType( )
      Case #PB_EventType_LeftClick
         Select GetGadgetText( *ew )
            Case "No"     : SetWindowData( *message, #PB_MessageRequester_No )     ; no
            Case "Yes"    : SetWindowData( *message, #PB_MessageRequester_Yes )    ; yes
            Case "Cancel" : SetWindowData( *message, #PB_MessageRequester_Cancel ) ; cancel
         EndSelect
         
         
         UnbindGadgetEvent( *ew, @MessageEvents( ), #PB_EventType_LeftClick )
         
;          ;\\ exit main loop
;          CompilerIf #PB_Compiler_OS = #PB_OS_MacOS
;             ;\\ winCloseHandler(obj.i, sel.i, win.i) 
;             winCloseHandler(0,0,0) 
;          CompilerElseIf #PB_Compiler_OS = #PB_OS_Linux
;             ;\\ winCloseHandler(*Widget.GtkWidget, *Event.GdkEventAny, UserData.I)
;             winCloseHandler(0,0,0)
;          CompilerElseIf #PB_Compiler_OS = #PB_OS_Windows
;             ;\\ winCloseHandler(WindowID,message,wParam,lParam)
;             winCloseHandler(0, #WM_DESTROY,0,0)
;          CompilerEndIf
         
         ;\\ exit main loop
              CompilerSelect #PB_Compiler_OS 
                CompilerCase #PB_OS_Windows
                  PostQuitMessage_( 0 )
                CompilerCase #PB_OS_Linux
                  gtk_main_quit_( )
                CompilerCase #PB_OS_MacOS
                  CocoaMessage(0, CocoaMessage(0, 0, "NSApplication sharedApplication"), "stop:", win)
              CompilerEndSelect
              
   EndSelect
   
   ProcedureReturn #PB_Ignore
EndProcedure

;       Procedure MessageCanvasEvents( )
;          EventHandler( #PB_Event_Gadget, EventGadget( ), EventType( ), EventData( ) )
;       EndProcedure
;    

 UseJPEGImageDecoder() 
UseJPEG2000ImageDecoder() 
UsePNGImageDecoder() 
UseTIFFImageDecoder() 
UseTGAImageDecoder() 
UseGIFImageDecoder()
   
Procedure Message( Title.s, Text.s, flag.q, *parent )
   Protected result
   Protected img = - 1, f1 = - 1, f2 = 8, width = 400, height = 120
   Protected bw = 85, bh = 25, iw = height - bh - f1 - f2 * 4 - 2 - 1
   
   Protected x = 100
   Protected y = 100
   
   Protected *message = OpenWindow(#PB_Any, x, y, width, height, Title, #PB_Window_TitleBar|#PB_Window_WindowCentered, *parent)
  
   If Flag & #PB_MessageRequester_Info
     img = - 1;ImageID(CatchImage( #PB_Any, ?img_info, ?end_img_info - ?img_info ))
     
    
;      DataSection
;        img_info: 
;        IncludeBinary #PB_Compiler_Home + "examples/sources/Data/Background.bmp"
;      EndDataSection

      DataSection
         img_info:
         ; size : 1404 bytes
         Data.q $0A1A0A0D474E5089, $524448490D000000, $2800000028000000, $B8FE8C0000000608, $474B62060000006D
         Data.q $A0FF00FF00FF0044, $493105000093A7BD, $5F98CD8558544144, $3B3BBFC71C47144C, $54C0F03D7F7BB707
         Data.q $14DA0D5AD0348C10, $7C1A6360A90B6D6D, $6D03CAADF49898D3, $D1A87D7AD262545F, $B69B5F469AA9349A
         Data.q $680D82AB6C37D269, $A6220B47FA51A890, $DECFEE38E105102A, $053FB87D333B772E, $CCDD3CF850EE114A
         Data.q $0766FDFE767ECCDC, $F476DC569948E258, $5BCA94AD89227ADA, $3C10B9638C15E085, $7A59504C89240017
         Data.q $8055B371E2774802, $2E678FEAA9A17AFC, $06961711C3AC7F58, $EF905DD4CA91A322, $A159B0EAD38F5EA2
         Data.q $4D30000CA9417358, $1A3033484098DD06, $2C671601A343EB08, $EDD3F547A138B820, $DAFB560A82C89ABE
         Data.q $2E1D2C863E5562A8, $3CD50AAB359173CC, $8D8C00262FCE6397, $83FB0DA43FD7D187, $DDAAFF5D74F85C02
         Data.q $B3A477582D666357, $45754E5D9B42C73C, $16732AAEDD894565, $41FBABA3A6B0899B, $3FAB16311F45A424
         Data.q $8FDB82C66F4B707F, $1595D6EF9001DD5F, $69B32B24BD2B2529, $EA0DEEB7E6181FDC, $9D9F369A5BB6326
         Data.q $A94FBDAEC7BBE0B7, $A732EAE5951BF5F4, $5C114204D2DD216D, $6B9C344C651BD9B9, $5F8FDB82CE66FAAA
         Data.q $5F57EDFEF90841DD, $8469F486ECB61D52, $C2634777AE971D35, $2A9E9FF5E072D5DC, $8DE85A9CB3A47758
         Data.q $4DCF559EDB963737, $0D1DD74741182C67, $C9DDD550E5F86C71, $E68DAFB555E65365, $79E522B2BAF36858
         Data.q $B2DAC765C78001C9, $8DAFB573522C2B62, $8F9455C8929B2E4E, $77B1059330B54E5C, $D579F26E672AD4E3
         Data.q $AC8D0E0F2BD2BD5F, $9F9532F8021F1304, $C910838758FEB56E, $816E0DF732515957, $DAAF81036D5F2CA9
         Data.q $C2E305A5E54F66D7, $73EED922E79850D2, $88B9E6F02BB0E0D9, $2241697952FB2AA2, $B51C5D50B8ACB1A3
         Data.q $69322368555B297F, $A654FC089009A54C, $1E34DD1B45EE65EE, $5F9F7579224403B7, $416D440905240B59
         Data.q $244059B47C668BBE, $56F2A644DDF22B00, $1EBC77E473482920, $E3DCB126CD5175A7, $E720A4816B952854
         Data.q $AA1C1F8C97DBB0A8, $3CE0A0A481CA0015, $2829A74C5DCDCD5F, $0F5481799C981CD6, $9356B8BCB2A56E0A
         Data.q $0B4C0AC3821950B0, $6188962AC4914B75, $8326E2692ED8B632, $32112C58C9006044, $ECE858E5B0989D1A
         Data.q $743677B1BE616735, $07BA4027E44A0623, $6C80F60B188E13D1, $829201DC00066B09, $8C96858E8E2EC9A6
         Data.q $805AC633A82068E1, $371FE43AD04336D4, $3E017C48017AE2C5, $292045C9C672091A, $FE17193FA6FF7E78
         Data.q $24BB170DC670F1B1, $228215E7B04759EC, $8381081FD341E657, $105A57F6BD342FFB, $B487FAFAA7631800
         Data.q $02CD8258AB7E1B4C, $7FAFA533BF1272D8, $0B4E95227E4D3348, $C2283FB0F4FD51EA, $448A12D9E3719E9A
         Data.q $A9D39441710FE231, $C02226AFBB60B4BC, $BE71A320F3D6FF0F, $B80C4880C5A02FD4, $EAE80059B3FE70FC
         Data.q $BFD96D3E2109AFBE, $33433E3653923D3E, $6181FDEF7925044E, $40CCA2BCC151695B, $BFB32F995BDBE050
         Data.q $4BD80C6A38598607, $EED1229FCE4E4FFB, $37BADFD58B1931AB, $9AC9DFBE734207A8, $31180DF76E30F1B1
         Data.q $484A73B9DC7FEBCE, $D7A5B83F9D2F4FFB, $F3E8DECDC7776C64, $77EFE7474D218F98, $BEA6C0F5ABB1CE75
         Data.q $E6D34B630E33E5E9, $D1DDEBF686899CB3, $30F1B1C9EBB3E0B1, $707F829A8EE8DF2E, $EB33FE99E7EAA9A1
         Data.q $92547BE745F7507E, $CF3D5948A6BB587F, $BB773989021B3939, $EE4FFEBB1CE0C06F, $17B5C8FDB00082A9
         Data.q $0D85E5765D9A9161, $D2CFBB3D8776A515, $B091079EAE8A2450, $58699FAF38C60FA6, $AAAC44AE240825E7
         Data.q $524EF9BCCF8048DA, $7CE63B71E6C2BC56, $B1F0FBBCC0BA9B3D, $B389F106710FE236, $E0B19105F4D4FFA4
         Data.q $4964FB2AA2BB5124, $96EF9053D965946A, $5542B5438A9C7B97, $AA218C9B953A9172, $F504091819AC204F
         Data.q $19C68C085CE323C7, $0AFC1667EBA1393B, $9132FEBD1DB62678, $0A88495AE54CAD78, $974C713C10AF0B93
         Data.q $C7A92409E9132188, $DA1DCE5A182B5934, $00FF3496B3E99DD4, $C5E52BD0901E71B2, $444E454900000000
         Data.b $AE, $42, $60, $82
         end_img_info:
      EndDataSection
   EndIf
   
   If Flag & #PB_MessageRequester_Error
      img = - 1;ImageID(CatchImage( #PB_Any, ?img_error, ?end_img_error - ?img_error ))
      
      DataSection
         img_error:
         ; size : 1642 bytes
         Data.q $0A1A0A0D474E5089, $524448490D000000, $3000000030000000, $F902570000000608, $474B620600000087
         Data.q $A0FF00FF00FF0044, $491F06000093A7BD, $41D9ED8168544144, $CCEFF1C71DC7546C, $F6A06C4218C6ED7A
         Data.q $E448A410E515497A, $2070C40BB121A4E0, $46DC512B241A4E54, $124BD29004AB2039, $5150F4DA060B2630
         Data.q $52894889E9734815, $42B01552AB888955, $0A9535535581A8E4, $A69B1B838C151352, $0F5F9BEDFAF1DAF1
         Data.q $1B16F7DEBB3635DE, $DBF3D5DEB2E7A873, $8599BCFFBCCDEFCF, $8B999BBFFED0B685, $D94DFC3235B5A893
         Data.q $2AD241A8331E9177, $A24A50090AA21D50, $F4E23494382E38DF, $CDC2449B1FD5A692, $67C9F4601567BBF6
         Data.q $EA910FC176C73A56, $FB3E2C820C026811, $90FA231C4D0CFD92, $77E7A6B4722EFB8E, $3975B5B8601AF37D
         Data.q $E795079E6401C8E9, $718909C7B3E02570, $139E92E751637E23, $67B6C9EA403CB783, $16621CEA8257EE71
         Data.q $51DA72431163C9F8, $ED40125BADFBB67D, $B69198EA40D4D1ED, $E1CFD7F08E620A6A, $649A76066FAEE378
         Data.q $1CAF696A00B39BD2, $F8A5BF1E82DFA931, $B68B1E9F7E92E7EC, $10366C83462792C6, $9B483C679D1EDEDF
         Data.q $E5ADFDD3DFC7CA2B, $679B1D481A900EB3, $FD5FC5A1C6FDEE7C, $789EA5087457C832, $DF27E036FC740DB6
         Data.q $2EDEA7739A99E91B, $7D63573D4FD7C039, $091E176ECB121FEF, $3D92C5F7739E6BA1, $E3F8C8438CEC4B05
         Data.q $E338639DC7E0C287, $93E731F8D0BBE631, $A883C20B9CF064CA, $C03059C99BECC32E, $8A2A927678B696E8
         Data.q $6773962BC31DF31F, $5E32A40D35BC1ED7, $61AE34C8F7C47E20, $B482B75C33F7CFE9, $BD6DC8C3B3E18BF3
         Data.q $F3CE00E87774D0D6, $C8C73B8EC3301077, $1EAA53FC3F1397B7, $A3ED685DBED88879, $889BEB3C515EF88C
         Data.q $FBB987C6E2C3DC1F, $4F437B575A305FF5, $D8C99E55CF67C74C, $B432B0912802A16D, $0BD967DF31F98D05
         Data.q $2244C006A9AB295B, $95211F6B425F3AC4, $131BB7DFAF88CCC9, $17F2C3565D100089, $60D9F045FBE631B7
         Data.q $0C030246B6B523F0, $1BA0F14E30F0BF9F, $EF9127DDBFE58A36, $7DED884489AFFE4F, $0078CCC4F5CBAD05
         Data.q $A1A89BAF79FF3EF9, $AF17ABFAEFE27E38, $B54C2C7A40060436, $9FD33FDED83596F9, $D82EC4FA885E59F8
         Data.q $D0F7C463C6548EB0, $7ABDF473BC7CC6DA, $3F0026054BD3D308, $C1803039A9C479F1, $CC32DA5654B6183D
         Data.q $843D34389FD11F87, $875C6CC25F3AC4B5, $EFC7C8EAEF1236D6, $86D6458670FE883D, $6F207AF2E72123C2
         Data.q $EE229FADFBFAF81E, $E35C19F88FCEA52F, $89B8CABF4FF7EA1A, $F8B374EBF5EC6161, $5A3FDFED5BFB10EC
         Data.q $524EA5751007B45D, $7B2B97B0FD822695, $BC3B99AC09EB4E0F, $A8050B7237754E04, $6194D2B63B9F052A
         Data.q $FCB800F3AFA5E83E, $D12A27E1D9A4A295, $FA6EE7C74A0110E2, $3343761C4CC77B89, $A4788CCDAA213002
         Data.q $66EA532260530BFC, $3698EAEF136AB9F0, $377FBE21937FAE6C, $F026FF1923335366, $598BE240181C3102
         Data.q $3270DA691B56A7E1, $666A6EC0EAEF12D6, $08BE902F11299324, $7D1CEF04E7174011, $C4AF2272F4B8079D
         Data.q $9181BE3CC1EC0FC6, $C085D20F121D8CEC, $B0DECF8273F38800, $621F92BD2E59CCE6, $A6A48DE6EC4EC1E5
         Data.q $181F3A4E3C00A70C, $F4D5891F61D388C0, $FF7BBCB9F7DE3E68, $9675385AC3B9B564, $5373410C15F6BBCB
         Data.q $ECEB025E38B489F6, $8C7F569A4B00C0E9, $4B1CE3220F0C5CB8, $4FE0BA3BE3E5365B, $7F45AC8B952B4C1F
         Data.q $2DEA844889EFC9EC, $AA5D23C40BBE782D, $091207B8325CECFD, $630A823C3166F487, $4543837863E1F7F9
         Data.q $19E4E8B5A54439F1, $CBEF0864EAFCBD2E, $4131B94C3B5E0641, $2D1D5E40D37B9078, $4D6E25BF5A1CA4B8
         Data.q $EEB9F085E5489FE6, $FC565ABAD19F3B4E, $A7A63EFBBDAE05E4, $6E687C654A927037, $E61DAF030B4B7AA2
         Data.q $3330F5B7215D7F8E, $DF6577BFDC7F695E, $FAD5F0000A84AF5F, $73E133C7EE175E27, $6A27DF318E73D6A5
         Data.q $EF9E3E769954FD08, $47491E3068863728, $99CE42CECBFF3FEA, $D060C40EE915C4D7, $1E3436B2A80CBC02
         Data.q $1F8B0DAC8B0C0A89, $CEE0189ADA5B5132, $7C316769C9AF2793, $336A9850616065F1, $19C98BB16DA138F5
         Data.q $ED9F556C6E8B7D37, $3A0F0BB71BC70B7E, $03198A7793FCFF1A, $E71DB45BAAEEE677, $EFB1DD41BC6F9DDE
         Data.q $B7736A17C8317D2C, $077E9A22B2A5A1BF, $E37DE9DE572F3CD8, $B9BF6727F58E9E45, $86F6AD189E4B100B
         Data.q $B13618F9EBF4207E, $F1370F06153E967B, $E8769E1B43D0C703, $DA14BFE31CD96208, $607AA16C6FE6341E
         Data.q $630AEDEA7739AB6A, $7C039E94863A4956, $152AAF8DE711D25A, $E681F06F91FCB30F, $65624DA80766477A
         Data.q $DDC7F71DC8CBF889, $35C804BCEC3342D1, $388C1EF7C0FABD81, $AA70FBA106B9CB35, $887D7214F8B2AA07
         Data.q $FB5D3D9D6F3A4E8B, $B6859B67A164B9D9, $FEEC7FED695A16D0, $00006B709A860323, $42AE444E45490000
         Data.b $60, $82
         
         
         end_img_error:
      EndDataSection
   EndIf
   
   If Flag & #PB_MessageRequester_Warning
      img = - 1;ImageID(CatchImage( #PB_Any, ?img_warning, ?end_img_warning - ?img_warning ))
      
      DataSection
         img_warning:
         ; size : 1015 bytes
         Data.q $0A1A0A0D474E5089, $524448490D000000, $2800000028000000, $B8FE8C0000000608, $474B62060000006D
         Data.q $A0FF00FF00FF0044, $49AC03000093A7BD, $DD98ED8558544144, $67339F8718551C6B, $6BA934DBB3B3B267
         Data.q $60255624DDDB3493, $785E2A42F0458295, $068C4AF69BDA17E3, $030B4150FDBB362A, $D9AC514B49409622
         Data.q $86FF825726F0546E, $2968A4290537B482, $7B79EF7CD1F26F42, $CCECECDD9B68DDB1, $3DE7337B07E4DE84
         Data.q $CE73DE666FECFBEF, $BE4895C549A28EC0, $D18003BEE526913D, $1BC8E3E7C60FAABF, $9FECC2827EF8A00B
         Data.q $A661997980015464, $5B7351EBFBE505F3, $47813B9850001351, $53C3D570C7AAE19E, $B23A91C71FB3F205
         Data.q $DEADAC5DE7CBF283, $8B8B83D4866AB9E2, $A3501A8AC0BD75C0, $F5C1DD1FC946EE17, $A401C06F62B271D5
         Data.q $FA6A26F924D8AC80, $7E5A30F4E54A0E48, $5560C8F125D550E7, $EF525E4622D61FC1, $09839A235B0F5C4F
         Data.q $6801C1363A672499, $22528E5162499C81, $1C849B7E9D4CA034, $9B0B11E8E79A47A4, $D4275B0ADE94A961
         Data.q $86766961DF69962D, $ACF075B2DD97A5A7, $D5E5ADCCBFD61B82, $E0E70AD6ED2BCBC9, $01C25A643259C2E2
         Data.q $267D976692740A74, $BDB1C9941DB6A94C, $00648F1BCF26FAD8, $B2C7BE9AE0658040, $5EA769DE2F46A039
         Data.q $1126BD12FA3A0EFB, $4936293C09200E18, $A54A016D72DDA26B, $768E93EC9BC50878, $2E521BC80E33910B
         Data.q $141140605A676E1D, $A093744937932ADA, $8281A48D7ED62F67, $15A3F82459547171, $403871C753A9C1DC
         Data.q $06470A2CF737C256, $804094E82C78A9F8, $D268304CD1725D32, $92EA1CB5051ED691, $7565900D8BC67CFC
         Data.q $D18BC6D5D9712E8E, $117CC62E3760194C, $10E54E54A025BC24, $2A40E3FD026F2319, $6858AA64C64A1498
         Data.q $61F477CD41DADA15, $27D00E40F641C4E3, $8096E855B9759636, $67D2AF1465F163F2, $8B1B13EAEAE0D8EC
         Data.q $535855B2BD295223, $321995650B7DF140, $C60B95CDEEFB4C6E, $B8D66D1F4CB2AB43, $D29243E17FBD28B6
         Data.q $084F4AD2B684774F, $4859A46E52C3D2B8, $3D5D0669FAB94043, $435D5C1B6F49A0CF, $B3ACF95CB8C88D26
         Data.q $D9AFD513076370D1, $EC1E3B578FDB0E23, $4DE1A355F6B926C1, $FEC232053D2E5280, $8171BCABDB194E87
         Data.q $9B43A3CCF63AB911, $1D8D8BF4930EEB37, $1B03C18628DF29A2, $2381EFADB70E37E8, $5E94A941C87A1FFF
         Data.q $4653A34D7B30E2C3, $57BCFD90E834E96B, $37AF4AA6517A9634, $506499A04FDF1404, $4BE860F68ADAA152
         Data.q $7B4EB6B20E173A18, $DF46D1F2B907EA58, $CA9492773F250FFD, $BBF30895BD7115D2, $BF527F49C6E93C04
         Data.q $2DC126EA5CA400A4, $73BAB8046E349A0E, $A6B8292C73E17BD5, $BB85E8D406B15816, $05103AFB551D0735
         Data.q $DA95C00E05160EAE, $1B16FD43CE570957, $DA5DBF1B621FD38E, $EA54075063860747, $5917BB61884A7336
         Data.q $FBD40FF52823CC02, $FE37EB4DCBBCBAE0, $9BF9A436D938F722, $8ED1D8C6E3DEF555, $2EE409553D03EE00
         Data.q $4900000000FAB21F
         Data.b $45, $4E, $44, $AE, $42, $60, $82
         end_img_warning:
      EndDataSection
   EndIf
   
   ;\\
   ContainerGadget(#PB_Any, f1, f1, width - f1 * 2, height - bh - f1 - f2 * 2 - 1 )
   ImageGadget(#PB_Any, f2, f2, iw, iw, img, #PB_Image_Border ); | #__flag_center )
   TextGadget(#PB_Any, f2 + iw + f2, f2, width - iw, iw, Text)          ;, #__flag_textcenter | #__flag_textleft )
   CloseGadgetList( )
   
   Protected *ok, *no, *cancel
   
   *ok = ButtonGadget(#PB_Any, width - bw - f2, height - bh - f2, bw, bh, "Ok");, #__button_Default )
   BindGadgetEvent( *ok, @MessageEvents( ), #PB_EventType_LeftClick )
   If Flag & #PB_MessageRequester_YesNo Or
      Flag & #PB_MessageRequester_YesNoCancel
      SetGadgetText( *ok, "Yes" )
      *no = ButtonGadget(#PB_Any, width - ( bw + f2 ) * 2 - f2, height - bh - f2, bw, bh, "No" )
      BindGadgetEvent( *no, @MessageEvents( ), #PB_EventType_LeftClick )
   EndIf
   
   If Flag & #PB_MessageRequester_YesNoCancel
      *cancel = ButtonGadget(#PB_Any, width - ( bw + f2 ) * 3 - f2 * 2, height - bh - f2, bw, bh, "Cancel" )
      BindGadgetEvent( *cancel, @MessageEvents( ), #PB_EventType_LeftClick )
   EndIf
   
   ;\\
   StickyWindow( *message, #True )
   
   ;\\
   WaitEvents( *message )
   
   StickyWindow( *message, #False )
   result = GetWindowData( *message )
   
   ;\\ close
   CloseWindow( *message )
   
   ProcedureReturn result
EndProcedure


UsePNGImageDecoder()

Procedure ShowMessage( UseGadgetList )
   Debug "open - Title"
   Define Result = Message("Title", "Please make your input:", #PB_MessageRequester_YesNoCancel|#PB_MessageRequester_Info, UseGadgetList) 
   Debug " close - Title " + Result
   
   Define flag, a$ = "Result of the previously requester was: "
   
   If Result = #PB_MessageRequester_Yes       ; pressed Yes button
      flag = #PB_MessageRequester_Ok|#PB_MessageRequester_Info
      a$ +#LF$+ "Yes"
   ElseIf Result = #PB_MessageRequester_No    ; pressed No button
      flag = #PB_MessageRequester_YesNo|#PB_MessageRequester_Error
      a$ +#LF$+ "No"
   Else                                       ; pressed Cancel button or Esc
      flag = #PB_MessageRequester_YesNoCancel|#PB_MessageRequester_Warning
      a$ +#LF$+ "Cancel"
   EndIf
   
   Debug "open - Information"
   Result = Message("Information", a$, flag, UseGadgetList)
   Debug "close - Information "+Result
EndProcedure

Procedure CanvasEvents( )
   If EventType( ) <> #PB_EventType_MouseMove
      Debug ""+EventType( )
   EndIf
EndProcedure

Procedure EventClick( )
   If EventType( ) = #PB_EventType_LeftClick
      ShowMessage( WindowID(0) )
   EndIf
EndProcedure

If OpenWindow( 0, 150, 150, 600, 300, "demo message", #PB_Window_SizeGadget | #PB_Window_SystemMenu )
   CanvasGadget(0,10,10,490, 250 )
   BindGadgetEvent( 0, @canvasevents() )
   
   Define *showButton = ButtonGadget(#PB_Any, 600-100, 300-40, 90,30,"show")
   BindGadgetEvent( *showButton, @EventClick() )
   
   ShowMessage( WindowID(0) )
   
   Repeat : Until WaitWindowEvent( ) = #PB_Event_CloseWindow 
EndIf
; IDE Options = PureBasic 5.73 LTS (Windows - x64)
; Folding = --q--
; EnableXP