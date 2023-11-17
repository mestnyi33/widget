Notes from ABBKlaus :

[1] NOV 11th 2006
Since PB4.01 fred has changed something that tailbite dislike. 
heres the header of a compiled snipped (only a part of it) :
; 
; PureBasic v4.01 (Windows - x86) generated code 
; 
; © 2006 Fantaisie Software 
; 
; The header must remain intact for Re-Assembly 
; 
; Window 
; Gadget 
; String 
; StringExtension 
; Misc2 
; MemoryExtension 
; Memory 
; LinkedList 
; LinkedListExtension 
; Library 
; Image 
; ImagePlugin 
; Font 
; FileSystem 
; File 
; Date 
; 2DDrawing 
; Object 
; SimpleList 
; :System 
; COMDLG32 
; GDI32 
; KERNEL32 
; USER32 
; WINSPOOL 
; 
format MS COFF 

Now tailbite in the current version compiles ok but when i start purebasic again and want to compile
with the new lib i get this error (same as Falko´s) :

--------------------------- 
PureBasic - Error 
--------------------------- 
Error: The following PureLibrary is missing: :System 
--------------------------- 
OK 
---------------------------

And i made some changes to the TailBite.pb sources just like you wrote Gnozal, the SplitFunctions procedure. (See my post above) 
Now the enumeration breaks exactly when the
; :System
part is reached.

[2] NOV 30th 2006
- Div64 bugfix 
- TailBite Installer Build.pb is now more PB4 compatible


[3] JAN 13th 2007
- fixed the quick-help bug in TailBite 

[4] APR 12th 2007
- fixed small bug with calling procedures (It seems if you call a procedure by pointer once you can't call it by name after that). 

[5] APR 15th 2007
- fixed ImportLib not found / quikchelp bug / DIV bug

[6] MAI 19th 2007
- tailbite does not quit anymore on this POLIB: warning: '__NULL_IMPORT_DESCRIPTOR' already defined in ... ignoring
- PB-Libs are now written in the .desc file i.e. OLE32.DLL , UUID.DLL (ts-soft)
- fixed "TailBite warning: Unknown Windows API function"
  now there are 2 more versions *A for ANSI *W for Unicode in the API-List
- TailBite parameter /CHM:helpfile.chm changed to /CHM:helpfile [without .chm] (ts-soft)
- Systemlibs like ODBCCP32.DLL/SQLConfigDataSource_() are working again (ts-soft)
- fixed endless loop in the ImportFunction

[7] JUN 2th 2007
- new TBManager option for Subsystem
- new command for Tailbite /SUBS:Subsystempath
[8] JUN 5th 2007
- new multiple languages support added (english.catalog is standard now)
[9] JUN 8th/9th 2007
- more language strings added
- For Vista compatibility nothing is written in the TailBite dir anymore
- The Preferences location was moved to #CSIDL_APPDATA\TailBite\TailBite.prefs
- The Library sources location was moved to #CSIDL_PERSONAL\TailBite Library Sources\
- Version information is stored in the exes directly rather than in prefs file
- when TailBite.prefs is found in current folder it will be used (old mode)
[10] JUL 9th 2007 TailBite v1.3 PR 1.848
- should be more VISTA compatible now (TailBite_Intstaller.exe + TBUpdater.exe now request administrator mode)
- fixed : the preferences are loaded correctly now
- fixed : under some conditions the Compilers folder could be deleted
- added : Subsystem now changes accordingly to the checkboxes
[11] JUL 11th 2007 TailBite v1.3 PR 1.849
- fixed a bug with the Initfunction
- added function for lazy coders (found by Paul)
  ProcedureDLL.l MsgTest3(Line.s,Title.s,Icon.l) 
    MessageRequester(Title,Line,Icon) 
  EndProcedure 
  ProcedureDLL.l MsgTest2(Line.s,Title.s) 
    MsgTest3(Line,Title,#MB_ICONINFORMATION) 
  EndProcedure 
  ProcedureDLL.l MsgTest(Line.s) 
    MsgTest3(Line,"Hello",#MB_ICONINFORMATION) 
  EndProcedure
  ^ ^ ^ ^ ^ ^ ^ ^ ^ those constructs work now ^ ^ ^ ^ ^ ^ ^ ^ ^
[12] AUG 8th 2007 TailBite v1.3 PR 1.850
- fixed LibraryMaker.exe warning when creating libs with strings (/NOUNICODEWARNING)
- fixed small bug where PBSubsystem$ was not set
[13] AUG 9th 2007 TailBite v1.3 PR 1.851
- fixed install problem where PBCompiler.exe reports version <4.00 (Falco)
[14] AUG 13th 2007 TailBite v1.3 PR 1.852
- fixed problem where the PureBasic registry key was not found (nco2k)
- fixed problem with usb-stick installation
[15] AUG 16th 2007 TailBite v1.3 PR 1.853
- added new commandline parameter for TailBite.exe /LIBN:Libname
  the generated lib has the filename "Libname"
- added new commandline parameter for TailBite.exe /OUTP "Path"
  the generated lib will be put in the folder "Path"
- added new icons Dog.ico (netmaestro) / s2xr2.ico (Inf0Byt3) / snake.ico (dontmailme)
[16] AUG 22th 2007 TailBite v1.3 PR 1.854
- fixed optional parameters bug reported by TS-Soft
[17] AUG 23th 2007 TailBite v1.3 PR 1.855
- fixed loading of preferences in the TailBite folder reported by TS-Soft
- new commandline switch /LOGF
  Enable creating of TailBite_Logfile.txt and save it into TemporaryDirectory
[18] AUG 30th 2007 TailBite v1.3 PR 1.856
- fixed *_Init bug found by nco2k
[19] SEP 8th 2007 TailBite v1.3 PR 1.857
- fixed problem with asm comments ; ! (found by eddy)
[20] OKT 10th 2007 TailBite v1.3 PR 1.858
- fixed problem with PB folder detection code
[21] OKT 17th 2007 TailBite v1.3 PR 1.859
- fixed problem with :Import section (found by srod)
[22] NOV 22th 2007 TailBite v1.3 PR 1.860
- fixed problem with 'call _SYS_InitString@0' in the _Init function (found by denis)
[23] DEC 12th 2007 TailBite v1.3 PR 1.861
- fixed problem with Labels 'Extrn Libname_l_labelname' (found by Lna)
[24] DEC 13th 2007 TailBite v1.3 PR 1.862
- fixed some more problems with Labels ?label_data (found by Lna)
- fixed renaming of ASM commands MOV DL,AL / MOV DH,AH / CMP AL,DL (found by Lna)
[25] DEC 18th 2007 TailBite v1.3 PR 1.863
- fixed error message when an import lib was not found (found by Mistrel)
- fixed handling of internal libs like 'window.lib' (found by Mistrel)
- fixed some Finishdirectory() missing
[26] JAN 2th 2008 TailBite v1.3 PR 1.864
- TBManager : correction of Subsystem folders (found by IceSoft)
- TBManager : added creation of Subsystem folders
[27] JAN 3th 2008 TailBite v1.3 PR 1.865
- fixed stack issue when 'Prompt confirm on deletion...' was checked (found by IceSoft)
- fixed mispelling of 'user library already exist.'
[28] JAN 22th 2008 TailBite v1.3 PR 1.866
- added a warning when a library already exists somewhere in the Subsystem folder (found by lexvictory)
- added a warning when .PB extension is not registered correctly and PBCompiler.exe was not found (found by hurga/Dostej)
[29] JAN 25th 2008 TailBite v1.3 PR 1.867
- fixed console window flashes no more (found by mistrel)
- added commandline options to the documentation (requested by lexvictory)
[30] JAN 31th 2008 TailBite v1.3 PR 1.868
- added batch options (requested by mistrel)
[31] FEB 29th 2008 TailBite v1.3 PR 1.869
- fixed several small bugs
- added French catalog (Thanks to Flype/Chris/wolfjeremy/Progi1984)
- added German catalog
- added Romanian catalog (Thanks to Infobite)
[32] MAR 19th 2008 TailBite v1.3 PR 1.870
- added linked list as paramter (made by Prodi1984)
[33] MAR 29th 2008 TailBite v1.3 PR 1.871
- added new parameter /VERSION (requested by Droopy)
- fixed recovery of userlib when compiling in unicode and/or threadsafe mode
- improved writelog procedure
- fixed cleaning of temp directory
- added explanation of subsystems to the helpfile
[34] APR 21th 2008 TailBite v1.3 PR 1.872
- fixed varalias bug (reported by LNA)
- fixed detection of modifiers (reported by Mistrel)
- switched to new sourcecode ordering (Thanks to Progi1984)
[35] APR 22th 2008 TailBite v1.3 PR 1.873
- fixed creation of resident (reported by ts-soft)
[36] APR 24th 2008 TailBite v1.3 PR 1.874
- added check for correct subsystem (reported by mistrel)
[37] MAI 25th 2008 TailBite v1.3 PR 1.875
- fixed PureBasic PB4.20 final problem with pb_align / pb_bssalign = align (macro´s are the same)
- improved GetPBFolder() reads uninstall information to determine PureBasic installation path (thanks to mistrel)
[38] MAI 27th 2008 TailBite v1.3 PR 1.876
- fixed GetPBFolder (thanks to ts-soft)
- fixed string bug in exported functions RET X + 4 (thanks to Fred / srod / gnozal)
  Note from Gnozal : don't use exported functions in the library
  Forum thread : http://www.purebasic.fr/english/viewtopic.php?p=230189#230189
[39] SEP 16th 2008 TailBite v1.3 PR 1.877
- fixed LibraryMaker.exe not found error in PureBasic 4.30 Beta 1
- note : SearchDirectory moved from Inc_Tailbite.pb to Inc_Misc.pb
- note : SearchDirectory added parameter Mode=#PB_String_NoCase
[40] OKT 14th 2008 TailBite V1.3 PR 1.878
- fixed X64 Compatibility
- added switch PBVersionX64 to run polib in X64 mode : 'polib.exe /MACHINE:X64'
- added preferences for X64 version 'TailBite_430X64.prefs'
- fixed LibraryMaker.exe : '/COMPRESSED' flag not working in X64 mode
- fixed TBManager.exe : 'Pick current' works now with PB4.30
- fixed LibraryMaker.exe not found in 'Library SDK' it was renamed to 'SDK' now, TailBite will now search trough the whole PureBasic directory !
- fixed another align / pb_align issue
- fixed HtmlCompile : Registry values for X64 added (when TailBite is compiled as 64-Bit executable)
- fixed Inc_TailBite.pb : nAlias is now read as long
- fixed Inc_TailBite.pb : _PB_BSSSection not found
- added X64 ASM-Header is now 'format MS64 COFF'
- added X64 = SYS_InitString / X86 = _SYS_InitString@0
- added Inc_Compiler.pb : ExecuteProgram uses ReadProgramError() to display more info´s on errors
- fixed 'Extrn' will no longer get commented out (found by mpz)
[41] DEC 9th 2008 - JAN 23 2009 TailBite V1.3 PR 1.879
- fixed RET X + 4 in X64 not needed
- fixed TailBite Warning: Unknown Windows API function (found by mistrel)
- fixed BuildApiList() was causing an invalid memory access error on Peeks()
- fixed FAsm error : reserved keyword used as symbol (found by lexvictory)
- fixed X64 FAsm error : invalid argument ... aligngosub (found by lexvictory)
- fixed tempdir was not cleaned while it was in use
- fixed symbol was removed when named the same as the procedure
- fixed do not extrn symbol that is already public
- fixed endfunctions for X64
[42] FEB 12th 2009 TailBite V1.3 PR 1.880
- fixed polib.exe not found if 'Don´t build library. only source files' was checked (found by lexvictory)
- fixed import libs where not written to objfiles.txt if 'Don´t build library. only source files' was checked (found by lexvictory)
- added /EXE option to stop pbcompiler running the exe after commented asm output 28.1.2009 2:55 (by lexvictory)
- added lexvictory´s multilib code that makes UNICODE/THREADSAFE/UNICODE+THREADSAFE in one library file
- fixed another extrn bug that has to be commented out (found by mback2k)
- fixed TBUpdater was broken
[43] FEB 26th 2009 TailBite V1.3 PR 1.881
- fixed missing Extrn when using @Procedure in datasection
[44] APR 7th 2009 TailBite v1.4.0
- MultiLib (lexvictory)
- Linux Support added (lexvictory)
- Preliminary OS X support (lexvictory)
- Import "" supported (access PB internals) (lexvictory)
- No search for librarymaker if where expected (PB 4.30) (lexvictory)
- TB_GagdetExtension, TB_Debugger, TB_ImagePlugin added back in as includes (lexvictory)
- TB_Debugger now supports all the new debugger features (expect language file based ones) (lexvictory)
  See freak's blog: http://www.purebasic.fr/blog/?p=103
- Samples for the above plugins created (MyDebugErrorPlugin updated) (lexvictory)
- New TailBite directive to add internal PBLibs to .Desc: ;--TB_ADD_PBLIB_LibName to add LibName to .Desc (lexvictory)
- fixed backup of old library when in multilib mode
[45] JUL 24th 2009 TailBite v1.4.1
- added 100% float & double fix (lexvictory)
- gadget extension: removed old way of including pb lib and added new one (lexvictory)
- Minor changes to allow TailBite to be compiled as a DLL (lexvictory)
  (changes just make sure an 'End' command doesn't get compiled into a DLL)
  TailBite_DLL.pb is used to build the Dll/so/dylib
  Does not need to be included in the installer builder, as it is a developer aimed extra (I plan to add it to my IDE, so I'll keep it up to date)
- added /PREF option to define prefs location (lexvictory)
- updated inc_os_windows to support windows 7 , osversion reports 80 instead of pb_os_windows_future=100 (lexvictory)
- more mac os x fixes (lexvictory)
- TB working (apart from PB bugs) on OS X (lexvictory)
- fixed bug in makepack() could not store zero-byte files / updated TBManager + TBUpdater to support zero-byte files
[46] JUL 26th 2009 TailBite v1.4.2
- fixed missing decoration bug (found by nco2k)
- added new expand button for the batch options (idea from netmaestro)
[47] FEB 1th 2010 TailBite v1.4.3
- Fixed bug in commandline function /CHM: where .chm was added when it was already present
- small dll updates, added pb4.40 map (renaming) support.
- linux x64 support - no extensive testing done
- updated TBManager to use image buttoms instead of toolbars - toolbars in containers causes a crash on OSX,
  changed batch options buttons to be more intuitive (click down arrow to bring panel down, etc)
- unicode dll fixes
- speed improvements, fasm integration (only fasm.dll needed for 32bit exe, fasmstandby and fasm.dll needed for 64 bit exe),
  (optional) progress bar (including windows 7 taskbar) - disable in tailbite.pb
[48] OCT 11th 2010 TailBite v1.4.4
- decoration bugfix found by PrincieD
- added the errormessage is now written to the logfile when TBError() is called
- fixed some code was incompatible with PureBasic 4.51
[49] OCT 11th 2010 TailBite v1.4.5
- fix for CALL qword [proc] (found by PrincieD)
[50] JAN 20th 2011 TailBite v1.4.6
- fix for pointer arrays (found by nco2k)
- x64 fixes (import libs and interfaces)
[51] FEB 18th 2011 TailBite v1.4.7
- fix for multilib issues with labels (found by CSHW89)
[52] JUL 13th 2011 TailBite v1.4.8
- fix for Extrn of Imported functions (found by Gnozal)
[53] MAR 06th 2013 TailBite v1.4.9
- fix for local labels
- fix for helpline not imported from generated asm source in PB5.10 (Thanks to gnozal)
- added new program icon (Thanks to Inf0Byt3)
[54] JUL 15th 2013 TailBite v1.4.10
- Added VarAlias so_ in Tailbite_Res.pb
- Added #PB_OS_Windows_8 constant to GetPBFolder() in Inc_OS_Win.pb
[55] SEP 24th 2013 TailBite v1.4.11
- removed switch /INLINEASM when PBVersion >=5.20 is installed
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

Tailbite is (c) El_Choni
You can download the full Tailbite package from one of these links:

http://www.tailbite.com

Beta versions:

http://inicia.es/de/elchoni/TailBite/
http://perso.wanadoo.es/tailbite/

You can contact the author by e-mail or at the PureBasic International Forums:

Author:
Miguel Calderón aka El_Choni
mcalderon@inicia.es

Klaus Dresen aka ABBKlaus
klaus.dresen@purebasicpower.de

PureBasic International Forums:
http://www.purebasic.fr/english/