; fg_color
; bg_color
; base_color
; text_color
; selected_bg_color
; selected_fg_color
; tooltip_bg_color
; tooltip_fg_color

ImportC ""
  gtk_style_lookup_color.l(*style, color_name.p-utf8, *color)
EndImport

Procedure GetColor(*widget, color_name.s, *color_out.GdkColor)
  a.s = Space(Len(color_name))
  
  PokeS(@a, color_name, -1, #PB_Ascii)
 
  gtk_widget_realize_(*widget)
 
  *style.GtkStyle = gtk_rc_get_style_(*widget)
  
  If Not gtk_style_lookup_color(*style, a, *color_out)
    gdk_color_parse_("black", @color)
  EndIf

EndProcedure


OpenWindow(0,0,0,0,0,"")
ButtonGadget(0, 0, 0, 0, 0, "")

color.GdkColor
GetColor(GadgetID(0), "fg_color", @color)

With color
  Debug (\red / 255) &$FF
  Debug (\green / 255) &$FF
  Debug (\blue / 255) &$FF
EndWith
; IDE Options = PureBasic 5.70 LTS (MacOS X - x64)
; Folding = -
; EnableXP