;=============================================================================
;
; Author:     blueb   
; Date:       May 7, 2017
; Reason:     I needed a better ColorRequester() Tool
;
; Usage: A Color Tool combining HeX0R's WikiColor and Graves's Color Picker Tool.
;
; See:  HeX0R.. http://www.purebasic.fr/english/viewtopic.php?p=457088#p457088
;      Graves.. http://www.purebasic.fr/english/viewtopic.php?p=379720#p379720
;
; Saved as: Designer Color Tool.pb
; ver. 1.1 - made Window Sticky and able to Minimize
;==============================================================================

Global my_COLORS.s = "250,255,220|255,225,255|225,250,225|64,255,64|200,200,200|0,32,64|225,250,225|255,200,80|210,190,140"
Global d2h.s = "0123456789ABCDEF"
Global hcolor.s = "$000000"

Macro Dec2Hex(n)
  Mid(d2h,(n/16)+1,1)+Mid(d2h,(n%16)+1,1)
EndMacro

Macro divide_cols(col)
  Val(StringField(col,1,",")), Val(StringField(col,2,",")), Val(StringField(col,3,","))
EndMacro

Procedure SetTracks(rd,gr,bl)
  co = RGB(rd,gr,bl)
  hcolor.s = "$"+Dec2Hex(bl)+Dec2Hex(gr)+Dec2Hex(rd)
  SetGadgetState(1,rd)
  SetGadgetState(2,gr)
  SetGadgetState(3,bl)
  SetGadgetText (11,RSet(Str(rd),3,"0"))
  SetGadgetText (12,RSet(Str(gr),3,"0"))
  SetGadgetText (13,RSet(Str(bl),3,"0"))
  SetGadgetText (14,hcolor)
  SetGadgetText (15,Str(co))
  SetGadgetColor(21,#PB_Gadget_FrontColor,0)
  SetGadgetColor(21,#PB_Gadget_BackColor,co)
  SetGadgetColor(22,#PB_Gadget_FrontColor,$FFFFFF)
  SetGadgetColor(22,#PB_Gadget_BackColor,co)
  SetGadgetColor(23,#PB_Gadget_FrontColor,co)
  SetGadgetColor(23,#PB_Gadget_BackColor,0)
  SetGadgetColor(24,#PB_Gadget_FrontColor,co)
  SetGadgetColor(24,#PB_Gadget_BackColor,$FFFFFF)
  SetGadgetColor(25,#PB_Gadget_FrontColor,co)
EndProcedure

Structure _WIKICOLORLIST_
   Name$
   Color.l
EndStructure

Procedure InitWikiColorList(List WKL._WIKICOLORLIST_())
   Protected a$

   Restore WikiColorList_Names
   Repeat
      Read.s a$
      If a$
         AddElement(WKL())
         WKL()\Name$ = a$
      EndIf
   Until a$ = ""

   Restore WikiColorList_Colors
   ForEach WKL()
      Read.l WKL()\Color
   Next

EndProcedure

DataSection
   WikiColorList_Names:
   Data.s "AcidGreen", "Aero", "AeroBlue", "AfricanViolet", "AirForceBlue_RAF", "AirForceBlue_USAF", "AirSuperiorityBlue", "AlabamaCrimson"
   Data.s "AliceBlue", "AlizarinCrimson", "AlloyOrange", "Almond", "Amaranth", "AmaranthDeepPurple", "AmaranthPink", "AmaranthPurple"
   Data.s "AmaranthRed", "Amazon", "Amber", "Amber_SAE_ECE", "AmericanRose", "Amethyst", "AndroidGreen", "AntiFlashWhite"
   Data.s "AntiqueBrass", "AntiqueBronze", "AntiqueFuchsia", "AntiqueRuby", "AntiqueWhite", "Ao_English", "AppleGreen", "Apricot"
   Data.s "Aqua", "Aquamarine", "ArmyGreen", "Arsenic", "Artichoke", "ArylideYellow", "AshGrey", "Asparagus"
   Data.s "AtomicTangerine", "Auburn", "Aureolin", "AuroMetalSaurus", "Avocado", "Azure", "Azure_WebColor", "AzureMist"
   Data.s "AzureishWhite", "BabyBlue", "BabyBlueEyes", "BabyPink", "BabyPowder", "BakerMillerPink", "BallBlue", "BananaMania"
   Data.s "BananaYellow", "BangladeshGreen", "BarbiePink", "BarnRed", "BattleshipGrey", "Bazaar", "BeauBlue", "Beaver"
   Data.s "Beige", "BdazzledBlue", "BigDipO?ruby", "Bisque", "Bistre", "BistreBrown", "BitterLemon", "BitterLime"
   Data.s "Bittersweet", "BittersweetShimmer", "Black", "BlackBean", "BlackLeatherJacket", "BlackOlive", "BlanchedAlmond", "BlastOffBronze"
   Data.s "BleuDeFrance", "BlizzardBlue", "Blond", "Blue_Crayola", "Blue_Munsell", "Blue_NCS", "Blue_Pantone", "Blue_Pigment"
   Data.s "Blue_RYB", "BlueBell", "BlueGray", "BlueGreen", "BlueLagoon", "BlueMagentaViolet", "BlueSapphire", "BlueViolet"
   Data.s "BlueYonder", "Blueberry", "Bluebonnet", "Blush", "Bole", "BondiBlue", "Bone", "BostonUniversityRed"
   Data.s "BottleGreen", "Boysenberry", "BrandeisBlue", "Brass", "BrickRed", "BrightCerulean", "BrightGreen", "BrightLavender"
   Data.s "BrightLilac", "BrightMaroon", "BrightNavyBlue", "BrightPink", "BrightTurquoise", "BrightUbe", "BrilliantAzure", "BrilliantLavender"
   Data.s "BrilliantRose", "BrinkPink", "BritishRacingGreen", "Bronze", "BronzeYellow", "Brown_Traditional", "Brown_Web", "BrownNose"
   Data.s "BrownYellow", "BrunswickGreen", "BubbleGum", "Bubbles", "Buff", "BudGreen", "BulgarianRose", "Burgundy"
   Data.s "Burlywood", "BurntOrange", "BurntSienna", "BurntUmber", "Byzantine", "Byzantium", "Cadet", "CadetBlue"
   Data.s "CadetGrey", "CadmiumGreen", "CadmiumOrange", "CadmiumRed", "CadmiumYellow", "CaféAuLait", "CaféNoir", "CalPolyGreen"
   Data.s "CambridgeBlue", "Camel", "CameoPink", "CamouflageGreen", "CanaryYellow", "CandyAppleRed", "CandyPink", "Capri"
   Data.s "CaputMortuum", "Cardinal", "CaribbeanGreen", "Carmine", "Carmine_MAndP", "CarminePink", "CarmineRed", "CarnationPink"
   Data.s "Carnelian", "CarolinaBlue", "CarrotOrange", "CastletonGreen", "CatalinaBlue", "Catawba", "CedarChest", "Ceil"
   Data.s "Celadon", "CeladonBlue", "CeladonGreen", "Celeste", "CelestialBlue", "Cerise", "CerisePink", "Cerulean"
   Data.s "CeruleanBlue", "CeruleanFrost", "CGBlue", "CGRed", "Chamoisee", "Champagne", "Charcoal", "CharlestonGreen"
   Data.s "CharmPink", "Chartreuse_Traditional", "Chartreuse_Web", "Cherry", "CherryBlossomPink", "Chestnut", "ChinaPink", "ChinaRose"
   Data.s "ChineseRed", "ChineseViolet", "Chocolate_Traditional", "Chocolate_Web", "ChromeYellow", "Cinereous", "Cinnabar", "Cinnamon[citationNeeded]"
   Data.s "Citrine", "Citron", "Claret", "ClassicRose", "CobaltBlue", "CocoaBrown", "Coconut", "Coffee"
   Data.s "ColumbiaBlue", "CongoPink", "CoolBlack", "CoolGrey", "Copper", "Copper_Crayola", "CopperPenny", "CopperRed"
   Data.s "CopperRose", "Coquelicot", "Coral", "CoralPink", "CoralRed", "Cordovan", "Corn", "CornellRed"
   Data.s "CornflowerBlue", "Cornsilk", "CosmicLatte", "CoyoteBrown", "CottonCandy", "Cream", "Crimson", "CrimsonGlory"
   Data.s "CrimsonRed", "CyanAzure", "CyanBlueAzure", "CyanCobaltBlue", "CyanCornflowerBlue", "Cyan_Process", "CyberGrape", "CyberYellow"
   Data.s "Daffodil", "Dandelion", "DarkBlue", "DarkBlueGray", "DarkBrown", "DarkBrownTangelo", "DarkByzantium", "DarkCandyAppleRed"
   Data.s "DarkCerulean", "DarkChestnut", "DarkCoral", "DarkCyan", "DarkElectricBlue", "DarkGoldenrod", "DarkGray_X11", "DarkGreen"
   Data.s "DarkGreen_X11", "DarkImperialBlue", "DarkImperialBlue_", "DarkJungleGreen", "DarkKhaki", "DarkLava", "DarkLavender", "DarkLiver"
   Data.s "DarkLiver_Horses", "DarkMagenta", "DarkMediumGray", "DarkMidnightBlue", "DarkMossGreen", "DarkOliveGreen", "DarkOrange", "DarkOrchid"
   Data.s "DarkPastelBlue", "DarkPastelGreen", "DarkPastelPurple", "DarkPastelRed", "DarkPink", "DarkPowderBlue", "DarkPuce", "DarkPurple"
   Data.s "DarkRaspberry", "DarkRed", "DarkSalmon", "DarkScarlet", "DarkSeaGreen", "DarkSienna", "DarkSkyBlue", "DarkSlateBlue"
   Data.s "DarkSlateGray", "DarkSpringGreen", "DarkTan", "DarkTangerine", "DarkTaupe", "DarkTerraCotta", "DarkTurquoise", "DarkVanilla"
   Data.s "DarkViolet", "DarkYellow", "DartmouthGreen", "DavysGrey", "DebianRed", "DeepAquamarine", "DeepCarmine", "DeepCarminePink"
   Data.s "DeepCarrotOrange", "DeepCerise", "DeepChampagne", "DeepChestnut", "DeepCoffee", "DeepFuchsia", "DeepGreen", "DeepGreenCyanTurquoise"
   Data.s "DeepJungleGreen", "DeepKoamaru", "DeepLemon", "DeepLilac", "DeepMagenta", "DeepMaroon", "DeepMauve", "DeepMossGreen"
   Data.s "DeepPeach", "DeepPink", "DeepPuce", "DeepRed", "DeepRuby", "DeepSaffron", "DeepSkyBlue", "DeepSpaceSparkle"
   Data.s "DeepSpringBud", "DeepTaupe", "DeepTuscanRed", "DeepViolet", "Deer", "Denim", "DesaturatedCyan", "Desert"
   Data.s "DesertSand", "Desire", "Diamond", "DimGray", "Dirt", "DodgerBlue", "DogwoodRose", "DollarBill"
   Data.s "DonkeyBrown", "Drab", "DukeBlue", "DustStorm", "DutchWhite", "EarthYellow", "Ebony", "Ecru"
   Data.s "EerieBlack", "Eggplant", "Eggshell", "EgyptianBlue", "ElectricBlue", "ElectricCrimson", "ElectricCyan", "ElectricGreen"
   Data.s "ElectricIndigo", "ElectricLavender", "ElectricLime", "ElectricPurple", "ElectricUltramarine", "ElectricViolet", "ElectricYellow", "Emerald"
   Data.s "Eminence", "EnglishGreen", "EnglishLavender", "EnglishRed", "EnglishViolet", "EtonBlue", "Eucalyptus", "Fallow"
   Data.s "FaluRed", "Fandango", "FandangoPink", "FashionFuchsia", "Fawn", "Feldgrau", "Feldspar", "FernGreen"
   Data.s "FerrariRed", "FieldDrab", "Firebrick", "FireEngineRed", "Flame", "FlamingoPink", "Flattery", "Flavescent"
   Data.s "Flax", "Flirt", "FloralWhite", "FluorescentOrange", "FluorescentPink", "FluorescentYellow", "Folly", "ForestGreen_Traditional"
   Data.s "ForestGreen_Web", "FrenchBeige", "FrenchBistre", "FrenchBlue", "FrenchFuchsia", "FrenchLilac", "FrenchLime", "FrenchMauve"
   Data.s "FrenchPink", "FrenchPlum", "FrenchPuce", "FrenchRaspberry", "FrenchRose", "FrenchSkyBlue", "FrenchViolet", "FrenchWine"
   Data.s "FreshAir", "Fuchsia", "Fuchsia_Crayola", "FuchsiaPink", "FuchsiaPurple", "FuchsiaRose", "Fulvous", "FuzzyWuzzy"
   Data.s "Gainsboro", "Gamboge", "GambogeOrange_Brown", "GenericViridian", "GhostWhite", "GiantsOrange", "Grussrel", "Glaucous"
   Data.s "Glitter", "GOGreen", "Gold_Metallic", "Gold_Web_Golden", "GoldFusion", "GoldenBrown", "GoldenPoppy", "GoldenYellow"
   Data.s "Goldenrod", "GrannySmithApple", "Grape", "Gray", "Gray_HTML_CSSGray", "Gray_X11Gray", "GrayAsparagus", "GrayBlue"
   Data.s "Green_ColorWheel_X11Green", "Green_Crayola", "Green_HTML_CSSColor", "Green_Munsell", "Green_NCS", "Green_Pantone", "Green_Pigment", "Green_RYB"
   Data.s "GreenBlue", "GreenCyan", "GreenYellow", "Grizzly", "Grullo", "GuppieGreen", "HalayàÚbe", "HanBlue"
   Data.s "HanPurple", "HansaYellow", "Harlequin", "HarlequinGreen", "HarvardCrimson", "HarvestGold", "HeartGold", "Heliotrope"
   Data.s "HeliotropeGray", "HeliotropeMagenta", "HollywoodCerise", "Honeydew", "HonoluluBlue", "HookersGreen", "HotMagenta", "HotPink"
   Data.s "HunterGreen", "Iceberg", "Icterine", "IlluminatingEmerald", "Imperial", "ImperialBlue", "ImperialPurple", "ImperialRed"
   Data.s "Inchworm", "Independence", "IndiaGreen", "IndianRed", "IndianYellow", "Indigo", "IndigoDye", "Indigo_Web"
   Data.s "InternationalKleinBlue", "InternationalOrange_Aerospace", "InternationalOrange_Engineering", "InternationalOrange_GoldenGateBridge", "Iris", "Irresistible", "Isabelline", "IslamicGreen"
   Data.s "ItalianSkyBlue", "Ivory", "Jade", "JapaneseCarmine", "JapaneseIndigo", "JapaneseViolet", "Jasmine", "Jasper"
   Data.s "JazzberryJam", "JellyBean", "Jet", "Jonquil", "JordyBlue", "JuneBud", "JungleGreen", "KellyGreen"
   Data.s "KenyanCopper", "Keppel", "Jawad_ChickenColor_HTML_CSS_Khaki", "Khaki_X11_LightKhaki", "Kobe", "Kobi", "KombuGreen", "KUCrimson"
   Data.s "LaSalleGreen", "LanguidLavender", "LapisLazuli", "LaserLemon", "LaurelGreen", "Lava", "Lavender_Floral", "Lavender_Web"
   Data.s "LavenderBlue", "LavenderBlush", "LavenderGray", "LavenderIndigo", "LavenderMagenta", "LavenderMist", "LavenderPink", "LavenderPurple"
   Data.s "LavenderRose", "LawnGreen", "Lemon", "LemonChiffon", "LemonCurry", "LemonGlacier", "LemonLime", "LemonMeringue"
   Data.s "LemonYellow", "Lenurple", "Licorice", "Liberty", "LightApricot", "LightBlue", "LightBrilliantRed", "LightBrown"
   Data.s "LightCarminePink", "LightCobaltBlue", "LightCoral", "LightCornflowerBlue", "LightCrimson", "LightCyan", "LightDeepPink", "LightFrenchBeige"
   Data.s "LightFuchsiaPink", "LightGoldenrodYellow", "LightGray", "LightGrayishMagenta", "LightGreen", "LightHotPink", "LightKhaki", "LightMediumOrchid"
   Data.s "LightMossGreen", "LightOrchid", "LightPastelPurple", "LightPink", "LightRedOchre", "LightSalmon", "LightSalmonPink", "LightSeaGreen"
   Data.s "LightSkyBlue", "LightSlateGray", "LightSteelBlue", "LightTaupe", "LightThulianPink", "LightYellow", "Lilac", "Lime_ColorWheel"
   Data.s "Lime_Web_X11Green", "LimeGreen", "Limerick", "LincolnGreen", "Linen", "Lion", "LiseranPurple", "LittleBoyBlue"
   Data.s "Liver", "Liver_Dogs", "Liver_Organ", "LiverChestnut", "Livid", "Lumber", "Lust", "Magenta"
   Data.s "Magenta_Crayola", "Magenta_Dye", "Magenta_Pantone", "Magenta_Process", "MagentaHaze", "MagentaPink", "MagicMint", "Magnolia"
   Data.s "Mahogany", "Maize", "MajorelleBlue", "Malachite", "Manatee", "MangoTango", "Mantis", "MardiGras"
   Data.s "Maroon_Crayola", "Maroon_HTML_CSS", "Maroon_X11", "Mauve", "MauveTaupe", "Mauvelous", "MayGreen", "MayaBlue"
   Data.s "MeatBrown", "MediumAquamarine", "MediumBlue", "MediumCandyAppleRed", "MediumCarmine", "MediumChampagne", "MediumElectricBlue", "MediumJungleGreen"
   Data.s "MediumLavenderMagenta", "MediumOrchid", "MediumPersianBlue", "MediumPurple", "MediumRedViolet", "MediumRuby", "MediumSeaGreen", "MediumSkyBlue"
   Data.s "MediumSlateBlue", "MediumSpringBud", "MediumSpringGreen", "MediumTaupe", "MediumTurquoise", "MediumTuscanRed", "MediumVermilion", "MediumVioletRed"
   Data.s "MellowApricot", "MellowYellow", "Melon", "MetallicSeaweed", "MetallicSunburst", "MexicanPink", "MidnightBlue", "MidnightGreen_EagleGreen"
   Data.s "MikadoYellow", "Mindaro", "Ming", "Mint", "MintCream", "MintGreen", "MistyRose", "Moccasin"
   Data.s "ModeBeige", "MoonstoneBlue", "MordantRed19", "MossGreen", "MountainMeadow", "MountbattenPink", "MSUGreen", "MughalGreen"
   Data.s "Mulberry", "Mustard", "MyrtleGreen", "NadeshikoPink", "NapierGreen", "NaplesYellow", "NavajoWhite", "Navy"
   Data.s "NavyPurple", "NeonCarrot", "NeonFuchsia", "NeonGreen", "NewCar", "NewYorkPink", "NonPhotoBlue", "NorthTexasGreen"
   Data.s "Nyanza", "OceanBoatBlue", "Ochre", "OfficeGreen", "OldBurgundy", "OldGold", "OldHeliotrope", "OldLace"
   Data.s "OldLavender", "OldMauve", "OldMossGreen", "OldRose", "OldSilver", "Olive", "OliveDrab_No3", "OliveDrabNo7"
   Data.s "Olivine", "Onyx", "OperaMauve", "Orange_ColorWheel", "Orange_Crayola", "Orange_Pantone", "Orange_RYB", "Orange_Web"
   Data.s "OrangePeel", "OrangeRed", "Orchid", "OrchidPink", "OriolesOrange", "OtterBrown", "OuterSpace", "OutrageousOrange"
   Data.s "OxfordBlue", "OUCrimsonRed", "PakistanGreen", "PalatinateBlue", "PalatinatePurple", "PaleAqua", "PaleBlue", "PaleBrown"
   Data.s "PaleCarmine", "PaleCerulean", "PaleChestnut", "PaleCopper", "PaleCornflowerBlue", "PaleCyan", "PaleGold", "PaleGoldenrod"
   Data.s "PaleGreen", "PaleLavender", "PaleMagenta", "PaleMagentaPink", "PalePink", "PalePlum", "PaleRedViolet", "PaleRobinEggBlue"
   Data.s "PaleSilver", "PaleSpringBud", "PaleTaupe", "PaleTurquoise", "PaleViolet", "PaleVioletRed", "PansyPurple", "PaoloVeroneseGreen"
   Data.s "PapayaWhip", "ParadisePink", "ParisGreen", "PastelBlue", "PastelBrown", "PastelGray", "PastelGreen", "PastelMagenta"
   Data.s "PastelOrange", "PastelPink", "PastelPurple", "PastelRed", "PastelViolet", "PastelYellow", "Patriarch", "PaynesGrey"
   Data.s "Peach", "Peach_", "PeachOrange", "PeachPuff", "PeachYellow", "Pear", "Pearl", "PearlAqua"
   Data.s "PearlyPurple", "Peridot", "Periwinkle", "PersianBlue", "PersianGreen", "PersianIndigo", "PersianOrange", "PersianPink"
   Data.s "PersianPlum", "PersianRed", "PersianRose", "Persimmon", "Peru", "Phlox", "PhthaloBlue", "PhthaloGreen"
   Data.s "PictonBlue", "PictorialCarmine", "PiggyPink", "PineGreen", "Pineapple", "Pink", "Pink_Pantone", "PinkLace"
   Data.s "PinkLavender", "PinkOrange", "PinkPearl", "PinkRaspberry", "PinkSherbet", "Pistachio", "Platinum", "Plum"
   Data.s "Plum_Web", "PompAndPower", "Popstar", "PortlandOrange", "PowderBlue", "PrincetonOrange", "Prune", "PrussianBlue"
   Data.s "PsychedelicPurple", "Puce", "PuceRed", "PullmanBrown_UPSBrown", "PullmanGreen", "Pumpkin", "Purple_HTML", "Purple_Munsell"
   Data.s "Purple_X11", "PurpleHeart", "PurpleMountainMajesty", "PurpleNavy", "PurplePizzazz", "PurpleTaupe", "Purpureus", "Quartz"
   Data.s "QueenBlue", "QueenPink", "QuinacridoneMagenta", "Rackley", "RadicalRed", "Rajah", "Raspberry", "RaspberryGlace"
   Data.s "RaspberryPink", "RaspberryRose", "RawUmber", "RazzleDazzleRose", "Razzmatazz", "RazzmicBerry", "RebeccaPurple", "Red_Crayola"
   Data.s "Red_Munsell", "Red_NCS", "Red_Pantone", "Red_Pigment", "Red_RYB", "RedBrown", "RedDevil", "RedOrange"
   Data.s "RedPurple", "RedViolet", "Redwood", "Regalia", "RegistrationBlack", "ResolutionBlue", "Rhythm", "RichBlack_Typical"
   Data.s "RichBlack_FOGRA29", "RichBlack_FOGRA39", "RichBrilliantLavender", "RichCarmine", "RichElectricBlue", "RichLavender", "RichLilac", "RichMaroon"
   Data.s "RifleGreen", "RoastCoffee", "RobinEggBlue", "RocketMetallic", "RomanSilver", "Rose", "RoseBonbon", "RoseEbony"
   Data.s "RoseGold", "RoseMadder", "RosePink", "RoseQuartz", "RoseRed", "RoseTaupe", "RoseVale", "Rosewood"
   Data.s "RossoCorsa", "RosyBrown", "RoyalAzure", "RoyalBlue", "RoyalBlue_", "RoyalFuchsia", "RoyalPurple", "RoyalYellow"
   Data.s "Ruber", "RubineRed", "Ruby", "RubyRed", "Ruddy", "RuddyBrown", "RuddyPink", "Rufous"
   Data.s "Russet", "RussianGreen", "RussianViolet", "Rust", "RustyRed", "SacramentoStateGreen", "SaddleBrown", "SafetyOrange"
   Data.s "SafetyOrange_BlazeOrange", "SafetyYellow", "Saffron", "Sage", "StPatricksBlue", "Salmon", "SalmonPink", "Sand"
   Data.s "SandDune", "Sandstorm", "SandyBrown", "SandyTaupe", "Sangria", "SapGreen", "Sapphire", "SapphireBlue"
   Data.s "SatinSheenGold", "Scarlet", "Scarlet_", "SchaussPink", "SchoolBusYellow", "ScreaminGreen", "SeaBlue", "SeaGreen"
   Data.s "SealBrown", "Seashell", "SelectiveYellow", "Sepia", "Shadow", "ShadowBlue", "Shampoo", "ShamrockGreen"
   Data.s "SheenGreen", "ShimmeringBlush", "ShockingPink", "ShockingPink_Crayola", "Sienna", "Silver", "SilverChalice", "SilverLakeBlue"
   Data.s "SilverPink", "SilverSand", "Sinopia", "Skobeloff", "SkyBlue", "SkyMagenta", "SlateBlue", "SlateGray"
   Data.s "Smalt_DarkPowderBlue", "Smitten", "Smoke", "SmokyBlack", "SmokyTopaz", "Snow", "Soap", "SolidPink"
   Data.s "SonicSilver", "SpartanCrimson", "SpaceCadet", "SpanishBistre", "SpanishBlue", "SpanishCarmine", "SpanishCrimson", "SpanishGray"
   Data.s "SpanishGreen", "SpanishOrange", "SpanishPink", "SpanishRed", "SpanishSkyBlue", "SpanishViolet", "SpanishViridian", "SpicyMix"
   Data.s "SpiroDiscoBall", "SpringBud", "SpringGreen", "StarCommandBlue", "SteelBlue", "SteelPink", "StilDeGrainYellow", "Stizza"
   Data.s "Stormcloud", "Straw", "Strawberry", "Sunglow", "Sunray", "Sunset", "SunsetOrange", "SuperPink"
   Data.s "Tan", "Tangelo", "Tangerine", "TangerineYellow", "TangoPink", "Taupe", "TaupeGray", "TeaGreen"
   Data.s "TeaRose", "TeaRose_", "Teal", "TealBlue", "TealDeer", "TealGreen", "Telemagenta", "Tenné"
   Data.s "TerraCotta", "Thistle", "ThulianPink", "TickleMePink", "TiffanyBlue", "TigersEye", "Timberwolf", "TitaniumYellow"
   Data.s "Tomato", "Toolbox", "Topaz", "TractorRed", "TrolleyGrey", "TropicalRainForest", "TrueBlue", "TuftsBlue"
   Data.s "Tulip", "Tumbleweed", "TurkishRose", "Turquoise", "TurquoiseBlue", "TurquoiseGreen", "Tuscan", "TuscanBrown"
   Data.s "TuscanRed", "TuscanTan", "Tuscany", "TwilightLavender", "TyrianPurple", "UABlue", "UARed", "Ube"
   Data.s "UCLABlue", "UCLAGold", "UFOGreen", "Ultramarine", "UltramarineBlue", "UltraPink", "UltraRed", "Umber"
   Data.s "UnbleachedSilk", "UnitedNationsBlue", "UniversityOfCaliforniaGold", "UnmellowYellow", "UPForestGreen", "UPMaroon", "UpsdellRed", "Urobilin"
   Data.s "USAFABlue", "USCCardinal", "USCGold", "UniversityOfTennesseeOrange", "UtahCrimson", "Vanilla", "VanillaIce", "VegasGold"
   Data.s "VenetianRed", "Verdigris", "Vermilion", "Vermilion_", "Veronica", "VeryLightAzure", "VeryLightBlue", "VeryLightMalachiteGreen"
   Data.s "VeryLightTangelo", "VeryPaleOrange", "VeryPaleYellow", "Violet", "Violet_ColorWheel", "Violet_RYB", "Violet_Web", "VioletBlue"
   Data.s "VioletRed", "Viridian", "ViridianGreen", "VistaBlue", "VividAmber", "VividAuburn", "VividBurgundy", "VividCerise"
   Data.s "VividCerulean", "VividCrimson", "VividGamboge", "VividLimeGreen", "VividMalachite", "VividMulberry", "VividOrange", "VividOrangePeel"
   Data.s "VividOrchid", "VividRaspberry", "VividRed", "VividRedTangelo", "VividSkyBlue", "VividTangelo", "VividTangerine", "VividVermilion"
   Data.s "VividViolet", "VividYellow", "WarmBlack", "Waterspout", "Wenge", "Wheat", "White", "WhiteSmoke"
   Data.s "WildBlueYonder", "WildOrchid", "WildStrawberry", "WildWatermelon", "WillpowerOrange", "WindsorTan", "Wine", "WineDregs"
   Data.s "Wisteria", "WoodBrown", "Xanadu", "YaleBlue", "YankeesBlue", "Yellow_Crayola", "Yellow_Munsell", "Yellow_NCS"
   Data.s "Yellow_Pantone", "Yellow_Process", "Yellow_RYB", "YellowGreen", "YellowOrange", "YellowRose", "Zaffre", "ZinnwalditeBrown"
   Data.s "Zomp"
   Data.s ""
   WikiColorList_Colors:
   Data.l $1ABFB0, $E8B97C, $E5FFC9, $BE84B2, $A88A5D, $8F3000, $C1A072, $2A00AF, $FFF8F0, $3626E3, $1062C4, $CDDEEF, $502BE5, $4F27AB, $BB9CF1, $4F27AB
   Data.l $2D21D3, $577A3B, $00BFFF, $007EFF, $3E03FF, $CC6699, $39C6A4, $F4F3F2, $7595CD, $1E5D66, $835C91, $2D1B84, $D7EBFA, $008000, $00B68D, $B1CEFB
   Data.l $FFFF00, $D4FF7F, $20534B, $4B443B, $79978F, $6BD6E9, $B5BEB2, $6BA987, $6699FF, $2A2AA5, $00EEFD, $807F6E, $038256, $FF7F00, $FFFFF0, $FFFFF0
   Data.l $F4E9DB, $F0CF89, $F1CAA1, $C2C2F4, $FAFEFE, $AF91FF, $CDAB21, $B5E7FA, $35E1FF, $4E6A00, $8A21E0, $020A7C, $828484, $7B7798, $E6D4BC, $70819F
   Data.l $DCF5F5, $94582E, $42259C, $C4E4FF, $1F2B3D, $177196, $0DE0CA, $00FFBF, $5E6FFE, $514FBF, $000000, $020C3D, $293525, $363C3B, $CDEBFF, $6471A5
   Data.l $E78C31, $EEE5AC, $BEF0FA, $FE751F, $AF9300, $BD8700, $A81800, $993333, $FE4702, $D0A2A2, $CC9966, $BA980D, $A1935E, $923555, $806112, $E22B8A
   Data.l $A77250, $F7864F, $F01C1C, $835DDE, $3B4479, $B69500, $C9DAE3, $0000CC, $4E6A00, $603287, $FF7000, $42A6B5, $5441CB, $D6AC1D, $00FF66, $E494BF
   Data.l $EF91D8, $4821C3, $D27419, $7F00FF, $DEE808, $E89FD1, $FF9933, $FFBBF4, $A355FF, $7F60FB, $254200, $327FCD, $007073, $004B96, $2A2AA5, $23446B
   Data.l $6699CC, $3E4D1B, $CCC1FF, $FFFEE7, $82DCF0, $61B67B, $070648, $200080, $87B8DE, $0055CC, $5174E9, $24338A, $A433BD, $632970, $726853, $A09E5F
   Data.l $B0A391, $3C6B00, $2D87ED, $2200E3, $00F6FF, $5B7BA6, $21364B, $2B4D1E, $ADC1A3, $6B9AC1, $CCBBEF, $6B8678, $00EFFF, $0008FF, $7A71E4, $FFBF00
   Data.l $202759, $3A1EC4, $99CC00, $180096, $4000D7, $424CEB, $3800FF, $C9A6FF, $1B1BB3, $D3A056, $2191ED, $3F5600, $782A06, $423670, $495AC9, $CFA192
   Data.l $AFE1AC, $A77B00, $7C842F, $FFFFB2, $D09749, $6331DE, $833BEC, $A77B00, $BE522A, $C39B6D, $A57A00, $313CE0, $5A78A0, $CEE7F7, $4F4536, $2B2B23
   Data.l $AC8FE6, $00FFDF, $00FF7F, $6331DE, $C5B7FF, $354595, $A16FDE, $6E51A8, $1E38AA, $886085, $003F7B, $1E69D2, $00A7FF, $7B8198, $3442E3, $1E69D2
   Data.l $0AD0E4, $1FA99F, $34177F, $E7CCFB, $AB4700, $1E69D2, $3E5A96, $374E6F, $E2D8C4, $7983F8, $000000, $AC928C, $3373B8, $678ADA, $696FAD, $516DCB
   Data.l $666699, $0038FF, $507FFF, $7983F8, $4040FF, $453F89, $5DECFB, $1B1BB3, $ED9564, $DCF8FF, $E7F8FF, $3E6181, $D9BCFF, $D0FDFF, $3C14DC, $3200BE
   Data.l $000099, $B4824E, $BF8246, $9C5828, $C28B18, $EBB700, $7C4258, $00D3FF, $31FFFF, $30E1F0, $8B0000, $996666, $214365, $4E6588, $54395D, $0000A4
   Data.l $7E4508, $606998, $455BCD, $8B8B00, $786853, $0B86B8, $A9A9A9, $203201, $006400, $6A4100, $F96E6E, $21241A, $6BB7BD, $323C48, $964F73, $4F4B53
   Data.l $373D54, $8B008B, $A9A9A9, $663300, $235D4A, $2F6B55, $008CFF, $CC3299, $CB9E77, $3CC003, $D66F96, $223BC2, $8054E7, $993300, $3C3A4F, $341930
   Data.l $572687, $00008B, $7A96E9, $190356, $8FBC8F, $14143C, $D6BE8C, $8B3D48, $4F4F2F, $457217, $518191, $12A8FF, $323C48, $5C4ECC, $D1CE00, $A8BED1
   Data.l $D30094, $0C879B, $3C7000, $555555, $530AD7, $6D8240, $3E20A9, $3830EF, $2C69E9, $8732DA, $A5D6FA, $484EB9, $414270, $C154C1, $086605, $617C0E
   Data.l $494B00, $663333, $1AC7F5, $BB5599, $CC00CC, $000082, $D473D4, $3B5E35, $A4CBFF, $9314FF, $685CA9, $010185, $5B3F84, $3399FF, $FFBF00, $6C644A
   Data.l $2F6B55, $605E7E, $4D4266, $660033, $5987BA, $BD6015, $999966, $6B9AC1, $AFC9ED, $533CEA, $FFF2B9, $696969, $53769B, $FF901E, $6818D7, $65BB85
   Data.l $284C66, $177196, $9C0000, $C9CCE5, $BBDFEF, $5FA9E1, $505D55, $80B2C2, $1B1B1B, $514061, $D6EAF0, $A63410, $FFF97D, $3F00FF, $FFFF00, $00FF00
   Data.l $FF006F, $FFBBF4, $00FFCC, $FF00BF, $FF003F, $FF008F, $33FFFF, $78C850, $82306C, $3E4D1B, $9583B4, $524BAB, $5C3C56, $A2C896, $A8D744, $6B9AC1
   Data.l $181880, $8933B5, $8552DE, $A100F4, $70AAE5, $535D4D, $B1D5FD, $42794F, $0028FF, $1E546C, $2222B2, $2920CE, $2258E2, $AC8EFC, $23446B, $8EE9F7
   Data.l $82DCEE, $6D00A2, $F0FAFF, $00BFFF, $9314FF, $00FFCC, $4F00FF, $214401, $228B22, $5B7BA6, $4D6D85, $BB7200, $923FFD, $8E6086, $38FD9E, $D473D4
   Data.l $9E6CFD, $531481, $09164E, $482CC7, $8A4AF6, $FEB577, $CE0688, $441EAC, $FFE7A6, $FF00FF, $C154C1, $FF77FF, $7B39CC, $7543C7, $0084E4, $6666CC
   Data.l $DCDCDC, $0F9BE4, $006699, $667F00, $FFF8F8, $1D5AFE, $0065B0, $B68260, $FAE8E6, $66AB00, $37AFD4, $00D7FF, $4E7585, $156599, $00C2FC, $00DFFF
   Data.l $20A5DA, $A0E4A8, $A82D6F, $808080, $808080, $BEBEBE, $455946, $AC928C, $00FF00, $78AC1C, $008000, $77A800, $6B9F00, $43AD00, $50A500, $32B066
   Data.l $B46411, $669900, $2FFFAD, $185888, $869AA9, $7FFF00, $543866, $CF6C44, $FA1852, $6BD6E9, $00FF3F, $18CB46, $1600C9, $0091DA, $008080, $FF73DF
   Data.l $A998AA, $BB00AA, $A100F4, $F0FFF0, $B06D00, $6B7949, $CE1DFF, $B469FF, $3B5E35, $D2A671, $5EF7FC, $779131, $6B2F60, $952300, $3C0266, $3929ED
   Data.l $5DECB2, $6D514C, $088813, $5C5CCD, $57A8E3, $FF006F, $921F09, $82004B, $A72F00, $004FFF, $0C16BA, $2C36C0, $CF4F5A, $6C44B3, $ECF0F4, $009000
   Data.l $FFFFB2, $F0FFFF, $6BA800, $33299D, $484326, $56325B, $7EDEF8, $3E3BD7, $5E0BA5, $4E61DA, $343434, $16CAF4, $F1B98A, $57DABD, $87AB29, $17BB4C
   Data.l $051C7C, $9EB03A, $91B0C3, $8CE6F0, $172D88, $C49FE7, $304235, $0D00E8, $307808, $DDCAD6, $9C6126, $66FFFF, $9DBAA9, $2010CF, $DC7EB5, $FAE6E6
   Data.l $FFCCCC, $F5F0FF, $D0C3C4, $EB5794, $EE82EE, $FAE6E6, $D2AEFB, $B67B96, $E3A0FB, $00FC7C, $00F7FF, $CDFAFF, $1DA0CC, $00FFFD, $00FFE3, $BEEAF6
   Data.l $4FF4FF, $D893BA, $10111A, $A75A54, $B1D5FD, $E6D8AD, $2E2EFE, $1D65B5, $7167E6, $E0AC88, $8080F0, $EACC93, $9169F5, $FFFFE0, $CD5CFF, $7FADC8
   Data.l $EF84F9, $D2FAFA, $D3D3D3, $CC99CC, $90EE90, $DEB3FF, $8CE6F0, $CB9BD3, $ADDFAD, $D7A8E6, $D99CB1, $C1B6FF, $5174E9, $7AA0FF, $9999FF, $AAB220
   Data.l $FACE87, $998877, $DEC4B0, $6D8BB3, $AC8FE6, $E0FFFF, $C8A2C8, $00FFBF, $00FF00, $32CD32, $09C29D, $055919, $E6F0FA, $6B9AC1, $A16FDE, $DCA06C
   Data.l $474C67, $296DB8, $1F2E6C, $567498, $CC9966, $CDE4FF, $2020E6, $FF00FF, $A355FF, $7B1FCA, $7E41D0, $9000FF, $76459F, $8B33CC, $D1F0AA, $FFF4F8
   Data.l $0040C0, $5DECFB, $DC5060, $51DA0B, $AA9A97, $4382FF, $65C374, $850088, $4821C3, $000080, $6030B0, $FFB0E0, $6D5F91, $AA98EF, $41914C, $FBC273
   Data.l $3BB7E5, $AADD66, $CD0000, $2C06E2, $3540AF, $ABE5F3, $965003, $2D351C, $DDA0DD, $D355BA, $A56700, $DB7093, $8533BB, $6940AA, $71B33C, $EBDA80
   Data.l $EE687B, $87DCC9, $9AFA00, $474C67, $CCD148, $3B4479, $3B60D9, $8515C7, $78B8F8, $7EDEF8, $B4BCFD, $8C7E0A, $387C9C, $7C00E4, $701919, $534900
   Data.l $0CC4FF, $88F9E3, $7D7436, $89B43E, $FAFFF5, $98FF98, $E1E4FF, $D7EBFA, $177196, $C2A973, $000CAE, $5B9A8A, $8FBA30, $8D7A99, $3B4518, $306030
   Data.l $8C4BC5, $58DBFF, $737831, $C6ADF6, $00802A, $5EDAFA, $ADDEFF, $800000, $EB5794, $43A3FF, $6441FE, $14FF39, $C64F21, $7F83D7, $EDDDA4, $339005
   Data.l $DBFFE9, $BE7700, $2277CC, $008000, $2E3043, $3BB5CF, $5C3C56, $E6F5FD, $786879, $473167, $367E86, $8180C0, $828484, $008080, $238E6B, $1F343C
   Data.l $73B99A, $393835, $A784B7, $007FFF, $3875FF, $0058FF, $0299FB, $00A5FF, $009FFF, $0045FF, $D670DA, $CDBDF2, $144FFB, $214365, $4C4A41, $4A6EFF
   Data.l $472100, $000099, $006600, $E23B27, $602868, $E6D4BC, $EEEEAF, $547698, $3540AF, $E2C49B, $AFADDD, $678ADA, $EFCDAB, $F8D387, $8ABEE6, $AAE8EE
   Data.l $98FB98, $FFD0DC, $E584F9, $CC99FF, $DDDAFA, $DDA0DD, $9370DB, $D1DE96, $BBC0C9, $BDEBEC, $7E98BC, $EEEEAF, $FF99CC, $9370DB, $4A1878, $7D9B00
   Data.l $D5EFFF, $623EE6, $78C850, $CFC6AE, $536983, $C4CFCF, $77DD77, $C29AF4, $47B3FF, $A4A5DE, $B59EB3, $6169FF, $C999CB, $96FDFD, $800080, $786853
   Data.l $B4E5FF, $A4CBFF, $99CCFF, $B9DAFF, $ADDFFA, $31E2D1, $C8E0EA, $C0D888, $A268B7, $00E2E6, $FFCCCC, $BB391C, $93A600, $7A1232, $5890D9, $BE7FF7
   Data.l $1C1C70, $3333CC, $A228FE, $0058EC, $3F85CD, $FF00DF, $890F00, $243512, $E8B145, $4E0BC3, $E6DDFD, $6F7901, $5C3C56, $CBC0FF, $9448D7, $F4DDFF
   Data.l $D1B2D8, $6699FF, $CFACE7, $360098, $A78FF7, $72C593, $E2E4E5, $85458E, $DDA0DD, $8E6086, $624FBE, $365AFF, $E6E0B0, $2580F5, $1C1C70, $533100
   Data.l $FF00DF, $9988CC, $372F72, $174164, $1C333B, $1875FF, $800080, $C5009F, $F020A0, $9C3569, $B67896, $80514E, $DA4EFE, $4D4050, $AE4E9A, $4F4851
   Data.l $956B43, $D7CCE8, $593A8E, $A88A5D, $5E35FF, $60ABFB, $5D0BE3, $6D5F91, $9850E2, $6C44B3, $446682, $CC33FF, $6B25E3, $854E8D, $993366, $4D20EE
   Data.l $3C00F2, $3302C4, $3929ED, $241CED, $1227FE, $2A2AA5, $110186, $4953FF, $7800E4, $8515C7, $525AA4, $802D52, $000000, $872300, $967677, $000000
   Data.l $130B01, $030201, $FEA7F1, $4000D7, $D09208, $CF6BA7, $D266B6, $6030B0, $384C44, $414270, $CCCC00, $807F8A, $968983, $7F00FF, $9E42F9, $464867
   Data.l $796EB7, $3626E3, $CC66FF, $A998AA, $561EC2, $5D5D90, $524EAB, $0B0065, $0000D4, $8F8FBC, $A83800, $662300, $E16941, $922CCA, $A95178, $5EDAFA
   Data.l $7646CE, $5600D1, $5F11E0, $1E119B, $2800FF, $2865BB, $968EE1, $071CA8, $1B4680, $679267, $4D1732, $0E41B7, $432CDA, $3F5600, $13458B, $0078FF
   Data.l $0067FF, $02D2EE, $30C4F4, $8AB8BC, $7A2923, $7280FA, $A491FF, $80B2C2, $177196, $40D5EC, $60A4F4, $177196, $0A0092, $2A7D50, $BA520F, $A56700
   Data.l $35A1CB, $0024FF, $350EFD, $AF91FF, $00D8FF, $7AFF76, $946900, $578B2E, $141432, $EEF5FF, $00BAFF, $144270, $5D798A, $A58B77, $F1CFFF, $609E00
   Data.l $00D48F, $9586D9, $C00FFC, $FF6FFF, $172D88, $C0C0C0, $ACACAC, $BA895D, $ADAEC4, $C2C1BF, $0B41CB, $747400, $EBCE87, $AF71CF, $CD5A6A, $908070
   Data.l $993300, $8641C8, $768273, $080C10, $413D93, $FAFAFF, $EFC8CE, $433889, $757575, $16139E, $51291D, $327580, $B87000, $4700D1, $4C1AE5, $989898
   Data.l $509100, $0061E8, $BEBFF7, $2600E6, $FFFF00, $82284C, $5C7F00, $4D5F8B, $FCC00F, $00FCA7, $7FFF00, $B87B00, $B48246, $CC33CC, $5EDAFA, $000099
   Data.l $6A664F, $6FD9E4, $8D5AFC, $33CCFF, $57ABE3, $A5D6FA, $535EFD, $A96BCF, $8CB4D2, $004DF9, $0085F2, $00CCFF, $7A71E4, $323C48, $89858B, $C0F0D0
   Data.l $7983F8, $C2C2F4, $808000, $887536, $B3E699, $7F8200, $7634CF, $0057CD, $5B72E2, $D8BFD8, $A16FDE, $AC89FC, $B5BA0A, $3C8DE0, $D2D7DB, $00E6EE
   Data.l $4763FF, $C06C74, $7CC8FF, $350EFD, $808080, $5E7500, $CF7300, $C17D41, $8D87FF, $88AADE, $8172B5, $D0E040, $EFFF00, $B4D6A0, $A5D6FA, $374E6F
   Data.l $48487C, $5B7BA6, $9999C0, $6B498A, $3C0266, $AA3300, $4C00D9, $C37888, $956853, $00B3FF, $70D03C, $8F0A12, $F56641, $FF6FFF, $856CFC, $475163
   Data.l $CADDFF, $E5925B, $2787B7, $66FFFF, $214401, $13117B, $2920AE, $21ADE1, $984F00, $000099, $00CCFF, $007FF7, $3F00D3, $ABE5F3, $A98FF3, $58B3C5
   Data.l $1508C8, $AEB343, $3442E3, $1E38D9, $F020A0, $FBBB74, $FF6666, $86E964, $77B0FF, $BFDFFF, $BFFFFF, $FF008F, $FF007F, $AF0186, $EE82EE, $B24A32
   Data.l $9453F7, $6D8240, $989600, $D99E7C, $0099CC, $242792, $351D9F, $811DDA, $EEAA00, $3300CC, $0099FF, $08D6A6, $33CC00, $E30CB8, $005FFF, $00A0FF
   Data.l $FF00CC, $6C00FF, $1A0DF7, $2461DF, $FFCC00, $2774F0, $89A0FF, $2460E5, $FF009F, $02E3FF, $000000, $F9F4A4, $525464, $B3DEF5, $FFFFFF, $F5F5F5
   Data.l $D0ADA2, $A270D4, $A443FF, $856CFC, $0058FD, $0255A7, $372F72, $473167, $DCA0C9, $6B9AC1, $788673, $924D0F, $41281C, $83E8FC, $00CCEF, $00D3FF
   Data.l $00DFFE, $00EFFF, $33FEFE, $32CD9A, $42AEFF, $00F0FF, $A81400, $08162C, $8EA739
EndDataSection

Global NewList WikiColorList._WIKICOLORLIST_()

Procedure SetColor()
     SetGadgetColor(101, #PB_Gadget_BackColor, WikiColorList()\Color) ; set the container's color
     ; gather the color information for the trackbar values
     rd = Red(WikiColorList()\Color)
     gr = Green(WikiColorList()\Color)
     bl = Blue(WikiColorList()\Color)
  SetTracks(rd,gr,bl) ; set the values to the three trackbar pointers
EndProcedure

OpenWindow(0, 0, 0, 320,300, "Designer Colors",  #PB_Window_MinimizeGadget|#PB_Window_SystemMenu|#PB_Window_ScreenCentered)

 StickyWindow(0, #True) ; prefered

 TrackBarGadget( 1, 55, 10,256, 25, 0, 255)
 TrackBarGadget( 2, 55, 45,256, 25, 0, 255)
 TrackBarGadget( 3, 55, 80,256, 25, 0, 255)
 TextGadget    ( 4,  2, 13, 30, 15, "Red")
 TextGadget    ( 5,  2, 48, 30, 15, "Green")
 TextGadget    ( 6,  2, 83, 30, 15, "Blue")
 TextGadget    (11, 32, 13, 20, 15, "000")
 TextGadget    (12, 32, 48, 20, 15, "000")
 TextGadget    (13, 32, 83, 20, 15, "000")
 SetGadgetColor(11, #PB_Gadget_FrontColor, RGB(200,0,0))
 SetGadgetColor(12, #PB_Gadget_FrontColor, RGB(0,128,0))
 SetGadgetColor(13, #PB_Gadget_FrontColor, RGB(0,0,200))
 TextGadget    (14,  2,118, 50, 20, "$000000")
 TextGadget    (15, 55,118, 50, 20, "0",#PB_Text_Right)
 ButtonGadget  (19,  5, 140, 75, 20, "ClipBoard")

 For n=1 To 5
   TextGadget  (20+n,110+((n-1)*40),115, 40, 20, "TEST",#PB_Text_Border|#PB_Text_Center)
 Next
 For n=1 To 9
   StringGadget(30+n,110+((n-1)*20),142, 15, 15, " "+Str(n),#PB_String_ReadOnly)
   color.s = StringField(my_COLORS,n,"|")
   SetGadgetColor(30+n, #PB_Gadget_BackColor, RGB(divide_cols(color)))
 Next
 SetGadgetColor(36, #PB_Gadget_FrontColor, #White)
 
  ; Start gadget numbers with 100 (to prevent a conflict with Graves coding)
   TextGadget(100, 5, 170, 315, 188, "Or choose a color here...")
   ContainerGadget(101, 5, 185, 310, 110, #PB_Container_Flat) ;the WikiColor background screen
   ComboBoxGadget(102, 20, 40, 265, 30) ;the WikiColor Combobox
 
     InitWikiColorList(WikiColorList())
      i = 0
      ForEach WikiColorList()
         AddGadgetItem (102, -1, WikiColorList()\Name$)
         SetGadgetItemData(102, i, @WikiColorList())
         i + 1
      Next
     
      FirstElement(WikiColorList())
      SetGadgetState(102, 0) ; zero being the first item shown
      SetColor()
     
; Events
      Repeat
           Select WaitWindowEvent()
                Case #PB_Event_CloseWindow: Break
                     
                Case #PB_Event_Gadget
                     nGad = EventGadget()
                     If nGad = 19
                          If Len(hcolor): SetClipboardText(hcolor): EndIf
                     ElseIf nGad > 30 And nGad < 40
                          If EventType() = #PB_EventType_Focus
                               ncol  = nGad - 30
                               color = StringField(my_COLORS,ncol,"|")
                               rd    = Val(StringField(color,1,","))
                               gr    = Val(StringField(color,2,","))
                               bl    = Val(StringField(color,3,","))
                               SetTracks(rd,gr,bl)
                          EndIf
                     ElseIf nGad = 102 ;the WikiColor Combobox
                          i = GetGadgetState(102)
                          If i > -1
                               ChangeCurrentElement(WikiColorList(), GetGadgetItemData(102, i))
                               SetColor()
                          EndIf
                     Else
                          rd = GetGadgetState(1)
                          gr = GetGadgetState(2)
                          bl = GetGadgetState(3)
                          SetTracks(rd,gr,bl)
                     EndIf
           EndSelect
      ForEver

End

; IDE Options = PureBasic 5.71 LTS (MacOS X - x64)
; Folding = ---
; EnableXP