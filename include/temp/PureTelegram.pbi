;=----------------------------------------------------------------------------┓
;                                                                             |
;                                 PureTelegram                                |
;       A Telegram API framework by Seymour Clufley for PureBasic v5.73+      |
;                                                                             |
;                            Released 26th Jan 2021                           |
;         https://www.purebasic.fr/english/viewtopic.php?f=12&t=76640         |
;             Thanks To Infratec for the multipart form data code             |
;                                                                             |
;  Notes: The chat_id passed can be username or integer ID                    |
;         Use PostItem() to post audio, image, video, etc.                    |
;         Telegram_GetUserProfilePhotos() needs the JPEG decoder to work      |
;         DeleteMessage() only works if the message is less than 48 hours old |
;         Line breaks in a message can be done with #CRLF$ or Chr(13)+Chr(10) |
;                                                                             |
;  Possible future changes: Generating TGS stickers                           |
;                           Fixing Telegram_PostItemWithThumbnail()           |
;                                                                             |
;  Also check out PureSVG, HSL, Server-Sent Events,                           |
;                 and my various geometry functions                           |
;                                                                             |
;=----------------------------------------------------------------------------┛




;-
;- BACKGROUND STUFF

CompilerIf Defined(ByteTruth,#PB_Procedure)=0
#d1 = "|"
Global c34.s{1} = Chr(34)

Macro R(t)
	MessageRequester("Report",t,0)
EndMacro

Macro EnsureThisNotStart(t,start)
	If Left(t,Len(start)) = start
		t = Mid(t,Len(start)+1,Len(t))
	EndIf
EndMacro

Macro EnsureThisEnd(t,endd)
	If endd<>""
		If Right(t,Len(endd)) <> endd
			t+endd
		EndIf
	EndIf
EndMacro

Macro StartsWith(main,sub)
	(sub<>"" And main<>"" And Left(main,Len(sub))=sub)
EndMacro

Macro BeatThis(a,b)
  If b>a
      a=b
  EndIf
EndMacro

Procedure.s ByteTruth(b.b)
  If b=#True
    ProcedureReturn "true"
  Else
    ProcedureReturn "false"
  EndIf
EndProcedure

Procedure.s ByteUntruth(b.b)
  If b=#True
    ProcedureReturn "false"
  Else
    ProcedureReturn "true"
  EndIf
EndProcedure

Procedure.b ValB(t.s)
  
  t = LCase(t)
  Select t
      Case "true", "1", "yes"
          ProcedureReturn #True
      Default
          ProcedureReturn #False
  EndSelect
  
EndProcedure

CompilerEndIf

Procedure.s ArrayToSerializedJSON(arr.s,dlm.s)
  items.i = CountString(arr,dlm)
  json.s = "["
  For o = 1 To items
    this_one.s = StringField(arr,o,dlm)
    json + c34+this_one+c34
    If o<items : json+", " : EndIf
  Next o
  json + "]"
  ProcedureReturn json
EndProcedure


Procedure.s MimeType(ext.s)
  Select ext
    Case "png", "jpg", "gif", "webp"
      tp.s = "image"
    Case "mp4", "webm"
      tp = "video"
    Case "mp3", "m4a", "ogg"
      tp = "audio"
  EndSelect
  
  ProcedureReturn tp+"/"+ext
EndProcedure




;-
;- GENERAL TELEGRAM STUFF


Structure TG_UserStructure
  is_bot.b
  first_name.s
  last_name.s
  username.s
  id.i
  can_join_groups.b
  can_read_all_group_messages.b
  supports_inline_queries.b
EndStructure

Structure TG_ChatMemberStructure
  user.TG_UserStructure
  status.s
  custom_title.s
  is_anonymous.b
  can_be_edited.b
  can_post_messages.b
  can_edit_messages.b
  can_delete_messages.b
  can_restrict_members.b
  can_promote_members.b
  can_change_info.b
  can_invite_users.b
  can_pin_messages.b
  is_member.b
  can_send_messages.b
  can_send_media_messages.b
  can_send_polls.b
  can_send_other_messages.b
  can_add_web_page_previews.b
  until_date.b
EndStructure

Structure TG_ChatStructure
  username.s
  title.s
  type.s
  id.i
  first_name.s
  last_name.s
  description.s
EndStructure

Structure TG_PollOptionStructure
  text.s
  voter_count.i
EndStructure

Structure TG_PollStructure
  id.s
  question.s
  Array options.TG_PollOptionStructure(1)
  total_voter_count.i
  is_closed.b
  is_anonymous.b
  type.s
  allows_multiple_answers.b
  correct_option_id.i
  explanation.s
  open_period.i
  close_date.i
EndStructure

Structure TG_PollAnswerStructure
  poll_id.s
  user.TG_UserStructure
  Array option_ids.i(1)
EndStructure

Structure TG_MessageEntityStructure
  type.s
  offset.i
  length.i
  url.s
  user.TG_UserStructure
  language.s
EndStructure

Structure TG_PhotoSizeStructure
  file_id.s ; can be used to download the file
  file_unique_id.s
  width.i
  height.i
  file_size.i
EndStructure

Structure TG_LocationStructure
  longitude.f
  latitude.f
  horizontal_accuracy.f
  live_period.i
  heading.i
  proximity_alert_radius.i
EndStructure

Structure TG_AnimationStructure
  file_id.s ; can be used to download the file
  file_unique_id.s
  width.i
  height.i
  duration.i
  thumb.TG_PhotoSizeStructure
  file_name.s
  mime_type.s
  file_size.i
EndStructure

Structure TG_AudioStructure
  file_id.s ; can be used to download the file
  file_unique_id.s
  duration.i
  performer.s
  title.s
  file_name.s
  mime_type.s
  file_size.i
  thumb.TG_PhotoSizeStructure
EndStructure

Structure TG_DocumentStructure
  file_id.s ; can be used to download the file
  file_unique_id.s
  thumb.TG_PhotoSizeStructure
  file_name.s
  mime_type.s
  file_size.i
EndStructure

Structure TG_VideoStructure
  file_id.s ; can be used to download the file
  file_unique_id.s
  width.i
  height.i
  duration.i
  thumb.TG_PhotoSizeStructure
  file_name.s
  mime_type.s
  file_size.i
EndStructure

Structure TG_VideoNoteStructure
  file_id.s ; can be used to download the file
  file_unique_id.s
  length.i
  duration.i
  thumb.TG_PhotoSizeStructure
  file_size.i
EndStructure

Structure TG_VoiceStructure
  file_id.s ; can be used to download the file
  file_unique_id.s
  duration.i
  mime_type.s
  file_size.i
EndStructure

Structure TG_VenueStructure
  location.TG_LocationStructure
  title.s
  address.s
  foursquare_id.s
  foursquare_type.s
  google_place_id.s
  google_place_type.s
EndStructure

Structure TG_ContactStructure
  phone_number.s
  first_name.s
  last_name.s
  user_id.i
  vcard.s
EndStructure

Structure TG_MaskPositionStructure
  point.s
  x_shift.f
  y_shift.f
  scale.f
EndStructure

Structure TG_StickerStructure
  file_id.s ; can be used to download the file
  file_unique_id.s
  width.i
  height.i
  is_animated.b
  thumb.TG_PhotoSizeStructure
  emoji.s
  set_name.s
  mask_position.TG_MaskPositionStructure
  file_size.i
EndStructure

Structure TG_StickerSetStructure
  name.s
  title.s
  is_animated.b
  contains_masks.b
  Array stickers.TG_StickerStructure(1)
  thumb.TG_PhotoSizeStructure
EndStructure

Structure TG_MessageStructure2
  message_id.i
  from.TG_UserStructure
  chat.TG_ChatStructure
  text.s
  caption.s
  date.i
  forward_from_message_id.i
  forward_signature.s
  forward_sender_name.s
  forward_date.i
  ;reply_to_message.TU_MessageStructure
  via_bot.TG_UserStructure
  edit_date.i
  media_group_id.s
  author_signature.s
  sender_chat.TG_ChatStructure
  forward_from_chat.TG_ChatStructure
  Array entities.TG_MessageEntityStructure(1)
  animation.TG_AnimationStructure
  audio.TG_AudioStructure
  document.TG_DocumentStructure
  Array photo.TG_PhotoSizeStructure(1)
  sticker.TG_StickerStructure
  video.TG_VideoStructure
  video_note.TG_VideoNoteStructure
  voice.TG_VoiceStructure
  poll.TG_PollStructure
  venue.TG_VenueStructure
  location.TG_LocationStructure
  Array caption_entities.TG_MessageEntityStructure(1)
  contact.TG_ContactStructure
  new_chat_participant.TG_UserStructure
  Array new_chat_members.TG_UserStructure(1)
  left_chat_member.TG_UserStructure
  new_chat_title.s
  Array new_chat_photo.TG_PhotoSizeStructure(1)
  delete_chat_photo.b
  group_chat_created.b
  supergroup_chat_created.b
  channel_chat_created.b
EndStructure

Structure TG_MessageStructure Extends TG_MessageStructure2
  reply_to_message.TG_MessageStructure2
EndStructure

Structure TG_InlineQueryStructure
  id.s
  from.TG_UserStructure
  location.TG_LocationStructure
  query.s
  offset.s
EndStructure

Structure TG_ChosenInlineResultStructure
  result_id.s
  from.TG_UserStructure
  location.TG_LocationStructure
  inline_message_id.s
  query.s
EndStructure

Structure TG_ShippingAddressStructure
  country_code.s
  state.s
  city.s
  street_line1.s
  street_line2.s
  post_code.s
EndStructure

Structure TG_ShippingQueryStructure
  id.s
  from.TG_UserStructure
  invoice_payload.s
  shipping_address.TG_ShippingAddressStructure
EndStructure

Structure TG_OrderInfoStructure
  name.s
  phone_number.s
  email.s
  shipping_address.TG_ShippingAddressStructure
EndStructure

Structure TG_PreCheckoutQueryStructure
  id.s
  from.TG_UserStructure
  currency.s
  total_amount.i
  invoice_payload.s
  shipping_option_id.s
  order_info.TG_OrderInfoStructure
EndStructure

Structure TG_CallbackQueryStructure
  id.s
  from.TG_UserStructure
  message.TG_MessageStructure
  inline_message_id.s
  chat_instance.s
  Data.s
  game_short_name.s
EndStructure




#Telegram_TextMaximum = 4096
#Telegram_CaptionMaximum = 1024


#TG_AllesOK = "{"+Chr(34)+"ok"+Chr(34)+":true,"
#TG_AllesOKResult = #TG_AllesOK+Chr(34)+"result"+Chr(34)+":"
    
Macro HandleTelegramResponse
  If HttpRequest
    rt.s = HTTPInfo(HTTPRequest, #PB_HTTP_Response)
    If HTTPInfo(HTTPRequest,#PB_HTTP_StatusCode)="200"
      Debug rt
      If StartsWith(rt,#TG_AllesOK)
        ;Debug "ALL OK"
        status = #True
      EndIf
    Else
      Debug "ERROR: "+rt
    EndIf
    FinishHTTP(HttpRequest)
  EndIf
EndMacro




Structure TG_FileStructure
  file_id.s
  file_unique_id.s
  file_size.i
  file_path.s
EndStructure

Procedure.b Telegram_GetFile(api_token.s,file_id.s,download_fn.s)
  InitNetwork()
  u.s = "https://api.telegram.org/bot"+api_token+"/getFile?file_id="+file_id
  HttpRequest.i = HTTPRequest(#PB_HTTP_Post,u)
  If HttpRequest
    rt.s = HTTPInfo(HTTPRequest, #PB_HTTP_Response)
    If HTTPInfo(HTTPRequest,#PB_HTTP_StatusCode)="200"
      FinishHTTP(HttpRequest)
      ;Debug rt
      EnsureThisNotStart(rt,#TG_AllesOKResult)
      rt = Left(rt,Len(rt)-1)
      
      j = 9
      CreateJSON(j)
      ParseJSON(j,rt)
      ;SetClipboardText(rt)
      ;R(ComposeJSON(j,#PB_JSON_PrettyPrint))
      
      ExtractJSONStructure(JSONValue(j),@fstruc.TG_FileStructure,TG_FileStructure)
      FreeJSON(j)
      
      u.s = "https://api.telegram.org/file/bot"+api_token+"/"+fstruc\file_path
      ReceiveHTTPFile(u,download_fn)
      
      ;Debug "ALL OK"
      ProcedureReturn #True
    Else
      Debug "ERROR: "+rt
    EndIf
    FinishHTTP(HttpRequest)
  EndIf
  ProcedureReturn status
EndProcedure

Procedure.i Telegram_GetFileToMemory(api_token.s,file_id.s)
  InitNetwork()
  u.s = "https://api.telegram.org/bot"+api_token+"/getFile?file_id="+file_id
  HttpRequest.i = HTTPRequest(#PB_HTTP_Post,u)
  If HttpRequest
    rt.s = HTTPInfo(HTTPRequest, #PB_HTTP_Response)
    If HTTPInfo(HTTPRequest,#PB_HTTP_StatusCode)="200"
      FinishHTTP(HttpRequest)
      ;Debug rt
      EnsureThisNotStart(rt,#TG_AllesOKResult)
      rt = Left(rt,Len(rt)-1)
      
      j = 9
      CreateJSON(j)
      ParseJSON(j,rt)
      ;SetClipboardText(rt)
      ;R(ComposeJSON(j,#PB_JSON_PrettyPrint))
      
      ExtractJSONStructure(JSONValue(j),@fstruc.TG_FileStructure,TG_FileStructure)
      FreeJSON(j)
      
      u.s = "https://api.telegram.org/file/bot"+api_token+"/"+fstruc\file_path
      *buffer = ReceiveHTTPMemory(u)
      
      ;Debug "ALL OK"
      ProcedureReturn *buffer
    Else
      Debug "ERROR: "+rt
    EndIf
    FinishHTTP(HttpRequest)
  EndIf
  ProcedureReturn status
EndProcedure








;-
;- "POSTING MESSAGE" FUNCTIONS

Macro HandleTelegramPostingResponse
  status.i = 0
  If HttpRequest
    rt.s = HTTPInfo(HTTPRequest, #PB_HTTP_Response)
    If HTTPInfo(HTTPRequest,#PB_HTTP_StatusCode)="200"
      Debug "*"+rt+"*"
      rt = StringField(rt,2,"message_id")
      rt = StringField(rt,2,":")
      rt = StringField(rt,1,",")
      status = Val(rt)
    Else
      Debug "ERROR: "+rt
    EndIf
    FinishHTTP(HttpRequest)
  EndIf
EndMacro

Macro PrepareChatID
  EnsureThisNotStart(chat_id,"@")
  If Left(chat_id,1)<>"-"
    chat_id = "@"+chat_id
  EndIf
EndMacro

Macro PrepareNamedChatID(pcivar)
  EnsureThisNotStart(pcivar,"@")
  If Left(pcivar,1)<>"-"
    pcivar = "@"+pcivar
  EndIf
EndMacro



Structure TelegramMessageTypeStructure
  php_name.s
  field_name.s
  max_file_size.d
EndStructure

Enumeration
  #TelegramMessageType_Text
  #TelegramMessageType_Animation
  #TelegramMessageType_Video
  #TelegramMessageType_File
  #TelegramMessageType_Audio
  #TelegramMessageType_Voicemessage
  #TelegramMessageType_Videomessage
  #TelegramMessageType_Image
  #TelegramMessageType_Sticker
  #TelegramMessageType_Contact
  #TelegramMessageType_Location
  #TelegramMessageType_Venue
  #TelegramMessageTypes = #PB_Compiler_EnumerationValue-1
EndEnumeration
Global Dim TelegramMessageType.TelegramMessageTypeStructure(#TelegramMessageTypes)

TelegramMessageType(#TelegramMessageType_Text)\php_name = "sendMessage"
TelegramMessageType(#TelegramMessageType_Text)\field_name = "text"

TelegramMessageType(#TelegramMessageType_Contact)\php_name = "sendContact"
TelegramMessageType(#TelegramMessageType_Contact)\field_name = "contact"

TelegramMessageType(#TelegramMessageType_Location)\php_name = "sendLocation"
TelegramMessageType(#TelegramMessageType_Location)\field_name = "location"

TelegramMessageType(#TelegramMessageType_Venue)\php_name = "sendVenue"
TelegramMessageType(#TelegramMessageType_Venue)\field_name = "photo"

TelegramMessageType(#TelegramMessageType_Image)\php_name = "sendPhoto"
TelegramMessageType(#TelegramMessageType_Image)\field_name = "photo"
TelegramMessageType(#TelegramMessageType_Image)\max_file_size = 10

TelegramMessageType(#TelegramMessageType_Voicemessage)\php_name = "sendVoice"
TelegramMessageType(#TelegramMessageType_Voicemessage)\field_name = "voice"
TelegramMessageType(#TelegramMessageType_Voicemessage)\max_file_size = 50

TelegramMessageType(#TelegramMessageType_Videomessage)\php_name = "sendVideoNote"
TelegramMessageType(#TelegramMessageType_Videomessage)\field_name = "video_note"
TelegramMessageType(#TelegramMessageType_Videomessage)\max_file_size = 50 ; maximum filesize is unknown, but maximum duration is 1 minute

TelegramMessageType(#TelegramMessageType_Animation)\php_name = "sendAnimation"
TelegramMessageType(#TelegramMessageType_Animation)\field_name = "animation"
TelegramMessageType(#TelegramMessageType_Animation)\max_file_size = 50

TelegramMessageType(#TelegramMessageType_Video)\php_name = "sendVideo"
TelegramMessageType(#TelegramMessageType_Video)\field_name = "video"
TelegramMessageType(#TelegramMessageType_Video)\max_file_size = 50

TelegramMessageType(#TelegramMessageType_Audio)\php_name = "sendAudio"
TelegramMessageType(#TelegramMessageType_Audio)\field_name = "audio"
TelegramMessageType(#TelegramMessageType_Audio)\max_file_size = 50

TelegramMessageType(#TelegramMessageType_File)\php_name = "sendDocument"
TelegramMessageType(#TelegramMessageType_File)\field_name = "document"
TelegramMessageType(#TelegramMessageType_File)\max_file_size = 2000

TelegramMessageType(#TelegramMessageType_Sticker)\php_name = "sendSticker"
TelegramMessageType(#TelegramMessageType_Sticker)\field_name = "sticker"
TelegramMessageType(#TelegramMessageType_Sticker)\max_file_size = 0.064


#MPF_Boundary = "---------------------------0123456789"



Procedure.i Telegram_PostText_OLD(api_token.s,chat_id.s,txt.s,disable_webpage_preview.b=#True,notify.b=#True)
  PrepareChatID
  If Len(txt)>#Telegram_TextMaximum
    Debug "txt can be max "+Str(#Telegram_TextMaximum)+" characters long"
    ProcedureReturn 0
  EndIf
  If FindString(txt,"#")
    Debug "consider using Telegram_PostSpecialText() for messages containing the # symbol"
  EndIf
  u.s = "https://api.telegram.org/bot"+api_token+"/"+TelegramMessageType(#TelegramMessageType_Text)\php_name+"?chat_id="+chat_id+"&parse_mode=html"
  If disable_webpage_preview : u + "&disable_web_page_preview=true" : EndIf
  If Not notify : u + "&disable_notification="+ByteUntruth(notify) : EndIf
  ;R(u) : end
  u + "&text="+URLEncoder(txt)
  HttpRequest.i = HTTPRequest(#PB_HTTP_Post,u)
  HandleTelegramPostingResponse
  ProcedureReturn status
EndProcedure


Procedure.i Telegram_PostText(api_token.s,chat_id.s,txt.s,disable_webpage_preview.b=#True,notify.b=#True) ; for sending messages that contain the hash symbol
  PrepareChatID
  
  BoundaryLen.i = StringByteLength(#MPF_Boundary, #PB_UTF8)
  
  tPost.s = #CRLF$ + "--"+#MPF_Boundary + #CRLF$
  tPost + "Content-Disposition: form-data; name="+c34+TelegramMessageType(#TelegramMessageType_Text)\field_name+c34 + #CRLF$
  tPost + "Content-Type: text/plain" + #CRLF$
  tPost + #CRLF$
  tPost + txt
  tPostLen.i = StringByteLength(tPost, #PB_UTF8)
  
  TotalMemsize.i = tPostLen + 2+2+BoundaryLen+2+2
  
  *Buffer = AllocateMemory(TotalMemsize, #PB_Memory_NoClear)
  If Not *Buffer
    Debug "could not allocate memory"
    ProcedureReturn 0
  EndIf
  *BufferPosition = *Buffer
  
  PokeS(*BufferPosition, tPost, -1, #PB_UTF8|#PB_String_NoZero) : *BufferPosition+tPostLen
  PokeS(*BufferPosition, #CRLF$+"--"+#MPF_Boundary+"--"+#CRLF$, -1, #PB_UTF8|#PB_String_NoZero) : *BufferPosition + 2+2+BoundaryLen+2+2
  
  ;R("Projected size: "+Str(TotalMemsize)+c13+"BufferPosition: "+Str(*BufferPosition-*Buffer)+c13+"Memory size: "+Str(MemorySize(*Buffer)))
  
;   rfn.s = "P:\gif_exper\"+Str(Date())+".txt"
;   rf = CreateFile(#PB_Any,rfn)
;   WriteData(rf,*Buffer,MemorySize(*Buffer))
;   CloseFile(rf)
;   RunProgram(rfn)
  
  NewMap Header.s()
  Header("Content-Type") = "multipart/form-data; boundary=" + #MPF_Boundary
  Header("Content-Length") = Str(MemorySize(*Buffer))
  
  u.s = "https://api.telegram.org/bot"+api_token+"/"+TelegramMessageType(#TelegramMessageType_Text)\php_name+"?chat_id="+chat_id+"&parse_mode=html"
  ;If disable_webpage_preview : u + "&disable_web_page_preview=true" : EndIf
  If Not notify : u + "&disable_notification="+ByteUntruth(notify) : EndIf
  HttpRequest.i = HTTPRequestMemory(#PB_HTTP_Post, u, *Buffer, MemorySize(*Buffer), 0, Header())
  FreeMemory(*Buffer)
  HandleTelegramPostingResponse
  
  ProcedureReturn status
EndProcedure


Macro TG_WrapCaption
  cPost.s = #CRLF$ + "--"+#MPF_Boundary + #CRLF$
  cPost + "Content-Disposition: form-data; name="+c34+"caption"+c34 + #CRLF$
  cPost + "Content-Type: text/plain" + #CRLF$
  cPost + #CRLF$
  cPost + caption
  cPostLen.i = StringByteLength(cPost, #PB_UTF8)
EndMacro


Procedure.i Telegram_PostItem(api_token.s,chat_id.s,msgtype.b,fn.s,caption.s,disable_webpage_preview.b=#True,notify.b=#True)
  PrepareChatID
  
  If fn=""
    Debug "no file specified"
    ProcedureReturn 0
  EndIf
  If FileSize(fn)<0
    Debug "file does not exist"
    ProcedureReturn 0
  EndIf
  If FileSize(fn) > (TelegramMessageType(msgtype)\max_file_size * 1000 * 1000)
    Debug "FILE TOO BIG"
    ProcedureReturn 0
  EndIf
  
  ext.s = LCase(GetExtensionPart(fn))
  
  If msgtype=#TelegramMessageType_Sticker
    Select ext
      Case "webp", "tgs"
      Default
        Debug "this format is not acceptable for a sticker"
        ProcedureReturn 0
    EndSelect
  EndIf
  
  If caption<>""
    If msgtype=#TelegramMessageType_Videomessage Or msgtype=#TelegramMessageType_Sticker
      Debug "This type cannot have a caption."
      ProcedureReturn 0
    EndIf
    If Len(caption)>#Telegram_CaptionMaximum
      Debug "caption can be max "+Str(#Telegram_CaptionMaximum)+" characters long"
      ProcedureReturn 0
    EndIf
  EndIf
  If ext="webp"
    Select msgtype
        Case #TelegramMessageType_Video, #TelegramMessageType_Image
      Debug "webp won't work with this posttype"
      ProcedureReturn 0
    Case #TelegramMessageType_Animation
      Debug "this will present as a file, not an animation"
    EndSelect
  EndIf
  
  f.i = ReadFile(#PB_Any, fn)
  If f
    FileLen.i = Lof(f)
    
    Post.s = "--" + #MPF_Boundary + #CRLF$
    Post + "Content-Disposition: form-data; name="+c34+TelegramMessageType(msgtype)\field_name+c34+"; filename="+c34+GetFilePart(fn)+c34 + #CRLF$
    Post + "Content-Type: "+MimeType(ext) + #CRLF$
    Post + #CRLF$
    ;R(Post)
    PostLen.i = StringByteLength(Post, #PB_UTF8)
    
    BoundaryLen.i = StringByteLength(#MPF_Boundary, #PB_UTF8)
    
    TG_WrapCaption
    
    *Buffer = AllocateMemory(PostLen + FileLen + cPostLen + 2+2+BoundaryLen+2+2, #PB_Memory_NoClear)
    *BufferPosition = *Buffer
    
    PokeS(*BufferPosition, Post, -1, #PB_UTF8|#PB_String_NoZero) : *BufferPosition+PostLen
    
    If ReadData(f, *BufferPosition, FileLen) = FileLen
      *BufferPosition+FileLen
      ;PokeS(*BufferPosition, #CRLF$+"--"+#MPF_Boundary+"--"+#CRLF$, -1, #PB_UTF8|#PB_String_NoZero) : *BufferPosition + 2+2+BoundaryLen+2+2
      
      PokeS(*BufferPosition, cPost, -1, #PB_UTF8|#PB_String_NoZero) : *BufferPosition+cPostLen
      
      PokeS(*BufferPosition, #CRLF$+"--"+#MPF_Boundary+"--"+#CRLF$, -1, #PB_UTF8|#PB_String_NoZero) : *BufferPosition + 2+2+BoundaryLen+2+2
      
      NewMap Header.s()
      Header("Content-Type") = "multipart/form-data; boundary=" + #MPF_Boundary
      Header("Content-Length") = Str(MemorySize(*Buffer))
      
      u.s = "https://api.telegram.org/bot"+api_token+"/"+TelegramMessageType(msgtype)\php_name+"?chat_id="+chat_id+"&parse_mode=html"
      If disable_webpage_preview : u + "&disable_web_page_preview=true" : EndIf
      If Not notify : u + "&disable_notification="+ByteUntruth(notify) : EndIf
      ;u + "&caption="+URLEncoder(caption)
      HttpRequest.i = HTTPRequestMemory(#PB_HTTP_Post, u, *Buffer, MemorySize(*Buffer), 0, Header())
      HandleTelegramPostingResponse
    EndIf
    FreeMemory(*Buffer)
    CloseFile(f)
  EndIf
  ProcedureReturn status
EndProcedure



Procedure.i Telegram_PostItemWithThumbnail(api_token.s,chat_id.s,msgtype.b,fn.s,thumb_fn.s,caption.s,disable_webpage_preview.b=#True,notify.b=#True) ; doesn't seem to work
  PrepareChatID
  
  If fn=""
    Debug "no file specified"
    ProcedureReturn 0
  EndIf
  If FileSize(fn)<0
    Debug "file does not exist"
    ProcedureReturn 0
  EndIf
  If FileSize(fn) > (TelegramMessageType(msgtype)\max_file_size * 1000 * 1000)
    Debug "FILE TOO BIG"
    ProcedureReturn 0
  EndIf
  
  ext.s = LCase(GetExtensionPart(fn))
  
  If msgtype=#TelegramMessageType_Sticker
    Select ext
      Case "webp", "tgs"
      Default
        Debug "this format is not acceptable for a sticker"
        ProcedureReturn 0
    EndSelect
  EndIf
  
  If caption<>""
    If msgtype=#TelegramMessageType_Videomessage Or msgtype=#TelegramMessageType_Sticker
      Debug "This type cannot have a caption."
      ProcedureReturn 0
    EndIf
    If Len(caption)>#Telegram_CaptionMaximum
      Debug "caption can be max "+Str(#Telegram_CaptionMaximum)+" characters long"
      ProcedureReturn 0
    EndIf
  EndIf
  If ext="webp"
    Select msgtype
      Case #TelegramMessageType_Video, #TelegramMessageType_Image
        Debug "webp won't work with this posttype"
        ProcedureReturn 0
      Case #TelegramMessageType_Animation
        Debug "this will present as a file, not an animation"
    EndSelect
  EndIf
  
  
  
  Select msgtype
    Case #TelegramMessageType_Audio, #TelegramMessageType_File, #TelegramMessageType_Video, #TelegramMessageType_Animation, #TelegramMessageType_Videomessage
    Default
      Debug "thumbnails will not work with this post type"
      ProcedureReturn 0
  EndSelect
  
  If thumb_fn=""
    Debug "no thumb file specified"
    ProcedureReturn 0
  EndIf
  If LCase(GetExtensionPart(thumb_fn))<>"jpg"
    Debug "thumb file is not JPEG"
    ProcedureReturn 0
  EndIf
  If FileSize(thumb_fn)<0
    Debug "thumb file does not exist"
    ProcedureReturn 0
  EndIf
  If FileSize(thumb_fn) > (0.2 * 1000 * 1000)
    Debug "THUMB FILE TOO BIG"
    ProcedureReturn 0
  EndIf
  
  
  f.i = ReadFile(#PB_Any, fn)
  If Not f
    Debug "could not read file!"
    ProcedureReturn 0
  EndIf
  FileLen.i = Lof(f)
  
  tf.i = ReadFile(#PB_Any, thumb_fn)
  If Not tf
    Debug "could not read thumb file!"
    ProcedureReturn 0
  EndIf
  tFileLen.i = Lof(tf)
  
  BoundaryLen.i = StringByteLength(#MPF_Boundary, #PB_UTF8)
  
  Post.s = #CRLF$ + "--"+#MPF_Boundary + #CRLF$
  Post + "Content-Disposition: form-data; name="+c34+TelegramMessageType(msgtype)\field_name+c34+"; filename="+c34+GetFilePart(fn)+c34 + #CRLF$
  Post + "Content-Type: "+MimeType(ext) + #CRLF$
  Post + #CRLF$
  PostLen.i = StringByteLength(Post, #PB_UTF8)
  
  tPost.s = #CRLF$ + "--"+#MPF_Boundary + #CRLF$
  tPost + "Content-Disposition: form-data; name="+c34+"thumbnail.jpg"+c34 + #CRLF$
  tPost + "Content-Type: "+MimeType("jpg") + #CRLF$
  tPost + #CRLF$
  tPostLen.i = StringByteLength(tPost, #PB_UTF8)
  
  TG_WrapCaption
  
  TotalMemsize.i = PostLen+FileLen + tPostLen+tFileLen + cPostLen + 2+2+BoundaryLen+2+2
  
  *Buffer = AllocateMemory(TotalMemsize, #PB_Memory_NoClear)
  If Not *Buffer
    Debug "could not allocate memory"
    CloseFile(f)
    CloseFile(tf)
    ProcedureReturn 0
  EndIf
  *BufferPosition = *Buffer
  
  PokeS(*BufferPosition, tPost, -1, #PB_UTF8|#PB_String_NoZero) : *BufferPosition+tPostLen
  ReadData(tf, *BufferPosition, tFileLen) : *BufferPosition+tFileLen
  CloseFile(tf)
  
  PokeS(*BufferPosition, Post, -1, #PB_UTF8|#PB_String_NoZero) : *BufferPosition+PostLen
  ReadData(f, *BufferPosition, FileLen) : *BufferPosition+FileLen
  CloseFile(f)
  
  PokeS(*BufferPosition, cPost, -1, #PB_UTF8|#PB_String_NoZero) : *BufferPosition+cPostLen
  
  PokeS(*BufferPosition, #CRLF$+"--"+#MPF_Boundary+"--"+#CRLF$, -1, #PB_UTF8|#PB_String_NoZero) : *BufferPosition + 2+2+BoundaryLen+2+2
  
  ;R("Projected size: "+Str(TotalMemsize)+c13+"BufferPosition: "+Str(*BufferPosition-*Buffer)+c13+"Memory size: "+Str(MemorySize(*Buffer)))
  
;   rfn.s = "P:\gif_exper\"+Str(Date())+".txt"
;   rf = CreateFile(#PB_Any,rfn)
;   WriteData(rf,*Buffer,MemorySize(*Buffer))
;   CloseFile(rf)
;   RunProgram(rfn)
  
  NewMap Header.s()
  Header("Content-Type") = "multipart/form-data; boundary=" + #MPF_Boundary
  Header("Content-Length") = Str(MemorySize(*Buffer))
  
  u.s = "https://api.telegram.org/bot"+api_token+"/"+TelegramMessageType(msgtype)\php_name+"?chat_id="+chat_id+"&parse_mode=html"
  ;If disable_webpage_preview : u + "&disable_web_page_preview=true" : EndIf
  If Not notify : u + "&disable_notification="+ByteUntruth(notify) : EndIf
  ;u + "&caption="+URLEncoder(caption)
  ;u + "&thumb=attach://thumbnail.jpg"
  u + "&thumb=attach%3A%2F%2Fthumbnail.jpg"
  HttpRequest.i = HTTPRequestMemory(#PB_HTTP_Post, u, *Buffer, MemorySize(*Buffer), 0, Header())
  FreeMemory(*Buffer)
  HandleTelegramPostingResponse
  
  ProcedureReturn status
EndProcedure



Procedure.i Telegram_PostPBImage(api_token.s,chat_id.s,img.i,imageplugin.i,caption.s,disable_webpage_preview.b=#True,notify.b=#True,msgtype.b=#TelegramMessageType_Image,give_filename.s="")
  PrepareChatID
  
  If Not IsImage(img)
    Debug "no image!"
    ProcedureReturn 0
  EndIf
  
  If msgtype=#TelegramMessageType_Image
    imageplugin = #PB_ImagePlugin_JPEG ; because Telegram will convert it to a JPEG anyway, unless you specify msgtype=#TelegramMessageType_File
  EndIf
  Select imageplugin
    Case #PB_ImagePlugin_JPEG
      mime.s = "jpeg"
    Case #PB_ImagePlugin_PNG
      mime.s = "png"
    Default
      Debug "don't know imageplugin format"
      ProcedureReturn 0
  EndSelect
  *ImgBuffer = EncodeImage(img,imageplugin)
  
  
  Post.s = "--" + #MPF_Boundary + #CRLF$
  Post + "Content-Disposition: form-data; name="+c34+TelegramMessageType(msgtype)\field_name+c34+"; filename="+c34+give_filename+c34 + #CRLF$
  Post + "Content-Type: image/"+mime + #CRLF$
  Post + #CRLF$
  
  PostLen.i = StringByteLength(Post, #PB_UTF8)
  FileLen.i = MemorySize(*ImgBuffer)
  BoundaryLen.i = StringByteLength(#MPF_Boundary, #PB_UTF8)
  
  TG_WrapCaption
  
  *Buffer = AllocateMemory(PostLen + FileLen + cPostLen + 2+2+BoundaryLen+2+2, #PB_Memory_NoClear)
  *BufferPosition = *Buffer
  
  PokeS(*BufferPosition, Post, -1, #PB_UTF8|#PB_String_NoZero) : *BufferPosition+PostLen
  
  If CopyMemory(*ImgBuffer, *BufferPosition, FileLen) : *BufferPosition+FileLen
    
    PokeS(*BufferPosition, cPost, -1, #PB_UTF8|#PB_String_NoZero) : *BufferPosition+cPostLen
    
    PokeS(*BufferPosition, #CRLF$ + "--" + #MPF_Boundary + "--" + #CRLF$, -1, #PB_UTF8|#PB_String_NoZero) : *BufferPosition+2+2+BoundaryLen+2+2
    
    NewMap Header.s()
    Header("Content-Type") = "multipart/form-data; boundary=" + #MPF_Boundary
    Header("Content-Length") = Str(MemorySize(*Buffer))
    
    u.s = "https://api.telegram.org/bot"+api_token+"/"+TelegramMessageType(msgtype)\php_name+"?chat_id="+chat_id+"&parse_mode=html"
    If disable_webpage_preview : u + "&disable_web_page_preview=true" : EndIf
    If Not notify : u + "&disable_notification="+ByteUntruth(notify) : EndIf
    ;u + "&caption="+URLEncoder(caption)
    HttpRequest.i = HTTPRequestMemory(#PB_HTTP_Post, u, *Buffer, MemorySize(*Buffer), 0, Header())
    HandleTelegramPostingResponse
  EndIf
  FreeMemory(*ImgBuffer)
  FreeMemory(*Buffer)
  
  ProcedureReturn status
  
EndProcedure



Procedure.i Telegram_PostOnlineImage(api_token.s,chat_id.s,imgu.s,caption.s,disable_webpage_preview.b=#True,notify.b=#True,msgtype.b=#TelegramMessageType_Image,give_filename.s="")
  PrepareChatID
  
  If imgu=""
    Debug "no image URL!"
    ProcedureReturn 0
  EndIf
  
  Post.s = "--" + #MPF_Boundary + #CRLF$
  Post + "Content-Disposition: form-data; name="+c34+TelegramMessageType(msgtype)\field_name+c34 + #CRLF$
  Post + "Content-Type: text/plain" + #CRLF$
  Post + #CRLF$
  Post + imgu
  PostLen.i = StringByteLength(Post, #PB_UTF8)
  
  BoundaryLen.i = StringByteLength(#MPF_Boundary, #PB_UTF8)
  
  TG_WrapCaption
  
  *Buffer = AllocateMemory(PostLen + cPostLen + 2+2+BoundaryLen+2+2, #PB_Memory_NoClear)
  *BufferPosition = *Buffer
  
  PokeS(*BufferPosition, Post, -1, #PB_UTF8|#PB_String_NoZero) : *BufferPosition+PostLen
  
  PokeS(*BufferPosition, cPost, -1, #PB_UTF8|#PB_String_NoZero) : *BufferPosition+cPostLen
  
  PokeS(*BufferPosition, #CRLF$ + "--" + #MPF_Boundary + "--" + #CRLF$, -1, #PB_UTF8|#PB_String_NoZero) : *BufferPosition+2+2+BoundaryLen+2+2
  
  NewMap Header.s()
  Header("Content-Type") = "multipart/form-data; boundary=" + #MPF_Boundary
  Header("Content-Length") = Str(MemorySize(*Buffer))
  
  u.s = "https://api.telegram.org/bot"+api_token+"/"+TelegramMessageType(msgtype)\php_name+"?chat_id="+chat_id+"&parse_mode=html"
  If disable_webpage_preview : u + "&disable_web_page_preview=true" : EndIf
  If Not notify : u + "&disable_notification="+ByteUntruth(notify) : EndIf
  HttpRequest.i = HTTPRequestMemory(#PB_HTTP_Post, u, *Buffer, MemorySize(*Buffer), 0, Header())
  HandleTelegramPostingResponse
  FreeMemory(*Buffer)
  
  ProcedureReturn status
  
EndProcedure




Structure Telegram_PhotoStructure
  type.s
  media.s
  caption.s
  parse_mode.s
EndStructure

Structure Telegram_VideoStructure
  type.s
  media.s
  caption.s
  parse_mode.s
EndStructure


Structure TelegramAlbumItemInfoStructure
  fn.s
  f.i
  fileLen.i
  Post.s
  PostLen.i
  caption.s
EndStructure

Structure Telegram_AlbumItemStructure
  fn.s
  caption.s
EndStructure

Procedure.i Telegram_PostAlbum(api_token.s,chat_id.s,msgtype.b,List tempinfo.Telegram_AlbumItemStructure(),Array msg_id.i(1),notify.b=#True)
  PrepareChatID
  
  files = ListSize(tempinfo())
  If files<2 Or files>10
    Debug "album files - min 2, max 10"
    ProcedureReturn 0
  EndIf
  
  ; duplicate check
  test_arr.s = #d1
  ForEach tempinfo()
    If FindString(test_arr,#d1+tempinfo()\fn+#d1)
      Debug "duplicate files cannot be sent"
      ProcedureReturn 0
    EndIf
    test_arr + tempinfo()\fn+#d1
  Next
  test_arr = ""
  
  Dim fileInfo.TelegramAlbumItemInfoStructure(files)
  
  a=0
  ForEach tempinfo()
    a+1
    fileInfo(a)\fn = tempinfo()\fn
    
    If FileSize(fileInfo(a)\fn)<0
      Debug "file #"+Str(a)+" does not exist "+fileInfo(a)\fn
      ProcedureReturn 0
    EndIf
    If FileSize(fileInfo(a)\fn) > (TelegramMessageType(msgtype)\max_file_size * 1000 * 1000)
      Debug "file #"+Str(a)+" too big"
      ProcedureReturn 0
    EndIf
    
    If Len(tempinfo()\caption)>#Telegram_CaptionMaximum
      Debug "caption can be max "+Str(#Telegram_CaptionMaximum)+" characters long"
      ProcedureReturn 0
    EndIf
    fileInfo(a)\caption = tempinfo()\caption
  Next
  
  
  
  ext.s = LCase(GetExtensionPart(fileInfo(1)\fn))
  
  If msgtype=#TelegramMessageType_Sticker
    Select ext
      Case "webp", "tgs"
      Default
        Debug "this format is not acceptable for a sticker"
        ProcedureReturn 0
    EndSelect
  EndIf
  
  If ext="webp"
    Select msgtype
      Case #TelegramMessageType_Video, #TelegramMessageType_Image
        Debug "webp won't work with this posttype"
        ProcedureReturn 0
      Case #TelegramMessageType_Animation
        Debug "this will present as a file, not an animation"
    EndSelect
  EndIf
  
  
  
  For a = 1 To files
    fileInfo(a)\f = ReadFile(#PB_Any, fileInfo(a)\fn)
    If Not fileInfo(a)\f
      Debug "could not read file!"
      Debug "FN: "+fileInfo(a)\fn
      ProcedureReturn 0
    EndIf
    fileInfo(a)\FileLen = Lof(fileInfo(a)\f)
  Next a
  
  
  BoundaryLen.i = StringByteLength(#MPF_Boundary, #PB_UTF8)
  
  TotalMemsize.i = 0
  js = CreateJSON(#PB_Any)
  jsarray = SetJSONArray(JSONValue(js))
  For a = 1 To files
    fileInfo(a)\post = #CRLF$+"--" + #MPF_Boundary + #CRLF$
    this_item.s = "albumfile"+Str(a)+"."+ext
    fileInfo(a)\post + "Content-Disposition: form-data; name="+c34+this_item+c34+"; filename="+c34+GetFilePart(fileInfo(a)\fn)+c34 + #CRLF$
    fileInfo(a)\post + "Content-Type: "+MimeType(ext) + #CRLF$
    fileInfo(a)\post + #CRLF$
    ;R(Post)
    fileInfo(a)\PostLen = StringByteLength(fileInfo(a)\post, #PB_UTF8)
    TotalMemsize + fileInfo(a)\PostLen+fileInfo(a)\FileLen;+2+2+BoundaryLen+2+2
    
    
    struc.Telegram_PhotoStructure
    struc\type = "photo"
    struc\media = "attach://"+this_item
    ;struc\media = "https://m.media-amazon.com/images/M/MV5BMTYwMDk0MTM1NV5BMl5BanBnXkFtZTgwNjI4MzIyMjE@._V1_.jpg"
    struc\caption = fileInfo(a)\caption
    struc\parse_mode = "html"
    jsarrayitem = AddJSONElement(jsarray)
    InsertJSONStructure(jsarrayitem, @struc, Telegram_PhotoStructure)
  Next a
  ;SetClipboardText(ComposeJSON(js)) : End
  ;Debug ComposeJSON(js)
  
  extrapost.s = #CRLF$+"--" + #MPF_Boundary + #CRLF$
  extrapost + "Content-Disposition: form-data; name="+c34+"media"+c34 + #CRLF$
  extrapost + "Content-Type: application/json" + #CRLF$
  extrapost + #CRLF$
  extrapost + ComposeJSON(js) + #CRLF$
  FreeJSON(js)
  extraPostLen.i = StringByteLength(extrapost, #PB_UTF8)
  TotalMemsize + extraPostLen +2+2+BoundaryLen+2+2
  
  
  
  *Buffer = AllocateMemory(TotalMemsize, #PB_Memory_NoClear)
  If Not *Buffer
    Debug "could not allocate memory"
    For a = 1 To files : CloseFile(fileInfo(a)\f) : Next a
    ProcedureReturn 0
  EndIf
  *BufferPosition = *Buffer
  
  PokeS(*BufferPosition, extraPost, extraPostLen, #PB_UTF8|#PB_String_NoZero) : *BufferPosition+extraPostLen
  
  For a = 1 To files
    PokeS(*BufferPosition, fileInfo(a)\post, fileInfo(a)\PostLen, #PB_UTF8|#PB_String_NoZero) : *BufferPosition+fileInfo(a)\PostLen
    ReadData(fileInfo(a)\f, *BufferPosition, fileInfo(a)\FileLen) : *BufferPosition + fileInfo(a)\FileLen
    CloseFile(fileInfo(a)\f)
  Next a
  
  PokeS(*BufferPosition, #CRLF$+"--"+#MPF_Boundary+"--"+#CRLF$, -1, #PB_UTF8|#PB_String_NoZero) : *BufferPosition + 2+2+BoundaryLen+2+2
  
  ;R("Projected size: "+Str(TotalMemsize) +c13+ "BufferPosition at end: "+Str(*BufferPosition-*Buffer) +c13+ "Memory size: "+Str(MemorySize(*Buffer)))
  
  NewMap Header.s()
  Header("Content-Type") = "multipart/form-data; boundary=" + #MPF_Boundary
  Header("Content-Length") = Str(MemorySize(*Buffer))
  
  ;R("OKAY") : ProcedureReturn
  u.s = "https://api.telegram.org/bot"+api_token+"/sendMediaGroup?chat_id="+chat_id
  If Not notify : u + "&disable_notification="+ByteUntruth(notify) : EndIf
  HttpRequest.i = HTTPRequestMemory(#PB_HTTP_Post, u, *Buffer, MemorySize(*Buffer), 0, Header())
  FreeMemory(*Buffer)
  
  
  rt.s = HTTPInfo(HTTPRequest, #PB_HTTP_Response)
  If HTTPInfo(HTTPRequest,#PB_HTTP_StatusCode)<>"200"
    Debug "ERROR: "+rt
    R("Proc: Telegram_PostAlbum"+c13+"ERROR IN HTTP REQUEST.")
    FinishHTTP(HttpRequest)
    ProcedureReturn #False
  EndIf
  FinishHTTP(HttpRequest)
  
  EnsureThisNotStart(rt,#TG_AllesOKResult)
  rt = Left(rt,Len(rt)-1)
  ;R(rt)
  ;Debug rt
  ;Debug "" : Debug "" : Debug "" : Debug "" ;: Debug "" : Debug "" : Debug "" : Debug ""
  j = 11
  CreateJSON(j)
  ParseJSON(j,rt)
  ;R(ComposeJSON(j,#PB_JSON_PrettyPrint))
  ObjectValue = JSONValue(j)
  Dim temp.TG_MessageStructure(0)
  ExtractJSONArray(ObjectValue,temp())
  FreeJSON(j)
  msgs = ArraySize(temp())+1
  ;R("ARRSIZE: "+Str(msgs))
  ReDim msg_id(msgs+1)
  For a = 1 To msgs
    ;R("#"+Str(a)+":"+c13+temp(a-1)\message_id)
    msg_id(a) = temp(a-1)\message_id
  Next a
  ProcedureReturn msgs
  
EndProcedure



Procedure.i Telegram_PostPoll(api_token.s,chat_id.s,txt.s,option_arr.s,option_delimiter.s,allow_multiple_selection.b,anonymous.b=#True,correct_option.i=0,explanation.s="",close_datelong.i=-1,notify.b=#True)
  PrepareChatID
  
  If txt=""
    Debug "poll question must be at least 1 character long"
    ProcedureReturn 0
  EndIf
  If Len(txt)>300
    Debug "poll question can be max 300 characters long"
    ProcedureReturn 0
  EndIf
  If Len(explanation)>200
    Debug "poll explanation can be max 200 characters long"
    ProcedureReturn 0
  EndIf
  
  If Right(option_arr,1)<>option_delimiter : option_arr+option_delimiter : EndIf
  options = CountString(option_arr,option_delimiter)
  If options<2
    Debug "min 2 options"
    ProcedureReturn 0
  EndIf
  If options>10
    Debug "max 10 options"
    ProcedureReturn 0
  EndIf
  optionjson.s = ArrayToSerializedJSON(option_arr,option_delimiter)
  
  ; parse_mode=html doesn't seem to work with polls - the question is shown as plain text
  u.s = "https://api.telegram.org/bot"+api_token+"/sendPoll?chat_id="+chat_id+"&parse_mode=html&question="+URLEncoder(txt)+"&options="+optionjson+"&is_anonymous="+ByteTruth(anonymous)
  If allow_multiple_selection
    u + "&allows_multiple_answers=true"
  EndIf
  If correct_option>0
    u + "&type=quiz&correct_option_id="+Str(correct_option-1)+"&explanation="+URLEncoder(explanation)
  EndIf
  If close_datelong>0
    u + "&close_date="+Str(close_datelong)
  EndIf
  If Not notify : u + "&disable_notification="+ByteUntruth(notify) : EndIf
  HttpRequest.i = HTTPRequest(#PB_HTTP_Post,u)
  HandleTelegramPostingResponse
  ProcedureReturn status
EndProcedure



Procedure.i Telegram_PostVenue(api_token.s,chat_id.s,latitude.f,longitude.f,title.s,address.s,foursquare_id.s,foursquare_type.s,google_place_id.s,google_place_type.s,notify.b=#True)
  PrepareChatID
  u.s = "https://api.telegram.org/bot"+api_token+"/sendVenue?chat_id="+chat_id+"&latitude="+StrF(latitude)+"&longitude="+StrF(longitude)+"&title="+title+"&address="+address+"&foursquare_id="+foursquare_id+"&foursquare_type="+foursquare_type+"&google_place_id="+google_place_id+"&google_place_type="+google_place_type
  If Not notify : u + "&disable_notification="+ByteUntruth(notify) : EndIf
  HttpRequest.i = HTTPRequest(#PB_HTTP_Post,u)
  HandleTelegramPostingResponse
  ProcedureReturn status
EndProcedure



Procedure.i Telegram_PostLocation(api_token.s,chat_id.s,latitude.f,longitude.f,horizontal_accuracy.f,live_period.i,heading.i,proximity_alert_radius.i,notify.b=#True)
  PrepareChatID
  u.s = "https://api.telegram.org/bot"+api_token+"/sendLocation?chat_id="+chat_id+"&latitude="+StrF(latitude)+"&longitude="+StrF(longitude)+"&horizontal_accuracy="+StrF(horizontal_accuracy)+"&live_period="+Str(live_period)+"&heading="+Str(heading)+"&proximity_alert_radius="+Str(proximity_alert_radius)
  If Not notify : u + "&disable_notification="+ByteUntruth(notify) : EndIf
  HttpRequest.i = HTTPRequest(#PB_HTTP_Post,u)
  HandleTelegramPostingResponse
  ProcedureReturn status
EndProcedure



Procedure.i Telegram_PostContact(api_token.s,chat_id.s,phone_number.i,first_name.s,last_name.s,vcard.s,notify.b=#True)
  PrepareChatID
  u.s = "https://api.telegram.org/bot"+api_token+"/sendContact?chat_id="+chat_id+"&phone_number="+phone_number+"&first_name="+first_name+"&last_name="+last_name+"&vcard="+vcard
  If Not notify : u + "&disable_notification="+ByteUntruth(notify) : EndIf
  HttpRequest.i = HTTPRequest(#PB_HTTP_Post,u)
  HandleTelegramPostingResponse
  ProcedureReturn status
EndProcedure




;-
;- SECONDARY MESSAGE FUNCTIONS

Procedure.b Telegram_StopPoll(api_token.s,chat_id.s,message_id.i)
  PrepareChatID
  u.s = "https://api.telegram.org/bot"+api_token+"/stopPoll?chat_id="+chat_id+"&message_id="+Str(message_id)
  HttpRequest.i = HTTPRequest(#PB_HTTP_Post,u)
  HandleTelegramResponse
  ProcedureReturn status
EndProcedure



Procedure.b Telegram_EditMessageText(api_token.s,chat_id.s,message_id.i,txt.s,disable_webpage_preview.b=#True) ; bot will need permission to "edit messages of others"
  PrepareChatID
  If Len(txt)>#Telegram_TextMaximum
    Debug "txt can be max "+Str(#Telegram_TextMaximum)+" characters long"
    ProcedureReturn 0
  EndIf
  u.s = "https://api.telegram.org/bot"+api_token+"/editMessageText?chat_id="+chat_id+"&message_id="+Str(message_id)+"&parse_mode=html"
  If disable_webpage_preview : u + "&disable_web_page_preview=true" : EndIf
  u + "&text="+URLEncoder(txt)
  HttpRequest.i = HTTPRequest(#PB_HTTP_Post,u)
  HandleTelegramResponse
  ProcedureReturn status
EndProcedure

Procedure.b Telegram_EditMessageCaption(api_token.s,chat_id.s,message_id.i,caption.s,disable_webpage_preview.b=#True) ; bot will need permission to "edit messages of others"
  PrepareChatID
  If Len(caption)>#Telegram_CaptionMaximum
    Debug "caption can be max "+Str(#Telegram_CaptionMaximum)+" characters long"
    ProcedureReturn 0
  EndIf
  u.s = "https://api.telegram.org/bot"+api_token+"/editMessageCaption?chat_id="+chat_id+"&message_id="+Str(message_id)+"&parse_mode=html"
  u + "&caption="+URLEncoder(caption)
  HttpRequest.i = HTTPRequest(#PB_HTTP_Post,u)
  HandleTelegramResponse
  ProcedureReturn status
EndProcedure



Procedure.b Telegram_PinMessage(api_token.s,chat_id.s,message_id.i,notify.b=#True)
  PrepareChatID
  u.s = "https://api.telegram.org/bot"+api_token+"/pinChatMessage?chat_id="+chat_id+"&message_id="+Str(message_id)
  If Not notify : u + "&disable_notification="+ByteUntruth(notify) : EndIf
  HttpRequest.i = HTTPRequest(#PB_HTTP_Post,u)
  HandleTelegramResponse
  ProcedureReturn status
EndProcedure

Procedure.b Telegram_UnpinMessage(api_token.s,chat_id.s,message_id.i)
  PrepareChatID
  u.s = "https://api.telegram.org/bot"+api_token+"/unpinChatMessage?chat_id="+chat_id+"&message_id="+Str(message_id)
  HttpRequest.i = HTTPRequest(#PB_HTTP_Post,u)
  HandleTelegramResponse
  ProcedureReturn status
EndProcedure

Procedure.b Telegram_UnpinAllMessages(api_token.s,chat_id.s)
  PrepareChatID
  u.s = "https://api.telegram.org/bot"+api_token+"/unpinAllChatMessages?chat_id="+chat_id
  HttpRequest.i = HTTPRequest(#PB_HTTP_Post,u)
  HandleTelegramResponse
  ProcedureReturn status
EndProcedure



Procedure.b Telegram_DeleteMessage(api_token.s,chat_id.s,message_id.i)
  PrepareChatID
  u.s = "https://api.telegram.org/bot"+api_token+"/deleteMessage?chat_id="+chat_id+"&message_id="+Str(message_id)
  HttpRequest.i = HTTPRequest(#PB_HTTP_Post,u)
  HandleTelegramResponse
  ProcedureReturn status
EndProcedure

Procedure.i Telegram_ForwardMessage(api_token.s,chat_id.s,from_chat_id.s,from_message_id.i,notify.b=#True)
  PrepareChatID
  PrepareNamedChatID(from_chat_id)
  u.s = "https://api.telegram.org/bot"+api_token+"/forwardMessage?chat_id="+chat_id+"&from_chat_id="+from_chat_id+"&message_id="+Str(from_message_id)
  If Not notify : u + "&disable_notification="+ByteUntruth(notify) : EndIf
  HttpRequest.i = HTTPRequest(#PB_HTTP_Post,u)
  HandleTelegramPostingResponse
  ProcedureReturn status
EndProcedure

Procedure.i Telegram_CopyMessage(api_token.s,chat_id.s,from_chat_id.s,from_message_id.i,notify.b=#True)
  PrepareChatID
  PrepareNamedChatID(from_chat_id)
  u.s = "https://api.telegram.org/bot"+api_token+"/copyMessage?chat_id="+chat_id+"&from_chat_id="+from_chat_id+"&message_id="+Str(from_message_id)
  If Not notify : u + "&disable_notification="+ByteUntruth(notify) : EndIf
  HttpRequest.i = HTTPRequest(#PB_HTTP_Post,u)
  HandleTelegramPostingResponse
  ProcedureReturn status
EndProcedure



Procedure.s Telegram_MessageURL(chat_username.s,message_id.i)
  ProcedureReturn "https://t.me/"+chat_username+"/"+Str(message_id)
EndProcedure

Procedure.s Telegram_MessageURLFromStructure(*msg.TG_MessageStructure)
  ProcedureReturn Telegram_MessageURL(*msg\chat\username,*msg\message_id)
EndProcedure




;-
;- STICKERS

Procedure.b Telegram_GetStickerSet(api_token.s,name.s,*stkrset.TG_StickerSetStructure)
  u.s = "https://api.telegram.org/bot"+api_token+"/getStickerSet?name=@"+name
  HttpRequest.i = HTTPRequest(#PB_HTTP_Post,u)
  
  rt.s = HTTPInfo(HTTPRequest, #PB_HTTP_Response)
  If HTTPInfo(HTTPRequest,#PB_HTTP_StatusCode)<>"200"
    Debug "ERROR: "+rt
    R("Proc: Telegram_GetStickerSet"+c13+"ERROR IN HTTP REQUEST.")
    FinishHTTP(HttpRequest)
    ProcedureReturn #False
  EndIf
  FinishHTTP(HttpRequest)
  
  EnsureThisNotStart(rt,#TG_AllesOKResult)
  rt = Left(rt,Len(rt)-1)
  ;Debug rt
  ;Debug "" : Debug "" : Debug "" : Debug "" ;: Debug "" : Debug "" : Debug "" : Debug ""
  j = 9
  CreateJSON(j)
  ParseJSON(j,rt)
  ;Debug "" : Debug ComposeJSON(j,#PB_JSON_PrettyPrint)
  ObjectValue = JSONValue(j)
  ExtractJSONStructure(ObjectValue,*stkrset.TG_StickerSetStructure,TG_StickerSetStructure)
  FreeJSON(j)
  
  ProcedureReturn #True
  
EndProcedure

Procedure.b Telegram_UploadStickerFile(api_token.s,fn.s,owner_user_id.i,*file.TG_FileStructure)
  
  If LCase(GetExtensionPart(fn))<>"png"
    Debug "sticker needs to be a PNG file"
    ProcedureReturn #False
  EndIf
  
  
  f.i = ReadFile(#PB_Any, fn)
  If Not f
    ProcedureReturn #False
  EndIf
  
  
  Post.s = "--" + #MPF_Boundary + #CRLF$
  Post + "Content-Disposition: form-data; name="+c34+"png_sticker"+c34 + #CRLF$
  Post + "Content-Type: "+MimeType("png") + #CRLF$
  Post + #CRLF$
  ;R(Post)
  
  PostLen.i = StringByteLength(Post, #PB_UTF8)
  FileLen.i = Lof(f)
  BoundaryLen.i = StringByteLength(#MPF_Boundary, #PB_UTF8)
  
  *Buffer = AllocateMemory(PostLen + FileLen + 2+2+BoundaryLen+2+2, #PB_Memory_NoClear)
  If Not *Buffer
    CloseFile(f)
    ProcedureReturn #False
  EndIf
  
  PokeS(*Buffer, Post, -1, #PB_UTF8|#PB_String_NoZero)
  
  If ReadData(f, *Buffer + PostLen, FileLen) = FileLen
    
    PokeS(*Buffer + PostLen + FileLen, #CRLF$+"--"+#MPF_Boundary+"--"+#CRLF$, -1, #PB_UTF8|#PB_String_NoZero)
    
    NewMap Header.s()
    Header("Content-Type") = "multipart/form-data; boundary=" + #MPF_Boundary
    Header("Content-Length") = Str(MemorySize(*Buffer))
    
    u.s = "https://api.telegram.org/bot"+api_token+"/uploadStickerFile?user_id="+Str(owner_user_id)
    HttpRequest.i = HTTPRequestMemory(#PB_HTTP_Post, u, *Buffer, MemorySize(*Buffer), 0, Header())
    
    rt.s = HTTPInfo(HTTPRequest, #PB_HTTP_Response)
    If HTTPInfo(HTTPRequest,#PB_HTTP_StatusCode)<>"200"
      Debug "ERROR: "+rt
      R("PROC: Telegram_UploadStickerFile"+c13+"ERROR IN HTTP REQUEST.")
      FinishHTTP(HttpRequest)
      ProcedureReturn #False
    EndIf
    FinishHTTP(HttpRequest)
    
    EnsureThisNotStart(rt,#TG_AllesOKResult)
    rt = Left(rt,Len(rt)-1)
    ;Debug rt
    ;Debug "" : Debug "" : Debug "" : Debug "" ;: Debug "" : Debug "" : Debug "" : Debug ""
    j = 9
    CreateJSON(j)
    ParseJSON(j,rt)
    ;Debug "" : Debug ComposeJSON(j,#PB_JSON_PrettyPrint)
    ObjectValue = JSONValue(j)
    ExtractJSONStructure(ObjectValue,*file.TG_FileStructure,TG_FileStructure)
    FreeJSON(j)
    
  Else
    FreeMemory(*Buffer)
    CloseFile(f)
    ProcedureReturn #False
  EndIf
  FreeMemory(*Buffer)
  CloseFile(f)
  
ProcedureReturn #True

EndProcedure

Procedure.b Telegram_CreateNewStickerSet(api_token.s,owner_user_id.i,fn.s,name.s,title.s,emojis.s,contains_masks.b,*mask_position.TG_MaskPositionStructure)
  
  ext.s = LCase(GetExtensionPart(fn))
  Select ext
    Case "png"
      field_name.s = "png_sticker"
    Case "tgs"
      field_name.s = "tgs_sticker"
    Default
      Debug "sticker needs to be a PNG or TGS file"
      ProcedureReturn #False
  EndSelect
  
  
  f.i = ReadFile(#PB_Any, fn)
  If Not f
    ProcedureReturn #False
  EndIf
  
  
  Post.s = "--" + #MPF_Boundary + #CRLF$
  Post + "Content-Disposition: form-data; name="+c34+field_name+c34 + #CRLF$
  Post + "Content-Type: "+MimeType(ext) + #CRLF$
  Post + #CRLF$
  ;R(Post)
  
  PostLen.i = StringByteLength(Post, #PB_UTF8)
  FileLen.i = Lof(f)
  BoundaryLen.i = StringByteLength(#MPF_Boundary, #PB_UTF8)
  
  *Buffer = AllocateMemory(PostLen + FileLen + 2+2+BoundaryLen+2+2, #PB_Memory_NoClear)
  If Not *Buffer
    CloseFile(f)
    ProcedureReturn #False
  EndIf
  
  PokeS(*Buffer, Post, -1, #PB_UTF8|#PB_String_NoZero)
  
  If ReadData(f, *Buffer + PostLen, FileLen) = FileLen
    
    PokeS(*Buffer + PostLen + FileLen, #CRLF$+"--"+#MPF_Boundary+"--"+#CRLF$, -1, #PB_UTF8|#PB_String_NoZero)
    
    NewMap Header.s()
    Header("Content-Type") = "multipart/form-data; boundary=" + #MPF_Boundary
    Header("Content-Length") = Str(MemorySize(*Buffer))
    
    mj = CreateJSON(10)
    InsertJSONStructure(mj,*mask_position,TG_MaskPositionStructure)
    u.s = "https://api.telegram.org/bot"+api_token+"/createNewStickerSet?user_id="+Str(owner_user_id)+"&name="+URLEncoder(name)+"&title="+URLEncoder(title)+"&emojis="+emojis+"&contains_masks="+ByteTruth(contains_masks)+"&mask_position="+URLEncoder(ComposeJSON(mj))
    FreeJSON(mj)
    HttpRequest.i = HTTPRequestMemory(#PB_HTTP_Post, u, *Buffer, MemorySize(*Buffer), 0, Header())
    HandleTelegramResponse
    
  Else
    FreeMemory(*Buffer)
    CloseFile(f)
    ProcedureReturn #False
  EndIf
  FreeMemory(*Buffer)
  CloseFile(f)
  
  ProcedureReturn status
  
EndProcedure

Procedure.b Telegram_AddStickerToSet(api_token.s,owner_user_id.i,fn.s,setName.s,emojis.s,*mask_position.TG_MaskPositionStructure)
  
  ext.s = LCase(GetExtensionPart(fn))
  Select ext
    Case "png"
      field_name.s = "png_sticker"
    Case "tgs"
      field_name.s = "tgs_sticker"
    Default
      Debug "sticker needs to be a PNG or TGS file"
      ProcedureReturn #False
  EndSelect
  
  
  f.i = ReadFile(#PB_Any, fn)
  If Not f
    ProcedureReturn #False
  EndIf
  
  
  Post.s = "--" + #MPF_Boundary + #CRLF$
  Post + "Content-Disposition: form-data; name="+c34+field_name+c34 + #CRLF$
  Post + "Content-Type: "+MimeType(ext) + #CRLF$
  Post + #CRLF$
  ;R(Post)
  
  PostLen.i = StringByteLength(Post, #PB_UTF8)
  FileLen.i = Lof(f)
  BoundaryLen.i = StringByteLength(#MPF_Boundary, #PB_UTF8)
  
  *Buffer = AllocateMemory(PostLen + FileLen + 2+2+BoundaryLen+2+2, #PB_Memory_NoClear)
  If Not *Buffer
    CloseFile(f)
    ProcedureReturn #False
  EndIf
  
  PokeS(*Buffer, Post, -1, #PB_UTF8|#PB_String_NoZero)
  
  If ReadData(f, *Buffer + PostLen, FileLen) = FileLen
    
    PokeS(*Buffer + PostLen + FileLen, #CRLF$+"--"+#MPF_Boundary+"--"+#CRLF$, -1, #PB_UTF8|#PB_String_NoZero)
    
    NewMap Header.s()
    Header("Content-Type") = "multipart/form-data; boundary=" + #MPF_Boundary
    Header("Content-Length") = Str(MemorySize(*Buffer))
    
    mj = CreateJSON(10)
    InsertJSONStructure(mj,*mask_position,TG_MaskPositionStructure)
    u.s = "https://api.telegram.org/bot"+api_token+"/addStickerToSet?user_id="+Str(owner_user_id)+"&name="+URLEncoder(setName)+"&emojis="+emojis+"&mask_position="+URLEncoder(ComposeJSON(mj))
    FreeJSON(mj)
    HttpRequest.i = HTTPRequestMemory(#PB_HTTP_Post, u, *Buffer, MemorySize(*Buffer), 0, Header())
    HandleTelegramResponse
    
  Else
    FreeMemory(*Buffer)
    CloseFile(f)
    ProcedureReturn #False
  EndIf
  FreeMemory(*Buffer)
  CloseFile(f)
  
  ProcedureReturn status
  
EndProcedure

Procedure.b Telegram_SetStickerPositionInSet(api_token.s,sticker.s,position.i)
  u.s = "https://api.telegram.org/bot"+api_token+"/setStickerPositionInSet?sticker="+sticker+"&position="+Str(position)
  HttpRequest.i = HTTPRequest(#PB_HTTP_Post,u)
  HandleTelegramResponse
  ProcedureReturn status
EndProcedure

Procedure.b Telegram_DeleteStickerFromSet(api_token.s,sticker.s)
  u.s = "https://api.telegram.org/bot"+api_token+"/deleteStickerFromSet?sticker="+sticker
  HttpRequest.i = HTTPRequest(#PB_HTTP_Post,u)
  HandleTelegramResponse
  ProcedureReturn status
EndProcedure

Procedure.b Telegram_SetStickerSetThumb(api_token.s,owner_user_id.i,setName.s,fn.s)
  
  If LCase(GetExtensionPart(fn))<>"png"
    Debug "stickerSet thumbnail needs to be a PNG file"
    ProcedureReturn #False
  EndIf
  
  
  f.i = ReadFile(#PB_Any, fn)
  If Not f
    ProcedureReturn #False
  EndIf
  
  
  Post.s = "--" + #MPF_Boundary + #CRLF$
  Post + "Content-Disposition: form-data; name="+c34+"thumb"+c34 + #CRLF$
  Post + "Content-Type: "+MimeType("png") + #CRLF$
  Post + #CRLF$
  ;R(Post)
  
  PostLen.i = StringByteLength(Post, #PB_UTF8)
  FileLen.i = Lof(f)
  BoundaryLen.i = StringByteLength(#MPF_Boundary, #PB_UTF8)
  
  *Buffer = AllocateMemory(PostLen + FileLen + 2+2+BoundaryLen+2+2, #PB_Memory_NoClear)
  If Not *Buffer
    CloseFile(f)
    ProcedureReturn #False
  EndIf
  
  PokeS(*Buffer, Post, -1, #PB_UTF8|#PB_String_NoZero)
  
  If ReadData(f, *Buffer + PostLen, FileLen) = FileLen
    
    PokeS(*Buffer + PostLen + FileLen, #CRLF$+"--"+#MPF_Boundary+"--"+#CRLF$, -1, #PB_UTF8|#PB_String_NoZero)
    
    NewMap Header.s()
    Header("Content-Type") = "multipart/form-data; boundary=" + #MPF_Boundary
    Header("Content-Length") = Str(MemorySize(*Buffer))
    
    u.s = "https://api.telegram.org/bot"+api_token+"/setStickerSetThumb?name="+setName+"&user_id="+Str(owner_user_id)
    HttpRequest.i = HTTPRequestMemory(#PB_HTTP_Post, u, *Buffer, MemorySize(*Buffer), 0, Header())
    HandleTelegramResponse
  Else
    FreeMemory(*Buffer)
    CloseFile(f)
    ProcedureReturn #False
  EndIf
  FreeMemory(*Buffer)
  CloseFile(f)
  
ProcedureReturn status

EndProcedure







;-
;- CHAT (GROUP OR CHANNEL) STUFF

Procedure.b Telegram_SetChatTitle(api_token.s,chat_id.s,new_title.s)
  PrepareChatID
  If Len(new_title)>255
    Debug "new title is too long (255 characters)"
    ProcedureReturn #False
  EndIf
  u.s = "https://api.telegram.org/bot"+api_token+"/setChatTitle?chat_id="+chat_id+"&title="+URLEncoder(new_title)
  HttpRequest.i = HTTPRequest(#PB_HTTP_Post,u)
  HandleTelegramResponse
  ProcedureReturn status
EndProcedure

Procedure.b Telegram_SetChatDescription(api_token.s,chat_id.s,new_desc.s)
  PrepareChatID
  If Len(new_desc)>255
    Debug "new title is too long (255 characters)"
    ProcedureReturn #False
  EndIf
  u.s = "https://api.telegram.org/bot"+api_token+"/setChatDescription?chat_id="+chat_id+"&description="+URLEncoder(new_desc)
  HttpRequest.i = HTTPRequest(#PB_HTTP_Post,u)
  HandleTelegramResponse
  ProcedureReturn status
EndProcedure


Procedure.b Telegram_SetChatPhoto(api_token.s,chat_id.s,fn.s)
  PrepareChatID
  
  If fn=""
    Debug "no file specified"
    ProcedureReturn 0
  EndIf
  If FileSize(fn)<0
    Debug "file does not exist"
    ProcedureReturn 0
  EndIf
  If FileSize(fn) > (TelegramMessageType(#TelegramMessageType_Image)\max_file_size * 1000 * 1000)
    Debug "FILE TOO BIG"
    ProcedureReturn 0
  EndIf
  
  ext.s = LCase(GetExtensionPart(fn))
  
  f.i = ReadFile(#PB_Any, fn)
  If f
    
    Post.s = "--" + #MPF_Boundary + #CRLF$
    Post + "Content-Disposition: form-data; name="+c34+"photo"+c34+"; filename="+c34+GetFilePart(fn)+c34 + #CRLF$
    Post + "Content-Type: "+MimeType(ext) + #CRLF$
    Post + #CRLF$
    ;R(Post)
    
    PostLen.i = StringByteLength(Post, #PB_UTF8)
    FileLen.i = Lof(f)
    BoundaryLen.i = StringByteLength(#MPF_Boundary, #PB_UTF8)
    
    *Buffer = AllocateMemory(PostLen + FileLen + 2+2+BoundaryLen+2+2, #PB_Memory_NoClear)
    If *Buffer
      PokeS(*Buffer, Post, -1, #PB_UTF8|#PB_String_NoZero)
      
      If ReadData(f, *Buffer + PostLen, FileLen) = FileLen
        
        PokeS(*Buffer + PostLen + FileLen, #CRLF$+"--"+#MPF_Boundary+"--"+#CRLF$, -1, #PB_UTF8|#PB_String_NoZero)
        
        NewMap Header.s()
        Header("Content-Type") = "multipart/form-data; boundary=" + #MPF_Boundary
        Header("Content-Length") = Str(MemorySize(*Buffer))
        
        u.s = "https://api.telegram.org/bot"+api_token+"/setChatPhoto?chat_id="+chat_id
        HttpRequest.i = HTTPRequestMemory(#PB_HTTP_Post, u, *Buffer, MemorySize(*Buffer), 0, Header())
        HandleTelegramResponse
      EndIf
      FreeMemory(*Buffer)
    EndIf
    CloseFile(f)
  EndIf
  ProcedureReturn status
  
EndProcedure

Procedure.b Telegram_SetChatPhotoPBImage(api_token.s,chat_id.s,img.i)
  PrepareChatID
  
  If Not IsImage(img)
    Debug "no image!"
    ProcedureReturn 0
  EndIf
  
  imageplugin = #PB_ImagePlugin_JPEG ; because Telegram will convert it to a JPEG anyway
  mime.s = "jpeg"
  *ImgBuffer = EncodeImage(img,imageplugin)
  If Not *ImgBuffer
    Debug "image encoding to jpeg failed!"
    ProcedureReturn 0
  EndIf
  
  
  Post.s = "--" + #MPF_Boundary + #CRLF$
  Post + "Content-Disposition: form-data; name="+c34+"photo"+c34+"; filename="+c34+give_filename+c34 + #CRLF$
  Post + "Content-Type: image/"+mime + #CRLF$
  Post + #CRLF$
  
  PostLen.i = StringByteLength(Post, #PB_UTF8)
  FileLen.i = MemorySize(*ImgBuffer)
  BoundaryLen.i = StringByteLength(#MPF_Boundary, #PB_UTF8)
  
  *Buffer = AllocateMemory(PostLen + FileLen + 2+2+StringByteLength(#MPF_Boundary,#PB_UTF8)+2+2, #PB_Memory_NoClear)
  *BufferPosition = *Buffer
  
  PokeS(*BufferPosition, Post, -1, #PB_UTF8|#PB_String_NoZero) : *BufferPosition+PostLen
  
  If CopyMemory(*ImgBuffer, *BufferPosition, FileLen) : *BufferPosition+FileLen
    
    PokeS(*BufferPosition, #CRLF$ + "--" + #MPF_Boundary + "--" + #CRLF$, -1, #PB_UTF8|#PB_String_NoZero) : *BufferPosition+2+2+BoundaryLen+2+2
    
    NewMap Header.s()
    Header("Content-Type") = "multipart/form-data; boundary=" + #MPF_Boundary
    Header("Content-Length") = Str(MemorySize(*Buffer))
    
    u.s = "https://api.telegram.org/bot"+api_token+"/setChatPhoto?chat_id="+chat_id
    HttpRequest.i = HTTPRequestMemory(#PB_HTTP_Post, u, *Buffer, MemorySize(*Buffer), 0, Header())
    HandleTelegramResponse
  EndIf
  FreeMemory(*ImgBuffer)
  FreeMemory(*Buffer)
  
  ProcedureReturn status
  
EndProcedure

Procedure.b Telegram_DeleteChatPhoto(api_token.s,chat_id.s)
  PrepareChatID
  u.s = "https://api.telegram.org/bot"+api_token+"/deleteChatPhoto?chat_id="+chat_id
  HttpRequest.i = HTTPRequest(#PB_HTTP_Post,u)
  HandleTelegramResponse
  ProcedureReturn status
EndProcedure



Procedure.b Telegram_SetChatStickerSet(api_token.s,chat_id.s,set_name.s)
  PrepareChatID
  u.s = "https://api.telegram.org/bot"+api_token+"/setChatStickerSet?chat_id="+chat_id+"&sticker_set_name="+set_name
  HttpRequest.i = HTTPRequest(#PB_HTTP_Post,u)
  HandleTelegramResponse
  ProcedureReturn status
EndProcedure

Procedure.b Telegram_DeleteChatStickerSet(api_token.s,chat_id.s)
  PrepareChatID
  u.s = "https://api.telegram.org/bot"+api_token+"/deleteChatStickerSet?chat_id="+chat_id
  HttpRequest.i = HTTPRequest(#PB_HTTP_Post,u)
  HandleTelegramResponse
  ProcedureReturn status
EndProcedure



Procedure.i Telegram_GetChatMembersCount(api_token.s,chat_id.s)
  PrepareChatID
  u.s = "https://api.telegram.org/bot"+api_token+"/getChatMembersCount?chat_id="+chat_id
  HttpRequest.i = HTTPRequest(#PB_HTTP_Post,u)
  If HttpRequest
    rt.s = HTTPInfo(HTTPRequest, #PB_HTTP_Response)
    If HTTPInfo(HTTPRequest,#PB_HTTP_StatusCode)="200"
      ;Debug rt
      EnsureThisNotStart(rt,#TG_AllesOKResult)
      rt = Left(rt,Len(rt)-1)
      count.i = Val(rt)
    Else
      Debug "ERROR: "+rt
    EndIf
    FinishHTTP(HttpRequest)
  EndIf
  ProcedureReturn count
EndProcedure


; this function gets you info about a user relative to a particular chat, ie. his permissions inside that chat
; more info: https://core.telegram.org/bots/api#getchatmember
Procedure.b Telegram_GetChatMember(api_token.s,chat_id.s,user_id.i,*cp.TG_ChatMemberStructure)
  PrepareChatID
  u.s = "https://api.telegram.org/bot"+api_token+"/getChatMember?chat_id="+chat_id+"&user_id="+Str(user_id)
  HttpRequest.i = HTTPRequest(#PB_HTTP_Post,u)
  
  If HttpRequest
    rt.s = HTTPInfo(HTTPRequest, #PB_HTTP_Response)
    If HTTPInfo(HTTPRequest,#PB_HTTP_StatusCode)="200"
      FinishHTTP(HttpRequest)
      ;Debug rt
      EnsureThisNotStart(rt,#TG_AllesOKResult)
      rt = Left(rt,Len(rt)-1)
      
      j = 2
      CreateJSON(j)
      ParseJSON(j,rt)
      ;json.s = ComposeJSON(j)
      
      ExtractJSONStructure(JSONValue(j),*cp,TG_ChatMemberStructure)
      FreeJSON(j)
      
      ;Debug "ALL OK"
      ProcedureReturn #True
    Else
      Debug "ERROR: "+rt
    EndIf
    FinishHTTP(HttpRequest)
  EndIf
  
  ProcedureReturn status
  
EndProcedure


Procedure.b Telegram_BanChatMember(api_token.s,chat_id.s,user_id.i,until_dl.i=0) ; bot will need permission to "edit messages of others"
  PrepareChatID
  u.s = "https://api.telegram.org/bot"+api_token+"/kickChatMember?chat_id="+chat_id+"&user_id="+Str(user_id)
  If until_dl>0
    u + "&until_date="+Str(until_dl)
  EndIf
  HttpRequest.i = HTTPRequest(#PB_HTTP_Post,u)
  HandleTelegramResponse
  ProcedureReturn status
EndProcedure

Procedure.b Telegram_RemoveChatMemberWithoutBanning(api_token.s,chat_id.s,user_id.i) ; bot will need permission to "edit messages of others"
  PrepareChatID
  u.s = "https://api.telegram.org/bot"+api_token+"/unbanChatMember?chat_id="+chat_id+"&user_id="+Str(user_id)+"&only_if_banned=true"
  HttpRequest.i = HTTPRequest(#PB_HTTP_Post,u)
  HandleTelegramResponse
  ProcedureReturn status
EndProcedure

Procedure.b Telegram_UnbanChatMember(api_token.s,chat_id.s,user_id.i) ; bot will need permission to "edit messages of others"
  PrepareChatID
  u.s = "https://api.telegram.org/bot"+api_token+"/unbanChatMember?chat_id="+chat_id+"&user_id="+Str(user_id)
  HttpRequest.i = HTTPRequest(#PB_HTTP_Post,u)
  HandleTelegramResponse
  ProcedureReturn status
EndProcedure


Structure TG_ChatPermissionsStructure
  can_send_messages.b
  can_send_media_messages.b
  can_send_polls.b
  can_send_other_messages.b
  can_add_web_page_previews.b
  can_change_info.b
  can_invite_users.b
  can_pin_messages.b
EndStructure

Procedure.b Telegram_SetChatMemberPermissions(api_token.s,chat_id.s,user_id.i,*cp.TG_ChatPermissionsStructure) ; bot will need permission to "ban users"
  PrepareChatID
  
  j = 7
  CreateJSON(j)
  InsertJSONStructure(JSONValue(j),*cp,TG_ChatPermissionsStructure)
  json.s = ComposeJSON(j)
  FreeJSON(j)
  For b = 0 To 1
    json = ReplaceString(json,c34+":"+Str(b)+","+c34,c34+":"+ByteTruth(b)+","+c34)
    json = ReplaceString(json,c34+":"+Str(b)+"}",c34+":"+ByteTruth(b)+"}")
  Next b
  ;R(json)
  u.s = "https://api.telegram.org/bot"+api_token+"/restrictChatMember?chat_id="+chat_id+"&user_id="+Str(user_id)+"&permissions="+json
  HttpRequest.i = HTTPRequest(#PB_HTTP_Post,u)
  HandleTelegramResponse
  ProcedureReturn status
EndProcedure

#TG_Permission_SendMessages = "can_send_messages"
#TG_Permission_SendMediaMessages = "can_send_media_messages"
#TG_Permission_SendPolls = "can_send_polls"
#TG_Permission_SendOtherMessages = "can_send_other_messages"
#TG_Permission_AddWebPagePreviews = "can_add_web_page_previews"
#TG_Permission_ChangeInfo = "can_change_info"
#TG_Permission_InviteUsers = "can_invite_users"
#TG_Permission_PinMessages = "can_pin_messages"

Procedure.b Telegram_SetChatMemberPermission(api_token.s,chat_id.s,user_id.i,permission.s,allowed.b) ; bot will need permission to "ban users"
  PrepareChatID
  json.s = "{"+c34+permission+c34+":"+ByteTruth(allowed)+"}"
  u.s = "https://api.telegram.org/bot"+api_token+"/restrictChatMember?chat_id="+chat_id+"&user_id="+Str(user_id)+"&permissions="+json
  HttpRequest.i = HTTPRequest(#PB_HTTP_Post,u)
  HandleTelegramResponse
  ProcedureReturn status
EndProcedure

Procedure.b Telegram_SetChatMemberPermissionsMap(api_token.s,chat_id.s,user_id.i,Map cp.b()) ; bot will need permission to "ban users"
  PrepareChatID
  j = 7
  CreateJSON(j)
  InsertJSONMap(JSONValue(j),cp())
  json.s = ComposeJSON(j)
  FreeJSON(j)
  For b = 0 To 1
    json = ReplaceString(json,c34+":"+Str(b)+","+c34,c34+":"+ByteTruth(b)+","+c34)
    json = ReplaceString(json,c34+":"+Str(b)+"}",c34+":"+ByteTruth(b)+"}")
  Next b
  ;R(json)
  u.s = "https://api.telegram.org/bot"+api_token+"/restrictChatMember?chat_id="+chat_id+"&user_id="+Str(user_id)+"&permissions="+json
  HttpRequest.i = HTTPRequest(#PB_HTTP_Post,u)
  HandleTelegramResponse
  ProcedureReturn status
EndProcedure




;-

Structure TG_UserProfilePhotosStructure
  total_count.i
  Array photos.TG_PhotoSizeStructure(1,1)
EndStructure

Procedure.i Telegram_DownloadUserProfilePhotos(api_token.s,user_id.i,folder.s,from_number.i=0,limit.i=100)
  If FileSize(folder)<>-2
    Debug "folder does not exist!"
    ProcedureReturn 0
  EndIf
  
  u.s = "https://api.telegram.org/bot"+api_token+"/getUserProfilePhotos?user_id="+Str(user_id)+"&offset="+Str(from_number)+"&limit="+limit
  HttpRequest.i = HTTPRequest(#PB_HTTP_Post,u)
  If HttpRequest
    rt.s = HTTPInfo(HTTPRequest, #PB_HTTP_Response)
    If HTTPInfo(HTTPRequest,#PB_HTTP_StatusCode)="200"
      FinishHTTP(HttpRequest)
      ;Debug rt
      EnsureThisNotStart(rt,#TG_AllesOKResult)
      rt = Left(rt,Len(rt)-1)
      
      j = 3
      CreateJSON(j)
      ParseJSON(j,rt)
      ;SetClipboardText(rt)
      ;R(ComposeJSON(j,#PB_JSON_PrettyPrint))
      
      ExtractJSONStructure(JSONValue(j),@up.TG_UserProfilePhotosStructure,TG_UserProfilePhotosStructure)
      FreeJSON(j)
      up\total_count-from_number
      
      ;R("PHOTOS: "+Str(up\total_count)+Chr(13)+"ARRAY SIZE: "+ArraySize(up\photos(),0))
      For a = 0 To up\total_count-1
        largest_fs.i = 0
        largest_fn.s = ""
        For b = 0 To 2
          ;Debug Str(a)+","+Str(b)+": *"+up\photos(a,b)\file_id+"*"
          If up\photos(a,b)\file_size > largest_fs
            largest_fs = up\photos(a,b)\file_size
            largest_fn = up\photos(a,b)\file_id
          EndIf
        Next b
        If Telegram_GetFile(api_token,largest_fn,folder+largest_fn+".jpg")
          images+1
        EndIf
      Next a
      
      
      ;Debug "ALL OK"
      ProcedureReturn images
    Else
      Debug "ERROR: "+rt
    EndIf
    FinishHTTP(HttpRequest)
  EndIf
  ProcedureReturn status
EndProcedure

; WARNING: this procedure will add the JPEG decoder to your program
Procedure.i Telegram_GetUserProfilePhotos(api_token.s,user_id.i,Array img.i(1),from_number.i=0,limit.i=100)
  u.s = "https://api.telegram.org/bot"+api_token+"/getUserProfilePhotos?user_id="+Str(user_id)+"&offset="+Str(from_number)+"&limit="+limit
  HttpRequest.i = HTTPRequest(#PB_HTTP_Post,u)
  If HttpRequest
    rt.s = HTTPInfo(HTTPRequest, #PB_HTTP_Response)
    If HTTPInfo(HTTPRequest,#PB_HTTP_StatusCode)="200"
      FinishHTTP(HttpRequest)
      ;Debug rt
      EnsureThisNotStart(rt,#TG_AllesOKResult)
      rt = Left(rt,Len(rt)-1)
      ;SetClipboardText(rt)
      
      j = 4
      CreateJSON(j)
      ParseJSON(j,rt)
      ;R(ComposeJSON(j,#PB_JSON_PrettyPrint))
      ExtractJSONStructure(JSONValue(j),@up.TG_UserProfilePhotosStructure,TG_UserProfilePhotosStructure)
      FreeJSON(j)
      up\total_count-from_number
      
      ;R("PHOTOS: "+Str(up\total_count)+Chr(13)+"ARRAY SIZE: "+ArraySize(up\photos(),0))
      images.i = 0
      For a = 0 To up\total_count-1
        largest_fs.i = 0
        largest_fn.s = ""
        For b = 0 To 2
          ;Debug Str(a)+","+Str(b)+": *"+up\photos(a,b)\file_id+"*"
          If up\photos(a,b)\file_size > largest_fs
            largest_fs = up\photos(a,b)\file_size
            largest_fn = up\photos(a,b)\file_id
          EndIf
        Next b
        *buffer = Telegram_GetFileToMemory(api_token,largest_fn)
        ;UseJPEGImageDecoder()
        images+1 : If ArraySize(img())<images : ReDim img(images) : EndIf
        img(images) = CatchImage(#PB_Any,*buffer)
        FreeMemory(*buffer)
      Next a
      
      ReDim img(images)
      ProcedureReturn images
    Else
      Debug "ERROR: "+rt
      FinishHTTP(HttpRequest)
    EndIf
  EndIf
  ProcedureReturn status
EndProcedure







;-
;- UPDATES STUFF

Structure TG_UserLedgerEntry_Structure
  first_name.s
  last_name.s
  username.s
  is_bot.b
EndStructure
Global TelegramUserLedgerFile.s
Global NewMap TelegramUserLedger.TG_UserLedgerEntry_Structure()

Procedure.b Telegram_LearnUserLedger()
  If TelegramUserLedgerFile=""
    Debug "no ledger file set!"
    ProcedureReturn #False
  EndIf
  ClearMap(TelegramUserLedger())
  
  f = ReadFile(#PB_Any,TelegramUserLedgerFile)
  If f
    While Not Eof(f)
      t.s = ReadString(f)
      If t="" : Continue : EndIf
      id.s = StringField(t,1,#d1)
      With TelegramUserLedger(id)
        \username = StringField(t,2,#d1)
        \first_name = StringField(t,3,#d1)
        \last_name = StringField(t,4,#d1)
        \is_bot = ValB(StringField(t,5,#d1))
      EndWith
    Wend
    CloseFile(f)
  EndIf
  
  ProcedureReturn #True
  
EndProcedure

Procedure.b Telegram_InstantiateLedger(fn.s)
  TelegramUserLedgerFile = fn
  Telegram_LearnUserLedger()
EndProcedure

Procedure.b Telegram_LedgeriseUser(*u.TG_UserStructure)
  
  key.s = Str(*u\id)
  If Not FindMapElement(TelegramUserLedger(),key)
    With TelegramUserLedger(key)
      \username = *u\username
      \first_name = *u\first_name
      \last_name = *u\last_name
      \is_bot = *u\is_bot
    EndWith
  EndIf
  
EndProcedure

Procedure.i Telegram_FindUserByName(first_name.s,last_name.s)
  ForEach TelegramUserLedger()
    If TelegramUserLedger()\first_name=first_name And TelegramUserLedger()\last_name=last_name
      ProcedureReturn Val(MapKey(TelegramUserLedger()))
    EndIf
  Next
  ProcedureReturn 0
EndProcedure

Procedure.i Telegram_FindUserByUsername(username.s)
  ForEach TelegramUserLedger()
    If TelegramUserLedger()\username = username
      ProcedureReturn Val(MapKey(TelegramUserLedger()))
    EndIf
  Next
  ProcedureReturn 0
EndProcedure

Procedure.s Telegram_UserDisplayNameFromStructure(*u.TG_UserStructure)
  ProcedureReturn Trim(*u\first_name+" "+*u\last_name)
EndProcedure

Procedure.s Telegram_UserDisplayName(uidnum.i)
  key.s = Str(uidnum)
  If Not FindMapElement(TelegramUserLedger(),key)
    ProcedureReturn "[UNKNOWN-"+key+"]"
  EndIf
  ProcedureReturn Trim(TelegramUserLedger(key)\first_name+" "+TelegramUserLedger(key)\last_name)
EndProcedure

; if the user has set a username, this procedure returns a URL by which they can be reached from the Internet. Otherwise, it returns an empty string
Procedure.s Telegram_UserURL(user_id.i)
  key.s = Str(user_id)
  If FindMapElement(TelegramUserLedger(),key) And TelegramUserLedger(key)\username<>""
    ProcedureReturn "https://t.me/"+TelegramUserLedger(key)\username
  EndIf
  ProcedureReturn ""
EndProcedure

; if the user has set a username, this procedure returns a "link" by which they can be reached FROM WITHIN TELEGRAM. Otherwise, it returns an empty string
; Procedure.s Telegram_UserInternalLink(*TI.TG_BotInstance,user_id.i)
;   key.s = Str(user_id)
;   If FindMapElement(*TI\UserLedger(),key) And *TI\UserLedger(key)\username<>""
;     ProcedureReturn "@"+*TI\UserLedger(key)\username
;   EndIf
;   ProcedureReturn ""
; EndProcedure


Structure TG_UpdateStructure
  id.i
  type.s
  chat_username.s
  chat_id.s
  user.i
  file_id.s
  
  update_id.i
  message.TG_MessageStructure
  message_type.b
  edited_message.TG_MessageStructure
  channel_post.TG_MessageStructure
  edited_channel_post.TG_MessageStructure
  poll.TG_PollStructure
  poll_answer.TG_PollAnswerStructure
  inline_query.TG_InlineQueryStructure
  chosen_inline_result.TG_ChosenInlineResultStructure
  callback_query.TG_CallbackQueryStructure
  shipping_query.TG_ShippingQueryStructure
  pre_checkout_query.TG_PreCheckoutQueryStructure
EndStructure

Structure TG_BotInstance
  api_token.s
  UpdateCounterFile.s
  List update.TG_UpdateStructure()
EndStructure


#TU_Type_UNKNOWN = ""
#TU_Type_MessagePosted = "message"
#TU_Type_MessageEdited = "edited_message"
#TU_Type_ChannelMessagePosted = "channel_post"
#TU_Type_ChannelMessageEdited = "edited_channel_post"
#TU_Type_InlineQuery = "inline_query"
#TU_Type_ChosenInlineResult = "chosen_inline_result"
#TU_Type_CallbackQuery = "callback_query"
#TU_Type_ShippingQuery = "shipping_query"
#TU_Type_PreCheckoutQuery = "pre_checkout_query"
#TU_Type_Poll = "poll"
#TU_Type_PollAnswer = "poll_answer"

#TU_Type_NewChatParticipant = "new_chat_participant"
#TU_Type_NewChatMember = "new_chat_member"
#TU_Type_LeftChatMember = "left_chat_member"
#TU_Type_GroupCreated = "group_created"
#TU_Type_SupergroupCreated = "supergroup_created"
#TU_Type_ChannelCreated = "channel_created"
#TU_Type_ChatPhotoDeleted = "channel_photo_deleted"
#TU_Type_ChatTitleChanged = "chat_title_changed"


Procedure.b Telegram_InstantiateBot(*TI.TG_BotInstance,api_token.s,ucfn.s)
  If api_token=""
    Debug "no API token provided!"
    ProcedureReturn #False
  EndIf
  If ucfn=""
    Debug "no update-counter file provided!"
    ProcedureReturn #False
  EndIf
  ;   If ulfn=""
  ;     Debug "no user-ledger file provided!"
  ;     ProcedureReturn #False
  ;   EndIf
  With *TI
    \api_token = api_token
    \UpdateCounterFile = ucfn
    ;\UserLedgerFile = ulfn
    ;Telegram_LearnUserLedger(*TI)
  EndWith
EndProcedure

; Procedure.b Telegram_ConfineFutureUpdatesToTypes(*TI.TG_BotInstance,utarr.s,dlm.s) ; I'm not sure about this procedure. It will receive the first available update (if any are available) and then that update will never be processed
;   If utarr<>""
;     EnsureThisEnd(utarr,dlm)
;   EndIf
;   u.s = "https://api.telegram.org/bot"+*TI\api_token+"/getUpdates?limit=1&allowed_updates="+ArrayToSerializedJSON(utarr,dlm)
; EndProcedure

Procedure.b TG_IdentifyMessageType(*msg.TG_MessageStructure,*u.TG_UpdateStructure)
  With *msg
    If \animation\file_id
      *u\file_id = \animation\file_id
      ProcedureReturn #TelegramMessageType_Animation
    EndIf
    If \audio\file_id
      *u\file_id = \audio\file_id
      ProcedureReturn #TelegramMessageType_Audio
    EndIf
    If \document\file_id
      *u\file_id = \document\file_id
      ProcedureReturn #TelegramMessageType_File
    EndIf
    If \photo(0)\file_id
      *u\file_id = \photo(0)\file_id
      ProcedureReturn #TelegramMessageType_Image
    EndIf
    If \sticker\file_id
      *u\file_id = \sticker\file_id
      ProcedureReturn #TelegramMessageType_Sticker
    EndIf
    If \video\file_id
      *u\file_id = \video\file_id
      ProcedureReturn #TelegramMessageType_Video
    EndIf
    If \video_note\file_id
      *u\file_id = \video_note\file_id
      ProcedureReturn #TelegramMessageType_Videomessage
    EndIf
    If \voice\file_id
      *u\file_id = \voice\file_id
      ProcedureReturn #TelegramMessageType_Voicemessage
    EndIf
    If \contact\first_name Or \contact\last_name Or \contact\phone_number
      ProcedureReturn #TelegramMessageType_Contact
    EndIf
    If \location\latitude Or \location\longitude
      ProcedureReturn #TelegramMessageType_Location
    EndIf
    If \venue\address Or \venue\title
      ProcedureReturn #TelegramMessageType_Venue
    EndIf
    ProcedureReturn #TelegramMessageType_Text
  EndWith
EndProcedure


Procedure.b Telegram_GetNewUpdates(*TI.TG_BotInstance,max_wait_seconds.i=0)
  If *TI\api_token="" : R("API token not set!") : ProcedureReturn : EndIf
  
  f = ReadFile(#PB_Any,*TI\UpdateCounterFile)
  If f
    most_recent_update.i = Val(ReadString(f))
    ;R("MOST RECENT UPDATE, FROM FILE: "+Str(most_recent_update))
    CloseFile(f)
  EndIf
  start_most_recent_update.i = most_recent_update
  start_ledger_size.i = MapSize(TelegramUserLedger())
  
  ClearList(*TI\update())
  #MaxUpdatesPerRequest = 100
  
  Repeat
    ;utarr.s = "message|"
    ;R("REQUESTING UPDATES FROM #"+Str(most_recent_update+1)+" (mru+1)")
    ;max_wait_seconds=0 ;-FUCK!
    u.s = "https://api.telegram.org/bot"+*TI\api_token+"/getUpdates?limit="+Str(#MaxUpdatesPerRequest)+"&timeout="+Str(max_wait_seconds)+"&offset="+Str(most_recent_update+1);+"&a7llowed_updates="+ArrayToSerializedJSON(utarr,#d1)
    
    If max_wait_seconds=0
      HttpRequest.i = HTTPRequest(#PB_HTTP_Post,u)
      If Not HttpRequest
        ;R("Synchronous HTTPRequest failed. Exiting loop.")
        Break
      EndIf
    Else
      HttpRequest.i = HTTPRequest(#PB_HTTP_Post,u,"",#PB_HTTP_Asynchronous)
      If Not HttpRequest
        ;R("Asynchronous HTTPRequest failed. Exiting loop.")
        Break
      EndIf
      Repeat
        Progress = HTTPProgress(HTTPRequest)
        ;R("PROGRESS: "+Str(Progress))
        Select Progress
          Case #PB_HTTP_Success
            ;R("SUCCESS")
            Break
          Case #PB_HTTP_Failed
            ;R("Download failed")
            Break
          Case #PB_HTTP_Aborted
            ;R("Download aborted")
            Break
          Default
            ;R("Current progress: " + Str(Progress))
        EndSelect
        Delay(500)
      ForEver
    EndIf
    
    rt.s = HTTPInfo(HTTPRequest, #PB_HTTP_Response)
    If HTTPInfo(HTTPRequest,#PB_HTTP_StatusCode)<>"200"
      Debug "ERROR: "+rt
      R("ERROR IN HTTP REQUEST. BREAKING.")
      FinishHTTP(HttpRequest)
      Break
    Else
      FinishHTTP(HttpRequest)
    EndIf
    
    EnsureThisNotStart(rt,#TG_AllesOKResult)
    rt = Left(rt,Len(rt)-1)
    
    
    ;- FUCK!
;     f = ReadFile(#PB_Any,"P:\gif_exper\raw_json_text_pretty.txt")
;     rt.s = ""
;     While Not Eof(f)
;       rt + ReadString(f)+Chr(13)+Chr(10)
;     Wend
;     CloseFile(f)
    
    ;Debug rt
    ;Debug "" : Debug "" : Debug "" : Debug "" ;: Debug "" : Debug "" : Debug "" : Debug ""
    ;j = 8
    ;CreateJSON(j)
    j = ParseJSON(#PB_Any,rt)
    f = CreateFile(#PB_Any,"P:\gif_exper\raw_json_text_pretty.txt") : WriteStringN(f,ComposeJSON(j,#PB_JSON_PrettyPrint)) : CloseFile(f)
    rt = ""
    
    ;rt = ""
    ;Debug "" : Debug ComposeJSON(j,#PB_JSON_PrettyPrint)
    
    ObjectValue = JSONValue(j)
    arrsize.i = JSONArraySize(ObjectValue)
    If arrsize=0
      ;R("ZERO ARRSIZE. BREAKING")
      FreeJSON(j)
      Break
    EndIf
    
    ;bumf = CreateFile(#PB_Any,"P:\gif_exper\raw_json_text_pretty.txt") : WriteStringN(bumf,rt) : CloseFile(bumf)
    
    ;arrsize-1
    ;Debug "" : Debug "UPDATES RECEIVED IN THIS REQUEST: "+Str(arrsize)
    Dim raw_arr.TG_UpdateStructure(0)
    ExtractJSONArray(ObjectValue,raw_arr())
    FreeJSON(j)
    For a = 1 To arrsize
      With raw_arr(a-1)
        ;Debug "NEWS #"+Str(a+1)
        \id = \update_id
        BeatThis(most_recent_update,\id)
        ;Debug Str(a)+"/"+Str(arrsize)+" MRU="+Str(most_recent_update)
        \type = #TU_Type_UNKNOWN
        If \message\date
          ;Debug "message posted"
          \type = #TU_Type_MessagePosted
          \chat_username = \message\chat\username
          \chat_id = Str(\message\chat\id)
          \user = \message\from\id
          Telegram_LedgeriseUser(@raw_arr(a-1)\message\from)
          
          
          \message_type = TG_IdentifyMessageType(@raw_arr(a-1)\message,@raw_arr(a-1))
          
          
          If \message\new_chat_participant\id
            \type = #TU_Type_NewChatParticipant
          EndIf
          If \message\new_chat_members(0)\id
            \type = #TU_Type_NewChatMember
          EndIf
          If \message\left_chat_member\id
            \type = #TU_Type_LeftChatMember
          EndIf
          If \message\group_chat_created
            \type = #TU_Type_GroupCreated
          EndIf
          If \message\supergroup_chat_created
            \type = #TU_Type_SupergroupCreated
          EndIf
          If \message\channel_chat_created
            \type = #TU_Type_ChannelCreated
          EndIf
          If \message\delete_chat_photo
            \type = #TU_Type_ChatPhotoDeleted
          EndIf
          If \message\new_chat_title
            \type = #TU_Type_ChatTitleChanged
          EndIf
          
          
          
        Else
          If \edited_message\edit_date
            ;Debug "message edited"
            \type = #TU_Type_MessageEdited
            \chat_username = \edited_message\chat\username
            \chat_id = Str(\edited_message\chat\id)
            \user = \edited_message\from\id
            Telegram_LedgeriseUser(@raw_arr(a-1)\edited_message\from)
            \message_type = TG_IdentifyMessageType(@raw_arr(a-1)\edited_message,@raw_arr(a-1))
          Else
            If \channel_post\date
              ;Debug "channel message posted"
              \type = #TU_Type_ChannelMessagePosted
              \chat_username = \channel_post\chat\username
              \chat_id = Str(\channel_post\chat\id)
              \user = \channel_post\from\id
              Telegram_LedgeriseUser(@raw_arr(a-1)\channel_post\from)
            Else
              If \edited_channel_post\edit_date
                ;Debug "channel message edited"
                \type = #TU_Type_ChannelMessageEdited
                \chat_username = \edited_channel_post\chat\username
                \chat_id = Str(\edited_channel_post\chat\id)
                \user = \edited_channel_post\from\id
                Telegram_LedgeriseUser(@raw_arr(a-1)\edited_channel_post\from)
              Else
                If \inline_query\id
                  ;Debug "inline query"
                  \type = #TU_Type_InlineQuery
                  \chat_username = \edited_channel_post\chat\username
                  \chat_id = Str(\edited_channel_post\chat\id)
                Else
                  If \chosen_inline_result\result_id
                    ;Debug "chosen inline result"
                    \type = #TU_Type_ChosenInlineResult
                  Else
                    If \callback_query\id
                      ;Debug "callback query"
                      \type = #TU_Type_CallbackQuery
                    Else
                      If \shipping_query\id
                        ;Debug "shipping query"
                        \type = #TU_Type_ShippingQuery
                      Else
                        If \pre_checkout_query\id
                          ;Debug "pre checkout query"
                          \type = #TU_Type_PreCheckoutQuery
                        Else
                          If \poll\id
                            ;Debug "poll"
                            \type = #TU_Type_Poll
                          Else
                            If \poll_answer\poll_id
                              ;Debug "poll answered"
                              \type = #TU_Type_PollAnswer
                            Else
                              Debug "unknown update type"
                            EndIf
                          EndIf
                        EndIf
                      EndIf
                    EndIf
                  EndIf
                EndIf
              EndIf
            EndIf
          EndIf
        EndIf
        AddElement(*TI\update()) : CopyStructure(@raw_arr(a-1),*TI\update(),TG_UpdateStructure)
      EndWith
    Next a
    
    ReDim raw_arr(0)
    
    ;If max_wait_seconds>0
    ;  R("MAX WAIT SECONDS. BREAKING")
    ;  Break
    ;EndIf
    
    If arrsize<#MaxUpdatesPerRequest
      ;R("SUB ARRSIZE. BREAKING")
      Break
    EndIf
    
  ForEver
  ;FreeArray(raw_arr())
  
  c13.s{1}=Chr(13)
  ;R("START MRU: "+Str(start_most_recent_update)+c13+"MRU: "+Str(most_recent_update)+c13+c13+"START LS: "+Str(start_ledger_size)+c13+"LS: "+Str(MapSize(TelegramUserLedger())))
  ;R("New updates: "+Str(most_recent_update-start_most_recent_update)+Chr(13)+"New members: "+Str(MapSize(TelegramUserLedger())-start_ledger_size))
  If most_recent_update > start_most_recent_update ; new updates received
    f = CreateFile(#PB_Any,*TI\UpdateCounterFile)
    If f
      WriteStringN(f,Str(most_recent_update))
      CloseFile(f)
    EndIf
    If MapSize(TelegramUserLedger()) > start_ledger_size ; new members encountered
      f = CreateFile(#PB_Any,TelegramUserLedgerFile)
      If f
        ForEach TelegramUserLedger()
          t.s = MapKey(TelegramUserLedger())+#d1+TelegramUserLedger()\username+#d1+TelegramUserLedger()\first_name+#d1+TelegramUserLedger()\last_name+#d1+ByteTruth(TelegramUserLedger()\is_bot)+#d1
          WriteStringN(f,t)
        Next
        CloseFile(f)
      EndIf
    EndIf
  EndIf
  
  
  ProcedureReturn #True
  
EndProcedure




; IDE Options = PureBasic 5.73 LTS (Windows - x64)
; CursorPosition = 1303
; FirstLine = 319
; Folding = -LAAACAAAA+DAAGDAksJ7z-
; EnableXP