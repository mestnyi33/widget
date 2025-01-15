; https://www.purebasic.fr/english/viewtopic.php?t=86061

;
; bt_module.pbi
;
; v1.0.0 DayDreamer 2025-01-09
;
; A rudimentary binary tree where logic design is to enable a fully populated tree to be created with empty nodes.
; There is no typical node ordering logic based on keys. Instead, order of tree nodes is organised
; by the natural order of recursive build and identifier which is incremented and saved within node structure.
; 
; Subsequently, node associated content can be updated by searching by node identifier which must be within 
; the range of 1 and Pow(2, tree_height)-1. A search always starts at the root which always has a value of 1
; The use of this logic is for small data sets only. 
;
; Primary driver for this logic is in support of recursive drawing algorithms of pedigree (family) trees. 
;
; This logic supports the PedigreeGadget codified in pdg_module.pbi.
;

DeclareModule bt
   
  Structure t_node
    *prev.t_node  ; Not used at the moment, for future use.
    *left.t_node
    *right.t_node
    lvl.i
    ID.i
    label.s
    backcolor.q
    frontcolor.q
  EndStructure
   
  Structure t_tree
    *root.t_node
    *current.t_node
    Height.i
    totalnodes.i
    label.s       ; Not used at the moment, for future use.
  EndStructure
  
  ; no native Log2 in PureBasic, so have to code it up. needed to calc tree node level based on node id or node count.
  Declare.d Log2(X.d)  
  
  ; create new tree - can specify tree height which will create a tree of empty nodes. default height is 4 levels.
  Declare.i New (tree_height.i = 4)
   
  ; destroy the tree
  Declare Destroy (*tr.t_tree)
   
  ; return the number of nodes, if equal to 0 means tree has no nodes.
  Declare.i GetNodeCount (*tr.t_tree)
  
  ; return the height of the tree
  Declare.i GetHeight (*tr.t_tree)
  
  ; set label of specific tree node
  Declare.i SetNodeLabel (*tr.t_tree, nodeid.i, label.s)
   
  ; get label of specific tree node
  Declare.s GetNodeLabel (*tr.t_tree, nodeid.i)
   
  ; set tree label (title)
  Declare.i SetTreeLabel (*tr.t_tree, label.s)
  
  ; get tree label (title)
  Declare.s GetTreeLabel (*tr.t_tree)
  
  ; set backcolor of specific tree node
  Declare.i SetNodeBackColor (*tr.t_tree, nodeid.i, backcolor.q) 
  
  ; set frontcolor of specific tree node
  Declare.i SetNodeFrontColor (*tr.t_tree, nodeid.i, frontcolor.q)  
  
  ; split a string into parts separated by separator and each part added to tree in sequential order as a separate node.
  Declare.s SplitStringTree (datastring.s, separator.s, *tr.t_tree)  

EndDeclareModule

Module bt

  EnableExplicit
  
  ; ----
  ; Private Code
  ; ----
  
  ; populate tree with empty nodes defined by total node count.
  Procedure.i AddNode (*tr.t_tree, *prevnode.t_node, nodeid)
    
    Protected *node.t_node = #Null, idl, idr
    
    If *tr
      If nodeid <= *tr\totalnodes
        *node = AllocateMemory(SizeOf(t_node))
        ClearStructure(*node, t_node)
        With *node
          
          \id = nodeid
          \lvl = Log2(nodeid+1)
          \prev = *prevnode
          \left = #Null
          \right = #Null
          \label = ""
          \backcolor = #White
          \frontcolor = #Black
          
          ; value of subsequent nodes for left and right nodes are
          ; left node id = double existing node id and
          ; right node id = left node id + 1.
          idl = nodeid*2
          idr = idl+1
          
          ; empty nodes will only be added if within range of
          ; 1 and total nodes for the the tree height.
          If idl <= *tr\totalnodes
            \left = AddNode(*tr, *node, idl)
          EndIf
          If idr <= *tr\totalnodes
            \right = AddNode(*tr, *node, idr)
          EndIf
          
        EndWith
      EndIf
    EndIf

    ProcedureReturn *node
  EndProcedure 
  
  ; find node based on match with node id and if match return pointer to found node.
  Procedure.i FindNode (*node.t_node, nodeid)
    
    Protected *foundnode = #Null
    
    If *node
      With *node
        If \id = nodeid
          *foundnode = *node
        Else
                 
          *foundnode = FindNode(\left, nodeid)
          If *foundnode
            ProcedureReturn *foundnode       
          Else
            *foundnode = FindNode(\right, nodeid)
            If *foundnode
              ProcedureReturn *foundnode
            EndIf
          EndIf
          
        EndIf
      EndWith
    EndIf
    
    ProcedureReturn(*foundnode)
  EndProcedure
  
  ; free the internal allocated memory of all tree nodes.
  Procedure FreeTreeNode (*tr.t_tree, *node.t_node)
    If *tr And *node
      FreeTreeNode (*tr, *node\left)
      FreeTreeNode (*tr, *node\right)
      *tr\totalnodes - 1   
      ClearStructure(*node, t_node)
      FreeMemory(*node)   
    EndIf
  EndProcedure
  
  ; ----
  ; Public code (per Module Declaration)
  ; ----
  
  ; no native Log2 in PureBasic, so have to code it up. needed to calc tree node level based on node id or node count.  
  Procedure.d Log2(X.d)

    ProcedureReturn Round(Log(X)/Log(2),#PB_Round_Up)
    
  EndProcedure  
  
  ; create new tree - can specify tree height which will create a tree of nodes equating to Pow(2, tree_height) - 1.
  ; default is to create a tree of height 4.
  Procedure.i New (tree_height.i = 4)
    
    Protected *tr.t_tree, nodeid
    
    ; initialise tree
    *tr = AllocateMemory(SizeOf(t_tree))
    ClearStructure(*tr, t_tree)
    
    ; add empty modes
    If tree_height > 0
      With *tr
        \height = tree_height
        
        \totalnodes = Pow(2, tree_height) - 1
        
        nodeid = 1
        ; root of tree instantiated here but subsequent nodes are added as routine calls itself recursively.
        \root = AddNode(*tr, #Null, nodeid)
        \current = \root
      EndWith
    EndIf
    
    ProcedureReturn *tr
  EndProcedure
   
  ; destroy the tree
  Procedure Destroy (*tr.t_tree)
    If *tr\root
      FreeTreeNode (*tr, *tr\root)
      ClearStructure(*tr, t_tree)
      FreeMemory(*tr)
    EndIf
  EndProcedure
       
  ; return the number of nodes in the tree, if equal to 0 means tree has no nodes.
  Procedure.i GetNodeCount (*tr.t_tree)
    If *tr
      With *tr
        ProcedureReturn \totalnodes
      EndWith
    EndIf
    ProcedureReturn 0    
  EndProcedure
  
  ; return the tree height
  Procedure.i GetHeight (*tr.t_tree)
    Protected *node.t_node
    If *tr
      With *tr
        ProcedureReturn \height
      EndWith
    EndIf
    ProcedureReturn 0
  EndProcedure  
  
  ; set label of specific tree node
  Procedure.i SetNodeLabel (*tr.t_tree, nodeid.i, label.s)
    Protected *node.t_node
    If *tr
      *node = FindNode (*tr\root, nodeid)
      If *node
        With *node
          \label = label
          ProcedureReturn #True
        EndWith
      EndIf
    EndIf
    ProcedureReturn #False
  EndProcedure
   
  ; get label of specific tree node
  Procedure.s GetNodeLabel (*tr.t_tree, nodeid.i)
    Protected *node.t_node
    If *tr
      *node = FindNode (*tr\root, nodeid)
      If *node
        With *node
          ProcedureReturn \label
        EndWith
      EndIf
    EndIf
    ProcedureReturn #Null$
  EndProcedure
   
  ; set tree label 
  Procedure.i SetTreeLabel (*tr.t_tree, label.s)
    If *tr
      With *tr
        \label = label
        ProcedureReturn #True
      EndWith
    EndIf
    ProcedureReturn #False
  EndProcedure
  
  ; get tree label
  Procedure.s GetTreeLabel (*tr.t_tree)
    If *tr
      With *tr
        ProcedureReturn \label
      EndWith
    EndIf
    ProcedureReturn #Null$
  EndProcedure
  
  ; set backcolor of specific tree node
  Procedure.i SetNodeBackColor (*tr.t_tree, nodeid.i, backcolor.q)
    Protected *node.t_node
    If *tr
      *node = FindNode (*tr\root, nodeid)
      If *node
        With *node
          \backcolor = backcolor
          ProcedureReturn #True
        EndWith
      EndIf
    EndIf
    ProcedureReturn #False
  EndProcedure
  
  ; set frontcolor of specific tree node
  Procedure.i SetNodeFrontColor (*tr.t_tree, nodeid.i, frontcolor.q)
    Protected *node.t_node
    If *tr
      *node = FindNode (*tr\root, nodeid)
      If *node
        With *node
          \frontcolor = frontcolor
          ProcedureReturn #True
        EndWith
      EndIf
    EndIf
    ProcedureReturn #False
  EndProcedure  
  
  ; split a string into parts indicated by separator and each part added to tree in sequential order as a separate node.
  ; this allows a bulk label update of the tree nodes. prerequisite is that tree has already been instantiated.
  ; if count of list of parts is greater than tree node count size, excess elements in string are ignored and not
  ; added to tree.
  ;
  Procedure.s SplitStringTree (datastring.s, separator.s, *tr.t_tree)
  
    Protected *String.character, *Separator.character
    Protected *Start, *End, exit, lock, do, dq, len, str.s, nid, totalnc
    
    If *tr
      With *tr
        
        nid = 1
        totalnc = \totalnodes        
        
        *String = @datastring
        *Separator = @separator
        *Start = *String
        *End = *String
      
        Repeat
          If *String\c = 0
            exit = #True
            do = #True
            If Not dq
              *End = *String
            EndIf
          Else
            If *String\c = '"'
              If Not lock
                lock = #True
                dq = #True
                *Start = *String + SizeOf(character)
              Else
                lock = #False
                *End = *String
              EndIf
            EndIf
            If *String\c = *Separator\c And Not lock
              do = #True
              If Not dq
                *End = *String
              EndIf
            EndIf
          EndIf
          If do
            len = (*End - *Start) / SizeOf(character)
            If Len > 0
              str = PeekS(*Start, len)
              If str
                If nid <= totalnc
                  SetNodeLabel(*tr, nid, str)
                  nid = nid+1
                EndIf
              EndIf
            EndIf
            *Start = *String + SizeOf(character)
            do = #False
            dq = #False
          EndIf
          *String + SizeOf(character)
        Until exit
  
      EndWith
    EndIf
  
  EndProcedure
    
EndModule

;
; btvw_module.pbi
;
; v1.0.0 DayDreamer 2025-01-09
;
; Recursive algorithms for drawing pedigree tree via traversing binary tree. 
;
; This logic supports the PedigreeGadget codified in pdg_module.pbi.
;

DeclareModule btvw
  
  #TR_Orientation_LeftRight = 0
  #TR_Orientation_RightLeft = 1
  #TR_Orientation_TopDown   = 2
  #TR_Orientation_BottomUp  = 3
   
  ; Draw tree of chosen orientation within the boundaries set by x, y, width and height.
  ; Default orientation is left to right with white background and black foreground.
  Declare DrawTree (*tree.bt::t_tree, X, Y, Width, Height, orientation=#TR_Orientation_LeftRight, backcolor=#White, frontcolor=#Black)
  
EndDeclareModule

Module btvw
  
  EnableExplicit
  
  ; ----
  ; Private Code
  ; ----
 
  ; draw a node for left to right orientation
  ;
  Procedure DrawNodeLR (*node.bt::t_node, xOffset, Height, *xStart.Integer, *yStart.Integer, Level) 
     
    Protected labelwidth, labelheight, lvlwidth, yOffset, lvl.s
     
    If *node
      
      labelwidth = TextWidth(*node\label)
      labelheight = TextHeight(*node\label) + 1
      
      lvl = "(" + Str(*node\lvl) + ")"      
      lvlwidth = TextWidth(lvl)
      
      ; Calc appropriate vertical offset position.
      yOffset = Height / 1 << (Level+1)
      
      ; Draw node edges (connectors).
      ;
      If *node\left
        Line(*xStart\i, *yStart\i, xOffset, -yOffset, RGB($66,$99,$CC))
      EndIf      
      
      If *node\right
         Line(*xStart\i, *yStart\i, xOffset, yOffset, RGB($66,$99,$CC))
      EndIf

      ; Draw node.
      ;
      DrawText(*xStart\i - labelwidth/2, *yStart\i - labelheight, *node\label, #Blue, *node\backcolor)
      
      Circle(*xStart\i, *yStart\i, 2, *node\frontcolor)
      
      DrawText(*xStart\i - lvlwidth/2, *yStart\i + 3, lvl, #Red, *node\backcolor)      
      
    EndIf
    
  EndProcedure  
  
  ; draw a node for right to left orientation
  ;  
  Procedure DrawNodeRL (*node.bt::t_node, xOff, h, *x.Integer, *y.Integer, Level) 
     
    Protected kw, kh, lw, offy, key$, lvl$
     
    If *node
      
      key$ = "ID: " + Str(*node\id) + " Label: " + *node\label
      lvl$ = "(" + Str(*node\lvl) + ")"
      
      kw = TextWidth(key$)
      kh = TextHeight(key$) + 1
      
      lw = TextWidth(lvl$)
      
      offy = h / 1 << (Level+1)
      
      ; Draw node edges (connectors).
      If *node\right
        Line(*x\i, *y\i, -xOff, offy, #Black)
      EndIf
      
      If *node\left
        Line(*x\i, *y\i, -xOff, -offy, #Black)
      EndIf
      
      ; Draw node.
      ;
      DrawText(*x\i - kw/2, *y\i - kh, key$, #Blue, #White)
      
      Circle(*x\i, *y\i, 2, #Black)
      
      DrawText(*x\i - lw/2, *y\i + 3, lvl$, #Red, #White)      
      
    EndIf
  EndProcedure  
  
  
  ; draw a node for top down orientation
  ;   
  Procedure DrawNodeTD (*node.bt::t_node, w, yOff, *x.Integer, *y.Integer, Level) 
     
    Protected kw, kh, lw, offx, key$, lvl$
     
    If *node
      key$ = "ID: " + Str(*node\id) + " Label: " + *node\label
      lvl$ = "(" + Str(*node\lvl) + ")"
      
      kw = TextWidth(key$)
      kh = TextHeight(key$) + 1
      
      lw = TextWidth(lvl$)
      
      offx = w  / 1 << (Level+1)
      
      If *node\right
        Line(*x\i, *y\i, offx, yOff, #Black)        
      EndIf
      
      If *node\left
        Line(*x\i, *y\i, - offx, yOff, #Black)        
      EndIf
      
      DrawText(*x\i - kw/2, *y\i - kh, key$, #Blue, #White)
      
      Circle(*x\i, *y\i, 2, #Black)
      
      DrawText(*x\i - lw/2, *y\i + 3, lvl$, #Red, #White)      
      
    EndIf
  EndProcedure
  
  ; draw a node for bottom up orientation
  ;   
  Procedure DrawNodeBU (*node.bt::t_node, w, yOff, *x.Integer, *y.Integer, Level) 
     ; draw a single node
     
     Protected kw, kh, lw, offx, key$, lvl$
     
     If *node
       
      key$ = "ID: " + Str(*node\id) + " Label: " + *node\label
      lvl$ = "(" + Str(*node\lvl) + ")"
      
      kw = TextWidth(key$)
      kh = TextHeight(key$) + 1
      
      lw = TextWidth(lvl$)
      
      offx = w  / 1 << (Level+1)
      
      If *node\right     
         Line(*x\i, *y\i, offx, -yOff, #Black)
      EndIf
      
      If *node\left
        Line(*x\i, *y\i, - offx, -yOff, #Black)          
      EndIf
      
      DrawText(*x\i - kw/2, *y\i - kh, key$, #Blue, #White)
      
      Circle(*x\i, *y\i, 2, #Black)
      
      DrawText(*x\i - lw/2, *y\i + 3, lvl$, #Red, #White)      
      
    EndIf
  EndProcedure  
  
  ; Draw horizontal tree, left to right.
  ;
  Procedure DrawTreeLR (*node.bt::t_node, xOffset, Height, *xStart.Integer, *yStart.Integer, Level)
     
    Protected yOffset
     
    If *node
          
      Level + 1
      
      yOffset = Height / 1 << Level     
   
      *xStart\i + xOffset
      *yStart\i - yOffset
      DrawTreeLR (*node\left, xOffset, Height, *xStart, *yStart, Level)
      *yStart\i + yOffset
      
      Level - 1       
      DrawNodeLR (*node, xOffset, Height, *xStart, *yStart, Level)
      Level + 1
      
      *yStart\i + yOffset
      DrawTreeLR (*node\right, xOffset, Height, *xStart, *yStart, Level)     
      *yStart\i - yOffset

      *xStart\i - xOffset

    EndIf
  EndProcedure
  
  ; Draw horizontal tree, right to left.
  ;  
  Procedure DrawTreeRL (*node.bt::t_node, xOff, h, *x.Integer, *y.Integer, Level)
     
    Protected offy
     
    If *node
 
      Level + 1   
      
      offy = h  / 1 << Level     
      *x\i - xOff
        
      *y\i - offy
      DrawTreeRL (*node\left, xOff, h, *x, *y, Level)
      *y\i + offy
        
      Level - 1       
      DrawNodeRL (*node, xOff, h, *x, *y, Level)
      Level + 1
        
      *y\i + offy
      DrawTreeRL (*node\right, xOff, h, *x, *y, Level)     
      *y\i - offy
      *x\i + xOff

    EndIf
  EndProcedure  
  
  ; Draw vertical tree, top down..
  ;  
  Procedure DrawTreeTD (*node.bt::t_node, w, yOff, *x.Integer, *y.Integer, Level)
     
    Protected offx
     
    If *node
 
      Level + 1   
      
      offx = w  / 1 << Level     
      *y\i + yOff
        
      *x\i - offx
      DrawTreeTD (*node\left, w, yOff, *x, *y, Level)
      *x\i + offx
        
      Level - 1       
      DrawNodeTD (*node, w, yOff, *x, *y, Level)
      Level + 1
        
      *x\i + offx
      DrawTreeTD (*node\right, w, yOff, *x, *y, Level)     
      *x\i - offx
      *y\i - yOff

    EndIf
  EndProcedure  
  
  ; Draw horizontal tree, bottom up.
  ;  
  Procedure DrawTreeBU (*node.bt::t_node, w, yOff, *x.Integer, *y.Integer, Level)
     
    Protected offx
     
    If *node
  
      Level + 1   
      
      offx = w  / 1 << Level     
      *y\i - yOff
        
      *x\i - offx
      DrawTreeBU (*node\left, w, yOff, *x, *y, Level)
      *x\i + offx
        
      Level - 1       
      DrawNodeBU (*node, w, yOff, *x, *y, Level)
      Level + 1
        
      *x\i + offx
      DrawTreeBU (*node\right, w, yOff, *x, *y, Level)     
      *x\i - offx
      *y\i + yOff
  
    EndIf
  EndProcedure
  
  ; ----
  ; Public code (per Module Declaration)
  ; ----    
  
  ; Draw tree of chosen orientation within the boundaries set by x, y, width and height.
  ; Default orientation is left to right with white background and black foreground.
  ; This uses the 2D Drawing Library.
  ;
  Procedure DrawTree (*tree.bt::t_tree, X, Y, Width, Height, orientation=#TR_Orientation_LeftRight, backcolor=#White, frontcolor=#Black)
    
    Protected levelcount, xOffset, yOffset, xstart, ystart
    
    If *tree
      
      ; get level count for tree.
      levelcount = bt::GetHeight(*tree)
      
      ; calc necessary offsets in support of distributing tree node levels equally within boundaries.
      xOffset = Width / (levelcount + 1) : yOffset = Height / (levelcount + 1)
      
      ; set background & foreground colors before drawing tree.
      Box(X, Y, Width, Height, backcolor) : FrontColor(frontcolor)   
      
      ; draw tree of chosen orientation with start position set prior accordingly.
      Select orientation
        Case #TR_Orientation_LeftRight
          xstart = X : ystart = Height/2
          DrawTreeLR(*tree\root, xOffset, Height, @xstart, @ystart, 1)
          
        Case #TR_Orientation_RightLeft
          xstart = Width : ystart = Height/2
          DrawTreeRL(*tree\root, xOffset, Height, @xstart, @ystart, 1)          
          
        Case #TR_Orientation_TopDown
          xstart = Width/2 : ystart = Y
          DrawTreeTD(*tree\root, Width, yOffset, @xstart, @ystart, 1)          
          
        Case #TR_Orientation_BottomUp
          xstart = Width/2 : ystart = Height
          DrawTreeBU(*tree\root, Width, yOffset, @xstart, @ystart, 1)          
          
      EndSelect
  
    EndIf
  
  EndProcedure
  
EndModule

;
; gcm_module.pbi
;
; v1.0.0 DayDreamer 2025-01-09
;
; Routines that are common for all custom gadgets.
;

DeclareModule gcm
  
  Declare WindowPB(Object)
  Declare FreeGadgetWithData(Gadget)
  
EndDeclareModule

Module gcm
  
  CompilerSelect #PB_Compiler_OS
    CompilerCase #PB_OS_Windows
      Procedure WindowPB(Object)
        Protected r1
        r1 = GetProp_(Object, "PB_WINDOWID")
        If r1 > 0
          ProcedureReturn r1 - 1
        Else
          ProcedureReturn -1
        EndIf
      EndProcedure
      
    CompilerCase #PB_OS_Linux
      Procedure WindowPB(Object)
        ProcedureReturn g_object_get_data_(Object, "pb_id" )
      EndProcedure
      
    CompilerCase #PB_OS_MacOS
      Import ""
        PB_Window_GetID(Object) 
      EndImport
      
      Procedure WindowPB(Object)
        ProcedureReturn PB_Window_GetID(Object)
      EndProcedure
      
  CompilerEndSelect
  
  ; ----
  
  Procedure FreeGadgetWithData(Gadget)
    Protected *This
    
    If IsGadget(Gadget)
      *This = GetGadgetData(Gadget)
      If *This
        FreeStructure(*This)
      EndIf
      FreeGadget(Gadget)
    EndIf
  EndProcedure
  
EndModule

;
; pdg_module.pbi
;
; v1.0.0 DayDreamer 2025-01-09
;
; Custom Pedigree Gadget supporting display of binary tree in pedigree form.
;

DeclareModule pdg
  
  #PG_Orientation_LeftRight = btvw::#TR_Orientation_LeftRight
  #PG_Orientation_RightLeft = btvw::#TR_Orientation_RightLeft
  #PG_Orientation_TopDown   = btvw::#TR_Orientation_TopDown
  #PG_Orientation_BottomUp  = btvw::#TR_Orientation_BottomUp
  
  Declare CreatePedigreeGadget(Gadget, X, Y, Width, Height, Text.s, 
                               DataList.s, Separator.s, TreeHeight = 3,
                               Orientation.i = #PG_Orientation_LeftRight, 
                               BackColor.q = #White, FrontColor.q = #Black, 
                               Flags = 0)
  Declare FreePedigreeGadget(Gadget)
  Declare SetText(Gadget, Text.s)
  Declare.s GetText(Gadget)
  Declare.i SetData(Gadget, DataList.s, Separator.s)
  Declare SetDirection(Gadget, Orientation.i)
  Declare SetBackColor(Gadget, BackColor.q)
  Declare SetFrontColor(Gadget, FrontColor.q)
  Declare SetItemLabel(Gadget, ItemID.i, Text.s)
  Declare.s GetItemLabel(Gadget, ItemID.i)
  Declare SetItemBackColor(Gadget, ItemID.i, BackColor.q)
  Declare SetItemFrontColor(Gadget, ItemID.i, FrontColor.q)  
  
EndDeclareModule

Module pdg
  
  ; ----
  ; Private Code
  ; ----

  Structure pdg_data
    ; Base
    Window.i
    Gadget.i
    EventType.i
    ; Param
    Text.s
    DataList.s
    Separator.s
    Orientation.i
    BackColor.q
    FrontColor.q
    Flags.i
    ; Pedigree tree data
    *Tree.bt::t_tree
  EndStructure
  
  EnableExplicit
  
  Procedure DrawGadget(*This.pdg_data)
    
    Protected dx, dy
    
    If *This
      With *This
        dx = GadgetWidth(\Gadget) : dy = GadgetHeight(\Gadget)
             
        If StartDrawing(CanvasOutput(\Gadget))       
          Select *This\Orientation
            Case #PG_Orientation_LeftRight, #PG_Orientation_RightLeft, 
                 #PG_Orientation_TopDown, #PG_Orientation_BottomUp
              btvw::DrawTree (*This\Tree, 0, 0, dx, dy, *This\Orientation, *This\BackColor, *This\FrontColor)                      
          EndSelect      
          StopDrawing()
        EndIf
      EndWith
    EndIf
  EndProcedure
  
  ; ----
  
  Procedure DoEvents()
    Protected *This.pdg_data = GetGadgetData(EventGadget())
    
    With *This
      If *This
        \EventType = EventType()
        Select \EventType
          Case #PB_EventType_MouseEnter              
          Case #PB_EventType_MouseLeave          
          Case #PB_EventType_MouseMove
          Case #PB_EventType_MouseWheel
          Case #PB_EventType_LeftButtonDown
          Case #PB_EventType_LeftButtonUp
          Case #PB_EventType_LeftClick
          Case #PB_EventType_LeftDoubleClick
          Case #PB_EventType_RightButtonDown
          Case #PB_EventType_RightButtonUp
          Case #PB_EventType_RightClick
          Case #PB_EventType_RightDoubleClick
          Case #PB_EventType_MiddleButtonDown
          Case #PB_EventType_MiddleButtonUp
          Case #PB_EventType_Focus
          Case #PB_EventType_LostFocus
          Case #PB_EventType_KeyDown
          Case #PB_EventType_KeyUp
          Case #PB_EventType_Input
            
          Case #PB_EventType_Resize
            ; Draw gadget
            DrawGadget(*This)

        EndSelect
      EndIf
    EndWith
  EndProcedure
  
  ; ----
  ; Public code (per Module Declaration)
  ; ----
      
  Procedure CreatePedigreeGadget(Gadget, X, Y, Width, Height, Text.s, 
                                 DataList.s, Separator.s, TreeHeight = 3, 
                                 Orientation.i = #PG_Orientation_LeftRight, 
                                 BackColor.q = #White, FrontColor.q = #Black, 
                                 Flags = 0)
    Protected r1, *This.pdg_data
    
    With *This
      ; Create memory for gadget
      *This = AllocateStructure(pdg_data)
      If Not *This
        ProcedureReturn 0
      EndIf
      
      ; Create Gadget
      r1 = CanvasGadget(Gadget, X, Y, Width, Height, Flags)
      If r1
        \Window = gcm::WindowPB(UseGadgetList(0))
        If Gadget = #PB_Any
          \Gadget = r1
        Else
          \Gadget = Gadget
        EndIf
        
        ; Store pointers to own data in gadget data
        SetGadgetData(\Gadget, *This)
        
        ; Parameters
        \Text = Text
        \Orientation = Orientation
        \BackColor = BackColor
        \FrontColor = FrontColor
        \Flags = Flags
        
        ; Instantiate tree structure.
        \Tree = bt::New(TreeHeight)
        
        ; Store initial bulk load of data into tree.
        bt::SplitStringTree(DataList, Separator, \Tree)
 
        ; Draw gadget
        DrawGadget(*This)
        
        ; Bind gadget events
        BindGadgetEvent(\Gadget, @DoEvents())
      Else
        FreeStructure(*This)
      EndIf
      
    EndWith
    ProcedureReturn r1
  EndProcedure  
  
  ; ----  
  
  Procedure FreePedigreeGadget(Gadget)
    Protected *This.pdg_data
    
    If IsGadget(Gadget)
      With *This      
        *This = GetGadgetData(Gadget)
        If *This
          bt::Destroy(\Tree)
          FreeStructure(*This)
        EndIf
        FreeGadget(Gadget)
      EndWith
    EndIf      
      
  EndProcedure 
  
  ; ----    
  
  Procedure SetText(Gadget, Text.s)
    Protected *This.pdg_data
    
    With *This
      *This = GetGadgetData(Gadget)
      If *This
        \Text = Text
        DrawGadget(*This)
      EndIf
    EndWith
  EndProcedure
  
  ; ----
      
  Procedure.s GetText(Gadget)
    Protected *This.pdg_data
    
    With *This
      *This = GetGadgetData(Gadget)
      If *This
        ProcedureReturn \Text
      EndIf
    EndWith
  EndProcedure
  
  ; ----  
  
  Procedure SetData(Gadget, DataList.s, Separator.s)
    Protected *This.pdg_data
    
    With *This
      *This = GetGadgetData(Gadget)
      If *This
        ; Store data for tree
        bt::SplitStringTree(DataList, Separator, \Tree)        
        DrawGadget(*This)
      EndIf
    EndWith    
  EndProcedure
  
  ; ----
  
  Procedure SetDirection(Gadget, Orientation.i)
    Protected *This.pdg_data
    
    Select Orientation
      Case #PG_Orientation_LeftRight, #PG_Orientation_RightLeft, 
           #PG_Orientation_TopDown, #PG_Orientation_BottomUp
        With *This
          *This = GetGadgetData(Gadget)
          If *This
            ; Store orientation for tree
            \Orientation = Orientation
            DrawGadget(*This)
          EndIf
        EndWith
    EndSelect
  EndProcedure  

  ; ----
  
  Procedure SetBackColor(Gadget, BackColor.q)
    Protected *This.pdg_data 
    
    With *This
      *This = GetGadgetData(Gadget)
      If *This
        ; Store background color
        \BackColor = BackColor
        DrawGadget(*This)
      EndIf
    EndWith    
    
  EndProcedure  
  
  ; ----
  
  Procedure SetFrontColor(Gadget, FrontColor.q)
    Protected *This.pdg_data    
    
    With *This
      *This = GetGadgetData(Gadget)
      If *This
        ; Store front (text) color
        \FrontColor = FrontColor
        DrawGadget(*This)
      EndIf
    EndWith    
    
  EndProcedure
  
  ; ----
  
  Procedure SetItemLabel(Gadget, ItemID.i, Text.s)
    Protected *This.pdg_data   
    
    With *This
      *This = GetGadgetData(Gadget)
      If *This 
        bt::SetNodeLabel(\Tree, ItemID, Text)
        DrawGadget(*This)        
      EndIf
    EndWith     
    
  EndProcedure
  
  ; ----
  
  Procedure.s GetItemLabel(Gadget, ItemID.i)  
    Protected *This.pdg_data    
    
    With *This
      *This = GetGadgetData(Gadget)
      If *This 
        ProcedureReturn (bt::GetNodeLabel (\Tree, ItemID))
      EndIf
    EndWith   
  EndProcedure
  
    ; ----
  
  Procedure SetItemBackColor(Gadget, ItemID.i, BackColor.q)
    Protected *This.pdg_data 
    
    With *This
      *This = GetGadgetData(Gadget)
      If *This
        bt::SetNodeBackColor(\Tree, ItemID, BackColor)
        DrawGadget(*This)        
      EndIf
    EndWith    
    
  EndProcedure  
  
  ; ----
  
  Procedure SetItemFrontColor(Gadget, ItemID.i, FrontColor.q)
    Protected *This.pdg_data    
    
    With *This
      *This = GetGadgetData(Gadget)
      If *This
        bt::SetNodeFrontColor(\Tree, ItemID, FrontColor)
        DrawGadget(*This) 
      EndIf
    EndWith    
    
  EndProcedure
  
EndModule


;
; pedigree.pb
;
; v1.0.0 DayDreamer 2025-01-09
;
; Example program to show pedigree gadget in action.
; App window space is divided into quarters with a pedigree gadget for each, and each
; showing alternative orientation of test data set. 4 levels of binary tree shown but default is 3.
;

; XIncludeFile "bt_module.pbi"
; XIncludeFile "btvw_module.pbi"
; XIncludeFile "gcm_module.pbi"
; XIncludeFile "pdg_module.pbi"

EnableExplicit

CompilerIf Not #PB_Compiler_Thread
  CompilerError "Use Compiler Option ThreadSafe!"
CompilerEndIf
  
CompilerIf #PB_Compiler_IsMainFile
  
  ; Core App Code
  
  #ProgramTitle = "Pedigree"
  #ProgramVersion = "v1.0.0"
  
  Enumeration Windows
    #Main
  EndEnumeration
  
  Enumeration MenuBar
    #MainMenu
  EndEnumeration
  
  Enumeration MenuItems
    #MainMenuAbout
    #MainMenuPreferences
    #MainMenuExit
    #kEscape
    #kTab
    #kBackTab
  EndEnumeration
  
  Enumeration Gadgets
    #MainGadget1
    #MainGadget2
    #MainGadget3
    #MainGadget4
  EndEnumeration
  
  Enumeration StatusBar
    #MainStatusBar
  EndEnumeration
  
  Procedure UpdateWindow()
    Protected dx, dy
    
    dx = WindowWidth(#Main)
    dy = WindowHeight(#Main) - StatusBarHeight(#MainStatusBar) - MenuHeight()
    
    ; Resize gadgets
    ResizeGadget(#MainGadget1, 0, 0, dx/2, dy/2)
    ResizeGadget(#MainGadget2, dx/2, 0, dx/2, dy/2)    
    ResizeGadget(#MainGadget3, 0, dy/2, dx/2, dy/2)
    ResizeGadget(#MainGadget4, dx/2, dy/2, dx/2, dy/2)
    
  EndProcedure
  
  Procedure Main()
    Protected dx, dy, testdata.s
    
    #MainStyle = #PB_Window_SystemMenu | 
                 #PB_Window_ScreenCentered | 
                 #PB_Window_SizeGadget | 
                 #PB_Window_MaximizeGadget | 
                 #PB_Window_MinimizeGadget
    
    If OpenWindow(#Main, #PB_Ignore, #PB_Ignore, 800, 600, #ProgramTitle , #MainStyle)
      ; Menu
      CreateMenu(#MainMenu, WindowID(#Main))
      MenuTitle("&File")
      CompilerIf #PB_Compiler_OS = #PB_OS_MacOS
        MenuItem(#PB_Menu_About, "")
        MenuItem(#PB_Menu_Preferences, "")
      CompilerElse
        MenuItem(#MainMenuAbout, "About")
        MenuItem(#MainMenuPreferences, "Preferences")
      CompilerEndIf
      ; Menu File Items
      
      CompilerIf Not #PB_Compiler_OS = #PB_OS_MacOS
        MenuBar()
        MenuItem(#MainMenuExit, "E&xit")
      CompilerEndIf
      
      ; StatusBar
      CreateStatusBar(#MainStatusBar, WindowID(#Main))
      AddStatusBarField(#PB_Ignore)
      
      ; Gadgets
      dx = WindowWidth(#Main)
      dy = WindowHeight(#Main) - StatusBarHeight(#MainStatusBar) - MenuHeight()
     
      testdata = "Person/Father/Mother/GF/GM/GF/GM/GGF/GGM/GGF/GGM/GGF/GGM/GGF/GGM"
      
      pdg::CreatePedigreeGadget(#MainGadget1, 0, 0, dx/2, dy/2, "", 
                                           testdata, "/", 4,
                                           pdg::#PG_Orientation_LeftRight, #White)
      
      pdg::CreatePedigreeGadget(#MainGadget2, dx/2, 0, dx/2, dy/2, "", 
                                           testdata, "/", 4,
                                           pdg::#PG_Orientation_RightLeft, #Gray)      
 
      pdg::CreatePedigreeGadget(#MainGadget3, 0, dy/2, dx/2, dy/2, "", 
                                           testdata, "/", 4,
                                           pdg::#PG_Orientation_TopDown, #Gray)
      
      pdg::CreatePedigreeGadget(#MainGadget4, dx/2, dy/2, dx/2, dy/2, "", 
                                           testdata, "/", 4,
                                           pdg::#PG_Orientation_BottomUp, #White)      
      
      ; Add keyboard shortcuts
      AddKeyboardShortcut(#Main, #PB_Shortcut_Escape, #kEscape)
      AddKeyboardShortcut(#Main, #PB_Shortcut_Tab, #kTab)
      AddKeyboardShortcut(#Main, #PB_Shortcut_Tab | #PB_Shortcut_Shift, #kBackTab)     
      
      ; Bind Events
      BindEvent(#PB_Event_SizeWindow, @UpdateWindow(), #Main)
      
      ; Event Loop
      Repeat
        Select WaitWindowEvent()
          Case #PB_Event_CloseWindow
            Select EventWindow()
              Case #Main
                Break
                
            EndSelect
            
          Case #PB_Event_Menu
            Select EventMenu()
              ; Standard menu options that only apply for MacOS systems.  
              CompilerIf #PB_Compiler_OS = #PB_OS_MacOS   
                Case #PB_Menu_About
                  PostEvent(#PB_Event_Menu, #Main, #MainMenuAbout)
                  
                Case #PB_Menu_Preferences
                  PostEvent(#PB_Event_Menu, #Main, #MainMenuPreferences)
                  
                Case #PB_Menu_Quit
                  PostEvent(#PB_Event_CloseWindow, #Main, #Null)
              CompilerEndIf
                
              ; Keyboard shortcuts
              Case #kEscape
                PostEvent(#PB_Event_CloseWindow, #Main, #Null)
                
              Case #kTab
                
              Case #kBackTab
                
              ; Menu items.
                
                
              ; Standard menu options that only apply for non MacOS systems.    
              Case #MainMenuAbout
                MessageRequester("About", #ProgramTitle + #LF$ + #ProgramVersion, #PB_MessageRequester_Info)
                
              Case #MainMenuPreferences  
                MessageRequester("Preferences", #ProgramTitle, #PB_MessageRequester_Info)
                  
              Case #MainMenuExit
                PostEvent(#PB_Event_CloseWindow, #Main, #Null)
              
            EndSelect
            
          Case #PB_Event_Gadget
            Select EventGadget()
                
            EndSelect
            
        EndSelect
      ForEver
      
      pdg::FreePedigreeGadget(#MainGadget4)
      pdg::FreePedigreeGadget(#MainGadget3)
      pdg::FreePedigreeGadget(#MainGadget2)
      pdg::FreePedigreeGadget(#MainGadget1)      
      
      RemoveKeyboardShortcut(#Main, #PB_Shortcut_All)
          
    EndIf
    
  EndProcedure : Main()

CompilerEndIf
; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 1316
; FirstLine = 219
; Folding = 3--------+-----8--------
; EnableThread
; EnableXP