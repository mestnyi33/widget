; ============================
; =        ezOds.pbi         =
; ============================
; Module For Read And modify spreadsheets open/libre office "*.ods"
; PB 6.01 LTS
; Author - Kulrom (03/2023)
; Last Update: 07/09/2023

; v 0.4.0 fixed ODS::SaveOdsBook()  - create .bak file if rewrite .ods file.  07/09/2023

DeclareModule Ods
	#version$ = "0.4.0"
	; type constants for ODS cells
	#float = "float"
	#string = "string"
	#date = "date"
	#curency = "curency"
	
	Declare openOdsBook(filename$)
	Declare saveOdsBook(ods_id, filename$="")
	Declare freeOdsBook(ods_id)
	Declare.s getCellValue(ods_id, sheet, row, col)
	Declare.s getCellType(ods_id, sheet, row, col)
	Declare.s getCellStyle(ods_id, sheet, row, col)
	Declare setCellValue(ods_id, sheet, row, col, value$, type$, style$="")
	Declare DeleteRows(ods_id, sheet, row_id, n_rows=1)
	Declare AddRows(ods_id, sheet, row_id, n_rows=1)
	Declare getNRows(ods_id, sheet)
EndDeclareModule

Module Ods
EnableExplicit

;--------------Structures------------

Structure Sheet
	n_rows.i					; row number
	Array row_cash.i(65535)		; массив ссылок на узлы со строками array of pointers to nodes
	cash_is_ready.i				; Флаг актуальности кэша. При каждой операции записи кэш становится не актуальным
EndStructure

Structure Book
	filename$
	xml_id.i
	xml_node.i
	n_sheets.i
	Array sheet.Sheet(0)
EndStructure

;--------------Constants-------------------------------------------
#is_Save_xml =	#False  ; Константа указывает нужно ли сохранять xml на компьютер. Нужно для изучения структуры xml


;--------------Globals--------------------------------------------
Global NewMap __BOOKS_MAP.Book()
Global __BOOK_COUNTER = 1


UseZipPacker()


;------------Private_methods--------------------------------------

CompilerIf #is_Save_xml
	Procedure _save_xml(xml.i, fname$)
		FormatXML(xml, #PB_XML_ReFormat|#PB_XML_ReIndent, 2)
		SaveXML(xml, fname$)
	EndProcedure
CompilerEndIf


Procedure _fill_row_cash(*sheet.Sheet, *sheet_node)
	Protected row = 0
	
	; если кэш не готов
	If Not *sheet\cash_is_ready
		; считаем кол-во строк
		Protected *row_node = XMLNodeFromPath(*sheet_node, "table:table-row")
		If *row_node
			While *row_node
				If ArraySize(*sheet\row_cash()) < row
					ReDim *sheet\row_cash(row)
				EndIf
				Protected repeated_rows = Val(GetXMLAttribute(*row_node, "table:number-rows-repeated"))
				Protected node_name$ = GetXMLNodeName(*row_node)
				If node_name$ = "table:table-row"
					*sheet\row_cash(row) = *row_node
					row + 1
				; Если строки сгруппированы
				ElseIf node_name$ = "table:table-row-group"
					Protected *row_node_1 = ChildXMLNode(*row_node)
					While *row_node_1
						Protected repeated_rows_1 = Val(GetXMLAttribute(*row_node_1, "table:number-rows-repeated"))
						node_name$ = GetXMLNodeName(*row_node_1)
						If node_name$ = "table:table-row"
							*sheet\row_cash(row) = *row_node_1
							row + 1
						EndIf
						If repeated_rows_1
							row + repeated_rows_1 - 1
						EndIf
						*row_node_1 = NextXMLNode(*row_node_1)
					Wend
				EndIf
				
				If repeated_rows
					row + repeated_rows - 1
				EndIf
				
				*row_node = NextXMLNode(*row_node)
			Wend
			*sheet\n_rows = row
			*sheet\cash_is_ready = #True
		EndIf
	EndIf
EndProcedure


;/////////////////////////////////////////////////////////////////////
; Функция возвращает id xml объекта content.xml из ods файла filename$
Procedure _get_content_xml(filename$)
	Protected *buffer
	Protected ods_file, buffer_size, xml_id
	
	If FileSize(filename$) >= 0
		ods_file = OpenPack(#PB_Any, filename$)
		If ods_file
			If ExaminePack(ods_file)
				
				While NextPackEntry(ods_file)
					If PackEntryName(ods_file) = "content.xml"
						buffer_size = PackEntrySize(ods_file)
						*buffer = AllocateMemory(buffer_size)
						UncompressPackMemory(ods_file, *buffer, buffer_size)
						xml_id = CatchXML(#PB_Any, *buffer, buffer_size)
						FreeMemory(*buffer)
						ClosePack(ods_file)
						ProcedureReturn xml_id
					EndIf
				Wend
				
			EndIf
			ClosePack(ods_file)
		EndIf
	EndIf
EndProcedure


Procedure _get_cell_node_in_row(*row_node, col_id)
	Protected col = 0
	Protected *cell_node = XMLNodeFromPath(*row_node, "table:table-cell")
	
	While *cell_node
		Protected repeated_cols = Val(GetXMLAttribute(*cell_node, "table:number-columns-repeated"))
		repeated_cols + Val(GetXMLAttribute(*cell_node, "table:number-columns-spanned"))
		If GetXMLNodeName(*cell_node) = "table:table-cell"
			If col = col_id
				ProcedureReturn *cell_node
			EndIf
			
			col + 1
			
			If repeated_cols
				col + repeated_cols - 1
			EndIf
			
			If col_id < col
				Break
			EndIf
		EndIf
		*cell_node = NextXMLNode(*cell_node)
	Wend
EndProcedure


; Функция возвращает указатель на узел строки
Procedure _get_row_node(*sheet.Sheet, *sheet_node, row_id)
	If Not *sheet\cash_is_ready
		_fill_row_cash(*sheet, *sheet_node)
	EndIf
	
	ProcedureReturn *sheet\row_cash(row_id)
EndProcedure


;////////////////////////////////////////////////////////////////////
; Функция возвращает ссылку на узел листа
Procedure _get_sheet_node(*book_node, sheet_id)
	Protected sheet = 0
	Protected *sheet_node = XMLNodeFromPath(*book_node, "table:table")
	While *sheet_node
		If GetXMLNodeName(*sheet_node) = "table:table"
			If sheet_id = sheet
				ProcedureReturn *sheet_node
			EndIf
			sheet + 1
			*sheet_node = NextXMLNode(*sheet_node)
		EndIf
	Wend
EndProcedure


; Функция возвращает указатель на экземпляр книги
Procedure _get_book(book_id.i)
	Protected *book
	
	If FindMapElement(__BOOKS_MAP(), Str(book_id))
		ProcedureReturn @__BOOKS_MAP()
	Else
		ProcedureReturn #False
	EndIf
EndProcedure


Procedure _get_cell_node(ods_id, sheet, row, col)
	Protected *book.Book = _get_book(ods_id)
	Protected *sheet.Sheet = *book\sheet(sheet)
	Protected *sheet_node = _get_sheet_node(*book\xml_node, Sheet)
	If *sheet_node
		Protected *row_node = _get_row_node(*sheet, *sheet_node, row)
		If *row_node
			Protected *cell_node = _get_cell_node_in_row(*row_node, col)
			If *cell_node
				ProcedureReturn *cell_node
			EndIf
		EndIf
	EndIf
EndProcedure

; функия возвращает количество столбцов в строке и заполняет кэш
Procedure _fill_cell_cash(*row_node, Array cell_cash.i(1))
	Protected *cell_node = XMLNodeFromPath(*row_node, "table:table-cell")
	Protected col
	While *cell_node
		Protected repeated_cells = Val(GetXMLAttribute(*cell_node, "table:number-columns-repeated"))
		If GetXMLNodeName(*cell_node) = "table:table-cell"
			cell_cash(col) = *cell_node
			If repeated_cells
				col + repeated_cells
			Else
				col + 1
			EndIf
		EndIf
		*cell_node = NextXMLNode(*cell_node)
	Wend
	ProcedureReturn col
EndProcedure


; /////////////////////////////////////////////////////////////
; Процедура собирает новый файл ods
Procedure _repack_zip(file_in.s, file_out.s, *content_buffer, content_size)
	Protected *buffer, res = 1
	Protected buffer_size
	Protected entry_type
	Protected entry_name$
	Protected temp_file$, base_file$
	
	; Проверяем не совпадают ли исходный и результирующий файл по названию
	; Если совпадает, то создаём временный файл
	If file_out = file_in
		temp_file$ = file_in + ".bak"
		If Not CopyFile(file_in, temp_file$)
			ProcedureReturn #False
		EndIf
		file_in = temp_file$
	EndIf
	
	Protected zip_in = OpenPack(#PB_Any, file_in)
	Protected zip_out = CreatePack(#PB_Any, file_out)
	
	If zip_in
		If zip_out
			If ExaminePack(zip_in)
				While NextPackEntry(zip_in)
					entry_name$ = PackEntryName(zip_in)
					entry_type = PackEntryType(zip_in)
					buffer_size = PackEntrySize(zip_in)
					
					If entry_name$ = "content.xml"
						AddPackMemory(zip_out, *content_buffer, content_size, "content.xml")
						Continue
					EndIf
					If buffer_size																; Если это файл с размером
						*buffer = AllocateMemory(buffer_size)
						UncompressPackMemory(zip_in, *buffer, buffer_size)
						AddPackMemory(zip_out, *buffer, buffer_size, entry_name$)
						FreeMemory(*buffer)
					Else																		; Если это просто каталог
						AddPackMemory(zip_out, 0, 0, entry_name$)
					EndIf
				Wend
			EndIf
			ClosePack(zip_out)
		Else
			res = #False
		EndIf
		ClosePack(zip_in)
	Else
		res = #False
	EndIf
	ProcedureReturn res
EndProcedure


; процедура создаёт узел ячейки
Procedure _modify_cell_xml_node(*cell_node, value$, type$, style$="")
	If Not *cell_node
		ProcedureReturn #False
	EndIf
	
	SetXMLAttribute(*cell_node, "office:value-type", type$)
	
	If type$ = "float"
		SetXMLAttribute(*cell_node, "office:value", value$)
	ElseIf type$ = "date"
		SetXMLAttribute(*cell_node, "office:date-value", value$)
	ElseIf type$ = "currency"
		SetXMLAttribute(*cell_node, "office:value", value$)
	ElseIf type$ = "string"
		Protected *txt_node = XMLNodeFromPath(*cell_node, "text:p")
		If *txt_node
			DeleteXMLNode(*txt_node)
		EndIf
		*txt_node = CreateXMLNode(*cell_node, "text:p", -1)
		SetXMLNodeText(*txt_node, value$)
	EndIf
	
	If style$ <> ""
		SetXMLAttribute(*cell_node, "table:style-name", style$)
	EndIf
	
	ProcedureReturn *cell_node
EndProcedure

; процедура удаляет записи о строках из кэша и изменяет размер массива кэша
Procedure _delete_rows_from_cash(Array row_cash.i(1), row_id, n_rows=1)
	Protected row
	
	; сдвигаем элементы массива на место удалённых строк
	For row = row_id + n_rows To ArraySize(row_cash())
		row_cash(row - n_rows) = row_cash(row)
	Next
	
	; изменяем размер массива
	Protected old_size = ArraySize(row_cash())
	Protected new_size = old_size - n_rows
	ReDim row_cash(new_size)
EndProcedure

Procedure _add_rows_to_cash(Array row_cash.i(1), row_id, n_rows=1)
	Protected row, prev_size
	
	prev_size = ArraySize(row_cash())
	ReDim row_cash(prev_size + n_rows)
	
	; сдвигаем элементы массива
	If row_id = prev_size
		row_cash(prev_size + n_rows) = row_cash(row_id)
		row_cash(row_id) = 0
	Else
		For row = prev_size To row_id+1 Step -1
			row_cash(row + n_rows) = row_cash(row)
			row_cash(row) = 0
		Next
	EndIf
EndProcedure

Procedure _create_row_node(*previous_row_node, n_rows, cols_in_row, is_first_row = #False)
	Protected *new_rownode, *cell_node
	Protected *parent_node
	
	*parent_node = ParentXMLNode(*previous_row_node)
	*new_rownode = CreateXMLNode(*parent_node, "table:table-row", *previous_row_node)
	
	If is_first_row
		SetXMLAttribute(*new_rownode, "table:style-name", GetXMLAttribute(NextXMLNode(*previous_row_node), "table:style-name"))
	Else
		SetXMLAttribute(*new_rownode, "table:style-name", GetXMLAttribute(*previous_row_node, "table:style-name"))
	EndIf
	
	SetXMLAttribute(*new_rownode, "table:number-rows-repeated", Str(n_rows))
	*cell_node = CreateXMLNode(*new_rownode, "table:table-cell")
	SetXMLAttribute(*cell_node, "table:number-columns-repeated", Str(cols_in_row))
	ProcedureReturn  *new_rownode
EndProcedure


Procedure _get_n_cols(*sheet_node)
	Protected *column_node
	Protected n_cols, repeated_cols
	
	*column_node = ChildXMLNode(*sheet_node)
	While GetXMLNodeName(*column_node) = "table:table-column"
		repeated_cols = Val(GetXMLAttribute(*column_node, "table:number-columns-repeated"))
		If repeated_cols
			n_cols + repeated_cols
		Else
			n_cols + 1
		EndIf
		*column_node = NextXMLNode(*column_node)
	Wend
	ProcedureReturn n_cols
EndProcedure


;--------------Public_methods-----------------------------

;//////////////////////////////////////////////////////////////
; Конструктор нового документа
Procedure openOdsBook(filename$)
	Protected *root_node, *book_node, *sheet_node
	Protected *book.Book
	Protected xml_id, res, sheets
	
	xml_id = _get_content_xml(filename$)
	
	CompilerIf #is_Save_xml
		_save_xml(xml_id, "content.xml")
	CompilerEndIf
	
	If xml_id
		*root_node = RootXMLNode(xml_id)
		*book_node = XMLNodeFromPath(*root_node, "/office:document-content/office:body/office:spreadsheet")
		*sheet_node = ChildXMLNode(*book_node)
		__BOOKS_MAP(Str(__BOOK_COUNTER))\xml_id = xml_id
		__BOOKS_MAP(Str(__BOOK_COUNTER))\xml_node = *book_node
		__BOOKS_MAP(Str(__BOOK_COUNTER))\filename$ = filename$
		*book = @__BOOKS_MAP()
		res = __BOOK_COUNTER
		; Вычисляем количество вкладок
		While *sheet_node
			If GetXMLNodeName(*sheet_node) = "table:table"
				sheets + 1
			EndIf
			*sheet_node = NextXMLNode(*sheet_node)
		Wend
		
		*book\n_sheets = sheets
		ReDim *book\sheet(sheets-1)
	EndIf
	
	
	If res
		__BOOK_COUNTER + 1
		ProcedureReturn res
	Else
		ProcedureReturn #False
	EndIf
EndProcedure


Procedure saveOdsBook(ods_id, filename$="")
	Protected res
	Protected *book.Book = _get_book(ods_id)
	If *book
		
		If filename$ = ""
			filename$ = *book\filename$
		EndIf
		
		CompilerIf #is_Save_xml
			_save_xml(*book\xml_id, "content_out.xml")
		CompilerEndIf

		Protected bufer_size = ExportXMLSize(*book\xml_id)
		Protected *buffer = AllocateMemory(bufer_size)
		ExportXML(*book\xml_id, *buffer, bufer_size)
		If _repack_zip(*book\filename$, filename$, *buffer, bufer_size)
			res = #True
		EndIf
		FreeMemory(*buffer)
	EndIf
	ProcedureReturn res
EndProcedure


Procedure freeOdsBook(ods_id)
	Protected *book.Book = _get_book(ods_id)
	If *book
		FreeXML(*book\xml_id)
		Protected sheet, row
		For sheet = 0 To ArraySize(*book\sheet())
			FreeArray(*book\sheet(sheet)\row_cash())
		Next
		ClearStructure(*book, Book)
		DeleteMapElement(__BOOKS_MAP(), Str(ods_id))
	EndIf
EndProcedure


Procedure.s getCellValue(ods_id, sheet, row, col)
	Protected *cell_node = _get_cell_node(ods_id, sheet, row, col)
	If *cell_node
		Select GetXMLAttribute(*cell_node, "office:value-type")
			Case "float"
				ProcedureReturn GetXMLAttribute(*cell_node, "office:value")
			Case "currency"
				ProcedureReturn GetXMLAttribute(*cell_node, "office:value")
			Case "date"
				ProcedureReturn GetXMLAttribute(*cell_node, "office:date-value")
			Case "string"
				Protected *text_node = XMLNodeFromPath(*cell_node, "text:p")
				If *text_node
					ProcedureReturn GetXMLNodeText(*text_node)
				EndIf
		EndSelect
	Else
		ProcedureReturn ""
	EndIf
EndProcedure


Procedure.s getCellType(ods_id, sheet, row, col)
	Protected *cell_node = _get_cell_node(ods_id, sheet, row, col)
	If *cell_node
		ProcedureReturn GetXMLAttribute(*cell_node, "office:value-type")
	EndIf
EndProcedure


Procedure.s getCellStyle(ods_id, sheet, row, col)
	Protected *cell_node = _get_cell_node(ods_id, sheet, row, col)
	If *cell_node
		ProcedureReturn GetXMLAttribute(*cell_node, "table:style-name")
	EndIf
EndProcedure


Procedure getNRows(ods_id, sheet)
	Protected *book.Book = _get_book(ods_id)
	Protected *sheet.Sheet = *book\sheet(sheet)
	Protected *sheet_node = _get_sheet_node(*book\xml_node, sheet)
	_fill_row_cash(*sheet, *sheet_node)
	ProcedureReturn *sheet\n_rows
EndProcedure

; процедура записывает данные в ячейку
;@param ods_id: номер объекта ods. Получается в результате работы процедуры openOdsBook
;@param sheet: номер листа
;@param row: номер строки
;@param col: номер столбца
;@param value$: значение ячейки
;@param type$: тип данных. может быть "float", "string", "date", "currency"
;@param style$: Стиль ячейки. Стиль ячейки можно получить функцией getSellStyle()
Procedure setCellValue(ods_id, sheet, row, col, value$, type$, style$="")
	Protected *book.Book = _get_book(ods_id)
	
	If Not *book
		ProcedureReturn #False
	EndIf
	
	If sheet > ArraySize(*book\sheet())
		Debug #PB_Compiler_Procedure + ": Перебор по листам"
		ProcedureReturn #False
	EndIf
	Protected repeated_rows
	Protected *row_node, *new_row_node, *prev_row_node
	
	; Заполняем кэш, если он ещё не заполнен
	Protected *sheet.Sheet = *book\sheet(sheet)
	If Not *sheet\cash_is_ready
		_fill_row_cash(*sheet, _get_sheet_node(*book\xml_node, sheet))
	EndIf
	
	;{ блок подготовки строк
	If row > ArraySize(*sheet\row_cash())
		Debug #PB_Compiler_Procedure + ": Line " + #PB_Compiler_Line + ": Перебор по строкам"
		ProcedureReturn #False
	EndIf
	*row_node = *sheet\row_cash(row)
	If *row_node
		; обрабатываем случай когда есть такой узел в кэше
		repeated_rows = Val(GetXMLAttribute(*row_node, "table:number-rows-repeated"))
		If repeated_rows
			; обрабатываем случай когда выбранная строка пустая и имеет повторы
			If repeated_rows > 1
				*new_row_node = CopyXMLNode(*row_node, ParentXMLNode(*row_node), *row_node) 			; создаём копию строки и помещаем её следующей
				SetXMLAttribute(*row_node, "table:number-rows-repeated", "")							; Убираем повторы в текущей строке
				SetXMLAttribute(*new_row_node, "table:number-rows-repeated", Str(repeated_rows-1))		; В следующей строке делаем повторы
				*sheet\row_cash(row + 1) = *new_row_node												; добавляем новую строку в кэш
			EndIf
		Else 
			; обрабатываем случай когда выбранная строка не имеет повторов
		EndIf
	Else
		; Обрабатываем случай, когда нет такой строки в кэше
		; находим ближайшую предыдущую строку в кэше копируем её во все пустые ячейки
		Protected i = row
		While Not *sheet\row_cash(i)
			i - 1
		Wend
		*prev_row_node = *sheet\row_cash(i)
		repeated_rows = Val(GetXMLAttribute(*prev_row_node, "table:number-rows-repeated"))
		SetXMLAttribute(*prev_row_node, "table:number-rows-repeated", "")
		*new_row_node = *prev_row_node
		i + 1
		While Not *sheet\row_cash(i)
			*new_row_node = CopyXMLNode(*prev_row_node, ParentXMLNode(*prev_row_node), *new_row_node)  ; копируем строку, заполняем кэш на этом участке
			*sheet\row_cash(i) = *new_row_node
			i + 1
			If i > *sheet\n_rows-1
				Debug #PB_Compiler_Procedure + ": Перебор по строкам"
				ProcedureReturn #False
			EndIf
		Wend
	EndIf
	;} Конец блока подготовки строк
	
	;{ Блок подготовки ячеек
	*row_node = *sheet\row_cash(row)
	Dim cell_cash.i(65535)
	Protected n_cols = _fill_cell_cash(*row_node, cell_cash())		; заполняем кэш ячеек строки и получаем кол-во ячеек
	
	Protected *next_cell_node, *prev_cel_node, *new_cell_node
	Protected *cell_node = cell_cash(col)
	If *cell_node
		; Если ячейка есть в кэше
		Protected repeated_cells = Val(GetXMLAttribute(*cell_node, "table:number-columns-repeated"))
		If repeated_cells > 1
			; Обрабатываем случай когда ячейка пустая и есть повторы
			SetXMLAttribute(*cell_node, "table:number-columns-repeated", "")
			*next_cell_node = CopyXMLNode(*cell_node, ParentXMLNode(*cell_node), *cell_node)
			SetXMLAttribute(*next_cell_node, "table:number-columns-repeated", Str(repeated_cells-1))
			cell_cash(col+1) = *next_cell_node
		Else
			; Обрабатываем случай когда ячейка не имеет повторов
		EndIf
	Else
		; Обрабатываем случай, когда нет ячейки в кэше
		; Находим ближайшую ячейку в кэше
		i = col
		While Not cell_cash(i)
			i - 1
		Wend
		*prev_cel_node = cell_cash(i)
		repeated_cells = Val(GetXMLAttribute(*prev_cel_node, "table:number-columns-repeated"))
		SetXMLAttribute(*prev_cel_node, "table:number-columns-repeated", "")
		*new_cell_node = *prev_cel_node
		i + 1
		While Not cell_cash(i) And i < n_cols
			*new_cell_node = CopyXMLNode(*prev_cel_node, ParentXMLNode(*prev_cel_node), *new_cell_node)
			cell_cash(i) = *new_cell_node
			i + 1
			; If i > n_cols - 1
			; 	Debug "Перебор по столбцам"
			; 	ProcedureReturn #False
			; EndIf
		Wend
	EndIf
	;} конец блока подготовки ячеек
	
	*cell_node = cell_cash(col)
	FreeArray(cell_cash())
	If *cell_node
		_modify_cell_xml_node(*cell_node, value$, type$, style$)
	Else
		Debug #PB_Compiler_Procedure + ": Перебор по столбцам"
		ProcedureReturn #False
	EndIf
	
	ProcedureReturn #True
EndProcedure


Procedure DeleteRows(ods_id, sheet, row_id, n_rows=1)
	Protected *book.Book = _get_book(ods_id)
	
	If Not *book
		ProcedureReturn #False
	EndIf
	
	; делаем запись в 0-й столбец каждой строки. Это нужно для того чтобы точно создался узел в XML для каждой строки
	Protected row
	For row = row_id To row_id + n_rows - 1
		If Not setCellValue(ods_id, sheet, row, 0, "-1", "float")
			Debug "DeleteRow:  Перебор по строкам"
			ProcedureReturn #False
		EndIf
	Next
	
	For row = row_id To row_id +n_rows - 1
		DeleteXMLNode(*book\sheet(sheet)\row_cash(row))
	Next
	
	_delete_rows_from_cash(*book\sheet(sheet)\row_cash(), row_id, n_rows)
	
	ProcedureReturn #True
EndProcedure


Procedure AddRows(ods_id, sheet, row_id, n_rows=1)
	Protected *book.Book = _get_book(ods_id)
	Protected *sheet.Sheet = *book\sheet(sheet)
	Protected repeated_rows, row
	
	If Not *book
		ProcedureReturn #False
	EndIf
	
	If sheet > ArraySize(*book\sheet())
		Debug #PB_Compiler_Procedure + ": Перебор по листам"
		ProcedureReturn #False
	EndIf
	
	; Заполняем кэш строк, если он ещё не заполнен
	If Not *sheet\cash_is_ready
		_fill_row_cash(*sheet, _get_sheet_node(*book\xml_node, sheet))
	EndIf
	
	; добавляем строки в кэш
	_add_rows_to_cash(*sheet\row_cash(), row_id, n_rows)
	
	; TODO нужно разрабатывать
	Protected *row_node, *parrent_node, *new_rownode
	If row_id > 0
		*row_node = *sheet\row_cash(row_id + n_rows)
	Else
		; если вставляем самую первую строку
		; ищем первый узел со строкой
		*parrent_node = _get_sheet_node(*book\xml_node, sheet)
		*row_node = ChildXMLNode(*parrent_node)
		While GetXMLNodeName(*row_node) <> "table:table-row"
			*row_node = NextXMLNode(*row_node)
		Wend
		*new_rownode = _create_row_node(PreviousXMLNode(*row_node), n_rows, _get_n_cols(_get_sheet_node(*book\xml_node, sheet)), #True)
		*sheet\n_rows + n_rows
		*sheet\row_cash(0) = *new_rownode
		ProcedureReturn #True
	EndIf
	
	If *row_node
		; Если узел есть в кэше
		repeated_rows = Val(GetXMLAttribute(*row_node, "table:number-rows-repeated"))
		If repeated_rows > 1
			; Если есть повторы
			SetXMLAttribute(*row_node, "table:number-rows-repeated", Str(repeated_rows + n_rows))
			*sheet\n_rows + n_rows
		Else
			; Если нет повторов
			Protected *sheet_node = _get_sheet_node(*book\xml_node, sheet)
			*sheet\row_cash(row_id) = _create_row_node(PreviousXMLNode(*row_node), n_rows, _get_n_cols(*sheet_node))
			*sheet\n_rows + n_rows
		EndIf
	Else
		; Если нет узла в кэше
		; Ищем предыдущий узел и меняем в нём количество повторений
		row = row_id
		While Not *row_node
			*row_node = *sheet\row_cash(row)
			row - 1 
		Wend
		repeated_rows = Val(GetXMLAttribute(*row_node, "table:number-rows-repeated"))
		SetXMLAttribute(*row_node, "table:number-rows-repeated", Str(repeated_rows + n_rows))
		*sheet\n_rows + n_rows
	EndIf
	
	ProcedureReturn #True
EndProcedure
	
EndModule
;-----------------------TEST-----------------------
CompilerIf #PB_Compiler_IsMainFile
	
	Define ods = Ods::openOdsBook("test_1.ods")
	If ods
		Ods::setCellValue(ods, 0, 3, 0, "remark", Ods::#string)
		Ods::setCellValue(ods, 0, 3, 1, "remark", Ods::#string)
		Ods::setCellValue(ods, 0, 3, 2, "remark", Ods::#string)
		Ods::setCellValue(ods, 0, 3, 3, "remark", Ods::#string)
		Ods::setCellValue(ods, 0, 3, 4, "remark", Ods::#string)
		Ods::setCellValue(ods, 0, 3, 5, "remark", Ods::#string)
		Ods::setCellValue(ods, 0, 3, 6, "remark", Ods::#string)
		Ods::saveOdsBook(ods)
		Debug "Done!"
	Else
		Debug "Файл .ods не был открыт"
	EndIf
	
CompilerEndIf

; IDE Options = PureBasic 6.00 LTS (MacOS X - x64)
; Folding = ------------------
; EnableXP