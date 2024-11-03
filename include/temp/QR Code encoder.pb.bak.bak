;
; QR Code generator library (C)
;
; Copyright (c) Project Nayuki. (MIT License)
; https://www.nayuki.io/page/qr-code-generator-library
; https://github.com/nayuki/QR-Code-generator
;
; converted to PB by infratec 2020-01-07
;
; https://www.purebasic.fr/english/viewtopic.php?f=12&t=76558
;
; infos:
; https://www.qrcode.com/en/about/version.html
;
; 2020-01-09 17:41  fixed boostEcl
; 2020-01-09 20:30  fixed getNumRawDataModules()
; 2020-01-10 00:56  fixed applyMask()
; 2020-01-10 21:25  added qrcodegen_CreateTextImage()
;

CompilerIf #PB_Compiler_IsMainFile
  EnableExplicit
CompilerEndIf

;-PB Help stuff
Structure AsciiStructure
  a.a[0]
EndStructure


#INT16_MAX = $7fff
#SIZE_MAX = $ffffffff
#LONG_MAX = $7fffffff

;-From Header

;-Enumerations
Enumeration qrcodegen_Ecc
  ; Must be declared in ascending order of error protection
  ; so that an internal qrcodegen function works properly
  #qrcodegen_Ecc_LOW      ; The QR Code can tolerate about  7% erroneous codewords
  #qrcodegen_Ecc_MEDIUM   ; The QR Code can tolerate about 15% erroneous codewords
  #qrcodegen_Ecc_QUARTILE ; The QR Code can tolerate about 25% erroneous codewords
  #qrcodegen_Ecc_HIGH     ; The QR Code can tolerate about 30% erroneous codewords
EndEnumeration


Enumeration qrcodegen_Mask
  ; A special value To tell the QR Code encoder To
  ; automatically Select an appropriate mask pattern
  #qrcodegen_Mask_AUTO = -1
  ; The eight actual mask patterns
  #qrcodegen_Mask_0 = 0
  #qrcodegen_Mask_1
  #qrcodegen_Mask_2
  #qrcodegen_Mask_3
  #qrcodegen_Mask_4
  #qrcodegen_Mask_5
  #qrcodegen_Mask_6
  #qrcodegen_Mask_7
EndEnumeration


Enumeration qrcodegen_Mode
  #qrcodegen_Mode_NUMERIC      = $1
  #qrcodegen_Mode_ALPHANUMERIC = $2
  #qrcodegen_Mode_BYTE         = $4
  #qrcodegen_Mode_KANJI        = $8
  #qrcodegen_Mode_ECI          = $7
EndEnumeration


#qrcodegen_VERSION_MIN = 1  ; The minimum version number supported in the QR Code Model 2 standard
#qrcodegen_VERSION_MAX = 40 ; The maximum version number supported in the QR Code Model 2 standard

; Calculates the number of bytes needed To store any QR Code up To And including the given version number,
; As a compile-time constant. For example, 'uint8_t buffer[qrcodegen_BUFFER_LEN_FOR_VERSION(25)];'
; can store any single QR Code from version 1 To 25 (inclusive). The result fits in an Int (Or int16).
; Requires qrcodegen_VERSION_MIN <= n <= qrcodegen_VERSION_MAX.
Macro qrcodegen_BUFFER_LEN_FOR_VERSION(n)
  ((((n) * 4 + 17) * ((n) * 4 + 17) + 7) / 8 + 1)
EndMacro

; The worst-Case number of bytes needed To store one QR Code, up To And including
; version 40. This value equals 3918, which is just under 4 kilobytes.
; Use this more convenient value To avoid calculating tighter memory bounds For buffers.
#qrcodegen_BUFFER_LEN_MAX = qrcodegen_BUFFER_LEN_FOR_VERSION(#qrcodegen_VERSION_MAX)


Structure qrcodegen_Segment
  ; The mode indicator of this segment.
  mode.i
  
  ; The length of this segment's unencoded data. Measured in characters for
  ; numeric/alphanumeric/kanji mode, bytes For byte mode, And 0 For ECI mode.
  ; Always zero Or positive. Not the same As the Data's bit length.
  numChars.i
  
  ; The Data bits of this segment, packed in bitwise big endian.
  ; Can be null If the bit length is zero.
  *data.AsciiStructure
  
  ; The number of valid Data bits used in the buffer. Requires
  ; 0 <= bitLength <= 32767, And bitLength <= (capacity of Data Array) * 8.
  ; The character count (numChars) must agree With the mode And the bit buffer length.
  bitLength.i
EndStructure


;-From Main

#qrcodegen_ALPHANUMERIC_CHARSET$ = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ $%*+-./:" + #DQUOTE$ + ";"


DataSection
  qrcodegen_internal_ECC_CODEWORDS_PER_BLOCK: ; [4][41]
  Data.b -1,  7, 10, 15, 20, 26, 18, 20, 24, 30, 18, 20, 24, 26, 30, 22, 24, 28, 30, 28, 28, 28, 28, 30, 30, 26, 28, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30
  Data.b -1, 10, 16, 26, 18, 24, 16, 18, 22, 22, 26, 30, 22, 22, 24, 24, 28, 28, 26, 26, 26, 26, 28, 28, 28, 28, 28, 28, 28, 28, 28, 28, 28, 28, 28, 28, 28, 28, 28, 28, 28
  Data.b -1, 13, 22, 18, 26, 18, 24, 18, 22, 20, 24, 28, 26, 24, 20, 30, 24, 28, 28, 26, 30, 28, 30, 30, 30, 30, 28, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30
  Data.b -1, 17, 28, 22, 16, 22, 28, 26, 26, 24, 28, 24, 28, 22, 24, 24, 30, 28, 28, 26, 28, 30, 24, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30, 30
EndDataSection

#qrcodegen_REED_SOLOMON_DEGREE_MAX = 30 ; Based on the table above

DataSection
  qrcodegen_internal_NUM_ERROR_CORRECTION_BLOCKS: ; [4][41]
  Data.b -1, 1, 1, 1, 1, 1, 2, 2, 2, 2, 4,  4,  4,  4,  4,  6,  6,  6,  6,  7,  8,  8,  9,  9, 10, 12, 12, 12, 13, 14, 15, 16, 17, 18, 19, 19, 20, 21, 22, 24, 25
  Data.b -1, 1, 1, 1, 2, 2, 4, 4, 4, 5, 5,  5,  8,  9,  9, 10, 10, 11, 13, 14, 16, 17, 17, 18, 20, 21, 23, 25, 26, 28, 29, 31, 33, 35, 37, 38, 40, 43, 45, 47, 49
  Data.b -1, 1, 1, 2, 2, 4, 4, 6, 6, 8, 8,  8, 10, 12, 16, 12, 17, 16, 18, 21, 20, 23, 23, 25, 27, 29, 34, 34, 35, 38, 40, 43, 45, 48, 51, 53, 56, 59, 62, 65, 68
  Data.b -1, 1, 1, 2, 4, 4, 4, 5, 6, 8, 8, 11, 11, 16, 16, 18, 16, 19, 21, 25, 25, 25, 34, 30, 32, 35, 37, 40, 42, 45, 48, 51, 54, 57, 60, 63, 66, 70, 74, 77, 81
EndDataSection

; For automatic mask pattern selection.
#qrcodegen_PENALTY_N1 =  3
#qrcodegen_PENALTY_N2 =  3
#qrcodegen_PENALTY_N3 = 40
#qrcodegen_PENALTY_N4 = 10

;-Declarations
Declare.i qrcodegen_encodeText(text$, *tempBuffer.AsciiStructure, *qrcode.AsciiStructure, ecl.i, minVersion.i, maxVersion.i, mask.i, boostEcl.i)
Declare.i qrcodegen_encodeBinary(*dataAndTemp.AsciiStructure, dataLen.i, *qrcode.AsciiStructure,	ecl.i, minVersion.i, maxVersion.i, mask.i, boostEcl.i)
Declare qrcodegen_internal_appendBitsToBuffer(val.i, numBits.i, *buffer.AsciiStructure, *bitLen.Integer)
Declare.i qrcodegen_encodeSegments(Array segs.qrcodegen_Segment(1), len.i, ecl.i, *tempBuffer.AsciiStructure, *qrcode.AsciiStructure)
Declare.i qrcodegen_encodeSegmentsAdvanced(Array segs.qrcodegen_Segment(1), len.i, ecl.i, minVersion.i, maxVersion.i, mask.i, boostEcl.i, *tempBuffer.AsciiStructure, *qrcode.AsciiStructure)
Declare qrcodegen_internal_addEccAndInterleave(*ata.AsciiStructure, version.i, ecl.i, *result.AsciiStructure)
Declare.i qrcodegen_internal_getNumDataCodewords(version.i, ecl.i)
Declare.i qrcodegen_internal_getNumRawDataModules(ver.i)
Declare qrcodegen_internal_reedSolomonComputeDivisor(degree.i, *result.AsciiStructure)
Declare qrcodegen_internal_reedSolomonComputeRemainder(*data.AsciiStructure, dataLen.i, *generator.AsciiStructure, degree.i, *result.AsciiStructure)
Declare.a qrcodegen_internal_reedSolomonMultiply(x.a, y.a)
Declare qrcodegen_internal_initializeFunctionModules(version.i, *qrcode.AsciiStructure)
Declare qrcodegen_internal_drawWhiteFunctionModules(*qrcode.AsciiStructure, version.i)
Declare qrcodegen_internal_drawFormatBits(ecl.i, mask.i, *qrcode.AsciiStructure)
Declare.i qrcodegen_internal_getAlignmentPatternPositions(version.i, Array result.a(1))
Declare qrcodegen_internal_fillRectangle(left.i, top.i, width.i, height.i, *qrcode.AsciiStructure)
Declare qrcodegen_internal_drawCodewords(*data.AsciiStructure, dataLen.i, *qrcode.AsciiStructure)
Declare qrcodegen_internal_applyMask(*functionModules.AsciiStructure, *qrcode.AsciiStructure, mask.i)
Declare.i qrcodegen_internal_getPenaltyScore(*qrcode.AsciiStructure)
Declare.i qrcodegen_internal_finderPenaltyCountPatterns(Array runHistory.i(1), qrsize.i)
Declare.i qrcodegen_internal_finderPenaltyTerminateAndCount(currentRunColor.i, currentRunLength.i, Array runHistory.i(1), qrsize.i)
Declare qrcodegen_internal_finderPenaltyAddHistory(currentRunLength.i, Array runHistory.i(1), qrsize.i)
Declare.i qrcodegen_getSize(*qrcode.AsciiStructure)
Declare.i qrcodegen_getModule(*qrcode.AsciiStructure, x.i, y.i)
Declare.i qrcodegen_internal_getModule(*qrcode.AsciiStructure, x.i, y.i)
Declare qrcodegen_internal_setModule(*qrcode.AsciiStructure, x.i, y.i, isBlack.i)
Declare qrcodegen_internal_setModuleBounded(*qrcode.AsciiStructure, x.i, y.i, isBlack.i)
Declare.i qrcodegen_internal_getBit(x.i, i.i)
Declare.i qrcodegen_isAlphanumeric(*text.Character)
Declare.i qrcodegen_isNumeric(*text.Character)
Declare.i qrcodegen_calcSegmentBufferSize(mode.i, numChars.i)
Declare.i qrcodegen_internal_calcSegmentBitLength(mode.i, numChars.i)
Declare.i qrcodegen_makeBytes(*data.AsciiStructure, len.i, *buf.AsciiStructure)
Declare.i qrcodegen_makeNumeric(digits$, *buf.AsciiStructure)
Declare.i qrcodegen_makeAlphanumeric(text$, *buf.AsciiStructure)
Declare.i qrcodegen_makeEci(assignVal.i, *buf.AsciiStructure)
Declare.i qrcodegen_internal_getTotalBits(Array segs.qrcodegen_Segment(1), len.i, version.i)
Declare.i qrcodegen_internal_numCharCountBits(mode.i, version.i)




;---- High-level QR Code encoding functions


; Public function - see documentation comment in header file.
Procedure.i qrcodegen_encodeText(text$, *tempBuffer.AsciiStructure, *qrcode.AsciiStructure, ecl.i, minVersion.i, maxVersion.i, mask.i, boostEcl.i)
  
  Protected Result.i, textLen.i, bufLen.i, i.i
  Protected Dim seg.qrcodegen_Segment(0)
  Protected *seg.qrcodegen_Segment
  
  
  textLen = Len(text$)
  If textLen = 0
    Dim Dummy.qrcodegen_Segment(0)
    Result = qrcodegen_encodeSegmentsAdvanced(Dummy(), 0, ecl, minVersion, maxVersion, mask, boostEcl, *tempBuffer, *qrcode)
  Else
    bufLen = qrcodegen_BUFFER_LEN_FOR_VERSION(maxVersion)
    If qrcodegen_isNumeric(@text$)
      If qrcodegen_calcSegmentBufferSize(#qrcodegen_Mode_NUMERIC, textLen) > bufLen
        ;Goto fail
        *qrcode\a[0] = 0
        ProcedureReturn #False
      EndIf
      *seg = qrcodegen_makeNumeric(text$, *tempBuffer)
      CopyStructure(*seg, @seg(0), qrcodegen_Segment)
    ElseIf qrcodegen_isAlphanumeric(@text$)
      If qrcodegen_calcSegmentBufferSize(#qrcodegen_Mode_ALPHANUMERIC, textLen) > bufLen
        *qrcode\a[0] = 0
        ProcedureReturn #False
      EndIf
      *seg = qrcodegen_makeAlphanumeric(Text$, *tempBuffer)
      CopyStructure(*seg, @seg(0), qrcodegen_Segment)
    Else
      If textLen > bufLen
        *qrcode\a[0] = 0
        ProcedureReturn #False
      EndIf
      For i = 0 To textLen - 1
        *tempBuffer\a[i] = Asc(Mid(text$, i + 1, 1))
      Next i
      seg(0)\mode = #qrcodegen_Mode_BYTE
      seg(0)\bitLength = qrcodegen_internal_calcSegmentBitLength(seg(0)\mode, textLen)
      If seg(0)\bitLength = -1
        *qrcode\a[0] = 0
        ProcedureReturn #False
      EndIf
      seg(0)\numChars = textLen
      seg(0)\Data = *tempBuffer
    EndIf
  EndIf
  
  ProcedureReturn qrcodegen_encodeSegmentsAdvanced(seg(), 1, ecl, minVersion, maxVersion, mask, boostEcl, *tempBuffer, *qrcode)
  
EndProcedure




; Public function - see documentation comment in header file.
Procedure.i qrcodegen_encodeBinary(*dataAndTemp.AsciiStructure, dataLen.i, *qrcode.AsciiStructure,	ecl.i, minVersion.i, maxVersion.i, mask.i, boostEcl.i)
  
  Protected Dim seg.qrcodegen_Segment(0)
  
  seg(0)\mode = #qrcodegen_Mode_BYTE
  seg(0)\bitLength = qrcodegen_internal_calcSegmentBitLength(seg(0)\mode, dataLen)
  If seg(0)\bitLength = -1
    *qrcode\a[0] = 0  ; Set size to invalid value for safety
    ProcedureReturn #False
  EndIf
  seg(0)\numChars = dataLen
  seg(0)\Data = *dataAndTemp
  ProcedureReturn qrcodegen_encodeSegmentsAdvanced(seg(), 1, ecl, minVersion, maxVersion, mask, boostEcl, *dataAndTemp, *qrcode)
EndProcedure




; Appends the given number of low-order bits of the given value To the given byte-based
; bit buffer, increasing the bit length. Requires 0 <= numBits <= 16 And val < 2^numBits.
Procedure qrcodegen_internal_appendBitsToBuffer(val.i, numBits.i, *buffer.AsciiStructure, *bitLen.Integer)
  
  Protected i.i
  
  
  ;assert(0 <= numBits && numBits <= 16 && (unsigned long)val >> numBits == 0)
  ;For (int i = numBits - 1; i >= 0; i--, (*bitLen)++)
  ;  buffer[*bitLen >> 3] |= ((val >> i) & 1) << (7 - (*bitLen & 7));
  
  ;   i = numBits - 1
  ;   While i
  ;     PokeA(*buffer + *bitLen\i >> 3, PeekA(*buffer + *bitLen\i >> 3) | ((val >> i) & 1) << (7 - (*bitLen\i & 7)))
  ;     i - 1
  ;     *bitLen\i + 1
  ;   Wend
  For i = numBits - 1 To 0 Step -1
    *buffer\a[*bitLen\i >> 3] = *buffer\a[*bitLen\i >> 3] | (((val >> i) & 1) << (7 - (*bitLen\i & 7)))
    *bitLen\i + 1
  Next i
  
EndProcedure


;---- Low-level QR Code encoding functions


; Public function - see documentation comment in header file.
Procedure.i qrcodegen_encodeSegments(Array segs.qrcodegen_Segment(1), len.i, ecl.i, *tempBuffer.AsciiStructure, *qrcode.AsciiStructure)
  ProcedureReturn qrcodegen_encodeSegmentsAdvanced(segs(), len, ecl, #qrcodegen_VERSION_MIN, #qrcodegen_VERSION_MAX, #qrcodegen_Mask_AUTO, #True, *tempBuffer, *qrcode)
EndProcedure




; Public function - see documentation comment in header file.
Procedure.i qrcodegen_encodeSegmentsAdvanced(Array segs.qrcodegen_Segment(1), len.i, ecl.i, minVersion.i, maxVersion.i, mask.i, boostEcl.i, *tempBuffer.AsciiStructure, *qrcode.AsciiStructure)
  
  Protected version.i, dataUsedBits.i, dataCapacityBits.i, terminatorBits.i, padByte.i
  Protected i.i, bitLen.i, bit.i, j.i, minPenalty.i, msk.i, penalty.i
  Protected *seg.qrcodegen_Segment
  
  
  ;assert(segs != NULL || len == 0);
  ;assert(qrcodegen_VERSION_MIN <= minVersion && minVersion <= maxVersion && maxVersion <= qrcodegen_VERSION_MAX);
  ;assert(0 <= (int)ecl && (int)ecl <= 3 && -1 <= (int)mask && (int)mask <= 7);
  
  ; Find the minimal version number To use
  version = minVersion
  Repeat
    dataCapacityBits = qrcodegen_internal_getNumDataCodewords(version, ecl) * 8 ; Number of data bits available
    dataUsedBits = qrcodegen_internal_getTotalBits(segs(), len, version)
    If dataUsedBits <> -1 And dataUsedBits <= dataCapacityBits
      Break ; This version number is found to be suitable
    EndIf
    If version >= maxVersion  ; All versions in the range could Not fit the given Data
      *qrcode\a[0] = 0        ; Set size to invalid value for safety
      ProcedureReturn #False
    EndIf
    version + 1
  ForEver
  ;assert(dataUsedBits != -1);
  
  ; Increase the error correction level While the Data still fits in the current version number
  For i = #qrcodegen_Ecc_MEDIUM To #qrcodegen_Ecc_HIGH  ; From low to high
    If boostEcl And dataUsedBits <= qrcodegen_internal_getNumDataCodewords(version, i) * 8
      ecl = i
    EndIf
  Next i
  
  ; Concatenate all segments To create the Data bit string
  ;memset(qrcode, 0, (size_t)qrcodegen_BUFFER_LEN_FOR_VERSION(version) * SizeOf(qrcode[0]));
  FillMemory(*qrcode, qrcodegen_BUFFER_LEN_FOR_VERSION(version) * 1, 0)
  For i = 0 To len - 1
    *seg = @segs(i)
    qrcodegen_internal_appendBitsToBuffer(*seg\mode, 4, *qrcode, @bitLen)
    qrcodegen_internal_appendBitsToBuffer(*seg\numChars, qrcodegen_internal_numCharCountBits(*seg\mode, version), *qrcode, @bitLen)
    For j = 0 To *seg\bitLength - 1
      bit = (*seg\Data\a[j >> 3] >> (7 - (j & 7))) & 1
      qrcodegen_internal_appendBitsToBuffer(bit, 1, *qrcode, @bitLen)
    Next j
  Next i
  ;assert(bitLen == dataUsedBits);
  
  ; Add terminator And pad up To a byte If applicable
  dataCapacityBits = qrcodegen_internal_getNumDataCodewords(version, ecl) * 8
  ;assert(bitLen <= dataCapacityBits)
  terminatorBits = dataCapacityBits - bitLen;
  If terminatorBits > 4
    terminatorBits = 4
  EndIf
  qrcodegen_internal_appendBitsToBuffer(0, terminatorBits, *qrcode, @bitLen)
  qrcodegen_internal_appendBitsToBuffer(0, (8 - bitLen % 8) % 8, *qrcode, @bitLen)
  ;assert(bitLen % 8 == 0);
  
  ; Pad With alternating bytes Until Data capacity is reached
  ;For (uint8_t padByte = 0xEC; bitLen < dataCapacityBits; padByte ^= 0xEC ^ 0x11)
  padByte = $EC
  While bitLen < dataCapacityBits
    qrcodegen_internal_appendBitsToBuffer(padByte, 8, *qrcode, @bitLen)
    ;padByte = padByte ! ($EC ! $11)
    If padByte = $EC
      padByte = $11
    Else
      padByte = $EC
    EndIf
  Wend
  
  ; Draw function And Data codeword modules
  qrcodegen_internal_addEccAndInterleave(*qrcode, version, ecl, *tempBuffer)
  qrcodegen_internal_initializeFunctionModules(version, *qrcode)
  qrcodegen_internal_drawCodewords(*tempBuffer, qrcodegen_internal_getNumRawDataModules(version) / 8, *qrcode)
  qrcodegen_internal_drawWhiteFunctionModules(*qrcode, version)
  qrcodegen_internal_initializeFunctionModules(version, *tempBuffer)
  
  ; Handle masking
  If mask = #qrcodegen_Mask_AUTO  ; Automatically choose best mask
    minPenalty = #LONG_MAX
    For i = #qrcodegen_Mask_0 To #qrcodegen_Mask_7
      msk = i
      qrcodegen_internal_applyMask(*tempBuffer, *qrcode, msk)
      qrcodegen_internal_drawFormatBits(ecl, msk, *qrcode)
      penalty = qrcodegen_internal_getPenaltyScore(*qrcode)
      If penalty < minPenalty
        mask = msk
        minPenalty = penalty
      EndIf
      qrcodegen_internal_applyMask(*tempBuffer, *qrcode, msk) ; Undoes the mask due to XOR
    Next i
  EndIf
  ;assert(0 <= (int)mask && (int)mask <= 7);
  
  qrcodegen_internal_applyMask(*tempBuffer, *qrcode, mask)
  qrcodegen_internal_drawFormatBits(ecl, mask, *qrcode)
  
  ProcedureReturn #True
  
EndProcedure


;---- Error correction code generation functions


; Appends error correction bytes To each block of the given Data Array, then interleaves
; bytes from the blocks And stores them in the result Array. Data[0 : dataLen] contains
; the input Data. Data[dataLen : rawCodewords] is used As a temporary work area And will
; be clobbered by this function. The final answer is stored in result[0 : rawCodewords].
Procedure qrcodegen_internal_addEccAndInterleave(*data.AsciiStructure, version.i, ecl.i, *result.AsciiStructure)
  
  Protected numBlocks.i, blockEccLen.i, rawCodewords.i, dataLen.i, numShortBlocks.i, shortBlockDataLen.i
  Protected *dat.AsciiStructure, i.i, j.i, k.i, *ecc.AsciiStructure, datLen.i
  Protected *rsdiv.AsciiStructure
  
  
  ; Calculate parameter numbers
  ;assert(0 <= (int)ecl && (int)ecl < 4 && qrcodegen_VERSION_MIN <= version && version <= qrcodegen_VERSION_MAX);
  numBlocks = PeekB(?qrcodegen_internal_NUM_ERROR_CORRECTION_BLOCKS + ecl * 41 + version)
  blockEccLen = PeekB(?qrcodegen_internal_ECC_CODEWORDS_PER_BLOCK + ecl * 41 + version)
  rawCodewords = qrcodegen_internal_getNumRawDataModules(version) / 8
  dataLen = qrcodegen_internal_getNumDataCodewords(version, ecl)
  numShortBlocks = numBlocks - rawCodewords % numBlocks
  shortBlockDataLen = rawCodewords / numBlocks - blockEccLen
  
  ; Split Data into blocks, calculate ECC, And interleave
  ; (Not concatenate) the bytes into a single sequence
  *rsdiv = AllocateMemory(#qrcodegen_REED_SOLOMON_DEGREE_MAX)
  If *rsdiv
    qrcodegen_internal_reedSolomonComputeDivisor(blockEccLen, *rsdiv)
    *dat = *data
    For i = 0 To numBlocks - 1
      If i < numShortBlocks
        datLen = shortBlockDataLen
      Else
        datLen = shortBlockDataLen + 1
      EndIf
      *ecc = @*data\a[dataLen]                                     ; Temporary storage
      qrcodegen_internal_reedSolomonComputeRemainder(*dat, datLen, *rsdiv, blockEccLen, *ecc);
      k = i
      For j = 0 To datLen - 1 ; Copy Data
        If j = shortBlockDataLen
          k - numShortBlocks
        EndIf
        *result\a[k] = *dat\a[j]
        k + numBlocks
      Next j
      
      k = dataLen + i
      For j = 0 To blockEccLen - 1 ; Copy ECC
        *result\a[k] = *ecc\a[j]
        k + numBlocks
      Next j
      *dat + datLen
    Next i
    FreeMemory(*rsdiv)
  EndIf
  
EndProcedure




; Returns the number of 8-bit codewords that can be used For storing Data (Not ECC),
; For the given version number And error correction level. The result is in the range [9, 2956].
Procedure.i qrcodegen_internal_getNumDataCodewords(version.i, ecl.i)
  
  Protected v.i, e.i
  
  
  v = version
  e = ecl
  ;assert(0 <= e && e < 4);
  ;ProcedureReturn qrcodegen_internal_getNumRawDataModules(v) / 8 - ECC_CODEWORDS_PER_BLOCK[e][v] * NUM_ERROR_CORRECTION_BLOCKS[e][v]
  ProcedureReturn qrcodegen_internal_getNumRawDataModules(v) / 8 - PeekB(?qrcodegen_internal_ECC_CODEWORDS_PER_BLOCK + e * 41 + v) * PeekB(?qrcodegen_internal_NUM_ERROR_CORRECTION_BLOCKS + e * 41 + v)
  
EndProcedure




; Returns the number of Data bits that can be stored in a QR Code of the given version number, after
; all function modules are excluded. This includes remainder bits, so it might Not be a multiple of 8.
; The result is in the range [208, 29648]. This could be implemented As a 40-entry lookup table.
Procedure.i qrcodegen_internal_getNumRawDataModules(ver.i)
  
  Protected result.i, numAlign.i
  
  
  ;assert(qrcodegen_VERSION_MIN <= ver && ver <= qrcodegen_VERSION_MAX);
  result = (16 * ver + 128) * ver + 64
  If ver >= 2
    numAlign = ver / 7 + 2
    result - ((25 * numAlign - 10) * numAlign - 55)
    If ver >= 7
      result - 36
    EndIf
  EndIf
  ;assert(208 <= result && result <= 29648);
  
  ProcedureReturn result
  
EndProcedure


;---- Reed-Solomon ECC generator functions


; Computes a Reed-Solomon ECC generator polynomial For the given degree, storing in result[0 : degree].
; This could be implemented As a lookup table over all possible parameter values, instead of As an algorithm.
Procedure qrcodegen_internal_reedSolomonComputeDivisor(degree.i, *result.AsciiStructure)
  
  Protected root.a, i.i, j.i
  
  
  ;assert(1 <= degree && degree <= qrcodegen_REED_SOLOMON_DEGREE_MAX);
  ; Polynomial coefficients are stored from highest To lowest power, excluding the leading term which is always 1.
  ; For example the polynomial x^3 + 255x^2 + 8x + 93 is stored As the uint8 Array {255, 8, 93}.
  ;memset(result, 0, (size_t)degree * SizeOf(result[0]));
  FillMemory(*result, degree * 1, 0)
  *result\a[degree - 1] = 1 ; Start off with the monomial x^0
  
  ; Compute the product polynomial (x - r^0) * (x - r^1) * (x - r^2) * ... * (x - r^{degree-1}),
  ; drop the highest monomial term which is always 1x^degree.
  ; Note that r = 0x02, which is a generator element of this field GF(2^8/0x11D).
  root = 1
  For i = 0 To degree - 1
    ; Multiply the current product by (x - r^i)
    For j = 0 To degree - 1
      *result\a[j] = qrcodegen_internal_reedSolomonMultiply(*result\a[j], root)
      If j + 1 < degree
        *result\a[j] = *result\a[j] ! *result\a[j + 1]
      EndIf
    Next j
    root = qrcodegen_internal_reedSolomonMultiply(root, $02)
  Next i
  
EndProcedure




; Computes the Reed-Solomon error correction codeword For the given Data And divisor polynomials.
; The remainder when Data[0 : dataLen] is divided by divisor[0 : degree] is stored in result[0 : degree].
; All polynomials are in big endian, And the generator has an implicit leading 1 term.
Procedure qrcodegen_internal_reedSolomonComputeRemainder(*data.AsciiStructure, dataLen.i, *generator.AsciiStructure, degree.i, *result.AsciiStructure)
  
  Protected i.i, factor.a, j.i
  
  
  ;assert(1 <= degree && degree <= qrcodegen_REED_SOLOMON_DEGREE_MAX);
  ;memset(result, 0, (size_t)degree * SizeOf(result[0]));
  FillMemory(*result, degree * 1, 0)
  For i = 0 To dataLen - 1  ; Polynomial division
    factor = *data\a[i] ! *result\a[0]
    ;memmove(&result[0], &result[1], (size_t)(degree - 1) * SizeOf(result[0]));
    MoveMemory(@*result\a[1], @*result\a[0], (degree - 1) * 1)
    *result\a[degree - 1] = 0
    For j = 0 To degree - 1
      *result\a[j] = *result\a[j] ! qrcodegen_internal_reedSolomonMultiply(*generator\a[j], factor)
    Next j
  Next i
  
EndProcedure




; Returns the product of the two given field elements modulo GF(2^8/0x11D).
; All inputs are valid. This could be implemented As a 256*256 lookup table.
Procedure.a qrcodegen_internal_reedSolomonMultiply(x.a, y.a)
  
  Protected z.a, i.i
  
  ; Russian peasant multiplication
  
  For i = 7 To 0 Step -1
    z = (z << 1) ! ((z >> 7) * $11D)
    z = z ! (((y >> i) & 1) * x)
  Next i
  
  ProcedureReturn z
  
EndProcedure


;---- Drawing function modules


; Clears the given QR Code grid With white modules For the given
; version's size, then marks every function module as black.
Procedure qrcodegen_internal_initializeFunctionModules(version.i, *qrcode.AsciiStructure)
  
  Protected qrsize.i, numAlign.i, i.i, j.i
  
  
  ; Initialize QR Code
  qrsize = version * 4 + 17
  ;memset(qrcode, 0, (size_t)((qrsize * qrsize + 7) / 8 + 1) * SizeOf(qrcode[0]));
  FillMemory(*qrcode, ((qrsize * qrsize + 7) / 8 + 1) * 1, 0)
  *qrcode\a[0] = qrsize
  
  ; Fill horizontal And vertical timing patterns
  qrcodegen_internal_fillRectangle(6, 0, 1, qrsize, *qrcode)
  qrcodegen_internal_fillRectangle(0, 6, qrsize, 1, *qrcode)
  
  ; Fill 3 finder patterns (all corners except bottom right) And format bits
  qrcodegen_internal_fillRectangle(0, 0, 9, 9, *qrcode)
  qrcodegen_internal_fillRectangle(qrsize - 8, 0, 8, 9, *qrcode)
  qrcodegen_internal_fillRectangle(0, qrsize - 8, 9, 8, *qrcode)
  
  ; Fill numerous alignment patterns
  ;uint8_t alignPatPos[7];
  Dim alignPatPos.a(7)
  numAlign = qrcodegen_internal_getAlignmentPatternPositions(version, alignPatPos())
  For i = 0 To numAlign - 1
    For j = 0 To numAlign - 1
      ; Don't draw on the three finder corners
      If Not ((i = 0 And j = 0) Or (i = 0 And j = numAlign - 1) Or (i = numAlign - 1 And j = 0))
        qrcodegen_internal_fillRectangle(alignPatPos(i) - 2, alignPatPos(j) - 2, 5, 5, *qrcode)
      EndIf
    Next j
  Next i
  
  ; Fill version blocks
  If version >= 7
    qrcodegen_internal_fillRectangle(qrsize - 11, 0, 3, 6, *qrcode)
    qrcodegen_internal_fillRectangle(0, qrsize - 11, 6, 3, *qrcode)
  EndIf
  
EndProcedure




; Draws white function modules And possibly some black modules onto the given QR Code, without changing
; non-function modules. This does Not draw the format bits. This requires all function modules To be previously
; marked black (namely by initializeFunctionModules()), because this may skip redrawing black function modules.
Procedure qrcodegen_internal_drawWhiteFunctionModules(*qrcode.AsciiStructure, version.i)
  
  Protected qrsize.i, i.i, dx.i, dy.i, dist.i, numAlign.i, j.i, rem.i, bits.i, k.i
  
  
  ; Draw horizontal And vertical timing patterns
  qrsize = qrcodegen_getSize(*qrcode)
  For i = 7 To qrsize - 8 Step 2
    qrcodegen_internal_setModule(*qrcode, 6, i, #False)
    qrcodegen_internal_setModule(*qrcode, i, 6, #False)
  Next i
  
  ; Draw 3 finder patterns (all corners except bottom right; overwrites some timing modules)
  For dy = -4 To 4
    For dx = -4 To 4
      dist = Abs(dx)
      If Abs(dy) > dist
        dist = Abs(dy)
      EndIf
      If dist = 2 Or dist = 4
        qrcodegen_internal_setModuleBounded(*qrcode, 3 + dx, 3 + dy, #False)
        qrcodegen_internal_setModuleBounded(*qrcode, qrsize - 4 + dx, 3 + dy, #False)
        qrcodegen_internal_setModuleBounded(*qrcode, 3 + dx, qrsize - 4 + dy, #False)
      EndIf
    Next dx
  Next dy
  
  ; Draw numerous alignment patterns
  Dim alignPatPos.a(7)
  numAlign = qrcodegen_internal_getAlignmentPatternPositions(version, alignPatPos())
  For i = 0 To numAlign - 1
    For j = 0 To numAlign - 1
      If (i = 0 And j = 0) Or (i = 0 And j = numAlign - 1) Or (i = numAlign - 1 And j = 0)
        Continue;  // Don't draw on the three finder corners
      EndIf
      For dy = -1 To 1
        For dx = -1 To 1
          qrcodegen_internal_setModule(*qrcode, alignPatPos(i) + dx, alignPatPos(j) + dy, Bool(dx = 0 And dy = 0))
        Next dx
      Next dy
    Next j
  Next i
  
  ; Draw version blocks
  If version >= 7
    ; Calculate error correction code And pack bits
    rem = version ; version is uint6, in the range [7, 40]
    For i = 0 To 11
      rem = (rem << 1) ! ((rem >> 11) * $1F25)
    Next i
    bits = version << 12 | rem;  // uint18
                              ;assert(bits >> 18 == 0);
    
    ; Draw two copies
    For i = 0 To 5
      For j = 0 To 2
        k = qrsize - 11 + j
        qrcodegen_internal_setModule(*qrcode, k, i, Bool((bits & 1) <> 0))
        qrcodegen_internal_setModule(*qrcode, i, k, Bool((bits & 1) <> 0))
        bits = bits >> 1
      Next j
    Next i
  EndIf
  
EndProcedure




; Draws two copies of the format bits (With its own error correction code) based
; on the given mask And error correction level. This always draws all modules of
; the format bits, unlike drawWhiteFunctionModules() which might skip black modules.
Procedure qrcodegen_internal_drawFormatBits(ecl.i, mask.i, *qrcode.AsciiStructure)
  
  Protected dataI.i, rem.i, i.i, bits.i, qrsize.i
  Protected Dim table.i(3)
  
  
  ; Calculate error correction code And pack bits
  ;assert(0 <= (int)mask && (int)mask <= 7);
  table(0) = 1
  table(1) = 0
  table(2) = 3
  table(3) = 2
  dataI = table(ecl) << 3 | mask  ; errCorrLvl is uint2, mask is uint3
  rem = dataI
  For i = 0 To 9
    rem = (rem << 1) ! ((rem >> 9) * $537)
  Next i
  bits = (dataI << 10 | rem) ! $5412  ;  // uint15
                                      ;assert(bits >> 15 == 0);
  
  ; Draw first copy
  For i = 0 To 5
    qrcodegen_internal_setModule(*qrcode, 8, i, qrcodegen_internal_getBit(bits, i))
  Next i
  qrcodegen_internal_setModule(*qrcode, 8, 7, qrcodegen_internal_getBit(bits, 6))
  qrcodegen_internal_setModule(*qrcode, 8, 8, qrcodegen_internal_getBit(bits, 7))
  qrcodegen_internal_setModule(*qrcode, 7, 8, qrcodegen_internal_getBit(bits, 8))
  For i = 9 To 14
    qrcodegen_internal_setModule(*qrcode, 14 - i, 8, qrcodegen_internal_getBit(bits, i))
  Next i
  
  ; Draw second copy
  qrsize = qrcodegen_getSize(*qrcode)
  For i = 0 To 7
    qrcodegen_internal_setModule(*qrcode, qrsize - 1 - i, 8, qrcodegen_internal_getBit(bits, i))
  Next i
  For i = 8 To 14
    qrcodegen_internal_setModule(*qrcode, 8, qrsize - 15 + i, qrcodegen_internal_getBit(bits, i))
  Next i
  qrcodegen_internal_setModule(*qrcode, 8, qrsize - 8, #True) ;  // Always black
  
EndProcedure




; Calculates And stores an ascending List of positions of alignment patterns
; For this version number, returning the length of the List (in the range [0,7]).
; Each position is in the range [0,177), And are used on both the x And y axes.
; This could be implemented As lookup table of 40 variable-length lists of unsigned bytes.
Procedure.i qrcodegen_internal_getAlignmentPatternPositions(version.i, Array result.a(1))
  
  Protected numAlign.i, Stepi.i, i.i, pos.i
  
  
  If version <> 1
    
    numAlign = version / 7 + 2
    If version = 32
      Stepi = 26
    Else
      Stepi = (version*4 + numAlign*2 + 1) / (numAlign*2 - 2) * 2
    EndIf
    ;For (int i = numAlign - 1, pos = version * 4 + 10; i >= 1; i--, pos -= step)
    pos = version * 4 + 10
    For i = numAlign - 1 To 1 Step -1
      result(i) = pos
      pos - stepi
    Next i
    result(0) = 6
  EndIf
  
  ProcedureReturn numAlign
  
EndProcedure




; Sets every pixel in the range [left : left + width] * [top : top + height] to black.
Procedure qrcodegen_internal_fillRectangle(left.i, top.i, width.i, height.i, *qrcode.AsciiStructure)
  
  Protected dy.i, dx.i
  
  
  For dy = 0 To height - 1
    For dx = 0 To width - 1
      qrcodegen_internal_setModule(*qrcode, left + dx, top + dy, #True)
    Next dx
  Next dy
  
EndProcedure


;---- Drawing Data modules And masking


; Draws the raw codewords (including Data And ECC) onto the given QR Code. This requires the initial state of
; the QR Code To be black at function modules And white at codeword modules (including unused remainder bits).
Procedure qrcodegen_internal_drawCodewords(*data.AsciiStructure, dataLen.i, *qrcode.AsciiStructure)
  
  Protected qrsize.i, i.i, right.i, vert.i, j.i, x.i, upward.i, y.i, black.i
  
  
  qrsize = qrcodegen_getSize(*qrcode)
  
  ; Do the funny zigzag scan
  For right = qrsize - 1 To 1 Step -2 ; Index of right column in each column pair
    If right = 6
      right = 5
    EndIf
    For vert = 0 To qrsize - 1  ; Vertical counter
      For j = 0 To 1
        x = right - j ; Actual x coordinate
        upward = Bool((right + 1) & 2 = 0)
        ; Actual y coordinate
        If upward
          y = qrsize - 1 - vert
        Else
          y = vert
        EndIf
        If (Not qrcodegen_internal_getModule(*qrcode, x, y)) And i < dataLen * 8
          black = qrcodegen_internal_getBit(*data\a[i >> 3], 7 - (i & 7))
          qrcodegen_internal_setModule(*qrcode, x, y, black)
          i + 1
        EndIf
        ; If this QR Code has any remainder bits (0 To 7), they were assigned As
        ; 0/false/white by the constructor And are left unchanged by this method
      Next j
    Next vert
  Next right
  ;assert(i == dataLen * 8);
EndProcedure




; XORs the codeword modules in this QR Code With the given mask pattern.
; The function modules must be marked And the codeword bits must be drawn
; before masking. Due To the arithmetic of XOr, calling applyMask() With
; the same mask value a second time will undo the mask. A final well-formed
; QR Code needs exactly one (Not zero, two, etc.) mask applied.
Procedure qrcodegen_internal_applyMask(*functionModules.AsciiStructure, *qrcode.AsciiStructure, mask.i)
  
  Protected qrsize.i, x.i, y.i, invert.i, val.i
  
  
  ;assert(0 <= (int)mask && (int)mask <= 7);  // Disallows qrcodegen_Mask_AUTO
  qrsize = qrcodegen_getSize(*qrcode)
  For y = 0 To qrsize - 1
    For x = 0 To qrsize - 1
      If qrcodegen_internal_getModule(*functionModules, x, y)
        Continue
      EndIf
      Select mask
        Case 0:  invert = Bool((x + y) % 2 = 0)
        Case 1:  invert = Bool(y % 2 = 0)
        Case 2:  invert = Bool(x % 3 = 0)
        Case 3:  invert = Bool((x + y) % 3 = 0)
        Case 4:  invert = Bool((x / 3 + y / 2) % 2 = 0)
        Case 5:  invert = Bool((x * y) % 2 + (x * y) % 3 = 0)
        Case 6:  invert = Bool(((x * y) % 2 + (x * y) % 3) % 2 = 0)
        Case 7:  invert = Bool(((x + y) % 2 + (x * y) % 3) % 2 = 0)
        Default:
          ;assert(false);
          ;Return       ;
          Break 2
      EndSelect			
      val = qrcodegen_internal_getModule(*qrcode, x, y)
      qrcodegen_internal_setModule(*qrcode, x, y, val ! invert)
    Next x
  Next y
  
EndProcedure




; Calculates And returns the penalty score based on state of the given QR Code's current modules.
; This is used by the automatic mask choice algorithm To find the mask pattern that yields the lowest score.
Procedure.i qrcodegen_internal_getPenaltyScore(*qrcode.AsciiStructure)
  
  Protected qrsize.i, result.i, x.i, y.i, runColor.i, runX.i, runY.i, color.i, black.i, total.i, k.i
  
  
  qrsize = qrcodegen_getSize(*qrcode)
  
  ; Adjacent modules in row having same color, And finder-like patterns
  For y = 0 To qrsize - 1
    runColor = #False
    runX = 0
    Dim runHistory.i(7)
    For x = 0 To qrsize - 1
      If qrcodegen_internal_getModule(*qrcode, x, y) = runColor
        runX + 1
        If runX = 5
          result + #qrcodegen_PENALTY_N1
        ElseIf runX > 5
          result + 1
        EndIf
      Else
        qrcodegen_internal_finderPenaltyAddHistory(runX, runHistory(), qrsize)
        If Not runColor
          result + qrcodegen_internal_finderPenaltyCountPatterns(runHistory(), qrsize) * #qrcodegen_PENALTY_N3
        EndIf
        runColor = qrcodegen_internal_getModule(*qrcode, x, y)
        runX = 1
      EndIf
    Next x
    result + qrcodegen_internal_finderPenaltyTerminateAndCount(runColor, runX, runHistory(), qrsize) * #qrcodegen_PENALTY_N3
  Next y
  
  ; Adjacent modules in column having same color, And finder-like patterns
  For x = 0 To qrsize - 1
    runColor = #False
    runY = 0
    Dim runHistory.i(7)
    For y = 0 To qrsize - 1
      If qrcodegen_internal_getModule(*qrcode, x, y) = runColor
        runY + 1
        If runY = 5
          result + #qrcodegen_PENALTY_N1
        ElseIf runY > 5
          result + 1
        EndIf
      Else
        qrcodegen_internal_finderPenaltyAddHistory(runY, runHistory(), qrsize)
        If Not runColor
          result + qrcodegen_internal_finderPenaltyCountPatterns(runHistory(), qrsize) * #qrcodegen_PENALTY_N3
        EndIf
        runColor = qrcodegen_internal_getModule(*qrcode, x, y)
        runY = 1
      EndIf
    Next y
    result + qrcodegen_internal_finderPenaltyTerminateAndCount(runColor, runY, runHistory(), qrsize) * #qrcodegen_PENALTY_N3
  Next x
  
  ; 2*2 blocks of modules having same color
  For y = 0 To qrsize - 2
    For x = 0 To qrsize - 2
      color = qrcodegen_internal_getModule(*qrcode, x, y)
      If color = qrcodegen_internal_getModule(*qrcode, x + 1, y) And color = qrcodegen_internal_getModule(*qrcode, x, y + 1) And color = qrcodegen_internal_getModule(*qrcode, x + 1, y + 1)
        result + #qrcodegen_PENALTY_N2
      EndIf
    Next x
  Next y
  
  ; Balance of black And white modules
  black = 0
  For y = 0 To qrsize - 1
    For x = 0 To qrsize - 1
      If qrcodegen_internal_getModule(*qrcode, x, y)
        black + 1
      EndIf
    Next x
  Next y
  total = qrsize * qrsize ; Note that size is odd, so black/total != 1/2
                          ; Compute the smallest integer k >= 0 such that (45-5k)% <= black/total <= (55+5k)%
  k = Int((Abs(black * 20 - total * 10) + total - 1) / total) - 1
  result + (k * #qrcodegen_PENALTY_N4)
  
  ProcedureReturn result
  
EndProcedure




; Can only be called immediately after a white run is added, And
; returns either 0, 1, Or 2. A helper function For getPenaltyScore().
Procedure.i qrcodegen_internal_finderPenaltyCountPatterns(Array runHistory.i(1), qrsize.i)
  
  Protected n.i, core.i, Result.i
  
  
  n = runHistory(1)
  ;assert(n <= qrsize * 3);
  core = Bool(n > 0 And runHistory(2) = n And runHistory(3) = n * 3 And runHistory(4) = n And runHistory(5) = n)
  ; The maximum QR Code size is 177, hence the black run length n <= 177.
  ; Arithmetic is promoted To int, so n*4 will Not overflow.
  ;Return (core && runHistory[0] >= n * 4 && runHistory[6] >= n ? 1 : 0) + (core && runHistory[6] >= n * 4 && runHistory[0] >= n ? 1 : 0); 
  If core And runHistory(0) >= n * 4 And runHistory(6) >= n
    Result + 1
  EndIf
  If core And runHistory(6) >= n * 4 And runHistory(0) >= n
    Result + 1
  EndIf
  
  ProcedureReturn Result
  
EndProcedure




; Must be called at the end of a line (row or column) of modules. A helper function for getPenaltyScore().
Procedure.i qrcodegen_internal_finderPenaltyTerminateAndCount(currentRunColor.i, currentRunLength.i, Array runHistory.i(1), qrsize.i)
  
  If currentRunColor  ; Terminate black run
    qrcodegen_internal_finderPenaltyAddHistory(currentRunLength, runHistory(), qrsize)
    currentRunLength = 0
  EndIf
  currentRunLength + qrsize;  // Add white border to final run
  qrcodegen_internal_finderPenaltyAddHistory(currentRunLength, runHistory(), qrsize)
  
  ProcedureReturn qrcodegen_internal_finderPenaltyCountPatterns(runHistory(), qrsize)
  
EndProcedure



; Pushes the given value to the front and drops the last value. A helper function for getPenaltyScore().
Procedure qrcodegen_internal_finderPenaltyAddHistory(currentRunLength.i, Array runHistory.i(1), qrsize.i)
  
  Protected i.i
  
  
  If runHistory(0) = 0
    currentRunLength + qrsize ; Add white border to initial run
  EndIf
  ;memmove(&runHistory[1], &runHistory[0], 6 * SizeOf(runHistory[0]));
  MoveMemory(@runHistory(0), @runHistory(1), 6 * SizeOf(Integer))
  runHistory(0) = currentRunLength
  
EndProcedure


;---- Basic QR Code information


; Public function - see documentation comment in header file.
Procedure.i qrcodegen_getSize(*qrcode.AsciiStructure)
  
  Protected result.i
  
  
  ;assert(qrcode != NULL);
  result = *qrcode\a[0]
  ;assert((qrcodegen_VERSION_MIN * 4 + 17) <= result	&& result <= (qrcodegen_VERSION_MAX * 4 + 17));
  
  ProcedureReturn result
  
EndProcedure




; Public function - see documentation comment in header file.
Procedure.i qrcodegen_getModule(*qrcode.AsciiStructure, x.i, y.i)
  
  Protected qrsize.i
  
  
  ;assert(qrcode != NULL);
  qrsize = *qrcode\a[0]
  
  ProcedureReturn Bool((0 <= x And x < qrsize And 0 <= y And y < qrsize) And qrcodegen_internal_getModule(*qrcode, x, y))
  
EndProcedure




; Gets the module at the given coordinates, which must be in bounds.
Procedure.i qrcodegen_internal_getModule(*qrcode.AsciiStructure, x.i, y.i)
  
  Protected qrsize.i, index.i
  
  
  qrsize = *qrcode\a[0]
  ;assert(21 <= qrsize && qrsize <= 177 && 0 <= x && x < qrsize && 0 <= y && y < qrsize);
  index = y * qrsize + x
  
  ProcedureReturn qrcodegen_internal_getBit(*qrcode\a[(index >> 3) + 1], index & 7)
  
EndProcedure




; Sets the module at the given coordinates, which must be in bounds.
Procedure qrcodegen_internal_setModule(*qrcode.AsciiStructure, x.i, y.i, isBlack.i)
  
  Protected qrsize.i, index.i, bitIndex.i, byteIndex.i
  
  
  qrsize = *qrcode\a[0]
  ;assert(21 <= qrsize && qrsize <= 177 && 0 <= x && x < qrsize && 0 <= y && y < qrsize);
  index = y * qrsize + x
  bitIndex = index & 7
  byteIndex = (index >> 3) + 1
  If isBlack
    *qrcode\a[byteIndex] = *qrcode\a[byteIndex] | (1 << bitIndex)
  Else
    *qrcode\a[byteIndex] = *qrcode\a[byteIndex] & ((1 << bitIndex) ! $FF)
  EndIf
  
EndProcedure




; Sets the module at the given coordinates, doing nothing if out of bounds.
Procedure qrcodegen_internal_setModuleBounded(*qrcode.AsciiStructure, x.i, y.i, isBlack.i)
  
  Protected qrsize.i
  
  
  qrsize = *qrcode\a[0]
  If 0 <= x And x < qrsize And 0 <= y And y < qrsize
    qrcodegen_internal_setModule(*qrcode, x, y, isBlack)
  EndIf
  
EndProcedure




; Returns true iff the i'th bit of x is set to 1. Requires x >= 0 and 0 <= i <= 14.
Procedure.i qrcodegen_internal_getBit(x.i, i.i)
  
  ProcedureReturn Bool(((x >> i) & 1) <> 0)
  
EndProcedure


;---- Segment handling


; Public function - see documentation comment in header file.
Procedure.i qrcodegen_isAlphanumeric(*text.Character)
  
  Protected Result.i
  
  
  Result = #True
  ;assert(text != NULL);
  While *text\c
    If FindString(#qrcodegen_ALPHANUMERIC_CHARSET$, Chr(*text\c)) = 0
      Result = #False
      Break
    EndIf
    *text + 2
  Wend
  
  ProcedureReturn Result
  
EndProcedure




; Public function - see documentation comment in header file.
Procedure.i qrcodegen_isNumeric(*text.Character)
  
  Protected Result.i
  
  
  Result = #True
  While *text\c
    If *text\c < '0' Or *text\c > '9'
      Result = #False
      Break
    EndIf
    *text + 2
  Wend
  
  ProcedureReturn Result
  
EndProcedure




; Public function - see documentation comment in header file.
Procedure.i qrcodegen_calcSegmentBufferSize(mode.i, numChars.i)
  
  Protected Result.i, temp.i
  
  
  temp = qrcodegen_internal_calcSegmentBitLength(mode, numChars)
  If temp = -1
    Result = #SIZE_MAX
  Else
    ;assert(0 <= temp && temp <= INT16_MAX)
    Result = (temp + 7) / 8
  EndIf
  
  ProcedureReturn Result
  
EndProcedure




; Returns the number of Data bits needed To represent a segment
; containing the given number of characters using the given mode. Notes:
; - Returns -1 on failure, i.e. numChars > INT16_MAX Or
;   the number of needed bits exceeds INT16_MAX (i.e. 32767).
; - Otherwise, all valid results are in the range [0, INT16_MAX].
; - For byte mode, numChars measures the number of bytes, Not Unicode code points.
; - For ECI mode, numChars must be 0, And the worst-Case number of bits is returned.
;   An actual ECI segment can have shorter Data. For non-ECI modes, the result is exact.
Procedure.i qrcodegen_internal_calcSegmentBitLength(mode.i, numChars.i)
  
  Protected result.i
  
  
  ; All calculations are designed To avoid overflow on all platforms
  If numChars > #INT16_MAX
    result = -1
  Else
    result = numChars
    If mode = #qrcodegen_Mode_NUMERIC
      result = (result * 10 + 2) / 3  ; ceil(10/3 * n)
    ElseIf mode = #qrcodegen_Mode_ALPHANUMERIC
      result = (result * 11 + 1) / 2  ; ceil(11/2 * n)
    ElseIf mode = #qrcodegen_Mode_BYTE
      result = result * 8
    ElseIf mode = #qrcodegen_Mode_KANJI
      result = result * 13
    ElseIf mode = #qrcodegen_Mode_ECI And numChars = 0
      result = 3 * 8
    Else  ; Invalid argument
          ;assert(false)
      Result = -1
    EndIf
    ;assert(result >= 0);
    If result > #INT16_MAX
      result = -1
    EndIf
  EndIf
  
  ProcedureReturn result
  
EndProcedure




; Public function - see documentation comment in header file.
Procedure.i qrcodegen_makeBytes(*data.AsciiStructure, len.i, *buf.AsciiStructure)
  
  Static result.qrcodegen_Segment
  
  
  ;assert(Data != NULL || len == 0)
  result\mode = #qrcodegen_Mode_BYTE
  result\bitLength = qrcodegen_internal_calcSegmentBitLength(result\mode, len)
  ;assert(result.bitLength != -1);
  result\numChars = len
  If len > 0
    ;memcpy(buf, Data, len * SizeOf(buf[0]));
    CopyMemory(*data, *buf, len * 1)
  EndIf
  result\Data = *buf
  
  ProcedureReturn @result
  
EndProcedure



; Public function - see documentation comment in header file.
Procedure.i qrcodegen_makeNumeric(digits$, *buf.AsciiStructure)
  
  Protected len.i, bitLen.i, accumData.i, accumCount.i
  Static result.qrcodegen_Segment
  Protected *digits.Character
  
  
  ;assert(digits != NULL)
  
  len = Len(digits$)
  result\mode = #qrcodegen_Mode_NUMERIC
  bitLen = qrcodegen_internal_calcSegmentBitLength(result\mode, len)
  ;assert(bitLen != -1)
  result\numChars = len
  If bitLen > 0
    ;memset(buf, 0, ((size_t)bitLen + 7) / 8 * SizeOf(buf[0]))
    FillMemory(*buf, (bitLen + 7) / 8 * 1, 0)
  EndIf
  result\bitLength = 0
  
  *digits = @digits$
  While *digits\c
    ;assert('0' <= c && c <= '9');
    accumData = accumData * 10 + (*digits\c - '0')
    accumCount + 1
    If accumCount = 3
      qrcodegen_internal_appendBitsToBuffer(accumData, 10, *buf, @result\bitLength)
      accumData = 0
      accumCount = 0
    EndIf
    *digits + 2
  Wend
  If accumCount > 0 ; 1 Or 2 digits remaining
    qrcodegen_internal_appendBitsToBuffer(accumData, accumCount * 3 + 1, *buf, @result\bitLength)
  EndIf
  ;assert(result.bitLength == bitLen)
  result\Data = *buf
  
  ProcedureReturn @result
  
EndProcedure




; Public function - see documentation comment in header file.
Procedure.i qrcodegen_makeAlphanumeric(text$, *buf.AsciiStructure)
  
  Protected len.i, bitLen.i, accumData.i, accumCount.i, temp.i
  Static result.qrcodegen_Segment
  Protected *text.Character
  
  
  ;assert(text != NULL);
  len = Len(text$)
  result\mode = #qrcodegen_Mode_ALPHANUMERIC
  bitLen = qrcodegen_internal_calcSegmentBitLength(result\mode, len)
  ;assert(bitLen != -1);
  result\numChars = len
  If bitLen > 0
    ;memset(buf, 0, ((size_t)bitLen + 7) / 8 * SizeOf(buf[0]));
    FillMemory(*buf, (bitLen + 7) / 8 * 1, 0)
  EndIf
  result\bitLength = 0
  
  ;For (; *text != '\0'; text++) {
  *text = @text$
  While *text\c
    temp = FindString(#qrcodegen_ALPHANUMERIC_CHARSET$, Chr(*text\c))
    ;assert(temp != NULL);
    accumData = accumData * 45 + temp - 1
    accumCount + 1
    If accumCount = 2
      qrcodegen_internal_appendBitsToBuffer(accumData, 11, *buf, @result\bitLength)
      accumData = 0
      accumCount = 0
    EndIf
    *text + 2
  Wend
  If accumCount > 0 ; 1 character remaining
    qrcodegen_internal_appendBitsToBuffer(accumData, 6, *buf, @result\bitLength)
  EndIf
  ;assert(result.bitLength == bitLen);
  result\Data = *buf
  
  ProcedureReturn @result
  
EndProcedure




; Public function - see documentation comment in header file.
Procedure.i qrcodegen_makeEci(assignVal.i, *buf.AsciiStructure)
  
  Static result.qrcodegen_Segment
  
  
  result\mode = #qrcodegen_Mode_ECI
  result\numChars = 0
  result\bitLength = 0
  If assignVal < 0
    ;assert(false);
  ElseIf assignVal < (1 << 7)
    ;memset(buf, 0, 1 * SizeOf(buf[0]))
    FillMemory(*buf, 1 * 1, 0)
    qrcodegen_internal_appendBitsToBuffer(assignVal, 8, *buf, @result\bitLength)
  ElseIf assignVal < (1 << 14)
    ;memset(buf, 0, 2 * SizeOf(buf[0]))
    FillMemory(*buf, 2 * 1, 0)
    qrcodegen_internal_appendBitsToBuffer(2, 2, *buf, @result\bitLength)
    qrcodegen_internal_appendBitsToBuffer(assignVal, 14, *buf, @result\bitLength)
  ElseIf assignVal < 1000000
    ;memset(buf, 0, 3 * SizeOf(buf[0]))
    FillMemory(*buf, 3 * 1, 0)
    qrcodegen_internal_appendBitsToBuffer(6, 3, *buf, @result\bitLength)
    qrcodegen_internal_appendBitsToBuffer((assignVal >> 10), 11, *buf, @result\bitLength)
    qrcodegen_internal_appendBitsToBuffer((assignVal & $3FF), 10, *buf, @result\bitLength)
  Else
    ;assert(false);
  EndIf
  result\Data = *buf
  
  ProcedureReturn @result
  
EndProcedure




; Calculates the number of bits needed To encode the given segments at the given version.
; Returns a non-negative number If successful. Otherwise returns -1 If a segment has too
; many characters To fit its length field, Or the total bits exceeds INT16_MAX.
Procedure.i qrcodegen_internal_getTotalBits(Array segs.qrcodegen_Segment(1), len.i, version.i)
  
  Protected i.i, result.i, numChars.i, bitLength.i, ccbits.i
  
  
  ;assert(segs != NULL || len == 0);
  
  For i = 0 To len - 1
    numChars = segs(i)\numChars
    bitLength = segs(i)\bitLength
    ;assert(0 <= numChars  && numChars  <= INT16_MAX);
    ;assert(0 <= bitLength && bitLength <= INT16_MAX);
    ccbits = qrcodegen_internal_numCharCountBits(segs(i)\mode, version)
    ;assert(0 <= ccbits && ccbits <= 16);
    If numChars >= (1 << ccbits)
      result = -1 ; The segment's length doesn't fit the field's bit width
      Break
    EndIf
    result + 4 + ccbits + bitLength
    If result > #INT16_MAX
      result = -1 ; The sum might overflow an int type
      Break
    EndIf
  Next i
  ;assert(0 <= result && result <= INT16_MAX);
  ProcedureReturn result
  
EndProcedure




; Returns the bit width of the character count field For a segment in the given mode
; in a QR Code at the given version number. The result is in the range [0, 16].
Procedure.i qrcodegen_internal_numCharCountBits(mode.i, version.i)
  
  Protected i.i, Result.i
  
  
  ;assert(qrcodegen_VERSION_MIN <= version && version <= qrcodegen_VERSION_MAX);
  i = (version + 7) / 17
  Select mode
    Case #qrcodegen_Mode_NUMERIC
      Select i
        Case 0 : Result = 10
        Case 1 : Result = 12
        Case 2 : Result = 14
        Default : Result = -1
      EndSelect
    Case #qrcodegen_Mode_ALPHANUMERIC
      Select i
        Case 0 : Result = 9
        Case 1 : Result = 11
        Case 2 : Result = 13
        Default : Result = -1
      EndSelect
    Case #qrcodegen_Mode_BYTE
      Select i
        Case 0 : Result = 8
        Case 1 : Result = 16
        Case 2 : Result = 16
        Default : Result = -1
      EndSelect
    Case #qrcodegen_Mode_KANJI
      Select i
        Case 0 : Result = 8
        Case 1 : Result = 10
        Case 2 : Result = 12
        Default : Result = -1
      EndSelect
    Case #qrcodegen_Mode_ECI
      Result = 0
    Default:
      ;assert(false);
      Result = -1 ;  // Dummy value
  EndSelect
  
  ProcedureReturn Result
  
EndProcedure


;-For PureBasic
Procedure.i qrcodegen_CreateTextImage(Text$, ErrCorLvl.i=#qrcodegen_Ecc_LOW, BoostEcl.i=#True, MinVersion.i=#qrcodegen_VERSION_MIN, MaxVersion.i=#qrcodegen_VERSION_MAX, Mask.i=#qrcodegen_Mask_AUTO, QuietZone.i=2)
  
  Protected.i bufferLen, qrsize, x, y, img
  Protected *qrcode, *tempBuffer
  
  
  bufferLen = qrcodegen_BUFFER_LEN_FOR_VERSION(maxVersion)
  *qrcode = AllocateMemory(bufferLen)
  If *qrcode
    *tempBuffer = AllocateMemory(bufferLen)
    If *tempBuffer
      
      If qrcodegen_encodeText(text$, *tempBuffer, *qrcode, errCorLvl, minVersion, maxVersion, mask, boostEcl)
        qrsize = qrcodegen_getSize(*qrcode)
        If qrsize > 0
          img = CreateImage(#PB_Any, qrsize + QuietZone * 2, qrsize + QuietZone * 2)
          If img
            If StartDrawing(ImageOutput(img))
              Box(0, 0, qrsize + QuietZone * 2, qrsize + QuietZone * 2, #White)
              For y = 0 To qrsize - 1
                For x = 0 To qrsize - 1
                  If qrcodegen_getModule(*qrcode, x, y)
                    Plot(x + QuietZone, y + QuietZone, #Black)
                  EndIf
                Next x
              Next y
              StopDrawing()
            EndIf
          EndIf
        EndIf
      EndIf
      
      FreeMemory(*tempBuffer)
    EndIf
    FreeMemory(*qrcode)
  EndIf
  
  ProcedureReturn img
  
EndProcedure


;-Demo
CompilerIf #PB_Compiler_IsMainFile
  
  Define.i img, magnifiedSize
  
  
  img = qrcodegen_CreateTextImage("Hello World")
  If img
    
    If ImageWidth(img) < 400
      magnifiedSize = ImageWidth(img) * (400 / ImageWidth(img))
      ResizeImage(img, magnifiedSize, magnifiedSize, #PB_Image_Raw)
    EndIf
    
    OpenWindow(0, 0, 0, ImageWidth(img), ImageHeight(img), "QRCodeGen Demo", #PB_Window_ScreenCentered|#PB_Window_MinimizeGadget)
    ImageGadget(0, 0, 0, 0, 0, ImageID(img))
    SetClipboardImage(img)
    
    Repeat
    Until WaitWindowEvent() = #PB_Event_CloseWindow
    
    FreeImage(img)
  EndIf
  
CompilerEndIf

; IDE Options = PureBasic 5.73 LTS (MacOS X - x64)
; Folding = ---------------------
; EnableXP