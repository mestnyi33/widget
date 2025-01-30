; Creates Images for Objects to allow direct drawing on them with various modes, using persistent and temporary images.
; In this fairly complex example, we will be able to draw directly on our Objects using persistent and temporary images.
; Double-click on an Object to edit its image, draw on it with the desired mode, then click outside the Object to confirm the drawing.

; Created on: 25/01/2025 by Dieppedalle David Alias Shadow.
; Translated into English With ChatGPT.
  
; Includes the program file.
XIncludeFile "EditorFactory.pbi" ; Editors Factory.pbi 1.19.

; Initializes the module to be used.
UseModule EditorFactory

EnableExplicit ; Enables strict variable management for better tracking.

; ---- Enumerations ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

; Window and Gadgets.
Enumeration 100
  #Window
  #Gadget_Canvas
  #ButtonDrawingMode1 ; Button Gadget for round drawing mode.
  #ButtonDrawingMode2 ; Button Gadget for filled square drawing mode.
  #ButtonDrawingMode3 ; Button Gadget for square border drawing mode.
EndEnumeration

; Objects.
Enumeration 1
  #Object1
  #Object2
  #Object3
  #Object4
EndEnumeration

; ---- Data ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

;{ DataSection
DataSection
  AdditionalImage_start:
    ; size : 7545 bytes
    Data.q $0A1A0A0D474E5089,$524448490D000000,$4000000040000000,$7169AA0000000608,$43436984010000DE,$6F72702043434950,$91280000656C6966,$851450C3483D917D,$20AC1C548A96D34F,$1C4545D93AA19222
    Data.q $AD0ADA50B0458AA5,$24349A0FF4BC983A,$9FC1C16B828E2E29,$AE0EAEB38B83AAC5,$A4E0ECE203F82082,$C45A1497DE2522E8,$70E77BCE3EF2E0F8,$0CD532ACD0807DDF,$5C44E91966AA01CC,$18822BD0C557E5CC
    Data.q $CC9EA662506A8045,$E3E1EEBEB9E1662C,$73FBDF79678C5DFB,$78913E01930529F5,$B33C41BC4586E98E,$2CAC2389F79CE969,$48350613C4E7C429,$25CE37E5D975C8FC,$79E9B231199E0587,$8BB962EA58B108E2
    Data.q $8AA389A78950D959,$BCE1597390BE51AA,$FE4FBB59D6AD59C5,$6A9D70C95B4170C2,$C8441489212C0904,$D768C42C2A82A3A8,$7F87B8F3A6913148,$02AB9325C8A7F1D8,$FC7242A0D4058E46,$6A7166B67BF07FE0
    Data.q $6D8BE081C70A4DD2,$B0D5A05DA1018C7F,$FE009D6EDB63EFED,$604D6BF8EB4AE067,$011E8B4746F493F6,$F7934775C5C0DBFD,$0C9749E8601DCB80,$BC08B14254FC91C9,$A05B8181E537D19F,$0FA71CFB5B9DCD77
    Data.q $1C1C037CB5669640,$7778F75ECA25E302,$DF9ED3BDFEDCF74F,$2E0658B872D69E0F,$474B6206000000D8,$832000B600F50044,$700900000038C62A,$00232E0000735948,$763FA57801232E00,$454D497407000000
    Data.q $F11233001F05E807,$74190000008EEF8B,$656D6D6F43745845,$746165724300746E,$2068746977206465,$170E8157504D4947,$54414449511B0000,$5565F4799BD5DA78,$FCDF7B9CFB3FDF95,$99462A81A81E6B9B
    Data.q $21C1052C51290107,$EEA71B74AD6515A6,$3A56B2742A36C1A5,$657B6E710D6EC749,$DD89D89AB6DDD5C5,$1101001C1145A5A6,$0A280A02A8628405,$0DEFF37EAAA280AA,$FEE71FCECE73DEF7,$CED469028A3F1EAA
    Data.q $BDE2BF7BCBAEEB5B,$7BFBDEEFEEF9F7BB,$CF81792F737E11F6,$2F50F5B7F4DFC174,$BFFEAFFBDFF777F7,$E6D7FEF10F5DDF69,$76EEFA6D1A35F910,$A1A1BCC4702CDDC1,$33875F87DE0BF2EF,$E93833E91EFC65E4
    Data.q $474B4F77DA402ABB,$579455E5F00E05D8,$520438577D7777DE,$19F4DA37E80E6B7E,$401A04D5E5EA0358,$D8D6990E8C6962BD,$9BA8DEA4D56CDA68,$BD15CF4C52F7800A,$B9B9864F8F6D39A9,$EAEFA740BA039FAE
    Data.q $11C397F9073EBD02,$5029D61E7E344FF2,$3D50C003016D0D2D,$759ED754A7D5EC65,$BB5B531CC791C0FA,$5EB8653D5965716A,$CE3553569F048D09,$7768BEBAF4239C07,$678E6A7A98683742,$EF4F71DF8FADDC1E
    Data.q $BB4E4E77CF6F5BE1,$874AE601981A6071,$F209D52F088E7D64,$20C09BC37EF5584F,$A3D549ED7A2C0230,$6C7C9C67EBEBC5FF,$16C6AB2ACB95D8FD,$D0631AD57AD55A35,$121C410F00421050,$8207D40434782102
    Data.q $CF8FCEE453CCB877,$6EFF793C36727B68,$5ED7EDEBB77BEDBF,$CE944C0E3020F737,$C83414BC22A1F4E8,$E2BF3E31F3B7F84B,$7A5D36B22C924943,$AF1A8BD2E3392BF1,$D34B25B8FD63613A,$5A4824922AB56AD1
    Data.q $55041403110498C1,$C450680D05150EF0,$7827BDE1C102827B,$34E6791CE08E6425,$77EB6E9D9EF275CB,$DBD9F5FABE5BD5EE,$92ED00CC674A6781,$F5884BC834657E2B,$A8BEBD7AC1ED8CB4,$FC9D963358AEAD5A
    Data.q $C18CEF3BAFBA0BEE,$C15B12191C6E3693,$531824A98B580924,$4B543A8088824C41,$022344540679D3BE,$03E09EA073827834,$7453CEF01778F721,$DC5A3C5F99907C0B,$7EFDDF75DC1BB5F5,$21ECC444A7B00B7B
    Data.q $15F21FA038B2F0D0,$EAD5AB46B56AD9A0,$DF4EDBDD78737AB2,$FB39CE34E745F171,$8315B03492E5B18C,$0D6B0624C1A90B11,$107516FC4A988248,$8A920575F81EA802,$814EB8F15B1EBBE0,$5382045A1D410577
    Data.q $F7903CF808BE3D54,$FA0FF5E4F34FF672,$B3DE55D4F4FF2E9B,$49016744F25BD81B,$C0ABE3057F65F61E,$E1E1E192C8C8C8C0,$79BD8FCCED46AD75,$8EF3C1C2F4BABFCF,$B530865490F97E3F,$B1262926C3524906
    Data.q $349163018C60C624,$D622C4914622AC41,$2D4853D6C2C31220,$8554709C7DCAE1FF,$8203101100681681,$B1AC11AC18C41041,$B31C9A5F8F0652D4,$DC9929CEE574E4E9,$62FF52A5F5EBB4FD,$D5F2CF301C85E0F9
    Data.q $6CBC3C3C3031A346,$F3B34B51FD787878,$E17EDE4BD9F6F63F,$1B5359578B0309F0,$A4D85B54910EA923,$3D1A22024982248A,$AFF988D126C41898,$92C1AD2609240A94,$6EBAAE5EDCFF9F26,$24785231747F8F8E
    Data.q $2882AC63C58F5078,$5882318318808082,$C8D7139AC247CBB1,$9F307FEFB69EA29A,$0BEC13945E17ABEA,$D2E6CD9BE301FEAC,$7BDE5D8F23E1E1E1,$4D82F5BD9CDEFBC3,$14BEB6356B49D68B,$CD2A431D524A5B53
    Data.q $0AC0111E0809BC68,$95C6982496C11624,$8F00C8C86A445537,$7FCEDC1F1DE5DEDC,$6845B3394E4AD8F9,$24F8868AA228A817,$A363180A27443D11,$56E392CAA4612573,$96E7764925D26BA4,$F606151780E97F6C
    Data.q $8E8E8E68057C7205,$92FD723E1E1E192E,$0DF5BEEA2EFBF36C,$9A486B5A4AB25AAF,$9865D5A4D58D31AB,$1CD10123046220CA,$54C16082B05181C1,$0D4A2A9012602A10,$B15F0F836A841CD3,$FDFF77F2CFB7FB8D
    Data.q $4C0631E4509E2C38,$9AF13183694C5040,$CB4B5260DBFF137F,$69A2CACB16A39186,$30505BEC5FDCB766,$4FB898724073E785,$D5AB48C0C0C0DA80,$39B3DEB39AAAD55A,$B030574B39F378BB,$A4C4AFA98558D31E
    Data.q $10E4245D28B11863,$9412443007CE9F4A,$A61A980908153514,$7773FAFE31D18752,$AEF3DE31F1FFBFF3,$D102CEC08E47A40D,$62BD418C0451C814,$171ABF46C4068204,$9556914B0310A9F0,$8EF6AABEF7BAC2E5
    Data.q $F3DA4FDD7D30F7A7,$C62F9EECF97CF4A5,$0C0DAB56B4F3EF9F,$EFDC75A4952F0F0F,$B0379E37A6FE305F,$EB6036B4C7AE0CC6,$9218C9316B2A6147,$ED02C1F9A0A31036,$4906A6A290098B00,$6591821D2441D203
    Data.q $1B6E7E4F8261B96C,$12D742D75BE77860,$B018CBC4C46C3130,$08C4155044062096,$86AB62A9B01182A4,$A7961B0AB5A43524,$15EA4BB54DE47F47,$35F69A65656302D6,$AF53337F40758760,$DE238181ADA3AB56
    Data.q $7EBB3A2F8BEEC679,$D6C46C698D1C0C8C,$18232A6357D4C48F,$82CC21B7C0EAA29B,$A6881444C49AC4EF,$06605A4134902B60,$A5F95C6A6608B9A0,$0C56239B4F6278FB,$31205742D6EBC172,$D406AA1189241620
    Data.q $3106278F892230C4,$9B1626C588C11106,$6E6729A6C135690A,$09763C7F17F69CAC,$C5E4937B2E181CB0,$1D5AB54AB3FE6038,$37C636974B1A346C,$EB15E1F4E494E6BD,$54C3AC6D80D819AC,$7E077D0950EC6257
    Data.q $313B4419F804C206,$A982A980CBCB44EC,$E6AC68318D216981,$21EF7C3FC2DA5FB3,$3C583AFE785C2B12,$7648D0555689590C,$29978910E6638A91,$1260B7F0898921D1,$6B73C84D5A409A4B,$0F7783FDCF486F36
    Data.q $79E6050E1D16026E,$AE9A71198C6EBF98,$8EA7D9D36CDCF4BD,$A615656C1AD6DA0E,$E4A2C63107631CBA,$447F7E033FC1A610,$A9355C6BF84AF480,$AE6811952269E344,$FF3FCAE36CEFFAE0,$7C5CF79C35A36329
    Data.q $7E495C108EF006C1,$24CCB624831740C4,$0251D12D504E4072,$4D8B1262893012C5,$C77B198C54B0DAA1,$2896564D83CDF589,$6780E50E40A1F7A8,$38D9AF63A69A7F31,$79B41B6A53BCE9B1,$4C6117548D5F5204
    Data.q $DC166EF2B892630B,$622D10E61093703E,$BF844A90F891B1D6,$BE329606107623AD,$8D882DFCFD7FCDB3,$FF386F06A2E97CB9,$60A3113507676848,$214926A040393404,$8629220FD62540AD,$608C015823190C4A
    Data.q $C36125490D492112,$7E7437DF47C27352,$0E7CF0143ECD05C9,$17D5F5B106F8AF98,$22A86ABE5F4E6E9E,$D47535843318D5F5,$FC0261DAB8B2541A,$D5BF2F881E828944,$628D8AD28AA7D646,$16E17F4F84B0297D
    Data.q $BA155A0609EBBCEE,$C56D4F5A6CD782BD,$A912B5E6F3A56428,$813A94350D054C10,$514F7966981AD806,$8C518824DB12C693,$426A921124588C55,$C6B39323E6CA936A,$102EAF45B2F2ED06,$81D5F53FA0380E62
    Data.q $D89D36D3DA27CDA1,$D828EA9815F52358,$93F2B96E84C51104,$EC622AD4BA6EF611,$D6C149505688318A,$E6ADA831F5216921,$DD5FC7FE16FAFF6F,$B9B984630348E8CC,$45B1203C7F5E8B9C,$42AD82A988B50156
    Data.q $20EC0B6909B4875A,$B10756C019244198,$A4CB26C6AD3626B5,$B58C518C06C458A8,$B2A462B0D56C1624,$3208719E6D2F77F1,$10D7A77CC0758594,$6CB29C92705D8C93,$097364717D49AD89,$41FB72F16421B6A8
    Data.q $929043C3B1DB4127,$D2616DA3F46C54AC,$CA3C5FBEE4AE6861,$549AC74603F8BE67,$E155A0672CDD09AA,$91A4C0E7004E0BC2,$0994C5188476242B,$4D03350B120498C9,$70CBDDEEA79B5E85,$2188D16EC568D02D
    Data.q $34844D15560311E0,$B5D1ED7B5B13D435,$3D0B658DCCC8BED3,$B740E022161ADA5B,$BA35D8F6B1A47CB7,$162B08BAA630EA9E,$C23C7E57299D00A1,$6802F8563EA0DB5E,$6487530352024A8A,$7DCF963309CB5A00
    Data.q $AF5EA59F1FECC7F1,$1B19F6739BB74020,$76846CF4036EB458,$DA98459204760432,$61A38ACC5AD0CC32,$1D8DDB705760F1C5,$3749DC71B7C7D3FE,$016B63B8DB9CF2B2,$0080392D51630552,$DC72C60224C5F912
    Data.q $288FD6A799D47268,$080B241B3FA541B3,$663D509D37340AB0,$3248A5952C30B2FD,$5547A8C0B4049880,$84480F56F5B17B41,$901A602A7EEB299F,$7FCB5D214B6A610C,$58BBDAF77C55D4FB,$B994E142231074BA
    Data.q $0B4095E8BC6F36D9,$B509A49047623AD5,$8A67B64AA035AA04,$2B66B9DF10F55FEF,$0793E3BD9DBF5ED7,$6F79C09FF7F2F288,$6942B5899EBB035F,$AA49625DF2BE7C42,$3D559CD7B1B8ED82,$80F1F4F7BABBF6F6
    Data.q $69C0FEFD39FAA92B,$7D4245EA071B2BEB,$1A28C62C5054C619,$DFFC5C60E7CB26CA,$527A76535160858C,$7BE1AE6851DD4B2D,$59F7FCFE9F39FADF,$701778B5348078B2,$9EB7B6F0AF51A785,$A02AC011C0E3D31F
    Data.q $EE0FED704F1DBECD,$7C6E8FCBDFEFEAE5,$29A6909034F69990,$D586C14EB98346AD,$5D93015E47F1FC83,$1318AA0226532BBC,$9A42358286248BA2,$26658DD511CA724A,$A012023F6113F4A8,$D2BB0AE37866A69A
    Data.q $244A910CBEA45624,$BE84C1EF07240125,$C609026327CFC256,$F5D8CB830C3B1034,$EB3435ECFCAE7EC0,$9547CB707A6AB529,$C833FAE562CF9BCD,$9F87BF3F67E61EA6,$EE6EFEBA3F3774DC,$85424DBCBD1767BE
    Data.q $03ECA8686461235A,$3B2E2B8F40772C94,$FAC7F1E0C763A19F,$425518AE20393D9A,$D36D658B018A35D9,$767DDD3033AA1EAF,$7540E8C072164826,$A49064D11F88F96C,$D0620E922ADA8832,$071978DA80528248
    Data.q $83365E626181224E,$D3EA7CC598096348,$D962B1775B3DC37F,$B8462B0F96822208,$6CC5F674D95B97F3,$24C43999A983B6DD,$C0E0CA46CD296BD4,$05E5AAA034128228,$FBF1C74DE6CE6E9D,$117DE177C6153C1F
    Data.q $04218264F1622615,$3386510A80DB6345,$3632797ABA322242,$76F2FD01073DC3BD,$3AD4D8363240D165,$934609A22A9A89A6,$3318979B59486618,$600CD49A31EDD652,$F0BF97C75CD0A3AB,$D562391BB5FCBE43
    Data.q $2C4D3382ECFB1222,$8D9A19EBBE3C77B9,$E19512208D66AD3A,$B2F7C6DD9E1C1A50,$3A90D9D9715FE2D8,$F26CA10E42166274,$0A50583DE9A73E82,$FDE8C945EAC694AD,$82485900E7DA5C3B,$929AB7543240C8C9
    Data.q $6DAA8BDA31EA30D4,$60B62DF3E3D28C7C,$6006498B8594258C,$767F3F7F5FB70578,$7952A41D192CD5E5,$B98D8924222DC76E,$C875DC94704204C8,$BF07F2EB2F4A0857,$E7B009C970DE6AF7,$13C4639F01D1421E
    Data.q $C11B8AB3C23DEC7C,$D1654290C183444B,$03AC2C13D85C1990,$24D460A91A6AB36C,$A031864A09C176A8,$20421C419D4B40E2,$318191D4829B01A8,$C99F7CCF89F2A4C2,$FB2CBE0F164B0EE9,$AE6191E2CE4E9D6E
    Data.q $DEF8D3DCC16737F8,$D4BE2082841E8434,$8C07C131C10A0F80,$0D5A62A008A62897,$68254E7C9BD82FA9,$EA2A822B18A9156A,$853A033A316740E7,$123C3621FDCC6CEA,$5D5083EB6AD940F4,$C1F9AE3AE67E9FC9
    Data.q $108BCC63AA1E192F,$C9E1459DBBF0F59D,$3C8E1AFC3FCB875C,$CFB0D3133ECC0973,$381660F1CECAE230,$A95113C6102EE450,$3E2E7C23B0B6B627,$B04DAE0F380A8803,$EAD443018C42F371,$B6B04985E2891050
    Data.q $E56FEFEEB94B4306,$6916E1E19ABCAF4F,$740B9C154DB5687A,$A3D7AC875CCE9CF3,$14696AD431504D5A,$39CED7305FB8393E,$133C3FA3F863B4FB,$11C05D77D5C57726,$F07F04EF34ACC7D4,$2A882821010A8247
    Data.q $6076249F3E988621,$0D5539DCFB93BA7B,$13780247A53AEA19,$7AC4AF8F4A94D569,$7C1363F4C035A01D,$5AF5092492D733E2,$BDBA3B9E4AD18165,$8E572B9DF8A9A99C,$2755E9B3C7B9DE70,$FDDFE8FE2ACD66B1
    Data.q $BE5006A2A626FB05,$DC3FF2E735E1CCB2,$27420FBDDD0EA304,$EF7897A1BA97D022,$1A880B88D6891127,$2D9F3D7B45E70042,$33B7C7B5ECF246C4,$1DBEA1970121793A,$C6200CCA7FA52551,$CD025AD8A680C6A2
    Data.q $E776DCD5F4F89F26,$28282989191A2CC3,$8C0B2C8CED647399,$EEBC75D4ED39360C,$FA38E3FCF9B3C7B5,$3F7622C063200DA4,$A86066ED8F1D85B2,$D7F8F76D9BE22CF5,$C0A77BF97F973AEF,$BCDC946CF908FBFE
    Data.q $FAB949484A13CF8B,$AA20074725C84A52,$17743A661AF501EB,$4DC007C67D259F6E,$45A316AEB9A9BACE,$629C10268BA2D156,$0A114052F588682D,$B95F8FF0AE18152C,$0D1AB427F97FCF95,$CF5D647AA7265042
    Data.q $B78A3DCEF39360D0,$9634E0BE2E54F9BC,$FE41CDE16E565BAC,$B7C3FCE46871B80C,$607232182F37447F,$1F2681E182DDBA6D,$1B98493EE82CECBF,$03847061EFA75D8F,$28C1A22170D1AEAB,$10447448264D4BE2
    Data.q $60BD3F69FEF9A08A,$27C81EFE0FA480C6,$B95776C764C4DD66,$213016258E590CD0,$405D125CC6256228,$9FF7F87BADBECEB5,$6A34BA75CC0819BC,$E9BDB79EBD9F5786,$663F2C09D172DE64,$A2876CE86D071975
    Data.q $D030C9314947AA83,$C468D1A4EE1BFAE6,$0EBD7302E7154962,$56ABC5799BF8FC9F,$BE1ED31F517B9EC1,$20F5897EF32D0420,$1AA82282B4DD9688,$737408A1017C57BC,$16CE1626E1393CED,$6C9989F234260B24
    Data.q $162B31389949A9FC,$1AA00EA24F83BC85,$804C47BC1F1B1230,$1E878FB93FF2E550,$2F5BC71F171DE09B,$47A32C7F5F1BC8DC,$1B7A61B5EC508F2F,$0C50AFDCBA891084,$B8A7C98A2D1A1D68,$9E072BD7A9478EE3
    Data.q $724729D6739DB664,$BDF1C7E984CF87C5,$5C42130C840ED049,$CE3B8D040441CF7D,$51734FB286B9EE52,$7CEFF605C079F067,$1242EB22EDF44DC6,$D3C8F93084564074,$84F5EDA36EE5DBBA,$DAC47F29307912A4
    Data.q $DFFBC333A0793E58,$7AB0C9F9FFAF84B9,$10F7D81D3A04B811,$4C418D3425AA1DEA,$4A876B12B577F07A,$198999E56ED74DC2,$E59FBD62011B2D96,$814BA4B9D97E3E5D,$082B843A94217BDD,$2500AC5273CDC0E2
    Data.q $216FE12F9DB32C68,$8F1CE080A12A8204,$F22494BAE6BB15CE,$FDCC064087F4076C,$9BA657E991EC91F2,$0FAF656BEA599A46,$B2BC0E2263F83918,$E0ECEC2CE82AACE9,$046EC746965D31B1,$B1B71EDCAD4A8B50
    Data.q $6DC3F75CAA01175F,$A605DE08C60AD354,$FB79B3CEFDDE33A6,$0CC5F0DBFD814F7B,$552E60EEFAC96EF8,$12AF7F9D665DCB45,$2CB977221F15E4FF,$CBDB72EF7716AB90,$19E7E010F9EC8239,$3BDCEC0F3A47B6EA
    Data.q $14DDF12D923C393C,$0F134BDB712A15EB,$C6C0285E4A10212E,$96CC4C4D06311161,$E65B04826D5EED44,$7052540CFD94B4A5,$2966CD00F4DFD705,$EC7C6A07060AF492,$7CF89133DE84AF83,$7C3B147DE0828A07
    Data.q $897881E4A10D6BE4,$ABE8B80CEF01F057,$FF185CE02F5C10A2,$FE9AF1CA07DD1DC9,$B1FE5080E7D35010,$F527B6E76E6A77BD,$045F1CDDF1CDD0E1,$61CB17501E7C79D4,$745A19751CB80575,$7C45D701D0917421
    Data.q $C7C32EDC79A5DC39,$5AA160E8E65F0099,$FBC3D0F176BBA1E7,$E99E98170A1355A9,$2B79E270E765C572,$1AD8A3B43429F261,$2CC946877FCCC472,$AF010201AFFC81E8,$E65C13BC0E085EA0,$2FD0F729A1E38571
    Data.q $640E4926FABBE5B7,$8301CA280EA0B301,$4B8CF6BBB8B66BF1,$8879702B2E057B4F,$28BE34BCD01E474D,$BC13973D35114508,$FD5ED91F78D4C03B,$A8588830145D3AC1,$58AF38EDFAEEB936,$1AEA795E0A77686B
    Data.q $3E176A61D3C1FA3E,$7568DC450FD08E9F,$57E6EE98D049BD31,$9D41BD413ABBC7DF,$C813A29EE7C173E0,$30277E48F0DEED0B,$DAC2AA16113C37D5,$EEF787FA605D8447,$65E848FAE3CB63BF,$BC059A0564279EF8
    Data.q $40A12022D1E16873,$252B805E40570382,$5C6959221751E0B3,$AA4904945AE158B5,$566AD3B61BC3F280,$7D8F975CDCCF0BC8,$41F6E6042BEA2CE8,$782105F51C8B46D1,$ABD841FC17218F8C,$47C510D8FAB36D8F
    Data.q $1CF7906453CE1409,$B3BBEBFFEDBA4C4F,$301B9C2EE80E9477,$BF019C227992DA0B,$A3ED4F6DDC5B7BFB,$4059701BBC9EBA17,$7B908E1680F2107B,$8C63EE397CE8F734,$C44ABF3ADB5B884A,$A655AB0491355355
    Data.q $56A92796E7724E77,$29C97DDE7267A613,$7C69FC61E39EF25C,$3C1AD9B8DD148336,$0830CA1659396BC6,$1884E0F383865168,$3B6F20CF8A704299,$9D6EE5DA6EF43E3A,$033385B383501F69,$FC606D061F301D0B
    Data.q $7EC3C774DF8E775B,$294F5C0F7C7374AB,$BB2923428427500A,$C42EA89621AA0FC8,$EAEE5AB960E17255,$6F1B8D5A813A52C6,$8D2BDE1EE9898C7E,$3BA19381FB7F857A,$CA2810EB804F684E,$F1A342D017047250
    Data.q $318FBD47A9744421,$20F790228AAFA21F,$EE3DD1E7B6B204EF,$9A72C6EA737DCFDE,$E688732A01A87DAC,$E27FA8D356D395D4,$1DB8F2DE3FF56E6F,$9F1577C55D702B27,$1885C4308BA76597,$9072B23E051E6116
    Data.q $D8DC4926AF3F0E88,$D4950769BC6E124C,$C69C0F91F1953132,$68B45EC4C3979BC9,$47CA431E4507BEA3,$E462A5F564E88583,$F3D247970069E123,$8374759BD3DCB819,$67B987FCF6F57BDB,$C8C4D43BD53C394F
    Data.q $BFECEC160E101CA1,$EF40FCDCB7FDD1FD,$3228E7AE7549C996,$9CB3C22842445970,$19871F396B28BA80,$D6D3F7D0816B117C,$451BBE7E9B9B74C0,$47BDE47C25A4F338,$B5C449DDF1A7FEC3,$2CFCC333A2E2ECCB
    Data.q $9007F78674A28061,$EF2059E58CA8B2E0,$F67FE17C4569B279,$19FD99AFD7F37E78,$E673E390E5B4BFB0,$9E029C32798A2479,$81F9BEDF53B5D4FE,$BD3CF790564997E2,$39E70615C0F4509E,$8C58BE24A67504E0
    Data.q $307F84BE1CCC4F04,$EE0F1F7FB8EC2690,$C73DF87C71DBA198,$9E6893D302B6B833,$D45DC80A2D028A13,$A72F1AE6A868F224,$704373E0DCB82F04,$281737A17790E790,$E1F17FE5D9EE3D7A,$2A9C219CAB7F4CAF
    Data.q $E1E7803D1871DF57,$DFE5E8FF41E8B982,$EF3C195AB07EFFCE,$0C101B130EB1C515,$6A0522025228ECB6,$A5B884900D104053,$7E9B95D48C403B86,$D65BE97397AC9BBE,$71FBBD87AEEFE973,$28BC832E0BB41B59
    Data.q $CDE123E0BC24A539,$5759895C84277CE7,$1C66F471DE4A7BC8,$F74B70BFFB87F63B,$C5FF62E1D767BCEF,$5970BF866B3D490C,$B270F56769FD91FB,$AA3A89068EB0CD7A,$751A2F08BCE72294,$56C4588966E25138
    Data.q $D9F2CB482A692CA2,$CBF8E7DB7DCFDFCF,$B53F0423EAC49C4F,$4BCF836F20662D1F,$2FBDC6509ED52B72,$973CBB16681D2C67,$A774F39BD02F4529,$A7BD5FC3DD27BB1D,$E00BFBBDBBAE7FF7,$B04E752FF7D5BEE9
    Data.q $E9F26C9999FE111F,$07ABE592DE5EDB69,$49A294D5E0C058C3,$31822258A26304E9,$A9B15490B528DCA6,$1F2B71FF43E7AE85,$EC2D6CBFEF2564B8,$F58DDE687367C49F,$3AB3A39792FF1944,$1CB8A17CA43131CF
    Data.q $40B9BD02F5929E8A,$1BE878B26BB1C66F,$9BEDF5E6FCDFE40F,$E1DD8C32C980A781,$69E766148BED05E6,$B4F43FF6CC9EEDCC,$FB0ED68BB2D1589D,$306823C150462A25,$24066A36AEE4BCE8,$6D8F0D54C58B48E5
    Data.q $FE5FC33D576BE59F,$0CF4DC3DAB867AC9,$F0A0CB8865C0779A,$9C103C9C8271B1A5,$20F45299E42E2B94,$3C66EB80D9B204EB,$6FB3BBABF96FC7B8,$BE33ED3FDA9BDFFC,$E6022C5F86E662F3,$89F2E77B1407248B
    Data.q $6B4943D5F1E01E6B,$33ED1213D59766AC,$26306AA261B884DA,$AAE18AD824A9370E,$BCEFCA596239C6EB,$D43D6426D1309863,$E7F8D445F1CB88E7,$10BE0B9704EF0C6B,$A281BA285DE4A65C,$DDDEF82438CCE9E3
    Data.q $AF9D07F9FFCDDCBB,$89F8D2EEEF6B6CFE,$277E8082AFFC6B17,$6D83FB3142164014,$23AB0D16C6AB079D,$5050F501E90CEA4B,$8C52412D4DA471B5,$6DE5D5D89E044849,$6864EBD1C018B5E7,$39F4AAB2F8B1C45E
    Data.q $F2285CF8A778AE68,$D93CF5902C8AEA98,$FF299EE85B3BA05C,$7FE87EEF8B3BF5C4,$8FB87FB4FF637F4E,$1C397965460B3BF1,$BDD00277982E2CF0,$9D931EDB8EDEF1FD,$24C1E1989A9AA983,$C4356E2108498234
    Data.q $1540CA148A5B5F09,$42B26C4EB2198D96,$3CD44BCD8B8508E1,$C81BAE299140F228,$BA05CEE9EBA281BB,$54F3DC4EAEED3993,$AFDBFBDEDD2FD3F1,$F839576006EE78FC,$FCB8EB2FF317DD30,$06260794A9931DF3
    Data.q $381BACE7C5A421CB,$BEBF1D37D6675DF5,$40FAE2E925EAC27E,$AA60AF5A425AD8C3,$BDECC96210B038F5,$704707C7BC43BD43,$C13DCB8704250A1E,$15EF27AE8A385141,$7DC5BD8EDF632E61,$669BADF2DFCC7BDF
    Data.q $FCE8981DF5F602EE,$B544F0EE1C4C0FBA,$6ACB31E8C02311CF,$AC27E9E6D4E77F1B,$A2C4727966BF1D6B,$349896A86B40D6B1,$C6A22F8232372D11,$0408A13CE0BCA650,$F4FC6D7B42F228E7,$1D1E2784EF19984C
    Data.q $D6E3B9DEDEAF5B77,$33EC9F18CA47DDAD,$1A1C39991D4DFB3C,$141A1F9FCCD08FFA,$663EAED2B29E8C9B,$2CD623BA8DD61B39,$D83239A4B25F2FAE,$21B115A9A312356C,$9E98AEF73EA67C04,$4F0B9C9C98114ED0
    Data.q $774763BCEDEED63F,$0EF5913DEB1FCFC7,$F770DE663C7F3C18,$F37363B8753438DB,$491AE6C77DAB04E7,$8DA49B75B5AD3492,$5568D0CDC39A1256,$B4F7834D55A8654C,$E53BDF2164EF3CF3,$21EE9EF6DF5D93DB
    Data.q $38BEF3A34AF5CD8E,$3938389BFEAB497F,$4D34C9A1E1748A8F,$E0E05E428A2D802B,$FED5887749E1FF64,$959D1EA5F2707167,$3A3F73FEACE8F15F,$C3EA01D438CE42FB,$B17E9E1EDFFF1BD5,$9F82F0293FCF23BF
    Data.q $34AAC807FFAFACBD,$0000008C7B70A88E,$6042AE444E454900
    Data.b $82
  AdditionalImage_end:
EndDataSection
;}

; ---- Variables -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

; Drawing type (1 to 3).
; 1 = Draw a Point.
; 2 = Draw a Filled Square.
; 3 = Draw a Square with Border.
Global DrawingType.i = 1

; Variable to save the mouse position on the Canvas.
Global CanvasMouseX.i
Global CanvasMouseY.i

; Variable to save the left mouse click position on the Canvas.
Global MouseLeftClickX.i
Global MouseLeftClickY.i

; ---- Procedures ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

; If the Object contains a valid Image in its data, returns it; otherwise, returns 0.
; Can be used to determine if an Object has an Image in its data. Warning: this does not check if the Image is valid, use IsImage(IsObjectCurrentImage(Object.i)) for this.
Procedure.i IsObjectCurrentImage(Object.i)
  
  ; If the Object has an Additional Image stored as a data value.
  Define ObjectImage.i = Val(GetObjectDictionary(Object.i, "CurrentImageID"))
  
  If ObjectImage.i <> 0 And IsImage(ObjectImage.i)
    ProcedureReturn ObjectImage.i
    
  Else
    ProcedureReturn 0
    
  EndIf
  
EndProcedure

; If the Object contains a valid temporary Image in its data (Used when the Object's Image is being edited), returns it; otherwise, returns 0.
; NumberImage.i is the number of the temporary Image to use: 1 = Temporary Image n°1 and 2 = Temporary Image n°2.
Procedure.i IsObjectTemporarilyImage(Object.i, NumberImage.i = 1)
  
  If NumberImage.i <= 0 
    NumberImage.i = 1
  EndIf
  
  If NumberImage.i > 2
    NumberImage.i = 2
  EndIf
  
  If NumberImage.i = 1
    
    ; If the Object has an Additional Image stored as a data value.
    Define ObjectImage.i = Val(GetObjectDictionary(Object.i, "TemporarilyImage1ID"))
    
  ElseIf NumberImage.i = 2
    
    ; If the Object has an Additional Image stored as a data value.
    Define ObjectImage.i = Val(GetObjectDictionary(Object.i, "TemporarilyImage2ID"))
    
  EndIf
  
  If ObjectImage.i <> 0 And IsImage(ObjectImage.i)
    ProcedureReturn ObjectImage.i
    
  Else
    ProcedureReturn 0
    
  EndIf
  
EndProcedure


; Creates an Image for the Object to add or edit Images on it.
; Warning: This function is essential and mandatory before using the other Object drawing functions, otherwise, it will not work!
Procedure.b CreateObjectImage(Object.i, Color.i = 838860800, AdditionalImage.i = 0, AdditionalImageX.i = 0, AdditionalImageY.i = 0, AdditionalImageTransparency.i = 255)
  
  ; If the Object exists.
  If IsObject(Object.i)
    
    Define InitCurrentImage.i
    Define InitTemporarilyImage1.i
    Define InitTemporarilyImage2.i
    Define ObjectCurrentImage.i
    Define ObjectTemporarilyImage1.i
    Define ObjectTemporarilyImage2.i
    
    ; Creates a transparent Image for the Object, which is the current Image.
    InitCurrentImage.i = CreateImage(#PB_Any, GetObjectWidth(Object.i), GetObjectHeight(Object.i), 32, #PB_Image_Transparent)
    
    ; Creates another transparent Image for the Object, which is Temporary Image 1 for drawing on.
    InitTemporarilyImage1.i = CreateImage(#PB_Any, GetObjectWidth(Object.i), GetObjectHeight(Object.i), 32, #PB_Image_Transparent)
    
    ; Creates another transparent Image for the Object, which is Temporary Image 2 for pre-drawing on.
    InitTemporarilyImage2.i = CreateImage(#PB_Any, GetObjectWidth(Object.i), GetObjectHeight(Object.i), 32, #PB_Image_Transparent)
    
    ; Verifies that the Images have been created and are valid.
    If IsImage(InitCurrentImage.i) And IsImage(InitTemporarilyImage1.i) And IsImage(InitTemporarilyImage2.i)
      
      ; Stores the Image in the Object's data.
      SetObjectDictionary(Object.i, "CurrentImageID", Str(InitCurrentImage.i))
      
      ; Stores the temporary Image in the Object's data.
      SetObjectDictionary(Object.i, "TemporarilyImage1ID", Str(InitTemporarilyImage1.i))
      
      ; Stores the temporary Image in the Object's data.
      SetObjectDictionary(Object.i, "TemporarilyImage2ID", Str(InitTemporarilyImage2.i))
      
      ; Indicates that the Image is not being edited.
      SetObjectDictionary(Object.i, "EditImage", "0")
      
      ObjectCurrentImage.i = IsObjectCurrentImage(Object.i)
      ObjectTemporarilyImage1.i = IsObjectTemporarilyImage(Object.i, 1)
      ObjectTemporarilyImage2.i = IsObjectTemporarilyImage(Object.i, 2)
      
      ; Verifies that the Images are properly registered.
      If ObjectCurrentImage.i And ObjectTemporarilyImage1.i And ObjectTemporarilyImage2.i
        
        If StartDrawing(ImageOutput(ObjectCurrentImage.i))
          
          DrawingMode(#PB_2DDrawing_AlphaBlend)
          
          ; Clears the Image with the custom color (Color.i).
          Box(0, 0, GetObjectWidth(#Object1), GetObjectHeight(#Object1), Color.i)
          
          ; If a valid additional Image exists, draw it on the Image at the specified position with the specified transparency.
          If IsImage(AdditionalImage.i)
            
            If AdditionalImageTransparency.i < 0
              AdditionalImageTransparency.i = 0
            EndIf
            
            If AdditionalImageTransparency.i > 255
              AdditionalImageTransparency.i = 255
            EndIf
            
            DrawAlphaImage(ImageID(AdditionalImage.i), AdditionalImageX.i, AdditionalImageY.i, AdditionalImageTransparency.i)
            
          EndIf
          
          StopDrawing()
          
        EndIf
        
        ProcedureReturn 1
        
      Else
        Debug "CreateObjectImage - Error: The Object " + Str(Object.i) + " does not have a valid Image !"
        ProcedureReturn 0
        
      EndIf
      
    Else
      Debug "CreateObjectImage - Error: Unable to create an Image for the Object " + Str(Object.i) + " !"
      ProcedureReturn 0
      
    EndIf
    
  Else
    Debug "CreateObjectImage - Error: Object " + Str(Object.i) + " not initialized !"
    ProcedureReturn 0
    
  EndIf

EndProcedure


; Custom procedure used in the procedure WhenDrawObject().
; Draws a point.
Procedure DrawPoint(CanvasGadget.i, CanvasMouseX.i, CanvasMouseY.i, Radius.i = 1, Color.i = -16777216) ; Mode 1.
  
  ; Draws on the Object's Images when the mouse is moved and the button is pressed.
  If IsGadget(CanvasGadget.i) And ExamineObjects(CanvasGadget.i)
    
    Define Object.i
    Object.i = NextObject(CanvasGadget.i)
    
    While Object.i
      
      If Radius.i <= -1
        Radius.i = 1
      EndIf
      
      ; If the Object is being edited and the left mouse button is pressed on it.
      If GetObjectDictionary(Object.i, "EditImage") = "1" And ObjectState(Object.i) & #State_LeftMousePushed
        
        ; Checks if the Object has Images in its data.
        Define ObjectCurrentImage.i = IsObjectCurrentImage(Object.i)
        Define ObjectTemporarilyImage1.i = IsObjectTemporarilyImage(Object.i, 1)
        
        ; Checks if the Object's Images are valid.
        If IsImage(ObjectCurrentImage.i) And IsImage(ObjectTemporarilyImage1.i)
          
          Define DrawX.i = CanvasMouseX - GetObjectX(Object.i) ; Local position.
          Define DrawY.i = CanvasMouseY - GetObjectY(Object.i) ; Local position.
          
          ; Draws the point.
          If StartDrawing(ImageOutput(ObjectTemporarilyImage1.i))
            DrawingMode(#PB_2DDrawing_AlphaBlend)
            Circle(DrawX.i, DrawY.i, Radius.i, Color.i)
            StopDrawing()
            
            ShowObject(Object.i) ; Triggers a refresh on the Canvas.
            
          EndIf
          
        Else
          Debug "DrawPoint - Error: The Object " + Str(Object.i) + " does not have an Image !"
          
        EndIf
        
      EndIf
      
      Object.i = NextObject(CanvasGadget.i)
      
    Wend
    
  EndIf
  
EndProcedure

; Custom procedure used in the procedure WhenDrawObject().
; Draws a square.
Procedure DrawBox(CanvasGadget.i, MouseLeftClickX.i, MouseLeftClickY.i, Color.i = -16777216) ; Mode 2.
  
  ; Draws on the Object's Images when the mouse is moved and the button is pressed.
  If IsGadget(CanvasGadget.i) And ExamineObjects(CanvasGadget.i)
    
    Define Object.i
    Object.i = NextObject(CanvasGadget.i)
    
    While Object.i
      
      ; If the Object is being edited and the left mouse button is pressed on it.
      If GetObjectDictionary(Object.i, "EditImage") = "1" And ObjectState(Object.i) & #State_LeftMousePushed
        
        ; Checks if the Object has Images in its data.
        Define ObjectTemporarilyImage2.i = IsObjectTemporarilyImage(Object.i, 2)
        
        ; Checks if the Object's Images are valid.
        If IsImage(ObjectTemporarilyImage2.i)
          
          Define DrawX.i = CanvasMouseX.i - GetObjectX(Object.i) ; Local position.
          Define DrawY.i = CanvasMouseY.i - GetObjectY(Object.i) ; Local position.
          
          If StartDrawing(ImageOutput(ObjectTemporarilyImage2.i))
            
            ; Clears the Image.
            DrawingMode(#PB_2DDrawing_AllChannels)
            Box(0, 0, GetObjectWidth(Object.i), GetObjectHeight(Object.i), RGBA(255, 255, 255, 0))
            
            ; Draws the square.
            DrawingMode(#PB_2DDrawing_AlphaBlend)
            Box(MouseLeftClickX.i, MouseLeftClickY.i, DrawX.i - MouseLeftClickX.i, DrawY.i - MouseLeftClickY.i, Color.i)
            StopDrawing()
            
            ShowObject(Object.i) ; Triggers a refresh on the Canvas.
            
          EndIf
          
        Else
          Debug "DrawBox - Error: The Object " + Str(Object.i) + " does not have an Image !"
          
        EndIf
        
      EndIf
      
      Object.i = NextObject(CanvasGadget.i)
      
    Wend
    
  EndIf
  
EndProcedure

; Custom procedure used in the procedure WhenDrawObject().
; Draws a square with a border.
Procedure DrawBorderBox(CanvasGadget.i, MouseLeftClickX.i, MouseLeftClickY.i, ColorBorderTop.i = -16777216, ColorBorderRight.i = -16777216, ColorBorderBottom.i = -16777216, ColorBorderLeft.i = -16777216, ColorInside.i = 16777215) ; Mode 3.
  
  ; Draws on the Object's Images when the mouse is moved and the button is pressed.
  If IsGadget(CanvasGadget.i) And ExamineObjects(CanvasGadget.i)
    
    Define Object.i
    Object.i = NextObject(CanvasGadget.i)
    
    While Object.i
      
      ; If the Object is being edited and the left mouse button is pressed on it.
      If GetObjectDictionary(Object.i, "EditImage") = "1" And ObjectState(Object.i) & #State_LeftMousePushed
        
        ; Checks if the Object has Images in its data.
        Define ObjectTemporarilyImage2.i = IsObjectTemporarilyImage(Object.i, 2)
        
        ; Checks if the Object's Image is valid.
        If IsImage(ObjectTemporarilyImage2.i)
          
          Define DrawX.i = CanvasMouseX.i - GetObjectX(Object.i) ; Local position.
          Define DrawY.i = CanvasMouseY.i - GetObjectY(Object.i) ; Local position.
          
          If StartDrawing(ImageOutput(ObjectTemporarilyImage2.i))
            
            ; Clears the Image.
            DrawingMode(#PB_2DDrawing_AllChannels)
            Box(0, 0, GetObjectWidth(Object.i), GetObjectHeight(Object.i), RGBA(255, 255, 255, 0))
            
            ; Draws the square with a border.
            DrawingMode(#PB_2DDrawing_AlphaBlend)
            Box(MouseLeftClickX.i, MouseLeftClickY.i, DrawX.i - MouseLeftClickX.i, DrawY.i - MouseLeftClickY.i, ColorInside.i)
            LineXY(MouseLeftClickX.i, MouseLeftClickY.i, DrawX.i, MouseLeftClickY.i, ColorBorderTop.i) ; Top line.
            LineXY(DrawX.i, MouseLeftClickY.i, DrawX.i, DrawY.i, ColorBorderRight.i) ; Right line.
            LineXY(DrawX.i, DrawY.i, MouseLeftClickX.i, DrawY.i, ColorBorderBottom.i) ; Bottom line.
            LineXY(MouseLeftClickX.i, DrawY.i, MouseLeftClickX.i, MouseLeftClickY.i, ColorBorderLeft.i) ; Left line.
            StopDrawing()
            
            ShowObject(Object.i) ; Triggers a refresh on the Canvas.
            
          EndIf
          
        Else
          Debug "DrawBorderBox - Error: The Object " + Str(Object.i) + " does not have an Image !"
          
        EndIf
        
      EndIf
      
      Object.i = NextObject(CanvasGadget.i)
      
    Wend
    
  EndIf
  
EndProcedure


; Updates the Image of the Object when the drawing is completed and confirmed by the user.
; Used in the WhenUnselectObject() procedure.
Procedure UpdatesObjectImage(Object.i)
  
  ; Verifies that the Object has Images in its data.
  Define ObjectCurrentImage.i = IsObjectCurrentImage(Object.i)
  Define ObjectTemporarilyImage1.i = IsObjectTemporarilyImage(Object.i, 1)
  
  ; Verifies that the Object's Images are valid.
  If IsImage(ObjectCurrentImage.i) And IsImage(ObjectTemporarilyImage1.i)
    
    Define Reponse.i = MessageRequester("Question...", "    Confirm changes made to the Object ?", #PB_MessageRequester_Info | #PB_MessageRequester_YesNo)
    
    If Reponse.i = #PB_MessageRequester_Yes
      
      ; Applies the temporary Image to the current Image.
      If StartDrawing(ImageOutput(ObjectCurrentImage.i))
        DrawingMode(#PB_2DDrawing_AlphaBlend)
        DrawImage(ImageID(ObjectTemporarilyImage1.i), 0, 0)
        StopDrawing()
        
      EndIf
      
      ; Clears the temporary Image without deleting it.
      If StartDrawing(ImageOutput(ObjectTemporarilyImage1.i))
        DrawingMode(#PB_2DDrawing_AllChannels)
        Box(0, 0, GetObjectWidth(Object.i), GetObjectHeight(Object.i), RGBA(255, 255, 255, 0))
        StopDrawing()
        
      EndIf
      
      ShowObject(Object.i) ; Triggers a refresh on the Canvas.
      
    Else
      
      ; Clears the temporary Image without deleting it.
      If StartDrawing(ImageOutput(ObjectTemporarilyImage1.i))
        DrawingMode(#PB_2DDrawing_AllChannels)
        Box(0, 0, GetObjectWidth(Object.i), GetObjectHeight(Object.i), RGBA(255, 255, 255, 0))
        StopDrawing()
        
      EndIf
      
      ShowObject(Object.i) ; Triggers a refresh on the Canvas.
      MessageRequester("Information...", "    Changes to the Object have been canceled !", #PB_MessageRequester_Info | #PB_MessageRequester_Ok)
      
    EndIf
    
  Else
    Debug "UpdatesObjectImage - Error: The Object " + Str(Object.i) + " does not have an Image !"
    
  EndIf
  
EndProcedure

; When an Object is double-clicked, it enters edit mode.
; Customizes its appearance. Used in the WhenDrawObject() procedure, see in the Object event loop.
Procedure WhenDoubleClickedObject(Object.i)
  
  ; If the Object exists.
  If IsObject(Object.i) And GetMouseHoveredObject() = Object.i
    
    ; Solid selection.
    SetObjectSelectionStyle(Object.i, #SelectionStyle_Solid, RGBA(255, 0, 0, 255), 3, 0)
    
    ; Temporarily removes the handles of the Object being edited.
    RemoveObjectHandle(Object.i, #Handle_Size | #Handle_Position)
    
    ; Custom cursor.
    SetObjectCursor(Object.i, #PB_Cursor_Cross)
    
    ; Indicates that the Image is being edited.
    SetObjectDictionary(Object.i, "EditImage", "1")
    
  EndIf
  
EndProcedure

; When an Object is being drawn, it is in edit mode. 
; This is where various drawing modes will be processed for direct drawing on the Objects.
; Each time something happens on the Canvas, this procedure will be called. See the Window event loop.
Procedure WhenDrawObject(Object.i, EventType.i)
  
  ; If the Object is valid.
  If IsObject(Object.i)
    
    ; Saves the mouse position on the Canvas each time something happens.
    CanvasMouseX.i = GetGadgetAttribute(#Gadget_Canvas, #PB_Canvas_MouseX)
    CanvasMouseY.i = GetGadgetAttribute(#Gadget_Canvas, #PB_Canvas_MouseY)
    
    Select EventType.i
        
      Case #PB_EventType_LeftButtonDown ; When the left mouse button is pressed on the Canvas.
        
        Select DrawingType.i
          Case 1
            ; If the drawing mode is 1, then we will draw a colored point. 
            ; You can change the size and color here.
            DrawPoint(#Gadget_Canvas, CanvasMouseX.i, CanvasMouseY.i, 2, RGBA(Random(255), Random(255), Random(255), 100))
            
          Case 2, 3 ; Saves the mouse click position on the Canvas if the drawing mode is greater than 1. 
            ; Used for pre-drawing, for example, a square or another shape.
            MouseLeftClickX.i = CanvasMouseX.i - GetObjectX(Object.i)
            MouseLeftClickY.i = CanvasMouseY.i - GetObjectY(Object.i)
        EndSelect
        
      Case #PB_EventType_LeftDoubleClick ; When the left mouse button is double-clicked on the Canvas.
        
        ; When the Canvas is double-clicked.
        WhenDoubleClickedObject(Object.i)
        
      Case #PB_EventType_MouseMove ; When the mouse moves over the Canvas.
        
        Select DrawingType.i
          Case 1
            ; If the drawing mode is 1, draw a colored point. 
            ; You can change the size and color here.
            DrawPoint(#Gadget_Canvas, CanvasMouseX.i, CanvasMouseY.i, 2, RGBA(Random(255), Random(255), Random(255), 100))
            
          Case 2
            ; If the drawing mode is 2, pre-draw a colored square with the mouse.
            ; You can change the color here.
            DrawBox(#Gadget_Canvas, MouseLeftClickX.i, MouseLeftClickY.i, RGBA(255, 0, 0, 175))
            
          Case 3
            ; If the drawing mode is 3, pre-draw a colored frame with the mouse.
            ; You can change the colors here.
            DrawBorderBox(#Gadget_Canvas, MouseLeftClickX.i, MouseLeftClickY.i, RGBA(Random(255), Random(255), Random(255), 175), RGBA(Random(255), Random(255), Random(255), 175), RGBA(Random(255), Random(255), Random(255), 175), RGBA(Random(255), Random(255), Random(255), 175))
        EndSelect
        
      Case #PB_EventType_LeftButtonUp ; When the left mouse button is released on the Canvas.
        
        ; Updates the temporary Images of the Object if it is being edited and the drawing mode is different from 1.
        If GetObjectDictionary(Object.i, "EditImage") = "1" And DrawingType.i <> 1
          
          ; Verifies that the Object has Images in its data.
          Define ObjectTemporarilyImage1.i = IsObjectTemporarilyImage(Object.i, 1)
          Define ObjectTemporarilyImage2.i = IsObjectTemporarilyImage(Object.i, 2)
          
          ; Verifies that the Object's Images are valid.
          If IsImage(ObjectTemporarilyImage1.i) And IsImage(ObjectTemporarilyImage2.i)
            
            Define DrawX.i = CanvasMouseX.i - GetObjectX(Object.i) ; Local position.
            Define DrawY.i = CanvasMouseY.i - GetObjectY(Object.i) ; Local position.
            
            If StartDrawing(ImageOutput(ObjectTemporarilyImage1.i))
              DrawingMode(#PB_2DDrawing_AlphaBlend)
              DrawImage(ImageID(ObjectTemporarilyImage2.i), 0, 0)
              StopDrawing()
              
              ShowObject(Object.i) ; Triggers a refresh on the Canvas.
              
            EndIf
            
            ; Clears the temporary Image without deleting it.
            If StartDrawing(ImageOutput(ObjectTemporarilyImage2.i))
              DrawingMode(#PB_2DDrawing_AllChannels)
              Box(0, 0, GetObjectWidth(Object.i), GetObjectHeight(Object.i), RGBA(255, 255, 255, 0))
              StopDrawing()
              
            EndIf
            
          Else
            Debug "WhenDrawObject - Error: The Object " + Str(Object.i) + " does not have an Image !"
          EndIf
          
        EndIf
        
    EndSelect
    
  EndIf

EndProcedure

; When an Object is deselected, this is where its image is updated. See the Object event loop.
Procedure WhenUnselectObject(Object.i)
  
  ; If the Object exists.
  If IsObject(Object.i)
    
    ; If the Object is being edited.
    If GetObjectDictionary(Object.i, "EditImage") = "1"
      
      ; Selection with dashed lines.
      SetObjectSelectionStyle(Object.i, #SelectionStyle_Dashed, RGBA(0, 0, 0, 255), 1, 0)
      
      ; Some non-exhaustive examples of Object handles.
      AddObjectHandle(Object.i, #Handle_Size | #Handle_Position) ; Resizable in all directions and movable.
      
      ; Custom cursor.
      SetObjectCursor(Object.i, #PB_Cursor_Hand)
      
      ; Indicates that the Object is no longer being edited.
      SetObjectDictionary(Object.i, "EditImage", "0")
      
      ; Applies the modified image to the Object.
      UpdatesObjectImage(Object.i)
      
    EndIf
    
  Else
    Debug "WhenUnselectObject - Warning: Object " + Str(Object.i) + " not initialized !"
    
  EndIf
  
EndProcedure

; When an Object is resized, its images are also resized. See the Object event loop.
Procedure WhenResizeObject(Object.i, CanvasGadget.i)
  
  Define NewCurrentImage.i
  Define NewTemporarilyImage1.i
  Define NewTemporarilyImage2.i
  
  If IsGadget(CanvasGadget.i)
    
    ; Verifies that the Object exists and that its images are valid.
    If IsObject(Object.i) And IsImage(IsObjectCurrentImage(Object.i)) And IsImage(IsObjectTemporarilyImage(Object.i, 1)) And IsImage(IsObjectTemporarilyImage(Object.i, 2))
      
      NewCurrentImage.i = GrabImage(IsObjectCurrentImage(Object.i), #PB_Any, 0, 0, GetObjectWidth(Object.i), GetObjectHeight(Object.i))
      NewTemporarilyImage1.i = GrabImage(IsObjectTemporarilyImage(Object.i, 1), #PB_Any, 0, 0, GetObjectWidth(Object.i), GetObjectHeight(Object.i))
      NewTemporarilyImage2.i = GrabImage(IsObjectTemporarilyImage(Object.i, 2), #PB_Any, 0, 0, GetObjectWidth(Object.i), GetObjectHeight(Object.i))
      
      FreeImage(IsObjectCurrentImage(Object.i))
      FreeImage(IsObjectTemporarilyImage(Object.i, 1))
      FreeImage(IsObjectTemporarilyImage(Object.i, 2))
      
      SetObjectDictionary(Object.i, "CurrentImageID", Str(NewCurrentImage.i))
      SetObjectDictionary(Object.i, "TemporarilyImage1ID", Str(NewTemporarilyImage1.i))
      SetObjectDictionary(Object.i, "TemporarilyImage2ID", Str(NewTemporarilyImage2.i))
      
    Else
      Debug "WhenResizeObject - Error: The Object " + Str(Object.i) + " does not have an Image !"
      
    EndIf
    
  EndIf
  
EndProcedure


; Custom drawing to render the Object with its images.
Runtime Procedure CustomDrawing(Object.i, Width.i, Height.i, iData.i)
  
  Define ObjectCurrentImage.i = IsObjectCurrentImage(Object.i) ; Checks if the Object has a valid image.
  Define ObjectTemporarilyImage1.i = IsObjectTemporarilyImage(Object.i, 1) ; Checks if the Object has a valid temporary image.
  Define ObjectTemporarilyImage2.i = IsObjectTemporarilyImage(Object.i, 2) ; Checks if the Object has another valid temporary image.
  
  ; If the Object has a current image, then display it.
  If ObjectCurrentImage.i
    MovePathCursor(0, 0)
    DrawVectorImage(ImageID(ObjectCurrentImage.i)) ; The image is stored in the Object's data.
    
    ; If the Object has temporary image 1 (When the Object is edited with drawing mode 1), then display it.
    If ObjectTemporarilyImage1.i
      MovePathCursor(0, 0)
      DrawVectorImage(ImageID(ObjectTemporarilyImage1.i)) ; The image is stored in the Object's data.
    EndIf
    
    ; If the Object has temporary image 2 (When the Object is edited with drawing modes 2 and 3), then display it.
    If ObjectTemporarilyImage2.i
      MovePathCursor(0, 0)
      DrawVectorImage(ImageID(ObjectTemporarilyImage2.i)) ; The image is stored in the Object's data.
    EndIf
    
  EndIf
  
  AddPathBox(0.5, 0.5, Width-1, Height-1)
  VectorSourceColor($80000000)
  StrokePath(1)
    
EndProcedure


; ---- Example ---------------------------------------------------------------------------------------------------------------------------------------

OpenWindow(#Window, 0, 0, 800, 450, "Draw on Objects...", #PB_Window_MinimizeGadget|#PB_Window_ScreenCentered)
CanvasGadget(#Gadget_Canvas, 0, 0, WindowWidth(#Window) - 50, WindowHeight(#Window), #PB_Canvas_Keyboard)

; Button for drawing mode 1 = Circle.
ButtonGadget(#ButtonDrawingMode1, WindowWidth(#Window) - 42, 10, 32, 32, "1", #PB_Button_Toggle)

; Button for drawing mode 2 = Filled squares.
ButtonGadget(#ButtonDrawingMode2, WindowWidth(#Window) - 42, 45, 32, 32, "2", #PB_Button_Toggle)

; Button for drawing mode 3 = Empty squares with borders.
ButtonGadget(#ButtonDrawingMode3, WindowWidth(#Window) - 42, 80, 32, 32, "3", #PB_Button_Toggle)

; Activates button 1.
SetGadgetState(#ButtonDrawingMode1, #True)

; ---- Objects ---------------------------------------------------------------------------------------------------------------------------------------

; Initializes the Canvas for managing Objects inside it.
InitializeCanvasObjects(#Gadget_Canvas, #Window)

; Creation of four Objects.
CreateObject(#Gadget_Canvas, #Object1, 20, 20, 200, 100)
CreateObject(#Gadget_Canvas, #Object2, 240, 20, 200, 100)
CreateObject(#Gadget_Canvas, #Object3, 20, 140, 200, 100)
CreateObject(#Gadget_Canvas, #Object4, 240, 140, 200, 100)

; Creates Images for the Objects.
; It is possible to customize (Optional) the background color of this image and also add an additional image with some options.
CreateObjectImage(#Object1, RGBA(255, 200, 0, 50), CatchImage(#PB_Any, ?AdditionalImage_start), 25, 16, 100)
CreateObjectImage(#Object2, RGBA(255, 0, 0, 50), CatchImage(#PB_Any, ?AdditionalImage_start), 25, 16)
CreateObjectImage(#Object3, RGBA(0, 150, 0, 50), CatchImage(#PB_Any, ?AdditionalImage_start), 115, 16, 100)
CreateObjectImage(#Object4, RGBA(0, 0, 255, 50), CatchImage(#PB_Any, ?AdditionalImage_start), 115, 16)

; Sets the drawing procedure for the Objects.
SetObjectDrawingCallback(#Object1, "CustomDrawing()")
SetObjectDrawingCallback(#Object2, "CustomDrawing()")
SetObjectDrawingCallback(#Object3, "CustomDrawing()")
SetObjectDrawingCallback(#Object4, "CustomDrawing()")

; Sets the handles for the Objects.
AddObjectHandle(#Object_All, #Handle_Size | #Handle_Position) ; Resizable in all directions and movable.

; Activates and customizes the mouse cursor selection on the Canvas for selecting Objects.
SetCursorSelectionStyle(#Gadget_Canvas, #SelectionStyle_Dotted, RGBA(0, 0, 0, 255), 1, 0)

; Sets the selection style for the Objects.
SetObjectSelectionStyle(#Object_All, #SelectionStyle_Dashed, RGBA(0, 0, 0, 255), 1, 0)

; Limits the minimum and maximum position of the Objects on the Canvas.
SetObjectBoundaries(#Object_All, 0, 0, GadgetWidth(#Gadget_Canvas), GadgetHeight(#Gadget_Canvas))

; Sets the cursor style for the Objects.
SetObjectCursor(#Object_All, #PB_Cursor_Hand)

; ---- Window and Object event management ---------------------------------------------------------------------------------------------------------------------------------------------------

Define Canevas.i ; To know on which Canvas the event occurred.
Define EventType.i ; To know what type of event occurred on the Canvas.
Define Object.i ; The Object number where something happened.

Repeat
	
	Select WaitWindowEvent()
		
		Case #PB_Event_Gadget
		  
			Select EventGadget()
				
			  Case #Gadget_Canvas
			    
			    ; Each time something happens on the Canvas, the WhenDrawObject() procedure will be called.
			    EventType.i = EventType()
			    WhenDrawObject(Object.i, EventType.i) ; The Object number is automatically obtained when something happens to it, see below.
			    
			  Case #ButtonDrawingMode1
			    
			    If GetGadgetState(#ButtonDrawingMode1) = #False
			      SetGadgetState(#ButtonDrawingMode1, #True)
			    EndIf
			    
			    SetGadgetState(#ButtonDrawingMode2, #False)
			    SetGadgetState(#ButtonDrawingMode3, #False)
			    
			    DrawingType.i = 1
			    
			    Debug "Drawing mode 1 activated."
			    
			  Case #ButtonDrawingMode2
			    
			    If GetGadgetState(#ButtonDrawingMode2) = #False
			      SetGadgetState(#ButtonDrawingMode2, #True)
			    EndIf
			    
			    SetGadgetState(#ButtonDrawingMode1, #False)
			    SetGadgetState(#ButtonDrawingMode3, #False)
			    
			    DrawingType.i = 2
			    
			    Debug "Drawing mode 2 activated."
			    
			  Case #ButtonDrawingMode3
			    
			    If GetGadgetState(#ButtonDrawingMode3) = #False
			      SetGadgetState(#ButtonDrawingMode3, #True)
			    EndIf
			    
			    SetGadgetState(#ButtonDrawingMode1, #False)
			    SetGadgetState(#ButtonDrawingMode2, #False)
			    
			    DrawingType.i = 3
			    
			    Debug "Drawing mode 3 activated."
			    
			EndSelect
			
		Case #PB_Event_CloseWindow
			Break
		
	EndSelect
	
  ; Object event loop on the Canvas.
  Repeat
    
    Select CanvasObjectsEvent() ; Something happened on a Canvas.
        
      Case #Event_Object ; This is an Object event.
        
        Canevas.i = CanvasObjectsEventGadget() ; On which Canvas did the event occur?
        Object.i = EventObject(Canevas.i)      ; On which Object did the event occur?
        
        Select CanvasObjectsEventType(Canevas.i) ; What type of event occurred on the Canvas Object?
            
          Case #EventType_MouseEnter
            Debug "The mouse entered Object #" + Object.i + "."
            
          Case #EventType_MouseLeave
            Debug "The mouse left Object #" + Object.i + "."
            
          Case #EventType_LeftMouseBottonDown
            Debug "The left mouse button was pressed on Object #" + Object.i + "."
            
          Case #EventType_LeftMouseBottonUp
            Debug "The left mouse button was released on Object #" + Object.i + "."
            
          Case #EventType_LeftMouseClick
            Debug "A left mouse click occurred on Object #" + Object.i + "."
            
          Case #EventType_LeftMouseDoubleClick
            Debug "A left mouse double-click occurred on Object #" + Object.i + "."
            
          Case #EventType_MiddleMouseBottonDown
            Debug "The middle mouse button was pressed on Object #" + Object.i + "."
            
          Case #EventType_MiddleMouseBottonUp
            Debug "The middle mouse button was released on Object #" + Object.i + "."
            
          Case #EventType_MiddleMouseClick
            Debug "A middle mouse click occurred on Object #" + Object.i + "."
            
          Case #EventType_MiddleMouseDoubleClick
            Debug "A middle mouse double-click occurred on Object #" + Object.i + "."
            
          Case #EventType_RightMouseBottonDown
            Debug "The right mouse button was pressed on Object #" + Object.i + "."
            
          Case #EventType_RightMouseBottonUp
            Debug "The right mouse button was released on Object #" + Object.i + "."
            
          Case #EventType_RightMouseClick
            Debug "A right mouse click occurred on Object #" + Object.i + "."
            
          Case #EventType_RightMouseDoubleClick
            Debug "A right mouse double-click occurred on Object #" + Object.i + "."
            
          Case #EventType_MouseWheel
            If CanvasObjectsEventData(Canevas.i) > 0
              Debug "The mouse wheel was scrolled up on Object #" + Object.i + "."
            Else
              Debug "The mouse wheel was scrolled down on Object #" + Object.i + "."
            EndIf
            
          Case #EventType_KeyUp
            Debug "The keyboard key " + Chr(CanvasObjectsEventData(Canevas.i)) + " was pressed on Object #" + Object.i + "." ; See the ASCII table.
            
          Case #EventType_KeyDown
            Debug "The keyboard key " + Chr(CanvasObjectsEventData(Canevas.i)) + " was released on Object #" + Object.i + "." ; See the ASCII table.
            
          Case #EventType_Selected
            Debug "Object #" + Object.i + " was selected."
            
          Case #EventType_Unselected ; If an Object was deselected, hide the temporary Canvas if it is active.
            Debug "Object #" + Object.i + " was deselected."
            ; When clicking outside the Object being edited, to confirm the changes, the Object's image is updated.
            WhenUnselectObject(Object.i)
            
          Case #EventType_Resized
            Debug "Object #" + Object.i + " was resized."
            ; When an Object is resized, change the size of the Object's Images.
            WhenResizeObject(Object.i, Canevas.i)
            
          Case #EventType_Selection
            Define SelectionX.i = CanvasObjectsEventData(Canevas.i, #EventTypeData_MinX)
            Define SelectionY.i = CanvasObjectsEventData(Canevas.i, #EventTypeData_MinY)
            Define SelectionLargeur.i = CanvasObjectsEventData(Canevas.i, #EventTypeData_MaxX) - SelectionX.i
            Define SelectionHauteur.i = CanvasObjectsEventData(Canevas.i, #EventTypeData_MaxY) - SelectionY.i
            Debug "A selection was made: ({X: " + Str(SelectionX.i) + ", Y: " + Str(SelectionY.i) + "}, {Width: " + Str(SelectionLargeur.i) + ", Height: " + Str(SelectionHauteur.i) + "})."
            
        EndSelect
        
      Case #Event_None ; No events.
        Break          ; Never omit this or the program will loop indefinitely!
        
    EndSelect
    
  ForEver
	
ForEver

; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 964
; FirstLine = 930
; Folding = ------------
; EnableXP