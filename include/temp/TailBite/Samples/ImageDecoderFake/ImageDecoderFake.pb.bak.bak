; Example ported from the SDK
IncludeFile #PB_Compiler_Home+"tailbite/Helper Libraries/TB_ImagePlugin.pb";If you installed TB somewhere else, you will need to change the path shown here.

ProcedureDLL ImageDecoderFake_Init()
  Global FakeImageWidth.l, FakeImageHeight.l, registered.l
  Global ImageDecoder.PB_ImageDecoder
EndProcedure

Procedure Decode(*Buffer, LinePitch.l, Format.l)
	;MessageRequester("fake image plugin", "decoding")
  
	;// Fill the buffer of red And green line

  For y=0 To FakeImageHeight-1
    *OutputBufferPtr = *Buffer+y*LinePitch;  // Makes the OutputBufferPtr variable points to the start of the line

		For x=0 To FakeImageWidth-1
  		PokeC(*OutputBufferPtr, 255); // write only the blue bit
			*OutputBufferPtr + 3;  // Each pixel is 24 bits (3 bytes)
    Next x
	Next y
EndProcedure

Procedure Check(*File, *Memory, Filename.s);*File is a file pointer.
  Result = 0;
	FileLength.i;

	If File  ;// Read it in from a File
	 	
	Else ;// Read directly from a memory buffer
	  
	EndIf

	Result = 1; // In this example, it's always a FAKE picture format :)

	If Result
		FakeImageWidth  = 100;
		FakeImageHeight =  50;
	EndIf

	ProcedureReturn Result;
EndProcedure

Procedure GetWidth()
  ProcedureReturn FakeImageWidth
EndProcedure

Procedure GetHeight()
  ProcedureReturn FakeImageHeight
EndProcedure

;You should never change the content of this function, just the name(s)
ProcedureDLL UseFAKEImageDecoder()
	If Registered = 0
		ImageDecoder\Check     = @Check();
		ImageDecoder\GetWidth  = @GetWidth();
		ImageDecoder\GetHeight = @GetHeight();
		ImageDecoder\Decode    = @Decode();

		PB_ImageDecoder_Register(@ImageDecoder);
		Registered = 1;
	EndIf

	ProcedureReturn Registered
EndProcedure
; IDE Options = PureBasic 4.30 (Windows - x64)
; CursorPosition = 1
; Folding = --
; EnableXP