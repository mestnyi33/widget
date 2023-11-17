IncludeFile #PB_Compiler_Home+"tailbite/Helper Libraries/TB_ImagePlugin.pb";If you installed TB somewhere else, you will need to change the path shown here.

; /* The encoder Procedure
;  *
;  * Parameters:
;  *
;  *   - Filename: The output file name (string$)
;  *
;  *   - Buffer: the uncompressed image buffer, in 24 bits format, similar To the
;  *						 decoder buffer.
;  *
;  *   - Width:  Width of the picture To encode (in pixels)
;  *
;  *   - Height: Height of the picture To encode (in pixels)
;  *
;  *   - LinePitch: Real length of a line, For the buffer, in bytes.
;  *
;  *	 - Flags: Not supported For now. Will be For compression adjustment
;  *
;  * Return value:
;  *
;  *   - 0: The encoder has failed
;  *   - 1: The encoder has correctly done the job
;  *
;  **/

Procedure Encode(Filename.s, *Buffer, Width.l, Height.l, LinePitch.l, Flags.l)

	Result = 0;  // False by default
	Define x, y, File
	
	Define *SourceCursor

	;// Open the file in write/binary mode
  File = OpenFile(#PB_Any, Filename)
  If File
		For y=0 To Height-1
			*SourceCursor = *Buffer + y * LinePitch;
      
			For x=0 To Width-1
				;// Read the pixels here And write it To disk in the desired format
			Next x
	  Next y
	  CloseFile(File)
	EndIf
	
	MessageRequester("Fake image encoder", "'encoded'")


  Result = 1;

	ProcedureReturn Result
EndProcedure

; /* The virtual table With the exported PureBasic function.
;  *
;  * Only the function name And the ID should be modified.
;  *
;  * The ID will be unique ID of the encoder, which is passed
;  * in the SaveImage(#Image, Filename$, EncoderID) function.
;  *
;  **/

ProcedureDLL FakeImageEncoder_Init()
  Global ImageEncoder.PB_ImageEncoder
  Global Registered.l
EndProcedure

ProcedureDLL UseFakeImageEncoder()
	If Registered = 0
		ImageEncoder\ID			= 'FAKE' ;this should be defined in a constant and compiled to a .res file
		ImageEncoder\Encode = @Encode();

		PB_ImageEncoder_Register(@ImageEncoder);
		Registered = 1;
	EndIf

	ProcedureReturn Registered;
EndProcedure


; IDE Options = PureBasic 4.30 (Windows - x64)
; Folding = -
; EnableXP