
XIncludeFile "../../../widgets.pbi"

CompilerIf #PB_Compiler_IsMainFile
   Uselib(widget)
   Global Steps = 0
   #PB_ToolBarIcon_Delete = 234567
   #PB_ToolBarIcon_Help = 456567
   #PB_ToolBarIcon_Print = 234565
   #PB_ToolBarIcon_PrintPreview = 98765
   #PB_ToolBarIcon_Replace = 12345678
   #PB_ToolBarIcon_Properties = 34567564
   #PB_ToolBarIcon_Cut = 234354657
   #PB_ToolBarIcon_Copy = 45678
   #PB_ToolBarIcon_Paste = 8765
   #PB_ToolBarIcon_Undo = 678      
   #PB_ToolBarIcon_Redo = 3456
   #PB_ToolBarIcon_Find = 8728357
   #PB_ToolBarIcon_Open = 325466
   #PB_ToolBarIcon_New = 675445
   #PB_ToolBarIcon_Save = 345676
   
   
   Procedure Events( )
      Protected i, j, Buffer$, Parent, Element, EventWidget = EventWidget( )
      
      ;Buffer$=Gadgets(GetGadgetData(IDGadget))\Flag$
      
      For j=0 To CountItems(EventWidget)-1
         If GetItemState(EventWidget, j)
            Buffer$ +"|"+ GetItemText(EventWidget,j)
         EndIf
      Next
      ;Debug GetItemState(EventWidget, 0)
      Debug Buffer$
      ;     ;Buffer$=Gadgets(GetGadgetData(IDGadget))\Flag$
      ;     For i=1 To CountString(Buffer$,"|")+1
      ;       For j=0 To CountGadgetItems(pElement)-1
      ;         If GetGadgetItemText(pElement,j)=StringField(Buffer$,i,"|")
      ;           SetGadgetItemState(pElement, j, #PB_ListIcon_Checked)
      ;         EndIf
      ;       Next
      ;     Next
      
      ; Debug EventClass(ElementEvent())
   EndProcedure
   
   Procedure GetButtonIcon(ButtonIcon) 
      Protected ButtonID =- 1
      UsePNGImageDecoder()
      
      Protected Directory$ = GetCurrentDirectory()+"Themes/" ; "";
      Protected ZipFile$ = Directory$ + "SilkTheme.zip"
      
      If FileSize(ZipFile$) < 1
         CompilerIf #PB_Compiler_OS = #PB_OS_Windows
            ZipFile$ = #PB_Compiler_Home+"themes\SilkTheme.zip"
         CompilerElse
            ZipFile$ = #PB_Compiler_Home+"themes/SilkTheme.zip"
         CompilerEndIf
         If FileSize(ZipFile$) < 1
            MessageRequester("Designer Error", "Themes\SilkTheme.zip Not found in the current directory" +#CRLF$+ "Or in PB_Compiler_Home\themes directory" +#CRLF$+#CRLF$+ "Exit now", #PB_MessageRequester_Error|#PB_MessageRequester_Ok)
            End
         EndIf
      EndIf
      
      If FileSize(ZipFile$) > 0
         UsePNGImageDecoder()
         
         CompilerIf #PB_Compiler_Version > 522
            UseZipPacker()
         CompilerEndIf
         
         Protected PackEntryName.s, ImageSize, *Image, ZipFile;, Image
         ZipFile = OpenPack(#PB_Any, ZipFile$, #PB_PackerPlugin_Zip)
         
         If ZipFile  
            If ExaminePack(ZipFile)
               While NextPackEntry(ZipFile)
                  
                  PackEntryName.S = PackEntryName(ZipFile)
                  
                  PackEntryName.S = ReplaceString(PackEntryName.S,".png","")
                  PackEntryName.S = ReplaceString(PackEntryName.S,"page_","")
                  
                  Select PackEntryType(ZipFile)
                     Case #PB_Packer_File
                        
                        Protected Left.S = UCase(Left(PackEntryName.S,1))
                        Protected Right.S = Right(PackEntryName.S,Len(PackEntryName.S)-1)
                        PackEntryName.S = " "+Left.S+Right.S
                        
                        Select ButtonIcon 
                              ;                 Case #PB_ToolBarIcon_Add
                              ;                   ButtonID = CatchImage(#PB_Any, ?addicon_png_start, 576)
                              ;                   
                           Case #PB_ToolBarIcon_Delete
                              ButtonID = CatchImage(#PB_Any, ?deleteicon_png_start, 801)
                              
                              ;                   If FindString(LCase(PackEntryName.S), "cross") And FindString(LCase(PackEntryName.S), "_") = 0
                              ;                     ImageSize = PackEntrySize(ZipFile)
                              ;                     *Image = AllocateMemory(ImageSize)
                              ;                     UncompressPackMemory(ZipFile, *Image, ImageSize)
                              ;                     ButtonID = CatchImage(#PB_Any, *Image, ImageSize)
                              ;                     FreeMemory(*Image)
                              ;                     Break
                              ;                   EndIf
                              
                           Case #PB_ToolBarIcon_Help
                              If FindString(LCase(PackEntryName.S), "help")
                                 ImageSize = PackEntrySize(ZipFile)
                                 *Image = AllocateMemory(ImageSize)
                                 UncompressPackMemory(ZipFile, *Image, ImageSize)
                                 ButtonID = CatchImage(#PB_Any, *Image, ImageSize)
                                 FreeMemory(*Image)
                                 Break
                              EndIf
                              
                           Case #PB_ToolBarIcon_Print
                              If FindString(LCase(PackEntryName.S), "script")
                                 ImageSize = PackEntrySize(ZipFile)
                                 *Image = AllocateMemory(ImageSize)
                                 UncompressPackMemory(ZipFile, *Image, ImageSize)
                                 ButtonID = CatchImage(#PB_Any, *Image, ImageSize)
                                 FreeMemory(*Image)
                                 Break
                              EndIf
                              
                           Case #PB_ToolBarIcon_PrintPreview
                              If FindString(LCase(PackEntryName.S), "folder_explore")
                                 ImageSize = PackEntrySize(ZipFile)
                                 *Image = AllocateMemory(ImageSize)
                                 UncompressPackMemory(ZipFile, *Image, ImageSize)
                                 ButtonID = CatchImage(#PB_Any, *Image, ImageSize)
                                 FreeMemory(*Image)
                                 Break
                              EndIf
                              
                           Case #PB_ToolBarIcon_Replace
                              If FindString(LCase(PackEntryName.S), "refresh") And FindString(LCase(PackEntryName.S), "_") = 0
                                 ImageSize = PackEntrySize(ZipFile)
                                 *Image = AllocateMemory(ImageSize)
                                 UncompressPackMemory(ZipFile, *Image, ImageSize)
                                 ButtonID = CatchImage(#PB_Any, *Image, ImageSize)
                                 FreeMemory(*Image)
                                 Break
                              EndIf
                              
                           Case #PB_ToolBarIcon_Properties
                              If FindString(LCase(PackEntryName.S), "edit") And FindString(LCase(PackEntryName.S), "_") = 0
                                 ImageSize = PackEntrySize(ZipFile)
                                 *Image = AllocateMemory(ImageSize)
                                 UncompressPackMemory(ZipFile, *Image, ImageSize)
                                 ButtonID = CatchImage(#PB_Any, *Image, ImageSize)
                                 FreeMemory(*Image)
                                 Break
                              EndIf
                              
                           Case #PB_ToolBarIcon_Cut
                              If FindString(LCase(PackEntryName.S), "cut")
                                 ImageSize = PackEntrySize(ZipFile)
                                 *Image = AllocateMemory(ImageSize)
                                 UncompressPackMemory(ZipFile, *Image, ImageSize)
                                 ButtonID = CatchImage(#PB_Any, *Image, ImageSize)
                                 FreeMemory(*Image)
                                 Break
                              EndIf
                              
                           Case #PB_ToolBarIcon_Copy
                              If FindString(LCase(PackEntryName.S), "copy")
                                 ImageSize = PackEntrySize(ZipFile)
                                 *Image = AllocateMemory(ImageSize)
                                 UncompressPackMemory(ZipFile, *Image, ImageSize)
                                 ButtonID = CatchImage(#PB_Any, *Image, ImageSize)
                                 FreeMemory(*Image)
                                 Break
                              EndIf
                              
                           Case #PB_ToolBarIcon_Paste
                              If FindString(LCase(PackEntryName.S), "paste")
                                 ImageSize = PackEntrySize(ZipFile)
                                 *Image = AllocateMemory(ImageSize)
                                 UncompressPackMemory(ZipFile, *Image, ImageSize)
                                 ButtonID = CatchImage(#PB_Any, *Image, ImageSize)
                                 FreeMemory(*Image)
                                 Break
                              EndIf
                              
                           Case #PB_ToolBarIcon_Undo
                              If FindString(LCase(PackEntryName.S), "arrow_undo")
                                 ImageSize = PackEntrySize(ZipFile)
                                 *Image = AllocateMemory(ImageSize)
                                 UncompressPackMemory(ZipFile, *Image, ImageSize)
                                 ButtonID = CatchImage(#PB_Any, *Image, ImageSize)
                                 FreeMemory(*Image)
                                 Break
                              EndIf
                              
                           Case #PB_ToolBarIcon_Redo
                              If FindString(LCase(PackEntryName.S), "arrow_redo")
                                 ImageSize = PackEntrySize(ZipFile)
                                 *Image = AllocateMemory(ImageSize)
                                 UncompressPackMemory(ZipFile, *Image, ImageSize)
                                 ButtonID = CatchImage(#PB_Any, *Image, ImageSize)
                                 FreeMemory(*Image)
                                 Break
                              EndIf
                              
                           Case #PB_ToolBarIcon_Find
                              If FindString(LCase(PackEntryName.S), "zoom")
                                 ImageSize = PackEntrySize(ZipFile)
                                 *Image = AllocateMemory(ImageSize)
                                 UncompressPackMemory(ZipFile, *Image, ImageSize)
                                 ButtonID = CatchImage(#PB_Any, *Image, ImageSize)
                                 FreeMemory(*Image)
                                 Break
                              EndIf
                              
                           Case #PB_ToolBarIcon_Open
                              If FindString(LCase(PackEntryName.S), "folder_page")
                                 ImageSize = PackEntrySize(ZipFile)
                                 *Image = AllocateMemory(ImageSize)
                                 UncompressPackMemory(ZipFile, *Image, ImageSize)
                                 ButtonID = CatchImage(#PB_Any, *Image, ImageSize)
                                 FreeMemory(*Image)
                                 Break
                              EndIf
                              
                           Case #PB_ToolBarIcon_New
                              If FindString(LCase(PackEntryName.S), "page") And FindString(LCase(PackEntryName.S), "_") = 0
                                 ImageSize = PackEntrySize(ZipFile)
                                 *Image = AllocateMemory(ImageSize)
                                 UncompressPackMemory(ZipFile, *Image, ImageSize)
                                 ButtonID = CatchImage(#PB_Any, *Image, ImageSize)
                                 FreeMemory(*Image)
                                 Break
                              EndIf
                              
                           Case #PB_ToolBarIcon_Save
                              If FindString(LCase(PackEntryName.S), "disk")
                                 ImageSize = PackEntrySize(ZipFile)
                                 *Image = AllocateMemory(ImageSize)
                                 UncompressPackMemory(ZipFile, *Image, ImageSize)
                                 ButtonID = CatchImage(#PB_Any, *Image, ImageSize)
                                 FreeMemory(*Image)
                                 Break
                              EndIf
                              
                        EndSelect
                        
                  EndSelect
                  
               Wend  
            EndIf
            
            ClosePack(ZipFile)
         EndIf
      EndIf
      
      
      
      DataSection
         deleteicon_png_start:
         ; size : 801 bytes
         Data.q $0A1A0A0D474E5089,$524448490D000000,$0E0000000E000000,$2D481F0000000608,$47527301000000D1
         Data.q $0000E91CCEAE0042,$0000414D41670400,$00000561FC0B8FB1,$0000735948700900,$C701C30E0000C30E
         Data.q $741900000064A86F,$7774666F53745845,$6E69617000657261,$2E342074656E2E74,$7A5B033433312E30
         Data.q $5441444991020000,$6153485D526D4F38,$AC1FA22E81FAFE18,$C6E6739D9D72E3B6,$175B34E8EDBFCE9C
         Data.q $1A0FE51AC2932061,$CF368A9494586EA2,$2EC428933697358E,$41FD855D108298D2,$1B461A071BC2E82C
         Data.q $A5285D578127538A,$5129A3BEFB78BBFB,$BCFBCF7EF177CDCF,$761CA75448BCFBCF,$62EB998C0F3D341B
         Data.q $1768A3E9A443BAA6,$8E51A3D9429C9C7B,$FEBC8C8BAE4E6AF7,$C93078AA507E5C8E,$5E10FA7A5B16B8EF
         Data.q $AD7DE90DB98A5CD5,$A5903BC8D48A09F4,$7A4D6626319FF31E,$104A2A5D372AD518,$B0756958BC8BDA11
         Data.q $05DFA4400F0C7E1F,$B5F68E82E3175513,$FEC798337BD3C7B1,$53210C52C84492D2,$5A8A9EE068E54C2E
         Data.q $DEF1E3723F682D13,$EAB0DD03AB62DAD6,$BD5FDE13708880ED,$5B2F26A768E4F490,$04C0B0429595CE7F
         Data.q $086E55AE787AF9D3,$F17A9E245245ACB4,$5BBBDFE22A6B1F78,$F04DDBE580E9C560,$682057D5C21AA1AD
         Data.q $10DA9D2616526336,$F248763DA6D1CA59,$AE7DE3C7DCBC4048,$56F961DAB4AE48AE,$8162C843D5352C23
         Data.q $A25154E9F06CA62F,$EF3919DA0FE917F4,$7CB0B5EC86BEA9D6,$46F20872D6730EDD,$D97B2D2EE0E06D78
         Data.q $AD83BAFEDB494EAE,$E4D66C9FE355EB95,$AF926CD82C237362,$620C367C021E02F9,$1BB23AA38E5A4EC5
         Data.q $6DF98ED1CA3D2115,$56542C3B66C589E5,$6706F06F08D9B4C2,$6154C3C45C20F30A,$76A19398D9E90C2E
         Data.q $B28A87EE1C2E42A2,$10B575C20386F844,$58BA8983386198B0,$8C8BA745C99233CA,$0C877E0084292910
         Data.q $0FB421B3ECAC71E9,$2C1D636CFAECF479,$D21859FCE0403536,$2217216B2B021B31,$4CD89AD9231DA9B0
         Data.q $3E7144E1B8F30F09,$B4DA8A395BA9B174,$839EB49CDF859F7A,$3C4E5776930E7A67,$FE2E9E45EFA29C89
         Data.q $4EAFD53ABC09B4EE,$7674882F78055646,$8561AC539BA10AB1,$3EA971753C4E567F,$FAB513D211AD4B27
         Data.q $E44097C6770976C0,$975227880FF88BA5,$1C285E1BF4202494,$0000005DDBFE0391,$6042AE444E454900
         Data.b $82
         deleteicon_png_end:
      EndDataSection
      
      DataSection
         addicon_png_start:
         ; size : 576 bytes
         Data.q $0A1A0A0D474E5089,$524448490D000000,$0E0000000E000000,$2D481F0000000608,$47527301000000D1
         Data.q $0000E91CCEAE0042,$0000414D41670400,$00000561FC0B8FB1,$0000735948700900,$C701C30E0000C30E
         Data.q $741900000064A86F,$7774666F53745845,$6E69617000657261,$2E342074656E2E74,$7A5B033433312E30
         Data.q $54414449B0010000,$939D9406C0634F38,$519840B9FCCC6439,$E4A8184C2A0D8C3B,$5EA3DF9A2954A94C
         Data.q $54105A60B35BA8B6,$64DB79DAEA303098,$31FD4E53C6FFA9EA,$D8184C2A1539DCEA,$FFE5EE76DB783A4E
         Data.q $84729FB1FCAEF3F6,$EC769E76184646A0,$DF973DFF9B92EBB6,$5C23481CFF3BE3FE,$4389C9C94021880E
         Data.q $C7FEDF45854E64A7,$FA7D98F63D8ED3F6,$3C3743BF1BB2EF89,$5D84FFD5FDB31FFE,$6838F67B6FC73EAF
         Data.q $B63D1F6B7EC7A3C3,$9064636A0372E9CC,$6ED45F2CD4E70EB7,$FE1739877FD4E536,$B3EB763FF9BB2CFB
         Data.q $F7DD4FFF5EBB49FF,$0F93FFCFC1DA7FFE,$C0FFC3FBBE1FFD7E,$83FBF6975BFF1F5D,$AB697AA0DE828235
         Data.q $FE5E17DDBFD3F4F5,$2F5D94EFFEE1B91D,$C8F73FFF7FED65FF,$3CCDFCBF4739FFE7,$C3BF8F9EEC77F5FC
         Data.q $97D93A50EDFC7D76,$1679B983233FF191,$1D9EC71F14F171AB,$3A2EC7F7F6D3BEFD,$63E2FBD9E7BF9FD9
         Data.q $70AFF2FF1E97FF9F,$C7F56E9BE90BCBFF,$BF7AEAB61FDEB9AC,$A06C46D80EBB4163,$FDBEA7553BA3F774
         Data.q $C7BED94FEDF33EAF,$AA7727DED94747C4,$9FC7F6735FFF7CCF,$E7BC58D7894FFD8A,$9D97FFDF53D2EDC9
         Data.q $031A090F68A7FEFE,$07BAA7EA426DDA8A,$84D2EC29F5744F55,$404B1C239005130A,$1ED3496C00003030
         Data.q $000000003E2C4D2A,$826042AE444E4549
         addicon_png_end:
      EndDataSection
      
      ProcedureReturn ButtonID 
   EndProcedure
   
   Define i
   Open(0, 0,0, 530,460, "Demo ListIcon") 
   Define g = ListIconGadget(#PB_Any,10,10,508,200, "Column_0",160, #PB_ListIcon_CheckBoxes|#PB_ListIcon_AlwaysShowSelection);|#PB_ListIcon_HeaderDragDrop)           
   Debug AddGadgetItem(g, -1, "ListIcon_1", ImageID(GetButtonIcon(#PB_ToolBarIcon_Copy)) )
   Debug AddGadgetItem(g, -1, "ListIcon_2") 
   Debug AddGadgetItem(g, -1, "ListIcon_3", ImageID(GetButtonIcon(#PB_ToolBarIcon_Cut)) )
   Debug AddGadgetItem(g, 0, "ListIcon_0", ImageID(GetButtonIcon(#PB_ToolBarIcon_Open)) )
   AddGadgetColumn(g, 1,"Column_2",100)
   For i=4 To 10
      Debug AddGadgetItem(g, -1, Chr(10)+"ListIcon_"+Str(i)) 
   Next
   
   Debug "------------------------------------"
   Define e = ListIcon(10-3,220-3,508+6,200+6, "Column_0",160,#__Flag_CheckBoxes|#__Flag_ThreeState);|#__Flag_SizeGadget) 
   Debug AddItem(e, -1, "ListIcon_1", GetButtonIcon(#PB_ToolBarIcon_Copy))
   Debug AddItem(e, -1, "ListIcon_2") 
   Debug AddItem(e, -1, "ListIcon_3", GetButtonIcon(#PB_ToolBarIcon_Cut))
   Debug AddItem(e, 0, "ListIcon_0", GetButtonIcon(#PB_ToolBarIcon_Open) )
   AddColumn(e, 1,"Column_2",100)
   For i=4 To 10
      Debug AddItem(e, -1, Chr(10)+"ListIcon_"+Str(i)) 
   Next
   
   
   Bind(e, @Events(), #__Event_Change|#__Event_LeftClick)
   WaitClose( )
CompilerEndIf

; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 325
; FirstLine = 307
; Folding = -----
; EnableXP
; DPIAware