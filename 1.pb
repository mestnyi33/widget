func$ = "Window" ; debug Window 1 0

; comment\uncomment
 func$ = "﻿Window" ; ﻿debug Window 0 1
 
 func$ = RemoveString(func$, "﻿" )
 ;func$ = ReplaceString(func$, "﻿", "" )
 ;func$ = ReplaceString(func$, "Window", "﻿Window" )
 
Debug ""+func$ +" "+ Bool(func$ = "Window") +" "+ Bool(func$ = "﻿Window") +" "+ Bool(func$ = "﻿Window")
                 
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 3
; EnableXP
; DPIAware