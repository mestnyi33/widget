﻿
; Example05_Attachment-and-containers.pb

; Includes the program file
XIncludeFile "EditorFactory.pbi"

; Initializes the Module
UseModule EditorFactory


; --------- Example ---------


; Program constants
Enumeration 1
	#Window
	#Canvas
	#Font
EndEnumeration

; Object constants starting from 1
Enumeration 1
	#Object1
	#Object2
	#Object3
	#Object4
	#Object5
	#Object6
	#Object7
	#Object8
EndEnumeration

; ----------------------------------------------

; Callback procedure to draw an object
Procedure DrawAnObject(Object.i, Width.i, Height.i, iData.i)
	AddPathBox(0, 0, Width, Height)
	VectorSourceColor(iData|$80000000)
	FillPath(#PB_Path_Preserve)
	VectorSourceColor(iData|$FF000000)
	VectorFont(FontID(#Font))
	StrokePath(2)
	MovePathCursor(5, 5)
	VectorSourceColor(iData|$FF000000-$404040)
	DrawVectorText(GetObjectDictionary(Object, "Label"))
EndProcedure

; Callback procedure to draw a panel gadget
Procedure DrawAPanel(Object.i, Width.i, Height.i, iData.i)
	Protected FrameText.s 
	If CountObjectFrames(Object) > 0
		FrameText = "Panel number "+Str(VisibleObjectFrame(Object))
	EndIf
	AddPathBox(0, 0, Width, 32)
	VectorSourceColor(iData|$80000000)
	FillPath(#PB_Path_Preserve)
	VectorSourceColor(iData|$FF000000)
	StrokePath(2)
	AddPathBox(0, 32, Width, Height-32)
	VectorSourceColor(iData|$40000000)
	FillPath(#PB_Path_Preserve)
	VectorSourceColor(iData|$FF000000)
	StrokePath(2)
	VectorFont(FontID(#Font))
	MovePathCursor(Width/2-VectorTextWidth(FrameText)/2, 16-VectorTextHeight(FrameText)/2)
	VectorSourceColor(iData|$FF000000-$404040)
	DrawVectorText(FrameText)
EndProcedure

; Callback procedure to draw a scroll area gadget
Procedure DrawAScrollArea(Object.i, Width.i, Height.i, iData.i)
	AddPathBox(Width-24, 0, 24, Height)
	AddPathBox(0, Height-24, Width, 24)
	VectorSourceColor(iData|$80000000)
	FillPath(#PB_Path_Preserve|#PB_Path_Winding)
	VectorSourceColor(iData|$FF000000)
	StrokePath(2)
	AddPathBox(0, 0, Width-24, Height-24)
	VectorSourceColor(iData|$40000000)
	FillPath(#PB_Path_Preserve)
	VectorSourceColor(iData|$FF000000)
	StrokePath(2)
EndProcedure

; ----------------------------------------------

; Load a font
LoadFont(#Font, "Arial", 12)

; Create a window
OpenWindow(#Window, 0, 0, 1200, 450, "Example 5: Attachment and containers", #PB_Window_MinimizeGadget|#PB_Window_ScreenCentered)

; Create a canvas gadget
CanvasGadget(#Canvas, 0, 0, WindowWidth(#Window), WindowHeight(#Window), #PB_Canvas_Keyboard)

; Initializes the object management for the canvas gadget
If Not InitializeCanvasObjects(#Canvas, #Window)
	Debug "Unable to initialize the object manager !"    
EndIf

SetCursorSelectionStyle(#Canvas, #SelectionStyle_Dashed|#SelectionStyle_Completely, $FFFF0000, 1, $20FF0000)

UsePNGImageDecoder()

; Define the default properties of objects:
AddObjectHandle(#Object_Default, #Handle_Position | #Handle_Size)



; --- Attachment ---
; You can attach an object on another object directly during creation or later with AttachObject

CreateObject(#Canvas, #Object1, 50, 50, 300, 100) ; Main object
SetObjectDrawingCallback(#Object1, @DrawAnObject(), RGB(192, 64, 128))
SetObjectDictionary(#Object1, "Label", "Simple attachment")

CreateObject(#Canvas, #Object2, 0, 120, 140, 100, #Object1) ; Attach object 2 directly to object 1, the position is then relative to object 1
SetObjectDrawingCallback(#Object2, @DrawAnObject(), RGB(128, 0, 64))

CreateObject(#Canvas, #Object3, 160, 170, 140, 100)
SetObjectDrawingCallback(#Object3, @DrawAnObject(), RGB(128, 0, 64))
AttachObject(#Object3, #Object1, #Attachment_X) ; Attach object 3 to object 1 but just the x-position


; --- Panel container ---
; If you attach an object to another and set its boundaries, it acts like a panel gadget.
; Here you can also swap between the different frames with the small handles on top left and top right.

CreateObject(#Canvas, #Object4, 450, 50, 300, 300) ; Main object
SetObjectDrawingCallback(#Object4, @DrawAPanel(), RGB(64, 128, 192))
AddObjectHandle(#Object4, #Handle_Custom1, CatchImage(#PB_Any, ?resultset_previous), #Alignment_Top | #Alignment_Left, 32, 16) ; This is the handle to swap the frame
AddObjectHandle(#Object4, #Handle_Custom2, CatchImage(#PB_Any, ?resultset_next), #Alignment_Top | #Alignment_Right, -32, 16)   ; This is the handle to swap the frame

SetObjectDrawingCallback(#Object_Default, @DrawAnObject(), RGB(0, 64, 128))

AddObjectFrame(#Object4, 0, 0, 32, #Boundary_ParentSize, #Boundary_ParentSize-32, #Boundary_ParentSize, #Boundary_ParentSize-32) ; Add some frames and set the view box for their child objects
AddObjectFrame(#Object4, 1, 0, 32, #Boundary_ParentSize, #Boundary_ParentSize-32, #Boundary_ParentSize, #Boundary_ParentSize-32) ;   as well as the inner area size to bound the childs.
AddObjectFrame(#Object4, 2, 0, 32, #Boundary_ParentSize, #Boundary_ParentSize-32, #Boundary_ParentSize, #Boundary_ParentSize-32)
CreateObject(#Canvas, #Object5, 50, 50, 140, 100, #Object4, 0) ; Attach object 5 directly to object 1 into the first frame
CreateObject(#Canvas, #Object6, 150, 150, 140, 100, #Object4, 1) ; Attach object 6 directly to object 1 into the second frame
CreateObject(#Canvas, #Object7, 100, 100, 100, 150, #Object4, 2) ; Attach object 6 directly to object 1 into the third frame

; --- Scroll area ---
; If you attach an object to another and set its clipping frame, it acts like a scroll area gadget.
; Here you can also change the visible area with the handles (arrows) on the right and bottom.

CreateObject(#Canvas, #Object8, 850, 50, 300, 300) ; Main object
SetObjectDrawingCallback(#Object8, @DrawAScrollArea(), RGB(128, 192, 64))
AddObjectHandle(#Object8, #Handle_Custom1, CatchImage(#PB_Any, ?arrow_up), #Alignment_Top | #Alignment_Right, -12, 16) ; This is the handle the change the visible area
AddObjectHandle(#Object8, #Handle_Custom2, CatchImage(#PB_Any, ?arrow_down), #Alignment_Bottom | #Alignment_Right, -12, -40) ; This is the handle the change the visible area
AddObjectHandle(#Object8, #Handle_Custom3, CatchImage(#PB_Any, ?arrow_left), #Alignment_Bottom | #Alignment_Left, 16, -12) ; This is the handle the change the visible area
AddObjectHandle(#Object8, #Handle_Custom4, CatchImage(#PB_Any, ?arrow_right), #Alignment_Bottom | #Alignment_Right, -40, -12) ; This is the handle the change the visible area

SetObjectDrawingCallback(#Object_Default, @DrawAnObject(), RGB(64, 128, 0))

; Attach some objects to #Object8
AddObjectFrame(#Object8, 0, 0, 0, #Boundary_ParentSize-24, #Boundary_ParentSize-24, 500, 500, 0, 0)
CreateObject(#Canvas, #PB_Any, 50, 50, 100, 100, #Object8, 0)
CreateObject(#Canvas, #PB_Any, 200, 50, 100, 100, #Object8, 0) 
CreateObject(#Canvas, #PB_Any, 50, 250, 100, 100, #Object8, 0)
CreateObject(#Canvas, #PB_Any, 200, 250, 100, 100, #Object8, 0)


; Containers here works a bit like the PureBasic PanelGadgets in a way
; but the objects may or may not be constrained in position within it.
; Each object can have frames (containers for other objects). These frames are numbered from 1 to n.
; If you attach an object (children) to another object (parent), you can specify to which frame it should be attached,
; otherwise it will be automatically added to the current visible frame.
; You can later change the displayed frame with the ShowObjectFrame() command.



; The window's event loop and gadgets.
Repeat
	
	Select WaitWindowEvent()
			
		Case #PB_Event_Gadget ; A Gadget type event.
			
		Case #PB_Event_CloseWindow ; Exit the program.
			Break
			
	EndSelect
	
	; The Objects events loop.
	Repeat
		Select CanvasObjectsEvent(#Canvas) ; Something happened in the Canvas.
			Case #Event_Handle
				Select CanvasObjectsEventType(#Canvas) ; What type of Events happened on the Handle ?
					Case #EventType_LeftMouseClick
						If EventObject(#Canvas) = #Object4 ; Panel container
							; Here the currently shown frame is changed.
							If EventHandle(#Canvas) = #Handle_Custom1 And CountObjectFrames(EventObject(#Canvas)) > 0
								ShowObjectFrame(EventObject(#Canvas), (VisibleObjectFrame(EventObject(#Canvas))+CountObjectFrames(EventObject(#Canvas))-1) % CountObjectFrames(EventObject(#Canvas)))
							EndIf
							If EventHandle(#Canvas) = #Handle_Custom2 And CountObjectFrames(EventObject(#Canvas)) > 0
								ShowObjectFrame(EventObject(#Canvas), (VisibleObjectFrame(EventObject(#Canvas))+1) % CountObjectFrames(EventObject(#Canvas)))
							EndIf
						EndIf
					Case #EventType_LeftMouseButtonHold
						If EventObject(#Canvas) = #Object8 ; Scroll area
							; Here the current scroll position is changed.
							If EventHandle(#Canvas) = #Handle_Custom1
								SetObjectFrameInnerOffset(#Object8, 0, 0, -25, #PB_Relative)
							EndIf
							If EventHandle(#Canvas) = #Handle_Custom2
								SetObjectFrameInnerOffset(#Object8, 0, 0, 25, #PB_Relative)
							EndIf
							If EventHandle(#Canvas) = #Handle_Custom3
								SetObjectFrameInnerOffset(#Object8, 0, -25, 0, #PB_Relative)
							EndIf
							If EventHandle(#Canvas) = #Handle_Custom4
								SetObjectFrameInnerOffset(#Object8, 0, 25, 0, #PB_Relative)
							EndIf
						EndIf
				EndSelect
			Case #Event_None ; No Events.
				Break
		EndSelect
		
	ForEver
	
ForEver

End


; Data section for the icon
DataSection
	; This icon is licensed under a Creative Commons Attribution 3.0 License.
	; Credits: https://www.fatcow.com/free-icons
	resultset_previous:
	Data.q $0A1A0A0D474E5089,$524448490D000000,$2000000020000000,$7A7A730000000608,$58457419000000F4
	Data.q $72617774666F5374,$2065626F64410065,$6165526567616D49,$00003C65C9717964,$DA78544144498702
	Data.q $C6144113684F97EC,$15A2C1B249FCECDF,$22464F15142083D2,$116DA822A6348208,$45E87820F0782B05
	Data.q $AF57B5B6B52093C4,$6E9A0A45E2083D9E,$7B10782946A9AD02,$E8BC148A944141E8,$66CDF1DDD9B756C1
	Data.q $97A6ECD4C35BB695,$FBDFBE610CB0BC0E,$9B094A44BBB7DBDE,$74C005B5E4D80CB9,$DF744F3DD10844FE
	Data.q $0D4E2DD2667EDB29,$459F51A74BC59CF5,$CF07B252363880E9,$F684903EF772E167,$47C5F02555AA5EE2
	Data.q $E6A06F0781821E2F,$17C002B64EB20849,$42CD1ED7072175BF,$8D57A80043C0293A,$96230BC48D03D244
	Data.q $C0E7C737073FA37D,$4DC46576D45C0C14,$158C1CB9FAFC48D8,$C1D57AA0E09981DF,$F88CD6370C0D9DEC
	Data.q $9201F53BB85933D5,$BE9896DDD461B998,$3E2F8004DF786AE3,$8A433F2F7B8597D0,$D789379FA095C5D7
	Data.q $F6272BECB5185101,$E9CCAA60BD7FDD2E,$95C0960964A1198A,$2A5F64BCCC001624,$CA85345B9C3D2E74
	Data.q $7AEF7D065AB6AC9C,$FBB6563E38A137D1,$4133482EAAFE768F,$FB5002B3AE1EDA29,$1CD4FD5A40EF442E
	Data.q $3FC60A7381CA3087,$ED01EFD436FF3C34,$33C791E4F06CF441,$C60D3FCB6D0389F3,$4E28C17AE81740C1
	Data.q $E997C622C0391241,$C3A9F333E35D53A1,$160318A05CA5C41D,$632C02E812A1BE0A,$EBBA7DB954F8C57C
	Data.q $18BE11983D3DF549,$0062F0C70657ACC3,$85995A7F93D10358,$8254C78208593BFD,$0B795584151F10B5
	Data.q $AFB5FB82A069327B,$F88D9AB1E08F0307,$57A5131055C34F3F,$4270233BC4DDBBB0,$EE18861039F10039
	Data.q $F94F6C742AAC97CD,$2100EC46180F7E10,$4E86D1D873C4F288,$7D9A0F6D516E0424,$C593108D310BF921
	Data.q $4D31C10266DF6849,$CA8081D424E9120C,$6CF50BD6A0DE5F70,$7CEAF0BD687F2024,$1833EF2B15BE6919
	Data.q $F183394DFDD182BB,$94207F00944691BD,$4AD6B413519C0F38,$01ECD60D23577580,$0C02DFAECD86DF5B
	Data.q $81B0E584E5E7BA00,$4E45490000000098,$000000826042AE44
	resultset_next:
	Data.q $0A1A0A0D474E5089,$524448490D000000,$2000000020000000,$7A7A730000000608,$58457419000000F4
	Data.q $72617774666F5374,$2065626F64410065,$6165526567616D49,$00003C65C9717964,$DA78544144498D02
	Data.q $C7145153683D97EC,$4C7ED6D3E5E3F7FF,$C5C5D685049C1A6E,$6BF07045B5420A1A,$AD8226E222E87370
	Data.q $917107059D5D5D09,$C1446890D44D2680,$294B1441C1D0EA41,$273D72FAF26ADB38,$B4F79BBEA1692B49
	Data.q $FFBC25EF2E1C2F4B,$8C2BBEE7B9CFFDEF,$0F63CBB121CDD831,$678F421093F9FB40,$CAEBA0A4E426B90B
	Data.q $9D915F86A69444CC,$33C59C467CFB4CEA,$58A6783D70D14657,$31053411076B3D7F,$0FC3F4C4DBBA897E
	Data.q $4EB14CA9C51E5EC8,$D7879D800BFF23F7,$80BC78DC1CC44834,$422AB0814247173B,$83A8C91A3B885C97
	Data.q $748230BADC45B9DB,$3807801D84103E66,$2E620824688D1004,$0DF08307CF3709FF,$94A0AD6818030420
	Data.q $33F95EE408C4816E,$03958433D63B9FAE,$1088CDA9470294EB,$4F4C259BFEE4A704,$EB75A4D0076106F5
	Data.q $83A7050E139076A8,$1F4ED7057EF0789D,$00A7FC20ED674B5E,$EA94AFD934040086,$57168F1B96EB470A
	Data.q $EAC5B4B5A9D35713,$3BAAD01AED0073B0,$20ADAE683760E95A,$E4AE7C6BF52C6971,$DB00E47800DB420B
	Data.q $DA832D863768A4AE,$CFC6EEEBB8490104,$53B4003B4B75BFC9,$47A18E9801B62520,$578A5BBC9F3F1BFB
	Data.q $01FD19B6844E2667,$5801BA2004805490,$AB979E43E38908DC,$5BA49CCF67578B7D,$C066D001E1AB14CB
	Data.q $F167D796E5BE700E,$65551F2B4F0AC323,$67EEF8A57F8B2CF6,$08AB4469A072B2B3,$CF020353C4972ABB
	Data.q $7B711B31F1200B2A,$18A8034D80631200,$10DDBD2850C60E0E,$7356C00D6E2362FF,$7F607E24104F7211
	Data.q $7B27772A1AF98514,$85F4865E01C9EF12,$8157858A08BEE184,$13692376D800ADC4,$2854A08B17D2D6A2
	Data.q $90143772DC501AA3,$5FE45E24FEA18A3A,$CA3F3080E76E2286,$533357D178FBE7F9,$4464E7EB9EB788A1
	Data.q $4EC18A21D3403F6F,$2FC349DF11B65973,$1DB8B9BCEBE9D380,$FA0402FDCB3E5088,$D80797F82E7C0DF2
	Data.q $1A0006016FE1B3BD,$0066A247E8BEE27A,$AE444E4549000000,$0000000000826042
	arrow_up:
	Data.q $0A1A0A0D474E5089,$524448490D000000,$2000000020000000,$7A7A730000000608,$58457419000000F4
	Data.q $72617774666F5374,$2065626F64410065,$6165526567616D49,$00003C65C9717964,$DA78544144497E02
	Data.q $FE144113684D57C4,$E2F15141ED893766,$220F450527A22941,$A544544454FE0A15,$07F043D5E849ED37
	Data.q $54F42A7A1104A28F,$D520428831408505,$05110A083C1C8583,$D6841E9622845FC5,$D937766F7C77766C
	Data.q $2F91E4E21BB3625D,$7DEFB7DEFBBB379B,$4266AC4A521199B3,$8598DBD199C37688,$E70572B8F170D381
	Data.q $EAF8A761776ECC68,$F137C3CCC6D0D582,$F92F7ADB4803C6E8,$01253F15778F3EC8,$72A7C585C843F92F
	Data.q $8917FFD91D487E76,$E2F270168A45F14E,$67853238BD9C36F0,$8533D91CD79A27AF,$F3D284FD50262F7B
	Data.q $2416D24E434F38EB,$4303D7C0563D9025,$143F2F1E5F667CD8,$FB5F4DDD40FA84E8,$23F540557A51E477
	Data.q $20417A245AD7734A,$C6C76E0E160EE27B,$C3445EFB50C73BA3,$8A9677EF0271CE09,$3116DEE618CB6BBF
	Data.q $61629C55F2E50EFF,$E4B17793FAC082F6,$2FF70162B08D14B8,$746049BC66F2A0CD,$4730638F4C2E0CF7
	Data.q $C65C9E115EA0C3D3,$2419F8A777FDBA3A,$B9081B0E97B60A30,$FAE486C21650B743,$792A0573EC05AF0B
	Data.q $491824584EB7271C,$F842F84CB0212762,$1103E179BAE093E1,$1A112C267E53E688,$CC847CB0115E9584
	Data.q $FF2719EF908B92F5,$8E9CE34A41961489,$CB3BA05F60108F5B,$C0B50905CB937374,$1DA470137FE8178D
	Data.q $6D117012F5B480AD,$91201A501175F281,$80D6EBE541A5B30B,$ACAE0341F44A33F4,$33422ED7CAC8FC23
	Data.q $3D0883E88445F7E6,$580D7E8E021159D1,$AC869CEBE51ABF91,$4056B5F4D4A160FA,$B58C22ED080D51D8
	Data.q $75B02CD8EC06B740,$0347F4426FC38ABF,$EC8C58F72F017FDE,$26E9895FC3013B43,$819AC0D7335E2BC0
	Data.q $8087A1A6F9E83D60,$761B5D393AA32C6C,$C1E3C0D461A0D6DD,$D78EEE52A695253E,$8BF3C8C53612B612
	Data.q $ECD205EF1BE117E0,$018483A4E012D38E,$52FE3FF27AA22644,$000300AFE0434EDC,$BD1843191674AD91
	Data.q $444E454900000000,$00000000826042AE
	arrow_down:
	Data.q $0A1A0A0D474E5089,$524448490D000000,$2000000020000000,$7A7A730000000608,$58457419000000F4
	Data.q $72617774666F5374,$2065626F64410065,$6165526567616D49,$00003C65C9717964,$DA78544144494C02
	Data.q $FE14411C483D57E4,$65481885A73576E6,$1B39216763ECE9A1,$14B1A5D858D88289,$1821FCAC11B04451
	Data.q $61CD0446CED6D2C4,$08A4D2E97616EA71,$B7890D142C1085A8,$77B7B73737BE373F,$C781C2B9BD5773D1
	Data.q $BECCFDE6FBDFCDF2,$2888426AD44A5211,$054303EDB05707B4,$D81B1229C342C65E,$05D1F8F508C59BDD
	Data.q $E5616B59236FED8F,$589DAD7CF033A36B,$78865F5B9302D934,$A4094986C926E49C,$EFB7C6EE9AD00283
	Data.q $DC0367A9F03D5AE3,$B83EA42026F5E3CF,$B848B4B6837252D0,$07A158D50802625F,$5042820499F6A09E
	Data.q $A1E28114D8222A54,$B49858D4809A90F3,$2817657B94BA4140,$0A05C2B70F80926C,$D26901256520249B
	Data.q $072AC2852033AC02,$2882E4A06346C2BF,$A07BD1B14610486E,$05DA340B718102CA,$3634033A5A5C993E
	Data.q $E2109952E27C059A,$2361A646A90317D7,$052E510B93685083,$C82E55F309BF1802,$2C57BF775480B39B
	Data.q $02475907817FC2CB,$F8F45407C8ABC3CD,$0622AF5FBFCBAE24,$36DF84B035D4FB18,$D0DE34CEC9160FDD
	Data.q $20FF6E5A0412FB90,$02455DF7FE88F997,$E7F180B8547F7F17,$07029C9C0CDA6231,$A90251FD12E9C887
	Data.q $177674C79FDF2E38,$11EEF838045FCFCE,$6855F3C79E71E7EE,$3F3923FC087168C4,$8CE4E70B2E54C65A
	Data.q $BF98AAE94B7646CC,$D7CF1E79C79FB98C,$AC669EB1F9D4E2EB,$66BE2CDF67492DEE,$7F60B8E0EEC7D106
	Data.q $72945671C1EFB32B,$669E319D954B82A2,$8EF12634892D426A,$3720705A389103E4,$B8F5FB98CBF921CF
	Data.q $5A1A71F0917F6495,$6F7A3B74F5873322,$93EA8988B07C70AF,$D1251025269C7DC7,$9FFE7DAD7246D241
	Data.q $59A72FA528117AF2,$C5C87FCE03A78913,$11D20003009DDAB5,$0000E97396E2423A,$42AE444E45490000
	Data.q $0000000000008260
	arrow_right:
	Data.q $0A1A0A0D474E5089,$524448490D000000,$2000000020000000,$7A7A730000000608,$58457419000000F4
	Data.q $72617774666F5374,$2065626F64410065,$6165526567616D49,$00003C65C9717964,$DA7854414449E301
	Data.q $861450C3483B97EC,$383AD42B58A9B4FF,$220A4E8293882839,$741D4321DA40BE0E,$82D1C4DD41570450
	Data.q $C1D0760E8AB9B88A,$671562DAAC58A141,$228A882A93E0820B,$558A6DB9E5E6D296,$9BDC2709C871A4D7
	Data.q $E12E6FF9FCEF9C3B,$61C9836199855554,$4600E98016005801,$7622C0EA196F9947,$80564B80A19BCC68
	Data.q $B9A4D8027B787ACE,$ED080CAC8E00D4BD,$D6C01DD08068E833,$6784BBC38B26086F,$B03279EAD19B8651
	Data.q $B7A39414019D2663,$56C3980A0DDA8865,$2E000B965A7E1664,$A4AC8FDC657B8151,$24564BA549C3CF40
	Data.q $B7F4410FE71AB992,$FB1047026BFF528E,$3C05BE9AB747041A,$1FAD4F311901770D,$6B9ADD1C42B077C0
	Data.q $BB1CE4E2AC4E10C7,$2CADA2C2F810337B,$0D97CBE70FA3086F,$A5E122F4E13635B4,$8218D506E1FF93A9
	Data.q $ECE0CF85014CAA82,$397FCCA207EC813A,$EFAA6C9C382D1B00,$EB5925B190A1602B,$108E0E049B7FFC91
	Data.q $0039891E82602D8B,$3A2A546DF5CF873B,$30646024919AC02B,$E2B987E2A7BBBE3F,$BFAF669948FCB493
	Data.q $D741D9A3D29EB28A,$03B4A3423CFF40EF,$22D8D1084880AF2F,$02ED8DE0A139E8A6,$00C1F286F28A40A6
	Data.q $3C7B2437EC9879CF,$60BC5C5D3E2A578E,$76F5CA37787CDA3D,$3E167847C63E3802,$FFC900C38B8B269A
	Data.q $7E14CA35A7594028,$82EBE800A9461AD6,$045FFC5DFA9C6D0A,$D98016005898FD67,$9FD699000C025F00
	Data.q $000000725C0E761B,$6042AE444E454900,$0000000000000082
	arrow_left:
	Data.q $0A1A0A0D474E5089,$524448490D000000,$2000000020000000,$7A7A730000000608,$58457419000000F4
	Data.q $72617774666F5374,$2065626F64410065,$6165526567616D49,$00003C65C9717964,$DA7854414449DC01
	Data.q $C7145144284D97EC,$2598B1418C7DF7FF,$F1F25B26A6A688F9,$92D92B5B311DF18A,$2C160B146D643162
	Data.q $20B3512566361625,$9A22485158A58594,$67739E6663318A52,$7A5333B9B2130CDE,$EF7E7BBD7EEF4EA7
	Data.q $91D75D31EDCF739C,$004C01316390914B,$3DD289BF00E72013,$C9652AF079DEAD87,$2A9A362F56E407B6
	Data.q $04D985FBC58D13D1,$76E1AA1AF85E5D90,$19A98F8D1C214DD7,$ED1AF869F19A7575,$822B06200CD5B770
	Data.q $33898C0F0665A021,$ED8665B3E992B7C8,$5E6D2B5B93FA0F1D,$E20CD475A03BD6EC,$E084258ECD1566E4
	Data.q $D1808E24BD0AC5A7,$F83ECBC3091458D7,$70E6BB501EE2283D,$D38439DDAD80E75F,$A48C5FEC4D9015DB
	Data.q $C6A828F200038B51,$D5B6D48500E56C25,$62A983AC0F389DDA,$C1B292C90214FE0D,$5F1C1C67E12A1278
	Data.q $CBA159E286A6219E,$33D3556888678D09,$4C8D18D37B43378F,$1029455A19A5B160,$552E092104931A89
	Data.q $4027D895592A043C,$5CF4631670EEF490,$AE16259795A0B970,$031916D12502D06D,$1CE9EA2382F23C6E
	Data.q $9D1052E7C4FA4220,$4FF2EE4A4455ECD0,$B702A705DEC68BA2,$15FA23464B7D2019,$043C683ED4170082
	Data.q $C0CFC28139C95724,$38829442D7FEF71B,$562D36317E78C598,$DF153C998F631894,$7A41A9691B5202EE
	Data.q $61F86359FC0F019D,$AFF8C3495FE63029,$C804C013131FCCC2,$DF8800030087C035,$0000CBF81800AA70
	Data.q $42AE444E45490000,$0000000000008260
EndDataSection

; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 131
; FirstLine = 123
; Folding = ---
; EnableThread
; EnableXP
; DPIAware
; EnableCompileCount = 516
; EnableBuildCount = 0
; EnableExeConstant