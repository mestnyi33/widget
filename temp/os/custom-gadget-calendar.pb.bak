; https://www.purebasic.fr/english/viewtopic.php?f=19&t=46349&p=352759&hilit=canvas+gadget#p352759
; - this calendar gadget has two procedures without any external variables (KISS)
; - calendar will return only one date or zero if no date selected
; - start day of week can be changed to Sunday=0 or Monday=1=WeekStart
; - can show number of days not in this month (in light gray)
; - negative date does not show selected
; - new months are blank
; - can't decide what to do with text colors (Month,days & day numbers)
; - different version numbers for procedures

EnableExplicit
Enumeration
    #calendar1
    #calendar2
    #calendar3
    #calendar4
    #calendar5
    #calendar6
    #window1
EndEnumeration
Define event,etype,id,dte

Procedure DrawCanvasCalendar(id,dte) ; vers 1.1
    ;options
    Protected weekstarts=1 ; =Sunday 1=Monday [must be set the same as in DoCanvasCalendarEvent()!]
    Protected showothermonths=1 ; 1=will show other days than just this month ; 0=noshow
    Protected fontloaded=20 ;  & fontloaded+1 ; font id value must be greater than all other font ids in program!
    ;color palette
    Protected backgroundcolor=$FFFFFF ; background color of calendar (white)
    Protected headingcolor=$D1B18D ; color of box under month name (blue)
    Protected buttoncolor=$EBDECF ; lighter shade of headingcolor for buttons (button center is headingcolor)
    Protected boxcolor=$dddddd ; empty day box color (gray)
    Protected selecteddaycolor=$9999ff ; selected day box color (red)
    Protected todaycolor=$99ff99 ; today's day box color (green)
    ;
    Protected showday=1 ; re-set below as 0=neg date / 1=pos date default (do not change!)
    If Abs(dte)<2000
        MessageRequester("Drawing calendar...","not a valid date "+Str(dte))
        ProcedureReturn 0
    ElseIf dte<-1 ; will be this is new month (so no day shown selected)
        showday=0 : dte=Abs(dte)
    EndIf
    Protected month=Month(dte),day=Day(dte),year=Year(dte)
    Protected lmonth,lyear=year,lmonthend ; lastmonth
    Protected w,h,bw,headingheight,headingwidth,cornerrounding
    Protected boxw,boxh,boxoffset,boxtop
    Protected monthoffset,monthend,weeks
    Protected x,xw,y,incr,cnt,txt$ ; reused
    Protected Dim MonthName.s(12)  ; rem out if you've already dim array globally (4 lines)
    For x=1 To 12
        MonthName(x)=Trim(Mid("        January  February March    April    May      June     July     August   SeptemberOctober  November December ",x*9,9))
    Next
    Protected Dim DayName.s(7)
    For x=1+WeekStarts To 7+WeekStarts
        DayName(x-WeekStarts)=Mid(" SuMoTuWeThFrSaSu",x*2,2)
    Next
    
    w=GadgetWidth(id)
    h=GadgetHeight(id)
    bw=2 ; border width from outline
    ;calculate heading size
    headingheight=h*0.15  ; heading is about 15% of total height of gadget
    headingwidth=w-(bw*6) ; full width of gadget less borders
    cornerrounding=30 ; amount of corner rounding
    ;try to load correct font size?
    Select headingwidth*0.8 ; approx 80% of title area is availiable for text (a guess)
    Case 1 To 130  ;  used Arial because it look good small ; change the font and all sizes will have to be adjusted!
        LoadFont(fontloaded,"Arial",12)
        LoadFont(fontloaded+1,"Arial",10)
    Case 1 To 200
        LoadFont(fontloaded,"Arial",14)
        LoadFont(fontloaded+1,"Arial",12)
    Default
        LoadFont(fontloaded,"Arial",18)
        LoadFont(fontloaded+1,"Arial",16)  
    EndSelect
    ;calculate box size
    boxoffset=bw*3 : boxw=(w-(boxoffset+boxoffset))/7
    boxtop=h*0.3 ; approx 30% of top area is Month title + day names
    ;find days in month
    monthoffset=DayOfWeek(Date(year,month,1,0,0,0))-WeekStarts : If monthoffset<0 : monthoffset=6 : EndIf
    ;monthend=MonthDays(month) ; use if you've already dim array globally
    monthend=31
        While Date(year,month,monthend,0,0,0)=-1
            monthend-1
        Wend
            If monthend<28 : MessageRequester("monthend=",Str(monthend)) : EndIf ; error checking
        If monthoffset+monthend>35 : weeks=6 : Else : weeks=5 : EndIf ; how many rows of weeks
    lmonth=month-1 : If lmonth<1 : lmonth=12 : lyear-1 : EndIf
    ;lmonthend=MonthDays(lmonth) ; use if you've already dim array globally (delete next 5 lines)
    lmonthend=31 
        While Date(lyear,lmonth,lmonthend,0,0,0)=-1
            lmonthend-1
        Wend
            If lmonthend<28 : MessageRequester("lmonthend=",Str(lmonthend)) : EndIf ; error checking
    ;depending on number of weeks ; find day box height
    boxh=(h-boxtop-bw-bw)/weeks
    StartDrawing(CanvasOutput(id))
        If GetWindowColor(GetActiveWindow())=-1
            DrawingMode(#PB_2DDrawing_AlphaChannel)
            Box(0,0,w,h,RGBA(0,0,0,0)) ; transparent background
            DrawingMode(#PB_2DDrawing_AlphaBlend)
            RoundBox(bw,bw,w-bw-bw,h-bw-bw,w/cornerrounding,h/cornerrounding,RGBA(Red(backgroundcolor),Green(backgroundcolor),Blue(backgroundcolor),255))
            DrawingMode(#PB_2DDrawing_Default)
        Else
            Box(0,0,w,h,GetWindowColor(GetActiveWindow())) ; blank
            RoundBox(bw,bw,w-bw-bw,h-bw-bw,w/cornerrounding,h/cornerrounding,backgroundcolor)
        EndIf
        ;solid color box
        RoundBox(bw*3 , bw*3 , headingwidth , headingheight , w/cornerrounding,h/cornerrounding,RGBA(Red(headingcolor),Green(headingcolor),Blue(headingcolor),255)) ; title box
        ;left arrow
        x=(bw*3)+(headingwidth*0.1) : y=(bw*3)+(headingheight/2)
        xw=headingheight*0.2 ; radius of circle
        Circle(x,y,xw,buttoncolor) ; lighter color
        incr=xw*0.6 ; draw arrow proportionally (incr=width of arrow is 1/2 height)
        x-(incr/2) ; y is unchanged
        Line(x,y,incr,-incr,headingcolor)
        Line(x+incr,y-incr,1,incr*2,headingcolor)
        Line(x+incr,y+incr,-incr,-incr,headingcolor)
        FillArea( x+1,y,headingcolor,headingcolor)
        ;right arrow
        x=(bw*3)+(headingwidth*0.9) ; y is unchanged
        Circle(x,y,xw,buttoncolor)
        x-(incr/2) : y=y
        Line(x,y-incr,1,incr+incr,headingcolor)
        Line(x,y+incr,incr,-incr,headingcolor)
        Line(x+incr,y,-incr,-incr,headingcolor)
        FillArea( x+1,y,headingcolor,headingcolor)
        ;outlined boxes
        DrawingMode(#PB_2DDrawing_Outlined)
        RoundBox(bw,bw,w-bw-bw,h-bw-bw,w/cornerrounding,h/cornerrounding,headingcolor)
        ; month name
        DrawingMode(#PB_2DDrawing_Transparent)
        DrawingFont(FontID(fontloaded))
        txt$=MonthName(month)+" '"+Right(Str(year),2) ; entire heading text (eg. Month '11)
        x=(w/2)-(TextWidth(txt$)/2) : y=(bw*3)+((headingheight-TextHeight(txt$))/2)
        DrawText(x,y,txt$,0)
        
        ; day text
        DrawingFont(FontID(fontloaded+1))
        y=(bw*2)+headingheight+bw
        For x=0 To 6
            DrawText(boxoffset+(x*boxw)+4,y,DayName(x+1),0)
        Next
;         ;lines between days
;         xw=(w-(bw*6))/7 ; width between days
;         For x=0 To 7
;             Line(boxoffset+(x*xw)-1,y,1,TextHeight(txt$),headingcolor)
;         Next
;         ;line under days
;         y+TextHeight(txt$)-1
;         Box(boxoffset,y,boxw*7,2,headingcolor)
        ;put in day boxes
        cnt=7*weeks
        For xw=1 To cnt ; 7*weeks
            x=xw : While x>7 : x-7 : Wend
            x=boxoffset+((x-1)*boxw)
            y=boxtop+(((xw-1)/7)*boxh)
            If xw>monthoffset And xw<=monthoffset+monthend
                If xw-monthoffset=day And showday
                    Box(x,y,boxw-1,boxh-1,selecteddaycolor)
                Else
                    Box(x,y,boxw-1,boxh-1,boxcolor)
                EndIf
                DrawText(x+2,y+2,Str(xw-monthoffset),0)
            Else
                If showothermonths
                    If xw>monthoffset+monthend
                        DrawText(x+2,y+2,Str(xw-monthoffset-monthend),$999999) ; grayed out text
                    Else
                        DrawText(x+2,y+2,Str(xw+lmonthend-monthoffset),$999999)
                    EndIf
                EndIf
            EndIf
            If xw-monthoffset=Day(Date()) And month=Month(Date()) And year=Year(Date())
                If xw-monthoffset=day And showday
                    Box(x,y,boxw-1,boxh-1,todaycolor)
                    Box(x+2,y+2,boxw-5,boxh-5,selecteddaycolor)
                Else
                    Box(x,y,boxw-1,boxh-1,todaycolor)
                EndIf
                DrawText(x+2,y+2,Str(xw-monthoffset),0)
            EndIf
        Next
    StopDrawing()  
    ; carry date along
    SetGadgetData(id,Date(year,month,day,0,0,0))
EndProcedure

Procedure DoCanvasCalendarEvent(id) ; vers 1
    Protected weekstarts=1 ; =Sunday 1=Monday [must be set the same as in DrawCanvasCalendar()!]
    ; call EventType() again if you want to know what type of click (or pass it in procedure)
    Protected month=Month(GetGadgetData(id))
    Protected day=Day(GetGadgetData(id))
    Protected year=Year(GetGadgetData(id))
    Protected w=GadgetWidth(id),h=GadgetHeight(id),bw=2
    Protected mx = GetGadgetAttribute(id, #PB_Canvas_MouseX)
    Protected my = GetGadgetAttribute(id, #PB_Canvas_MouseY)
    Protected dte ; return date of what day was clicked
    
    ;calculate box size
    Protected boxoffset=bw*3
    Protected boxw=(w-(boxoffset+boxoffset))/7
    Protected boxtop=h*0.3 ; 30% of top area is for Month text and day names
    ;calculate how many days in month
    Protected monthoffset=DayOfWeek(Date(year,month,1,0,0,0))-weekstarts : If monthoffset<0 : monthoffset=6 : EndIf
    ;Protected monthend=MonthDays(month) ; use if you've already dim array globally
    Protected monthend=31
        While Date(year,month,monthend,0,0,0)=-1 ; find number of days in month
            monthend-1
        Wend
        If monthend<28 : MessageRequester("",Str(monthend)) : EndIf ; error checking
    Protected weeks ;calculate weeks so can find box height
    If monthoffset+monthend>35 : weeks=6 : Else : weeks=5 : EndIf ; how many rows of weeks
    Protected boxh=(h-boxtop-bw-bw)/weeks
    
    ;find circle center
    Protected headingheight=h*0.15 ; 15%
    Protected headingwidth=w-(bw*6)
    Protected xw=headingheight*0.2  ; radius of circle
    Protected y=(bw*3)+(headingheight/2) ; either circle center
    Protected x ; either circle center
    
    If my<boxtop ; in top area
        If my>y-xw And my<y+xw ; on button row
            x=(bw*3)+(headingwidth*0.1)+1 ; left button center+1
            If mx=>x-xw And mx<=x+xw
                month-1 : day=1
                If month<1 : month=12 : year-1 : EndIf
                dte=Date(year,month,day,0,0,0)
                DrawCanvasCalendar(id,-dte) ; negative date so no day is selected
            EndIf
            x=(bw*3)+(headingwidth*0.9)+1 ; right button center+1
            If mx=>x-xw And mx<=x+xw
                month+1 : day=1
                If month>12 : month=1 : year+1 : EndIf
                dte=Date(year,month,day,0,0,0)
                DrawCanvasCalendar(id,-dte) ; negative date so no day is selected
            EndIf
        EndIf
        dte=0 ; no day selected
    Else ; in bottom area (days)
        x=((mx-boxoffset)/boxw)+1
        y=(my-boxtop)/boxh
        day=((y*7)+x)-monthoffset
        ;Debug Str(x)+" "+Str(y)+" "+Str(day)+" "+Str(month)+" "+Str(year)
        If day>0 And day<=monthend
            dte=Date(year,month,day,0,0,0)
            DrawCanvasCalendar(id,dte)
        Else
            dte=0 ; not on a day
        EndIf
    EndIf
    ProcedureReturn dte
EndProcedure

If OpenWindow(#window1, 220, 50, 750, 640, "Canvas Calendar", #PB_Window_SystemMenu )
    SetWindowColor(#Window1,$555555)
    CanvasGadget(#calendar1,10,10,170,120)
    DrawCanvasCalendar(#calendar1,-Date()) ; date is neg so will not appear selected
    CalendarGadget(#calendar2,10,140,170,120)
    
    CanvasGadget(#calendar3,10,270,200,170)
    DrawCanvasCalendar(#calendar3,Date())
    CalendarGadget(#calendar4,10,450,200,170)
    
    CanvasGadget(#calendar5,240,10,300,240)
    DrawCanvasCalendar(#calendar5,Date(2011,4,3,0,0,0))
    CalendarGadget(#calendar6,240,260,300,240,Date(2011,4,3,0,0,0))
    
    Repeat
        event=WaitWindowEvent()
        Select event
        Case #PB_Event_Gadget
            id=EventGadget()
            etype=EventType()
            Select id
            Case #calendar1,#calendar3,#calendar5
                Select etype
                Case #PB_EventType_LeftButtonUp
                    dte=DoCanvasCalendarEvent(id)
                    If dte
                        Debug "DATE:"+FormatDate("%mm/%dd/%yyyy",dte )
                    Else
                        Debug "no day clicked on"
                    EndIf
                EndSelect
            EndSelect
        EndSelect
    Until event=#PB_Event_CloseWindow
EndIf
; IDE Options = PureBasic 5.73 LTS (MacOS X - x64)
; Folding = ------
; EnableXP