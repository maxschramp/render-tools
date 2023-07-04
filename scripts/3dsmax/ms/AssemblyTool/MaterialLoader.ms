(if ATIcons == undefined then (fileIn ((getFilenamePath(getThisScriptFilename())) + "AssemblyToolIcons.ms")))
(if ATfn_ == undefined then (fileIn ((getFilenamePath(getThisScriptFilename())) + "AssemblyToolStruct.ms")))
	-----------------
(
Global rollout_MaterialLoader
try(if rollout_MaterialLoader.dialogBar then (cui.UnRegisterDialogBar rollout_MaterialLoader); destroyDialog rollout_MaterialLoader)catch()
Global _gEP2_rolloutTexSearchHistory
Global _gEP2_createMatHistoryArr = #()
	-------------------------------------------------------------------------------------------------------------------
local iniPath = (getFilenamePath (getThisScriptFilename())) + "INI\\"
local iniFile = iniPath + "MaterialLoader_Settings.ini"
local roll0W = 1065; local roll0H = 545; local roll0minH = 68
	--------
local Xch = 25
local Xedt = 22
local BS1 = 100
local chK1 = 20; local chK2 = 40; local chK3 = 60
local yp1 = 26; local yp2 = 50; local yp3 = 109; local yp4 = 68
local xp3 = #(10, 96, 112, 196, 215, 540, 580, 655, 677, 724,
			772, 836, 859, 912, 962, 1000, 1042, 560)
local xb1 = 20
local w = #(18, 80, 324, 78, 22, 46, 62, 22, 52, 48, 36, 40)
local BS2 = 20
	-------------------------------------------------------------------------------------------------------------------
local colZ = [160,160,160]
local colY = [238,220,13]
local colG = [12,218,61]
local colR = [236,77,57]
local colSearch = ATfn_.GetINI 0 iniFile "Settings" "SearchColor" [255,156,0]
local colObject = ATfn_.GetINI 0 iniFile "Settings" "ObjectColor" [255,156,0]
local colLayer = ATfn_.GetINI 0 iniFile "Settings" "LayerColor" [255,156,0]
local colMaterial = ATfn_.GetINI 0 iniFile "Settings" "MaterialColor" [255,156,0]
local colCHBX = ATfn_.GetINI 0 iniFile "Settings" "CheckboxColor" [255,156,0]
	-------------------------------------------------------------------------------------------------------------------
local OMS = (ATfn_.GetINI 0 iniFile "Filds" "NamesFromObjects" false)
	-------------------------------------------------------------------------------------------------------------------
local loaderItems = #("None", "Bitmap", "VRayColor", "VRayHDRI")
local HDRIColSpTypes = #("None", "Inverse gamma", "sRGB", "From 3ds max")
	-------------------------------------------------------------------------------------------------------------------
local ddlOf
local edtOf
local ddl_koef
local ddlLim
local ddlWidth_1
if (ATfn_.GetINI 0 iniFile "Settings" "WindowsFixUI" true)
then (ddlOf = 0; edtOf = 0; ddl_koef = 7.6; ddlLim = 30.; ddlWidth_1 = 150)
else (ddlOf = -1; edtOf = 1; ddl_koef = 5.2; ddlLim = 30.; ddlWidth_1 = 100)
	-------------------------------------------------------------------------------------------------------------------
local rolloutPrevTimer
local previewPath
Local previewTime
local openedBitMap
	-------------------------------------------------------------------------------------------------------------------
local instGHeadsArr = #()
local matGHeadsArr = #()
local wireGHeadsArr = #()
	-------------------------------------------------------------------------------------------------------------------
local OCIOConfigPath = ATfn_.GetINI 1 iniFile "Settings" "OCIOConfigPath" ""
local OCIOInOutType = (ATfn_.GetINI 0 iniFile "Settings" "OCIOInputOutput" 1) - 1
local OCIOGenMode = (ATfn_.GetINI 0 iniFile "Settings" "OCIOMode" 1) - 1
local OCIOColorSpaceIn = (ATfn_.GetINI 1 iniFile "Settings" "OCIOColorSpaceIn" "")
local OCIOColorSpaceOut = (ATfn_.GetINI 1 iniFile "Settings" "OCIOColorSpaceOut" "")
local ColorSpacesList = #()
	-------------------------------------------------------------------------------------------------------------------
local tt_chbtn_SearchFild = "Lmb - Use fild for Search"
local tt_chbtn_ObjectFild = "Lmb - Use fild for Object name\nRmb - Get Object name in fild"
local tt_chbtn_LayerFild = "Lmb - Use fild for Layer name\nRmb - Get Layer name in fild"
local tt_chbtn_MaterialFild = "Lmb - Use fild for Material name\nRmb - Get Material name in fild\n     (if Material Editor open then \n     get Material from active slot) "
local tt_ddl_Fild = "Lmb - Choose name\nAlt+Lmb - Delete name\nRmb - Clear fild\nAlt+Rmb - Save name"
local tt_chbtn_Search = "Lmb - Start Search\nRmb - Reset search"
local tt_ddl_Texture = "Rmb - Open texture file in VFB\nAlt+Rmb - Rename Convert Resize \nCtrl+Rmb - Open texture file in ..."
local tt_btn_Browse = "Browse for texture map:\nLmb - from last used directory\nRmb - from selected texture directory"
local tt_ddl_Loader = "Map Loader"
local tt_color_CoColor = "Color for VRayColor and Color Correction"
local tt_spnr_TilingU = "U Tiling"
local tt_spnr_TilingV = "V Tiling"
local tt_ddl_HDRIColSp = "Type of VRayHDRI loader Color space"
local tt_chbtn_ColCor = "Color Correction"
local tt_spnr_CCGammaContrast = "Gamma Contrast value for Color Correction"
local tt_spnr_CCRGB = "RGB value for Color Correction"
local tt_btn_MapType = "Texture map Extension\nLmb - Rename Convert Resize "
local tt_btn_MapSize = "Texture map Width Size\nLmb - Rename Convert Resize "
local tt_chbtn_Compos = "Composite"
local tt_chbtn_OCIO = "OCIO"
-- local tt_btn_ComposMask = "Masks for Composite"
-- local tt_btn_ComposMask = "In Progress"
	----===============================================================================================================
rollout rollout_MaterialLoader "Material Loader"
(
label lbl_1 "1" pos:[(Xedt-10),(yp1-18)]
checkButton chbtn_SearchFild1 "S" pos:[Xch+BS1*0,yp1-20] width:18 height:18 checked:(ATfn_.GetINI 0 iniFile "Filds" "Fild_01_Search" false) highlightColor:colSearch enabled:true tooltip:tt_chbtn_SearchFild
checkButton chbtn_ObjectFild1 "O" pos:[Xch+BS1*0+chK1,yp1-20] width:18 height:18 checked:(ATfn_.GetINI 0 iniFile "Filds" "Fild_01_Object" false) highlightColor:colObject enabled:true tooltip:tt_chbtn_ObjectFild
checkButton chbtn_LayerFild1 "L" pos:[Xch+BS1*0+chK2,yp1-20] width:18 height:18 checked:(ATfn_.GetINI 0 iniFile "Filds" "Fild_01_Layer" false) highlightColor:colLayer enabled:true tooltip:tt_chbtn_LayerFild
checkButton chbtn_MaterialFild1 "M" pos:[Xch+BS1*0+chK3,yp1-20] width:18 height:18 checked:(ATfn_.GetINI 0 iniFile "Filds" "Fild_01_Material" false) highlightColor:colMaterial enabled:true tooltip:tt_chbtn_MaterialFild
label lbl_2 "2" pos:[(Xedt-10)+BS1*1,(yp1-18)]
checkButton chbtn_SearchFild2 "S" pos:[Xch+BS1*1,yp1-20] width:18 height:18 checked:(ATfn_.GetINI 0 iniFile "Filds" "Fild_02_Search" false) highlightColor:colSearch enabled:true tooltip:tt_chbtn_SearchFild
checkButton chbtn_ObjectFild2 "O" pos:[Xch+BS1*1+chK1,yp1-20] width:18 height:18 checked:(ATfn_.GetINI 0 iniFile "Filds" "Fild_02_Object" false) highlightColor:colObject enabled:true tooltip:tt_chbtn_ObjectFild
checkButton chbtn_LayerFild2 "L" pos:[Xch+BS1*1+chK2,yp1-20] width:18 height:18 checked:(ATfn_.GetINI 0 iniFile "Filds" "Fild_02_Layer" false) highlightColor:colLayer enabled:true tooltip:tt_chbtn_LayerFild
checkButton chbtn_MaterialFild2 "M" pos:[Xch+BS1*1+chK3,yp1-20] width:18 height:18 checked:(ATfn_.GetINI 0 iniFile "Filds" "Fild_02_Material" false) highlightColor:colMaterial enabled:true tooltip:tt_chbtn_MaterialFild
label lbl_3 "3" pos:[(Xedt-10)+BS1*2,(yp1-18)]
checkButton chbtn_SearchFild3 "S" pos:[Xch+BS1*2,yp1-20] width:18 height:18 checked:(ATfn_.GetINI 0 iniFile "Filds" "Fild_03_Search" false) highlightColor:colSearch enabled:true tooltip:tt_chbtn_SearchFild
checkButton chbtn_ObjectFild3 "O" pos:[Xch+BS1*2+chK1,yp1-20] width:18 height:18 checked:(ATfn_.GetINI 0 iniFile "Filds" "Fild_03_Object" false) highlightColor:colObject enabled:true tooltip:tt_chbtn_ObjectFild
checkButton chbtn_LayerFild3 "L" pos:[Xch+BS1*2+chK2,yp1-20] width:18 height:18 checked:(ATfn_.GetINI 0 iniFile "Filds" "Fild_03_Layer" false) highlightColor:colLayer enabled:true tooltip:tt_chbtn_LayerFild
checkButton chbtn_MaterialFild3 "M" pos:[Xch+BS1*2+chK3,yp1-20] width:18 height:18 checked:(ATfn_.GetINI 0 iniFile "Filds" "Fild_03_Material" false) highlightColor:colMaterial enabled:true tooltip:tt_chbtn_MaterialFild
label lbl_4 "4" pos:[(Xedt-10)+BS1*3,(yp1-18)]
checkButton chbtn_SearchFild4 "S" pos:[Xch+BS1*3,yp1-20] width:18 height:18 checked:(ATfn_.GetINI 0 iniFile "Filds" "Fild_04_Search" false) highlightColor:colSearch enabled:true tooltip:tt_chbtn_SearchFild
checkButton chbtn_ObjectFild4 "O" pos:[Xch+BS1*3+chK1,yp1-20] width:18 height:18 checked:(ATfn_.GetINI 0 iniFile "Filds" "Fild_04_Object" false) highlightColor:colObject enabled:true tooltip:tt_chbtn_ObjectFild
checkButton chbtn_LayerFild4 "L" pos:[Xch+BS1*3+chK2,yp1-20] width:18 height:18 checked:(ATfn_.GetINI 0 iniFile "Filds" "Fild_04_Layer" false) highlightColor:colLayer enabled:true tooltip:tt_chbtn_LayerFild
checkButton chbtn_MaterialFild4 "M" pos:[Xch+BS1*3+chK3,yp1-20] width:18 height:18 checked:(ATfn_.GetINI 0 iniFile "Filds" "Fild_04_Material" false) highlightColor:colMaterial enabled:true tooltip:tt_chbtn_MaterialFild
label lbl_5 "5" pos:[(Xedt-10)+BS1*4,(yp1-18)]
checkButton chbtn_SearchFild5 "S" pos:[Xch+BS1*4,yp1-20] width:18 height:18 checked:(ATfn_.GetINI 0 iniFile "Filds" "Fild_05_Search" false) highlightColor:colSearch enabled:true tooltip:tt_chbtn_SearchFild
checkButton chbtn_ObjectFild5 "O" pos:[Xch+BS1*4+chK1,yp1-20] width:18 height:18 checked:(ATfn_.GetINI 0 iniFile "Filds" "Fild_05_Object" false) highlightColor:colObject enabled:true tooltip:tt_chbtn_ObjectFild
checkButton chbtn_LayerFild5 "L" pos:[Xch+BS1*4+chK2,yp1-20] width:18 height:18 checked:(ATfn_.GetINI 0 iniFile "Filds" "Fild_05_Layer" false) highlightColor:colLayer enabled:true tooltip:tt_chbtn_LayerFild
checkButton chbtn_MaterialFild5 "M" pos:[Xch+BS1*4+chK3,yp1-20] width:18 height:18 checked:(ATfn_.GetINI 0 iniFile "Filds" "Fild_05_Material" false) highlightColor:colMaterial enabled:true tooltip:tt_chbtn_MaterialFild
label lbl_6 "6" pos:[(Xedt-10)+BS1*5,(yp1-18)]
checkButton chbtn_SearchFild6 "S" pos:[Xch+BS1*5,yp1-20] width:18 height:18 checked:(ATfn_.GetINI 0 iniFile "Filds" "Fild_06_Search" false) highlightColor:colSearch enabled:true tooltip:tt_chbtn_SearchFild
checkButton chbtn_ObjectFild6 "O" pos:[Xch+BS1*5+chK1,yp1-20] width:18 height:18 checked:(ATfn_.GetINI 0 iniFile "Filds" "Fild_06_Object" false) highlightColor:colObject enabled:true tooltip:tt_chbtn_ObjectFild
checkButton chbtn_LayerFild6 "L" pos:[Xch+BS1*5+chK2,yp1-20] width:18 height:18 checked:(ATfn_.GetINI 0 iniFile "Filds" "Fild_06_Layer" false) highlightColor:colLayer enabled:true tooltip:tt_chbtn_LayerFild
checkButton chbtn_MaterialFild6 "M" pos:[Xch+BS1*5+chK3,yp1-20] width:18 height:18 checked:(ATfn_.GetINI 0 iniFile "Filds" "Fild_06_Material" false) highlightColor:colMaterial enabled:true tooltip:tt_chbtn_MaterialFild
label lbl_7 "7" pos:[(Xedt-10)+BS1*6,(yp1-18)]
checkButton chbtn_SearchFild7 "S" pos:[Xch+BS1*6,yp1-20] width:18 height:18 checked:(ATfn_.GetINI 0 iniFile "Filds" "Fild_07_Search" false) highlightColor:colSearch enabled:true tooltip:tt_chbtn_SearchFild
checkButton chbtn_ObjectFild7 "O" pos:[Xch+BS1*6+chK1,yp1-20] width:18 height:18 checked:(ATfn_.GetINI 0 iniFile "Filds" "Fild_07_Object" false) highlightColor:colObject enabled:true tooltip:tt_chbtn_ObjectFild
checkButton chbtn_LayerFild7 "L" pos:[Xch+BS1*6+chK2,yp1-20] width:18 height:18 checked:(ATfn_.GetINI 0 iniFile "Filds" "Fild_07_Layer" false) highlightColor:colLayer enabled:true tooltip:tt_chbtn_LayerFild
checkButton chbtn_MaterialFild7 "M" pos:[Xch+BS1*6+chK3,yp1-20] width:18 height:18 checked:(ATfn_.GetINI 0 iniFile "Filds" "Fild_07_Material" false) highlightColor:colMaterial enabled:true tooltip:tt_chbtn_MaterialFild
label lbl_8 "8" pos:[(Xedt-10)+BS1*7,(yp1-18)]
checkButton chbtn_SearchFild8 "S" pos:[Xch+BS1*7,yp1-20] width:18 height:18 checked:(ATfn_.GetINI 0 iniFile "Filds" "Fild_08_Search" false) highlightColor:colSearch enabled:true tooltip:tt_chbtn_SearchFild
checkButton chbtn_ObjectFild8 "O" pos:[Xch+BS1*7+chK1,yp1-20] width:18 height:18 checked:(ATfn_.GetINI 0 iniFile "Filds" "Fild_08_Object" false) highlightColor:colObject enabled:true tooltip:tt_chbtn_ObjectFild
checkButton chbtn_LayerFild8 "L" pos:[Xch+BS1*7+chK2,yp1-20] width:18 height:18 checked:(ATfn_.GetINI 0 iniFile "Filds" "Fild_08_Layer" false) highlightColor:colLayer enabled:true tooltip:tt_chbtn_LayerFild
checkButton chbtn_MaterialFild8 "M" pos:[Xch+BS1*7+chK3,yp1-20] width:18 height:18 checked:(ATfn_.GetINI 0 iniFile "Filds" "Fild_08_Material" false) highlightColor:colMaterial enabled:true tooltip:tt_chbtn_MaterialFild

dropdownlist ddl_Fild_01 items:(ATfn_.GetINI 0 iniFile "Filds" "Fild_01_Saved" #("")) pos:[(Xedt-16),yp1+ddlOf] width:20 height:33 selection:0 enabled:(not OMS) tooltip:tt_ddl_Fild
edittext edt_Fild_01 "" text:(ATfn_.GetINI 1 iniFile "Filds" "Fild_01_Default" "") pos:[Xedt,yp1+edtOf] width:80 height:17 enabled:(not OMS)
dropdownlist ddl_Fild_02 items:(ATfn_.GetINI 0 iniFile "Filds" "Fild_02_Saved" #("")) pos:[(Xedt-16)+BS1*1,yp1+ddlOf] width:20 height:33 selection:0 enabled:(not OMS) tooltip:tt_ddl_Fild
edittext edt_Fild_02 "" text:(ATfn_.GetINI 1 iniFile "Filds" "Fild_02_Default" "") pos:[Xedt+BS1*1,yp1+edtOf] width:80 height:17 enabled:(not OMS)
dropdownlist ddl_Fild_03 items:(ATfn_.GetINI 0 iniFile "Filds" "Fild_03_Saved" #("")) pos:[(Xedt-16)+BS1*2,yp1+ddlOf] width:20 height:33 selection:0 enabled:(not OMS) tooltip:tt_ddl_Fild
edittext edt_Fild_03 "" text:(ATfn_.GetINI 1 iniFile "Filds" "Fild_03_Default" "") pos:[Xedt+BS1*2,yp1+edtOf] width:80 height:17 enabled:(not OMS)
dropdownlist ddl_Fild_04 items:(ATfn_.GetINI 0 iniFile "Filds" "Fild_04_Saved" #("")) pos:[(Xedt-16)+BS1*3,yp1+ddlOf] width:20 height:33 selection:0 enabled:(not OMS) tooltip:tt_ddl_Fild
edittext edt_Fild_04 "" text:(ATfn_.GetINI 1 iniFile "Filds" "Fild_04_Default" "") pos:[Xedt+BS1*3,yp1+edtOf] width:80 height:17 enabled:(not OMS)
dropdownlist ddl_Fild_05 items:(ATfn_.GetINI 0 iniFile "Filds" "Fild_05_Saved" #("")) pos:[(Xedt-16)+BS1*4,yp1+ddlOf] width:20 height:33 selection:0 enabled:(not OMS) tooltip:tt_ddl_Fild
edittext edt_Fild_05 "" text:(ATfn_.GetINI 1 iniFile "Filds" "Fild_05_Default" "") pos:[Xedt+BS1*4,yp1+edtOf] width:80 height:17 enabled:(not OMS)
dropdownlist ddl_Fild_06 items:(ATfn_.GetINI 0 iniFile "Filds" "Fild_06_Saved" #("")) pos:[(Xedt-16)+BS1*5,yp1+ddlOf] width:20 height:33 selection:0 enabled:(not OMS) tooltip:tt_ddl_Fild
edittext edt_Fild_06 "" text:(ATfn_.GetINI 1 iniFile "Filds" "Fild_06_Default" "") pos:[Xedt+BS1*5,yp1+edtOf] width:80 height:17 enabled:(not OMS)
dropdownlist ddl_Fild_07 items:(ATfn_.GetINI 0 iniFile "Filds" "Fild_07_Saved" #("")) pos:[(Xedt-16)+BS1*6,yp1+ddlOf] width:20 height:33 selection:0 enabled:(not OMS) tooltip:tt_ddl_Fild
edittext edt_Fild_07 "" text:(ATfn_.GetINI 1 iniFile "Filds" "Fild_07_Default" "") pos:[Xedt+BS1*6,yp1+edtOf] width:80 height:17 enabled:(not OMS)
dropdownlist ddl_Fild_08 items:(ATfn_.GetINI 0 iniFile "Filds" "Fild_08_Saved" #("")) pos:[(Xedt-16)+BS1*7,yp1+ddlOf] width:20 height:33 selection:0 enabled:(not OMS) tooltip:tt_ddl_Fild
edittext edt_Fild_08 "" text:(ATfn_.GetINI 1 iniFile "Filds" "Fild_08_Default" "") pos:[Xedt+BS1*7,yp1+edtOf] width:80 height:17 enabled:(not OMS)
	
-- button btn_SOLMClear " S O L M" pos:[808,(yp2-44)] width:56 height:18 tooltip:"On\Off all Search, Object,\nLayer and Material CheckButtons"
button btn_SClear "S" pos:[806,(yp2-44)] width:27 height:18 tooltip:"Lmb - On\Off all Search CheckButtons\nRmb - On\Off all SOLM CheckButtons"
button btn_OClear "O" pos:[835,(yp2-44)] width:27 height:18 tooltip:"Lmb - On\Off all Object CheckButtons\nRmb - On\Off all SOLM CheckButtons"
button btn_LClear "L" pos:[864,(yp2-44)] width:27 height:18 tooltip:"Lmb - On\Off all Layer CheckButtons\nRmb - On\Off all SOLM CheckButtons"
button btn_MClear "M" pos:[893,(yp2-44)] width:27 height:18 tooltip:"Lmb - On\Off all Material CheckButtons\nRmb - On\Off all SOLM CheckButtons"

checkButton chbtn_Separator "Separator" pos:[806,(yp2-24)] width:56 height:20 checked:(ATfn_.GetINI 0 iniFile "Separators" "Separator_State" false) highlightColor:colCHBX enabled:true tooltip:"Toggle Separator"
checkButton chbtn_OneObjCounter "Counter" pos:[864,(yp2-24)] width:56 height:20 checked:(ATfn_.GetINI 0 iniFile "Filds" "OneObjectCounter" false) highlightColor:colCHBX enabled:true tooltip:"Toggle counter for one object"
	
button btn_FildsClear "ClearFilds" pos:[806,(yp2-2)] width:56 height:18 enabled:(not OMS) tooltip:"Clear all Filds"
button btn_RenameGet "Get" pos:[864,(yp2-2)] width:56 height:18 enabled:(not OMS) tooltip:"Get selected object name"
	
button btn_RenameObject "Rename Object" pos:[922,(yp2-44)] width:88 height:18 tooltip:"Rename objects"
button btn_ObjectToLayer "Add to Layer" pos:[922,(yp2-24)] width:88 height:20 tooltip:"Add to layer by Name"
button btn_CreateMaterial "Create Material" pos:[922,(yp2-2)] width:88 height:18 tooltip:"Create Material"
button btn_ObjLayerCreateMat "GO" pos:[1012,(yp2-44)] width:48 height:40 tooltip:"Rename Objects,\nAdd to Layer,\nCreate Material."
button btn_SearchTextures "Search" pos:[1012,(yp2-2)] width:48 height:18 enabled:(not OMS) tooltip:"Lmb - Search for all Texture Maps\nRmb - Reset Search for all Texture Maps"

button btn_Preferences "Preferences" pos:[734,(yp2-2)] width:70 height:18 tooltip:"Show/Hide Preferences dialog"

button btn_MinimizeUI "-" pos:[8,yp2] width:14 height:14 tooltip:"Minimize UI"
button btn_DockTop "T" pos:[26,yp2-2] width:18 height:18 tooltip:"Dock Top"
button btn_DockBottom "B" pos:[46,yp2-2] width:18 height:18 tooltip:"Dock Bottom"
	
checkButton chbtn_FromObjMode "Objects" pos:[26,yp4] width:50 height:18 checked:(OMS) highlightColor:colCHBX enabled:true tooltip:"Objects mode toggle:\nGet names from selected objects"
checkButton chbtn_MultiStatus "M" pos:[78,yp4] width:20 height:18 checked:(ATfn_.GetINI 0 iniFile "MainDirectory" "MultiState" false) highlightColor:colCHBX enabled:true tooltip:"Toggle MultiDirectiry mode"
dropdownlist ddl_RootsSaved items:(ATfn_.GetINI 0 iniFile "MainDirectory" "RootsSaved" #()) pos:[100,yp4+1+ddlOf] width:20 height:20 selection:0 tooltip:"Saved roots\nLmb - Choose the root directory\nAlt+Lmb - Delete the root directory\nAlt+Rmb - Save the root directory"
dropdownlist ddl_Roots items:(ATfn_.GetINI 0 iniFile "MainDirectory" "RootsLastUsed" #()) pos:[119,yp4+1+ddlOf] width:420 height:20 selection:(ATfn_.GetINI 0 iniFile "MainDirectory" "RootsSelection" 0) enabled:((ATfn_.GetINI 0 iniFile "MainDirectory" "RootsLastUsed" #()).count!=0) tooltip:"Alt+Lmb - Delete directory"
button btn_RootBrowse "Browse" pos:[540,(yp4)] width:46 height:18 enabled:true tooltip:"Lmb - Add the root directory\nRmb - Add the subdirectories of the root"
button btn_Del "Del" pos:[588,yp4] width:27 height:18 enabled:((ATfn_.GetINI 0 iniFile "MainDirectory" "RootsLastUsed" #()).count!=0) tooltip:"Delete directory"
button btn_All "All" pos:[617,yp4] width:27 height:18 enabled:((ATfn_.GetINI 0 iniFile "MainDirectory" "RootsLastUsed" #()).count!=0) tooltip:"Clear the list of directories"
button btn_Sel "Sel" pos:[646,yp4] width:27 height:18 enabled:((ATfn_.GetINI 0 iniFile "MainDirectory" "RootsLastUsed" #()).count!=0) tooltip:"Clear the list except\n selected directory"
button btn_Sub "Sub" pos:[675,yp4] width:27 height:18 enabled:((ATfn_.GetINI 0 iniFile "MainDirectory" "RootsLastUsed" #()).count!=0) tooltip:"  Get the subdirectories\n of the selected directory"
	
checkButton chbtn_SpecialRule "Rule" pos:[704,yp4] width:40 height:18 checked:(ATfn_.GetINI 0 iniFile "Settings" "SpecialRuleState" false) highlightColor:colCHBX tooltip:"Toggle Main filds search special rule. \n# - name\nFor example:\nSearch name - ''Test''\nIf type expression ''_#_'' \nThen script will search ''_Test_''"
-- label lbl_SpecialRule "Special Rule" pos:[(10+17),yp2-1+3]
edittext edt_SpecialRule "" text:(ATfn_.GetINI 1 iniFile "Settings" "SpecialRuleExpression" "#") pos:[742,yp4+edtOf] width:60 height:17 enabled:(ATfn_.GetINI 0 iniFile "Settings" "SpecialRuleState" false)

checkButton chbtn_Blend "VRayBlendMtl" pos:[806,yp4] width:114 height:18 checked:(ATfn_.GetINI 0 iniFile "Settings" "BlendState" false) highlightColor:colCHBX enabled:true tooltip:" Put VRayMtl in VRayBlendMtl"

button btn_MaterialsByName " Mat By Name" pos:[922,yp4] width:68 height:18 tooltip:" Run Materials By Name "
button btn_WireColorByMaterial "Wire By Mat" pos:[992,yp4] width:68 height:18 tooltip:" Set WireColor By Material "

-- local borderState = true
local borderState = false
button btn_MapsType "Maps" pos:[10,(yp3-19)] width:84 height:18 border:borderState tooltip:""
button btn_SearchNames "   Search Names" pos:[xp3[2],(yp3-19)] width:98 height:18 border:borderState tooltip:""
button btn_Textures "Textures" pos:[xp3[4],(yp3-19)] width:352 height:18 border:borderState tooltip:""
button btn_OCIO "OCIO" pos:[xp3[18]-7,(yp3-19)] width:34 height:18 border:borderState tooltip:""
button btn_Loaders "Loaders" pos:[(xp3[7]+7),(yp3-19)] width:66 height:18 border:borderState tooltip:""
button btn_Tiling "Tiling" pos:[xp3[9],(yp3-19)] width:92 height:18 border:borderState tooltip:""
button btn_ColorSpace "Color Space" pos:[xp3[11],(yp3-19)] width:62 height:18 border:borderState tooltip:""
button btn_Composite "C" pos:[xp3[17],(yp3-19)] width:18 height:18 border:borderState tooltip:""
button btn_ColorCorrect "CC" pos:[xp3[12],(yp3-19)] width:22 height:18 border:borderState tooltip:""
button btn_Gamma "Gamma" pos:[xp3[13],(yp3-19)] width:52 height:18 border:borderState tooltip:""
button btn_RGB "RGB" pos:[xp3[14],(yp3-19)] width:48 height:18 border:borderState tooltip:""
button btn_Types "Types" pos:[xp3[15],(yp3-19)] width:36 height:18 border:borderState tooltip:""
button btn_Size "Size" pos:[xp3[16],(yp3-19)] width:40 height:18 border:borderState tooltip:""

checkButton chbtn_DiffuseState "" pos:[xp3[1],(yp3+2)+BS2*0] width:14 height:14 checked:(ATfn_.GetINI 0 iniFile "Diffuse" "OnOffState" false) highlightColor:colCHBX
label lbl_DiffuseState "Diffuse" pos:[(xp3[1]+xb1),(yp3+2)+BS2*0]
dropdownlist ddl_DiffuseSearchName items:(ATfn_.GetINI 0 iniFile "Diffuse" "SavedSearchNames" #("")) pos:[xp3[2],(yp3+ddlOf)+BS2*0] width:20 height:33 selection:0 enabled:(ATfn_.GetINI 0 iniFile "Diffuse" "OnOffState" false) tooltip:tt_ddl_Fild
edittext edt_DiffuseSearchName "" text:(ATfn_.GetINI 1 iniFile "Diffuse" "DefaultSearchName" "") pos:[xp3[3],(yp3+edtOf)+BS2*0] width:w[2] height:17 enabled:(ATfn_.GetINI 0 iniFile "Diffuse" "OnOffState" false)
checkButton chbtn_DiffuseStatus "S" pos:[xp3[4],yp3+BS2*0] width:w[1] height:18 checked:(ATfn_.GetINI 0 iniFile "Diffuse" "OnOffState" false) highlightColor:colZ enabled:((ATfn_.GetINI 0 iniFile "Diffuse" "OnOffState" false) and (not OMS)) tooltip:tt_chbtn_Search
dropdownlist ddl_DiffuseTexture items:#() pos:[xp3[5],(yp3+ddlOf)+BS2*0] width:w[3] height:20 selection:0 enabled:false tooltip:tt_ddl_Texture
button btn_DiffuseBrowse "..." pos:[xp3[6],yp3+BS2*0] width:w[1] height:18 enabled:((ATfn_.GetINI 0 iniFile "Diffuse" "OnOffState" false) and (not OMS)) tooltip:tt_btn_Browse
dropdownlist ddl_DiffuseLoader items:loaderItems pos:[xp3[7],(yp3+ddlOf)+BS2*0] width:w[4] height:33 selection:(ATfn_.GetINI 0 iniFile "Diffuse" "DefaultLoader" 1) enabled:(ATfn_.GetINI 0 iniFile "Diffuse" "OnOffState" false) tooltip:tt_ddl_Loader
checkButton chbtn_DiffuseOCIO "O" pos:[xp3[18],yp3+BS2*0] width:w[1] height:18 checked:(if (ATfn_.GetINI 0 iniFile "Diffuse" "OnOffState" false) then (ATfn_.GetINI 0 iniFile "Diffuse" "OCIOState" false) else (false)) highlightColor:colCHBX enabled:(ATfn_.GetINI 0 iniFile "Diffuse" "OnOffState" false) tooltip:tt_chbtn_OCIO
colorpicker color_DiffuseCoColor "" pos:[xp3[8],yp3+BS2*0] width:w[5] height:18 color:(ATfn_.GetINI 0 iniFile "Diffuse" "CorrectionVRayColor" [128,128,128]) enabled:(ATfn_.GetINI 0 iniFile "Diffuse" "OnOffState" false) modal:false tooltip:tt_color_CoColor
spinner spnr_DiffuseTilingU "" pos:[xp3[9],(yp3+edtOf)+BS2*0] width:w[6] range:[-999,999,(ATfn_.GetINI 0 iniFile "Diffuse" "UTiling" 1.0)] type:#float scale:0.1 enabled:(ATfn_.GetINI 0 iniFile "Diffuse" "OnOffState" false) tooltip:tt_spnr_TilingU
spinner spnr_DiffuseTilingV "" pos:[xp3[10],(yp3+edtOf)+BS2*0] width:w[6] range:[-999,999,(ATfn_.GetINI 0 iniFile "Diffuse" "VTiling" 1.0)] type:#float scale:0.1 enabled:(ATfn_.GetINI 0 iniFile "Diffuse" "OnOffState" false) tooltip:tt_spnr_TilingV
dropdownlist ddl_DiffuseHDRIColSp items:HDRIColSpTypes pos:[xp3[11],(yp3+ddlOf)+BS2*0] width:w[7] height:33 selection:(ATfn_.GetINI 0 iniFile "Diffuse" "HDRIColorSpace" 2) enabled:(ATfn_.GetINI 0 iniFile "Diffuse" "OnOffState" false) tooltip:tt_ddl_HDRIColSp
checkButton chbtn_DiffuseColCor "CC" pos:[xp3[12],yp3+BS2*0] width:w[8] height:18 checked:(if (ATfn_.GetINI 0 iniFile "Diffuse" "OnOffState" false) then (ATfn_.GetINI 0 iniFile "Diffuse" "ColorCorrectState" false) else (false)) highlightColor:colCHBX enabled:(ATfn_.GetINI 0 iniFile "Diffuse" "OnOffState" false) tooltip:tt_chbtn_ColCor
spinner spnr_DiffuseCCGammaContrast "" pos:[xp3[13],(yp3+edtOf)+BS2*0] width:w[9] range:[0,99,(ATfn_.GetINI 0 iniFile "Diffuse" "ColCorGammaContrast" 1.0)] type:#float scale:0.001 enabled:(ATfn_.GetINI 0 iniFile "Diffuse" "OnOffState" false) tooltip:tt_spnr_CCGammaContrast
spinner spnr_DiffuseCCRGB "" pos:[xp3[14],(yp3+edtOf)+BS2*0] width:w[10] range:[0,999,(ATfn_.GetINI 0 iniFile "Diffuse" "ColCorRGB" 100)] type:#float scale:0.1 enabled:(ATfn_.GetINI 0 iniFile "Diffuse" "OnOffState" false) tooltip:tt_spnr_CCRGB
button btn_DiffuseMapType "" pos:[xp3[15],yp3+BS2*0] width:w[11] height:18 enabled:false tooltip:tt_btn_MapType
button btn_DiffuseMapSize "" pos:[xp3[16],yp3+BS2*0] width:w[12] height:18 enabled:false tooltip:tt_btn_MapSize
checkButton chbtn_DiffuseCompos "C" pos:[xp3[17],yp3+BS2*0] width:w[1] height:18 checked:(if (ATfn_.GetINI 0 iniFile "Diffuse" "OnOffState" false) then (ATfn_.GetINI 0 iniFile "Diffuse" "CompositeState" false) else (false)) highlightColor:colCHBX enabled:(ATfn_.GetINI 0 iniFile "Diffuse" "OnOffState" false) tooltip:tt_chbtn_Compos

checkButton chbtn_RoughnessState "" pos:[xp3[1],(yp3+2)+BS2*1] width:14 height:14 checked:(ATfn_.GetINI 0 iniFile "Roughness" "OnOffState" false) highlightColor:colCHBX
label lbl_RoughnessState "Roughness" pos:[(xp3[1]+xb1),(yp3+2)+BS2*1]
dropdownlist ddl_RoughnessSearchName items:(ATfn_.GetINI 0 iniFile "Roughness" "SavedSearchNames" #("")) pos:[xp3[2],(yp3+ddlOf)+BS2*1] width:20 height:33 selection:0 enabled:(ATfn_.GetINI 0 iniFile "Roughness" "OnOffState" false) tooltip:tt_ddl_Fild
edittext edt_RoughnessSearchName "" text:(ATfn_.GetINI 1 iniFile "Roughness" "DefaultSearchName" "") pos:[xp3[3],(yp3+edtOf)+BS2*1] width:w[2] height:17 enabled:(ATfn_.GetINI 0 iniFile "Roughness" "OnOffState" false)
checkButton chbtn_RoughnessStatus "S" pos:[xp3[4],yp3+BS2*1] width:w[1] height:18 checked:(ATfn_.GetINI 0 iniFile "Roughness" "OnOffState" false) highlightColor:colZ enabled:((ATfn_.GetINI 0 iniFile "Roughness" "OnOffState" false) and (not OMS)) tooltip:tt_chbtn_Search
dropdownlist ddl_RoughnessTexture items:#() pos:[xp3[5],(yp3+ddlOf)+BS2*1] width:w[3] height:20 selection:0 enabled:false tooltip:tt_ddl_Texture
button btn_RoughnessBrowse "..." pos:[xp3[6],yp3+BS2*1] width:w[1] height:18 enabled:((ATfn_.GetINI 0 iniFile "Roughness" "OnOffState" false) and (not OMS)) tooltip:tt_btn_Browse
dropdownlist ddl_RoughnessLoader items:loaderItems pos:[xp3[7],(yp3+ddlOf)+BS2*1] width:w[4] height:33 selection:(ATfn_.GetINI 0 iniFile "Roughness" "DefaultLoader" 1) enabled:(ATfn_.GetINI 0 iniFile "Roughness" "OnOffState" false) tooltip:tt_ddl_Loader
checkButton chbtn_RoughnessOCIO "O" pos:[xp3[18],yp3+BS2*1] width:w[1] height:18 checked:(if (ATfn_.GetINI 0 iniFile "Roughness" "OnOffState" false) then (ATfn_.GetINI 0 iniFile "Roughness" "OCIOState" false) else (false)) highlightColor:colCHBX enabled:(ATfn_.GetINI 0 iniFile "Roughness" "OnOffState" false) tooltip:tt_chbtn_OCIO
colorpicker color_RoughnessCoColor "" pos:[xp3[8],yp3+BS2*1] width:w[5] height:18 color:(ATfn_.GetINI 0 iniFile "Roughness" "CorrectionVRayColor" [128,128,128]) enabled:(ATfn_.GetINI 0 iniFile "Roughness" "OnOffState" false) modal:false tooltip:tt_color_CoColor
spinner spnr_RoughnessTilingU "" pos:[xp3[9],(yp3+edtOf)+BS2*1] width:w[6] range:[-999,999,(ATfn_.GetINI 0 iniFile "Roughness" "UTiling" 1.0)] type:#float scale:0.1 enabled:(ATfn_.GetINI 0 iniFile "Roughness" "OnOffState" false) tooltip:tt_spnr_TilingU
spinner spnr_RoughnessTilingV "" pos:[xp3[10],(yp3+edtOf)+BS2*1] width:w[6] range:[-999,999,(ATfn_.GetINI 0 iniFile "Roughness" "VTiling" 1.0)] type:#float scale:0.1 enabled:(ATfn_.GetINI 0 iniFile "Roughness" "OnOffState" false) tooltip:tt_spnr_TilingV
dropdownlist ddl_RoughnessHDRIColSp items:HDRIColSpTypes pos:[xp3[11],(yp3+ddlOf)+BS2*1] width:w[7] height:33 selection:(ATfn_.GetINI 0 iniFile "Roughness" "HDRIColorSpace" 2) enabled:(ATfn_.GetINI 0 iniFile "Roughness" "OnOffState" false) tooltip:tt_ddl_HDRIColSp
checkButton chbtn_RoughnessColCor "CC" pos:[xp3[12],yp3+BS2*1] width:w[8] height:18 checked:(if (ATfn_.GetINI 0 iniFile "Roughness" "OnOffState" false) then (ATfn_.GetINI 0 iniFile "Roughness" "ColorCorrectState" false) else (false)) highlightColor:colCHBX enabled:(ATfn_.GetINI 0 iniFile "Roughness" "OnOffState" false) tooltip:tt_chbtn_ColCor
spinner spnr_RoughnessCCGammaContrast "" pos:[xp3[13],(yp3+edtOf)+BS2*1] width:w[9] range:[0,99,(ATfn_.GetINI 0 iniFile "Roughness" "ColCorGammaContrast" 1.0)] type:#float scale:0.001 enabled:(ATfn_.GetINI 0 iniFile "Roughness" "OnOffState" false) tooltip:tt_spnr_CCGammaContrast
spinner spnr_RoughnessCCRGB "" pos:[xp3[14],(yp3+edtOf)+BS2*1] width:w[10] range:[0,999,(ATfn_.GetINI 0 iniFile "Roughness" "ColCorRGB" 100)] type:#float scale:0.1 enabled:(ATfn_.GetINI 0 iniFile "Roughness" "OnOffState" false) tooltip:tt_spnr_CCRGB
button btn_RoughnessMapType "" pos:[xp3[15],yp3+BS2*1] width:w[11] height:18 enabled:false tooltip:tt_btn_MapType
button btn_RoughnessMapSize "" pos:[xp3[16],yp3+BS2*1] width:w[12] height:18 enabled:false tooltip:tt_btn_MapSize
checkButton chbtn_RoughnessCompos "C" pos:[xp3[17],yp3+BS2*1] width:w[1] height:18 checked:(if (ATfn_.GetINI 0 iniFile "Roughness" "OnOffState" false) then (ATfn_.GetINI 0 iniFile "Roughness" "CompositeState" false) else (false)) highlightColor:colCHBX enabled:(ATfn_.GetINI 0 iniFile "Roughness" "OnOffState" false) tooltip:tt_chbtn_Compos

checkButton chbtn_SelfIllumState "" pos:[xp3[1],(yp3+2)+BS2*2] width:14 height:14 checked:(ATfn_.GetINI 0 iniFile "SelfIllum" "OnOffState" false) highlightColor:colCHBX
label lbl_SelfIllumState "SelfIllum" pos:[(xp3[1]+xb1),(yp3+2)+BS2*2]
dropdownlist ddl_SelfIllumSearchName items:(ATfn_.GetINI 0 iniFile "SelfIllum" "SavedSearchNames" #("")) pos:[xp3[2],(yp3+ddlOf)+BS2*2] width:20 height:33 selection:0 enabled:(ATfn_.GetINI 0 iniFile "SelfIllum" "OnOffState" false) tooltip:tt_ddl_Fild
edittext edt_SelfIllumSearchName "" text:(ATfn_.GetINI 1 iniFile "SelfIllum" "DefaultSearchName" "") pos:[xp3[3],(yp3+edtOf)+BS2*2] width:w[2] height:17 enabled:(ATfn_.GetINI 0 iniFile "SelfIllum" "OnOffState" false)
checkButton chbtn_SelfIllumStatus "S" pos:[xp3[4],yp3+BS2*2] width:w[1] height:18 checked:(ATfn_.GetINI 0 iniFile "SelfIllum" "OnOffState" false) highlightColor:colZ enabled:((ATfn_.GetINI 0 iniFile "SelfIllum" "OnOffState" false) and (not OMS)) tooltip:tt_chbtn_Search
dropdownlist ddl_SelfIllumTexture items:#() pos:[xp3[5],(yp3+ddlOf)+BS2*2] width:w[3] height:20 selection:0 enabled:false tooltip:tt_ddl_Texture
button btn_SelfIllumBrowse "..." pos:[xp3[6],yp3+BS2*2] width:w[1] height:18 enabled:((ATfn_.GetINI 0 iniFile "SelfIllum" "OnOffState" false) and (not OMS)) tooltip:tt_btn_Browse
dropdownlist ddl_SelfIllumLoader items:loaderItems pos:[xp3[7],(yp3+ddlOf)+BS2*2] width:w[4] height:33 selection:(ATfn_.GetINI 0 iniFile "SelfIllum" "DefaultLoader" 1) enabled:(ATfn_.GetINI 0 iniFile "SelfIllum" "OnOffState" false) tooltip:tt_ddl_Loader
checkButton chbtn_SelfIllumOCIO "O" pos:[xp3[18],yp3+BS2*2] width:w[1] height:18 checked:(if (ATfn_.GetINI 0 iniFile "SelfIllum" "OnOffState" false) then (ATfn_.GetINI 0 iniFile "SelfIllum" "OCIOState" false) else (false)) highlightColor:colCHBX enabled:(ATfn_.GetINI 0 iniFile "SelfIllum" "OnOffState" false) tooltip:tt_chbtn_OCIO
colorpicker color_SelfIllumCoColor "" pos:[xp3[8],yp3+BS2*2] width:w[5] height:18 color:(ATfn_.GetINI 0 iniFile "SelfIllum" "CorrectionVRayColor" [128,128,128]) enabled:(ATfn_.GetINI 0 iniFile "SelfIllum" "OnOffState" false) modal:false tooltip:tt_color_CoColor
spinner spnr_SelfIllumTilingU "" pos:[xp3[9],(yp3+edtOf)+BS2*2] width:w[6] range:[-999,999,(ATfn_.GetINI 0 iniFile "SelfIllum" "UTiling" 1.0)] type:#float scale:0.1 enabled:(ATfn_.GetINI 0 iniFile "SelfIllum" "OnOffState" false) tooltip:tt_spnr_TilingU
spinner spnr_SelfIllumTilingV "" pos:[xp3[10],(yp3+edtOf)+BS2*2] width:w[6] range:[-999,999,(ATfn_.GetINI 0 iniFile "SelfIllum" "VTiling" 1.0)] type:#float scale:0.1 enabled:(ATfn_.GetINI 0 iniFile "SelfIllum" "OnOffState" false) tooltip:tt_spnr_TilingV
dropdownlist ddl_SelfIllumHDRIColSp items:HDRIColSpTypes pos:[xp3[11],(yp3+ddlOf)+BS2*2] width:w[7] height:33 selection:(ATfn_.GetINI 0 iniFile "SelfIllum" "HDRIColorSpace" 2) enabled:(ATfn_.GetINI 0 iniFile "SelfIllum" "OnOffState" false) tooltip:tt_ddl_HDRIColSp
checkButton chbtn_SelfIllumColCor "CC" pos:[xp3[12],yp3+BS2*2] width:w[8] height:18 checked:(if (ATfn_.GetINI 0 iniFile "SelfIllum" "OnOffState" false) then (ATfn_.GetINI 0 iniFile "SelfIllum" "ColorCorrectState" false) else (false)) highlightColor:colCHBX enabled:(ATfn_.GetINI 0 iniFile "SelfIllum" "OnOffState" false) tooltip:tt_chbtn_ColCor
spinner spnr_SelfIllumCCGammaContrast "" pos:[xp3[13],(yp3+edtOf)+BS2*2] width:w[9] range:[0,99,(ATfn_.GetINI 0 iniFile "SelfIllum" "ColCorGammaContrast" 1.0)] type:#float scale:0.001 enabled:(ATfn_.GetINI 0 iniFile "SelfIllum" "OnOffState" false) tooltip:tt_spnr_CCGammaContrast
spinner spnr_SelfIllumCCRGB "" pos:[xp3[14],(yp3+edtOf)+BS2*2] width:w[10] range:[0,999,(ATfn_.GetINI 0 iniFile "SelfIllum" "ColCorRGB" 100)] type:#float scale:0.1 enabled:(ATfn_.GetINI 0 iniFile "SelfIllum" "OnOffState" false) tooltip:tt_spnr_CCRGB
button btn_SelfIllumMapType "" pos:[xp3[15],yp3+BS2*2] width:w[11] height:18 enabled:false tooltip:tt_btn_MapType
button btn_SelfIllumMapSize "" pos:[xp3[16],yp3+BS2*2] width:w[12] height:18 enabled:false tooltip:tt_btn_MapSize
checkButton chbtn_SelfIllumCompos "C" pos:[xp3[17],yp3+BS2*2] width:w[1] height:18 checked:(if (ATfn_.GetINI 0 iniFile "SelfIllum" "OnOffState" false) then (ATfn_.GetINI 0 iniFile "SelfIllum" "CompositeState" false) else (false)) highlightColor:colCHBX enabled:(ATfn_.GetINI 0 iniFile "SelfIllum" "OnOffState" false) tooltip:tt_chbtn_Compos

checkButton chbtn_ReflectState "" pos:[xp3[1],(yp3+2)+BS2*3] width:14 height:14 checked:(ATfn_.GetINI 0 iniFile "Reflect" "OnOffState" false) highlightColor:colCHBX
label lbl_ReflectState "Reflect" pos:[(xp3[1]+xb1),(yp3+2)+BS2*3]
dropdownlist ddl_ReflectSearchName items:(ATfn_.GetINI 0 iniFile "Reflect" "SavedSearchNames" #("")) pos:[xp3[2],(yp3+ddlOf)+BS2*3] width:20 height:33 selection:0 enabled:(ATfn_.GetINI 0 iniFile "Reflect" "OnOffState" false) tooltip:tt_ddl_Fild
edittext edt_ReflectSearchName "" text:(ATfn_.GetINI 1 iniFile "Reflect" "DefaultSearchName" "") pos:[xp3[3],(yp3+edtOf)+BS2*3] width:w[2] height:17 enabled:(ATfn_.GetINI 0 iniFile "Reflect" "OnOffState" false)
checkButton chbtn_ReflectStatus "S" pos:[xp3[4],yp3+BS2*3] width:w[1] height:18 checked:(ATfn_.GetINI 0 iniFile "Reflect" "OnOffState" false) highlightColor:colZ enabled:((ATfn_.GetINI 0 iniFile "Reflect" "OnOffState" false) and (not OMS)) tooltip:tt_chbtn_Search
dropdownlist ddl_ReflectTexture items:#() pos:[xp3[5],(yp3+ddlOf)+BS2*3] width:w[3] height:20 selection:0 enabled:false tooltip:tt_ddl_Texture
button btn_ReflectBrowse "..." pos:[xp3[6],yp3+BS2*3] width:w[1] height:18 enabled:((ATfn_.GetINI 0 iniFile "Reflect" "OnOffState" false) and (not OMS)) tooltip:tt_btn_Browse
dropdownlist ddl_ReflectLoader items:loaderItems pos:[xp3[7],(yp3+ddlOf)+BS2*3] width:w[4] height:33 selection:(ATfn_.GetINI 0 iniFile "Reflect" "DefaultLoader" 1) enabled:(ATfn_.GetINI 0 iniFile "Reflect" "OnOffState" false) tooltip:tt_ddl_Loader
checkButton chbtn_ReflectOCIO "O" pos:[xp3[18],yp3+BS2*3] width:w[1] height:18 checked:(if (ATfn_.GetINI 0 iniFile "Reflect" "OnOffState" false) then (ATfn_.GetINI 0 iniFile "Reflect" "OCIOState" false) else (false)) highlightColor:colCHBX enabled:(ATfn_.GetINI 0 iniFile "Reflect" "OnOffState" false) tooltip:tt_chbtn_OCIO
colorpicker color_ReflectCoColor "" pos:[xp3[8],yp3+BS2*3] width:w[5] height:18 color:(ATfn_.GetINI 0 iniFile "Reflect" "CorrectionVRayColor" [128,128,128]) enabled:(ATfn_.GetINI 0 iniFile "Reflect" "OnOffState" false) modal:false tooltip:tt_color_CoColor
spinner spnr_ReflectTilingU "" pos:[xp3[9],(yp3+edtOf)+BS2*3] width:w[6] range:[-999,999,(ATfn_.GetINI 0 iniFile "Reflect" "UTiling" 1.0)] type:#float scale:0.1 enabled:(ATfn_.GetINI 0 iniFile "Reflect" "OnOffState" false) tooltip:tt_spnr_TilingU
spinner spnr_ReflectTilingV "" pos:[xp3[10],(yp3+edtOf)+BS2*3] width:w[6] range:[-999,999,(ATfn_.GetINI 0 iniFile "Reflect" "VTiling" 1.0)] type:#float scale:0.1 enabled:(ATfn_.GetINI 0 iniFile "Reflect" "OnOffState" false) tooltip:tt_spnr_TilingV
dropdownlist ddl_ReflectHDRIColSp items:HDRIColSpTypes pos:[xp3[11],(yp3+ddlOf)+BS2*3] width:w[7] height:33 selection:(ATfn_.GetINI 0 iniFile "Reflect" "HDRIColorSpace" 2) enabled:(ATfn_.GetINI 0 iniFile "Reflect" "OnOffState" false) tooltip:tt_ddl_HDRIColSp
checkButton chbtn_ReflectColCor "CC" pos:[xp3[12],yp3+BS2*3] width:w[8] height:18 checked:(if (ATfn_.GetINI 0 iniFile "Reflect" "OnOffState" false) then (ATfn_.GetINI 0 iniFile "Reflect" "ColorCorrectState" false) else (false)) highlightColor:colCHBX enabled:(ATfn_.GetINI 0 iniFile "Reflect" "OnOffState" false) tooltip:tt_chbtn_ColCor
spinner spnr_ReflectCCGammaContrast "" pos:[xp3[13],(yp3+edtOf)+BS2*3] width:w[9] range:[0,99,(ATfn_.GetINI 0 iniFile "Reflect" "ColCorGammaContrast" 1.0)] type:#float scale:0.001 enabled:(ATfn_.GetINI 0 iniFile "Reflect" "OnOffState" false) tooltip:tt_spnr_CCGammaContrast
spinner spnr_ReflectCCRGB "" pos:[xp3[14],(yp3+edtOf)+BS2*3] width:w[10] range:[0,999,(ATfn_.GetINI 0 iniFile "Reflect" "ColCorRGB" 100)] type:#float scale:0.1 enabled:(ATfn_.GetINI 0 iniFile "Reflect" "OnOffState" false) tooltip:tt_spnr_CCRGB
button btn_ReflectMapType "" pos:[xp3[15],yp3+BS2*3] width:w[11] height:18 enabled:false tooltip:tt_btn_MapType
button btn_ReflectMapSize "" pos:[xp3[16],yp3+BS2*3] width:w[12] height:18 enabled:false tooltip:tt_btn_MapSize
checkButton chbtn_ReflectCompos "C" pos:[xp3[17],yp3+BS2*3] width:w[1] height:18 checked:(if (ATfn_.GetINI 0 iniFile "Reflect" "OnOffState" false) then (ATfn_.GetINI 0 iniFile "Reflect" "CompositeState" false) else (false)) highlightColor:colCHBX enabled:(ATfn_.GetINI 0 iniFile "Reflect" "OnOffState" false) tooltip:tt_chbtn_Compos

checkButton chbtn_HGlossinessState "" pos:[xp3[1],(yp3+2)+BS2*4] width:14 height:14 checked:(ATfn_.GetINI 0 iniFile "HGlossiness" "OnOffState" false) highlightColor:colCHBX
label lbl_HGlossinessState "HGlossiness" pos:[(xp3[1]+xb1),(yp3+2)+BS2*4]
dropdownlist ddl_HGlossinessSearchName items:(ATfn_.GetINI 0 iniFile "HGlossiness" "SavedSearchNames" #("")) pos:[xp3[2],(yp3+ddlOf)+BS2*4] width:20 height:33 selection:0 enabled:(ATfn_.GetINI 0 iniFile "HGlossiness" "OnOffState" false) tooltip:tt_ddl_Fild
edittext edt_HGlossinessSearchName "" text:(ATfn_.GetINI 1 iniFile "HGlossiness" "DefaultSearchName" "") pos:[xp3[3],(yp3+edtOf)+BS2*4] width:w[2] height:17 enabled:(ATfn_.GetINI 0 iniFile "HGlossiness" "OnOffState" false)
checkButton chbtn_HGlossinessStatus "S" pos:[xp3[4],yp3+BS2*4] width:w[1] height:18 checked:(ATfn_.GetINI 0 iniFile "HGlossiness" "OnOffState" false) highlightColor:colZ enabled:((ATfn_.GetINI 0 iniFile "HGlossiness" "OnOffState" false) and (not OMS)) tooltip:tt_chbtn_Search
dropdownlist ddl_HGlossinessTexture items:#() pos:[xp3[5],(yp3+ddlOf)+BS2*4] width:w[3] height:20 selection:0 enabled:false tooltip:tt_ddl_Texture
button btn_HGlossinessBrowse "..." pos:[xp3[6],yp3+BS2*4] width:w[1] height:18 enabled:((ATfn_.GetINI 0 iniFile "HGlossiness" "OnOffState" false) and (not OMS)) tooltip:tt_btn_Browse
dropdownlist ddl_HGlossinessLoader items:loaderItems pos:[xp3[7],(yp3+ddlOf)+BS2*4] width:w[4] height:33 selection:(ATfn_.GetINI 0 iniFile "HGlossiness" "DefaultLoader" 1) enabled:(ATfn_.GetINI 0 iniFile "HGlossiness" "OnOffState" false) tooltip:tt_ddl_Loader
checkButton chbtn_HGlossinessOCIO "O" pos:[xp3[18],yp3+BS2*4] width:w[1] height:18 checked:(if (ATfn_.GetINI 0 iniFile "HGlossiness" "OnOffState" false) then (ATfn_.GetINI 0 iniFile "HGlossiness" "OCIOState" false) else (false)) highlightColor:colCHBX enabled:(ATfn_.GetINI 0 iniFile "HGlossiness" "OnOffState" false) tooltip:tt_chbtn_OCIO
colorpicker color_HGlossinessCoColor "" pos:[xp3[8],yp3+BS2*4] width:w[5] height:18 color:(ATfn_.GetINI 0 iniFile "HGlossiness" "CorrectionVRayColor" [128,128,128]) enabled:(ATfn_.GetINI 0 iniFile "HGlossiness" "OnOffState" false) modal:false tooltip:tt_color_CoColor
spinner spnr_HGlossinessTilingU "" pos:[xp3[9],(yp3+edtOf)+BS2*4] width:w[6] range:[-999,999,(ATfn_.GetINI 0 iniFile "HGlossiness" "UTiling" 1.0)] type:#float scale:0.1 enabled:(ATfn_.GetINI 0 iniFile "HGlossiness" "OnOffState" false) tooltip:tt_spnr_TilingU
spinner spnr_HGlossinessTilingV "" pos:[xp3[10],(yp3+edtOf)+BS2*4] width:w[6] range:[-999,999,(ATfn_.GetINI 0 iniFile "HGlossiness" "VTiling" 1.0)] type:#float scale:0.1 enabled:(ATfn_.GetINI 0 iniFile "HGlossiness" "OnOffState" false) tooltip:tt_spnr_TilingV
dropdownlist ddl_HGlossinessHDRIColSp items:HDRIColSpTypes pos:[xp3[11],(yp3+ddlOf)+BS2*4] width:w[7] height:33 selection:(ATfn_.GetINI 0 iniFile "HGlossiness" "HDRIColorSpace" 2) enabled:(ATfn_.GetINI 0 iniFile "HGlossiness" "OnOffState" false) tooltip:tt_ddl_HDRIColSp
checkButton chbtn_HGlossinessColCor "CC" pos:[xp3[12],yp3+BS2*4] width:w[8] height:18 checked:(if (ATfn_.GetINI 0 iniFile "HGlossiness" "OnOffState" false) then (ATfn_.GetINI 0 iniFile "HGlossiness" "ColorCorrectState" false) else (false)) highlightColor:colCHBX enabled:(ATfn_.GetINI 0 iniFile "HGlossiness" "OnOffState" false) tooltip:tt_chbtn_ColCor
spinner spnr_HGlossinessCCGammaContrast "" pos:[xp3[13],(yp3+edtOf)+BS2*4] width:w[9] range:[0,99,(ATfn_.GetINI 0 iniFile "HGlossiness" "ColCorGammaContrast" 1.0)] type:#float scale:0.001 enabled:(ATfn_.GetINI 0 iniFile "HGlossiness" "OnOffState" false) tooltip:tt_spnr_CCGammaContrast
spinner spnr_HGlossinessCCRGB "" pos:[xp3[14],(yp3+edtOf)+BS2*4] width:w[10] range:[0,999,(ATfn_.GetINI 0 iniFile "HGlossiness" "ColCorRGB" 100)] type:#float scale:0.1 enabled:(ATfn_.GetINI 0 iniFile "HGlossiness" "OnOffState" false) tooltip:tt_spnr_CCRGB
button btn_HGlossinessMapType "" pos:[xp3[15],yp3+BS2*4] width:w[11] height:18 enabled:false tooltip:tt_btn_MapType
button btn_HGlossinessMapSize "" pos:[xp3[16],yp3+BS2*4] width:w[12] height:18 enabled:false tooltip:tt_btn_MapSize
checkButton chbtn_HGlossinessCompos "C" pos:[xp3[17],yp3+BS2*4] width:w[1] height:18 checked:(if (ATfn_.GetINI 0 iniFile "HGlossiness" "OnOffState" false) then (ATfn_.GetINI 0 iniFile "HGlossiness" "CompositeState" false) else (false)) highlightColor:colCHBX enabled:(ATfn_.GetINI 0 iniFile "HGlossiness" "OnOffState" false) tooltip:tt_chbtn_Compos

checkButton chbtn_RGlossinessState "" pos:[xp3[1],(yp3+2)+BS2*5] width:14 height:14 checked:(ATfn_.GetINI 0 iniFile "RGlossiness" "OnOffState" false) highlightColor:colCHBX
label lbl_RGlossinessState "RGlossiness" pos:[(xp3[1]+xb1),(yp3+2)+BS2*5]
dropdownlist ddl_RGlossinessSearchName items:(ATfn_.GetINI 0 iniFile "RGlossiness" "SavedSearchNames" #("")) pos:[xp3[2],(yp3+ddlOf)+BS2*5] width:20 height:33 selection:0 enabled:(ATfn_.GetINI 0 iniFile "RGlossiness" "OnOffState" false) tooltip:tt_ddl_Fild
edittext edt_RGlossinessSearchName "" text:(ATfn_.GetINI 1 iniFile "RGlossiness" "DefaultSearchName" "") pos:[xp3[3],(yp3+edtOf)+BS2*5] width:w[2] height:17 enabled:(ATfn_.GetINI 0 iniFile "RGlossiness" "OnOffState" false)
checkButton chbtn_RGlossinessStatus "S" pos:[xp3[4],yp3+BS2*5] width:w[1] height:18 checked:(ATfn_.GetINI 0 iniFile "RGlossiness" "OnOffState" false) highlightColor:colZ enabled:((ATfn_.GetINI 0 iniFile "RGlossiness" "OnOffState" false) and (not OMS)) tooltip:tt_chbtn_Search
dropdownlist ddl_RGlossinessTexture items:#() pos:[xp3[5],(yp3+ddlOf)+BS2*5] width:w[3] height:20 selection:0 enabled:false tooltip:tt_ddl_Texture
button btn_RGlossinessBrowse "..." pos:[xp3[6],yp3+BS2*5] width:w[1] height:18 enabled:((ATfn_.GetINI 0 iniFile "RGlossiness" "OnOffState" false) and (not OMS)) tooltip:tt_btn_Browse
dropdownlist ddl_RGlossinessLoader items:loaderItems pos:[xp3[7],(yp3+ddlOf)+BS2*5] width:w[4] height:33 selection:(ATfn_.GetINI 0 iniFile "RGlossiness" "DefaultLoader" 1) enabled:(ATfn_.GetINI 0 iniFile "RGlossiness" "OnOffState" false) tooltip:tt_ddl_Loader
checkButton chbtn_RGlossinessOCIO "O" pos:[xp3[18],yp3+BS2*5] width:w[1] height:18 checked:(if (ATfn_.GetINI 0 iniFile "RGlossiness" "OnOffState" false) then (ATfn_.GetINI 0 iniFile "RGlossiness" "OCIOState" false) else (false)) highlightColor:colCHBX enabled:(ATfn_.GetINI 0 iniFile "RGlossiness" "OnOffState" false) tooltip:tt_chbtn_OCIO
colorpicker color_RGlossinessCoColor "" pos:[xp3[8],yp3+BS2*5] width:w[5] height:18 color:(ATfn_.GetINI 0 iniFile "RGlossiness" "CorrectionVRayColor" [128,128,128]) enabled:(ATfn_.GetINI 0 iniFile "RGlossiness" "OnOffState" false) modal:false tooltip:tt_color_CoColor
spinner spnr_RGlossinessTilingU "" pos:[xp3[9],(yp3+edtOf)+BS2*5] width:w[6] range:[-999,999,(ATfn_.GetINI 0 iniFile "RGlossiness" "UTiling" 1.0)] type:#float scale:0.1 enabled:(ATfn_.GetINI 0 iniFile "RGlossiness" "OnOffState" false) tooltip:tt_spnr_TilingU
spinner spnr_RGlossinessTilingV "" pos:[xp3[10],(yp3+edtOf)+BS2*5] width:w[6] range:[-999,999,(ATfn_.GetINI 0 iniFile "RGlossiness" "VTiling" 1.0)] type:#float scale:0.1 enabled:(ATfn_.GetINI 0 iniFile "RGlossiness" "OnOffState" false) tooltip:tt_spnr_TilingV
dropdownlist ddl_RGlossinessHDRIColSp items:HDRIColSpTypes pos:[xp3[11],(yp3+ddlOf)+BS2*5] width:w[7] height:33 selection:(ATfn_.GetINI 0 iniFile "RGlossiness" "HDRIColorSpace" 2) enabled:(ATfn_.GetINI 0 iniFile "RGlossiness" "OnOffState" false) tooltip:tt_ddl_HDRIColSp
checkButton chbtn_RGlossinessColCor "CC" pos:[xp3[12],yp3+BS2*5] width:w[8] height:18 checked:(if (ATfn_.GetINI 0 iniFile "RGlossiness" "OnOffState" false) then (ATfn_.GetINI 0 iniFile "RGlossiness" "ColorCorrectState" false) else (false)) highlightColor:colCHBX enabled:(ATfn_.GetINI 0 iniFile "RGlossiness" "OnOffState" false) tooltip:tt_chbtn_ColCor
spinner spnr_RGlossinessCCGammaContrast "" pos:[xp3[13],(yp3+edtOf)+BS2*5] width:w[9] range:[0,99,(ATfn_.GetINI 0 iniFile "RGlossiness" "ColCorGammaContrast" 1.0)] type:#float scale:0.001 enabled:(ATfn_.GetINI 0 iniFile "RGlossiness" "OnOffState" false) tooltip:tt_spnr_CCGammaContrast
spinner spnr_RGlossinessCCRGB "" pos:[xp3[14],(yp3+edtOf)+BS2*5] width:w[10] range:[0,999,(ATfn_.GetINI 0 iniFile "RGlossiness" "ColCorRGB" 100)] type:#float scale:0.1 enabled:(ATfn_.GetINI 0 iniFile "RGlossiness" "OnOffState" false) tooltip:tt_spnr_CCRGB
button btn_RGlossinessMapType "" pos:[xp3[15],yp3+BS2*5] width:w[11] height:18 enabled:false tooltip:tt_btn_MapType
button btn_RGlossinessMapSize "" pos:[xp3[16],yp3+BS2*5] width:w[12] height:18 enabled:false tooltip:tt_btn_MapSize
checkButton chbtn_RGlossinessCompos "C" pos:[xp3[17],yp3+BS2*5] width:w[1] height:18 checked:(if (ATfn_.GetINI 0 iniFile "RGlossiness" "OnOffState" false) then (ATfn_.GetINI 0 iniFile "RGlossiness" "CompositeState" false) else (false)) highlightColor:colCHBX enabled:(ATfn_.GetINI 0 iniFile "RGlossiness" "OnOffState" false) tooltip:tt_chbtn_Compos

checkButton chbtn_FresnelIORState "" pos:[xp3[1],(yp3+2)+BS2*6] width:14 height:14 checked:(ATfn_.GetINI 0 iniFile "FresnelIOR" "OnOffState" false) highlightColor:colCHBX
label lbl_FresnelIORState "FresnelIOR" pos:[(xp3[1]+xb1),(yp3+2)+BS2*6]
dropdownlist ddl_FresnelIORSearchName items:(ATfn_.GetINI 0 iniFile "FresnelIOR" "SavedSearchNames" #("")) pos:[xp3[2],(yp3+ddlOf)+BS2*6] width:20 height:33 selection:0 enabled:(ATfn_.GetINI 0 iniFile "FresnelIOR" "OnOffState" false) tooltip:tt_ddl_Fild
edittext edt_FresnelIORSearchName "" text:(ATfn_.GetINI 1 iniFile "FresnelIOR" "DefaultSearchName" "") pos:[xp3[3],(yp3+edtOf)+BS2*6] width:w[2] height:17 enabled:(ATfn_.GetINI 0 iniFile "FresnelIOR" "OnOffState" false)
checkButton chbtn_FresnelIORStatus "S" pos:[xp3[4],yp3+BS2*6] width:w[1] height:18 checked:(ATfn_.GetINI 0 iniFile "FresnelIOR" "OnOffState" false) highlightColor:colZ enabled:((ATfn_.GetINI 0 iniFile "FresnelIOR" "OnOffState" false) and (not OMS)) tooltip:tt_chbtn_Search
dropdownlist ddl_FresnelIORTexture items:#() pos:[xp3[5],(yp3+ddlOf)+BS2*6] width:w[3] height:20 selection:0 enabled:false tooltip:tt_ddl_Texture
button btn_FresnelIORBrowse "..." pos:[xp3[6],yp3+BS2*6] width:w[1] height:18 enabled:((ATfn_.GetINI 0 iniFile "FresnelIOR" "OnOffState" false) and (not OMS)) tooltip:tt_btn_Browse
dropdownlist ddl_FresnelIORLoader items:loaderItems pos:[xp3[7],(yp3+ddlOf)+BS2*6] width:w[4] height:33 selection:(ATfn_.GetINI 0 iniFile "FresnelIOR" "DefaultLoader" 1) enabled:(ATfn_.GetINI 0 iniFile "FresnelIOR" "OnOffState" false) tooltip:tt_ddl_Loader
checkButton chbtn_FresnelIOROCIO "O" pos:[xp3[18],yp3+BS2*6] width:w[1] height:18 checked:(if (ATfn_.GetINI 0 iniFile "FresnelIOR" "OnOffState" false) then (ATfn_.GetINI 0 iniFile "FresnelIOR" "OCIOState" false) else (false)) highlightColor:colCHBX enabled:(ATfn_.GetINI 0 iniFile "FresnelIOR" "OnOffState" false) tooltip:tt_chbtn_OCIO
colorpicker color_FresnelIORCoColor "" pos:[xp3[8],yp3+BS2*6] width:w[5] height:18 color:(ATfn_.GetINI 0 iniFile "FresnelIOR" "CorrectionVRayColor" [128,128,128]) enabled:(ATfn_.GetINI 0 iniFile "FresnelIOR" "OnOffState" false) modal:false tooltip:tt_color_CoColor
spinner spnr_FresnelIORTilingU "" pos:[xp3[9],(yp3+edtOf)+BS2*6] width:w[6] range:[-999,999,(ATfn_.GetINI 0 iniFile "FresnelIOR" "UTiling" 1.0)] type:#float scale:0.1 enabled:(ATfn_.GetINI 0 iniFile "FresnelIOR" "OnOffState" false) tooltip:tt_spnr_TilingU
spinner spnr_FresnelIORTilingV "" pos:[xp3[10],(yp3+edtOf)+BS2*6] width:w[6] range:[-999,999,(ATfn_.GetINI 0 iniFile "FresnelIOR" "VTiling" 1.0)] type:#float scale:0.1 enabled:(ATfn_.GetINI 0 iniFile "FresnelIOR" "OnOffState" false) tooltip:tt_spnr_TilingV
dropdownlist ddl_FresnelIORHDRIColSp items:HDRIColSpTypes pos:[xp3[11],(yp3+ddlOf)+BS2*6] width:w[7] height:33 selection:(ATfn_.GetINI 0 iniFile "FresnelIOR" "HDRIColorSpace" 2) enabled:(ATfn_.GetINI 0 iniFile "FresnelIOR" "OnOffState" false) tooltip:tt_ddl_HDRIColSp
checkButton chbtn_FresnelIORColCor "CC" pos:[xp3[12],yp3+BS2*6] width:w[8] height:18 checked:(if (ATfn_.GetINI 0 iniFile "FresnelIOR" "OnOffState" false) then (ATfn_.GetINI 0 iniFile "FresnelIOR" "ColorCorrectState" false) else (false)) highlightColor:colCHBX enabled:(ATfn_.GetINI 0 iniFile "FresnelIOR" "OnOffState" false) tooltip:tt_chbtn_ColCor
spinner spnr_FresnelIORCCGammaContrast "" pos:[xp3[13],(yp3+edtOf)+BS2*6] width:w[9] range:[0,99,(ATfn_.GetINI 0 iniFile "FresnelIOR" "ColCorGammaContrast" 1.0)] type:#float scale:0.001 enabled:(ATfn_.GetINI 0 iniFile "FresnelIOR" "OnOffState" false) tooltip:tt_spnr_CCGammaContrast
spinner spnr_FresnelIORCCRGB "" pos:[xp3[14],(yp3+edtOf)+BS2*6] width:w[10] range:[0,999,(ATfn_.GetINI 0 iniFile "FresnelIOR" "ColCorRGB" 100)] type:#float scale:0.1 enabled:(ATfn_.GetINI 0 iniFile "FresnelIOR" "OnOffState" false) tooltip:tt_spnr_CCRGB
button btn_FresnelIORMapType "" pos:[xp3[15],yp3+BS2*6] width:w[11] height:18 enabled:false tooltip:tt_btn_MapType
button btn_FresnelIORMapSize "" pos:[xp3[16],yp3+BS2*6] width:w[12] height:18 enabled:false tooltip:tt_btn_MapSize
checkButton chbtn_FresnelIORCompos "C" pos:[xp3[17],yp3+BS2*6] width:w[1] height:18 checked:(if (ATfn_.GetINI 0 iniFile "FresnelIOR" "OnOffState" false) then (ATfn_.GetINI 0 iniFile "FresnelIOR" "CompositeState" false) else (false)) highlightColor:colCHBX enabled:(ATfn_.GetINI 0 iniFile "FresnelIOR" "OnOffState" false) tooltip:tt_chbtn_Compos

checkButton chbtn_MetalnessState "" pos:[xp3[1],(yp3+2)+BS2*7] width:14 height:14 checked:(ATfn_.GetINI 0 iniFile "Metalness" "OnOffState" false) highlightColor:colCHBX
label lbl_MetalnessState "Metalness" pos:[(xp3[1]+xb1),(yp3+2)+BS2*7]
dropdownlist ddl_MetalnessSearchName items:(ATfn_.GetINI 0 iniFile "Metalness" "SavedSearchNames" #("")) pos:[xp3[2],(yp3+ddlOf)+BS2*7] width:20 height:33 selection:0 enabled:(ATfn_.GetINI 0 iniFile "Metalness" "OnOffState" false) tooltip:tt_ddl_Fild
edittext edt_MetalnessSearchName "" text:(ATfn_.GetINI 1 iniFile "Metalness" "DefaultSearchName" "") pos:[xp3[3],(yp3+edtOf)+BS2*7] width:w[2] height:17 enabled:(ATfn_.GetINI 0 iniFile "Metalness" "OnOffState" false)
checkButton chbtn_MetalnessStatus "S" pos:[xp3[4],yp3+BS2*7] width:w[1] height:18 checked:(ATfn_.GetINI 0 iniFile "Metalness" "OnOffState" false) highlightColor:colZ enabled:((ATfn_.GetINI 0 iniFile "Metalness" "OnOffState" false) and (not OMS)) tooltip:tt_chbtn_Search
dropdownlist ddl_MetalnessTexture items:#() pos:[xp3[5],(yp3+ddlOf)+BS2*7] width:w[3] height:20 selection:0 enabled:false tooltip:tt_ddl_Texture
button btn_MetalnessBrowse "..." pos:[xp3[6],yp3+BS2*7] width:w[1] height:18 enabled:((ATfn_.GetINI 0 iniFile "Metalness" "OnOffState" false) and (not OMS)) tooltip:tt_btn_Browse
dropdownlist ddl_MetalnessLoader items:loaderItems pos:[xp3[7],(yp3+ddlOf)+BS2*7] width:w[4] height:33 selection:(ATfn_.GetINI 0 iniFile "Metalness" "DefaultLoader" 1) enabled:(ATfn_.GetINI 0 iniFile "Metalness" "OnOffState" false) tooltip:tt_ddl_Loader
checkButton chbtn_MetalnessOCIO "O" pos:[xp3[18],yp3+BS2*7] width:w[1] height:18 checked:(if (ATfn_.GetINI 0 iniFile "Metalness" "OnOffState" false) then (ATfn_.GetINI 0 iniFile "Metalness" "OCIOState" false) else (false)) highlightColor:colCHBX enabled:(ATfn_.GetINI 0 iniFile "Metalness" "OnOffState" false) tooltip:tt_chbtn_OCIO
colorpicker color_MetalnessCoColor "" pos:[xp3[8],yp3+BS2*7] width:w[5] height:18 color:(ATfn_.GetINI 0 iniFile "Metalness" "CorrectionVRayColor" [128,128,128]) enabled:(ATfn_.GetINI 0 iniFile "Metalness" "OnOffState" false) modal:false tooltip:tt_color_CoColor
spinner spnr_MetalnessTilingU "" pos:[xp3[9],(yp3+edtOf)+BS2*7] width:w[6] range:[-999,999,(ATfn_.GetINI 0 iniFile "Metalness" "UTiling" 1.0)] type:#float scale:0.1 enabled:(ATfn_.GetINI 0 iniFile "Metalness" "OnOffState" false) tooltip:tt_spnr_TilingU
spinner spnr_MetalnessTilingV "" pos:[xp3[10],(yp3+edtOf)+BS2*7] width:w[6] range:[-999,999,(ATfn_.GetINI 0 iniFile "Metalness" "VTiling" 1.0)] type:#float scale:0.1 enabled:(ATfn_.GetINI 0 iniFile "Metalness" "OnOffState" false) tooltip:tt_spnr_TilingV
dropdownlist ddl_MetalnessHDRIColSp items:HDRIColSpTypes pos:[xp3[11],(yp3+ddlOf)+BS2*7] width:w[7] height:33 selection:(ATfn_.GetINI 0 iniFile "Metalness" "HDRIColorSpace" 2) enabled:(ATfn_.GetINI 0 iniFile "Metalness" "OnOffState" false) tooltip:tt_ddl_HDRIColSp
checkButton chbtn_MetalnessColCor "CC" pos:[xp3[12],yp3+BS2*7] width:w[8] height:18 checked:(if (ATfn_.GetINI 0 iniFile "Metalness" "OnOffState" false) then (ATfn_.GetINI 0 iniFile "Metalness" "ColorCorrectState" false) else (false)) highlightColor:colCHBX enabled:(ATfn_.GetINI 0 iniFile "Metalness" "OnOffState" false) tooltip:tt_chbtn_ColCor
spinner spnr_MetalnessCCGammaContrast "" pos:[xp3[13],(yp3+edtOf)+BS2*7] width:w[9] range:[0,99,(ATfn_.GetINI 0 iniFile "Metalness" "ColCorGammaContrast" 1.0)] type:#float scale:0.001 enabled:(ATfn_.GetINI 0 iniFile "Metalness" "OnOffState" false) tooltip:tt_spnr_CCGammaContrast
spinner spnr_MetalnessCCRGB "" pos:[xp3[14],(yp3+edtOf)+BS2*7] width:w[10] range:[0,999,(ATfn_.GetINI 0 iniFile "Metalness" "ColCorRGB" 100)] type:#float scale:0.1 enabled:(ATfn_.GetINI 0 iniFile "Metalness" "OnOffState" false) tooltip:tt_spnr_CCRGB
button btn_MetalnessMapType "" pos:[xp3[15],yp3+BS2*7] width:w[11] height:18 enabled:false tooltip:tt_btn_MapType
button btn_MetalnessMapSize "" pos:[xp3[16],yp3+BS2*7] width:w[12] height:18 enabled:false tooltip:tt_btn_MapSize
checkButton chbtn_MetalnessCompos "C" pos:[xp3[17],yp3+BS2*7] width:w[1] height:18 checked:(if (ATfn_.GetINI 0 iniFile "Metalness" "OnOffState" false) then (ATfn_.GetINI 0 iniFile "Metalness" "CompositeState" false) else (false)) highlightColor:colCHBX enabled:(ATfn_.GetINI 0 iniFile "Metalness" "OnOffState" false) tooltip:tt_chbtn_Compos

checkButton chbtn_AnisotropyState "" pos:[xp3[1],(yp3+2)+BS2*8] width:14 height:14 checked:(ATfn_.GetINI 0 iniFile "Anisotropy" "OnOffState" false) highlightColor:colCHBX
label lbl_AnisotropyState "Anisotropy" pos:[(xp3[1]+xb1),(yp3+2)+BS2*8]
dropdownlist ddl_AnisotropySearchName items:(ATfn_.GetINI 0 iniFile "Anisotropy" "SavedSearchNames" #("")) pos:[xp3[2],(yp3+ddlOf)+BS2*8] width:20 height:33 selection:0 enabled:(ATfn_.GetINI 0 iniFile "Anisotropy" "OnOffState" false) tooltip:tt_ddl_Fild
edittext edt_AnisotropySearchName "" text:(ATfn_.GetINI 1 iniFile "Anisotropy" "DefaultSearchName" "") pos:[xp3[3],(yp3+edtOf)+BS2*8] width:w[2] height:17 enabled:(ATfn_.GetINI 0 iniFile "Anisotropy" "OnOffState" false)
checkButton chbtn_AnisotropyStatus "S" pos:[xp3[4],yp3+BS2*8] width:w[1] height:18 checked:(ATfn_.GetINI 0 iniFile "Anisotropy" "OnOffState" false) highlightColor:colZ enabled:((ATfn_.GetINI 0 iniFile "Anisotropy" "OnOffState" false) and (not OMS)) tooltip:tt_chbtn_Search
dropdownlist ddl_AnisotropyTexture items:#() pos:[xp3[5],(yp3+ddlOf)+BS2*8] width:w[3] height:20 selection:0 enabled:false tooltip:tt_ddl_Texture
button btn_AnisotropyBrowse "..." pos:[xp3[6],yp3+BS2*8] width:w[1] height:18 enabled:((ATfn_.GetINI 0 iniFile "Anisotropy" "OnOffState" false) and (not OMS)) tooltip:tt_btn_Browse
dropdownlist ddl_AnisotropyLoader items:loaderItems pos:[xp3[7],(yp3+ddlOf)+BS2*8] width:w[4] height:33 selection:(ATfn_.GetINI 0 iniFile "Anisotropy" "DefaultLoader" 1) enabled:(ATfn_.GetINI 0 iniFile "Anisotropy" "OnOffState" false) tooltip:tt_ddl_Loader
checkButton chbtn_AnisotropyOCIO "O" pos:[xp3[18],yp3+BS2*8] width:w[1] height:18 checked:(if (ATfn_.GetINI 0 iniFile "Anisotropy" "OnOffState" false) then (ATfn_.GetINI 0 iniFile "Anisotropy" "OCIOState" false) else (false)) highlightColor:colCHBX enabled:(ATfn_.GetINI 0 iniFile "Anisotropy" "OnOffState" false) tooltip:tt_chbtn_OCIO
colorpicker color_AnisotropyCoColor "" pos:[xp3[8],yp3+BS2*8] width:w[5] height:18 color:(ATfn_.GetINI 0 iniFile "Anisotropy" "CorrectionVRayColor" [128,128,128]) enabled:(ATfn_.GetINI 0 iniFile "Anisotropy" "OnOffState" false) modal:false tooltip:tt_color_CoColor
spinner spnr_AnisotropyTilingU "" pos:[xp3[9],(yp3+edtOf)+BS2*8] width:w[6] range:[-999,999,(ATfn_.GetINI 0 iniFile "Anisotropy" "UTiling" 1.0)] type:#float scale:0.1 enabled:(ATfn_.GetINI 0 iniFile "Anisotropy" "OnOffState" false) tooltip:tt_spnr_TilingU
spinner spnr_AnisotropyTilingV "" pos:[xp3[10],(yp3+edtOf)+BS2*8] width:w[6] range:[-999,999,(ATfn_.GetINI 0 iniFile "Anisotropy" "VTiling" 1.0)] type:#float scale:0.1 enabled:(ATfn_.GetINI 0 iniFile "Anisotropy" "OnOffState" false) tooltip:tt_spnr_TilingV
dropdownlist ddl_AnisotropyHDRIColSp items:HDRIColSpTypes pos:[xp3[11],(yp3+ddlOf)+BS2*8] width:w[7] height:33 selection:(ATfn_.GetINI 0 iniFile "Anisotropy" "HDRIColorSpace" 2) enabled:(ATfn_.GetINI 0 iniFile "Anisotropy" "OnOffState" false) tooltip:tt_ddl_HDRIColSp
checkButton chbtn_AnisotropyColCor "CC" pos:[xp3[12],yp3+BS2*8] width:w[8] height:18 checked:(if (ATfn_.GetINI 0 iniFile "Anisotropy" "OnOffState" false) then (ATfn_.GetINI 0 iniFile "Anisotropy" "ColorCorrectState" false) else (false)) highlightColor:colCHBX enabled:(ATfn_.GetINI 0 iniFile "Anisotropy" "OnOffState" false) tooltip:tt_chbtn_ColCor
spinner spnr_AnisotropyCCGammaContrast "" pos:[xp3[13],(yp3+edtOf)+BS2*8] width:w[9] range:[0,99,(ATfn_.GetINI 0 iniFile "Anisotropy" "ColCorGammaContrast" 1.0)] type:#float scale:0.001 enabled:(ATfn_.GetINI 0 iniFile "Anisotropy" "OnOffState" false) tooltip:tt_spnr_CCGammaContrast
spinner spnr_AnisotropyCCRGB "" pos:[xp3[14],(yp3+edtOf)+BS2*8] width:w[10] range:[0,999,(ATfn_.GetINI 0 iniFile "Anisotropy" "ColCorRGB" 100)] type:#float scale:0.1 enabled:(ATfn_.GetINI 0 iniFile "Anisotropy" "OnOffState" false) tooltip:tt_spnr_CCRGB
button btn_AnisotropyMapType "" pos:[xp3[15],yp3+BS2*8] width:w[11] height:18 enabled:false tooltip:tt_btn_MapType
button btn_AnisotropyMapSize "" pos:[xp3[16],yp3+BS2*8] width:w[12] height:18 enabled:false tooltip:tt_btn_MapSize
checkButton chbtn_AnisotropyCompos "C" pos:[xp3[17],yp3+BS2*8] width:w[1] height:18 checked:(if (ATfn_.GetINI 0 iniFile "Anisotropy" "OnOffState" false) then (ATfn_.GetINI 0 iniFile "Anisotropy" "CompositeState" false) else (false)) highlightColor:colCHBX enabled:(ATfn_.GetINI 0 iniFile "Anisotropy" "OnOffState" false) tooltip:tt_chbtn_Compos

checkButton chbtn_AnRotationState "" pos:[xp3[1],(yp3+2)+BS2*9] width:14 height:14 checked:(ATfn_.GetINI 0 iniFile "AnRotation" "OnOffState" false) highlightColor:colCHBX
label lbl_AnRotationState "AnRotation" pos:[(xp3[1]+xb1),(yp3+2)+BS2*9]
dropdownlist ddl_AnRotationSearchName items:(ATfn_.GetINI 0 iniFile "AnRotation" "SavedSearchNames" #("")) pos:[xp3[2],(yp3+ddlOf)+BS2*9] width:20 height:33 selection:0 enabled:(ATfn_.GetINI 0 iniFile "AnRotation" "OnOffState" false) tooltip:tt_ddl_Fild
edittext edt_AnRotationSearchName "" text:(ATfn_.GetINI 1 iniFile "AnRotation" "DefaultSearchName" "") pos:[xp3[3],(yp3+edtOf)+BS2*9] width:w[2] height:17 enabled:(ATfn_.GetINI 0 iniFile "AnRotation" "OnOffState" false)
checkButton chbtn_AnRotationStatus "S" pos:[xp3[4],yp3+BS2*9] width:w[1] height:18 checked:(ATfn_.GetINI 0 iniFile "AnRotation" "OnOffState" false) highlightColor:colZ enabled:((ATfn_.GetINI 0 iniFile "AnRotation" "OnOffState" false) and (not OMS)) tooltip:tt_chbtn_Search
dropdownlist ddl_AnRotationTexture items:#() pos:[xp3[5],(yp3+ddlOf)+BS2*9] width:w[3] height:20 selection:0 enabled:false tooltip:tt_ddl_Texture
button btn_AnRotationBrowse "..." pos:[xp3[6],yp3+BS2*9] width:w[1] height:18 enabled:((ATfn_.GetINI 0 iniFile "AnRotation" "OnOffState" false) and (not OMS)) tooltip:tt_btn_Browse
dropdownlist ddl_AnRotationLoader items:loaderItems pos:[xp3[7],(yp3+ddlOf)+BS2*9] width:w[4] height:33 selection:(ATfn_.GetINI 0 iniFile "AnRotation" "DefaultLoader" 1) enabled:(ATfn_.GetINI 0 iniFile "AnRotation" "OnOffState" false) tooltip:tt_ddl_Loader
checkButton chbtn_AnRotationOCIO "O" pos:[xp3[18],yp3+BS2*9] width:w[1] height:18 checked:(if (ATfn_.GetINI 0 iniFile "AnRotation" "OnOffState" false) then (ATfn_.GetINI 0 iniFile "AnRotation" "OCIOState" false) else (false)) highlightColor:colCHBX enabled:(ATfn_.GetINI 0 iniFile "AnRotation" "OnOffState" false) tooltip:tt_chbtn_OCIO
colorpicker color_AnRotationCoColor "" pos:[xp3[8],yp3+BS2*9] width:w[5] height:18 color:(ATfn_.GetINI 0 iniFile "AnRotation" "CorrectionVRayColor" [128,128,128]) enabled:(ATfn_.GetINI 0 iniFile "AnRotation" "OnOffState" false) modal:false tooltip:tt_color_CoColor
spinner spnr_AnRotationTilingU "" pos:[xp3[9],(yp3+edtOf)+BS2*9] width:w[6] range:[-999,999,(ATfn_.GetINI 0 iniFile "AnRotation" "UTiling" 1.0)] type:#float scale:0.1 enabled:(ATfn_.GetINI 0 iniFile "AnRotation" "OnOffState" false) tooltip:tt_spnr_TilingU
spinner spnr_AnRotationTilingV "" pos:[xp3[10],(yp3+edtOf)+BS2*9] width:w[6] range:[-999,999,(ATfn_.GetINI 0 iniFile "AnRotation" "VTiling" 1.0)] type:#float scale:0.1 enabled:(ATfn_.GetINI 0 iniFile "AnRotation" "OnOffState" false) tooltip:tt_spnr_TilingV
dropdownlist ddl_AnRotationHDRIColSp items:HDRIColSpTypes pos:[xp3[11],(yp3+ddlOf)+BS2*9] width:w[7] height:33 selection:(ATfn_.GetINI 0 iniFile "AnRotation" "HDRIColorSpace" 2) enabled:(ATfn_.GetINI 0 iniFile "AnRotation" "OnOffState" false) tooltip:tt_ddl_HDRIColSp
checkButton chbtn_AnRotationColCor "CC" pos:[xp3[12],yp3+BS2*9] width:w[8] height:18 checked:(if (ATfn_.GetINI 0 iniFile "AnRotation" "OnOffState" false) then (ATfn_.GetINI 0 iniFile "AnRotation" "ColorCorrectState" false) else (false)) highlightColor:colCHBX enabled:(ATfn_.GetINI 0 iniFile "AnRotation" "OnOffState" false) tooltip:tt_chbtn_ColCor
spinner spnr_AnRotationCCGammaContrast "" pos:[xp3[13],(yp3+edtOf)+BS2*9] width:w[9] range:[0,99,(ATfn_.GetINI 0 iniFile "AnRotation" "ColCorGammaContrast" 1.0)] type:#float scale:0.001 enabled:(ATfn_.GetINI 0 iniFile "AnRotation" "OnOffState" false) tooltip:tt_spnr_CCGammaContrast
spinner spnr_AnRotationCCRGB "" pos:[xp3[14],(yp3+edtOf)+BS2*9] width:w[10] range:[0,999,(ATfn_.GetINI 0 iniFile "AnRotation" "ColCorRGB" 100)] type:#float scale:0.1 enabled:(ATfn_.GetINI 0 iniFile "AnRotation" "OnOffState" false) tooltip:tt_spnr_CCRGB
button btn_AnRotationMapType "" pos:[xp3[15],yp3+BS2*9] width:w[11] height:18 enabled:false tooltip:tt_btn_MapType
button btn_AnRotationMapSize "" pos:[xp3[16],yp3+BS2*9] width:w[12] height:18 enabled:false tooltip:tt_btn_MapSize
checkButton chbtn_AnRotationCompos "C" pos:[xp3[17],yp3+BS2*9] width:w[1] height:18 checked:(if (ATfn_.GetINI 0 iniFile "AnRotation" "OnOffState" false) then (ATfn_.GetINI 0 iniFile "AnRotation" "CompositeState" false) else (false)) highlightColor:colCHBX enabled:(ATfn_.GetINI 0 iniFile "AnRotation" "OnOffState" false) tooltip:tt_chbtn_Compos

checkButton chbtn_RefractState "" pos:[xp3[1],(yp3+2)+BS2*10] width:14 height:14 checked:(ATfn_.GetINI 0 iniFile "Refract" "OnOffState" false) highlightColor:colCHBX
label lbl_RefractState "Refract" pos:[(xp3[1]+xb1),(yp3+2)+BS2*10]
dropdownlist ddl_RefractSearchName items:(ATfn_.GetINI 0 iniFile "Refract" "SavedSearchNames" #("")) pos:[xp3[2],(yp3+ddlOf)+BS2*10] width:20 height:33 selection:0 enabled:(ATfn_.GetINI 0 iniFile "Refract" "OnOffState" false) tooltip:tt_ddl_Fild
edittext edt_RefractSearchName "" text:(ATfn_.GetINI 1 iniFile "Refract" "DefaultSearchName" "") pos:[xp3[3],(yp3+edtOf)+BS2*10] width:w[2] height:17 enabled:(ATfn_.GetINI 0 iniFile "Refract" "OnOffState" false)
checkButton chbtn_RefractStatus "S" pos:[xp3[4],yp3+BS2*10] width:w[1] height:18 checked:(ATfn_.GetINI 0 iniFile "Refract" "OnOffState" false) highlightColor:colZ enabled:((ATfn_.GetINI 0 iniFile "Refract" "OnOffState" false) and (not OMS)) tooltip:tt_chbtn_Search
dropdownlist ddl_RefractTexture items:#() pos:[xp3[5],(yp3+ddlOf)+BS2*10] width:w[3] height:20 selection:0 enabled:false tooltip:tt_ddl_Texture
button btn_RefractBrowse "..." pos:[xp3[6],yp3+BS2*10] width:w[1] height:18 enabled:((ATfn_.GetINI 0 iniFile "Refract" "OnOffState" false) and (not OMS)) tooltip:tt_btn_Browse
dropdownlist ddl_RefractLoader items:loaderItems pos:[xp3[7],(yp3+ddlOf)+BS2*10] width:w[4] height:33 selection:(ATfn_.GetINI 0 iniFile "Refract" "DefaultLoader" 1) enabled:(ATfn_.GetINI 0 iniFile "Refract" "OnOffState" false) tooltip:tt_ddl_Loader
checkButton chbtn_RefractOCIO "O" pos:[xp3[18],yp3+BS2*10] width:w[1] height:18 checked:(if (ATfn_.GetINI 0 iniFile "Refract" "OnOffState" false) then (ATfn_.GetINI 0 iniFile "Refract" "OCIOState" false) else (false)) highlightColor:colCHBX enabled:(ATfn_.GetINI 0 iniFile "Refract" "OnOffState" false) tooltip:tt_chbtn_OCIO
colorpicker color_RefractCoColor "" pos:[xp3[8],yp3+BS2*10] width:w[5] height:18 color:(ATfn_.GetINI 0 iniFile "Refract" "CorrectionVRayColor" [128,128,128]) enabled:(ATfn_.GetINI 0 iniFile "Refract" "OnOffState" false) modal:false tooltip:tt_color_CoColor
spinner spnr_RefractTilingU "" pos:[xp3[9],(yp3+edtOf)+BS2*10] width:w[6] range:[-999,999,(ATfn_.GetINI 0 iniFile "Refract" "UTiling" 1.0)] type:#float scale:0.1 enabled:(ATfn_.GetINI 0 iniFile "Refract" "OnOffState" false) tooltip:tt_spnr_TilingU
spinner spnr_RefractTilingV "" pos:[xp3[10],(yp3+edtOf)+BS2*10] width:w[6] range:[-999,999,(ATfn_.GetINI 0 iniFile "Refract" "VTiling" 1.0)] type:#float scale:0.1 enabled:(ATfn_.GetINI 0 iniFile "Refract" "OnOffState" false) tooltip:tt_spnr_TilingV
dropdownlist ddl_RefractHDRIColSp items:HDRIColSpTypes pos:[xp3[11],(yp3+ddlOf)+BS2*10] width:w[7] height:33 selection:(ATfn_.GetINI 0 iniFile "Refract" "HDRIColorSpace" 2) enabled:(ATfn_.GetINI 0 iniFile "Refract" "OnOffState" false) tooltip:tt_ddl_HDRIColSp
checkButton chbtn_RefractColCor "CC" pos:[xp3[12],yp3+BS2*10] width:w[8] height:18 checked:(if (ATfn_.GetINI 0 iniFile "Refract" "OnOffState" false) then (ATfn_.GetINI 0 iniFile "Refract" "ColorCorrectState" false) else (false)) highlightColor:colCHBX enabled:(ATfn_.GetINI 0 iniFile "Refract" "OnOffState" false) tooltip:tt_chbtn_ColCor
spinner spnr_RefractCCGammaContrast "" pos:[xp3[13],(yp3+edtOf)+BS2*10] width:w[9] range:[0,99,(ATfn_.GetINI 0 iniFile "Refract" "ColCorGammaContrast" 1.0)] type:#float scale:0.001 enabled:(ATfn_.GetINI 0 iniFile "Refract" "OnOffState" false) tooltip:tt_spnr_CCGammaContrast
spinner spnr_RefractCCRGB "" pos:[xp3[14],(yp3+edtOf)+BS2*10] width:w[10] range:[0,999,(ATfn_.GetINI 0 iniFile "Refract" "ColCorRGB" 100)] type:#float scale:0.1 enabled:(ATfn_.GetINI 0 iniFile "Refract" "OnOffState" false) tooltip:tt_spnr_CCRGB
button btn_RefractMapType "" pos:[xp3[15],yp3+BS2*10] width:w[11] height:18 enabled:false tooltip:tt_btn_MapType
button btn_RefractMapSize "" pos:[xp3[16],yp3+BS2*10] width:w[12] height:18 enabled:false tooltip:tt_btn_MapSize
checkButton chbtn_RefractCompos "C" pos:[xp3[17],yp3+BS2*10] width:w[1] height:18 checked:(if (ATfn_.GetINI 0 iniFile "Refract" "OnOffState" false) then (ATfn_.GetINI 0 iniFile "Refract" "CompositeState" false) else (false)) highlightColor:colCHBX enabled:(ATfn_.GetINI 0 iniFile "Refract" "OnOffState" false) tooltip:tt_chbtn_Compos

checkButton chbtn_GlossinessState "" pos:[xp3[1],(yp3+2)+BS2*11] width:14 height:14 checked:(ATfn_.GetINI 0 iniFile "Glossiness" "OnOffState" false) highlightColor:colCHBX
label lbl_GlossinessState "Glossiness" pos:[(xp3[1]+xb1),(yp3+2)+BS2*11]
dropdownlist ddl_GlossinessSearchName items:(ATfn_.GetINI 0 iniFile "Glossiness" "SavedSearchNames" #("")) pos:[xp3[2],(yp3+ddlOf)+BS2*11] width:20 height:33 selection:0 enabled:(ATfn_.GetINI 0 iniFile "Glossiness" "OnOffState" false) tooltip:tt_ddl_Fild
edittext edt_GlossinessSearchName "" text:(ATfn_.GetINI 1 iniFile "Glossiness" "DefaultSearchName" "") pos:[xp3[3],(yp3+edtOf)+BS2*11] width:w[2] height:17 enabled:(ATfn_.GetINI 0 iniFile "Glossiness" "OnOffState" false)
checkButton chbtn_GlossinessStatus "S" pos:[xp3[4],yp3+BS2*11] width:w[1] height:18 checked:(ATfn_.GetINI 0 iniFile "Glossiness" "OnOffState" false) highlightColor:colZ enabled:((ATfn_.GetINI 0 iniFile "Glossiness" "OnOffState" false) and (not OMS)) tooltip:tt_chbtn_Search
dropdownlist ddl_GlossinessTexture items:#() pos:[xp3[5],(yp3+ddlOf)+BS2*11] width:w[3] height:20 selection:0 enabled:false tooltip:tt_ddl_Texture
button btn_GlossinessBrowse "..." pos:[xp3[6],yp3+BS2*11] width:w[1] height:18 enabled:((ATfn_.GetINI 0 iniFile "Glossiness" "OnOffState" false) and (not OMS)) tooltip:tt_btn_Browse
dropdownlist ddl_GlossinessLoader items:loaderItems pos:[xp3[7],(yp3+ddlOf)+BS2*11] width:w[4] height:33 selection:(ATfn_.GetINI 0 iniFile "Glossiness" "DefaultLoader" 1) enabled:(ATfn_.GetINI 0 iniFile "Glossiness" "OnOffState" false) tooltip:tt_ddl_Loader
checkButton chbtn_GlossinessOCIO "O" pos:[xp3[18],yp3+BS2*11] width:w[1] height:18 checked:(if (ATfn_.GetINI 0 iniFile "Glossiness" "OnOffState" false) then (ATfn_.GetINI 0 iniFile "Glossiness" "OCIOState" false) else (false)) highlightColor:colCHBX enabled:(ATfn_.GetINI 0 iniFile "Glossiness" "OnOffState" false) tooltip:tt_chbtn_OCIO
colorpicker color_GlossinessCoColor "" pos:[xp3[8],yp3+BS2*11] width:w[5] height:18 color:(ATfn_.GetINI 0 iniFile "Glossiness" "CorrectionVRayColor" [128,128,128]) enabled:(ATfn_.GetINI 0 iniFile "Glossiness" "OnOffState" false) modal:false tooltip:tt_color_CoColor
spinner spnr_GlossinessTilingU "" pos:[xp3[9],(yp3+edtOf)+BS2*11] width:w[6] range:[-999,999,(ATfn_.GetINI 0 iniFile "Glossiness" "UTiling" 1.0)] type:#float scale:0.1 enabled:(ATfn_.GetINI 0 iniFile "Glossiness" "OnOffState" false) tooltip:tt_spnr_TilingU
spinner spnr_GlossinessTilingV "" pos:[xp3[10],(yp3+edtOf)+BS2*11] width:w[6] range:[-999,999,(ATfn_.GetINI 0 iniFile "Glossiness" "VTiling" 1.0)] type:#float scale:0.1 enabled:(ATfn_.GetINI 0 iniFile "Glossiness" "OnOffState" false) tooltip:tt_spnr_TilingV
dropdownlist ddl_GlossinessHDRIColSp items:HDRIColSpTypes pos:[xp3[11],(yp3+ddlOf)+BS2*11] width:w[7] height:33 selection:(ATfn_.GetINI 0 iniFile "Glossiness" "HDRIColorSpace" 2) enabled:(ATfn_.GetINI 0 iniFile "Glossiness" "OnOffState" false) tooltip:tt_ddl_HDRIColSp
checkButton chbtn_GlossinessColCor "CC" pos:[xp3[12],yp3+BS2*11] width:w[8] height:18 checked:(if (ATfn_.GetINI 0 iniFile "Glossiness" "OnOffState" false) then (ATfn_.GetINI 0 iniFile "Glossiness" "ColorCorrectState" false) else (false)) highlightColor:colCHBX enabled:(ATfn_.GetINI 0 iniFile "Glossiness" "OnOffState" false) tooltip:tt_chbtn_ColCor
spinner spnr_GlossinessCCGammaContrast "" pos:[xp3[13],(yp3+edtOf)+BS2*11] width:w[9] range:[0,99,(ATfn_.GetINI 0 iniFile "Glossiness" "ColCorGammaContrast" 1.0)] type:#float scale:0.001 enabled:(ATfn_.GetINI 0 iniFile "Glossiness" "OnOffState" false) tooltip:tt_spnr_CCGammaContrast
spinner spnr_GlossinessCCRGB "" pos:[xp3[14],(yp3+edtOf)+BS2*11] width:w[10] range:[0,999,(ATfn_.GetINI 0 iniFile "Glossiness" "ColCorRGB" 100)] type:#float scale:0.1 enabled:(ATfn_.GetINI 0 iniFile "Glossiness" "OnOffState" false) tooltip:tt_spnr_CCRGB
button btn_GlossinessMapType "" pos:[xp3[15],yp3+BS2*11] width:w[11] height:18 enabled:false tooltip:tt_btn_MapType
button btn_GlossinessMapSize "" pos:[xp3[16],yp3+BS2*11] width:w[12] height:18 enabled:false tooltip:tt_btn_MapSize
checkButton chbtn_GlossinessCompos "C" pos:[xp3[17],yp3+BS2*11] width:w[1] height:18 checked:(if (ATfn_.GetINI 0 iniFile "Glossiness" "OnOffState" false) then (ATfn_.GetINI 0 iniFile "Glossiness" "CompositeState" false) else (false)) highlightColor:colCHBX enabled:(ATfn_.GetINI 0 iniFile "Glossiness" "OnOffState" false) tooltip:tt_chbtn_Compos

checkButton chbtn_IORState "" pos:[xp3[1],(yp3+2)+BS2*12] width:14 height:14 checked:(ATfn_.GetINI 0 iniFile "IOR" "OnOffState" false) highlightColor:colCHBX
label lbl_IORState "IOR" pos:[(xp3[1]+xb1),(yp3+2)+BS2*12]
dropdownlist ddl_IORSearchName items:(ATfn_.GetINI 0 iniFile "IOR" "SavedSearchNames" #("")) pos:[xp3[2],(yp3+ddlOf)+BS2*12] width:20 height:33 selection:0 enabled:(ATfn_.GetINI 0 iniFile "IOR" "OnOffState" false) tooltip:tt_ddl_Fild
edittext edt_IORSearchName "" text:(ATfn_.GetINI 1 iniFile "IOR" "DefaultSearchName" "") pos:[xp3[3],(yp3+edtOf)+BS2*12] width:w[2] height:17 enabled:(ATfn_.GetINI 0 iniFile "IOR" "OnOffState" false)
checkButton chbtn_IORStatus "S" pos:[xp3[4],yp3+BS2*12] width:w[1] height:18 checked:(ATfn_.GetINI 0 iniFile "IOR" "OnOffState" false) highlightColor:colZ enabled:((ATfn_.GetINI 0 iniFile "IOR" "OnOffState" false) and (not OMS)) tooltip:tt_chbtn_Search
dropdownlist ddl_IORTexture items:#() pos:[xp3[5],(yp3+ddlOf)+BS2*12] width:w[3] height:20 selection:0 enabled:false tooltip:tt_ddl_Texture
button btn_IORBrowse "..." pos:[xp3[6],yp3+BS2*12] width:w[1] height:18 enabled:((ATfn_.GetINI 0 iniFile "IOR" "OnOffState" false) and (not OMS)) tooltip:tt_btn_Browse
dropdownlist ddl_IORLoader items:loaderItems pos:[xp3[7],(yp3+ddlOf)+BS2*12] width:w[4] height:33 selection:(ATfn_.GetINI 0 iniFile "IOR" "DefaultLoader" 1) enabled:(ATfn_.GetINI 0 iniFile "IOR" "OnOffState" false) tooltip:tt_ddl_Loader
checkButton chbtn_IOROCIO "O" pos:[xp3[18],yp3+BS2*12] width:w[1] height:18 checked:(if (ATfn_.GetINI 0 iniFile "IOR" "OnOffState" false) then (ATfn_.GetINI 0 iniFile "IOR" "OCIOState" false) else (false)) highlightColor:colCHBX enabled:(ATfn_.GetINI 0 iniFile "IOR" "OnOffState" false) tooltip:tt_chbtn_OCIO
colorpicker color_IORCoColor "" pos:[xp3[8],yp3+BS2*12] width:w[5] height:18 color:(ATfn_.GetINI 0 iniFile "IOR" "CorrectionVRayColor" [128,128,128]) enabled:(ATfn_.GetINI 0 iniFile "IOR" "OnOffState" false) modal:false tooltip:tt_color_CoColor
spinner spnr_IORTilingU "" pos:[xp3[9],(yp3+edtOf)+BS2*12] width:w[6] range:[-999,999,(ATfn_.GetINI 0 iniFile "IOR" "UTiling" 1.0)] type:#float scale:0.1 enabled:(ATfn_.GetINI 0 iniFile "IOR" "OnOffState" false) tooltip:tt_spnr_TilingU
spinner spnr_IORTilingV "" pos:[xp3[10],(yp3+edtOf)+BS2*12] width:w[6] range:[-999,999,(ATfn_.GetINI 0 iniFile "IOR" "VTiling" 1.0)] type:#float scale:0.1 enabled:(ATfn_.GetINI 0 iniFile "IOR" "OnOffState" false) tooltip:tt_spnr_TilingV
dropdownlist ddl_IORHDRIColSp items:HDRIColSpTypes pos:[xp3[11],(yp3+ddlOf)+BS2*12] width:w[7] height:33 selection:(ATfn_.GetINI 0 iniFile "IOR" "HDRIColorSpace" 2) enabled:(ATfn_.GetINI 0 iniFile "IOR" "OnOffState" false) tooltip:tt_ddl_HDRIColSp
checkButton chbtn_IORColCor "CC" pos:[xp3[12],yp3+BS2*12] width:w[8] height:18 checked:(if (ATfn_.GetINI 0 iniFile "IOR" "OnOffState" false) then (ATfn_.GetINI 0 iniFile "IOR" "ColorCorrectState" false) else (false)) highlightColor:colCHBX enabled:(ATfn_.GetINI 0 iniFile "IOR" "OnOffState" false) tooltip:tt_chbtn_ColCor
spinner spnr_IORCCGammaContrast "" pos:[xp3[13],(yp3+edtOf)+BS2*12] width:w[9] range:[0,99,(ATfn_.GetINI 0 iniFile "IOR" "ColCorGammaContrast" 1.0)] type:#float scale:0.001 enabled:(ATfn_.GetINI 0 iniFile "IOR" "OnOffState" false) tooltip:tt_spnr_CCGammaContrast
spinner spnr_IORCCRGB "" pos:[xp3[14],(yp3+edtOf)+BS2*12] width:w[10] range:[0,999,(ATfn_.GetINI 0 iniFile "IOR" "ColCorRGB" 100)] type:#float scale:0.1 enabled:(ATfn_.GetINI 0 iniFile "IOR" "OnOffState" false) tooltip:tt_spnr_CCRGB
button btn_IORMapType "" pos:[xp3[15],yp3+BS2*12] width:w[11] height:18 enabled:false tooltip:tt_btn_MapType
button btn_IORMapSize "" pos:[xp3[16],yp3+BS2*12] width:w[12] height:18 enabled:false tooltip:tt_btn_MapSize
checkButton chbtn_IORCompos "C" pos:[xp3[17],yp3+BS2*12] width:w[1] height:18 checked:(if (ATfn_.GetINI 0 iniFile "IOR" "OnOffState" false) then (ATfn_.GetINI 0 iniFile "IOR" "CompositeState" false) else (false)) highlightColor:colCHBX enabled:(ATfn_.GetINI 0 iniFile "IOR" "OnOffState" false) tooltip:tt_chbtn_Compos

checkButton chbtn_TranslucentState "" pos:[xp3[1],(yp3+2)+BS2*13] width:14 height:14 checked:(ATfn_.GetINI 0 iniFile "Translucent" "OnOffState" false) highlightColor:colCHBX
label lbl_TranslucentState "Translucent" pos:[(xp3[1]+xb1),(yp3+2)+BS2*13]
dropdownlist ddl_TranslucentSearchName items:(ATfn_.GetINI 0 iniFile "Translucent" "SavedSearchNames" #("")) pos:[xp3[2],(yp3+ddlOf)+BS2*13] width:20 height:33 selection:0 enabled:(ATfn_.GetINI 0 iniFile "Translucent" "OnOffState" false) tooltip:tt_ddl_Fild
edittext edt_TranslucentSearchName "" text:(ATfn_.GetINI 1 iniFile "Translucent" "DefaultSearchName" "") pos:[xp3[3],(yp3+edtOf)+BS2*13] width:w[2] height:17 enabled:(ATfn_.GetINI 0 iniFile "Translucent" "OnOffState" false)
checkButton chbtn_TranslucentStatus "S" pos:[xp3[4],yp3+BS2*13] width:w[1] height:18 checked:(ATfn_.GetINI 0 iniFile "Translucent" "OnOffState" false) highlightColor:colZ enabled:((ATfn_.GetINI 0 iniFile "Translucent" "OnOffState" false) and (not OMS)) tooltip:tt_chbtn_Search
dropdownlist ddl_TranslucentTexture items:#() pos:[xp3[5],(yp3+ddlOf)+BS2*13] width:w[3] height:20 selection:0 enabled:false tooltip:tt_ddl_Texture
button btn_TranslucentBrowse "..." pos:[xp3[6],yp3+BS2*13] width:w[1] height:18 enabled:((ATfn_.GetINI 0 iniFile "Translucent" "OnOffState" false) and (not OMS)) tooltip:tt_btn_Browse
dropdownlist ddl_TranslucentLoader items:loaderItems pos:[xp3[7],(yp3+ddlOf)+BS2*13] width:w[4] height:33 selection:(ATfn_.GetINI 0 iniFile "Translucent" "DefaultLoader" 1) enabled:(ATfn_.GetINI 0 iniFile "Translucent" "OnOffState" false) tooltip:tt_ddl_Loader
checkButton chbtn_TranslucentOCIO "O" pos:[xp3[18],yp3+BS2*13] width:w[1] height:18 checked:(if (ATfn_.GetINI 0 iniFile "Translucent" "OnOffState" false) then (ATfn_.GetINI 0 iniFile "Translucent" "OCIOState" false) else (false)) highlightColor:colCHBX enabled:(ATfn_.GetINI 0 iniFile "Translucent" "OnOffState" false) tooltip:tt_chbtn_OCIO
colorpicker color_TranslucentCoColor "" pos:[xp3[8],yp3+BS2*13] width:w[5] height:18 color:(ATfn_.GetINI 0 iniFile "Translucent" "CorrectionVRayColor" [128,128,128]) enabled:(ATfn_.GetINI 0 iniFile "Translucent" "OnOffState" false) modal:false tooltip:tt_color_CoColor
spinner spnr_TranslucentTilingU "" pos:[xp3[9],(yp3+edtOf)+BS2*13] width:w[6] range:[-999,999,(ATfn_.GetINI 0 iniFile "Translucent" "UTiling" 1.0)] type:#float scale:0.1 enabled:(ATfn_.GetINI 0 iniFile "Translucent" "OnOffState" false) tooltip:tt_spnr_TilingU
spinner spnr_TranslucentTilingV "" pos:[xp3[10],(yp3+edtOf)+BS2*13] width:w[6] range:[-999,999,(ATfn_.GetINI 0 iniFile "Translucent" "VTiling" 1.0)] type:#float scale:0.1 enabled:(ATfn_.GetINI 0 iniFile "Translucent" "OnOffState" false) tooltip:tt_spnr_TilingV
dropdownlist ddl_TranslucentHDRIColSp items:HDRIColSpTypes pos:[xp3[11],(yp3+ddlOf)+BS2*13] width:w[7] height:33 selection:(ATfn_.GetINI 0 iniFile "Translucent" "HDRIColorSpace" 2) enabled:(ATfn_.GetINI 0 iniFile "Translucent" "OnOffState" false) tooltip:tt_ddl_HDRIColSp
checkButton chbtn_TranslucentColCor "CC" pos:[xp3[12],yp3+BS2*13] width:w[8] height:18 checked:(if (ATfn_.GetINI 0 iniFile "Translucent" "OnOffState" false) then (ATfn_.GetINI 0 iniFile "Translucent" "ColorCorrectState" false) else (false)) highlightColor:colCHBX enabled:(ATfn_.GetINI 0 iniFile "Translucent" "OnOffState" false) tooltip:tt_chbtn_ColCor
spinner spnr_TranslucentCCGammaContrast "" pos:[xp3[13],(yp3+edtOf)+BS2*13] width:w[9] range:[0,99,(ATfn_.GetINI 0 iniFile "Translucent" "ColCorGammaContrast" 1.0)] type:#float scale:0.001 enabled:(ATfn_.GetINI 0 iniFile "Translucent" "OnOffState" false) tooltip:tt_spnr_CCGammaContrast
spinner spnr_TranslucentCCRGB "" pos:[xp3[14],(yp3+edtOf)+BS2*13] width:w[10] range:[0,999,(ATfn_.GetINI 0 iniFile "Translucent" "ColCorRGB" 100)] type:#float scale:0.1 enabled:(ATfn_.GetINI 0 iniFile "Translucent" "OnOffState" false) tooltip:tt_spnr_CCRGB
button btn_TranslucentMapType "" pos:[xp3[15],yp3+BS2*13] width:w[11] height:18 enabled:false tooltip:tt_btn_MapType
button btn_TranslucentMapSize "" pos:[xp3[16],yp3+BS2*13] width:w[12] height:18 enabled:false tooltip:tt_btn_MapSize
checkButton chbtn_TranslucentCompos "C" pos:[xp3[17],yp3+BS2*13] width:w[1] height:18 checked:(if (ATfn_.GetINI 0 iniFile "Translucent" "OnOffState" false) then (ATfn_.GetINI 0 iniFile "Translucent" "CompositeState" false) else (false)) highlightColor:colCHBX enabled:(ATfn_.GetINI 0 iniFile "Translucent" "OnOffState" false) tooltip:tt_chbtn_Compos

checkButton chbtn_FogColorState "" pos:[xp3[1],(yp3+2)+BS2*14] width:14 height:14 checked:(ATfn_.GetINI 0 iniFile "FogColor" "OnOffState" false) highlightColor:colCHBX
label lbl_FogColorState "FogColor" pos:[(xp3[1]+xb1),(yp3+2)+BS2*14]
dropdownlist ddl_FogColorSearchName items:(ATfn_.GetINI 0 iniFile "FogColor" "SavedSearchNames" #("")) pos:[xp3[2],(yp3+ddlOf)+BS2*14] width:20 height:33 selection:0 enabled:(ATfn_.GetINI 0 iniFile "FogColor" "OnOffState" false) tooltip:tt_ddl_Fild
edittext edt_FogColorSearchName "" text:(ATfn_.GetINI 1 iniFile "FogColor" "DefaultSearchName" "") pos:[xp3[3],(yp3+edtOf)+BS2*14] width:w[2] height:17 enabled:(ATfn_.GetINI 0 iniFile "FogColor" "OnOffState" false)
checkButton chbtn_FogColorStatus "S" pos:[xp3[4],yp3+BS2*14] width:w[1] height:18 checked:(ATfn_.GetINI 0 iniFile "FogColor" "OnOffState" false) highlightColor:colZ enabled:((ATfn_.GetINI 0 iniFile "FogColor" "OnOffState" false) and (not OMS)) tooltip:tt_chbtn_Search
dropdownlist ddl_FogColorTexture items:#() pos:[xp3[5],(yp3+ddlOf)+BS2*14] width:w[3] height:20 selection:0 enabled:false tooltip:tt_ddl_Texture
button btn_FogColorBrowse "..." pos:[xp3[6],yp3+BS2*14] width:w[1] height:18 enabled:((ATfn_.GetINI 0 iniFile "FogColor" "OnOffState" false) and (not OMS)) tooltip:tt_btn_Browse
dropdownlist ddl_FogColorLoader items:loaderItems pos:[xp3[7],(yp3+ddlOf)+BS2*14] width:w[4] height:33 selection:(ATfn_.GetINI 0 iniFile "FogColor" "DefaultLoader" 1) enabled:(ATfn_.GetINI 0 iniFile "FogColor" "OnOffState" false) tooltip:tt_ddl_Loader
checkButton chbtn_FogColorOCIO "O" pos:[xp3[18],yp3+BS2*14] width:w[1] height:18 checked:(if (ATfn_.GetINI 0 iniFile "FogColor" "OnOffState" false) then (ATfn_.GetINI 0 iniFile "FogColor" "OCIOState" false) else (false)) highlightColor:colCHBX enabled:(ATfn_.GetINI 0 iniFile "FogColor" "OnOffState" false) tooltip:tt_chbtn_OCIO
colorpicker color_FogColorCoColor "" pos:[xp3[8],yp3+BS2*14] width:w[5] height:18 color:(ATfn_.GetINI 0 iniFile "FogColor" "CorrectionVRayColor" [128,128,128]) enabled:(ATfn_.GetINI 0 iniFile "FogColor" "OnOffState" false) modal:false tooltip:tt_color_CoColor
spinner spnr_FogColorTilingU "" pos:[xp3[9],(yp3+edtOf)+BS2*14] width:w[6] range:[-999,999,(ATfn_.GetINI 0 iniFile "FogColor" "UTiling" 1.0)] type:#float scale:0.1 enabled:(ATfn_.GetINI 0 iniFile "FogColor" "OnOffState" false) tooltip:tt_spnr_TilingU
spinner spnr_FogColorTilingV "" pos:[xp3[10],(yp3+edtOf)+BS2*14] width:w[6] range:[-999,999,(ATfn_.GetINI 0 iniFile "FogColor" "VTiling" 1.0)] type:#float scale:0.1 enabled:(ATfn_.GetINI 0 iniFile "FogColor" "OnOffState" false) tooltip:tt_spnr_TilingV
dropdownlist ddl_FogColorHDRIColSp items:HDRIColSpTypes pos:[xp3[11],(yp3+ddlOf)+BS2*14] width:w[7] height:33 selection:(ATfn_.GetINI 0 iniFile "FogColor" "HDRIColorSpace" 2) enabled:(ATfn_.GetINI 0 iniFile "FogColor" "OnOffState" false) tooltip:tt_ddl_HDRIColSp
checkButton chbtn_FogColorColCor "CC" pos:[xp3[12],yp3+BS2*14] width:w[8] height:18 checked:(if (ATfn_.GetINI 0 iniFile "FogColor" "OnOffState" false) then (ATfn_.GetINI 0 iniFile "FogColor" "ColorCorrectState" false) else (false)) highlightColor:colCHBX enabled:(ATfn_.GetINI 0 iniFile "FogColor" "OnOffState" false) tooltip:tt_chbtn_ColCor
spinner spnr_FogColorCCGammaContrast "" pos:[xp3[13],(yp3+edtOf)+BS2*14] width:w[9] range:[0,99,(ATfn_.GetINI 0 iniFile "FogColor" "ColCorGammaContrast" 1.0)] type:#float scale:0.001 enabled:(ATfn_.GetINI 0 iniFile "FogColor" "OnOffState" false) tooltip:tt_spnr_CCGammaContrast
spinner spnr_FogColorCCRGB "" pos:[xp3[14],(yp3+edtOf)+BS2*14] width:w[10] range:[0,999,(ATfn_.GetINI 0 iniFile "FogColor" "ColCorRGB" 100)] type:#float scale:0.1 enabled:(ATfn_.GetINI 0 iniFile "FogColor" "OnOffState" false) tooltip:tt_spnr_CCRGB
button btn_FogColorMapType "" pos:[xp3[15],yp3+BS2*14] width:w[11] height:18 enabled:false tooltip:tt_btn_MapType
button btn_FogColorMapSize "" pos:[xp3[16],yp3+BS2*14] width:w[12] height:18 enabled:false tooltip:tt_btn_MapSize
checkButton chbtn_FogColorCompos "C" pos:[xp3[17],yp3+BS2*14] width:w[1] height:18 checked:(if (ATfn_.GetINI 0 iniFile "FogColor" "OnOffState" false) then (ATfn_.GetINI 0 iniFile "FogColor" "CompositeState" false) else (false)) highlightColor:colCHBX enabled:(ATfn_.GetINI 0 iniFile "FogColor" "OnOffState" false) tooltip:tt_chbtn_Compos

checkButton chbtn_NormalState "" pos:[xp3[1],(yp3+2)+BS2*15] width:14 height:14 checked:(ATfn_.GetINI 0 iniFile "Normal" "OnOffState" false) highlightColor:colCHBX
label lbl_NormalState "Normal" pos:[(xp3[1]+xb1),(yp3+2)+BS2*15]
dropdownlist ddl_NormalSearchName items:(ATfn_.GetINI 0 iniFile "Normal" "SavedSearchNames" #("")) pos:[xp3[2],(yp3+ddlOf)+BS2*15] width:20 height:33 selection:0 enabled:(ATfn_.GetINI 0 iniFile "Normal" "OnOffState" false) tooltip:tt_ddl_Fild
edittext edt_NormalSearchName "" text:(ATfn_.GetINI 1 iniFile "Normal" "DefaultSearchName" "") pos:[xp3[3],(yp3+edtOf)+BS2*15] width:w[2] height:17 enabled:(ATfn_.GetINI 0 iniFile "Normal" "OnOffState" false)
checkButton chbtn_NormalStatus "S" pos:[xp3[4],yp3+BS2*15] width:w[1] height:18 checked:(ATfn_.GetINI 0 iniFile "Normal" "OnOffState" false) highlightColor:colZ enabled:((ATfn_.GetINI 0 iniFile "Normal" "OnOffState" false) and (not OMS)) tooltip:tt_chbtn_Search
dropdownlist ddl_NormalTexture items:#() pos:[xp3[5],(yp3+ddlOf)+BS2*15] width:w[3] height:20 selection:0 enabled:false tooltip:tt_ddl_Texture
button btn_NormalBrowse "..." pos:[xp3[6],yp3+BS2*15] width:w[1] height:18 enabled:((ATfn_.GetINI 0 iniFile "Normal" "OnOffState" false) and (not OMS)) tooltip:tt_btn_Browse
dropdownlist ddl_NormalLoader items:loaderItems pos:[xp3[7],(yp3+ddlOf)+BS2*15] width:w[4] height:33 selection:(ATfn_.GetINI 0 iniFile "Normal" "DefaultLoader" 1) enabled:(ATfn_.GetINI 0 iniFile "Normal" "OnOffState" false) tooltip:tt_ddl_Loader
checkButton chbtn_NormalOCIO "O" pos:[xp3[18],yp3+BS2*15] width:w[1] height:18 checked:(if (ATfn_.GetINI 0 iniFile "Normal" "OnOffState" false) then (ATfn_.GetINI 0 iniFile "Normal" "OCIOState" false) else (false)) highlightColor:colCHBX enabled:(ATfn_.GetINI 0 iniFile "Normal" "OnOffState" false) tooltip:tt_chbtn_OCIO
colorpicker color_NormalCoColor "" pos:[xp3[8],yp3+BS2*15] width:w[5] height:18 color:(ATfn_.GetINI 0 iniFile "Normal" "CorrectionVRayColor" [128,128,128]) enabled:(ATfn_.GetINI 0 iniFile "Normal" "OnOffState" false) modal:false tooltip:tt_color_CoColor
spinner spnr_NormalTilingU "" pos:[xp3[9],(yp3+edtOf)+BS2*15] width:w[6] range:[-999,999,(ATfn_.GetINI 0 iniFile "Normal" "UTiling" 1.0)] type:#float scale:0.1 enabled:(ATfn_.GetINI 0 iniFile "Normal" "OnOffState" false) tooltip:tt_spnr_TilingU
spinner spnr_NormalTilingV "" pos:[xp3[10],(yp3+edtOf)+BS2*15] width:w[6] range:[-999,999,(ATfn_.GetINI 0 iniFile "Normal" "VTiling" 1.0)] type:#float scale:0.1 enabled:(ATfn_.GetINI 0 iniFile "Normal" "OnOffState" false) tooltip:tt_spnr_TilingV
dropdownlist ddl_NormalHDRIColSp items:HDRIColSpTypes pos:[xp3[11],(yp3+ddlOf)+BS2*15] width:w[7] height:33 selection:(ATfn_.GetINI 0 iniFile "Normal" "HDRIColorSpace" 2) enabled:(ATfn_.GetINI 0 iniFile "Normal" "OnOffState" false) tooltip:tt_ddl_HDRIColSp
checkButton chbtn_NormalColCor "CC" pos:[xp3[12],yp3+BS2*15] width:w[8] height:18 checked:(if (ATfn_.GetINI 0 iniFile "Normal" "OnOffState" false) then (ATfn_.GetINI 0 iniFile "Normal" "ColorCorrectState" false) else (false)) highlightColor:colCHBX enabled:(ATfn_.GetINI 0 iniFile "Normal" "OnOffState" false) tooltip:tt_chbtn_ColCor
spinner spnr_NormalCCGammaContrast "" pos:[xp3[13],(yp3+edtOf)+BS2*15] width:w[9] range:[0,99,(ATfn_.GetINI 0 iniFile "Normal" "ColCorGammaContrast" 1.0)] type:#float scale:0.001 enabled:(ATfn_.GetINI 0 iniFile "Normal" "OnOffState" false) tooltip:tt_spnr_CCGammaContrast
spinner spnr_NormalCCRGB "" pos:[xp3[14],(yp3+edtOf)+BS2*15] width:w[10] range:[0,999,(ATfn_.GetINI 0 iniFile "Normal" "ColCorRGB" 100)] type:#float scale:0.1 enabled:(ATfn_.GetINI 0 iniFile "Normal" "OnOffState" false) tooltip:tt_spnr_CCRGB
button btn_NormalMapType "" pos:[xp3[15],yp3+BS2*15] width:w[11] height:18 enabled:false tooltip:tt_btn_MapType
button btn_NormalMapSize "" pos:[xp3[16],yp3+BS2*15] width:w[12] height:18 enabled:false tooltip:tt_btn_MapSize
checkButton chbtn_NormalCompos "C" pos:[xp3[17],yp3+BS2*15] width:w[1] height:18 checked:(if (ATfn_.GetINI 0 iniFile "Normal" "OnOffState" false) then (ATfn_.GetINI 0 iniFile "Normal" "CompositeState" false) else (false)) highlightColor:colCHBX enabled:(ATfn_.GetINI 0 iniFile "Normal" "OnOffState" false) tooltip:tt_chbtn_Compos

checkButton chbtn_BumpState "" pos:[xp3[1],(yp3+2)+BS2*16] width:14 height:14 checked:(ATfn_.GetINI 0 iniFile "Bump" "OnOffState" false) highlightColor:colCHBX
label lbl_BumpState "Bump" pos:[(xp3[1]+xb1),(yp3+2)+BS2*16]
dropdownlist ddl_BumpSearchName items:(ATfn_.GetINI 0 iniFile "Bump" "SavedSearchNames" #("")) pos:[xp3[2],(yp3+ddlOf)+BS2*16] width:20 height:33 selection:0 enabled:(ATfn_.GetINI 0 iniFile "Bump" "OnOffState" false) tooltip:tt_ddl_Fild
edittext edt_BumpSearchName "" text:(ATfn_.GetINI 1 iniFile "Bump" "DefaultSearchName" "") pos:[xp3[3],(yp3+edtOf)+BS2*16] width:w[2] height:17 enabled:(ATfn_.GetINI 0 iniFile "Bump" "OnOffState" false)
checkButton chbtn_BumpStatus "S" pos:[xp3[4],yp3+BS2*16] width:w[1] height:18 checked:(ATfn_.GetINI 0 iniFile "Bump" "OnOffState" false) highlightColor:colZ enabled:((ATfn_.GetINI 0 iniFile "Bump" "OnOffState" false) and (not OMS)) tooltip:tt_chbtn_Search
dropdownlist ddl_BumpTexture items:#() pos:[xp3[5],(yp3+ddlOf)+BS2*16] width:w[3] height:20 selection:0 enabled:false tooltip:tt_ddl_Texture
button btn_BumpBrowse "..." pos:[xp3[6],yp3+BS2*16] width:w[1] height:18 enabled:((ATfn_.GetINI 0 iniFile "Bump" "OnOffState" false) and (not OMS)) tooltip:tt_btn_Browse
dropdownlist ddl_BumpLoader items:loaderItems pos:[xp3[7],(yp3+ddlOf)+BS2*16] width:w[4] height:33 selection:(ATfn_.GetINI 0 iniFile "Bump" "DefaultLoader" 1) enabled:(ATfn_.GetINI 0 iniFile "Bump" "OnOffState" false) tooltip:tt_ddl_Loader
checkButton chbtn_BumpOCIO "O" pos:[xp3[18],yp3+BS2*16] width:w[1] height:18 checked:(if (ATfn_.GetINI 0 iniFile "Bump" "OnOffState" false) then (ATfn_.GetINI 0 iniFile "Bump" "OCIOState" false) else (false)) highlightColor:colCHBX enabled:(ATfn_.GetINI 0 iniFile "Bump" "OnOffState" false) tooltip:tt_chbtn_OCIO
colorpicker color_BumpCoColor "" pos:[xp3[8],yp3+BS2*16] width:w[5] height:18 color:(ATfn_.GetINI 0 iniFile "Bump" "CorrectionVRayColor" [128,128,128]) enabled:(ATfn_.GetINI 0 iniFile "Bump" "OnOffState" false) modal:false tooltip:tt_color_CoColor
spinner spnr_BumpTilingU "" pos:[xp3[9],(yp3+edtOf)+BS2*16] width:w[6] range:[-999,999,(ATfn_.GetINI 0 iniFile "Bump" "UTiling" 1.0)] type:#float scale:0.1 enabled:(ATfn_.GetINI 0 iniFile "Bump" "OnOffState" false) tooltip:tt_spnr_TilingU
spinner spnr_BumpTilingV "" pos:[xp3[10],(yp3+edtOf)+BS2*16] width:w[6] range:[-999,999,(ATfn_.GetINI 0 iniFile "Bump" "VTiling" 1.0)] type:#float scale:0.1 enabled:(ATfn_.GetINI 0 iniFile "Bump" "OnOffState" false) tooltip:tt_spnr_TilingV
dropdownlist ddl_BumpHDRIColSp items:HDRIColSpTypes pos:[xp3[11],(yp3+ddlOf)+BS2*16] width:w[7] height:33 selection:(ATfn_.GetINI 0 iniFile "Bump" "HDRIColorSpace" 2) enabled:(ATfn_.GetINI 0 iniFile "Bump" "OnOffState" false) tooltip:tt_ddl_HDRIColSp
checkButton chbtn_BumpColCor "CC" pos:[xp3[12],yp3+BS2*16] width:w[8] height:18 checked:(if (ATfn_.GetINI 0 iniFile "Bump" "OnOffState" false) then (ATfn_.GetINI 0 iniFile "Bump" "ColorCorrectState" false) else (false)) highlightColor:colCHBX enabled:(ATfn_.GetINI 0 iniFile "Bump" "OnOffState" false) tooltip:tt_chbtn_ColCor
spinner spnr_BumpCCGammaContrast "" pos:[xp3[13],(yp3+edtOf)+BS2*16] width:w[9] range:[0,99,(ATfn_.GetINI 0 iniFile "Bump" "ColCorGammaContrast" 1.0)] type:#float scale:0.001 enabled:(ATfn_.GetINI 0 iniFile "Bump" "OnOffState" false) tooltip:tt_spnr_CCGammaContrast
spinner spnr_BumpCCRGB "" pos:[xp3[14],(yp3+edtOf)+BS2*16] width:w[10] range:[0,999,(ATfn_.GetINI 0 iniFile "Bump" "ColCorRGB" 100)] type:#float scale:0.1 enabled:(ATfn_.GetINI 0 iniFile "Bump" "OnOffState" false) tooltip:tt_spnr_CCRGB
button btn_BumpMapType "" pos:[xp3[15],yp3+BS2*16] width:w[11] height:18 enabled:false tooltip:tt_btn_MapType
button btn_BumpMapSize "" pos:[xp3[16],yp3+BS2*16] width:w[12] height:18 enabled:false tooltip:tt_btn_MapSize
checkButton chbtn_BumpCompos "C" pos:[xp3[17],yp3+BS2*16] width:w[1] height:18 checked:(if (ATfn_.GetINI 0 iniFile "Bump" "OnOffState" false) then (ATfn_.GetINI 0 iniFile "Bump" "CompositeState" false) else (false)) highlightColor:colCHBX enabled:(ATfn_.GetINI 0 iniFile "Bump" "OnOffState" false) tooltip:tt_chbtn_Compos

checkButton chbtn_DisplaceState "" pos:[xp3[1],(yp3+2)+BS2*17] width:14 height:14 checked:(ATfn_.GetINI 0 iniFile "Displace" "OnOffState" false) highlightColor:colCHBX
label lbl_DisplaceState "Displace" pos:[(xp3[1]+xb1),(yp3+2)+BS2*17]
dropdownlist ddl_DisplaceSearchName items:(ATfn_.GetINI 0 iniFile "Displace" "SavedSearchNames" #("")) pos:[xp3[2],(yp3+ddlOf)+BS2*17] width:20 height:33 selection:0 enabled:(ATfn_.GetINI 0 iniFile "Displace" "OnOffState" false) tooltip:tt_ddl_Fild
edittext edt_DisplaceSearchName "" text:(ATfn_.GetINI 1 iniFile "Displace" "DefaultSearchName" "") pos:[xp3[3],(yp3+edtOf)+BS2*17] width:w[2] height:17 enabled:(ATfn_.GetINI 0 iniFile "Displace" "OnOffState" false)
checkButton chbtn_DisplaceStatus "S" pos:[xp3[4],yp3+BS2*17] width:w[1] height:18 checked:(ATfn_.GetINI 0 iniFile "Displace" "OnOffState" false) highlightColor:colZ enabled:((ATfn_.GetINI 0 iniFile "Displace" "OnOffState" false) and (not OMS)) tooltip:tt_chbtn_Search
dropdownlist ddl_DisplaceTexture items:#() pos:[xp3[5],(yp3+ddlOf)+BS2*17] width:w[3] height:20 selection:0 enabled:false tooltip:tt_ddl_Texture
button btn_DisplaceBrowse "..." pos:[xp3[6],yp3+BS2*17] width:w[1] height:18 enabled:((ATfn_.GetINI 0 iniFile "Displace" "OnOffState" false) and (not OMS)) tooltip:tt_btn_Browse
dropdownlist ddl_DisplaceLoader items:loaderItems pos:[xp3[7],(yp3+ddlOf)+BS2*17] width:w[4] height:33 selection:(ATfn_.GetINI 0 iniFile "Displace" "DefaultLoader" 1) enabled:(ATfn_.GetINI 0 iniFile "Displace" "OnOffState" false) tooltip:tt_ddl_Loader
checkButton chbtn_DisplaceOCIO "O" pos:[xp3[18],yp3+BS2*17] width:w[1] height:18 checked:(if (ATfn_.GetINI 0 iniFile "Displace" "OnOffState" false) then (ATfn_.GetINI 0 iniFile "Displace" "OCIOState" false) else (false)) highlightColor:colCHBX enabled:(ATfn_.GetINI 0 iniFile "Displace" "OnOffState" false) tooltip:tt_chbtn_OCIO
colorpicker color_DisplaceCoColor "" pos:[xp3[8],yp3+BS2*17] width:w[5] height:18 color:(ATfn_.GetINI 0 iniFile "Displace" "CorrectionVRayColor" [128,128,128]) enabled:(ATfn_.GetINI 0 iniFile "Displace" "OnOffState" false) modal:false tooltip:tt_color_CoColor
spinner spnr_DisplaceTilingU "" pos:[xp3[9],(yp3+edtOf)+BS2*17] width:w[6] range:[-999,999,(ATfn_.GetINI 0 iniFile "Displace" "UTiling" 1.0)] type:#float scale:0.1 enabled:(ATfn_.GetINI 0 iniFile "Displace" "OnOffState" false) tooltip:tt_spnr_TilingU
spinner spnr_DisplaceTilingV "" pos:[xp3[10],(yp3+edtOf)+BS2*17] width:w[6] range:[-999,999,(ATfn_.GetINI 0 iniFile "Displace" "VTiling" 1.0)] type:#float scale:0.1 enabled:(ATfn_.GetINI 0 iniFile "Displace" "OnOffState" false) tooltip:tt_spnr_TilingV
dropdownlist ddl_DisplaceHDRIColSp items:HDRIColSpTypes pos:[xp3[11],(yp3+ddlOf)+BS2*17] width:w[7] height:33 selection:(ATfn_.GetINI 0 iniFile "Displace" "HDRIColorSpace" 2) enabled:(ATfn_.GetINI 0 iniFile "Displace" "OnOffState" false) tooltip:tt_ddl_HDRIColSp
checkButton chbtn_DisplaceColCor "CC" pos:[xp3[12],yp3+BS2*17] width:w[8] height:18 checked:(if (ATfn_.GetINI 0 iniFile "Displace" "OnOffState" false) then (ATfn_.GetINI 0 iniFile "Displace" "ColorCorrectState" false) else (false)) highlightColor:colCHBX enabled:(ATfn_.GetINI 0 iniFile "Displace" "OnOffState" false) tooltip:tt_chbtn_ColCor
spinner spnr_DisplaceCCGammaContrast "" pos:[xp3[13],(yp3+edtOf)+BS2*17] width:w[9] range:[0,99,(ATfn_.GetINI 0 iniFile "Displace" "ColCorGammaContrast" 1.0)] type:#float scale:0.001 enabled:(ATfn_.GetINI 0 iniFile "Displace" "OnOffState" false) tooltip:tt_spnr_CCGammaContrast
spinner spnr_DisplaceCCRGB "" pos:[xp3[14],(yp3+edtOf)+BS2*17] width:w[10] range:[0,999,(ATfn_.GetINI 0 iniFile "Displace" "ColCorRGB" 100)] type:#float scale:0.1 enabled:(ATfn_.GetINI 0 iniFile "Displace" "OnOffState" false) tooltip:tt_spnr_CCRGB
button btn_DisplaceMapType "" pos:[xp3[15],yp3+BS2*17] width:w[11] height:18 enabled:false tooltip:tt_btn_MapType
button btn_DisplaceMapSize "" pos:[xp3[16],yp3+BS2*17] width:w[12] height:18 enabled:false tooltip:tt_btn_MapSize
checkButton chbtn_DisplaceCompos "C" pos:[xp3[17],yp3+BS2*17] width:w[1] height:18 checked:(if (ATfn_.GetINI 0 iniFile "Displace" "OnOffState" false) then (ATfn_.GetINI 0 iniFile "Displace" "CompositeState" false) else (false)) highlightColor:colCHBX enabled:(ATfn_.GetINI 0 iniFile "Displace" "OnOffState" false) tooltip:tt_chbtn_Compos

checkButton chbtn_OpacityState "" pos:[xp3[1],(yp3+2)+BS2*18] width:14 height:14 checked:(ATfn_.GetINI 0 iniFile "Opacity" "OnOffState" false) highlightColor:colCHBX
label lbl_OpacityState "Opacity" pos:[(xp3[1]+xb1),(yp3+2)+BS2*18]
dropdownlist ddl_OpacitySearchName items:(ATfn_.GetINI 0 iniFile "Opacity" "SavedSearchNames" #("")) pos:[xp3[2],(yp3+ddlOf)+BS2*18] width:20 height:33 selection:0 enabled:(ATfn_.GetINI 0 iniFile "Opacity" "OnOffState" false) tooltip:tt_ddl_Fild
edittext edt_OpacitySearchName "" text:(ATfn_.GetINI 1 iniFile "Opacity" "DefaultSearchName" "") pos:[xp3[3],(yp3+edtOf)+BS2*18] width:w[2] height:17 enabled:(ATfn_.GetINI 0 iniFile "Opacity" "OnOffState" false)
checkButton chbtn_OpacityStatus "S" pos:[xp3[4],yp3+BS2*18] width:w[1] height:18 checked:(ATfn_.GetINI 0 iniFile "Opacity" "OnOffState" false) highlightColor:colZ enabled:((ATfn_.GetINI 0 iniFile "Opacity" "OnOffState" false) and (not OMS)) tooltip:tt_chbtn_Search
dropdownlist ddl_OpacityTexture items:#() pos:[xp3[5],(yp3+ddlOf)+BS2*18] width:w[3] height:20 selection:0 enabled:false tooltip:tt_ddl_Texture
button btn_OpacityBrowse "..." pos:[xp3[6],yp3+BS2*18] width:w[1] height:18 enabled:((ATfn_.GetINI 0 iniFile "Opacity" "OnOffState" false) and (not OMS)) tooltip:tt_btn_Browse
dropdownlist ddl_OpacityLoader items:loaderItems pos:[xp3[7],(yp3+ddlOf)+BS2*18] width:w[4] height:33 selection:(ATfn_.GetINI 0 iniFile "Opacity" "DefaultLoader" 1) enabled:(ATfn_.GetINI 0 iniFile "Opacity" "OnOffState" false) tooltip:tt_ddl_Loader
checkButton chbtn_OpacityOCIO "O" pos:[xp3[18],yp3+BS2*18] width:w[1] height:18 checked:(if (ATfn_.GetINI 0 iniFile "Opacity" "OnOffState" false) then (ATfn_.GetINI 0 iniFile "Opacity" "OCIOState" false) else (false)) highlightColor:colCHBX enabled:(ATfn_.GetINI 0 iniFile "Opacity" "OnOffState" false) tooltip:tt_chbtn_OCIO
colorpicker color_OpacityCoColor "" pos:[xp3[8],yp3+BS2*18] width:w[5] height:18 color:(ATfn_.GetINI 0 iniFile "Opacity" "CorrectionVRayColor" [128,128,128]) enabled:(ATfn_.GetINI 0 iniFile "Opacity" "OnOffState" false) modal:false tooltip:tt_color_CoColor
spinner spnr_OpacityTilingU "" pos:[xp3[9],(yp3+edtOf)+BS2*18] width:w[6] range:[-999,999,(ATfn_.GetINI 0 iniFile "Opacity" "UTiling" 1.0)] type:#float scale:0.1 enabled:(ATfn_.GetINI 0 iniFile "Opacity" "OnOffState" false) tooltip:tt_spnr_TilingU
spinner spnr_OpacityTilingV "" pos:[xp3[10],(yp3+edtOf)+BS2*18] width:w[6] range:[-999,999,(ATfn_.GetINI 0 iniFile "Opacity" "VTiling" 1.0)] type:#float scale:0.1 enabled:(ATfn_.GetINI 0 iniFile "Opacity" "OnOffState" false) tooltip:tt_spnr_TilingV
dropdownlist ddl_OpacityHDRIColSp items:HDRIColSpTypes pos:[xp3[11],(yp3+ddlOf)+BS2*18] width:w[7] height:33 selection:(ATfn_.GetINI 0 iniFile "Opacity" "HDRIColorSpace" 2) enabled:(ATfn_.GetINI 0 iniFile "Opacity" "OnOffState" false) tooltip:tt_ddl_HDRIColSp
checkButton chbtn_OpacityColCor "CC" pos:[xp3[12],yp3+BS2*18] width:w[8] height:18 checked:(if (ATfn_.GetINI 0 iniFile "Opacity" "OnOffState" false) then (ATfn_.GetINI 0 iniFile "Opacity" "ColorCorrectState" false) else (false)) highlightColor:colCHBX enabled:(ATfn_.GetINI 0 iniFile "Opacity" "OnOffState" false) tooltip:tt_chbtn_ColCor
spinner spnr_OpacityCCGammaContrast "" pos:[xp3[13],(yp3+edtOf)+BS2*18] width:w[9] range:[0,99,(ATfn_.GetINI 0 iniFile "Opacity" "ColCorGammaContrast" 1.0)] type:#float scale:0.001 enabled:(ATfn_.GetINI 0 iniFile "Opacity" "OnOffState" false) tooltip:tt_spnr_CCGammaContrast
spinner spnr_OpacityCCRGB "" pos:[xp3[14],(yp3+edtOf)+BS2*18] width:w[10] range:[0,999,(ATfn_.GetINI 0 iniFile "Opacity" "ColCorRGB" 100)] type:#float scale:0.1 enabled:(ATfn_.GetINI 0 iniFile "Opacity" "OnOffState" false) tooltip:tt_spnr_CCRGB
button btn_OpacityMapType "" pos:[xp3[15],yp3+BS2*18] width:w[11] height:18 enabled:false tooltip:tt_btn_MapType
button btn_OpacityMapSize "" pos:[xp3[16],yp3+BS2*18] width:w[12] height:18 enabled:false tooltip:tt_btn_MapSize
checkButton chbtn_OpacityCompos "C" pos:[xp3[17],yp3+BS2*18] width:w[1] height:18 checked:(if (ATfn_.GetINI 0 iniFile "Opacity" "OnOffState" false) then (ATfn_.GetINI 0 iniFile "Opacity" "CompositeState" false) else (false)) highlightColor:colCHBX enabled:(ATfn_.GetINI 0 iniFile "Opacity" "OnOffState" false) tooltip:tt_chbtn_Compos

checkButton chbtn_EnvironmentState "" pos:[xp3[1],(yp3+2)+BS2*19] width:14 height:14 checked:(ATfn_.GetINI 0 iniFile "Environment" "OnOffState" false) highlightColor:colCHBX
label lbl_EnvironmentState "Environment" pos:[(xp3[1]+xb1),(yp3+2)+BS2*19]
dropdownlist ddl_EnvironmentSearchName items:(ATfn_.GetINI 0 iniFile "Environment" "SavedSearchNames" #("")) pos:[xp3[2],(yp3+ddlOf)+BS2*19] width:20 height:33 selection:0 enabled:(ATfn_.GetINI 0 iniFile "Environment" "OnOffState" false) tooltip:tt_ddl_Fild
edittext edt_EnvironmentSearchName "" text:(ATfn_.GetINI 1 iniFile "Environment" "DefaultSearchName" "") pos:[xp3[3],(yp3+edtOf)+BS2*19] width:w[2] height:17 enabled:(ATfn_.GetINI 0 iniFile "Environment" "OnOffState" false)
checkButton chbtn_EnvironmentStatus "S" pos:[xp3[4],yp3+BS2*19] width:w[1] height:18 checked:(ATfn_.GetINI 0 iniFile "Environment" "OnOffState" false) highlightColor:colZ enabled:((ATfn_.GetINI 0 iniFile "Environment" "OnOffState" false) and (not OMS)) tooltip:tt_chbtn_Search
dropdownlist ddl_EnvironmentTexture items:#() pos:[xp3[5],(yp3+ddlOf)+BS2*19] width:w[3] height:20 selection:0 enabled:false tooltip:tt_ddl_Texture
button btn_EnvironmentBrowse "..." pos:[xp3[6],yp3+BS2*19] width:w[1] height:18 enabled:((ATfn_.GetINI 0 iniFile "Environment" "OnOffState" false) and (not OMS)) tooltip:tt_btn_Browse
dropdownlist ddl_EnvironmentLoader items:loaderItems pos:[xp3[7],(yp3+ddlOf)+BS2*19] width:w[4] height:33 selection:(ATfn_.GetINI 0 iniFile "Environment" "DefaultLoader" 1) enabled:(ATfn_.GetINI 0 iniFile "Environment" "OnOffState" false) tooltip:tt_ddl_Loader
checkButton chbtn_EnvironmentOCIO "O" pos:[xp3[18],yp3+BS2*19] width:w[1] height:18 checked:(if (ATfn_.GetINI 0 iniFile "Environment" "OnOffState" false) then (ATfn_.GetINI 0 iniFile "Environment" "OCIOState" false) else (false)) highlightColor:colCHBX enabled:(ATfn_.GetINI 0 iniFile "Environment" "OnOffState" false) tooltip:tt_chbtn_OCIO
colorpicker color_EnvironmentCoColor "" pos:[xp3[8],yp3+BS2*19] width:w[5] height:18 color:(ATfn_.GetINI 0 iniFile "Environment" "CorrectionVRayColor" [128,128,128]) enabled:(ATfn_.GetINI 0 iniFile "Environment" "OnOffState" false) modal:false tooltip:tt_color_CoColor
spinner spnr_EnvironmentTilingU "" pos:[xp3[9],(yp3+edtOf)+BS2*19] width:w[6] range:[-999,999,(ATfn_.GetINI 0 iniFile "Environment" "UTiling" 1.0)] type:#float scale:0.1 enabled:(ATfn_.GetINI 0 iniFile "Environment" "OnOffState" false) tooltip:tt_spnr_TilingU
spinner spnr_EnvironmentTilingV "" pos:[xp3[10],(yp3+edtOf)+BS2*19] width:w[6] range:[-999,999,(ATfn_.GetINI 0 iniFile "Environment" "VTiling" 1.0)] type:#float scale:0.1 enabled:(ATfn_.GetINI 0 iniFile "Environment" "OnOffState" false) tooltip:tt_spnr_TilingV
dropdownlist ddl_EnvironmentHDRIColSp items:HDRIColSpTypes pos:[xp3[11],(yp3+ddlOf)+BS2*19] width:w[7] height:33 selection:(ATfn_.GetINI 0 iniFile "Environment" "HDRIColorSpace" 2) enabled:(ATfn_.GetINI 0 iniFile "Environment" "OnOffState" false) tooltip:tt_ddl_HDRIColSp
checkButton chbtn_EnvironmentColCor "CC" pos:[xp3[12],yp3+BS2*19] width:w[8] height:18 checked:(if (ATfn_.GetINI 0 iniFile "Environment" "OnOffState" false) then (ATfn_.GetINI 0 iniFile "Environment" "ColorCorrectState" false) else (false)) highlightColor:colCHBX enabled:(ATfn_.GetINI 0 iniFile "Environment" "OnOffState" false) tooltip:tt_chbtn_ColCor
spinner spnr_EnvironmentCCGammaContrast "" pos:[xp3[13],(yp3+edtOf)+BS2*19] width:w[9] range:[0,99,(ATfn_.GetINI 0 iniFile "Environment" "ColCorGammaContrast" 1.0)] type:#float scale:0.001 enabled:(ATfn_.GetINI 0 iniFile "Environment" "OnOffState" false) tooltip:tt_spnr_CCGammaContrast
spinner spnr_EnvironmentCCRGB "" pos:[xp3[14],(yp3+edtOf)+BS2*19] width:w[10] range:[0,999,(ATfn_.GetINI 0 iniFile "Environment" "ColCorRGB" 100)] type:#float scale:0.1 enabled:(ATfn_.GetINI 0 iniFile "Environment" "OnOffState" false) tooltip:tt_spnr_CCRGB
button btn_EnvironmentMapType "" pos:[xp3[15],yp3+BS2*19] width:w[11] height:18 enabled:false tooltip:tt_btn_MapType
button btn_EnvironmentMapSize "" pos:[xp3[16],yp3+BS2*19] width:w[12] height:18 enabled:false tooltip:tt_btn_MapSize
checkButton chbtn_EnvironmentCompos "C" pos:[xp3[17],yp3+BS2*19] width:w[1] height:18 checked:(if (ATfn_.GetINI 0 iniFile "Environment" "OnOffState" false) then (ATfn_.GetINI 0 iniFile "Environment" "CompositeState" false) else (false)) highlightColor:colCHBX enabled:(ATfn_.GetINI 0 iniFile "Environment" "OnOffState" false) tooltip:tt_chbtn_Compos

dropdownlist ddl_BRDFtype items:#("Phong", "Blinn", "Ward", "Microfacet GTR (GGX)") pos:[8,yp3+1+BS2*20+ddlOf] width:138 height:5 selection:(ATfn_.GetINI 0 iniFile "VRayMaterial" "BRDFtype" 4) enabled:true tooltip:"VRay Material BRDF type"
radiobuttons rdbtn_GlossiOrRough "" labels:#("Use Glossiness","Use Roughness") pos:[155,yp3+3+BS2*20] columns:2 offsets:#([0,0],[0,0]) default:(ATfn_.GetINI 0 iniFile "VRayMaterial" "GlossiOrRough" 1)

button btn_SaveSettings "Save settings" pos:[850,yp3+2+BS2*20] width:74 height:18 tooltip:" Save text filds, checkboxs \n and checkbuttons state \n in working .ini file"
button btn_SaveINI "Save Preset" pos:[926,yp3+2+BS2*20] width:66 height:18 tooltip:" Lmb - Save working .ini file as\n Rmb - Open ini file directory"
button btn_LoadINI "Load Preset" pos:[994,yp3+2+BS2*20] width:66 height:18 tooltip:" Load settings ini file \n as working .ini file "

progressBar prgrs_FromObjMode pos:[8,yp3+3+BS2*21] width:(roll0W-15) height:10 value:0 color:orange
local ft = 3 ---  sec
timer tmr_prgrsFade interval:((ft*1000/68) as integer) active:false
	-----Locals-------------------------------------------------------------------------------------------------------
local noTex = "          T   e   x   t   u   r   e   s       n   o   t       f   o   u   n   d"
	-----ControlArrays-------------------------------------------------------------------------------------------------
local chbtnSearchFildsArr = #(chbtn_SearchFild1, chbtn_SearchFild2, chbtn_SearchFild3, chbtn_SearchFild4, chbtn_SearchFild5, chbtn_SearchFild6, chbtn_SearchFild7, chbtn_SearchFild8)
local chbtnObjectFildsArr = #(chbtn_ObjectFild1, chbtn_ObjectFild2, chbtn_ObjectFild3, chbtn_ObjectFild4, chbtn_ObjectFild5, chbtn_ObjectFild6, chbtn_ObjectFild7, chbtn_ObjectFild8)
local chbtnLayerFildsArr = #(chbtn_LayerFild1, chbtn_LayerFild2, chbtn_LayerFild3, chbtn_LayerFild4, chbtn_LayerFild5, chbtn_LayerFild6, chbtn_LayerFild7, chbtn_LayerFild8)
local chbtnMaterialFildsArr = #(chbtn_MaterialFild1, chbtn_MaterialFild2, chbtn_MaterialFild3, chbtn_MaterialFild4, chbtn_MaterialFild5, chbtn_MaterialFild6, chbtn_MaterialFild7, chbtn_MaterialFild8)
local ddlFildsArr = #(ddl_Fild_01, ddl_Fild_02, ddl_Fild_03, ddl_Fild_04, ddl_Fild_05, ddl_Fild_06, ddl_Fild_07, ddl_Fild_08)
local edtFildsArr = #(edt_Fild_01, edt_Fild_02, edt_Fild_03, edt_Fild_04, edt_Fild_05, edt_Fild_06, edt_Fild_07, edt_Fild_08)
local MapTypeNamesArr = #("Diffuse", "Roughness", "SelfIllum", "Reflect", "HGlossiness", "RGlossiness", "FresnelIOR", "Metalness", "Anisotropy", "AnRotation", "Refract", "Glossiness", "IOR", "Translucent", "FogColor", "Normal", "Bump", "Displace", "Opacity", "Environment")
local chbtnStateArr = #(chbtn_DiffuseState, chbtn_RoughnessState, chbtn_SelfIllumState, chbtn_ReflectState, chbtn_HGlossinessState, chbtn_RGlossinessState, chbtn_FresnelIORState, chbtn_MetalnessState, chbtn_AnisotropyState, chbtn_AnRotationState, chbtn_RefractState, chbtn_GlossinessState, chbtn_IORState, chbtn_TranslucentState, chbtn_FogColorState, chbtn_NormalState, chbtn_BumpState,	chbtn_DisplaceState, chbtn_OpacityState, chbtn_EnvironmentState)
local ddlSearchNameArr = #(ddl_DiffuseSearchName, ddl_RoughnessSearchName, ddl_SelfIllumSearchName, ddl_ReflectSearchName, ddl_HGlossinessSearchName, ddl_RGlossinessSearchName, ddl_FresnelIORSearchName, ddl_MetalnessSearchName, ddl_AnisotropySearchName, ddl_AnRotationSearchName, ddl_RefractSearchName, ddl_GlossinessSearchName, ddl_IORSearchName, ddl_TranslucentSearchName, ddl_FogColorSearchName, ddl_NormalSearchName, ddl_BumpSearchName,	ddl_DisplaceSearchName, ddl_OpacitySearchName, ddl_EnvironmentSearchName)
local edtSearchNameArr = #(edt_DiffuseSearchName, edt_RoughnessSearchName, edt_SelfIllumSearchName, edt_ReflectSearchName, edt_HGlossinessSearchName, edt_RGlossinessSearchName, edt_FresnelIORSearchName, edt_MetalnessSearchName, edt_AnisotropySearchName, edt_AnRotationSearchName, edt_RefractSearchName, edt_GlossinessSearchName, edt_IORSearchName, edt_TranslucentSearchName, edt_FogColorSearchName, edt_NormalSearchName, edt_BumpSearchName,	edt_DisplaceSearchName, edt_OpacitySearchName, edt_EnvironmentSearchName)
local chbtnStatusArr = #(chbtn_DiffuseStatus, chbtn_RoughnessStatus, chbtn_SelfIllumStatus, chbtn_ReflectStatus, chbtn_HGlossinessStatus, chbtn_RGlossinessStatus, chbtn_FresnelIORStatus, chbtn_MetalnessStatus, chbtn_AnisotropyStatus, chbtn_AnRotationStatus, chbtn_RefractStatus, chbtn_GlossinessStatus, chbtn_IORStatus, chbtn_TranslucentStatus, chbtn_FogColorStatus, chbtn_NormalStatus, chbtn_BumpStatus,	chbtn_DisplaceStatus, chbtn_OpacityStatus, chbtn_EnvironmentStatus)
local ddlTextureArr = #(ddl_DiffuseTexture, ddl_RoughnessTexture, ddl_SelfIllumTexture, ddl_ReflectTexture, ddl_HGlossinessTexture, ddl_RGlossinessTexture, ddl_FresnelIORTexture, ddl_MetalnessTexture, ddl_AnisotropyTexture, ddl_AnRotationTexture, ddl_RefractTexture, ddl_GlossinessTexture, ddl_IORTexture, ddl_TranslucentTexture, ddl_FogColorTexture, ddl_NormalTexture, ddl_BumpTexture,	ddl_DisplaceTexture, ddl_OpacityTexture, ddl_EnvironmentTexture)
local btnBrowseArr = #(btn_DiffuseBrowse, btn_RoughnessBrowse, btn_SelfIllumBrowse, btn_ReflectBrowse, btn_HGlossinessBrowse, btn_RGlossinessBrowse, btn_FresnelIORBrowse, btn_MetalnessBrowse, btn_AnisotropyBrowse, btn_AnRotationBrowse, btn_RefractBrowse, btn_GlossinessBrowse, btn_IORBrowse, btn_TranslucentBrowse, btn_FogColorBrowse, btn_NormalBrowse, btn_BumpBrowse,	btn_DisplaceBrowse, btn_OpacityBrowse, btn_EnvironmentBrowse)
local ddlLoaderArr = #(ddl_DiffuseLoader, ddl_RoughnessLoader, ddl_SelfIllumLoader, ddl_ReflectLoader, ddl_HGlossinessLoader, ddl_RGlossinessLoader, ddl_FresnelIORLoader, ddl_MetalnessLoader, ddl_AnisotropyLoader, ddl_AnRotationLoader, ddl_RefractLoader, ddl_GlossinessLoader, ddl_IORLoader, ddl_TranslucentLoader, ddl_FogColorLoader, ddl_NormalLoader, ddl_BumpLoader,	ddl_DisplaceLoader, ddl_OpacityLoader, ddl_EnvironmentLoader)
local colorCoColorArr = #(color_DiffuseCoColor, color_RoughnessCoColor, color_SelfIllumCoColor, color_ReflectCoColor, color_HGlossinessCoColor, color_RGlossinessCoColor, color_FresnelIORCoColor, color_MetalnessCoColor, color_AnisotropyCoColor, color_AnRotationCoColor, color_RefractCoColor, color_GlossinessCoColor, color_IORCoColor, color_TranslucentCoColor, color_FogColorCoColor, color_NormalCoColor, color_BumpCoColor,	color_DisplaceCoColor, color_OpacityCoColor, color_EnvironmentCoColor)
local spnrTilingUArr = #(spnr_DiffuseTilingU, spnr_RoughnessTilingU, spnr_SelfIllumTilingU, spnr_ReflectTilingU, spnr_HGlossinessTilingU, spnr_RGlossinessTilingU, spnr_FresnelIORTilingU, spnr_MetalnessTilingU, spnr_AnisotropyTilingU, spnr_AnRotationTilingU, spnr_RefractTilingU, spnr_GlossinessTilingU, spnr_IORTilingU, spnr_TranslucentTilingU, spnr_FogColorTilingU, spnr_NormalTilingU, spnr_BumpTilingU,	spnr_DisplaceTilingU, spnr_OpacityTilingU, spnr_EnvironmentTilingU)
local spnrTilingVArr = #(spnr_DiffuseTilingV, spnr_RoughnessTilingV, spnr_SelfIllumTilingV, spnr_ReflectTilingV, spnr_HGlossinessTilingV, spnr_RGlossinessTilingV, spnr_FresnelIORTilingV, spnr_MetalnessTilingV, spnr_AnisotropyTilingV, spnr_AnRotationTilingV, spnr_RefractTilingV, spnr_GlossinessTilingV, spnr_IORTilingV, spnr_TranslucentTilingV, spnr_FogColorTilingV, spnr_NormalTilingV, spnr_BumpTilingV,	spnr_DisplaceTilingV, spnr_OpacityTilingV, spnr_EnvironmentTilingV)
local ddlHDRIColSpArr = #(ddl_DiffuseHDRIColSp, ddl_RoughnessHDRIColSp, ddl_SelfIllumHDRIColSp, ddl_ReflectHDRIColSp, ddl_HGlossinessHDRIColSp, ddl_RGlossinessHDRIColSp, ddl_FresnelIORHDRIColSp, ddl_MetalnessHDRIColSp, ddl_AnisotropyHDRIColSp, ddl_AnRotationHDRIColSp, ddl_RefractHDRIColSp, ddl_GlossinessHDRIColSp, ddl_IORHDRIColSp, ddl_TranslucentHDRIColSp, ddl_FogColorHDRIColSp, ddl_NormalHDRIColSp, ddl_BumpHDRIColSp,	ddl_DisplaceHDRIColSp, ddl_OpacityHDRIColSp, ddl_EnvironmentHDRIColSp)
local chbtnColCorArr = #(chbtn_DiffuseColCor, chbtn_RoughnessColCor, chbtn_SelfIllumColCor, chbtn_ReflectColCor, chbtn_HGlossinessColCor, chbtn_RGlossinessColCor, chbtn_FresnelIORColCor, chbtn_MetalnessColCor, chbtn_AnisotropyColCor, chbtn_AnRotationColCor, chbtn_RefractColCor, chbtn_GlossinessColCor, chbtn_IORColCor, chbtn_TranslucentColCor, chbtn_FogColorColCor, chbtn_NormalColCor, chbtn_BumpColCor,	chbtn_DisplaceColCor, chbtn_OpacityColCor, chbtn_EnvironmentColCor)
local spnrCCGammaContrastArr = #(spnr_DiffuseCCGammaContrast, spnr_RoughnessCCGammaContrast, spnr_SelfIllumCCGammaContrast, spnr_ReflectCCGammaContrast, spnr_HGlossinessCCGammaContrast, spnr_RGlossinessCCGammaContrast, spnr_FresnelIORCCGammaContrast, spnr_MetalnessCCGammaContrast, spnr_AnisotropyCCGammaContrast, spnr_AnRotationCCGammaContrast, spnr_RefractCCGammaContrast, spnr_GlossinessCCGammaContrast, spnr_IORCCGammaContrast, spnr_TranslucentCCGammaContrast, spnr_FogColorCCGammaContrast, spnr_NormalCCGammaContrast, spnr_BumpCCGammaContrast,	spnr_DisplaceCCGammaContrast, spnr_OpacityCCGammaContrast, spnr_EnvironmentCCGammaContrast)
local spnrCCRGBArr = #(spnr_DiffuseCCRGB, spnr_RoughnessCCRGB, spnr_SelfIllumCCRGB, spnr_ReflectCCRGB, spnr_HGlossinessCCRGB, spnr_RGlossinessCCRGB, spnr_FresnelIORCCRGB, spnr_MetalnessCCRGB, spnr_AnisotropyCCRGB, spnr_AnRotationCCRGB, spnr_RefractCCRGB, spnr_GlossinessCCRGB, spnr_IORCCRGB, spnr_TranslucentCCRGB, spnr_FogColorCCRGB, spnr_NormalCCRGB, spnr_BumpCCRGB,	spnr_DisplaceCCRGB, spnr_OpacityCCRGB, spnr_EnvironmentCCRGB)
local btnMapTypeArr = #(btn_DiffuseMapType, btn_RoughnessMapType, btn_SelfIllumMapType, btn_ReflectMapType, btn_HGlossinessMapType, btn_RGlossinessMapType, btn_FresnelIORMapType, btn_MetalnessMapType, btn_AnisotropyMapType, btn_AnRotationMapType, btn_RefractMapType, btn_GlossinessMapType, btn_IORMapType, btn_TranslucentMapType, btn_FogColorMapType, btn_NormalMapType, btn_BumpMapType,	btn_DisplaceMapType, btn_OpacityMapType, btn_EnvironmentMapType)
local btnMapSizeArr = #(btn_DiffuseMapSize, btn_RoughnessMapSize, btn_SelfIllumMapSize, btn_ReflectMapSize, btn_HGlossinessMapSize, btn_RGlossinessMapSize, btn_FresnelIORMapSize, btn_MetalnessMapSize, btn_AnisotropyMapSize, btn_AnRotationMapSize, btn_RefractMapSize, btn_GlossinessMapSize, btn_IORMapSize, btn_TranslucentMapSize, btn_FogColorMapSize, btn_NormalMapSize, btn_BumpMapSize,	btn_DisplaceMapSize, btn_OpacityMapSize, btn_EnvironmentMapSize)
local chbtnComposArr = #(chbtn_DiffuseCompos, chbtn_RoughnessCompos, chbtn_SelfIllumCompos, chbtn_ReflectCompos, chbtn_HGlossinessCompos, chbtn_RGlossinessCompos, chbtn_FresnelIORCompos, chbtn_MetalnessCompos, chbtn_AnisotropyCompos, chbtn_AnRotationCompos, chbtn_RefractCompos, chbtn_GlossinessCompos, chbtn_IORCompos, chbtn_TranslucentCompos, chbtn_FogColorCompos, chbtn_NormalCompos, chbtn_BumpCompos,	chbtn_DisplaceCompos, chbtn_OpacityCompos, chbtn_EnvironmentCompos)
local chbtnOCIOArr = #(chbtn_DiffuseOCIO, chbtn_RoughnessOCIO, chbtn_SelfIllumOCIO, chbtn_ReflectOCIO, chbtn_HGlossinessOCIO, chbtn_RGlossinessOCIO, chbtn_FresnelIOROCIO, chbtn_MetalnessOCIO, chbtn_AnisotropyOCIO, chbtn_AnRotationOCIO, chbtn_RefractOCIO, chbtn_GlossinessOCIO, chbtn_IOROCIO, chbtn_TranslucentOCIO, chbtn_FogColorOCIO, chbtn_NormalOCIO, chbtn_BumpOCIO,	chbtn_DisplaceOCIO, chbtn_OpacityOCIO, chbtn_EnvironmentOCIO)
	-----ControlArrays-------------------------------------------------------------------------------------------------
	-----fn------------------------------------------------------------------------------------------------------------
FN fn_setHighlightColor chbtn col = (chbtn.highlightColor = col; chbtn.checked = not chbtn.checked; chbtn.checked = not chbtn.checked)
	-----fn------------------------------------------------------------------------------------------------------------
FN fn_setArrayHighlightColor Arr col = (for chbtn_ in Arr do chbtn_.highlightColor = col; for chbtn_ in Arr do (chbtn_.checked = not chbtn_.checked; chbtn_.checked = not chbtn_.checked))
	-----fn------------------------------------------------------------------------------------------------------------
-- FN fn_nameRistrictSymbols arg = (substituteString (substituteString arg " " "") "\\" "")
FN fn_nameRistrictSymbols arg = trimright arg "\ ?????????????????????????????????????????????????????????????????????????"
	-----fn------------------------------------------------------------------------------------------------------------
FN fn_ddlWidthStatic ddl wdth = (if (windows.sendmessage ddl.hwnd[1] 351 0 0) < wdth then (windows.sendmessage ddl.hwnd[1] 352 wdth 0))
	-----fn------------------------------------------------------------------------------------------------------------
FN fn_compareCount objct1 objct2 =
(
local difference = (objct2.count)-(objct1.count)
case of
	(
	(difference < 0.): -1
	(difference > 0.): 1
	default: 0
	)
)
	-----fn------------------------------------------------------------------------------------------------------------
FN fn_Delim = (if chbtn_Separator.checked then (ATfn_.GetINI 1 iniFile "Separators" "Separator_Current" "_") else (""))
	-----fn------------------------------------------------------------------------------------------------------------
FN fn_fromFilds_SearchNameArr =
(
local SearchArr =#()
for n=1 to edtFildsArr.count do (if (chbtnSearchFildsArr[n].checked == true and edtFildsArr[n].text != "") then (append SearchArr edtFildsArr[n].text))
qSort SearchArr fn_compareCount
return SearchArr
)
	-----fn------------------------------------------------------------------------------------------------------------
FN fn_fromFilds_ObjectName =
(
local NamesArr = #()
for n=1 to edtFildsArr.count do (if (chbtnObjectFildsArr[n].checked == true and edtFildsArr[n].text != "") then (append NamesArr edtFildsArr[n].text))
local tempName = ""
for n in NamesArr do (tempName += (fn_Delim()) + n)
return (if NamesArr.count != 0 then (if (fn_Delim()=="") then (tempName) else (replace tempName 1 ((fn_Delim()).count) "")) else (""))
)
	-----fn------------------------------------------------------------------------------------------------------------
FN fn_fromFilds_LayerName =
(
local NamesArr = #()
for n=1 to edtFildsArr.count do (if (chbtnLayerFildsArr[n].checked == true and edtFildsArr[n].text != "") then (append NamesArr edtFildsArr[n].text))
local tempName = ""
for n in NamesArr do (tempName += (fn_Delim()) + n)
return (if NamesArr.count != 0 then (if (fn_Delim()=="") then (tempName) else (replace tempName 1 ((fn_Delim()).count) "")) else (""))
)
	-----fn------------------------------------------------------------------------------------------------------------
FN fn_fromFilds_MaterialName =
(
local NamesArr = #()
for n=1 to edtFildsArr.count do (if (chbtnMaterialFildsArr[n].checked == true and edtFildsArr[n].text != "") then (append NamesArr edtFildsArr[n].text))
local tempName = ""
for n in NamesArr do (tempName += (fn_Delim()) + n)
return (if NamesArr.count != 0 then (if (fn_Delim()=="") then (tempName) else (replace tempName 1 ((fn_Delim()).count) "")) else ("Unnamed"))
)
	-----fn------------------------------------------------------------------------------------------------------------
FN fn_fromObject_SearchNameArr objct =
(
local SearchArr =#()
local objNameArr = filterString (ATfn_.RemoveCounter objct.name) (ATfn_.GetINI 1 iniFile "Separators" "Separator_Current" "_")
for n=1 to objNameArr.count do (if (chbtnSearchFildsArr[n].checked == true) then (append SearchArr objNameArr[n]))
qSort SearchArr fn_compareCount
return SearchArr
)
	-----fn------------------------------------------------------------------------------------------------------------
FN fn_fromObject_SearchName objct =
(
local NamesArr = #()
local objNameArr = filterString (ATfn_.RemoveCounter objct.name) (ATfn_.GetINI 1 iniFile "Separators" "Separator_Current" "_")
for n=1 to objNameArr.count do (if (chbtnSearchFildsArr[n].checked == true) then (append NamesArr objNameArr[n]))
local tempName = ""
for n in NamesArr do (tempName += (fn_Delim()) + n)
return (if NamesArr.count != 0 then (if (fn_Delim()=="") then (tempName) else (replace tempName 1 ((fn_Delim()).count) "")) else (""))
)
	-----fn------------------------------------------------------------------------------------------------------------
FN fn_fromObject_ObjectName objct =
(
local NamesArr = #()
local objNameArr = filterString (ATfn_.RemoveCounter objct.name) (ATfn_.GetINI 1 iniFile "Separators" "Separator_Current" "_")
for n=1 to objNameArr.count do (if (chbtnObjectFildsArr[n].checked == true) then (append NamesArr objNameArr[n]))
local tempName = ""
for n in NamesArr do (tempName += (fn_Delim()) + n)
return (if NamesArr.count != 0 then (if (fn_Delim()=="") then (tempName) else (replace tempName 1 ((fn_Delim()).count) "")) else (""))
)
	-----fn------------------------------------------------------------------------------------------------------------
FN fn_fromObject_LayerName objct =
(
local NamesArr = #()
local objNameArr = filterString (ATfn_.RemoveCounter objct.name) (ATfn_.GetINI 1 iniFile "Separators" "Separator_Current" "_")
for n=1 to objNameArr.count do (if (chbtnLayerFildsArr[n].checked == true) then (append NamesArr objNameArr[n]))
local tempName = ""
for n in NamesArr do (tempName += (fn_Delim()) + n)
return (if NamesArr.count != 0 then (if (fn_Delim()=="") then (tempName) else (replace tempName 1 ((fn_Delim()).count) "")) else (""))
)
	-----fn------------------------------------------------------------------------------------------------------------
FN fn_fromObject_MaterialName objct =
(
local NamesArr = #()
local objNameArr = filterString (ATfn_.RemoveCounter objct.name) (ATfn_.GetINI 1 iniFile "Separators" "Separator_Current" "_")
for n=1 to objNameArr.count do (if (chbtnMaterialFildsArr[n].checked == true) then (append NamesArr objNameArr[n]))
local tempName = ""
for n in NamesArr do (tempName += (fn_Delim()) + n)
return (if NamesArr.count != 0 then (if (fn_Delim()=="") then (tempName) else (replace tempName 1 ((fn_Delim()).count) "")) else (ATfn_.RemoveCounter objct.name))
)
	-----fn------------------------------------------------------------------------------------------------------------
FN fn_mapsSearchNoNamesCheck =
(
local CheckState = true
for n=1 to 20 where (chbtnStateArr[n].checked and edtSearchNameArr[n].text != "") do CheckState = false
return CheckState
)
	-----fn-----------------------------------------------------------------------------------------------------SOLM-
FN fn_SOLMClear = 
(
Sstate = chbtnSearchFildsArr[1].checked
for chbtn in chbtnSearchFildsArr do (chbtn.checked = not Sstate)
for chbtn in chbtnObjectFildsArr do (chbtn.checked = not Sstate)
for chbtn in chbtnLayerFildsArr do (chbtn.checked = not Sstate)
for chbtn in chbtnMaterialFildsArr do (chbtn.checked = not Sstate)
)
	-----fn-----------------------------------------------------------------------------------------------------SOLM-
FN fn_chbtnObjectFild n = (if selection.count > 0 then (edtFildsArr[n].text = selection[1].name) else (messageBox "Object not selected.\n\n Can not get name." title:"No selection" beep:false))
	-----fn-----------------------------------------------------------------------------------------------------SOLM-
FN fn_chbtnLayerFild n = (if selection.count > 0 then (edtFildsArr[n].text = selection[1].layer.name) else (messageBox "Object not selected.\n\n Can not get name." title:"No selection" beep:false))
	-----fn-----------------------------------------------------------------------------------------------------SOLM-
FN fn_chbtnMaterialFild n = 
(
if MatEditor.isOpen()
then (edtFildsArr[n].text = meditMaterials[activeMeditSlot].name)
else 
	(
	if selection.count > 0
	then 
		(
		if selection[1].material != undefined
		then (edtFildsArr[n].text = selection[1].material.name)
		else (messageBox "Object material undefined." title:"Undefined" beep:false)
		)
	else (messageBox "Object not selected.\n\n Can not get name." title:"No selection" beep:false)
	)
)
	-----fn-----------------------------------------------------------------------------------------------------FILDS-
FN fn_ddlFild_LMB n item =
(
if keyboard.altPressed
	then
		(
		local FildArr = ddlFildsArr[n].items
		if FildArr[item] != "" then
			(
			deleteItem FildArr item
			ddlFildsArr[n].items = FildArr
			edtFildsArr[n].text = ""
			setFocus edtFildsArr[n]
			)
		)
	else
		(
		edtFildsArr[n].text = (ddlFildsArr[n].items)[item]
		try (setFocus edtFildsArr[n+1]) catch ()
		)
)
	-----fn-----------------------------------------------------------------------------------------------------FILDS-
FN fn_ddlFild_RMB n =
(
if keyboard.altPressed
	then
		(
		local FildArr = ddlFildsArr[n].items
		appendIfUnique FildArr edtFildsArr[n].text
		sort FildArr
		ddlFildsArr[n].items = FildArr
		setFocus edtFildsArr[n]
		)
	else
		(
		edtFildsArr[n].text = ""
		setFocus edtFildsArr[n]
		)
)
	-----fn------------------------------------------------------------------------------------------------------------
FN fn_slashReplacePathL mDir =
	(
	if mDir.count == 3 then ( for w = 1 to mDir.count do (if mDir[w] == "\\" then (mDir = replace mDir w 1 "/")) )
	return mDir
	)
	-----fn------------------------------------------------------------------------------------------------------------
FN fn_slashReplaceR inArr =
	(
	tempArr = #()
	for proDir in inArr do ( for w = 1 to proDir.count do (if proDir[w] == "/" then (proDir = replace proDir w 1 "\\")); appendIfUnique tempArr proDir )
	return tempArr
	)
	-----fn------------------------------------------------------------------------------------------------------------
FN fn_deleteSubdirs rootsArr =
	(
	tempArr = #()
	for proDir in rootsArr do ( for w = 1 to proDir.count do (if proDir[w] == "/" then (proDir = replace proDir w 1 "\\")); appendIfUnique tempArr proDir )
	rootsArrCopy = deepcopy tempArr
	finArr = deepcopy tempArr
	for curDir in tempArr do (for nDir in rootsArrCopy where ((matchPattern nDir pattern:(curDir+"*")) and (nDir != curDir)) do (try (deleteItem finArr (findItem finArr nDir)) catch()))
	return finArr
	)
	-----fn------------------------------------------------------------------------------------------------------------
FN fn_dotNetCollectFiles foldersArr: pattern: extensions: =
(
local filesArr = #()
local deniedArr = #()
local deniedArrTemp = #()
local deniedArrProcess = deepCopy foldersArr
local deniedArrProcessTemp = #()
do
(
-- windows.processPostedMessages()
deniedArrProcessTemp = #()
deniedArrTemp = #()
for folder in deniedArrProcess do
	(
	try
		(
		windows.processPostedMessages()
		local allFiles = (dotNetClass "System.IO.Directory").GetFiles folder ("*"+pattern+"*") ((dotNetClass "System.IO.SearchOption").AllDirectories)
		for f in allFiles where ( findItem extensions (tolower (getfilenametype f)) ) > 0 do (appendIfUnique filesArr f)
		)
	catch (appendIfUnique deniedArrTemp folder)
	)
for deniedDir in deniedArrTemp do 
	(
	local subDirsArr = GetDirectories (deniedDir+"\*")
	if subDirsArr.count == 0 then (appendIfUnique deniedArr deniedDir) else (for dir in subDirsArr do (appendIfUnique deniedArrProcessTemp dir))
	)
deniedArrProcess = deepCopy deniedArrProcessTemp
)
while (deniedArrTemp.count > 0)
sort deniedArr
return #(filesArr,deniedArr)
)
	-----fn------------------------------------------------------------------------------------------------------------
FN fn_getTexExtSize n ExtState SizeState =
(
try
	(
	local imgFile = (ddlTextureArr[n].items)[ddlTextureArr[n].selection]
	if ExtState then
		(
		if imgFile == noTex
		then (btnMapTypeArr[n].caption = "---")
		else (btnMapTypeArr[n].caption = getFilenameType imgFile)
		)
	if SizeState then
		(
		if imgFile == noTex
		then (btnMapSizeArr[n].caption = "---")
		else 
			(
			imgInfo = getBitmapInfo imgFile
			btnMapSizeArr[n].caption = (imgInfo[3] as string)
			btnMapSizeArr[n].tooltip = "Width: "+(imgInfo[3] as string)+"\nHeight: "+(imgInfo[4] as string)
			)
		)
-- 	) catch (btnMapTypeArr[n].caption = ""; btnMapSizeArr[n].caption = ""; btnMapSizeArr[n].tooltip = tt_btn_MapSize)
	) catch ()
)
	-----fn--------------------------------------------------------------------------------------------MAPS----------
FN fn_chbtnState n theState =
(
chbtnStatusArr[n].checked=ddlSearchNameArr[n].enabled=edtSearchNameArr[n].enabled=ddlTextureArr[n].enabled=btnBrowseArr[n].enabled=ddlLoaderArr[n].enabled=theState
colorCoColorArr[n].enabled=spnrTilingUArr[n].enabled=spnrTilingVArr[n].enabled=ddlHDRIColSpArr[n].enabled=chbtnColCorArr[n].enabled=spnrCCGammaContrastArr[n].enabled=theState
spnrCCRGBArr[n].enabled=btnMapTypeArr[n].enabled=btnMapSizeArr[n].enabled=chbtnComposArr[n].enabled=chbtnOCIOArr[n].enabled=theState
if chbtn_FromObjMode.checked then chbtnStatusArr[n].enabled=false else chbtnStatusArr[n].enabled=theState
if ((ddlTextureArr[n].items).count==0 or (ddlTextureArr[n].items)[1]==noTex) then (ddlTextureArr[n].enabled=btnMapTypeArr[n].enabled=btnMapSizeArr[n].enabled=false)
if theState
then
	(
	chbtnColCorArr[n].checked = (ATfn_.GetINI 0 iniFile MapTypeNamesArr[n] "ColorCorrectState" false)
	chbtnComposArr[n].checked = (ATfn_.GetINI 0 iniFile MapTypeNamesArr[n] "CompositeState" false)
	chbtnOCIOArr[n].checked = (ATfn_.GetINI 0 iniFile MapTypeNamesArr[n] "OCIOState" false)
	)
else (chbtnColCorArr[n].checked = chbtnComposArr[n].checked = chbtnOCIOArr[n].checked = false)
)
	-----fn--------------------------------------------------------------------------------------------MAPS----------
FN fn_ddlSearchName_LMB n item =
(
if keyboard.altPressed
	then
		(
		local savedNamesArr = ddlSearchNameArr[n].items
		if savedNamesArr[item] != "" then
			(
			deleteItem savedNamesArr item
			ddlSearchNameArr[n].items = deepCopy savedNamesArr
			)
		)
	else
		(
		edtSearchNameArr[n].text = (ddlSearchNameArr[n].items)[item]
		)
)
	-----fn--------------------------------------------------------------------------------------------MAPS----------
FN fn_ddlSearchName_RMB n =
(
if keyboard.altPressed
	then
		(
		local savedNamesArr = ddlSearchNameArr[n].items
		appendIfUnique savedNamesArr edtSearchNameArr[n].text
		sort savedNamesArr
		ddlSearchNameArr[n].items = deepCopy savedNamesArr
		setFocus edtSearchNameArr[n]
		)
	else
		(
		edtSearchNameArr[n].text = ""
		setFocus edtSearchNameArr[n]
		)
)
	-----fn--------------------------------------------------------------------------------------------MAPS----------
FN fn_chbtnSearch_LMB n =
(
local startTime = timeStamp()
local ddlRootsItems
if chbtn_MultiStatus.checked then (ddlRootsItems = fn_deleteSubdirs (ddl_Roots.items)) else (try (ddlRootsItems = #((ddl_Roots.items)[ddl_Roots.selection])) catch (ddlRootsItems = #()))
ddlRootsItems = fn_slashReplaceR ddlRootsItems
local mainNameArr = fn_fromFilds_SearchNameArr()
local tempMNArr = #()
if chbtn_SpecialRule.checked then (for mn in mainNameArr do (appendIfUnique tempMNArr (substituteString edt_SpecialRule.text "#" mn)); mainNameArr = tempMNArr)
local filesArr = #()
local deniedArr = #()
if ddlRootsItems.count != 0
then 
	(
	if mainNameArr.count != 0
	then
		(
		if mainNameArr.count == 1
		then
			(
			collectResult = fn_dotNetCollectFiles foldersArr:ddlRootsItems pattern:(mainNameArr[1]) extensions:(ATfn_.GetINI 0 iniFile "Settings" "TypesOfExtensionForSearch" #(".jpg"))
			deniedArr = deepCopy collectResult[2]
			mainFilesArr = deepCopy collectResult[1]
			if edtSearchNameArr[n].text != ""
			then (filesArr = for filePath in mainFilesArr where ( matchPattern (getFilenameFile filePath) pattern:("*"+(edtSearchNameArr[n].text)+"*") ) collect filePath)
			else (filesArr = deepCopy mainFilesArr)
			)
		else
			(
			local operatingArr = #()
			collectResult = fn_dotNetCollectFiles foldersArr:ddlRootsItems pattern:(mainNameArr[1]) extensions:(ATfn_.GetINI 0 iniFile "Settings" "TypesOfExtensionForSearch" #(".jpg"))
			deniedArr = deepCopy collectResult[2]
			mainFilesArr = deepCopy collectResult[1]
			for mN=2 to mainNameArr.count do
				(
				filesArr = for filePath in mainFilesArr where ( matchPattern (getFilenameFile filePath) pattern:("*"+(mainNameArr[mN])+"*") ) collect filePath
				mainFilesArr = filesArr
				)
			if edtSearchNameArr[n].text != ""
			then (filesArr = for filePath in mainFilesArr where ( matchPattern (getFilenameFile filePath) pattern:("*"+(edtSearchNameArr[n].text)+"*") ) collect filePath)
			else (filesArr = deepCopy mainFilesArr)
			)
			--------------------------
		if deniedArr.count != 0
		then
			(
			clearlistener()
			for dir in deniedArr do (format "!!!  Access denied:   %\n" dir)
			)
		if filesArr.count != 0
		then
			(
			sort filesArr
			ddlTextureArr[n].items = deepCopy filesArr
			local textureSelection = 1
			extPattern = "*"+(ATfn_.GetINI 0 iniFile "Settings" "TypesOfExtensionForSearch" #(".jpg"))[(ATfn_.GetINI 0 iniFile "Settings" "PreferredTextureExtension" 1)]
			for n in filesArr.count to 1 by -1 do (if (matchPattern filesArr[n] pattern:extPattern) then (textureSelection = n))
			ddlTextureArr[n].selection = textureSelection
			if filesArr.count == 1 then (chbtnStatusArr[n].highlightColor = colG) else (chbtnStatusArr[n].highlightColor = colY)
			ddlTextureArr[n].enabled = true; chbtnStatusArr[n].checked = false; chbtnStatusArr[n].checked = true
			fn_getTexExtSize n true true
			btnMapTypeArr[n].enabled = btnMapSizeArr[n].enabled = true
			ATfn_.ddlWidthDynamic ddlTextureArr[n]
			setFocus ddlTextureArr[n]
			)
		else
			(
			ddlTextureArr[n].items = #(noTex)
			ddlTextureArr[n].selection = 1
			chbtnStatusArr[n].highlightColor = colR
			ddlTextureArr[n].enabled = false; chbtnStatusArr[n].checked = false; chbtnStatusArr[n].checked = true
			fn_getTexExtSize n true true
			btnMapTypeArr[n].enabled = btnMapSizeArr[n].enabled = false
			)
		)
	else
		(
		if edtSearchNameArr[n].text != ""
		then
			(
			collectResult = fn_dotNetCollectFiles foldersArr:ddlRootsItems pattern:(edtSearchNameArr[n].text) extensions:(ATfn_.GetINI 0 iniFile "Settings" "TypesOfExtensionForSearch" #(".jpg"))
			deniedArr = deepCopy collectResult[2]
			filesArr = deepCopy collectResult[1]
				--------------------------
			if deniedArr.count != 0
			then
				(
				clearlistener()
				for dir in deniedArr do (format "!!!  Access denied:   %\n" dir)
				)
			if filesArr.count != 0
			then
				(
				sort filesArr
				ddlTextureArr[n].items = deepCopy filesArr
				local textureSelection = 1
				extPattern = "*"+(ATfn_.GetINI 0 iniFile "Settings" "TypesOfExtensionForSearch" #(".jpg"))[(ATfn_.GetINI 0 iniFile "Settings" "PreferredTextureExtension" 1)]
				for n in filesArr.count to 1 by -1 do (if (matchPattern filesArr[n] pattern:extPattern) then (textureSelection = n))
				ddlTextureArr[n].selection = textureSelection
				if filesArr.count == 1 then (chbtnStatusArr[n].highlightColor = colG) else (chbtnStatusArr[n].highlightColor = colY)
				ddlTextureArr[n].enabled = true; chbtnStatusArr[n].checked = false; chbtnStatusArr[n].checked = true
				fn_getTexExtSize n true true
				btnMapTypeArr[n].enabled = btnMapSizeArr[n].enabled = true
				ATfn_.ddlWidthDynamic ddlTextureArr[n]
				setFocus ddlTextureArr[n]
				)
			else
				(
				ddlTextureArr[n].items = #(noTex)
				ddlTextureArr[n].selection = 1
				chbtnStatusArr[n].highlightColor = colR
				ddlTextureArr[n].enabled = false; chbtnStatusArr[n].checked = false; chbtnStatusArr[n].checked = true
				fn_getTexExtSize n true true
				btnMapTypeArr[n].enabled = btnMapSizeArr[n].enabled = false
				)
			)
		else (messageBox "Search filds empty." title:"Search data missing" beep:false)
		)
	)
else (messageBox "List of directories empty." title:"Search data missing" beep:false)
format "Processing took % seconds\n" (filterString (((dotnetclass "TimeSpan").FromMilliseconds (timeStamp() - starttime)).ToString()) ".")[1]
)
	-----fn--------------------------------------------------------------------------------------------MAPS----------
FN fn_mapSearch n rootsItems mnArr mfArr =
(
local denArr = #()
local filesArr = #()
if mnArr.count != 0
then 
	(
	if edtSearchNameArr[n].text != ""
	then (filesArr = for filePath in mfArr where ( matchPattern (getFilenameFile filePath) pattern:("*"+(edtSearchNameArr[n].text)+"*") ) collect filePath)
	else (filesArr = deepCopy mfArr)
	)
else
	(
	if edtSearchNameArr[n].text != ""
	then
		(
		collectResult = fn_dotNetCollectFiles foldersArr:rootsItems pattern:(edtSearchNameArr[n].text) extensions:(ATfn_.GetINI 0 iniFile "Settings" "TypesOfExtensionForSearch" #(".jpg"))
		denArr = deepCopy collectResult[2]
		filesArr = deepCopy collectResult[1]
		)
	else ()
	)
if denArr.count != 0 then (for dir in denArr do (format "!!!  Access denied:   %\n" dir))
if filesArr.count != 0
then
	(
	sort filesArr
	ddlTextureArr[n].items = deepCopy filesArr
	local textureSelection = 1
	extPattern = "*"+(ATfn_.GetINI 0 iniFile "Settings" "TypesOfExtensionForSearch" #(".jpg"))[(ATfn_.GetINI 0 iniFile "Settings" "PreferredTextureExtension" 1)]
	for n in filesArr.count to 1 by -1 do (if (matchPattern filesArr[n] pattern:extPattern) then (textureSelection = n))
	ddlTextureArr[n].selection = textureSelection
	if filesArr.count == 1 then (chbtnStatusArr[n].highlightColor = colG) else (chbtnStatusArr[n].highlightColor = colY)
	ddlTextureArr[n].enabled = true; chbtnStatusArr[n].checked = false; chbtnStatusArr[n].checked = true
	fn_getTexExtSize n true true
	btnMapTypeArr[n].enabled = btnMapSizeArr[n].enabled = true
	ATfn_.ddlWidthDynamic ddlTextureArr[n]
	)
else
	(
	ddlTextureArr[n].items = #(noTex)
	ddlTextureArr[n].selection = 1
	chbtnStatusArr[n].highlightColor = colR
	ddlTextureArr[n].enabled = false; chbtnStatusArr[n].checked = false; chbtnStatusArr[n].checked = true
	fn_getTexExtSize n true true
	btnMapTypeArr[n].enabled = btnMapSizeArr[n].enabled = false
	)
)
	-----fn--------------------------------------------------------------------------------------------MAPS----------
FN fn_chbtnSearch_RMB n =
(
ddlTextureArr[n].items = #()
chbtnStatusArr[n].highlightColor = colZ
ddlTextureArr[n].enabled = false; chbtnStatusArr[n].checked = false; chbtnStatusArr[n].checked = true
btnMapTypeArr[n].caption = btnMapSizeArr[n].caption = ""; btnMapSizeArr[n].tooltip = tt_btn_MapSize
btnMapTypeArr[n].enabled = btnMapSizeArr[n].enabled = false
)
	-----fn----------------------------------------------------------------------------RENAME-CONVERT-RESIZE--------
FN fn_rollRenameConvertResize n =
(
Global _gEP2_mapN = n
if doesFileExist (ddlTextureArr[_gEP2_mapN].selected)
then
(
if ddlTextureArr[n].selection != 0 then
(
rollout rolloutRenConvRes "Rename Convert Resize"
(
edittext edt_RenameText "" text:"" pos:[3,9+edtOf] width:254 height:17 enabled:true
button btn_RenameTexture "Rename" pos:[6,35] width:60 height:26 tooltip:"Rename Texture file"
button btn_ExplorerFolder "Find" pos:[70,35] width:60 height:26 tooltip:"Open Texture file in Explorer Folder"
button btn_AssociatedProgram "Shell" pos:[134,35] width:60 height:26 tooltip:"Open Texture file in Associated Program"
button btn_Photoshop "PS" pos:[198,35] width:60 height:26 tooltip:"Open Texture file in Photoshop"
checkButton razdel1 "" tooltip:"" pos:[3,68] width:258 height:4 highlightColor:[100,100,100] checked:true enabled:false
checkButton razdel2 "" tooltip:"" pos:[130,71] width:4 height:148 highlightColor:[100,100,100] checked:true enabled:false
button btn_ConvertTexture "Convert" pos:[6,76] width:121 height:26 tooltip:"Convert Texture file"
label lbl_ToFormat "Format:" pos:[16,110]
dropdownlist ddl_ConvertExtensions items:#(".avi", ".bmp", ".exr", ".hdr", ".jpeg", ".png", ".mov", ".tga", ".tiff", ".dds") pos:[66,108+ddlOf] width:60 height:33 selection:5 tooltip:"Convert Extensions"
button btn_ConvertOptions "Format  Setup" pos:[6,128] width:121 height:22 enabled:true tooltip:"Convertion format Setup"
button btn_SaveAs "Save As" pos:[6,164] width:121 height:18 tooltip:"Save Texture file with\ncustom Name and Extension\n(Access to all formats setup)"
checkButton chbtn_ConvertAll "" pos:[9,196] width:14 height:14 checked:false highlightColor:colCHBX tooltip:"Convert All active maps"
label lbl_ConvertAll "Convert All maps" pos:[29,196] enabled:true

button btn_ResizeTexture "Resize" pos:[137,76] width:121 height:26 tooltip:"Resize Texture file"
checkButton chbtn_CopyReplace "Copy" pos:[140,107] width:48 height:20 checked:(ATfn_.GetINI 0 iniFile "RenameConvertResize" "CopyReplace_State" false) highlightColor:colCHBX tooltip:"Copy Or Replace Maps"
local ttp_CopyFormula = " Copy Counter Formula \n  W - New Width \n   H - New Height "
edittext edt_CopyFormula text:(ATfn_.GetINI 1 iniFile "RenameConvertResize" "CopyFormula" "") enabled:chbtn_CopyReplace.state pos:[186,107+edtOf] width:70 height:17 enabled:true tooltip:ttp_CopyFormula
checkButton chbtn_LockSize "[" pos:[140,138] width:14 height:22 checked:true enabled:true tooltip:"Lock Size"
label lbl_Width "Width:" pos:[160,131]
spinner spnr_WidthValue "" pos:[201,130] width:55 range:[0,99999,100] type:#integer scale:1 enabled:true tooltip:"Set Width size in Pixels"
label lbl_Height "Height:" pos:[160,152]
spinner spnr_HeightValue "" pos:[201,151] width:55 range:[0,99999,100] type:#integer scale:1 enabled:true tooltip:"Set Height size in Pixels"
checkButton chbtn_PercentState "" pos:[140,173] width:14 height:14 checked:false enabled:true highlightColor:colCHBX tooltip:"Size in Percentages"
label lbl_Percent "Percent:" pos:[160,173] enabled:false
spinner spnr_PercentageSize "" pos:[201,172] width:55 range:[0,99999,100] type:#float scale:1 enabled:false tooltip:"Set Size in Percentages"
checkButton chbtn_ResizeAll "" pos:[140,196] width:14 height:14 checked:false highlightColor:colCHBX tooltip:"Resize All active maps"
label lbl_ResizeAll "Resize All maps" pos:[160,196] enabled:true
	-----Locals-------------------------------------------------------------------------------------------------
local resKoef; local wPers;  local hPers
	-----fn--------------------------------------------------------------------
FN fn_Round val n = (local outVal = (floor ((val * (10.0 ^ n)) + 0.5)) / (10.0 ^ n); if n==0 then (outVal = outVal as integer); return outVal)
	-----fn--------------------------------------------------------------------
on edt_CopyFormula changed txt do (if txt == "" then edt_CopyFormula.text = "_WxH")
	-----------------------------------------------------------
on chbtn_CopyReplace changed state do (edt_CopyFormula.enabled = state)
	-----------------------------------------------------------
on btn_RenameTexture pressed do
	(
	local curTexMap = ddlTextureArr[_gEP2_mapN]; local ddlFilesArr = curTexMap.items; local ddlNSel = curTexMap.selection; local fileNameStr = ddlFilesArr[ddlNSel]
	local newNameStr = ((getFilenamePath fileNameStr) + (edt_RenameText.text) + (getFilenameType fileNameStr))
	renameFile fileNameStr newNameStr
	deleteItem ddlFilesArr ddlNSel
	appendIfUnique ddlFilesArr newNameStr; sort ddlFilesArr
	curTexMap.items = deepCopy ddlFilesArr; curTexMap.selection = findItem ddlFilesArr newNameStr
	ATfn_.ddlWidthDynamic curTexMap
	)
on btn_ExplorerFolder pressed do (shellLaunch "explorer.exe" ("/e,/select,\"" + ((ddlTextureArr[_gEP2_mapN].items)[ddlTextureArr[_gEP2_mapN].selection]) + "\""))
on btn_AssociatedProgram pressed do (shellLaunch ((ddlTextureArr[_gEP2_mapN].items)[ddlTextureArr[_gEP2_mapN].selection]) "")
on btn_Photoshop pressed do (Image_= (ddlTextureArr[_gEP2_mapN].items)[ddlTextureArr[_gEP2_mapN].selection]; PsApp = CreateOLEObject "Photoshop.Application"; PsApp.open Image_; PsApp.bringToFront(); releaseAllOLEObjects())
	-----
on btn_ConvertTexture pressed do
	(
	local convExt = (ddl_ConvertExtensions.items)[ddl_ConvertExtensions.selection]
	if chbtn_ConvertAll.checked
	then
		(
		for ne=1 to 20 where chbtnStateArr[ne].checked do
			(
			local curTexMap = ddlTextureArr[ne]; local ddlFilesArr = curTexMap.items; local ddlNSel = curTexMap.selection; local fileNameStr = ddlFilesArr[ddlNSel]
			if fileNameStr != noTex
			then
				(
				local old_Bitmap = openBitMap fileNameStr; local new_Bitmap = bitmap old_Bitmap.width old_Bitmap.height
				local newBitmapStr = (getFilenamePath fileNameStr)+(getFilenameFile fileNameStr)+convExt
				copy old_Bitmap new_Bitmap; new_Bitmap.filename = newBitmapStr
				save new_Bitmap; close old_Bitmap; close new_Bitmap; free old_Bitmap; free new_Bitmap; freeSceneBitmaps(); for k=1 to 24 do ( mat = medit.GetTopMtlSlot k ; setMTLMeditObjType mat (getMTLMeditObjType mat) )
				appendIfUnique ddlFilesArr newBitmapStr; sort ddlFilesArr
				curTexMap.items = deepCopy ddlFilesArr; curTexMap.selection = findItem ddlFilesArr newBitmapStr
				fn_getTexExtSize ne true false
				if ddlFilesArr.count == 1 then (chbtnStatusArr[ne].highlightColor = colG) else (chbtnStatusArr[ne].highlightColor = colY); chbtnStatusArr[ne].checked = false; chbtnStatusArr[ne].checked = true
				ATfn_.ddlWidthDynamic curTexMap
				)
			)
		)
	else
		(
		local curTexMap = ddlTextureArr[_gEP2_mapN]; local ddlFilesArr = curTexMap.items; local ddlNSel = curTexMap.selection; local fileNameStr = ddlFilesArr[ddlNSel]
		local old_Bitmap = openBitMap fileNameStr; local new_Bitmap = bitmap old_Bitmap.width old_Bitmap.height
		local newBitmapStr = (getFilenamePath fileNameStr)+(getFilenameFile fileNameStr)+convExt
		copy old_Bitmap new_Bitmap; new_Bitmap.filename = newBitmapStr
		save new_Bitmap; close old_Bitmap; close new_Bitmap; free old_Bitmap; free new_Bitmap; freeSceneBitmaps(); for k=1 to 24 do ( mat = medit.GetTopMtlSlot k ; setMTLMeditObjType mat (getMTLMeditObjType mat) )
		appendIfUnique ddlFilesArr newBitmapStr; sort ddlFilesArr
		curTexMap.items = deepCopy ddlFilesArr; curTexMap.selection = findItem ddlFilesArr newBitmapStr
		fn_getTexExtSize _gEP2_mapN true false
		if ddlFilesArr.count == 1 then (chbtnStatusArr[_gEP2_mapN].highlightColor = colG) else (chbtnStatusArr[_gEP2_mapN].highlightColor = colY); chbtnStatusArr[_gEP2_mapN].checked = false; chbtnStatusArr[_gEP2_mapN].checked = true
		ATfn_.ddlWidthDynamic curTexMap
		)
	)
on ddl_ConvertExtensions selected arg do
	(
	case arg of
		(
		1: btn_ConvertOptions.enabled = false
		2: btn_ConvertOptions.enabled = true
		3: btn_ConvertOptions.enabled = false
		4: btn_ConvertOptions.enabled = false
		5: btn_ConvertOptions.enabled = true
		6: btn_ConvertOptions.enabled = true
		7: btn_ConvertOptions.enabled = false
		8: btn_ConvertOptions.enabled = true
		9: btn_ConvertOptions.enabled = true
		10: btn_ConvertOptions.enabled = false
		)
	)
on btn_ConvertOptions pressed do
	(
	case ddl_ConvertExtensions.selection of
		(
		2: ATfn_.SetupBMP()
		5: ATfn_.SetupJPEG()
		6: ATfn_.SetupPNG()
		8: ATfn_.SetupTGA()
		9: ATfn_.SetupTIFF()
		)
	)
on btn_SaveAs pressed do
	(
	local curTexMap = ddlTextureArr[_gEP2_mapN]; local ddlFilesArr = curTexMap.items; local ddlNSel = curTexMap.selection; local fileNameStr = ddlFilesArr[ddlNSel]
	local old_Bitmap = openBitMap fileNameStr; local new_Bitmap = bitmap old_Bitmap.width old_Bitmap.height
	local convExt = (ddl_ConvertExtensions.items)[ddl_ConvertExtensions.selection]
	local newBitmapStr = SelectSaveBitmap caption:"Save as..." gamma:&gma metadata:&data filename:((getFilenamePath fileNameStr)+(getFilenameFile fileNameStr))
	if newBitmapStr != undefined
	then
		(
		copy old_Bitmap new_Bitmap; new_Bitmap.filename = newBitmapStr
		save new_Bitmap; close new_Bitmap; free old_Bitmap; free new_Bitmap; freeSceneBitmaps(); for k=1 to 24 do ( mat = medit.GetTopMtlSlot k ; setMTLMeditObjType mat (getMTLMeditObjType mat) )
		appendIfUnique ddlFilesArr newBitmapStr; sort ddlFilesArr
		curTexMap.items = deepCopy ddlFilesArr; curTexMap.selection = findItem ddlFilesArr newBitmapStr
		if ddlFilesArr.count == 1 then (chbtnStatusArr[_gEP2_mapN].highlightColor = colG) else (chbtnStatusArr[_gEP2_mapN].highlightColor = colY); chbtnStatusArr[_gEP2_mapN].checked = false; chbtnStatusArr[_gEP2_mapN].checked = true
		ATfn_.ddlWidthDynamic curTexMap
		)
	)
	-----
on chbtn_LockSize changed state do
	(
	if state then (spnr_HeightValue.value = fn_Round ((spnr_WidthValue.value) / resKoef) 0; spnr_PercentageSize.value = (spnr_WidthValue.value) / wPers)
	chbtn_PercentState.enabled = state
	chbtn_PercentState.checked = false
	)
on spnr_WidthValue changed arg do (if chbtn_LockSize.checked then (spnr_HeightValue.value = fn_Round (arg / resKoef) 0; spnr_PercentageSize.value = arg / wPers))
on spnr_HeightValue changed arg do (if chbtn_LockSize.checked then (spnr_WidthValue.value = fn_Round (arg * resKoef) 0; spnr_PercentageSize.value = arg / hPers))
on chbtn_PercentState changed state do (lbl_Width.enabled=spnr_WidthValue.enabled=lbl_Height.enabled=spnr_HeightValue.enabled=chbtn_LockSize.enabled=not state; lbl_Percent.enabled=spnr_PercentageSize.enabled=state)
on spnr_PercentageSize changed arg do (spnr_WidthValue.value = fn_Round (wPers * arg) 0; spnr_HeightValue.value = fn_Round (hPers * arg) 0)
on btn_ResizeTexture pressed do 
	(
	if chbtn_ResizeAll.checked
	then
		(
		for ne=1 to 20 where chbtnStateArr[ne].checked do
			(
			local curTexMap = ddlTextureArr[ne]; local ddlFilesArr = curTexMap.items; local ddlNSel = curTexMap.selection; local fileNameStr = ddlFilesArr[ddlNSel]; local fileExt = getFilenameType fileNameStr
			if fileNameStr != noTex
			then
				(
				local old_Bitmap = openBitMap fileNameStr
				local WidthValue; local HeightValue
				if chbtn_PercentState.checked
				then (WidthValue = fn_Round ((old_Bitmap.width)*(spnr_PercentageSize.value/100)) 0; HeightValue = fn_Round ((old_Bitmap.height)*(spnr_PercentageSize.value/100)) 0)
				else (WidthValue = spnr_WidthValue.value; HeightValue = spnr_HeightValue.value)
				local new_Bitmap = bitmap WidthValue HeightValue
-- 				local newBitmapStr = (getFilenamePath fileNameStr)+(getFilenameFile fileNameStr)+"("+(WidthValue as string)+"x"+(HeightValue as string)+")"+fileExt
				local newBitmapStr = fileNameStr
				if chbtn_CopyReplace.checked then (newBitmapStr = (getFilenamePath fileNameStr)+(getFilenameFile fileNameStr)+(substituteString  (substituteString edt_CopyFormula.text "W" (WidthValue as string)) "H" (HeightValue as string))+fileExt )
				copy old_Bitmap new_Bitmap; new_Bitmap.filename = newBitmapStr
				save new_Bitmap; close old_Bitmap; close new_Bitmap; free old_Bitmap; free new_Bitmap; freeSceneBitmaps(); for k=1 to 24 do ( mat = medit.GetTopMtlSlot k ; setMTLMeditObjType mat (getMTLMeditObjType mat) )
				appendIfUnique ddlFilesArr newBitmapStr; sort ddlFilesArr
				curTexMap.items = ddlFilesArr; curTexMap.selection = findItem ddlFilesArr newBitmapStr
				fn_getTexExtSize ne false true
				if ddlFilesArr.count == 1 then (chbtnStatusArr[ne].highlightColor = colG) else (chbtnStatusArr[ne].highlightColor = colY); chbtnStatusArr[ne].checked = false; chbtnStatusArr[ne].checked = true
				ATfn_.ddlWidthDynamic curTexMap
				)
			)
		)
	else
		(
		local curTexMap = ddlTextureArr[_gEP2_mapN]; local ddlFilesArr = curTexMap.items; local ddlNSel = curTexMap.selection; local fileNameStr = ddlFilesArr[ddlNSel]; local fileExt = getFilenameType fileNameStr
		local old_Bitmap = openBitMap fileNameStr; local new_Bitmap = bitmap (spnr_WidthValue.value) (spnr_HeightValue.value)
-- 		local newBitmapStr = (getFilenamePath fileNameStr)+(getFilenameFile fileNameStr)+"("+(spnr_WidthValue.value as string)+"x"+(spnr_HeightValue.value as string)+")"+fileExt
		local newBitmapStr = fileNameStr
		if chbtn_CopyReplace.checked then (newBitmapStr = (getFilenamePath fileNameStr)+(getFilenameFile fileNameStr)+(substituteString  (substituteString edt_CopyFormula.text "W" (spnr_WidthValue.value as string)) "H" (spnr_HeightValue.value as string))+fileExt )
		copy old_Bitmap new_Bitmap; new_Bitmap.filename = newBitmapStr
		save new_Bitmap; close old_Bitmap; close new_Bitmap; free old_Bitmap; free new_Bitmap; freeSceneBitmaps(); for k=1 to 24 do ( mat = medit.GetTopMtlSlot k ; setMTLMeditObjType mat (getMTLMeditObjType mat) )
		appendIfUnique ddlFilesArr newBitmapStr; sort ddlFilesArr
		curTexMap.items = ddlFilesArr; curTexMap.selection = findItem ddlFilesArr newBitmapStr
		fn_getTexExtSize _gEP2_mapN false true
		if ddlFilesArr.count == 1 then (chbtnStatusArr[_gEP2_mapN].highlightColor = colG) else (chbtnStatusArr[_gEP2_mapN].highlightColor = colY); chbtnStatusArr[_gEP2_mapN].checked = false; chbtnStatusArr[_gEP2_mapN].checked = true
		ATfn_.ddlWidthDynamic curTexMap
		)
	)
	-----
on rolloutRenConvRes open do 
	(
-- 	local fileNameStr = (ddlTextureArr[_gEP2_mapN].items)[ddlTextureArr[_gEP2_mapN].selection]
	local fileNameStr = ddlTextureArr[_gEP2_mapN].selected
	local imgInfo = getBitmapInfo fileNameStr
	edt_RenameText.text = getFilenameFile fileNameStr
	spnr_WidthValue.value = imgInfo[3]; spnr_HeightValue.value = imgInfo[4]
	resKoef = (spnr_WidthValue.value as float) / (spnr_HeightValue.value as float)
	wPers = (spnr_WidthValue.value as float) / 100.0
	hPers = (spnr_HeightValue.value as float) / 100.0
	)
on rolloutRenConvRes close do
	(
	setINISetting iniFile "RenameConvertResize" "CopyFormula" (edt_CopyFormula.text)
	setINISetting iniFile "RenameConvertResize" "CopyReplace_State" (chbtn_CopyReplace.checked as string)
	_gEP2_mapN = undefined
	)
)
X = mouse.screenpos.X
Y = mouse.screenpos.Y
CreateDialog rolloutRenConvRes 264 220 pos:[(X-200),(Y-10)] style:#(#style_titlebar, #style_toolwindow, #style_sysmenu) modal:true
)
)
else (messageBox ((ddlTextureArr[_gEP2_mapN].selected) + "\n\nFile Dosn't Exist.") title:"File Dosn't Exist")
)
	-----fn--------------------------------------------------------------------------------------------------MAPS----
FN fn_ddlTex_RMB n =
(
if doesFileExist (ddlTextureArr[n].selected)
then
(
if keyboard.altPressed
	then (fn_rollRenameConvertResize n)
	else
if keyboard.controlPressed
	then
		(
		Global _gEP2_mapN = n
		rcMenu rcmenuOpenTexIn
			(
			menuItem mi_explFolder "Explorer Folder"
			menuItem mi_assProgram "Associated Program"
			menuItem mi_Photoshop "Photoshop" 
			on mi_explFolder picked do
				(
				if (ddlTextureArr[_gEP2_mapN].items).count != 0 then (shellLaunch "explorer.exe" ("/e,/select,\"" + ((ddlTextureArr[_gEP2_mapN].items)[ddlTextureArr[_gEP2_mapN].selection]) + "\"") )
				_gEP2_mapN = undefined
				)
			on mi_assProgram picked do
				(
				if (ddlTextureArr[_gEP2_mapN].items).count != 0 then (shellLaunch ((ddlTextureArr[_gEP2_mapN].items)[ddlTextureArr[_gEP2_mapN].selection]) "")
				_gEP2_mapN = undefined
				)
			on mi_Photoshop picked do
				(
				Image_= (ddlTextureArr[_gEP2_mapN].items)[ddlTextureArr[_gEP2_mapN].selection]
				PsApp = CreateOLEObject "Photoshop.Application"
				PsApp.open Image_
				PsApp.bringToFront()
				releaseAllOLEObjects()
				_gEP2_mapN = undefined
				)
			)
		rcPos = mouse.screenpos
		popUpMenu rcmenuOpenTexIn pos:rcPos
		)
	else
		(
		freeSceneBitmaps(); for k=1 to 24 do ( mat = medit.GetTopMtlSlot k ; setMTLMeditObjType mat (getMTLMeditObjType mat) )
		previewPath = (ddlTextureArr[n].items)[ddlTextureArr[n].selection]
		previewTime = (ATfn_.GetINI 0 iniFile "Settings" "PreviewTime" 2.2)*1000
		if (ATfn_.GetINI 0 iniFile "Settings" "TimerOnOff" true)
		then
			(
			rollout rolloutPrevTimer "PT"
			(
			timer tmr_Close interval:previewTime active:true
			on tmr_Close tick do (unDisplay openedBitMap; free openedBitMap; destroyDialog rolloutPrevTimer)
			on rolloutPrevTimer open do (free openedBitMap; openedBitMap = openBitMap previewPath; display openedBitMap caption:"Preview")
			on rolloutPrevTimer close do (free openedBitMap; freeSceneBitmaps(); for k=1 to 24 do ( mat = medit.GetTopMtlSlot k ; setMTLMeditObjType mat (getMTLMeditObjType mat) ); setFocus rollout_MaterialLoader)
			)
			try (destroyDialog rolloutPrevTimer) catch()
			CreateDialog rolloutPrevTimer 45 1 pos:[(1000),(-20)] style:#(#style_titlebar, #style_toolwindow, #style_sysmenu)
			)
		else
			(
			free openedBitMap; freeSceneBitmaps(); for k=1 to 24 do ( mat = medit.GetTopMtlSlot k ; setMTLMeditObjType mat (getMTLMeditObjType mat) )
			openedBitMap = openBitMap previewPath
			display openedBitMap caption:"Preview"
			)
		)
)
else (messageBox ((ddlTextureArr[n].selected) + "\n\nFile Dosn't Exist.") title:"File Dosn't Exist")
)
	-----fn--------------------------------------------------------------------------------------------------MAPS----
FN fn_btnBrow_LMB n =
(
extArr = ATfn_.GetINI 0 iniFile "Settings" "TypesOfExtensionForSearch" #(".jpg")
local typesStr = "All|*.*|"
try (for ext in extArr do typesStr += (toUpper (replace ext 1 1 ""))+" (*"+ext+")|*"+ext+"|") catch()
lastUsedDir = ATfn_.GetINI 1 iniFile "MainDirectory" "LastUsed" ""
if lastUsedDir.count == 3 then ( for w = 1 to lastUsedDir.count do (if lastUsedDir[w] == "/" then (lastUsedDir = replace lastUsedDir w 1 "")) )
if lastUsedDir[lastUsedDir.count] == "\\" then (lastUsedDir = replace lastUsedDir lastUsedDir.count 1 "")
LoadFilePath = getOpenFileName caption:"Load Texture..." filename:(lastUsedDir+"\\") types:typesStr
local filesArr = ddlTextureArr[n].items
if LoadFilePath != undefined 
	then
		(
		if filesArr[1] == noTex then filesArr = #()
		ddlTextureArr[n].enabled = true
		append filesArr LoadFilePath
		ddlTextureArr[n].items = deepCopy filesArr
		ddlTextureArr[n].selection = filesArr.count
		if filesArr.count == 1 then (chbtnStatusArr[n].highlightColor = colG) else (chbtnStatusArr[n].highlightColor = colY)
		chbtnStatusArr[n].checked = false; chbtnStatusArr[n].checked = true
		fn_getTexExtSize n true true
		btnMapTypeArr[n].enabled = btnMapSizeArr[n].enabled = true
		ATfn_.ddlWidthDynamic ddlTextureArr[n]
		setINISetting iniFile "MainDirectory" "LastUsed" (getFilenamePath LoadFilePath)
		)
	else()
)
	-----fn--------------------------------------------------------------------------------------------------MAPS----
FN fn_btnBrow_RMB n =
(
local filesArr = ddlTextureArr[n].items
local fileSel = ddlTextureArr[n].selection
if filesArr.count != 0
then
	(
	extArr = ATfn_.GetINI 0 iniFile "Settings" "TypesOfExtensionForSearch" #(".jpg")
	local typesStr = "All|*.*|"
	try (for ext in extArr do typesStr += (toUpper (replace ext 1 1 ""))+" (*"+ext+")|*"+ext+"|") catch()
	LoadFilePath = getOpenFileName caption:"Load Texture..." filename:((getFilenamePath filesArr[fileSel])) types:typesStr
	if LoadFilePath != undefined 
		then
			(
			if filesArr[1] == noTex then filesArr = #()
			ddlTextureArr[n].enabled = true
			append filesArr LoadFilePath
			ddlTextureArr[n].items = deepCopy filesArr
			ddlTextureArr[n].selection = filesArr.count
			if filesArr.count == 1 then (chbtnStatusArr[n].highlightColor = colG) else (chbtnStatusArr[n].highlightColor = colY)
			chbtnStatusArr[n].checked = false; chbtnStatusArr[n].checked = true
			fn_getTexExtSize n true true
			btnMapTypeArr[n].enabled = btnMapSizeArr[n].enabled = true
			ATfn_.ddlWidthDynamic ddlTextureArr[n]
			setINISetting iniFile "MainDirectory" "LastUsed" (getFilenamePath LoadFilePath)
			)
		else()
	)
)
	-----fn-----------------------------------------------------------------------------------------ADD-LOADER-----
FN fn_AddLoader n materialName =
(
local _mat_texmap_
local texPath
try (texPath = (ddlTextureArr[n].items)[ddlTextureArr[n].selection]) catch (texPath = "")
if texPath == noTex then texPath = ""
local BitTex = BitmapTexture filename:texPath name:(materialName + "_Bitmap")
BitTex.coords.U_Tiling = spnrTilingUArr[n].value; BitTex.coords.V_Tiling = spnrTilingVArr[n].value
BitTex.coords.blur = (ATfn_.GetINI 0 iniFile "Settings" "TextureLoaderBlur" 0.1)
local VrHdr = VrayHDRI HDRIMapName:texPath name:(materialName + "_VrayHDRI")
VrHdr.coords.U_Tiling = spnrTilingUArr[n].value; VrHdr.coords.V_Tiling = spnrTilingVArr[n].value
VrHdr.color_space = (ddlHDRIColSpArr[n].selection) - 1
VrHdr.coords.blur = (ATfn_.GetINI 0 iniFile "Settings" "TextureLoaderBlur" 0.1)
local VrCol = VRayColor name:(materialName + "_VRayColor")
VrCol.color = colorCoColorArr[n].color
VrCol.color_gamma = (ATfn_.GetINI 0 iniFile "Settings" "VRayColorGamma" 1.0)
local ColCor = Color_Correction name:(materialName + "_ColorCorr")
ColCor.color = colorCoColorArr[n].color
ColCor.lightnessMode = 1; ColCor.gammaRGB = spnrCCGammaContrastArr[n].value; ColCor.gainRGB = spnrCCRGBArr[n].value
local CompMat = CompositeTexture()
CompMat.name = (materialName + "_ComposMat")
local _tex_map_
case ddlLoaderArr[n].selection of
	(
	1: (_tex_map_ = undefined)
	2: (_tex_map_ = BitTex)
	3: (_tex_map_ = VrCol)
	4: (_tex_map_ = VrHdr)
	)
if chbtnColCorArr[n].checked
then
	(
	if chbtnComposArr[n].checked
	then (ColCor.map = _tex_map_; CompMat.mapList[1] = ColCor; _mat_texmap_ = CompMat)
	else (ColCor.map = _tex_map_; _mat_texmap_ = ColCor)
	)
else
	(
	if chbtnComposArr[n].checked
	then (CompMat.mapList[1] = _tex_map_; _mat_texmap_ = CompMat)
	else (_mat_texmap_ = _tex_map_)
	)
if chbtnOCIOArr[n].checked
then
	(
	local VrOCIO = VRayOCIO name:(materialName + "_VRayOCIO")
	VrOCIO.gen_basemap = _mat_texmap_
-- 	VrOCIO.gen_ocio_config = ATfn_.GetINI 1 iniFile "Settings" "OCIOConfigPath" ""
	VrOCIO.gen_ocio_config = OCIOConfigPath
	VrOCIO.inout_type = OCIOInOutType
	VrOCIO.gen_mode = OCIOGenMode
	VrOCIO.colorspace_in = OCIOColorSpaceIn
	VrOCIO.colorspace_out = OCIOColorSpaceOut
	_mat_texmap_ = VrOCIO
	)
return _mat_texmap_
)
	-----fn--------------------------------------------------------------------------------------------HISTORY-----
FN fn_ddlLoadMatHistoryState arg =
(
for n=1 to 20 do 
	(
	filesArr = _gEP2_createMatHistoryArr[arg][2][n]; ddlTextureArr[n].items = deepCopy filesArr
	textureSelection = 1; extPattern = "*"+(ATfn_.GetINI 0 iniFile "Settings" "TypesOfExtensionForSearch" #(".jpg"))[(ATfn_.GetINI 0 iniFile "Settings" "PreferredTextureExtension" 1)]
	for n in filesArr.count to 1 by -1 do (if (matchPattern filesArr[n] pattern:extPattern) then (textureSelection = n))
	ddlTextureArr[n].selection = textureSelection
	fn_getTexExtSize n true true
	if chbtnStateArr[n].checked
	then
		(
		if filesArr.count > 1
		then
			(
			chbtnStatusArr[n].highlightColor = colY
			ddlTextureArr[n].enabled = true; chbtnStatusArr[n].checked = false; chbtnStatusArr[n].checked = true
			btnMapTypeArr[n].enabled = btnMapSizeArr[n].enabled = true
			ATfn_.ddlWidthDynamic ddlTextureArr[n]
			)
		else
			(
			if filesArr[1] == noTex
			then
				(
				chbtnStatusArr[n].highlightColor = colR
				ddlTextureArr[n].enabled = false; chbtnStatusArr[n].checked = false; chbtnStatusArr[n].checked = true
				btnMapTypeArr[n].enabled = btnMapSizeArr[n].enabled = false
				)
			else
				(
				if filesArr.count != 0
				then
					(
					chbtnStatusArr[n].highlightColor = colG
					ddlTextureArr[n].enabled = true; chbtnStatusArr[n].checked = false; chbtnStatusArr[n].checked = true
					btnMapTypeArr[n].enabled = btnMapSizeArr[n].enabled = true
					ATfn_.ddlWidthDynamic ddlTextureArr[n]
					)
				else
					(
					chbtnStatusArr[n].highlightColor = colR
					ddlTextureArr[n].enabled = false; chbtnStatusArr[n].checked = false; chbtnStatusArr[n].checked = true
					btnMapTypeArr[n].enabled = btnMapSizeArr[n].enabled = false
					)
				)
			)
		)
	)
)
	-----fn------------------------------------------------------------------------------CREATE-MATERIAL------------
FN fn_CreateMaterial materialName =
(
local vrMat = VRayMtl()
local BRDF = case ddl_BRDFtype.selection of
	(
	1: 0
	2: 1
	3: 2
	4: 4
	)
vrMat.brdf_type = BRDF
-- if rdbtn_GlossiOrRough.state == 1
-- then
-- 	(
-- 	vrMat.brdf_useRoughness = off
-- 	)
-- else
-- 	(
-- 	vrMat.brdf_useRoughness = on
-- 	vrMat.Reflection = color 255 255 255
-- 	)
if rdbtn_GlossiOrRough.state == 2 do (vrMat.brdf_useRoughness = on; vrMat.Reflection = color 255 255 255)
vrMat.name = materialName
if chbtn_DiffuseState.checked then (vrMat.texmap_diffuse = fn_AddLoader 1 materialName)
if chbtn_RoughnessState.checked then (vrMat.texmap_roughness = fn_AddLoader 2 materialName)
if chbtn_SelfIllumState.checked then (vrMat.texmap_self_illumination = fn_AddLoader 3 materialName)
if chbtn_ReflectState.checked then (vrMat.texmap_reflection = fn_AddLoader 4 materialName)
if chbtn_HGlossinessState.checked then (vrMat.texmap_hilightGlossiness = fn_AddLoader 5 materialName)
if chbtn_RGlossinessState.checked then (vrMat.texmap_reflectionGlossiness = fn_AddLoader 6 materialName)
if chbtn_FresnelIORState.checked then (vrMat.reflection_lockIOR = off; vrMat.texmap_reflectionIOR = fn_AddLoader 7 materialName)
if chbtn_MetalnessState.checked then (vrMat.texmap_metalness = fn_AddLoader 8 materialName)
if chbtn_AnisotropyState.checked then (vrMat.texmap_anisotropy = fn_AddLoader 9 materialName)
if chbtn_AnRotationState.checked then (vrMat.texmap_anisotropy_rotation = fn_AddLoader 10 materialName)
if chbtn_RefractState.checked then (vrMat.texmap_refraction = fn_AddLoader 11 materialName)
if chbtn_GlossinessState.checked then (vrMat.texmap_refractionGlossiness = fn_AddLoader 12 materialName)
if chbtn_IORState.checked then (vrMat.texmap_refractionIOR = fn_AddLoader 13 materialName)
if chbtn_TranslucentState.checked then (vrMat.texmap_translucent = fn_AddLoader 14 materialName)
if chbtn_FogColorState.checked then (vrMat.texmap_refraction_fog = fn_AddLoader 15 materialName)
if chbtn_NormalState.checked
then
	(
	vrMat.texmap_bump_multiplier = 100
	local VrNormMap = VRayNormalMap name:(materialName + "_VRayNormalMap")
	VrNormMap.flip_green = on
	VrNormMap.normal_map = fn_AddLoader 16 materialName
	if chbtn_BumpState.checked then (VrNormMap.bump_map = fn_AddLoader 17 materialName)
	vrMat.texmap_bump = VrNormMap
	)
else
	(
	if chbtn_BumpState.checked then
		(
		vrMat.texmap_bump_multiplier = 100
		vrMat.texmap_bump = fn_AddLoader 17 materialName
		)
	)
if chbtn_DisplaceState.checked then (vrMat.texmap_displacement = fn_AddLoader 18 materialName)
if chbtn_OpacityState.checked then (vrMat.texmap_opacity = fn_AddLoader 19 materialName)
if chbtn_EnvironmentState.checked then (vrMat.texmap_environment = fn_AddLoader 20 materialName)
if (ATfn_.GetINI 0 iniFile "Settings" "ShowMaterialInViewport" true) then (showTextureMap vrMat on) else (showTextureMap vrMat off)
local finalMat
if chbtn_Blend.checked then (materialName += "_Blend"; finalMat = VRayBlendMtl name:materialName baseMtl:vrMat) else (finalMat = vrMat)
return finalMat
)
	-----fn------------------------------------------------------------------------------------------------------------
FN fn_btnObjectsRenameAddToLayerCreateMaterial addToLayerState objectsRenameState =
(
-- windows.processPostedMessages()
local MEditState = mateditor.isopen()
if MEditState then mateditor.close()
if classOf renderers.current != Vray then renderers.current = Vray()
for k=1 to 24 do ( mat = medit.GetTopMtlSlot k ; setMTLMeditObjType mat (getMTLMeditObjType mat) )
local curSel = for objct in (selection as array) where not (isGroupHead objct) collect objct; qSort curSel ATfn_.CompareNames
if chbtn_FromObjMode.checked
then   -----------------------------------------------------------------------------------------------------------------------------------------------------------
	(
	_gEP2_createMatHistoryArr = #()
	if curSel.count != 0
	then
		(
		 ------------------------------
		local newNamesArr = for objct in curSel collect (fn_fromObject_SearchName objct)
		local oldNamesArrArr = #()
		for nN=1 to newNamesArr.count do (oldNamesArr= #(); for snN=1 to newNamesArr.count where (newNamesArr[nN]==newNamesArr[snN]) do (append oldNamesArr curSel[snN].name; appendIfUnique oldNamesArrArr oldNamesArr))
		local oldNamesArrArrUniqueStr = #()
		for el in oldNamesArrArr do (appendIfUnique oldNamesArrArrUniqueStr (el as string))
		local oldNamesArrArrUnique = #()
		for el in oldNamesArrArrUniqueStr do (append oldNamesArrArrUnique (execute el))
		prgrs_FromObjMode.value = 0
		prgrs_FromObjMode.color = orange
		for Narr in oldNamesArrArrUnique do
			(
			windows.processPostedMessages()
			prgrs_FromObjMode.color = orange
			local mtrlName = fn_fromObject_MaterialName (getNodeByName Narr[1])
			local ddlRootsItems
			if chbtn_MultiStatus.checked then (ddlRootsItems = fn_deleteSubdirs (ddl_Roots.items)) else (try (ddlRootsItems = #((ddl_Roots.items)[ddl_Roots.selection])) catch (ddlRootsItems = #()))
			ddlRootsItems = fn_slashReplaceR ddlRootsItems
			local mainNameArr = fn_fromObject_SearchNameArr (getNodeByName Narr[1])
			local tempMNArr = #()
			if chbtn_SpecialRule.checked then (for mn in mainNameArr do (appendIfUnique tempMNArr (substituteString edt_SpecialRule.text "#" mn)); mainNameArr = tempMNArr)
			local mainFilesArr = #()
			local filesArr = #()
			local deniedArr = #()
			if ddlRootsItems.count != 0 then
				(
				if (mainNameArr.count == 0 and fn_mapsSearchNoNamesCheck())
				then (/*messageBox "Search filds empty." title:"Search data missing" beep:false*/) 
				else
					(
					if mainNameArr.count != 0
					then
						(
						if mainNameArr.count == 1
						then
							(
							collectResult = fn_dotNetCollectFiles foldersArr:ddlRootsItems pattern:(mainNameArr[1]) extensions:(ATfn_.GetINI 0 iniFile "Settings" "TypesOfExtensionForSearch" #(".jpg"))
							deniedArr = deepCopy collectResult[2]
							mainFilesArr = deepCopy collectResult[1]
							)
						else
							(
							local operatingArr = #()
							collectResult = fn_dotNetCollectFiles foldersArr:ddlRootsItems pattern:(mainNameArr[1]) extensions:(ATfn_.GetINI 0 iniFile "Settings" "TypesOfExtensionForSearch" #(".jpg"))
							deniedArr = deepCopy collectResult[2]
							mainFilesArr = deepCopy collectResult[1]
							for mN=2 to mainNameArr.count do
								(
								filesArr = for filePath in mainFilesArr where ( matchPattern (getFilenameFile filePath) pattern:("*"+(mainNameArr[mN])+"*") ) collect filePath
								mainFilesArr = deepCopy filesArr
								)
							)
						for dir in deniedArr do (format "!!!  Access denied:   %\n" dir)
						)
					for n=1 to 20 do (if chbtnStateArr[n].checked then (fn_mapSearch n ddlRootsItems mainNameArr mainFilesArr))
					)
				)
			else (/*messageBox "List of directories empty." title:"Search data missing" beep:false*/)
			------------------------------------------------------------------------------------------------------------------
			local finalMat = fn_CreateMaterial mtrlName
-- 			for n in Narr do (try (local nd = (getNodeByName n); nd.material = finalMat; nd.wirecolor = ATfn_.RandomColor()) catch())
			for n in Narr do (try (local nd = (for o in selection where o.name == n collect o); nd.material = finalMat; nd.wirecolor = ATfn_.RandomColor()) catch())
			toSlot = ((ATfn_.GetINI 0 iniFile "Settings" "ToMaterialEditorSlot" 1) + ((findItem oldNamesArrArrUnique Narr) - 1))
			matTo = if (toSlot <= 24) then toSlot else 24
			if (ATfn_.GetINI 0 iniFile "Settings" "PutMaterialToEditor" true) then ((activeMeditSlot = (ATfn_.GetINI 0 iniFile "Settings" "ToMaterialEditorSlot" 1)); (meditMaterials[matTo] = finalMat))
			 ------------------------------SearchHistory------------------------------
			curHistoryArr = #(mtrlName, #())
			for Nddl=1 to ddlTextureArr.count do 
				(
				if chbtnStateArr[Nddl].checked
				then ( if ((ddlTextureArr[Nddl].items).count > 0) then (append curHistoryArr[2] ddlTextureArr[Nddl].items) )
				else ( append curHistoryArr[2] #() )
				)
			append _gEP2_createMatHistoryArr curHistoryArr
			 ------------------------------SearchHistory------------------------------
			forceCompleteRedraw()
			prgrs_FromObjMode.value = 100.0*(findItem oldNamesArrArrUnique Narr)/(oldNamesArrArrUnique.count)
			)
		 ------------------------------AddToLayer------------------------------
		if addToLayerState then
		(
		for objct in curSel do
			(
			local layerName = fn_fromObject_LayerName objct
			if layerName != ""
			then
				(
				layermanager.newLayerFromName layerName
				local objctLayer = LayerManager.getlayerfromName layerName
				objctLayer.current = true
				objctLayer.addNode objct
				)
			)
		)
		 ------------------------------ObjectsRename------------------------------
		if objectsRenameState then
		(
		local newObjArr = #()
		local newNamesArr = #()
		for objct in curSel where ((fn_fromObject_ObjectName objct) != "") do (append newObjArr objct; append newNamesArr (fn_fromObject_ObjectName objct) )
		local oldNamesArrArr = #()
		for nN=1 to newNamesArr.count do (oldNamesArr= #(); for snN=1 to newNamesArr.count where (newNamesArr[nN]==newNamesArr[snN]) do (append oldNamesArr curSel[snN].name; appendIfUnique oldNamesArrArr oldNamesArr))
		local oldNamesArrArrUniqueStr = #()
		for el in oldNamesArrArr do (appendIfUnique oldNamesArrArrUniqueStr (el as string))
		local oldNamesArrArrUnique = #()
		for el in oldNamesArrArrUniqueStr do (append oldNamesArrArrUnique (execute el))
		for Narr in oldNamesArrArrUnique do
			(
-- 			if Narr.count == 1
-- 			then ( if chbtn_OneObjCounter.checked then ((getNodeByName Narr[1]).name = (fn_fromObject_ObjectName (getNodeByName Narr[1]) + "_001")) else ((getNodeByName Narr[1]).name = fn_fromObject_ObjectName (getNodeByName Narr[1])) )
-- 			else (for n=1 to Narr.count do ( (getNodeByName Narr[n]).name = ((fn_fromObject_ObjectName (getNodeByName Narr[n])) + (fn_Delim()) + (if n<10 then ("00"+(n as string)) else (if n<100 then ("0"+(n as string)) else (n as string)))) ))
			if chbtn_OneObjCounter.checked
			then (for n=1 to Narr.count do ( (getNodeByName Narr[n]).name = ((fn_fromObject_ObjectName (getNodeByName Narr[n])) + (fn_Delim()) + (if n<10 then ("00"+(n as string)) else (if n<100 then ("0"+(n as string)) else (n as string)))) ))
			else (for n=1 to Narr.count do ( (getNodeByName Narr[n]).name = ((fn_fromObject_ObjectName (getNodeByName Narr[n]))) ))
			)
		)
		 ------------------------------
		if MEditState then mateditor.Open()
		redrawViews()
		 ------------------------------SearchHistory------------------------------
		(
		rollout _gEP2_rolloutTexSearchHistory "Materials"
		(
		dropDownList ddl_MaterialsList items:(for m in _gEP2_createMatHistoryArr collect m[1]) pos:[0,-30] selection:_gEP2_createMatHistoryArr.count width:20 height:1
		listbox lstbx_MaterialsList items:(for m in _gEP2_createMatHistoryArr collect m[1]) pos:[2,2] selection:_gEP2_createMatHistoryArr.count width:((ATfn_.GetINI 0 iniFile "DialogPosition" "LastSize" [200,200])[1]-3) height:_gEP2_createMatHistoryArr.count
		-----------
		on ddl_MaterialsList selected arg do
			(
			local MEditStatel = mateditor.isopen()
			if MEditStatel then mateditor.close()
			matObjcts = for objct in objects where (objct.material != undefined and objct.material.name == _gEP2_createMatHistoryArr[arg][1]) collect objct; select matObjcts
			for sl=1 to 24 do (if (getMeditMaterial sl).name == _gEP2_createMatHistoryArr[arg][1] then activeMeditSlot = sl)
			local nameSel = for objct in (selection as array) where not (isGroupHead objct) collect objct; nameStr = nameSel[1].name; nameArr = filterString nameStr (fn_Delim()); if nameSel.count > 1 then (deleteItem nameArr nameArr.count)
			for edt in edtFildsArr do (edt.text = ""); for n=1 to edtFildsArr.count do (if nameArr[n] != undefined then edtFildsArr[n].text = nameArr[n])
			fn_ddlLoadMatHistoryState arg
			if MEditStatel then mateditor.Open()
			setFocus ddl_MaterialsList
			lstbx_MaterialsList.selection = arg
			)
		-----------
		on lstbx_MaterialsList selected arg do
			(
			local MEditStatel = mateditor.isopen()
			if MEditStatel then mateditor.close()
			matObjcts = for objct in objects where (objct.material != undefined and objct.material.name == _gEP2_createMatHistoryArr[arg][1]) collect objct; select matObjcts
			for sl=1 to 24 do (if (getMeditMaterial sl).name == _gEP2_createMatHistoryArr[arg][1] then activeMeditSlot = sl)
			local nameSel = for objct in (selection as array) where not (isGroupHead objct) collect objct; nameStr = nameSel[1].name; nameArr = filterString nameStr (fn_Delim()); if nameSel.count > 1 then (deleteItem nameArr nameArr.count)
			for edt in edtFildsArr do (edt.text = ""); for n=1 to edtFildsArr.count do (if nameArr[n] != undefined then edtFildsArr[n].text = nameArr[n])
			fn_ddlLoadMatHistoryState arg
			if MEditStatel then mateditor.Open()
			setFocus ddl_MaterialsList
			ddl_MaterialsList.selection = arg
			)
		-----------
		on _gEP2_rolloutTexSearchHistory resized size do
			(
			lstbx_MaterialsList.width = size[1] - 3
			lstbx_MaterialsList.height = size[2] - 3
			)
		-----------
		on _gEP2_rolloutTexSearchHistory open do
			(
			local LastSize = ATfn_.GetINI 0 iniFile "DialogPosition" "LastSize" [200,200]
			lstbx_MaterialsList.width = LastSize[1] - 3
			lstbx_MaterialsList.height = LastSize[2] - 3
			for chbtn in chbtnObjectFildsArr do (chbtn.enabled = false)
			for chbtn in chbtnLayerFildsArr do (chbtn.enabled = false)
			for chbtn in chbtnMaterialFildsArr do (chbtn.enabled = false)
			for ddl in ddlFildsArr do (ddl.enabled = true)
			for edt in edtFildsArr do (edt.enabled = true)
			for n=1 to 20 where chbtnStateArr[n].checked do (chbtnStatusArr[n].enabled = btnBrowseArr[n].enabled = true)
			btn_SearchTextures.enabled = true
			btn_ObjLayerCreateMat.enabled = btn_SClear.enabled = btn_OClear.enabled = btn_LClear.enabled = btn_MClear.enabled = btn_RenameObject.enabled = btn_ObjectToLayer.enabled = chbtn_FromObjMode.checked = chbtn_FromObjMode.enabled = false
			matObjcts = for objct in objects where (objct.material != undefined and objct.material.name == _gEP2_createMatHistoryArr[_gEP2_createMatHistoryArr.count][1]) collect objct; select matObjcts
			fn_ddlLoadMatHistoryState _gEP2_createMatHistoryArr.count
			setFocus ddl_MaterialsList
			)
		on _gEP2_rolloutTexSearchHistory close do 
			(
			for chbtn in chbtnObjectFildsArr do (chbtn.enabled = true)
			for chbtn in chbtnLayerFildsArr do (chbtn.enabled = true)
			for chbtn in chbtnMaterialFildsArr do (chbtn.enabled = true)
			for ddl in ddlFildsArr do (ddl.enabled = false)
			for edt in edtFildsArr do (edt.enabled = false)
			for ddl in ddlTextureArr do (ddl.items = #(); ddl.enabled = false)
			for n=1 to 20 where chbtnStateArr[n].checked do (btnMapTypeArr[n].caption = btnMapSizeArr[n].caption = ""; btnMapSizeArr[n].tooltip = tt_btn_MapSize)
			for n=1 to 20 where chbtnStateArr[n].checked do (btnMapTypeArr[n].enabled = btnMapSizeArr[n].enabled = false)
			for n=1 to 20 where chbtnStateArr[n].checked do (chbtnStatusArr[n].highlightColor = colZ; chbtnStatusArr[n].checked = false; chbtnStatusArr[n].checked = true)
			for n=1 to 20 where chbtnStateArr[n].checked do (chbtnStatusArr[n].enabled = btnBrowseArr[n].enabled = false)
			btn_SearchTextures.enabled = btn_FildsClear.enabled = btn_RenameGet.enabled = false
			btn_ObjLayerCreateMat.enabled = btn_SClear.enabled = btn_OClear.enabled = btn_LClear.enabled = btn_MClear.enabled = btn_RenameObject.enabled = btn_ObjectToLayer.enabled = chbtn_FromObjMode.checked = chbtn_FromObjMode.enabled = true
			try (setINISetting iniFile "DialogPosition" "TexSearchHistoryShift" (((GetDialogPos rollout_MaterialLoader) - (GetDialogPos _gEP2_rolloutTexSearchHistory)) as string)) catch()
			try (setINISetting iniFile "DialogPosition" "LastSize" ((GetDialogSize _gEP2_rolloutTexSearchHistory) as string)) catch()
			_gEP2_createMatHistoryArr = #()
			_gEP2_rolloutTexSearchHistory = undefined
			)
		)
		local LastSize = ATfn_.GetINI 0 iniFile "DialogPosition" "LastSize" [200,200]
-- 		roll1W = 200; roll1H = 8+14*(_gEP2_createMatHistoryArr.count)
		roll1W = LastSize[1]; roll1H = LastSize[2]
		DialogPositionShift = ATfn_.GetINI 0 iniFile "DialogPosition" "TexSearchHistoryShift" [210,0]
		DialogPosition = (GetDialogPos rollout_MaterialLoader) - DialogPositionShift
		if DialogPosition[1] < 0 then DialogPosition[1] = 0; if DialogPosition[2] < 30 then DialogPosition[2] = 30
		if (DialogPosition[1] > (sysInfo.DesktopSize[1] - roll1W)) then abs(DialogPosition[1] = (sysInfo.DesktopSize[1] - roll1W - 10))
		if (DialogPosition[2] > (sysInfo.DesktopSize[2] - roll1H)) then abs(DialogPosition[2] = (sysInfo.DesktopSize[2] - roll1H - 30))
-- 		CreateDialog _gEP2_rolloutTexSearchHistory roll1W roll1H pos:DialogPosition style:#(#style_titlebar, #style_toolwindow, #style_sysmenu) modal:false
		CreateDialog _gEP2_rolloutTexSearchHistory roll1W roll1H pos:DialogPosition style:#(#style_resizing, #style_titlebar, #style_toolwindow, #style_sysmenu) modal:false
		)
		 ------------------------------SearchHistory------------------------------
		prgrs_FromObjMode.color = green
		tmr_prgrsFade.active = true
		)
	else (messageBox "Objects not selected.\n\n Can not get names." title:"No selection" beep:false)
	)
else   -----------------------------------------------------------------------------------------------------------------------------------------------------------
	(
	local createMatHistoryState = _gEP2_createMatHistoryArr.count != 0
	local lstbxMaterialsListSelection = 0
	local mtrlName
	if createMatHistoryState
	then
		(
		lstbxMaterialsListSelection = _gEP2_rolloutTexSearchHistory.lstbx_MaterialsList.selection
		mtrlName = _gEP2_createMatHistoryArr[lstbxMaterialsListSelection][1]
		)
	else (mtrlName = fn_fromFilds_MaterialName())
	 ------------------------------
	local finalMat = fn_CreateMaterial mtrlName
	curSel.wirecolor = ATfn_.RandomColor()
	try (curSel.material = finalMat) catch()
	if createMatHistoryState
	then 
		(
		if (ATfn_.GetINI 0 iniFile "Settings" "PutMaterialToEditor" true) then (activeMeditSlot = (ATfn_.GetINI 0 iniFile "Settings" "ToMaterialEditorSlot" 1) + (lstbxMaterialsListSelection - 1))
		meditMaterials[activeMeditSlot] = finalMat
		for Nddl=1 to ddlTextureArr.count do ( if chbtnStateArr[Nddl].checked then ( if (ddlTextureArr[Nddl].items).count != 0 then ( (ddlTextureArr[Nddl]).items = #( (ddlTextureArr[Nddl].items)[ddlTextureArr[Nddl].selection] );  ddlTextureArr[Nddl].selection = 1 ) ) )
		local ddlTextureSelectionArr = #()
		for Nddl=1 to ddlTextureArr.count do (append ddlTextureSelectionArr ddlTextureArr[Nddl].selection)
		_gEP2_createMatHistoryArr[lstbxMaterialsListSelection][2] = #()
		for Nddl=1 to ddlTextureArr.count do (if chbtnStateArr[Nddl].checked then (append _gEP2_createMatHistoryArr[lstbxMaterialsListSelection][2] ddlTextureArr[Nddl].items) else (append _gEP2_createMatHistoryArr[lstbxMaterialsListSelection][2] #()) )
		fn_ddlLoadMatHistoryState lstbxMaterialsListSelection
		for Nddl=1 to ddlTextureArr.count do (ddlTextureArr[Nddl].selection = ddlTextureSelectionArr[Nddl])
		)
	else (if (ATfn_.GetINI 0 iniFile "Settings" "PutMaterialToEditor" true) then (activeMeditSlot = (ATfn_.GetINI 0 iniFile "Settings" "ToMaterialEditorSlot" 1); meditMaterials[activeMeditSlot] = finalMat))
	 ------------------------------AddToLayer------------------------------
	if addToLayerState then
	(
	local layerName = fn_fromFilds_LayerName()
	if layerName != ""
	then
		(
		layermanager.newLayerFromName layerName
		local objctLayer = LayerManager.getlayerfromName layerName
		objctLayer.current = true
		for objct in curSel do objctLayer.addNode objct
		)
	)
	 ------------------------------RenameObjects------------------------------
	if objectsRenameState then
	(
	local ObjectName = fn_fromFilds_ObjectName()
	if ObjectName != ""
	then
		(
		if curSel.count != 0
		then
			(
-- 			if curSel.count == 1
-- 			then (if chbtn_OneObjCounter.checked then (curSel[1].name = ObjectName + "_001") else (curSel[1].name = ObjectName))
-- 			else (ATfn_.RenameAddCounter ObjectName curSel Separator:(fn_Delim()) CounterDigits:3)
			if chbtn_OneObjCounter.checked then (ATfn_.RenameAddCounter ObjectName curSel Separator:(fn_Delim()) CounterDigits:3) else (curSel.name = ObjectName)
			)
		else (messageBox "Objects not renamed." title:"No selection" beep:false)
		)
	)
	 ------------------------------
	if MEditState then mateditor.Open()
	)
)      -------------------------------------------------------------------------------------------------------------
	-----fn-------------------------------------------------------------------------------------SAVE-INI-----------
FN fn_SaveDefaultsInINI =
(
setINISetting iniFile "Separators" "Separator_State" (chbtn_Separator.checked as string)
for n=1 to 8 do
	(
	setINISetting iniFile "Filds" ("Fild_0"+(n as string)+"_Search") (chbtnSearchFildsArr[n].checked as string)
	setINISetting iniFile "Filds" ("Fild_0"+(n as string)+"_Object") (chbtnObjectFildsArr[n].checked as string)
	setINISetting iniFile "Filds" ("Fild_0"+(n as string)+"_Layer") (chbtnLayerFildsArr[n].checked as string)
	setINISetting iniFile "Filds" ("Fild_0"+(n as string)+"_Material") (chbtnMaterialFildsArr[n].checked as string)
	setINISetting iniFile "Filds" ("Fild_0"+(n as string)+"_Saved") (with printAllElements on (ddlFildsArr[n].items as string))
	setINISetting iniFile "Filds" ("Fild_0"+(n as string)+"_Default") (edtFildsArr[n].text)
	)
setINISetting iniFile "Filds" "NamesFromObjects" (chbtn_FromObjMode.checked as string)
setINISetting iniFile "Filds" "OneObjectCounter" (chbtn_OneObjCounter.checked as string)
setINISetting iniFile "MainDirectory" "MultiState" (chbtn_MultiStatus.checked as string)
setINISetting iniFile "MainDirectory" "RootsSaved" (with printAllElements on (ddl_RootsSaved.items as string))
setINISetting iniFile "MainDirectory" "RootsLastUsed" (with printAllElements on (ddl_Roots.items as string))
setINISetting iniFile "MainDirectory" "RootsSelection" (ddl_Roots.selection as string)
for n=1 to 20 do
	(
	setINISetting iniFile MapTypeNamesArr[n] "OnOffState" (chbtnStateArr[n].checked as string)
	setINISetting iniFile MapTypeNamesArr[n] "SavedSearchNames" (with printAllElements on (ddlSearchNameArr[n].items as string))
	setINISetting iniFile MapTypeNamesArr[n] "DefaultSearchName" (edtSearchNameArr[n].text)
	setINISetting iniFile MapTypeNamesArr[n] "DefaultLoader" (ddlLoaderArr[n].selection as string)
	setINISetting iniFile MapTypeNamesArr[n] "CorrectionVRayColor" (colorCoColorArr[n].color as string)
	setINISetting iniFile MapTypeNamesArr[n] "UTiling" (spnrTilingUArr[n].value as string)
	setINISetting iniFile MapTypeNamesArr[n] "VTiling" (spnrTilingVArr[n].value as string)
	setINISetting iniFile MapTypeNamesArr[n] "HDRIColorSpace" (ddlHDRIColSpArr[n].selection as string)
	setINISetting iniFile MapTypeNamesArr[n] "ColorCorrectState" (chbtnColCorArr[n].checked as string)
	setINISetting iniFile MapTypeNamesArr[n] "ColCorGammaContrast" (spnrCCGammaContrastArr[n].value as string)
	setINISetting iniFile MapTypeNamesArr[n] "ColCorRGB" (spnrCCRGBArr[n].value as string)
	setINISetting iniFile MapTypeNamesArr[n] "CompositeState" (chbtnComposArr[n].checked as string)
	setINISetting iniFile MapTypeNamesArr[n] "OCIOState" (chbtnOCIOArr[n].checked as string)
	)
setINISetting iniFile "Settings" "SpecialRuleExpression" edt_SpecialRule.text
setINISetting iniFile "Settings" "SpecialRuleState" (chbtn_SpecialRule.checked as string)
setINISetting iniFile "VRayMaterial" "BRDFtype" (ddl_BRDFtype.selection as string)
setINISetting iniFile "VRayMaterial" "GlossiOrRough" (rdbtn_GlossiOrRough.state as string)
setINISetting iniFile "Settings" "BlendState" (chbtn_Blend.checked as string)
)
	-----fn------------------------------------------------------------------------------------LOAD-INI-----------
FN fn_LoadINI loadingINI =
(
local ObjModeState = (ATfn_.GetINI 0 loadingINI "Filds" "NamesFromObjects" false)
chbtn_Separator.checked = (ATfn_.GetINI 0 loadingINI "Separators" "Separator_State" true)
fn_setHighlightColor chbtn_Separator (ATfn_.GetINI 0 loadingINI "Settings" "CheckboxColor" [255,156,0])
for n=1 to 8 do 
	(
	chbtnSearchFildsArr[n].checked = (ATfn_.GetINI 0 loadingINI "Filds" ("Fild_0"+(n as string)+"_Search") false)
	fn_setHighlightColor chbtnSearchFildsArr[n] (ATfn_.GetINI 0 loadingINI "Settings" "SearchColor" [255,156,0])
	chbtnObjectFildsArr[n].checked = (ATfn_.GetINI 0 loadingINI "Filds" ("Fild_0"+(n as string)+"_Object") false)
	fn_setHighlightColor chbtnObjectFildsArr[n] (ATfn_.GetINI 0 loadingINI "Settings" "ObjectColor" [255,156,0])
	chbtnLayerFildsArr[n].checked = (ATfn_.GetINI 0 loadingINI "Filds" ("Fild_0"+(n as string)+"_Layer") false)
	fn_setHighlightColor chbtnLayerFildsArr[n] (ATfn_.GetINI 0 loadingINI "Settings" "LayerColor" [255,156,0])
	chbtnMaterialFildsArr[n].checked = (ATfn_.GetINI 0 loadingINI "Filds" ("Fild_0"+(n as string)+"_Material") false)
	fn_setHighlightColor chbtnMaterialFildsArr[n] (ATfn_.GetINI 0 loadingINI "Settings" "MaterialColor" [255,156,0])
	edtFildsArr[n].enabled = ddlFildsArr[n].enabled = not ObjModeState
	edtFildsArr[n].text = (ATfn_.GetINI 1 loadingINI "Filds" ("Fild_0"+(n as string)+"_Default") "")
	ddlFildsArr[n].items = (ATfn_.GetINI 0 loadingINI "Filds" ("Fild_0"+(n as string)+"_Saved") #(""))
	)
chbtn_FromObjMode.checked = ObjModeState
fn_setHighlightColor chbtn_FromObjMode (ATfn_.GetINI 0 loadingINI "Settings" "CheckboxColor" [255,156,0])
chbtn_OneObjCounter.checked = (ATfn_.GetINI 0 loadingINI "Filds" "OneObjectCounter" false)
fn_setHighlightColor chbtn_OneObjCounter (ATfn_.GetINI 0 loadingINI "Settings" "CheckboxColor" [255,156,0])
chbtn_MultiStatus.checked = (ATfn_.GetINI 0 loadingINI "MainDirectory" "MultiState" false)
fn_setHighlightColor chbtn_MultiStatus (ATfn_.GetINI 0 loadingINI "Settings" "CheckboxColor" [255,156,0])
ddl_RootsSaved.items = (ATfn_.GetINI 0 loadingINI "MainDirectory" "RootsSaved" #())
local ddlRootsItemsArr = (ATfn_.GetINI 0 loadingINI "MainDirectory" "RootsLastUsed" #())
ddl_Roots.items = ddlRootsItemsArr; ddl_Roots.enabled = btn_Del.enabled = btn_All.enabled = btn_Sel.enabled = btn_Sub.enabled = (ddlRootsItemsArr.count != 0)
ddl_Roots.selection = (ATfn_.GetINI 0 loadingINI "MainDirectory" "RootsSelection" 0)
btn_SearchTextures.enabled = btn_FildsClear.enabled = btn_RenameGet.enabled = not ObjModeState
for n=1 to 20 do
	(
	local OnOffSt = (ATfn_.GetINI 0 loadingINI MapTypeNamesArr[n] "OnOffState" false)
	chbtnStateArr[n].checked = OnOffSt
	fn_setHighlightColor chbtnStateArr[n] (ATfn_.GetINI 0 loadingINI "Settings" "CheckboxColor" [255,156,0])
	ddlSearchNameArr[n].items = (ATfn_.GetINI 0 loadingINI MapTypeNamesArr[n] "SavedSearchNames" #(""))
	ddlSearchNameArr[n].enabled = OnOffSt
	edtSearchNameArr[n].text = (ATfn_.GetINI 1 loadingINI MapTypeNamesArr[n] "DefaultSearchName" "")
	edtSearchNameArr[n].enabled = OnOffSt
	chbtnStatusArr[n].enabled = (OnOffSt and not ObjModeState)
	chbtnStatusArr[n].checked = OnOffSt
	fn_setHighlightColor chbtnStatusArr[n] colZ
	btnBrowseArr[n].enabled = (OnOffSt and not ObjModeState)
	ddlLoaderArr[n].selection = (ATfn_.GetINI 0 loadingINI MapTypeNamesArr[n] "DefaultLoader" 1)
	ddlLoaderArr[n].enabled = OnOffSt
	colorCoColorArr[n].color = (ATfn_.GetINI 0 loadingINI MapTypeNamesArr[n] "CorrectionVRayColor" [128,128,128])
	colorCoColorArr[n].enabled = OnOffSt
	spnrTilingUArr[n].value = (ATfn_.GetINI 0 loadingINI MapTypeNamesArr[n] "UTiling" 1.0)
	spnrTilingVArr[n].value = (ATfn_.GetINI 0 loadingINI MapTypeNamesArr[n] "VTiling" 1.0)
	spnrTilingUArr[n].enabled = spnrTilingVArr[n].enabled = OnOffSt
	ddlHDRIColSpArr[n].selection = (ATfn_.GetINI 0 loadingINI MapTypeNamesArr[n] "HDRIColorSpace" 2)
	ddlHDRIColSpArr[n].enabled = OnOffSt
	chbtnColCorArr[n].checked = (if OnOffSt then (ATfn_.GetINI 0 loadingINI MapTypeNamesArr[n] "ColorCorrectState" false) else (false))
	fn_setHighlightColor chbtnColCorArr[n] (ATfn_.GetINI 0 loadingINI "Settings" "CheckboxColor" [255,156,0])
	chbtnColCorArr[n].enabled = OnOffSt
	spnrCCGammaContrastArr[n].value = (ATfn_.GetINI 0 loadingINI MapTypeNamesArr[n] "ColCorGammaContrast" 1.0)
	spnrCCGammaContrastArr[n].enabled = OnOffSt
	spnrCCRGBArr[n].value = (ATfn_.GetINI 0 loadingINI MapTypeNamesArr[n] "ColCorRGB" 100)
	spnrCCRGBArr[n].enabled = OnOffSt
	btnMapTypeArr[n].enabled = OnOffSt
	btnMapSizeArr[n].enabled = OnOffSt
	chbtnComposArr[n].checked = (if OnOffSt then (ATfn_.GetINI 0 loadingINI MapTypeNamesArr[n] "CompositeState" false) else (false))
	fn_setHighlightColor chbtnComposArr[n] (ATfn_.GetINI 0 loadingINI "Settings" "CheckboxColor" [255,156,0])
	chbtnComposArr[n].enabled = OnOffSt
	chbtnOCIOArr[n].checked = (if OnOffSt then (ATfn_.GetINI 0 loadingINI MapTypeNamesArr[n] "OCIOState" false) else (false))
	fn_setHighlightColor chbtnOCIOArr[n] (ATfn_.GetINI 0 loadingINI "Settings" "CheckboxColor" [255,156,0])
	chbtnOCIOArr[n].enabled = OnOffSt
	)
ddlTextureArr.items = #()
ddlTextureArr.enabled = false
chbtn_SpecialRule.checked = edt_SpecialRule.enabled = (ATfn_.GetINI 0 loadingINI "Settings" "SpecialRuleState" false)
fn_setHighlightColor chbtn_SpecialRule (ATfn_.GetINI 0 loadingINI "Settings" "CheckboxColor" [255,156,0])
edt_SpecialRule.text = (ATfn_.GetINI 1 loadingINI "Settings" "SpecialRuleExpression" "#")
ddl_BRDFtype.selection = (ATfn_.GetINI 0 loadingINI "VRayMaterial" "BRDFtype" 4)
rdbtn_GlossiOrRough.state = (ATfn_.GetINI 0 loadingINI "VRayMaterial" "GlossiOrRough" 1)
chbtn_Blend.checked = (ATfn_.GetINI 0 loadingINI "Settings" "BlendState" false)
fn_setHighlightColor chbtn_Blend (ATfn_.GetINI 0 loadingINI "Settings" "CheckboxColor" [255,156,0])
)
	-----fn------------------------------------------------------------------------------------------------------------
	-------------------------------------------------------------------------------------------------------------------
on tmr_prgrsFade tick do
(
local pc = prgrs_FromObjMode.color; local k1 = 66
local R = if pc.r<k1 then (pc.r + 1) else k1; local G = if pc.g>68 then (pc.g - 3) else 68; local B = if pc.b<k1 then (pc.b + 1) else k1
prgrs_FromObjMode.color = [R, G, B]; if G<=68 then (tmr_prgrsFade.active = false)
)
	-------------------------------------------------------------------------------------------------------------------
on rdbtn_GlossiOrRough changed state do
(
case state of
	(
	1: (lbl_HGlossinessState.text = "HGlossiness"; lbl_RGlossinessState.text = "RGlossiness")
	2: (lbl_HGlossinessState.text = "HRoughness"; lbl_RGlossinessState.text = "RRoughness")
	)
)
	-------------------------------------------------------------------------------------------------------------------
on btn_WireColorByMaterial pressed do
(
local matArr = for selObj in selection where (selObj.material != undefined) collect selObj.material
for mat in matArr do
	(
	local randCol = ATfn_.RandomColor()
	for objct in selection where (objct.material == mat) do (objct.wirecolor = randCol)
	)
)
	-------------------------------------------------------------------------------------------------------------------
on btn_MapsType pressed do (local State = chbtnStateArr[1].checked; for n=1 to 20 do (fn_chbtnState n (not State); chbtnStateArr[n].checked = not State))
	-------------------------------------------------------------------------------------------------------------------
on btn_SearchNames pressed do (for n=1 to 20 do (if chbtnStateArr[n].checked then (edtSearchNameArr[n].text = "")))
	-------------------------------------------------------------------------------------------------------------------
on btn_Textures pressed do (for n=1 to 20 do (if chbtnStateArr[n].checked then (fn_chbtnSearch_RMB n)))
	-------------------------------------------------------------------------------------------------------------------
on btn_Loaders pressed do (for n=1 to 20 do (ddlLoaderArr[n].selection = 1))
	-------------------------------------------------------------------------------------------------------------------
on btn_Loaders rightclick do
(
local sel = ddlLoaderArr[1].selection
for n=1 to 20 do
	(
	if sel != 4
	then (ddlLoaderArr[n].selection = sel + 1)
	else (ddlLoaderArr[n].selection = 1)
	ddlHDRIColSpArr[n].enabled = ((ddlLoaderArr[n].selection == 4) and (chbtnStateArr[n].checked))
	)
)
	-------------------------------------------------------------------------------------------------------------------
on btn_OCIO pressed do
(
local enableState = false
for n=1 to 20 do (if chbtnOCIOArr[n].enabled then enableState = chbtnOCIOArr[n].checked)
for n=1 to 20 do (if chbtnStateArr[n].checked then (chbtnOCIOArr[n].checked = not enableState))
)
	-------------------------------------------------------------------------------------------------------------------
on btn_Tiling pressed do (for n=1 to 20 do (spnrTilingUArr[n].value = spnrTilingVArr[n].value = 1))
	-------------------------------------------------------------------------------------------------------------------
on btn_ColorSpace pressed do (for n=1 to 20 do (ddlHDRIColSpArr[n].selection  = 2))
	-------------------------------------------------------------------------------------------------------------------
on btn_ColorSpace rightclick do
(
local sel = ddlHDRIColSpArr[1].selection
for n=1 to 18 do
	(
	if sel != 4
	then (ddlHDRIColSpArr[n].selection = sel + 1)
	else (ddlHDRIColSpArr[n].selection = 1)
	)
)
	-------------------------------------------------------------------------------------------------------------------
on btn_ColorCorrect pressed do
(
local enableState = false
for n=1 to 20 do (if chbtnColCorArr[n].enabled then enableState = chbtnColCorArr[n].checked)
for n=1 to 20 do (if chbtnStateArr[n].checked then (chbtnColCorArr[n].checked = not enableState))
)
	-------------------------------------------------------------------------------------------------------------------
on btn_Gamma pressed do (for n=1 to 20 do (spnrCCGammaContrastArr[n].value = spnrCCGammaContrastArr[n].value = 1))
	-------------------------------------------------------------------------------------------------------------------
on btn_RGB pressed do (for n=1 to 20 do (spnrCCRGBArr[n].value = spnrCCRGBArr[n].value = 100))
	-------------------------------------------------------------------------------------------------------------------
on btn_Composite pressed do
(
local enableState = false
for n=1 to 20 do (if chbtnComposArr[n].enabled then enableState = chbtnComposArr[n].checked)
for n=1 to 20 do (if chbtnStateArr[n].checked then (chbtnComposArr[n].checked = not enableState))
)
	-------------------------------------------------------------------------------------------------------------------
on chbtn_FromObjMode changed state do 
(
for ddl in ddlFildsArr do (ddl.enabled = not state); for edt in edtFildsArr do (edt.enabled = not state)
for n=1 to 20 where chbtnStateArr[n].checked do (chbtnStatusArr[n].enabled = not state; btnBrowseArr[n].enabled = not state)
btn_SearchTextures.enabled = btn_FildsClear.enabled = btn_RenameGet.enabled = not state
)
	-------------------------------------------------------------------------------------------------------------------
on chbtn_ObjectFild1 rightclick do (fn_chbtnObjectFild 1)
on chbtn_LayerFild1 rightclick do (fn_chbtnLayerFild 1)
on chbtn_MaterialFild1 rightclick do (fn_chbtnMaterialFild 1)
	-------------------------------------------------------------------------------------------------------------------
on chbtn_ObjectFild2 rightclick do (fn_chbtnObjectFild 2)
on chbtn_LayerFild2 rightclick do (fn_chbtnLayerFild 2)
on chbtn_MaterialFild2 rightclick do (fn_chbtnMaterialFild 2)
	-------------------------------------------------------------------------------------------------------------------
on chbtn_ObjectFild3 rightclick do (fn_chbtnObjectFild 3)
on chbtn_LayerFild3 rightclick do (fn_chbtnLayerFild 3)
on chbtn_MaterialFild3 rightclick do (fn_chbtnMaterialFild 3)
	-------------------------------------------------------------------------------------------------------------------
on chbtn_ObjectFild4 rightclick do (fn_chbtnObjectFild 4)
on chbtn_LayerFild4 rightclick do (fn_chbtnLayerFild 4)
on chbtn_MaterialFild4 rightclick do (fn_chbtnMaterialFild 4)
	-------------------------------------------------------------------------------------------------------------------
on chbtn_ObjectFild5 rightclick do (fn_chbtnObjectFild 5)
on chbtn_LayerFild5 rightclick do (fn_chbtnLayerFild 5)
on chbtn_MaterialFild5 rightclick do (fn_chbtnMaterialFild 5)
	-------------------------------------------------------------------------------------------------------------------
on chbtn_ObjectFild6 rightclick do (fn_chbtnObjectFild 6)
on chbtn_LayerFild6 rightclick do (fn_chbtnLayerFild 6)
on chbtn_MaterialFild6 rightclick do (fn_chbtnMaterialFild 6)
	-------------------------------------------------------------------------------------------------------------------
on chbtn_ObjectFild7 rightclick do (fn_chbtnObjectFild 7)
on chbtn_LayerFild7 rightclick do (fn_chbtnLayerFild 7)
on chbtn_MaterialFild7 rightclick do (fn_chbtnMaterialFild 7)
	-------------------------------------------------------------------------------------------------------------------
on chbtn_ObjectFild8 rightclick do (fn_chbtnObjectFild 8)
on chbtn_LayerFild8 rightclick do (fn_chbtnLayerFild 8)
on chbtn_MaterialFild8 rightclick do (fn_chbtnMaterialFild 8)
	-------------------------------------------------------------------------------------------------------------------
--ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ---Fild_01---ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ
on edt_Fild_01 changed arg do (edt_Fild_01.text = (fn_nameRistrictSymbols arg))
on ddl_Fild_01 selected item do (fn_ddlFild_LMB 1 item)
on ddl_Fild_01 rightclick do (fn_ddlFild_RMB 1)
--ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ---Fild_02---ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ
on edt_Fild_02 changed arg do (edt_Fild_02.text = (fn_nameRistrictSymbols arg))
on ddl_Fild_02 selected item do (fn_ddlFild_LMB 2 item)
on ddl_Fild_02 rightclick do (fn_ddlFild_RMB 2)
--ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ---Fild_03---ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ
on edt_Fild_03 changed arg do (edt_Fild_03.text = (fn_nameRistrictSymbols arg))
on ddl_Fild_03 selected item do (fn_ddlFild_LMB 3 item)
on ddl_Fild_03 rightclick do (fn_ddlFild_RMB 3)
--ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ---Fild_04---ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ
on edt_Fild_04 changed arg do (edt_Fild_04.text = (fn_nameRistrictSymbols arg))
on ddl_Fild_04 selected item do (fn_ddlFild_LMB 4 item)
on ddl_Fild_04 rightclick do (fn_ddlFild_RMB 4)
--ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ---Fild_05---ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ
on edt_Fild_05 changed arg do (edt_Fild_05.text = (fn_nameRistrictSymbols arg))
on ddl_Fild_05 selected item do (fn_ddlFild_LMB 5 item)
on ddl_Fild_05 rightclick do (fn_ddlFild_RMB 5)
--ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ---Fild_06---ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ
on edt_Fild_06 changed arg do (edt_Fild_06.text = (fn_nameRistrictSymbols arg))
on ddl_Fild_06 selected item do (fn_ddlFild_LMB 6 item)
on ddl_Fild_06 rightclick do (fn_ddlFild_RMB 6)
--ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ---Fild_07---ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ
on edt_Fild_07 changed arg do (edt_Fild_07.text = (fn_nameRistrictSymbols arg))
on ddl_Fild_07 selected item do (fn_ddlFild_LMB 7 item)
on ddl_Fild_07 rightclick do (fn_ddlFild_RMB 7)
--ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ---Fild_08---ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ
on edt_Fild_08 changed arg do (edt_Fild_08.text = (fn_nameRistrictSymbols arg))
on ddl_Fild_08 selected item do (fn_ddlFild_LMB 8 item)
on ddl_Fild_08 rightclick do (fn_ddlFild_RMB 8)
--ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ
	-------------------------------------------------------------------------------------------------------------------
on btn_RenameObject pressed do
(
local curSel = for objct in (selection as array) where not (isGroupHead objct) collect objct; qSort curSel ATfn_.CompareNames
	undo on
if chbtn_FromObjMode.checked
then   ---------------------------------------------------------------------------------------------------
	(
	local newObjArr = #()
	local newNamesArr = #()
	for objct in curSel where ((fn_fromObject_ObjectName objct) != "") do (append newObjArr objct; append newNamesArr (fn_fromObject_ObjectName objct) )
	local oldNamesArrArr = #()
	for nN=1 to newNamesArr.count do (oldNamesArr= #(); for snN=1 to newNamesArr.count where (newNamesArr[nN]==newNamesArr[snN]) do (append oldNamesArr newObjArr[snN].name; appendIfUnique oldNamesArrArr oldNamesArr))
	local oldNamesArrArrUniqueStr = #()
	for el in oldNamesArrArr do (appendIfUnique oldNamesArrArrUniqueStr (el as string))
	local oldNamesArrArrUnique = #()
	for el in oldNamesArrArrUniqueStr do (append oldNamesArrArrUnique (execute el))
	for Narr in oldNamesArrArrUnique do
		(
-- 		if Narr.count == 1
-- 		then ( if chbtn_OneObjCounter.checked then ((getNodeByName Narr[1]).name = (fn_fromObject_ObjectName (getNodeByName Narr[1]) + "_001")) else ((getNodeByName Narr[1]).name = fn_fromObject_ObjectName (getNodeByName Narr[1])) )
-- 		else (for n=1 to Narr.count do ( (getNodeByName Narr[n]).name = ((fn_fromObject_ObjectName (getNodeByName Narr[n])) + (fn_Delim()) + (if n<10 then ("00"+(n as string)) else (if n<100 then ("0"+(n as string)) else (n as string)))) ))
		if chbtn_OneObjCounter.checked
		then (for n=1 to Narr.count do ( (getNodeByName Narr[n]).name = ((fn_fromObject_ObjectName (getNodeByName Narr[n])) + (fn_Delim()) + (if n<10 then ("00"+(n as string)) else (if n<100 then ("0"+(n as string)) else (n as string)))) ))
		else (for n=1 to Narr.count do ( (getNodeByName Narr[n]).name = ( ( fn_fromObject_ObjectName (getNodeByName Narr[n]) ) ) ) )
		)
	)
else   ---------------------------------------------------------------------------------------------------
	(
	local ObjectName = fn_fromFilds_ObjectName()
	if ObjectName != ""
	then
		(
		if curSel.count != 0
		then
			(
-- 			if curSel.count == 1
-- 			then (if chbtn_OneObjCounter.checked then (curSel[1].name = ObjectName + "_001") else (curSel[1].name = ObjectName))
-- 			else (if chbtn_OneObjCounter.checked then (ATfn_.RenameAddCounter ObjectName curSel Separator:(fn_Delim()) CounterDigits:3) else (curSel.name = ObjectName))
			if chbtn_OneObjCounter.checked then (ATfn_.RenameAddCounter ObjectName curSel Separator:(fn_Delim()) CounterDigits:3) else (curSel.name = ObjectName)
			)
		else (messageBox "Objects not renamed." title:"No selection" beep:false)
		)
	)
curSel.wirecolor = ATfn_.RandomColor()
)
	-------------------------------------------------------------------------------------------------------------------
on btn_ObjectToLayer pressed do
(
ungroup selection; local curSel = selection as array; qSort curSel ATfn_.CompareNames
	undo on
if chbtn_FromObjMode.checked
then   ---------------------------------------------------------------------------------------------------
	(
	for objct in curSel do
		(
		local layerName = fn_fromObject_LayerName objct
		if layerName != ""
		then
			(
			layermanager.newLayerFromName layerName
			local objctLayer = LayerManager.getlayerfromName layerName
			objctLayer.current = true
			objctLayer.addNode objct
			)
		)
	)
else   ---------------------------------------------------------------------------------------------------
	(
	local layerName = fn_fromFilds_LayerName()
	if layerName != ""
	then
		(
		layermanager.newLayerFromName layerName
		local objctLayer = LayerManager.getlayerfromName layerName
		objctLayer.current = true
		for objct in curSel do objctLayer.addNode objct
		)
	)
curSel.wirecolor = ATfn_.RandomColor()
)
	-------------------------------------------------------------------------------------------------------------------
on btn_CreateMaterial pressed do (undo on; fn_btnObjectsRenameAddToLayerCreateMaterial false false)
	-------------------------------------------------------------------------------------------------------------------
on btn_ObjLayerCreateMat pressed do (undo on; fn_btnObjectsRenameAddToLayerCreateMaterial true true)
	-------------------------------------------------------------------------------------------------------------------
on btn_SearchTextures pressed do 
(
clearlistener()
windows.processPostedMessages()
local startTime = timeStamp()
local ddlRootsItems
if chbtn_MultiStatus.checked then (ddlRootsItems = fn_deleteSubdirs (ddl_Roots.items)) else (try (ddlRootsItems = #((ddl_Roots.items)[ddl_Roots.selection])) catch (ddlRootsItems = #()))
ddlRootsItems = fn_slashReplaceR ddlRootsItems
local mainNameArr = fn_fromFilds_SearchNameArr()
local tempMNArr = #()
if chbtn_SpecialRule.checked then (for mn in mainNameArr do (appendIfUnique tempMNArr (substituteString edt_SpecialRule.text "#" mn)); mainNameArr = tempMNArr)
local mainFilesArr = #()
local filesArr = #()
local deniedArr = #()
if ddlRootsItems.count != 0 then
(
if (mainNameArr.count == 0 and fn_mapsSearchNoNamesCheck())
then (messageBox "Search filds empty." title:"Search data missing" beep:false)
else
	(
	if mainNameArr.count != 0
	then
		(
		if mainNameArr.count == 1
		then
			(
			collectResult = fn_dotNetCollectFiles foldersArr:ddlRootsItems pattern:(mainNameArr[1]) extensions:(ATfn_.GetINI 0 iniFile "Settings" "TypesOfExtensionForSearch" #(".jpg"))
			deniedArr = deepCopy collectResult[2]
			mainFilesArr = deepCopy collectResult[1]
			)
		else
			(
			local operatingArr = #()
			collectResult = fn_dotNetCollectFiles foldersArr:ddlRootsItems pattern:(mainNameArr[1]) extensions:(ATfn_.GetINI 0 iniFile "Settings" "TypesOfExtensionForSearch" #(".jpg"))
			deniedArr = deepCopy collectResult[2]
			mainFilesArr = deepCopy collectResult[1]
			for mN=2 to mainNameArr.count do
				(
				filesArr = for filePath in mainFilesArr where ( matchPattern (getFilenameFile filePath) pattern:("*"+(mainNameArr[mN])+"*") ) collect filePath
				mainFilesArr = deepCopy filesArr
				)
			)
		for dir in deniedArr do (format "!!!  Access denied:   %\n" dir)
		)
	for n=1 to 20 do (if chbtnStateArr[n].checked then (fn_mapSearch n ddlRootsItems mainNameArr mainFilesArr))
	)
)
else 
(
messageBox "List of directories empty." title:"Search data missing" beep:false
)
format "Processing took % seconds\n" (filterString (((dotnetclass "TimeSpan").FromMilliseconds (timeStamp() - starttime)).ToString()) ".")[1]
)
	-------------------------------------------------------------------------------------------------------------------
on btn_SearchTextures rightclick do (for n=1 to 20 do (if chbtnStateArr[n].checked then (ddlTextureArr[n].items = #(); ddlTextureArr[n].enabled = false; chbtnStatusArr[n].highlightColor = colZ; chbtnStatusArr[n].checked = false; chbtnStatusArr[n].checked = true; btnMapTypeArr[n].caption = btnMapSizeArr[n].caption = ""; btnMapSizeArr[n].tooltip = tt_btn_MapSize; btnMapTypeArr[n].enabled = btnMapSizeArr[n].enabled = false)))
	-------------------------------------------------------------------------------------------------------------------
on btn_SClear pressed do (Sstate = chbtnSearchFildsArr[1].checked; for chbtn in chbtnSearchFildsArr do (chbtn.checked = not Sstate))
on btn_SClear rightclick do (fn_SOLMClear())
	-------------------------------------------------------------------------------------------------------------------
on btn_OClear pressed do (Sstate = chbtnObjectFildsArr[1].checked; for chbtn in chbtnObjectFildsArr do (chbtn.checked = not Sstate))
on btn_OClear rightclick do (fn_SOLMClear())
	-------------------------------------------------------------------------------------------------------------------
on btn_LClear pressed do (Sstate = chbtnLayerFildsArr[1].checked; for chbtn in chbtnLayerFildsArr do (chbtn.checked = not Sstate))
on btn_LClear rightclick do (fn_SOLMClear())
	-------------------------------------------------------------------------------------------------------------------
on btn_MClear pressed do (Sstate = chbtnMaterialFildsArr[1].checked; for chbtn in chbtnMaterialFildsArr do (chbtn.checked = not Sstate))
on btn_MClear rightclick do (fn_SOLMClear())
	-------------------------------------------------------------------------------------------------------------------
on btn_FildsClear pressed do (for edt in edtFildsArr do (edt.text = ""))
	-------------------------------------------------------------------------------------------------------------------
on btn_RenameGet pressed do
(
if selection.count != 0
then
	(
	local curSel = for objct in (selection as array) where not (isGroupHead objct) collect objct; nameStr = (ATfn_.RemoveCounter curSel[1].name); nameArr = filterString nameStr (fn_Delim())
	for edt in edtFildsArr do (edt.text = ""); for n=1 to edtFildsArr.count do (if nameArr[n] != undefined then edtFildsArr[n].text = nameArr[n])
	)
)
	-------------------------------------------------------------------------------------------------------------------
--OOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO
on ddl_RootsSaved selected item do
(
if keyboard.altPressed
	then
		(
		RootsArr = ddl_RootsSaved.items
		deleteItem RootsArr item
		ddl_RootsSaved.items = deepCopy RootsArr
		ATfn_.ddlWidthDynamic ddl_RootsSaved
		)
	else
		(
		rootToList = (ddl_RootsSaved.items)[item]
		ddl_Roots.enabled = true; btn_Del.enabled = true; btn_All.enabled = true; btn_Sel.enabled = true; btn_Sub.enabled = true
		rootsArr = ddl_Roots.items
		appendIfUnique rootsArr rootToList
		sort rootsArr
		ddl_Roots.items = deepCopy rootsArr
		if (findItem rootsArr rootToList) != 0 then (ddl_Roots.selection = findItem rootsArr rootToList) else (ddl_Roots.selection = 1)
		setINISetting iniFile "MainDirectory" "LastUsed" rootToList
		setFocus ddl_Roots
		)
)
	-------------------------------------------------------------------------------------------------------------------
on ddl_RootsSaved rightclick do
(
if keyboard.altPressed
	then
		(
		RootsArr = ddl_RootsSaved.items
		selectedDir = ((ddl_Roots.items)[ddl_Roots.selection])
		if (ddl_Roots.items).count != 0 then ((appendIfUnique RootsArr selectedDir); sort RootsArr)
		ddl_RootsSaved.items = deepCopy RootsArr
		ATfn_.ddlWidthDynamic ddl_RootsSaved
		)
	else
		(
		)
)
	-------------------------------------------------------------------------------------------------------------------
on ddl_Roots selected item do
(
if keyboard.altPressed
then
	(
	if (ddl_Roots.items).count > 1
		then
			(
			RootsArr = ddl_Roots.items
			deleteItem RootsArr item
			ddl_Roots.items = deepCopy RootsArr
			if RootsArr.count < item then (ddl_Roots.selection = (item-1)) else (ddl_Roots.selection = item)
			setFocus ddl_Roots
			)
		else (if (ddl_Roots.items).count == 1 then (ddl_Roots.items = #(); ddl_Roots.enabled = false; btn_Del.enabled = false; btn_All.enabled = false; btn_Sel.enabled = false; btn_Sub.enabled = false))
	)
else ()
)
	-------------------------------------------------------------------------------------------------------------------
on btn_RootBrowse pressed do
(
initialDir = ATfn_.GetINI 1 iniFile "MainDirectory" "LastUsed" ""
mainDIR = getSavePath caption:"Select Folder" initialDir:initialDir
if mainDIR != undefined
	then
		(
		mainDIR = fn_slashReplacePathL mainDIR
		ddl_Roots.enabled = true; btn_Del.enabled = true; btn_All.enabled = true; btn_Sel.enabled = true; btn_Sub.enabled = true
		rootsArr = ddl_Roots.items
		appendIfUnique rootsArr mainDIR
		sort rootsArr
		ddl_Roots.items = deepCopy rootsArr
		if (findItem rootsArr mainDIR) != 0 then (ddl_Roots.selection = findItem rootsArr mainDIR) else (ddl_Roots.selection = 1)
		setFocus ddl_Roots
		setINISetting iniFile "MainDirectory" "LastUsed" mainDIR
		)
	else ()
)
	-------------------------------------------------------------------------------------------------------------------
on btn_RootBrowse rightclick do
(
initialDir = ATfn_.GetINI 1 iniFile "MainDirectory" "LastUsed" ""
mainDIR = getSavePath caption:"Select Folder" initialDir:initialDir
if mainDIR != undefined
	then
		(
		mainDIR = fn_slashReplacePathL mainDIR
		subDirArr = #()
		if mainDIR.count == 3 then (subDirArr = GetDirectories (mainDIR + "*")) else (subDirArr = GetDirectories (mainDIR + "\*"))
		if subDirArr.count == 0
			then (ddl_Roots.items = #(); ddl_Roots.enabled = false; btn_Del.enabled = false; btn_All.enabled = false; btn_Sel.enabled = false; btn_Sub.enabled = false)
			else
				(
				ddl_Roots.enabled = true; btn_Del.enabled = true; btn_All.enabled = true; btn_Sel.enabled = true; btn_Sub.enabled = true
				rootsArr = ddl_Roots.items
				for subDir in subDirArr do (appendIfUnique rootsArr (replace subDir subDir.count 1 ""))
				sort rootsArr
				ddl_Roots.items = deepCopy rootsArr
				if (findItem rootsArr mainDIR) != 0 then (ddl_Roots.selection = findItem rootsArr mainDIR) else (ddl_Roots.selection = 1)
				ddl_Roots.selection = 1
				)
		setFocus ddl_Roots
		setINISetting iniFile "MainDirectory" "LastUsed" mainDIR
		)
	else ()
)
	-------------------------------------------------------------------------------------------------------------------
on btn_Del pressed do
(
if (ddl_Roots.items).count > 1
	then
		(
		item = ddl_Roots.selection
		RootsArr = ddl_Roots.items
		deleteItem RootsArr item
		ddl_Roots.items = deepCopy RootsArr
		if RootsArr.count < item then (ddl_Roots.selection = (item-1)) else (ddl_Roots.selection = item)
		setFocus ddl_Roots
		)
	else (if (ddl_Roots.items).count == 1 then (ddl_Roots.items = #(); ddl_Roots.enabled = false; btn_Del.enabled = false; btn_All.enabled = false; btn_Sel.enabled = false; btn_Sub.enabled = false))
)
	-------------------------------------------------------------------------------------------------------------------
on btn_All pressed do (ddl_Roots.items = #(); ddl_Roots.enabled = false; btn_Del.enabled = false; btn_All.enabled = false; btn_Sel.enabled = false; btn_Sub.enabled = false)
	-------------------------------------------------------------------------------------------------------------------
on btn_Sel pressed do
(
RootStr = (ddl_Roots.items)[ddl_Roots.selection]
RootsArr = #()
append RootsArr RootStr
ddl_Roots.items = deepCopy RootsArr
ddl_Roots.selection = 1
)
	-------------------------------------------------------------------------------------------------------------------
on btn_Sub pressed do
(
initialDir = ATfn_.GetINI 1 iniFile "MainDirectory" "LastUsed" ""
mainDIR=(ddl_Roots.items)[ddl_Roots.selection]
if mainDIR != undefined
	then
		(
		mainDIR = fn_slashReplacePathL mainDIR
		subDirArr = #()
		if mainDIR.count == 3 then (subDirArr = GetDirectories (mainDIR + "*")) else (subDirArr = GetDirectories (mainDIR + "\*"))
		if subDirArr.count == 0
			then ()
			else
				(
				rootsArr = #()
				for subDir in subDirArr do (appendIfUnique rootsArr (replace subDir subDir.count 1 ""))
				sort rootsArr
				ddl_Roots.items = deepCopy rootsArr
				ddl_Roots.selection = 1
				)
		setFocus ddl_Roots
		setINISetting iniFile "MainDirectory" "LastUsed" mainDIR
		)
	else ()
)
	-------------------------------------------------------------------------------------------------------------------
on btn_MinimizeUI pressed do
(
if rollout_MaterialLoader.dialogBar == false
then
	(
	if rollout_MaterialLoader.height != roll0H then (rollout_MaterialLoader.height = roll0H; btn_MinimizeUI.caption = "-") else (rollout_MaterialLoader.height = roll0minH; btn_MinimizeUI.caption = "+")
	setFocus rollout_MaterialLoader
	)
)
	-------------------------------------------------------------------------------------------------------------------
on btn_DockTop pressed do
(
-- if (try(cui.getDockState rollout_MaterialLoader) catch(false)) == false
if rollout_MaterialLoader.dialogBar == false
then
	(
	rollout_MaterialLoader.height = roll0minH-2; btn_MinimizeUI.caption = "+"
	try (setINISetting iniFile "DialogPosition" "LastPosition" ((GetDialogPos rollout_MaterialLoader) as string)) catch()
	cui.RegisterDialogBar rollout_MaterialLoader style:#(#cui_dock_horz)
	cui.DockDialogBar rollout_MaterialLoader #cui_dock_top
	)
else
	(
	if cui.getDockState rollout_MaterialLoader == #cui_dock_bottom
	then
		(
		cui.DockDialogBar rollout_MaterialLoader #cui_dock_top
		)
	else
		(
-- 		cui.DockDialogBar rollout_MaterialLoader #cui_floatable
		cui.UnRegisterDialogBar rollout_MaterialLoader
		SetDialogPos rollout_MaterialLoader (ATfn_.GetINI 0 iniFile "DialogPosition" "LastPosition" [5,30])
		rollout_MaterialLoader.width = roll0W
		rollout_MaterialLoader.height = roll0H
		)
	)
-- try(cui.UnRegisterDialogBar rollout_MaterialLoader)catch()
setINISetting iniFile "DialogPosition" "DockState" ((try (cui.getDockState rollout_MaterialLoader) catch(undefined)) as string)
)
	-------------------------------------------------------------------------------------------------------------------
on btn_DockBottom pressed do
(
-- if (try(cui.getDockState rollout_MaterialLoader) catch(false)) == false
if rollout_MaterialLoader.dialogBar == false
then
	(
	rollout_MaterialLoader.height = roll0minH-2; btn_MinimizeUI.caption = "+"
	try (setINISetting iniFile "DialogPosition" "LastPosition" ((GetDialogPos rollout_MaterialLoader) as string)) catch()
	cui.RegisterDialogBar rollout_MaterialLoader style:#(#cui_dock_horz)
	cui.DockDialogBar rollout_MaterialLoader #cui_dock_bottom
	)
else
	(
	if cui.getDockState rollout_MaterialLoader == #cui_dock_top
	then
		(
		cui.DockDialogBar rollout_MaterialLoader #cui_dock_bottom
		)
	else
		(
-- 		cui.DockDialogBar rollout_MaterialLoader #cui_floatable
		cui.UnRegisterDialogBar rollout_MaterialLoader
		SetDialogPos rollout_MaterialLoader (ATfn_.GetINI 0 iniFile "DialogPosition" "LastPosition" [5,30])
		rollout_MaterialLoader.width = roll0W
		rollout_MaterialLoader.height = roll0H
		)
	)
-- try(cui.UnRegisterDialogBar rollout_MaterialLoader)catch()
setINISetting iniFile "DialogPosition" "DockState" ((try (cui.getDockState rollout_MaterialLoader) catch(undefined)) as string)
)
--OOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO
--ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ---Diffuse---ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ
on chbtn_DiffuseState changed state do (fn_chbtnState 1 state)
on ddl_DiffuseSearchName selected item do (fn_ddlSearchName_LMB 1 item)
on ddl_DiffuseSearchName rightclick do (fn_ddlSearchName_RMB 1)
on edt_DiffuseSearchName changed arg do (edt_DiffuseSearchName.text = (fn_nameRistrictSymbols arg))
on chbtn_DiffuseStatus changed state do (fn_chbtnSearch_LMB 1)
on chbtn_DiffuseStatus rightclick do (fn_chbtnSearch_RMB 1)
on ddl_DiffuseTexture selected item do (fn_getTexExtSize 1 true true)
on ddl_DiffuseTexture rightclick do (fn_ddlTex_RMB 1)
on btn_DiffuseBrowse pressed do (fn_btnBrow_LMB 1)
on btn_DiffuseBrowse rightclick do (fn_btnBrow_RMB 1)
on btn_DiffuseMapType pressed do (fn_rollRenameConvertResize 1)
on btn_DiffuseMapSize pressed do (fn_rollRenameConvertResize 1)
--ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ---Roughness---ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ
on chbtn_RoughnessState changed state do (fn_chbtnState 2 state)
on ddl_RoughnessSearchName selected item do (fn_ddlSearchName_LMB 2 item)
on ddl_RoughnessSearchName rightclick do (fn_ddlSearchName_RMB 2)
on edt_RoughnessSearchName changed arg do (edt_RoughnessSearchName.text = (fn_nameRistrictSymbols arg))
on chbtn_RoughnessStatus changed state do (fn_chbtnSearch_LMB 2)
on chbtn_RoughnessStatus rightclick do (fn_chbtnSearch_RMB 2)
on ddl_RoughnessTexture selected item do (fn_getTexExtSize 2 true true)
on ddl_RoughnessTexture rightclick do (fn_ddlTex_RMB 2)
on btn_RoughnessBrowse pressed do (fn_btnBrow_LMB 2)
on btn_RoughnessBrowse rightclick do (fn_btnBrow_RMB 2)
on btn_RoughnessMapType pressed do (fn_rollRenameConvertResize 2)
on btn_RoughnessMapSize pressed do (fn_rollRenameConvertResize 2)
--ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ---SelfIllum---ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ
on chbtn_SelfIllumState changed state do (fn_chbtnState 3 state)
on ddl_SelfIllumSearchName selected item do (fn_ddlSearchName_LMB 3 item)
on ddl_SelfIllumSearchName rightclick do (fn_ddlSearchName_RMB 3)
on edt_SelfIllumSearchName changed arg do (edt_SelfIllumSearchName.text = (fn_nameRistrictSymbols arg))
on chbtn_SelfIllumStatus changed state do (fn_chbtnSearch_LMB 3)
on chbtn_SelfIllumStatus rightclick do (fn_chbtnSearch_RMB 3)
on ddl_SelfIllumTexture selected item do (fn_getTexExtSize 3 true true)
on ddl_SelfIllumTexture rightclick do (fn_ddlTex_RMB 3)
on btn_SelfIllumBrowse pressed do (fn_btnBrow_LMB 3)
on btn_SelfIllumBrowse rightclick do (fn_btnBrow_RMB 3)
on btn_SelfIllumMapType pressed do (fn_rollRenameConvertResize 3)
on btn_SelfIllumMapSize pressed do (fn_rollRenameConvertResize 3)
--ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ---Reflect---ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ
on chbtn_ReflectState changed state do (fn_chbtnState 4 state)
on ddl_ReflectSearchName selected item do (fn_ddlSearchName_LMB 4 item)
on ddl_ReflectSearchName rightclick do (fn_ddlSearchName_RMB 4)
on edt_ReflectSearchName changed arg do (edt_ReflectSearchName.text = (fn_nameRistrictSymbols arg))
on chbtn_ReflectStatus changed state do (fn_chbtnSearch_LMB 4)
on chbtn_ReflectStatus rightclick do (fn_chbtnSearch_RMB 4)
on ddl_ReflectTexture selected item do (fn_getTexExtSize 4 true true)
on ddl_ReflectTexture rightclick do (fn_ddlTex_RMB 4)
on btn_ReflectBrowse pressed do (fn_btnBrow_LMB 4)
on btn_ReflectBrowse rightclick do (fn_btnBrow_RMB 4)
on btn_ReflectMapType pressed do (fn_rollRenameConvertResize 4)
on btn_ReflectMapSize pressed do (fn_rollRenameConvertResize 4)
--ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ---HGlossiness---ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ
on chbtn_HGlossinessState changed state do (fn_chbtnState 5 state)
on ddl_HGlossinessSearchName selected item do (fn_ddlSearchName_LMB 5 item)
on ddl_HGlossinessSearchName rightclick do (fn_ddlSearchName_RMB 5)
on edt_HGlossinessSearchName changed arg do (edt_HGlossinessSearchName.text = (fn_nameRistrictSymbols arg))
on chbtn_HGlossinessStatus changed state do (fn_chbtnSearch_LMB 5)
on chbtn_HGlossinessStatus rightclick do (fn_chbtnSearch_RMB 5)
on ddl_HGlossinessTexture selected item do (fn_getTexExtSize 5 true true)
on ddl_HGlossinessTexture rightclick do (fn_ddlTex_RMB 5)
on btn_HGlossinessBrowse pressed do (fn_btnBrow_LMB 5)
on btn_HGlossinessBrowse rightclick do (fn_btnBrow_RMB 5)
on btn_HGlossinessMapType pressed do (fn_rollRenameConvertResize 5)
on btn_HGlossinessMapSize pressed do (fn_rollRenameConvertResize 5)
--ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ---RGlossiness---ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ
on chbtn_RGlossinessState changed state do (fn_chbtnState 6 state)
on ddl_RGlossinessSearchName selected item do (fn_ddlSearchName_LMB 6 item)
on ddl_RGlossinessSearchName rightclick do (fn_ddlSearchName_RMB 6)
on edt_RGlossinessSearchName changed arg do (edt_RGlossinessSearchName.text = (fn_nameRistrictSymbols arg))
on chbtn_RGlossinessStatus changed state do (fn_chbtnSearch_LMB 6)
on chbtn_RGlossinessStatus rightclick do (fn_chbtnSearch_RMB 6)
on ddl_RGlossinessTexture selected item do (fn_getTexExtSize 6 true true)
on ddl_RGlossinessTexture rightclick do (fn_ddlTex_RMB 6)
on btn_RGlossinessBrowse pressed do (fn_btnBrow_LMB 6)
on btn_RGlossinessBrowse rightclick do (fn_btnBrow_RMB 6)
on btn_RGlossinessMapType pressed do (fn_rollRenameConvertResize 6)
on btn_RGlossinessMapSize pressed do (fn_rollRenameConvertResize 6)
--ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ---FresnelIOR---ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ
on chbtn_FresnelIORState changed state do (fn_chbtnState 7 state)
on ddl_FresnelIORSearchName selected item do (fn_ddlSearchName_LMB 7 item)
on ddl_FresnelIORSearchName rightclick do (fn_ddlSearchName_RMB 7)
on edt_FresnelIORSearchName changed arg do (edt_FresnelIORSearchName.text = (fn_nameRistrictSymbols arg))
on chbtn_FresnelIORStatus changed state do (fn_chbtnSearch_LMB 7)
on chbtn_FresnelIORStatus rightclick do (fn_chbtnSearch_RMB 7)
on ddl_FresnelIORTexture selected item do (fn_getTexExtSize 7 true true)
on ddl_FresnelIORTexture rightclick do (fn_ddlTex_RMB 7)
on btn_FresnelIORBrowse pressed do (fn_btnBrow_LMB 7)
on btn_FresnelIORBrowse rightclick do (fn_btnBrow_RMB 7)
on btn_FresnelIORMapType pressed do (fn_rollRenameConvertResize 7)
on btn_FresnelIORMapSize pressed do (fn_rollRenameConvertResize 7)
--ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ---Metalness---ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ
on chbtn_MetalnessState changed state do (fn_chbtnState 8 state)
on ddl_MetalnessSearchName selected item do (fn_ddlSearchName_LMB 8 item)
on ddl_MetalnessSearchName rightclick do (fn_ddlSearchName_RMB 8)
on edt_MetalnessSearchName changed arg do (edt_MetalnessSearchName.text = (fn_nameRistrictSymbols arg))
on chbtn_MetalnessStatus changed state do (fn_chbtnSearch_LMB 8)
on chbtn_MetalnessStatus rightclick do (fn_chbtnSearch_RMB 8)
on ddl_MetalnessTexture selected item do (fn_getTexExtSize 8 true true)
on ddl_MetalnessTexture rightclick do (fn_ddlTex_RMB 8)
on btn_MetalnessBrowse pressed do (fn_btnBrow_LMB 8)
on btn_MetalnessBrowse rightclick do (fn_btnBrow_RMB 8)
on btn_MetalnessMapType pressed do (fn_rollRenameConvertResize 8)
on btn_MetalnessMapSize pressed do (fn_rollRenameConvertResize 8)
--ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ---Anisotropy---ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ
on chbtn_AnisotropyState changed state do (fn_chbtnState 9 state)
on ddl_AnisotropySearchName selected item do (fn_ddlSearchName_LMB 9 item)
on ddl_AnisotropySearchName rightclick do (fn_ddlSearchName_RMB 9)
on edt_AnisotropySearchName changed arg do (edt_AnisotropySearchName.text = (fn_nameRistrictSymbols arg))
on chbtn_AnisotropyStatus changed state do (fn_chbtnSearch_LMB 9)
on chbtn_AnisotropyStatus rightclick do (fn_chbtnSearch_RMB 9)
on ddl_AnisotropyTexture selected item do (fn_getTexExtSize 9 true true)
on ddl_AnisotropyTexture rightclick do (fn_ddlTex_RMB 9)
on btn_AnisotropyBrowse pressed do (fn_btnBrow_LMB 9)
on btn_AnisotropyBrowse rightclick do (fn_btnBrow_RMB 9)
on btn_AnisotropyMapType pressed do (fn_rollRenameConvertResize 9)
on btn_AnisotropyMapSize pressed do (fn_rollRenameConvertResize 9)
--ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ---AnRotation---ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ
on chbtn_AnRotationState changed state do (fn_chbtnState 10 state)
on ddl_AnRotationSearchName selected item do (fn_ddlSearchName_LMB 10 item)
on ddl_AnRotationSearchName rightclick do (fn_ddlSearchName_RMB 10)
on edt_AnRotationSearchName changed arg do (edt_AnRotationSearchName.text = (fn_nameRistrictSymbols arg))
on chbtn_AnRotationStatus changed state do (fn_chbtnSearch_LMB 10)
on chbtn_AnRotationStatus rightclick do (fn_chbtnSearch_RMB 10)
on ddl_AnRotationTexture selected item do (fn_getTexExtSize 10 true true)
on ddl_AnRotationTexture rightclick do (fn_ddlTex_RMB 10)
on btn_AnRotationBrowse pressed do (fn_btnBrow_LMB 10)
on btn_AnRotationBrowse rightclick do (fn_btnBrow_RMB 10)
on btn_AnRotationMapType pressed do (fn_rollRenameConvertResize 10)
on btn_AnRotationMapSize pressed do (fn_rollRenameConvertResize 10)
--ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ---Refract---ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ
on chbtn_RefractState changed state do (fn_chbtnState 11 state)
on ddl_RefractSearchName selected item do (fn_ddlSearchName_LMB 11 item)
on ddl_RefractSearchName rightclick do (fn_ddlSearchName_RMB 11)
on edt_RefractSearchName changed arg do (edt_RefractSearchName.text = (fn_nameRistrictSymbols arg))
on chbtn_RefractStatus changed state do (fn_chbtnSearch_LMB 11)
on chbtn_RefractStatus rightclick do (fn_chbtnSearch_RMB 11)
on ddl_RefractTexture selected item do (fn_getTexExtSize 11 true true)
on ddl_RefractTexture rightclick do (fn_ddlTex_RMB 11)
on btn_RefractBrowse pressed do (fn_btnBrow_LMB 11)
on btn_RefractBrowse rightclick do (fn_btnBrow_RMB 11)
on btn_RefractMapType pressed do (fn_rollRenameConvertResize 11)
on btn_RefractMapSize pressed do (fn_rollRenameConvertResize 11)
--ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ---Glossiness---ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ
on chbtn_GlossinessState changed state do (fn_chbtnState 12 state)
on ddl_GlossinessSearchName selected item do (fn_ddlSearchName_LMB 12 item)
on ddl_GlossinessSearchName rightclick do (fn_ddlSearchName_RMB 12)
on edt_GlossinessSearchName changed arg do (edt_GlossinessSearchName.text = (fn_nameRistrictSymbols arg))
on chbtn_GlossinessStatus changed state do (fn_chbtnSearch_LMB 12)
on chbtn_GlossinessStatus rightclick do (fn_chbtnSearch_RMB 12)
on ddl_GlossinessTexture selected item do (fn_getTexExtSize 12 true true)
on ddl_GlossinessTexture rightclick do (fn_ddlTex_RMB 12)
on btn_GlossinessBrowse pressed do (fn_btnBrow_LMB 12)
on btn_GlossinessBrowse rightclick do (fn_btnBrow_RMB 12)
on btn_GlossinessMapType pressed do (fn_rollRenameConvertResize 12)
on btn_GlossinessMapSize pressed do (fn_rollRenameConvertResize 12)
--ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ---IOR---ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ
on chbtn_IORState changed state do (fn_chbtnState 13 state)
on ddl_IORSearchName selected item do (fn_ddlSearchName_LMB 13 item)
on ddl_IORSearchName rightclick do (fn_ddlSearchName_RMB 13)
on edt_IORSearchName changed arg do (edt_IORSearchName.text = (fn_nameRistrictSymbols arg))
on chbtn_IORStatus changed state do (fn_chbtnSearch_LMB 13)
on chbtn_IORStatus rightclick do (fn_chbtnSearch_RMB 13)
on ddl_IORTexture selected item do (fn_getTexExtSize 13 true true)
on ddl_IORTexture rightclick do (fn_ddlTex_RMB 13)
on btn_IORBrowse pressed do (fn_btnBrow_LMB 13)
on btn_IORBrowse rightclick do (fn_btnBrow_RMB 13)
on btn_IORMapType pressed do (fn_rollRenameConvertResize 13)
on btn_IORMapSize pressed do (fn_rollRenameConvertResize 13)
--ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ---Translucent---ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ
on chbtn_TranslucentState changed state do (fn_chbtnState 14 state)
on ddl_TranslucentSearchName selected item do (fn_ddlSearchName_LMB 14 item)
on ddl_TranslucentSearchName rightclick do (fn_ddlSearchName_RMB 14)
on edt_TranslucentSearchName changed arg do (edt_TranslucentSearchName.text = (fn_nameRistrictSymbols arg))
on chbtn_TranslucentStatus changed state do (fn_chbtnSearch_LMB 14)
on chbtn_TranslucentStatus rightclick do (fn_chbtnSearch_RMB 14)
on ddl_TranslucentTexture selected item do (fn_getTexExtSize 14 true true)
on ddl_TranslucentTexture rightclick do (fn_ddlTex_RMB 14)
on btn_TranslucentBrowse pressed do (fn_btnBrow_LMB 14)
on btn_TranslucentBrowse rightclick do (fn_btnBrow_RMB 14)
on btn_TranslucentMapType pressed do (fn_rollRenameConvertResize 14)
on btn_TranslucentMapSize pressed do (fn_rollRenameConvertResize 14)
--ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ---FogColor---ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ
on chbtn_FogColorState changed state do (fn_chbtnState 15 state)
on ddl_FogColorSearchName selected item do (fn_ddlSearchName_LMB 15 item)
on ddl_FogColorSearchName rightclick do (fn_ddlSearchName_RMB 15)
on edt_FogColorSearchName changed arg do (edt_FogColorSearchName.text = (fn_nameRistrictSymbols arg))
on chbtn_FogColorStatus changed state do (fn_chbtnSearch_LMB 15)
on chbtn_FogColorStatus rightclick do (fn_chbtnSearch_RMB 15)
on ddl_FogColorTexture selected item do (fn_getTexExtSize 15 true true)
on ddl_FogColorTexture rightclick do (fn_ddlTex_RMB 15)
on btn_FogColorBrowse pressed do (fn_btnBrow_LMB 15)
on btn_FogColorBrowse rightclick do (fn_btnBrow_RMB 15)
on btn_FogColorMapType pressed do (fn_rollRenameConvertResize 15)
on btn_FogColorMapSize pressed do (fn_rollRenameConvertResize 15)
--ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ---Normal---ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ
on chbtn_NormalState changed state do (fn_chbtnState 16 state)
on ddl_NormalSearchName selected item do (fn_ddlSearchName_LMB 16 item)
on ddl_NormalSearchName rightclick do (fn_ddlSearchName_RMB 16)
on edt_NormalSearchName changed arg do (edt_NormalSearchName.text = (fn_nameRistrictSymbols arg))
on chbtn_NormalStatus changed state do (fn_chbtnSearch_LMB 16)
on chbtn_NormalStatus rightclick do (fn_chbtnSearch_RMB 16)
on ddl_NormalTexture selected item do (fn_getTexExtSize 16 true true)
on ddl_NormalTexture rightclick do (fn_ddlTex_RMB 16)
on btn_NormalBrowse pressed do (fn_btnBrow_LMB 16)
on btn_NormalBrowse rightclick do (fn_btnBrow_RMB 16)
on btn_NormalMapType pressed do (fn_rollRenameConvertResize 16)
on btn_NormalMapSize pressed do (fn_rollRenameConvertResize 16)
--ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ---Bump---ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ
on chbtn_BumpState changed state do (fn_chbtnState 17 state)
on ddl_BumpSearchName selected item do (fn_ddlSearchName_LMB 17 item)
on ddl_BumpSearchName rightclick do (fn_ddlSearchName_RMB 17)
on edt_BumpSearchName changed arg do (edt_BumpSearchName.text = (fn_nameRistrictSymbols arg))
on chbtn_BumpStatus changed state do (fn_chbtnSearch_LMB 17)
on chbtn_BumpStatus rightclick do (fn_chbtnSearch_RMB 17)
on ddl_BumpTexture selected item do (fn_getTexExtSize 17 true true)
on ddl_BumpTexture rightclick do (fn_ddlTex_RMB 17)
on btn_BumpBrowse pressed do (fn_btnBrow_LMB 17)
on btn_BumpBrowse rightclick do (fn_btnBrow_RMB 17)
on btn_BumpMapType pressed do (fn_rollRenameConvertResize 17)
on btn_BumpMapSize pressed do (fn_rollRenameConvertResize 17)
--ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ---Displace---ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ
on chbtn_DisplaceState changed state do (fn_chbtnState 18 state)
on ddl_DisplaceSearchName selected item do (fn_ddlSearchName_LMB 18 item)
on ddl_DisplaceSearchName rightclick do (fn_ddlSearchName_RMB 18)
on edt_DisplaceSearchName changed arg do (edt_DisplaceSearchName.text = (fn_nameRistrictSymbols arg))
on chbtn_DisplaceStatus changed state do (fn_chbtnSearch_LMB 18)
on chbtn_DisplaceStatus rightclick do (fn_chbtnSearch_RMB 18)
on ddl_DisplaceTexture selected item do (fn_getTexExtSize 18 true true)
on ddl_DisplaceTexture rightclick do (fn_ddlTex_RMB 18)
on btn_DisplaceBrowse pressed do (fn_btnBrow_LMB 18)
on btn_DisplaceBrowse rightclick do (fn_btnBrow_RMB 18)
on btn_DisplaceMapType pressed do (fn_rollRenameConvertResize 18)
on btn_DisplaceMapSize pressed do (fn_rollRenameConvertResize 18)
--ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ---Opacity---ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ
on chbtn_OpacityState changed state do (fn_chbtnState 19 state)
on ddl_OpacitySearchName selected item do (fn_ddlSearchName_LMB 19 item)
on ddl_OpacitySearchName rightclick do (fn_ddlSearchName_RMB 19)
on edt_OpacitySearchName changed arg do (edt_OpacitySearchName.text = (fn_nameRistrictSymbols arg))
on chbtn_OpacityStatus changed state do (fn_chbtnSearch_LMB 19)
on chbtn_OpacityStatus rightclick do (fn_chbtnSearch_RMB 19)
on ddl_OpacityTexture selected item do (fn_getTexExtSize 19 true true)
on ddl_OpacityTexture rightclick do (fn_ddlTex_RMB 19)
on btn_OpacityBrowse pressed do (fn_btnBrow_LMB 19)
on btn_OpacityBrowse rightclick do (fn_btnBrow_RMB 19)
on btn_OpacityMapType pressed do (fn_rollRenameConvertResize 19)
on btn_OpacityMapSize pressed do (fn_rollRenameConvertResize 19)
--ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ---Environment---ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ
on chbtn_EnvironmentState changed state do (fn_chbtnState 20 state)
on ddl_EnvironmentSearchName selected item do (fn_ddlSearchName_LMB 20 item)
on ddl_EnvironmentSearchName rightclick do (fn_ddlSearchName_RMB 20)
on edt_EnvironmentSearchName changed arg do (edt_EnvironmentSearchName.text = (fn_nameRistrictSymbols arg))
on chbtn_EnvironmentStatus changed state do (fn_chbtnSearch_LMB 20)
on chbtn_EnvironmentStatus rightclick do (fn_chbtnSearch_RMB 20)
on ddl_EnvironmentTexture selected item do (fn_getTexExtSize 20 true true)
on ddl_EnvironmentTexture rightclick do (fn_ddlTex_RMB 20)
on btn_EnvironmentBrowse pressed do (fn_btnBrow_LMB 20)
on btn_EnvironmentBrowse rightclick do (fn_btnBrow_RMB 20)
on btn_EnvironmentMapType pressed do (fn_rollRenameConvertResize 20)
on btn_EnvironmentMapSize pressed do (fn_rollRenameConvertResize 20)
--OOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO
	-------------------------------------------------------------------------------------------------------------------
on btn_SaveINI pressed do
(
fn_SaveDefaultsInINI()
LocT = getLocalTime()
LocT2 = if (LocT[2] as string).count == 1 then ("0"+(LocT[2] as string)) else (LocT[2] as string)
LocT4 = if (LocT[4] as string).count == 1 then ("0"+(LocT[4] as string)) else (LocT[4] as string)
LocDateStr = "_" + (LocT[1] as string) + "." + LocT2 + "." + LocT4
SaveInFile = getSaveFileName caption:"Save ini..." filename:((getFilenamePath (getThisScriptFilename())) + "MaterialLoader_Settings" + LocDateStr + ".ini") types:"Settings (*.ini)|*.ini|All|*.*|"
if SaveInFile != undefined then
	(
	if (doesFileExist SaveInFile) then (deleteFile SaveInFile)
	copyFile iniFile SaveInFile
	)
)
	-------------------------------------------------------------------------------------------------------------------
on btn_SaveINI rightclick do (shellLaunch "explorer.exe" (getFilenamePath  iniFile))
	-------------------------------------------------------------------------------------------------------------------
on btn_LoadINI pressed do
(
iniLoadFile = getOpenFileName caption:"Load ini..." types:"Settings (*.ini)|*.ini|All|*.*|"
if (iniLoadFile != undefined and iniLoadFile != iniFile) then 
	(
	fn_LoadINI iniLoadFile
	ATfn_.ddlWidthDynamic ddl_RootsSaved
	ATfn_.ddlWidthDynamic ddl_Roots
	fn_SaveDefaultsInINI()
	setINISetting iniFile "Separators" "Separator_Current" (ATfn_.GetINI 1 iniLoadFile "Separators" "Separator_Current" "_")
	setINISetting iniFile "Settings" "TypesOfExtensionForSearch" (with printAllElements on ((ATfn_.GetINI 0 iniLoadFile "Settings" "TypesOfExtensionForSearch" #(".jpg")) as string))
	setINISetting iniFile "Settings" "PreferredTextureExtension" ((ATfn_.GetINI 0 iniLoadFile "Settings" "PreferredTextureExtension" 1) as string)
	setINISetting iniFile "Settings" "TimerOnOff" ((ATfn_.GetINI 0 iniLoadFile "Settings" "TimerOnOff" true) as string)
	setINISetting iniFile "Settings" "PreviewTime" ((ATfn_.GetINI 0 iniLoadFile "Settings" "PreviewTime" 2.2) as string)
	setINISetting iniFile "Settings" "PutMaterialToEditor" ((ATfn_.GetINI 0 iniLoadFile "Settings" "PutMaterialToEditor" true) as string)
	setINISetting iniFile "Settings" "ToMaterialEditorSlot" ((ATfn_.GetINI 0 iniLoadFile "Settings" "ToMaterialEditorSlot" 1) as string)
	setINISetting iniFile "Settings" "ShowMaterialInViewport" ((ATfn_.GetINI 0 iniLoadFile "Settings" "ShowMaterialInViewport" true) as string)
	setINISetting iniFile "Settings" "CloseSaveSettings" ((ATfn_.GetINI 0 iniLoadFile "Settings" "CloseSaveSettings" true) as string)
	setINISetting iniFile "Settings" "TextureLoaderBlur" ((ATfn_.GetINI 0 iniLoadFile "Settings" "TextureLoaderBlur" 0.1) as string)
	setINISetting iniFile "Settings" "VRayColorGamma" ((ATfn_.GetINI 0 iniLoadFile "Settings" "VRayColorGamma" 1.0) as string)
	setINISetting iniFile "Settings" "WindowsFixUI" ((ATfn_.GetINI 0 iniLoadFile "Settings" "WindowsFixUI" true) as string)
	setINISetting iniFile "Settings" "SearchColor" ((ATfn_.GetINI 0 iniLoadFile "Settings" "SearchColor" [255,156,0]) as string)
	setINISetting iniFile "Settings" "ObjectColor" ((ATfn_.GetINI 0 iniLoadFile "Settings" "ObjectColor" [255,156,0]) as string)
	setINISetting iniFile "Settings" "LayerColor" ((ATfn_.GetINI 0 iniLoadFile "Settings" "LayerColor" [255,156,0]) as string)
	setINISetting iniFile "Settings" "MaterialColor" ((ATfn_.GetINI 0 iniLoadFile "Settings" "MaterialColor" [255,156,0]) as string)
	setINISetting iniFile "Settings" "CheckboxColor" ((ATfn_.GetINI 0 iniLoadFile "Settings" "CheckboxColor" [255,156,0]) as string)
	setINISetting iniFile "Settings" "OCIOConfigPath" (ATfn_.GetINI 1 iniLoadFile "Settings" "OCIOConfigPath" "")
	setINISetting iniFile "Settings" "OCIOInputOutput" ((ATfn_.GetINI 0 iniLoadFile "Settings" "OCIOInputOutput" 1) as string)
	setINISetting iniFile "Settings" "OCIOMode" ((ATfn_.GetINI 0 iniLoadFile "Settings" "OCIOMode" 1) as string)
	setINISetting iniFile "Settings" "OCIOColorSpaceIn" (ATfn_.GetINI 1 iniLoadFile "Settings" "OCIOColorSpaceIn" "")
	setINISetting iniFile "Settings" "OCIOColorSpaceOut" (ATfn_.GetINI 1 iniLoadFile "Settings" "OCIOColorSpaceOut" "")
	OCIOConfigPath = ATfn_.GetINI 1 iniFile "Settings" "OCIOConfigPath" ""
	OCIOInOutType = (ATfn_.GetINI 0 iniFile "Settings" "OCIOInputOutput" 1) - 1
	OCIOGenMode = (ATfn_.GetINI 0 iniFile "Settings" "OCIOMode" 1) - 1
	OCIOColorSpaceIn = (ATfn_.GetINI 1 iniFile "Settings" "OCIOColorSpaceIn" "")
	OCIOColorSpaceOut = (ATfn_.GetINI 1 iniFile "Settings" "OCIOColorSpaceOut" "")
	)
)
	-------------------------------------------------------------------------------------------------------------------
on btn_SaveSettings pressed do fn_SaveDefaultsInINI()
	-------------------------------------------------------------------------------------------------------------------
on chbtn_SpecialRule changed state do (edt_SpecialRule.enabled = state)
	-------------------------------------------------------------------------------------------------------------------
on edt_SpecialRule changed arg do (if (matchPattern arg pattern:"*#*") == false then (edt_SpecialRule.text = arg + "#")) 
	-------------------------------------------------------------------------------------------------------------------
on edt_SpecialRule entered arg do (edt_SpecialRule.text = (substituteString arg "\\" ""))
	-------------------------------------------------------------------------------------------------------------------
on btn_Preferences pressed do
(
rollout rolloutPreferences "Preferences"
(
local y1 = 11
local yb = 21
label lbl_Extensions " Types of extension for search:" pos:[10,y1+yb*0]
dropdownlist ddl_Extensions items:(ATfn_.GetINI 0 iniFile "Settings" "TypesOfExtensionForSearch" #(".jpg")) pos:[163,(y1-3)+ddlOf+yb*0] width:20 height:33 selection:0 tooltip:"Lmb - Choose Extension\nAlt+Lmb - Delete Extension\nAlt+Rmb - Save Extension"
edittext edt_Extensions "" text:"" pos:[179,(y1-3)+edtOf+yb*0] width:50 height:17 enabled:true
label lbl_Preferred " Preferred  texture  extension:" pos:[10,y1+yb*1]
dropdownlist ddl_Preferred items:(ATfn_.GetINI 0 iniFile "Settings" "TypesOfExtensionForSearch" #(".jpg")) pos:[163,(y1-3)+edtOf+yb*1] width:67 height:33 selection:(ATfn_.GetINI 0 iniFile "Settings" "PreferredTextureExtension" 1) tooltip:""
checkbox chbx_TimerOnOff "  Close   preview   after:" pos:[10,(y1-1)+yb*2] checked:(ATfn_.GetINI 0 iniFile "Settings" "TimerOnOff" true) enabled:true tooltip:"1000 milliseconds = 1 second"
spinner spnr_PreviewTime pos:[163,y1+yb*2] range:[0.1,99,(ATfn_.GetINI 0 iniFile "Settings" "PreviewTime" 2.2)] type:#float width:44 enabled:(ATfn_.GetINI 0 iniFile "Settings" "TimerOnOff" true)
label lbl_Sec "sec" pos:[212,y1+yb*2] enabled:(ATfn_.GetINI 0 iniFile "Settings" "TimerOnOff" true)
checkbox chbx_MaterialToEditor "  Put  material  in  editor  -  slot:" pos:[10,(y1-1)+yb*3] checked:(ATfn_.GetINI 0 iniFile "Settings" "PutMaterialToEditor" true) tooltip:" Put the created material \n to the material editor "
spinner spnr_MaterialToSlot pos:[190,y1+yb*3] range:[1,24,(ATfn_.GetINI 0 iniFile "Settings" "ToMaterialEditorSlot" 1)] type:#integer width:40 enabled:(ATfn_.GetINI 0 iniFile "Settings" "PutMaterialToEditor" true) tooltip:""
checkbox chbx_ShowMatInViewport "  Show shaded material in viewport toggle" pos:[10,(y1-1)+yb*4] checked:(ATfn_.GetINI 0 iniFile "Settings" "ShowMaterialInViewport" true) tooltip:" Show shaded material in viewport \n  for created material on/off"
checkbox chbx_CloseSaveSettings "  Save  settings  in  .ini  file  when  close" pos:[10,(y1-1)+yb*5] checked:(ATfn_.GetINI 0 iniFile "Settings" "CloseSaveSettings" true) tooltip:" Save text filds, checkboxs \n and checkbuttons state \n in working .ini file when close "
label lbl_Separator " Separator" pos:[10,y1+yb*6]
edittext edt_Separator "" text:(ATfn_.GetINI 1 iniFile "Separators" "Separator_Current" "_") pos:[60,(y1-3)+edtOf+yb*6] width:40 height:17
checkbox chbx_winUIfix " Windows 10 UI fix" pos:[120,(y1-1)+yb*6] checked:(ATfn_.GetINI 0 iniFile "Settings" "WindowsFixUI" true) tooltip:"Windows 10 fix UI\n(Restart required)"

label lbl_TextureBlur " VRayHDRI and Bitmap loader Blur:" pos:[10,y1+yb*7]
spinner spnr_TextureBlur pos:[180,y1+yb*7] range:[0.01,100,(ATfn_.GetINI 0 iniFile "Settings" "TextureLoaderBlur" 0.1)] type:#float scale:0.01 width:50 tooltip:"VRayHDRI or Bitmap loader Blur"
label lbl_VRColorGamma " VRayColor Parameters color gamma:" pos:[10,y1+yb*8]
spinner spnr_VRColorGamma pos:[190,y1+yb*8] range:[0.05,20,(ATfn_.GetINI 0 iniFile "Settings" "VRayColorGamma" 1.0)] type:#float scale:0.01 width:40 tooltip:"VRayColor Parameters color gamma"
label lbl_ChbxColors " S O L M:" pos:[10,y1+1+yb*9]
colorpicker color_Search "" pos:[52,(y1-2)+yb*9] width:24 color:(ATfn_.GetINI 0 iniFile "Settings" "SearchColor" [255,156,0]) modal:false tooltip:"Search checkbox color"
colorpicker color_Object "" pos:[73,(y1-2)+yb*9] width:24 color:(ATfn_.GetINI 0 iniFile "Settings" "ObjectColor" [255,156,0]) modal:false tooltip:"Object checkbox color"
colorpicker color_Layer "" pos:[94,(y1-2)+yb*9] width:24 color:(ATfn_.GetINI 0 iniFile "Settings" "LayerColor" [255,156,0]) modal:false tooltip:"Layer checkbox color"
colorpicker color_Material "" pos:[115,(y1-2)+yb*9] width:24 color:(ATfn_.GetINI 0 iniFile "Settings" "MaterialColor" [255,156,0]) modal:false tooltip:"Material checkbox color"
label lbl_OtherColors "Other Colors:" pos:[144,y1+1+yb*9]
colorpicker color_CheckboxColor "" pos:[206,(y1-2)+yb*9] width:24 color:(ATfn_.GetINI 0 iniFile "Settings" "CheckboxColor" [255,156,0]) modal:false tooltip:"On/Off checkbox color"

label lbl_OCIOconfig " OCIO Config" pos:[10,y1+1+yb*10]
button btn_OCIOconfigSet pos:[80,y1+yb*10] width:152 height:18
label lbl_OCIOInputOutput " Input Output" pos:[10,y1+1+yb*11]
dropdownlist ddl_OCIOInputOutput items:#("by colorspace", "by role") pos:[80,(y1-2)+ddlOf+yb*11] width:152 height:33 selection:(ATfn_.GetINI 0 iniFile "Settings" "OCIOInputOutput" 1) tooltip:""
label lbl_OCIOMode " Mode" pos:[10,y1+1+yb*12]
dropdownlist ddl_OCIOMode items:#("ColorSpace", "CDLTransform", "FileTransform", "LogConvert", "Display", "Look") pos:[58,(y1-2)+ddlOf+yb*12] width:174 height:33 selection:(ATfn_.GetINI 0 iniFile "Settings" "OCIOMode" 1) tooltip:""
label lbl_OCIOColorSpaceIn " In" pos:[10,y1+1+yb*13] enabled:(ddl_OCIOMode.selection == 1)
dropdownlist ddl_OCIOColorSpaceIn items:#() pos:[36,(y1-2)+ddlOf+yb*13] width:196 height:33 selection:0 tooltip:"OCIO ColorSpace In"
label lbl_OCIOColorSpaceOut " Out" pos:[10,y1+1+yb*14] enabled:(ddl_OCIOMode.selection == 1)
dropdownlist ddl_OCIOColorSpaceOut items:#() pos:[36,(y1-2)+ddlOf+yb*14] width:196 height:33 selection:0 tooltip:"OCIO ColorSpace Out"
-----
FN fn_GetColorSpacesList OCIOconfigPath =
(
local MatEditorisOpen = MatEditor.isOpen()
MatEditor.mode = #basic; MatEditor.Open()
local activeMeditMat = meditMaterials[activeMeditSlot]
local VrOCIO = VRayOCIO name:"VRayOCIO"
meditMaterials[activeMeditSlot] = VrOCIO
VrOCIO.gen_ocio_config = OCIOconfigPath
local ColorSpacesList = meditMaterials[activeMeditSlot].colorspaces_list as array
meditMaterials[activeMeditSlot] = activeMeditMat
if not MatEditorisOpen then MatEditor.Close()
return ColorSpacesList
)
-- FN fn_GetColorSpacesList OCIOconfigPath =
-- (
-- renderers.current = Vray()
-- vfbControl #ocio true #loadocio OCIOconfigPath
-- local ColSpList = (vfbControl #itemsociocs)[1]
-- if classOf ColSpList == String do ColSpList = #()
-- return ColSpList
-- )
-----
on ddl_OCIOColorSpaceIn selected item do
(
OCIOColorSpaceIn = (ddl_OCIOColorSpaceIn.items)[item]
)
-----
on ddl_OCIOColorSpaceOut selected item do
(
OCIOColorSpaceOut = (ddl_OCIOColorSpaceOut.items)[item]
)
-----
on ddl_OCIOMode selected item do
(
OCIOGenMode = item - 1
lbl_OCIOColorSpaceIn.enabled = lbl_OCIOColorSpaceOut.enabled = ddl_OCIOColorSpaceIn.enabled = ddl_OCIOColorSpaceOut.enabled = (item == 1)
if item == 1
then
	(
	if ColorSpacesList.count == 0 then (ColorSpacesList = fn_GetColorSpacesList OCIOConfigPath)
	ddl_OCIOColorSpaceIn.items = ddl_OCIOColorSpaceOut.items = ColorSpacesList
	ATfn_.ddlWidthDynamic ddl_OCIOColorSpaceIn; ATfn_.ddlWidthDynamic ddl_OCIOColorSpaceOut
	ddl_OCIOColorSpaceIn.selection = findItem ColorSpacesList OCIOColorSpaceIn
	ddl_OCIOColorSpaceOut.selection = findItem ColorSpacesList OCIOColorSpaceOut
	)
)
-----
on ddl_OCIOInputOutput selected item do
(
OCIOInOutType = item - 1
)
-----
on btn_OCIOconfigSet pressed do
(
local OCIOcofiguration = getOpenFileName caption:"Load OCIO cofiguration..." filename:OCIOconfigPath types:"OCIO cofiguration (*.ocio)|*.ocio|All|*.*|"
if (OCIOcofiguration != undefined )
then 
	(
	OCIOconfigPath = OCIOcofiguration
	ColorSpacesList = fn_GetColorSpacesList OCIOConfigPath
	ddl_OCIOColorSpaceIn.items = ddl_OCIOColorSpaceOut.items = ColorSpacesList
	ddl_OCIOColorSpaceIn.selection = ddl_OCIOColorSpaceOut.selection = 0
	btn_OCIOconfigSet.text = filenameFromPath OCIOconfigPath
	btn_OCIOconfigSet.tooltip = OCIOconfigPath
	ATfn_.ddlWidthDynamic ddl_OCIOColorSpaceIn; ATfn_.ddlWidthDynamic ddl_OCIOColorSpaceOut
	)
)
-----
on ddl_Extensions selected item do
(
if keyboard.altPressed
	then
		(
		selPrefItem = (ddl_Preferred.items)[ddl_Preferred.selection]
		ExtensionsArr = ddl_Extensions.items
		oldExtensionsArr = deepCopy ExtensionsArr
		if ((queryBox ("Do you want to delete Extension  - " + ExtensionsArr[item] + " - ?") title:"Delete?" beep:false) and ExtensionsArr[item] != "") then
			(
			deleteItem ExtensionsArr item
			ddl_Extensions.items = deepCopy ExtensionsArr
			ddl_Preferred.items = deepCopy ExtensionsArr
			if selPrefItem != oldExtensionsArr[item]
			then (ddl_Preferred.selection = findItem ExtensionsArr selPrefItem)
			else (ddl_Preferred.selection = (ddl_Preferred.items).count )
			)
		)
	else
		(
		edt_Extensions.text = (ddl_Extensions.items)[item]
		)
)
on ddl_Extensions rightclick do
(
if keyboard.altPressed
then
	(
	if edt_Extensions.text != ""
	then
		(
		selPrefItem = (ddl_Preferred.items)[ddl_Preferred.selection]
		ExtensionsArr = ddl_Extensions.items
		appendIfUnique ExtensionsArr (tolower edt_Extensions.text)
		sort ExtensionsArr
		ddl_Extensions.items = deepCopy ExtensionsArr
		ddl_Preferred.items = deepCopy ExtensionsArr
		ddl_Preferred.selection = findItem ExtensionsArr selPrefItem
		)
	)
else
	(
	edt_Extensions.text = ""
	)
)
on edt_Extensions changed arg do (edt_Extensions.text = (fn_nameRistrictSymbols arg))
on edt_Extensions entered arg do
(
if edt_Extensions.text != ""
then
	(
	selPrefItem = (ddl_Preferred.items)[ddl_Preferred.selection]
	ExtensionsArr = ddl_Extensions.items
	appendIfUnique ExtensionsArr (tolower edt_Extensions.text)
	sort ExtensionsArr
	ddl_Extensions.items = deepCopy ExtensionsArr
	ddl_Preferred.items = deepCopy ExtensionsArr
	ddl_Preferred.selection = findItem ExtensionsArr selPrefItem
	)
)
on chbx_TimerOnOff changed state do (spnr_PreviewTime.enabled=lbl_Sec.enabled=state)
on chbx_MaterialToEditor changed state do (spnr_MaterialToSlot.enabled=state)
on color_Search changed col do (fn_setArrayHighlightColor chbtnSearchFildsArr col)
on color_Object changed col do (fn_setArrayHighlightColor chbtnObjectFildsArr col)
on color_Layer changed col do (fn_setArrayHighlightColor chbtnLayerFildsArr col)
on color_Material changed col do (fn_setArrayHighlightColor chbtnMaterialFildsArr col)
on color_CheckboxColor changed col do
(
fn_setArrayHighlightColor chbtnStateArr col; fn_setHighlightColor chbtn_SpecialRule col; fn_setHighlightColor chbtn_Separator col
fn_setHighlightColor chbtn_FromObjMode col; fn_setHighlightColor chbtn_OneObjCounter col; fn_setHighlightColor chbtn_MultiStatus col
fn_setArrayHighlightColor chbtnColCorArr col; fn_setArrayHighlightColor chbtnComposArr col; fn_setHighlightColor chbtn_Blend col
fn_setArrayHighlightColor chbtnOCIOArr col
)
on rolloutPreferences open do
	(
	if ddl_OCIOMode.selection == 1
	then
		(
		if ColorSpacesList.count == 0 then (ColorSpacesList = fn_GetColorSpacesList OCIOConfigPath)
		ddl_OCIOColorSpaceIn.items = ddl_OCIOColorSpaceOut.items = ColorSpacesList
		ATfn_.ddlWidthDynamic ddl_OCIOColorSpaceIn; ATfn_.ddlWidthDynamic ddl_OCIOColorSpaceOut
		ddl_OCIOColorSpaceIn.selection = findItem ColorSpacesList (ATfn_.GetINI 1 iniFile "Settings" "OCIOColorSpaceIn" "")
		ddl_OCIOColorSpaceOut.selection = findItem ColorSpacesList (ATfn_.GetINI 1 iniFile "Settings" "OCIOColorSpaceOut" "")
		)
	btn_OCIOconfigSet.text = filenameFromPath OCIOconfigPath
	btn_OCIOconfigSet.tooltip = OCIOconfigPath
	)
on rolloutPreferences close do
	(
	setINISetting iniFile "Separators" "Separator_Current" (edt_Separator.text)
	setINISetting iniFile "Settings" "TypesOfExtensionForSearch" (with printAllElements on (ddl_Extensions.items as String))
	setINISetting iniFile "Settings" "PreferredTextureExtension" (ddl_Preferred.selection as String)
	setINISetting iniFile "Settings" "TimerOnOff" (chbx_TimerOnOff.checked as String)
	setINISetting iniFile "Settings" "PreviewTime" (spnr_PreviewTime.value as String)
	setINISetting iniFile "Settings" "PutMaterialToEditor" (chbx_MaterialToEditor.checked as String)
	setINISetting iniFile "Settings" "ToMaterialEditorSlot" (spnr_MaterialToSlot.value as String)
	setINISetting iniFile "Settings" "ShowMaterialInViewport" (chbx_ShowMatInViewport.checked as String)
	setINISetting iniFile "Settings" "CloseSaveSettings" (chbx_CloseSaveSettings.checked as String)
	setINISetting iniFile "Settings" "TextureLoaderBlur" (spnr_TextureBlur.value as String)
	setINISetting iniFile "Settings" "VRayColorGamma" (spnr_VRColorGamma.value as String)
	setINISetting iniFile "Settings" "WindowsFixUI" (chbx_winUIfix.checked as String)
	setINISetting iniFile "Settings" "SearchColor" (color_Search.color as String)
	setINISetting iniFile "Settings" "ObjectColor" (color_Object.color as String)
	setINISetting iniFile "Settings" "LayerColor" (color_Layer.color as String)
	setINISetting iniFile "Settings" "MaterialColor" (color_Material.color as String)
	setINISetting iniFile "Settings" "CheckboxColor" (color_CheckboxColor.color as String)
	setINISetting iniFile "Settings" "OCIOConfigPath" OCIOConfigPath
	setINISetting iniFile "Settings" "OCIOInputOutput" (ddl_OCIOInputOutput.selection as String)
	setINISetting iniFile "Settings" "OCIOMode" (ddl_OCIOMode.selection as String)
	try(setINISetting iniFile "Settings" "OCIOColorSpaceIn" ddl_OCIOColorSpaceIn.selected)catch()
	try(setINISetting iniFile "Settings" "OCIOColorSpaceOut" ddl_OCIOColorSpaceOut.selected)catch()
	)
)
X = mouse.screenpos.X
Y = mouse.screenpos.Y
CreateDialog rolloutPreferences 238 328 pos:[(X-198-10),(Y-10)] style:#(#style_titlebar, #style_toolwindow, #style_sysmenu) modal:true
)
	-------------------------------------------------------------------------------------------------------------------
	----===============================================================================================================
on rollout_MaterialLoader open do
    (
	case rdbtn_GlossiOrRough.state of
		(
		1: (lbl_HGlossinessState.text = "HGlossiness"; lbl_RGlossinessState.text = "RGlossiness")
		2: (lbl_HGlossinessState.text = "HRoughness"; lbl_RGlossinessState.text = "RRoughness")
		)
	local ddlArr = #(ddl_Fild_01, ddl_Fild_02, ddl_Fild_03, ddl_Fild_04, ddl_Fild_05, ddl_Fild_06, ddl_Fild_07, ddl_Fild_08, ddl_DisplaceSearchName, ddl_OpacitySearchName, ddl_EnvironmentSearchName,
	ddl_DiffuseSearchName, ddl_RoughnessSearchName, ddl_SelfIllumSearchName, ddl_ReflectSearchName, ddl_HGlossinessSearchName, ddl_RGlossinessSearchName, ddl_FresnelIORSearchName, ddl_MetalnessSearchName, ddl_AnisotropySearchName, 
	ddl_AnRotationSearchName, ddl_RefractSearchName, ddl_GlossinessSearchName, ddl_IORSearchName, ddl_TranslucentSearchName, ddl_FogColorSearchName, ddl_NormalSearchName, ddl_BumpSearchName, ddl_BRDFtype)
	for dl in ddlArr do (fn_ddlWidthStatic dl ddlWidth_1)
	ATfn_.ddlWidthDynamic ddl_RootsSaved
	ATfn_.ddlWidthDynamic ddl_Roots
	local DockState = (ATfn_.GetINI 1 iniFile "DialogPosition" "DockState" "undefined")
	if DockState != "undefined"
	then
		(
		rollout_MaterialLoader.height = roll0minH-2; btn_MinimizeUI.caption = "+"
		cui.RegisterDialogBar rollout_MaterialLoader style:#(#cui_dock_horz)
		if DockState == "cui_dock_top" then (cui.DockDialogBar rollout_MaterialLoader #cui_dock_top) else (cui.DockDialogBar rollout_MaterialLoader #cui_dock_bottom)
		)
	)
	-------------------------------------------------------------------------------------------------------------------
on rollout_MaterialLoader close do
    (
	try (for gh in instGHeadsArr where (isValidObj gh) do (setGroupOpen gh false)) catch()
	try (for gh in matGHeadsArr where (isValidObj gh) do (setGroupOpen gh false)) catch()
	try (for gh in wireGHeadsArr where (isValidObj gh) do (setGroupOpen gh false)) catch()
	try (setINISetting iniFile "DialogPosition" "LastPosition" ((GetDialogPos rollout_MaterialLoader) as string)) catch()
	if (ATfn_.GetINI 0 iniFile "Settings" "CloseSaveSettings" true) then fn_SaveDefaultsInINI()
	try (destroyDialog _gEP2_rolloutTexSearchHistory) catch()
	_gEP2_rolloutTexSearchHistory = undefined
	_gEP2_createMatHistoryArr = undefined
	rollout_MaterialLoader = undefined
	freeSceneBitmaps(); for k=1 to 24 do ( mat = medit.GetTopMtlSlot k ; setMTLMeditObjType mat (getMTLMeditObjType mat) )
	if floater_AssemblyTool != undefined do try(floater_AssemblyTool.rollouts[1].chbtn_TL_MaterialLoader.checked = false)catch()
	gc()
    )
)
	----===============================================================================================================
on execute do
	(
	DialogPosition = ATfn_.GetINI 0 iniFile "DialogPosition" "LastPosition" [5,30]
	if DialogPosition[1] < 0 then DialogPosition[1] = 0; if DialogPosition[2] < 30 then DialogPosition[2] = 30
	if (DialogPosition[1] > (sysInfo.DesktopSize[1] - roll0W)) then abs(DialogPosition[1] = (sysInfo.DesktopSize[1] - roll0W - 10))
	if (DialogPosition[2] > (sysInfo.DesktopSize[2] - roll0H)) then abs(DialogPosition[2] = (sysInfo.DesktopSize[2] - roll0H - 30))
	CreateDialog rollout_MaterialLoader roll0W roll0H pos:DialogPosition style:#(#style_titlebar, #style_sysmenu, #style_minimizebox) modal:false
	)
)