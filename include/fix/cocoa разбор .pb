Macro GetCocoa( objectCocoa, funcCocoa, paramCocoa )
    CocoaMessage(0, objectCocoa, funcCocoa+":@", @paramCocoa)
  EndMacro
  ;   Macro GetCocoa(objectCocoa, funcCocoa, paramCocoa)
  ;     CocoaMessage(0, objectCocoa, funcCocoa+":@", @paramCocoa)
  ;   EndMacro
  
  ;   Procedure CocoaNSApp()
  ;     ProcedureReturn CocoaMessage(0, 0, "NSApplication sharedApplication")
  ;   EndProcedure
  ;   
  ;   Procedure CocoaWindowNumber(CocoaNSWindow)
  ;     ProcedureReturn CocoaMessage(0, CocoaNSWindow, "windowNumber")
  ;   EndProcedure
  ;   
  ;   Procedure CocoaNSWindow(CocoaNSApp, CocoaWindowNumber)
  ;     ProcedureReturn CocoaMessage(0, CocoaNSApp, "windowWithWindowNumber:", CocoaWindowNumber)
  ;   EndProcedure
  ;   
  
  
;@MainActor class NSResponder : NSObject
;class NSApplication : NSResponder
;class NSWindow : NSResponder
;class NSView : NSResponder
; func indexOfTabViewItem(_ tabViewItem: NSTabViewItem) -> Int
;var currentEvent: NSEvent? { get }    currentEvent = CocoaMessage(0,NSEvent,"currentEvent")

;func sendEvent(_ event: NSEvent)
;func postEvent(_ event: NSEvent, atStart flag: Bool ) 
;func mouseEntered(with event: NSEvent) ; https://developer.apple.com/documentation/appkit/nsresponder/1529306-mouseentered

;class NSAttributedString : NSObject    AttributedString = CocoaMessage(0, 0, "NSAttributedString alloc")

;var enclosingScrollView: NSScrollView? { get }      ScrollView = CocoaMessage(0,GadgetID,"enclosingScrollView")
;var firstBaselineOffsetFromTop: CGFloat { get }    CocoaMessage(@top, GadgetID(Gadget), "firstBaselineOffsetFromTop")
;var alphaValue: CGFloat { get set }       CocoaMessage(0, WindowID, "setAlphaValue:@", @alpha) ; alpha.CGFloat = 0.7
;var badgeLabel: String? { get set }       CocoaMessage(0, DockTile, "setBadgeLabel:$", @"Pure")
;var keyEquivalent: String { get set }     CocoaMessage(0, ButtonID, "setKeyEquivalent:$", @"b")
;var view: NSView? { get set }
;func setDocumentEdited(_ dirtyFlag: Bool) ; CocoaMessage(0, WindowID, "setDocumentEdited:", #True)
;func stop(_ sender: Any?)

; - (ObjectType)objectForKey:(KeyType)aKey;    
;      LanguageCode = CocoaMessage(0, CurrentLocale, "objectForKey:$", @"kCFLocaleLanguageCodeKey")
;      DecimalSeparator = CocoaMessage(0, CurrentLocale, "objectForKey:$", @"kCFLocaleDecimalSeparatorKey")


;- (instancetype)initWithPath:(NSString *)path;  
;      CocoaMessage(@AttributedString, AttributedString, "initWithPath:$", @"filename.rtf", "documentAttributes:", #Null)

;+ (instancetype)arrayWithCapacity:(NSUInteger)numItems;
;     MutableArray = CocoaMessage(0, 0, "NSMutableArray arrayWithCapacity:", 10)

;+ (instancetype)bezierPathWithRoundedRect:(CGRect)rect  byRoundingCorners:(UIRectCorner)corners  cornerRadii:(CGSize)cornerRadii;
;    CocoaMessage(0, 0, "NSBezierPath bezierPathWithRoundedRect:@", @Rect, "xRadius:@", @RadiusX, "yRadius:@", @RadiusY)

;+ (NSImageRep *)imageRepWithContentsOfFile:(NSString *)filename;
;    CocoaMessage(@Rep, 0, "NSImageRep imageRepWithContentsOfFile:$", @Filename)

; @property NSSize size;        CocoaMessage(@Size, Rep, "size")

;- (void)drawAtPoint:(CGPoint)point;        CocoaMessage(0, Rep, "drawAtPoint:@", @Point)

;+ (instancetype)dataWithBytesNoCopy:(void *)bytes  length:(NSUInteger)length  freeWhenDone:(BOOL)b;
;    CocoaMessage(@DataObj, 0, "NSData dataWithBytesNoCopy:", *MemoryAddress, "length:", MemorySize, "freeWhenDone:", #NO)
   
;+ (Class)imageRepClassForData:(NSData *)data;      CocoaMessage(@Class, 0, "NSImageRep imageRepClassForData:", DataObj)

;func setSize(_ size: String!)   CocoaMessage(0, Rep, "setSize:@", @Size) ; Size.NSSize
;    
;var applicationIconImage: NSImage! { get set }     CocoaMessage(0, Application, "setApplicationIconImage:", ImageID(0))

;@property(class, readonly, strong) __kindof NSApplication *sharedApplication;    Application = CocoaMessage(0, 0, "NSApplication sharedApplication")
; IDE Options = PureBasic 5.73 LTS (MacOS X - x64)
; Folding = -
; EnableXP