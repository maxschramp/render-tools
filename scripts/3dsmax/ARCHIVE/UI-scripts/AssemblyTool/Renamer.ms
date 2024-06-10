	-----------------
	--^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
(if ATIcons == undefined then (fileIn ((getFilenamePath(getThisScriptFilename())) + "AssemblyToolIcons.ms")))
(if ATfn_ == undefined then (fileIn ((getFilenamePath(getThisScriptFilename())) + "AssemblyToolStruct.ms")))
	--^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
(
Global rollout_Renamer
Global floater_AssemblyTool
try(if rollout_Renamer.dialogBar then (cui.UnRegisterDialogBar rollout_Renamer); destroyDialog rollout_Renamer)catch()
	--^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
local rollTitle = "Renamer"
local iniPath = (getFilenamePath (getThisScriptFilename())) + "INI\\"
local iniFile = iniPath + "Renamer_Settings.ini"
local fixedW = 500; local fixedH = 557
local roll0S = ATfn_.GetINI 0 iniFile rollTitle "LastSize" [fixedW,fixedH]; local roll0W = roll0S[1]; local roll0H = roll0S[2]
local colCHBX = ATfn_.GetINI 0 (iniPath + "AssemblyTool_Settings.ini") "Preferences" "color_PS_ChBxColor" [255,156,0]
local ExcludedControls = #("prgrs_RN_ProBar", "tmr_RN_prgrsFade", "mlbx_RN_RenamerList", "ddl_RN_ObjClasses", \
	"ddl_RN_MatClasses", "ddl_RN_TexTypes")
	-------------------------------------------------------------------------------------------------------------------
local ObjArr = #(); local ObjNameArr = #(); local ObjPrevArr = #()
local MatArr = #(); local MatNameArr = #(); local MatPrevArr = #()
local LoadArrArr = #(); local TexArr = #(); local TexNameArr = #(); local TexPrevArr = #(); local TexNamePrevArr = #()
local CoincidencesCounterDigits = 2
local CopyPasteStr = ""
local openedBitMap = undefined
local renameSingle_rollout; local renameSingleIndex
local CustomMaterialClass = ATfn_.GetINI 0 iniFile rollTitle "CustomMaterialClass" NoMaterial
local lastSearchFolder = ATfn_.GetINI 1 iniFile rollTitle "lastSearchFolder" "C:\\"
	-------------------------------------------------------------------------------------------------------------------
	----===============================================================================================================
rollout rollout_Renamer rollTitle
(
local yp1 = #(4, 55, 116, 231, 292, 369, 436, 462, 488, 514)
button btn_RN_Refresh "Refresh" pos:[4,yp1[1]] width:47 height:45 border:true tooltip:" Refresh List "
radiobuttons rdbtn_RN_SelectedOrScene "" labels:#("Selected","Scene") pos:[62,yp1[1]+6] columns:2 offsets:#([0,0],[7,0]) default:2 tooltip:" Process Selected Objects \n Or All Scene Objects "
edittext edt_RN_NameFilter "Filter" pos:[55,yp1[1]+30] width:145 height:17 bold:false tooltip:" Filter List By Name "
local mlbx_RN_RenamerList_ttp = " DoubleClick - Manual Rename Single Texture \n Alt+Lmb - Open Single Texture 
 Rmb - Selects Dependent Scene Objects \n Alt+Rmb - Selects By Identical Names \n Ctrl+Rmb - Deselect All List \n Shift+Rmb - Select/Deselect All List "
multilistbox mlbx_RN_RenamerList items:#() pos:[200,yp1[1]+52] width:(rollout_Renamer.width-205) height:100 tooltip:mlbx_RN_RenamerList_ttp
	
checkButton chbtn_RN_Objects "Objects" pos:[207,yp1[1]+17] width:90 height:31 highlightColor:colCHBX checked:false
checkButton chbtn_RN_Materials "Materials" pos:[304,yp1[1]+17] width:90 height:31 highlightColor:colCHBX checked:false
checkButton chbtn_RN_Textures "Textures" pos:[401,yp1[1]+17] width:90 height:31 highlightColor:colCHBX checked:false

dropdownlist ddl_RN_ObjClasses items:#("All", "Geometry", "VRayProxy", "Shapes", "Lights", "Cameras", "Helpers", "Bones", "Other") pos:[207,0] width:90 height:33 selection:1 tooltip:" Select Objects Class "
local MatClasses = #("All", "Standard", "VRayMtl", "Multi/Sub-Object", "PhysicalMaterial", "PBRMetalRough", "PBRSpecGloss", "VRay2SidedMtl", "VRayBlendMtl", "VRayLightMtl", "Custom...")
dropdownlist ddl_RN_MatClasses items:MatClasses pos:[304,0] width:90 height:33 selection:1 tooltip:" Select Materials Class "
dropdownlist ddl_RN_TexTypes items:#("All", ".bmp", ".gif", ".jpeg", ".png", ".tga", ".tiff", "Other") pos:[401,0] width:90 height:33 selection:1 tooltip:" Select Textures Type "

GroupBox grp_RN_Prefix "Prefix" pos:[7,yp1[2]] width:(mlbx_RN_RenamerList.pos.x-12) height:60
checkButton chbtn_RN_RemFirstSymbols "" pos:[12,yp1[2]+15] width:14 height:14 checked:false highlightColor:colCHBX tooltip:" Remove First Symbols Toggle "
spinner spnr_RN_RemFirstSymbols "Remove First:" pos:[90,yp1[2]+15] width:40 range:[1,99,1] type:#Integer scale:1 enabled:false toolTip:" Number Of First Symbols To Remove "
label lbl_RN_FirstSymbols "Symbols" pos:[133,yp1[2]+15] enabled:false tooltip:spnr_RN_RemFirstSymbols.tooltip
checkButton chbtn_RN_Prefix "" pos:[12,yp1[2]+35] width:14 height:14 checked:false highlightColor:colCHBX tooltip:" Use Prefix Toggle "
edittext edt_RN_Prefix "Prefix:" pos:[30,yp1[2]+35] width:157 height:17 bold:false enabled:false tooltip:" Names Prefix "

GroupBox grp_RN_Base "Base" pos:[7,yp1[3]] width:(mlbx_RN_RenamerList.pos.x-12) height:115
checkButton chbtn_RN_Base "" pos:[12,yp1[3]+15] width:14 height:14 checked:false highlightColor:colCHBX tooltip:" Use Base Toggle "
edittext edt_RN_Base "" pos:[27,yp1[3]+15] width:162 height:17 bold:false enabled:false tooltip:" Base Name "

GroupBox grp_RN_MaterialAsBase "Material Name As Base" pos:[12,yp1[3]+37] width:(mlbx_RN_RenamerList.pos.x-22) height:74
checkButton chbtn_RN_MaterialAsBase "" pos:[17,yp1[3]+52] width:14 height:14 checked:false highlightColor:colCHBX tooltip:" Use Material Name As Base Toggle "
label lbl_RN_MaterialAsBase "Use Material Name As Base" pos:[35,yp1[3]+52] tooltip:chbtn_RN_MaterialAsBase.tooltip
GroupBox grp_RN_MABAutoRename "Automatic Rename" pos:[17,yp1[3]+70] width:(mlbx_RN_RenamerList.pos.x-32) height:37 enabled:false
checkButton chbtn_RN_MABAutoRename "" pos:[22,yp1[3]+85] width:14 height:14 checked:false highlightColor:colCHBX enabled:false tooltip:" Automatic Rename Identical Names Toggle "
spinner spnr_RN_MABCounterDigs "Digits:" pos:[72,yp1[3]+85] width:32 range:[1,9,2] type:#Integer scale:1 enabled:false toolTip:" Number Of Digits In Counter "
edittext edt_RN_MABSepar "Separator:" text:"_" pos:[110,yp1[3]+85] width:70 height:17 bold:false enabled:false tooltip:" Counter Separator "

GroupBox grp_RN_Suffix "Suffix" pos:[7,yp1[4]] width:(mlbx_RN_RenamerList.pos.x-12) height:60
checkButton chbtn_RN_RemLastSymbols "" pos:[12,yp1[4]+15] width:14 height:14 checked:false highlightColor:colCHBX tooltip:" Remove Last Symbols Toggle "
spinner spnr_RN_RemLastSymbols "Remove Last:" pos:[90,yp1[4]+15] width:40 range:[1,99,1] type:#Integer scale:1 enabled:false toolTip:" Number Of Last Symbols To Remove "
label lbl_RN_LastSymbols "Symbols" pos:[133,yp1[4]+15] enabled:false tooltip:spnr_RN_RemLastSymbols.tooltip
checkButton chbtn_RN_Suffix "" pos:[12,yp1[4]+35] width:14 height:14 checked:false highlightColor:colCHBX tooltip:" Use Suffix Toggle "
edittext edt_RN_Suffix "Suffix:" pos:[30,yp1[4]+35] width:157 height:17 bold:false enabled:false tooltip:" Names Suffix "

GroupBox grp_RN_Counter "Counter" pos:[7,yp1[5]] width:(mlbx_RN_RenamerList.pos.x-12) height:74
checkButton chbtn_RN_Counter "" pos:[12,yp1[5]+15] width:14 height:14 checked:false highlightColor:colCHBX tooltip:" Use Counter Toggle "
label lbl_RN_CounterAt "Counter At:" pos:[30,yp1[5]+15] enabled:false tooltip:" Use Counter At The Beginning \n Of The Name Or At The End "
radiobuttons rdbtn_RN_CounterBeginOrEnd "" labels:#("Begin","End") pos:[92,yp1[5]+14] columns:2 offsets:#([0,0],[0,0]) default:2 enabled:false tooltip:lbl_RN_CounterAt.tooltip
spinner spnr_RN_CounterDigits "Digits:" pos:[46,yp1[5]+33] width:32 range:[1,9,3] type:#Integer scale:1 enabled:false toolTip:" Number Of Digits In Counter "
checkButton chbtn_RN_Separator "" pos:[97,yp1[5]+33] width:14 height:14 checked:false highlightColor:colCHBX enabled:false tooltip:" Use Separator Toggle "
edittext edt_RN_Separator "Separator:" text:"_" pos:[115,yp1[5]+33] width:70 height:17 bold:false enabled:false tooltip:" Counter Separator "
spinner spnr_RN_StartFrom "Start From:" pos:[66,yp1[5]+51] width:46 range:[0,999,1] type:#Integer scale:1 enabled:false toolTip:" Start Counter Value "
spinner spnr_RN_CountStep "Step:" pos:[148,yp1[5]+51] width:36 range:[1,99,1] type:#Integer scale:1 enabled:false toolTip:" Count Step "

GroupBox grp_RN_Replace "Replace" pos:[7,yp1[6]] width:(mlbx_RN_RenamerList.pos.x-12) height:60
checkButton chbtn_RN_Replace "" pos:[12,yp1[6]+15] width:14 height:14 checked:false highlightColor:colCHBX tooltip:" Use Replace Toggle "
edittext edt_RN_ReplaceIt "Replace:" pos:[30,yp1[6]+15] width:157 height:17 bold:false enabled:false tooltip:" Symbols To Replace "
edittext edt_RN_ReplaceWith "With:" pos:[46,yp1[6]+35] width:141 height:17 bold:false enabled:false tooltip:" Replace With Symbols "
button btn_RN_ReplaceSwap "Del." pos:[12,yp1[6]+35] width:30 height:19 enabled:false tooltip:" Lmb - Clear Replace Filds \n Rmb - Swap Replace Strings "

button btn_RN_SelectMissing "Missing" pos:[5,yp1[7]] width:45 height:23 tooltip:" Selects Missing Files "
button btn_RN_SelectObjects "Select Dependent" pos:[53,yp1[7]] width:99 height:23 tooltip:" Selects Texture Dependent Objects In Scene "
button btn_RN_Open "Open" pos:[155,yp1[7]] width:40 height:23 tooltip:" Open Selected Textures "
button btn_RN_SelIdentical "Select Identical Names" pos:[5,yp1[8]] width:120 height:23 tooltip:" Selects Textures With \n Identical Name And Extension "
button btn_RN_SelectAll "Sel All" pos:[128,yp1[8]] width:40 height:23 tooltip:" Lmb - Select Or Deselect All List Items \n Rmb - Deselect All List Items "
button btn_RN_SelectInvert "Inv" pos:[171,yp1[8]] width:24 height:23 tooltip:" Inverts List Selection "
button btn_RN_SelIncorName "Select Incorrect Names" pos:[5,yp1[9]] width:125 height:23 tooltip:" Selects Incorrect Textures Names "
button btn_RN_FixName "Fix Names" pos:[133,yp1[9]] width:62 height:23 tooltip:" Fix Selected Names \n (Copy Texture With Correct Name And Set)"
button btn_RN_LoadersToEditor "Loaders To Edit" pos:[5,yp1[10]] width:92 height:23 tooltip:" Put Selected Textures Dependent Loaders \n To Material Editor "
button btn_RN_MaterialsToEditor "Materials To Edit" pos:[100,yp1[10]] width:95 height:23 tooltip:" Put Selected Textures Dependent \n Materials To Material Editor "

checkButton chbtn_RN_ShowTexPath "" pos:[200,yp1[9]+9] width:14 height:14 checked:false highlightColor:colCHBX tooltip:" Show Texture Path In List "
label lbl_RN_ShowTexPath "Show Texture Path In List" pos:[218,yp1[9]+9] tooltip:chbtn_RN_ShowTexPath.tooltip
checkButton chbtn_RN_Preview "Interactive Preview" pos:[200,yp1[10]] width:144 height:23 highlightColor:colCHBX

radiobuttons rdbtn_RN_CopyOrReplace "" labels:#("Copy","Replace") pos:[353,yp1[9]+11] columns:1 offsets:#([0,0],[0,5]) default:1 tooltip:" Copy Or Replace Renaming Texture "

button btn_RN_Rename "Rename" pos:[418,yp1[9]+9] width:76 height:40

progressBar prgrs_RN_ProBar pos:[7,roll0H-15] width:(fixedW-13) height:10 value:0 color:orange
timer tmr_RN_prgrsFade interval:((3*1000/68) as integer) active:false
on tmr_RN_prgrsFade tick do (ATfn_.ProgBarFade prgrs_RN_ProBar tmr_RN_prgrsFade)
	-------------------------------------------------------------------------------------------------------------------
local shCntrlsPosY = #()
local shCntrls = #(prgrs_RN_ProBar, chbtn_RN_ShowTexPath, lbl_RN_ShowTexPath, btn_RN_SelIdentical, btn_RN_SelIncorName, \
	btn_RN_FixName, chbtn_RN_Preview, btn_RN_SelectAll, btn_RN_LoadersToEditor, btn_RN_MaterialsToEditor, btn_RN_SelectInvert, \
	btn_RN_Rename, btn_RN_SelectMissing, btn_RN_SelectObjects, btn_RN_Open, rdbtn_RN_CopyOrReplace)
	-----fn------------------------------------------------------------------------------------------------------------
FN fn_MSG_SelectItems = (messageBox "Select Items In List." title:" Renamer" beep:false)
	-----fn------------------------------------------------------------------------------------------------------------
FN fn_MSG_FilenameExists = (messageBox "New Filename Already Exists." title:" Renamer" beep:false)
	-----fn------------------------------------------------------------------------------------------------------------
FN fn_MSG_PathsNotExists = (messageBox "One Or More Texture Paths Are Missing." title:" Renamer" beep:false)
	-----fn------------------------------------------------------------------------------------------------------------
FN fn_OpenTexture =
(
if chbtn_RN_Textures.checked do
	(
	local indexArr = mlbx_RN_RenamerList.selection as array
	if indexArr.count == 0 do return (fn_MSG_SelectItems())
	for i in indexArr do
		(
		local Item = TexArr[i]
		openedBitMap = openBitMap Item
		if openedBitMap != undefined do (display openedBitMap caption:Item)
		)
	)
)
	-----fn------------------------------------------------------------------------------------------------------------
FN fn_RestoreListSelection newListSel =
(
local newIndexArr = #()
for i in newListSel do
	(
	if chbtn_RN_Objects.checked do (join newIndexArr (ATfn_.FindAllItems ObjNameArr i))
	if chbtn_RN_Materials.checked do (join newIndexArr (ATfn_.FindAllItems MatNameArr i))
	if chbtn_RN_Textures.checked do (join newIndexArr (ATfn_.FindAllItems TexArr i))
	)
sort newIndexArr
mlbx_RN_RenamerList.selection = (newIndexArr as BitArray)
)
	-----fn------------------------------------------------------------------------------------------------------------
FN fn_GetData =
(
-- 	clearListener()
mlbx_RN_RenamerList.selection = #{}
if chbtn_RN_Objects.checked do
	(
-- 	local sosArr = for o in (if rdbtn_RN_SelectedOrScene.state==1 then selection else objects) where not (isGroupHead o) collect #(o, o.name)
	local sosArr = for o in (if rdbtn_RN_SelectedOrScene.state==1 then selection else objects) collect #(o, o.name)
	local fArr = for n=1 to sosArr.count where (matchPattern sosArr[n][2] pattern:("*" + edt_RN_NameFilter.text + "*")) == true collect (sosArr[n])
	FN fn_CollectByClass inArr byClass =
		(
		local outArr =#()
		for n=1 to inArr.count where (superClassOf inArr[n][1] == byClass) do append outArr inArr[n]
		for n=1 to inArr.count where (classOf inArr[n][1] == Targetobject) do (if (for d in (refs.dependents inArr[n][1]) where (superClassOf d == byClass) collect d).count > 0 do append outArr inArr[n])
		return outArr
		)
	local cArr = #()
	case ddl_RN_ObjClasses.selection of
		(
		1:	(cArr = fArr)
		2:	(for n=1 to fArr.count where (ATfn_.GCheck fArr[n][1] VRProxy:false) do append cArr fArr[n])
		3:	(for n=1 to fArr.count where (classOf fArr[n][1] == VRayProxy) do append cArr fArr[n])
		4:	(for n=1 to fArr.count where (superClassOf fArr[n][1] == shape) do append cArr fArr[n])
		5:	(cArr = fn_CollectByClass fArr light)
		6:	(cArr = fn_CollectByClass fArr camera)
		7:	(cArr = fn_CollectByClass fArr helper)
		8:	(for n=1 to fArr.count where (superClassOf fArr[n][1] == GeometryClass and classOf fArr[n][1] == BoneGeometry) do append cArr fArr[n])
		9:	(
			for n=1 to fArr.count where 
				(
				not (ATfn_.GCheck fArr[n][1] VRProxy:false) and
				not (classOf fArr[n][1] == VRayProxy) and
				not (superClassOf fArr[n][1] == shape) and
				not (superClassOf fArr[n][1] == shape) and
				not (superClassOf fArr[n][1] == light) and
				not (superClassOf fArr[n][1] == camera) and
				not (superClassOf fArr[n][1] == helper) and
				not (classOf fArr[n][1] == Targetobject) and
				not (superClassOf fArr[n][1] == GeometryClass and classOf fArr[n][1] == BoneGeometry)
				)
			do append cArr fArr[n]
			)
		)
	local sArr = ATfn_.AlphabetSortArray cArr
	ObjArr = sArr[1]; ObjNameArr = sArr[2]
	)
if chbtn_RN_Materials.checked do
	(
	local matsArr = #()
	/*
	case rdbtn_RN_SelectedOrScene.state of
		(
		1: (
			for o in selection where (o.mat != undefined) do (appendIfUnique matsArr o.mat)
			ATfn_.AppendSubMaterials matsArr
			)
		2: for cls in material.classes do (join matsArr (getClassInstances cls))
		)
	/*
	case rdbtn_RN_SelectedOrScene.state of
		(
		1: for o in selection where (o.mat != undefined) do (appendIfUnique matsArr o.mat)
		2: matsArr = sceneMaterials
		)
	ATfn_.AppendSubMaterials matsArr
	-- */
	-- */
	/*
	for o in (if rdbtn_RN_SelectedOrScene.state==1 then selection else objects) where (o.material != undefined) do (appendIfUnique matsArr o.material)
	ATfn_.AppendSubMaterials matsArr
	-- */
-- 	/*
	case rdbtn_RN_SelectedOrScene.state of
		(
		1: for o in selection where (o.mat != undefined) do (appendIfUnique matsArr o.mat)
		2: for o in objects where (o.mat != undefined) do (appendIfUnique matsArr o.mat)
		)
	ATfn_.AppendSubMaterials matsArr
	-- */
	local sosArr = for m in matsArr collect #(m, m.name)
	local fArr = for n=1 to sosArr.count where (matchPattern sosArr[n][2] pattern:("*" + edt_RN_NameFilter.text + "*")) == true collect (sosArr[n])
	local cArr = case ddl_RN_MatClasses.selection of
		(
		1:	(fArr)
		2:	(for n=1 to fArr.count where (classOf fArr[n][1] == Standardmaterial) collect fArr[n])
		3:	(for n=1 to fArr.count where (classOf fArr[n][1] == VRayMtl) collect fArr[n])
		4:	(for n=1 to fArr.count where (classOf fArr[n][1] == Multimaterial) collect fArr[n])
		5:	(for n=1 to fArr.count where (classOf fArr[n][1] == PhysicalMaterial) collect fArr[n])
		6:	(for n=1 to fArr.count where (classOf fArr[n][1] == PBRMetalRough) collect fArr[n])
		7:	(for n=1 to fArr.count where (classOf fArr[n][1] == PBRSpecGloss) collect fArr[n])
		8:	(for n=1 to fArr.count where (classOf fArr[n][1] == VRay2SidedMtl) collect fArr[n])
		9:	(for n=1 to fArr.count where (classOf fArr[n][1] == VRayBlendMtl) collect fArr[n])
		10:	(for n=1 to fArr.count where (classOf fArr[n][1] == VRayLightMtl) collect fArr[n])
		11:	(for n=1 to fArr.count where (classOf fArr[n][1] == CustomMaterialClass) collect fArr[n])
		)
	local sArr = ATfn_.AlphabetSortArray cArr
	MatArr = sArr[1]; MatNameArr = sArr[2]
	)
if chbtn_RN_Textures.checked do
	(
	local sosArr = for o in (if rdbtn_RN_SelectedOrScene.state==1 then selection else objects) where (o.material != undefined) collect o.material
	local fArr = ATfn_.GetMapsTextures sosArr SingleTexture:true FilterName:(edt_RN_NameFilter.text)
	fArr = for n=1 to fArr[2].count collect #(fArr[1][n], fArr[2][n])
	local cArr = case ddl_RN_TexTypes.selection of
		(
		1:	(fArr)
		2:	(for n=1 to fArr.count where (matchPattern fArr[n][2] pattern:"*.bmp") collect fArr[n])
		3:	(for n=1 to fArr.count where (matchPattern fArr[n][2] pattern:"*.gif") collect fArr[n])
		4:	(for n=1 to fArr.count where (matchPattern fArr[n][2] pattern:"*.jpeg" or matchPattern fArr[n][2] pattern:"*.jpg") collect fArr[n])
		5:	(for n=1 to fArr.count where (matchPattern fArr[n][2] pattern:"*.png") collect fArr[n])
		6:	(for n=1 to fArr.count where (matchPattern fArr[n][2] pattern:"*.tga") collect fArr[n])
		7:	(for n=1 to fArr.count where (matchPattern fArr[n][2] pattern:"*.tiff" or matchPattern fArr[n][2] pattern:"*.tif") collect fArr[n])
		8:	(
			for n=1 to fArr.count where 
				(
				not (matchPattern fArr[n][2] pattern:"*.bmp") and
				not (matchPattern fArr[n][2] pattern:"*.gif") and
				not (matchPattern fArr[n][2] pattern:"*.jpeg") and
				not (matchPattern fArr[n][2] pattern:"*.jpg") and
				not (matchPattern fArr[n][2] pattern:"*.png") and
				not (matchPattern fArr[n][2] pattern:"*.tga") and
				not (matchPattern fArr[n][2] pattern:"*.tiff") and
				not (matchPattern fArr[n][2] pattern:"*.tif")
				)
			collect fArr[n]
			)
		)
	local sArr = ATfn_.AlphabetSortArray cArr
	LoadArrArr = sArr[1]; TexArr = sArr[2]; TexNameArr = for i in TexArr collect (filenameFromPath i)
	)
)
	-----fn------------------------------------------------------------------------------------------------------------
FN fn_GetPreview NameArr =
(
local PrevArr = deepCopy NameArr
local indexArr = mlbx_RN_RenamerList.selection as array
local mnPrevArr = #()
if (not chbtn_RN_Materials.checked) and chbtn_RN_MaterialAsBase.checked do
	(
	if chbtn_RN_Objects.checked do
		(for n=1 to indexArr.count do (append mnPrevArr (try(ObjArr[indexArr[n]].mat.name)catch(undefined))))
	if chbtn_RN_Textures.checked do
		(for n=1 to indexArr.count do (append mnPrevArr (for d in (refs.dependents LoadArrArr[indexArr[n]][1]) where (superClassOf d == Material and classOf d != Multimaterial) collect d)[1].name))
	for n=1 to mnPrevArr.count do
		(
		if mnPrevArr[n] != undefined do
			(
			local matName = mnPrevArr[n]
			PrevArr[indexArr[n]] = matName
			if chbtn_RN_MABAutoRename.checked do
				(
				local identIndArr = ATfn_.FindAllItems mnPrevArr matName
				if identIndArr.count > 1 do
					(
					for i=1 to identIndArr.count do
						(
						local newName = matName + edt_RN_MABSepar.text + (ATfn_.Counter i CounterDigits:spnr_RN_MABCounterDigs.value)
						PrevArr[indexArr[identIndArr[i]]] = mnPrevArr[identIndArr[i]] = newName
						)
					)
				)
			)
		)
	)
if chbtn_RN_Replace.checked do (for n=1 to indexArr.count do (PrevArr[indexArr[n]] = ATfn_.ReplaceString PrevArr[indexArr[n]] edt_RN_ReplaceIt.text edt_RN_ReplaceWith.text))
if chbtn_RN_RemFirstSymbols.checked do (for n=1 to indexArr.count do (PrevArr[indexArr[n]] = substring PrevArr[indexArr[n]] (spnr_RN_RemFirstSymbols.value + 1) PrevArr[indexArr[n]].count))
if chbtn_RN_RemLastSymbols.checked do (for n=1 to indexArr.count do (PrevArr[indexArr[n]] = substring PrevArr[indexArr[n]] 1 (PrevArr[indexArr[n]].count - spnr_RN_RemLastSymbols.value)))
if chbtn_RN_Base.checked do (for n=1 to indexArr.count do (PrevArr[indexArr[n]] = edt_RN_Base.text))
if chbtn_RN_Prefix.checked do (for n=1 to indexArr.count do (PrevArr[indexArr[n]] = edt_RN_Prefix.text + PrevArr[indexArr[n]]))
if chbtn_RN_Suffix.checked do (for n=1 to indexArr.count do (PrevArr[indexArr[n]] = PrevArr[indexArr[n]] + edt_RN_Suffix.text))
if chbtn_RN_Counter.checked do
	(
	for n=1 to indexArr.count do
		(
		local count = ATfn_.Counter n CounterDigits:spnr_RN_CounterDigits.value StartFrom:spnr_RN_StartFrom.value Step:spnr_RN_CountStep.value
		local separ = if chbtn_RN_Separator.checked then edt_RN_Separator.text else ""
		PrevArr[indexArr[n]] = if rdbtn_RN_CounterBeginOrEnd.state == 1 then (count + separ + PrevArr[indexArr[n]]) else (PrevArr[indexArr[n]] + separ + count)
		)
	)
return PrevArr
)
	-----fn------------------------------------------------------------------------------------------------------------
FN fn_SetPreview =
(
if chbtn_RN_Textures.checked do
	(
	local NameNoExtPrevArr = fn_GetPreview (for i in TexArr collect (getFilenameFile i))
	TexPrevArr = for n=1 to TexArr.count collect ((getFilenamePath TexArr[n]) + NameNoExtPrevArr[n] + (getFilenameType TexArr[n]))
	TexNamePrevArr = for n=1 to TexArr.count collect (NameNoExtPrevArr[n] + (getFilenameType TexArr[n]))
	)
if chbtn_RN_Preview.checked
then
	(
	if chbtn_RN_Objects.checked do mlbx_RN_RenamerList.items = ObjPrevArr = fn_GetPreview ObjNameArr
	if chbtn_RN_Materials.checked do mlbx_RN_RenamerList.items = MatPrevArr = fn_GetPreview MatNameArr
	if chbtn_RN_Textures.checked do
		(
		if chbtn_RN_ShowTexPath.checked
		then (mlbx_RN_RenamerList.items = TexPrevArr)
		else (mlbx_RN_RenamerList.items = TexNamePrevArr)
		)
	)
else
	(
	if chbtn_RN_Objects.checked do mlbx_RN_RenamerList.items = ObjNameArr
	if chbtn_RN_Materials.checked do mlbx_RN_RenamerList.items = MatNameArr
	if chbtn_RN_Textures.checked do
		(
		if chbtn_RN_ShowTexPath.checked
		then (mlbx_RN_RenamerList.items = TexArr)
		else (mlbx_RN_RenamerList.items = TexNameArr)
		)
	)
)
	-----fn------------------------------------------------------------------------------------------------------------
FN fn_GetDataSetPreview =
(
local indexArr = mlbx_RN_RenamerList.selection as array
if indexArr.count == 0
then (fn_GetData(); fn_SetPreview())
else
	(
	local newListSel = #()
	if chbtn_RN_Objects.checked do (for i in indexArr do (append newListSel ObjNameArr[i]))
	if chbtn_RN_Materials.checked do (for i in indexArr do (append newListSel MatNameArr[i]))
	if chbtn_RN_Textures.checked do (for i in indexArr do (append newListSel TexArr[i]))
	fn_GetData(); fn_SetPreview()
	fn_RestoreListSelection newListSel
	fn_SetPreview()
	)
)
	-----fn------------------------------------------------------------------------------------------------------------
FN fn_SelectIdentical =
(
local indexIdentArr = #()
local itemsArr = #()
if chbtn_RN_Objects.checked do itemsArr = deepCopy (if chbtn_RN_Preview.checked then ObjPrevArr else ObjNameArr)
if chbtn_RN_Materials.checked do itemsArr = deepCopy (if chbtn_RN_Preview.checked then MatPrevArr else MatNameArr)
if chbtn_RN_Textures.checked do itemsArr = deepCopy (if chbtn_RN_Preview.checked then TexNamePrevArr else TexNameArr)
for nm in itemsArr do
	(
	local items = ATfn_.FindAllItems itemsArr nm
	if items.count > 1 do join indexIdentArr items
	)
mlbx_RN_RenamerList.selection = (makeUniqueArray indexIdentArr) as BitArray
fn_SetPreview()
)
	-----fn------------------------------------------------------------------------------------------------------------
FN fn_SelectAllList =
(
local listCount = mlbx_RN_RenamerList.items.count
if mlbx_RN_RenamerList.selection.numberSet == listCount
then (mlbx_RN_RenamerList.selection = #{})
else (mlbx_RN_RenamerList.selection = #{1..listCount})
fn_SetPreview()
)
	-----fn------------------------------------------------------------------------------------------------------------
FN fn_SelectDependentObjects =
(
local indexArr = mlbx_RN_RenamerList.selection as array
if indexArr.count == 0 do (return fn_MSG_SelectItems())
-- if rdbtn_RN_SelectedOrScene.state == 1 do mlbx_RN_RenamerList.selection = #{}
local SelArr = #()
if chbtn_RN_Objects.checked do
	(for i in indexArr do append SelArr ObjArr[i])
if chbtn_RN_Materials.checked do
	(for i in indexArr do (join SelArr (refs.dependentNodes MatArr[i])))
if chbtn_RN_Textures.checked do
	(for i in indexArr do (for l in LoadArrArr[i] do (join SelArr (refs.dependentNodes l))))
ATfn_.SelectInGroups SelArr
if rdbtn_RN_SelectedOrScene.state == 1 do fn_SelectAllList()
redrawViews()
fn_SetPreview()
)
	-----fn------------------------------------------------------------------------------------------------------------
FN fn_GetCustomMaterialClass =
(
rollout rollout_MaterialClass "MaterialClass"
(
edittext edt_MC_NameFilter "" pos:[0,0] width:200 height:17 bold:true
multilistbox mlbx_MC_List pos:[0,17] items:(sort (for c in material.classes collect (c as string))) pos:[0,0] selection:0 width:200 tooltip:""
FN fn_GetList =
(
mlbx_MC_List.items = (sort (for c in material.classes collect (c as string)))
mlbx_MC_List.items = for i in mlbx_MC_List.items where (matchPattern i pattern:("*" + edt_MC_NameFilter.text + "*")) == true collect i
setFocus edt_MC_NameFilter
)
on mlbx_MC_List doubleClicked arg do
	(
	CustomMaterialClass = execute (mlbx_MC_List.items)[arg]
	setINISetting iniFile rollTitle "CustomMaterialClass" (CustomMaterialClass as string)
	MatClasses[11] = "More..." + (CustomMaterialClass as string)
	ddl_RN_MatClasses.items = MatClasses
	fn_GetDataSetPreview()
	destroyDialog rollout_MaterialClass
	)
on edt_MC_NameFilter changed txt do (fn_GetList())
on rollout_MaterialClass resized size do (mlbx_MC_List.width = size[1]; mlbx_MC_List.height = size[2]-17; edt_MC_NameFilter.width = size[1])
on rollout_MaterialClass open do (mlbx_MC_List.height = 400-17)
on rollout_MaterialClass close do (fn_GetDataSetPreview())
)
CreateDialog rollout_MaterialClass 200 400 pos:[mouse.screenpos.X-100, mouse.screenpos.Y-100] style:#(#style_resizing, #style_titlebar, #style_toolwindow, #style_sysmenu) modal:true
)
	-----fn------------------------------------------------------------------------------------------------------------
FN fn_SetLoaderFilename Loader Filename =
(
case classOf Loader of
	(
	Bitmaptexture: (Loader.FileName = Filename)
	VRayBitmap: (Loader.HDRIMapName = Filename)
	)
)
	-----fn------------------------------------------------------------------------------------------------------------
	-------------------------------------------------------------------------------------------------------------------
on btn_RN_Rename pressed do with undo on
(
local indexArr = mlbx_RN_RenamerList.selection as array
if indexArr.count == 0 do (return fn_MSG_SelectItems())
local newListSel = #()
local missingSel = #()
if chbtn_RN_Objects.checked do
	(for i in indexArr do (ObjArr[i].name = ObjPrevArr[i]; append newListSel ObjPrevArr[i]))
if chbtn_RN_Materials.checked do
	(for i in indexArr do (MatArr[i].name = MatPrevArr[i]; append newListSel MatPrevArr[i]))
if chbtn_RN_Textures.checked do
	(
	try(close openedBitMap; free openedBitMap)catch(); freeSceneBitmaps()
	for i in indexArr do
		(
		local oldFile = ATfn_.CheckStripGetPath TexArr[i]
		local newFile = ATfn_.CheckStripGetPath TexPrevArr[i]
		if doesFileExist oldFile
		then
			(
			if doesFileExist newFile and getFileSize oldFile != getFileSize newFile do
				(newFile = ATfn_.FoundNewFilename newFile oldFile CounterDigits:CoincidencesCounterDigits)
			if rdbtn_RN_CopyOrReplace.state == 1 then copyFile oldFile newFile else renameFile oldFile newFile
			if (filterString TexArr[i] "\\").count == 1 do newFile = filenameFromPath newFile
			for l in LoadArrArr[i] do (fn_SetLoaderFilename l newFile)
			append newListSel newFile
			)
		else (append missingSel TexArr[i])
		)
	)
fn_GetData()
if missingSel.count == 0
then (fn_RestoreListSelection newListSel)
else
	(
	fn_RestoreListSelection missingSel
	fn_MSG_PathsNotExists()
	)
fn_SetPreview()
)
	-------------------------------------------------------------------------------------------------------------------
on btn_RN_Open pressed do with undo off (fn_OpenTexture())
	-------------------------------------------------------------------------------------------------------------------
on btn_RN_SelectObjects pressed do with undo on (fn_SelectDependentObjects())
	-------------------------------------------------------------------------------------------------------------------
on btn_RN_SelectMissing pressed do with undo off
(
local missIndexArr = #()
for n=1 to TexArr.count where (not doesFileExist (ATfn_.CheckStripGetPath TexArr[n])) do (append missIndexArr n)
mlbx_RN_RenamerList.selection = missIndexArr as bitarray
fn_SetPreview()
)
	-------------------------------------------------------------------------------------------------------------------
on btn_RN_MaterialsToEditor pressed do with undo on
(
local indexArr = mlbx_RN_RenamerList.selection as array
if indexArr.count == 0 do (return fn_MSG_SelectItems())
local toMEditTemp = #()
if chbtn_RN_Objects.checked do
	(
	toMEditTemp = for i in indexArr where (ObjArr[i].mat != undefined) collect ObjArr[i].mat
	)
if chbtn_RN_Materials.checked do
	(
	for i in indexArr do appendIfUnique toMEditTemp MatArr[i]
	)
if chbtn_RN_Textures.checked do
	(
	local loadersArr = #(); for i in indexArr do (for l in LoadArrArr[i] do (appendIfUnique loadersArr l))
	for l in loadersArr do (join toMEditTemp (for d in (refs.dependents l) where (superClassOf d == Material) collect d))
	)
local toMEdit = ATfn_.MakeUniqueMaterialArray toMEditTemp byName:true
local count = if toMEdit.count <= 24 then toMEdit.count else 24
if toMEdit.count != 0
then
	(
-- 	if queryBox "Open Selected Materials in Material Editor?" title:"Open Materials?" beep:false do
		(MatEditor.Open(); for n=1 to count do (meditMaterials[n] = toMEdit[n]))
	)
)
	-------------------------------------------------------------------------------------------------------------------
on btn_RN_LoadersToEditor pressed do with undo on
(
local indexArr = mlbx_RN_RenamerList.selection as array
if indexArr.count == 0 do (return fn_MSG_SelectItems())
local toMEdit = #()
local loadersArr = #()
if chbtn_RN_Objects.checked do
	(
	local mArr = for i in indexArr where (ObjArr[i].mat != undefined) collect ObjArr[i].mat
	for i in indexArr do (join toMEdit (ATfn_.GetMapsTextures mArr)[1])
	)
if chbtn_RN_Materials.checked do
	(
	local mArr = for i in indexArr collect MatArr[i]
	for i in indexArr do (join toMEdit (ATfn_.GetMapsTextures mArr)[1])
	)
if chbtn_RN_Textures.checked do
	(
	for i in indexArr do (for l in LoadArrArr[i] do (appendIfUnique toMEdit l))
	)
local toMEdit = ATfn_.MakeUniqueMaterialArray toMEdit byName:true
local count = if toMEdit.count <= 24 then toMEdit.count else 24
if toMEdit.count != 0
then
	(
-- 	if queryBox "Open Selected Loaders in Material Editor?" title:"Open Materials?" beep:false do
		(MatEditor.Open(); for n=1 to count do (meditMaterials[n] = toMEdit[n]))
	)
)
	-------------------------------------------------------------------------------------------------------------------
on btn_RN_FixName pressed do with undo on
(
local indexArr = mlbx_RN_RenamerList.selection as array
if indexArr.count == 0 do (return fn_MSG_SelectItems())
try(close openedBitMap; free openedBitMap)catch(); freeSceneBitmaps()
local newListSel = #()
local missingSel = #()
local namesArr = #()
if chbtn_RN_Objects.checked then (for i in indexArr do append namesArr ObjNameArr[i])
if chbtn_RN_Materials.checked then (for i in indexArr do append namesArr MatNameArr[i])
if chbtn_RN_Textures.checked then (for i in indexArr do append namesArr (getFilenameFile TexArr[i]))
for n=1 to namesArr.count do
	(
	local fixedName = ATfn_.fixName namesArr[n]
	if fixedName != namesArr[n] do
		(
		local index = indexArr[n]
		if chbtn_RN_Objects.checked do ObjArr[index].name = fixedName
		if chbtn_RN_Materials.checked do MatArr[index].name = fixedName
		if chbtn_RN_Textures.checked
		then
			(
			local oldFile = ATfn_.CheckStripGetPath TexArr[index]
			local newFile = ATfn_.CheckStripGetPath ((getFilenamePath TexArr[index]) + fixedName + (getFilenameType TexArr[index]))
			if doesFileExist oldFile
			then
				(
				if doesFileExist newFile and getFileSize oldFile != getFileSize newFile do
					(newFile = ATfn_.FoundNewFilename newFile oldFile CounterDigits:CoincidencesCounterDigits)
				copyFile oldFile newFile
				if (filterString TexArr[index] "\\").count == 1 do newFile = filenameFromPath newFile
				for l in LoadArrArr[index] do (fn_SetLoaderFilename l newFile)
				append newListSel newFile
				)
			else (append missingSel TexArr[index])
			)
		else
			(
			append newListSel fixedName
			)
		)
	)
fn_GetData()
if missingSel.count == 0
then (fn_RestoreListSelection newListSel)
else
	(
	fn_RestoreListSelection missingSel
	fn_MSG_PathsNotExists()
	)
fn_SetPreview()
)
	-------------------------------------------------------------------------------------------------------------------
on btn_RN_SelIncorName pressed do with undo off
(
local fixIndexArr = #()
local itemsArr = #()
if chbtn_RN_Objects.checked do itemsArr = deepCopy (if chbtn_RN_Preview.checked then ObjPrevArr else ObjNameArr)
if chbtn_RN_Materials.checked do itemsArr = deepCopy (if chbtn_RN_Preview.checked then MatPrevArr else MatNameArr)
if chbtn_RN_Textures.checked do itemsArr = for n=1 to TexArr.count collect (if chbtn_RN_Preview.checked then (getFilenameFile TexPrevArr[n]) else (getFilenameFile TexArr[n]))
for n=1 to itemsArr.count do (if (ATfn_.fixName itemsArr[n]) != itemsArr[n] do (append fixIndexArr n))
mlbx_RN_RenamerList.selection = fixIndexArr as bitarray
fn_SetPreview()
)
	-------------------------------------------------------------------------------------------------------------------
on btn_RN_SelIdentical pressed do with undo off (fn_SelectIdentical())
	-------------------------------------------------------------------------------------------------------------------
on btn_RN_SelectInvert pressed do with undo off (mlbx_RN_RenamerList.selection = (ATfn_.ArraysDifference (for n=1 to mlbx_RN_RenamerList.items.count collect n) (mlbx_RN_RenamerList.selection as array)) as BitArray; fn_SetPreview())
	-------------------------------------------------------------------------------------------------------------------
on btn_RN_SelectAll pressed do with undo off (fn_SelectAllList())
on btn_RN_SelectAll rightclick do with undo off (mlbx_RN_RenamerList.selection = #{}; fn_SetPreview())
	-------------------------------------------------------------------------------------------------------------------
on mlbx_RN_RenamerList selectionEnd do with undo off
(
if keyboard.altPressed
	then (fn_OpenTexture())
else (fn_SetPreview())
)
	-------------------------------------------------------------------------------------------------------------------
on mlbx_RN_RenamerList doubleClicked arg do with undo on
(
renameSingleIndex = (mlbx_RN_RenamerList.selection as array)[1]
-- 	/*
rollout renameSingle_rollout "Rename"
(
edittext btn_Name text:"" pos:[4,4] width:192 height:17 bold:false
radiobuttons rdbtn_CopyOrReplace "" labels:#("Copy","Replace") pos:[7,28] columns:2 offsets:#([0,0],[-6,0]) default:1 tooltip:" Copy Or Replace Renaming Texture "
button btn_Rename "Rename" pos:[122,23] width:74 height:25
	-----fn------------
FN fn_CopyReplaceOneFile copyState: =
	(
	local newListSel = #()
	if chbtn_RN_Objects.checked do
		(
		ObjArr[renameSingleIndex].name = btn_Name.text
		append newListSel btn_Name.text
		)
	if chbtn_RN_Materials.checked do
		(
		MatArr[renameSingleIndex].name = btn_Name.text
		append newListSel btn_Name.text
		)
	if chbtn_RN_Textures.checked do
		(
		if not doesFileExist (ATfn_.CheckStripGetPath TexArr[renameSingleIndex]) do return fn_MSG_PathsNotExists()
		local oldFile = ATfn_.CheckStripGetPath TexArr[renameSingleIndex]
		local newFile = ATfn_.CheckStripGetPath ((getFilenamePath TexArr[renameSingleIndex]) + (btn_Name.text) + (getFilenameType TexArr[renameSingleIndex]))
		if doesFileExist newFile do (return fn_MSG_FilenameExists())
		if copyState then copyFile oldFile newFile else renameFile oldFile newFile
		if (filterString TexArr[renameSingleIndex] "\\").count == 1 do newFile = filenameFromPath newFile
		for l in LoadArrArr[renameSingleIndex] do (fn_SetLoaderFilename l newFile)
		append newListSel newFile
		)
	fn_GetDataSetPreview()
	fn_RestoreListSelection newListSel
	Destroydialog renameSingle_rollout
	)
	-----fn------------
on btn_Rename pressed do with undo on (fn_CopyReplaceOneFile copyState:(rdbtn_CopyOrReplace.state == 1))
on renameSingle_rollout open do
	(
	if chbtn_RN_Objects.checked do (btn_Name.text = (if chbtn_RN_Preview.checked then ObjPrevArr[renameSingleIndex] else ObjNameArr[renameSingleIndex]); rdbtn_CopyOrReplace.enabled = false)
	if chbtn_RN_Materials.checked do (btn_Name.text = (if chbtn_RN_Preview.checked then MatPrevArr[renameSingleIndex] else MatNameArr[renameSingleIndex]); rdbtn_CopyOrReplace.enabled = false)
	if chbtn_RN_Textures.checked do btn_Name.text = (if chbtn_RN_Preview.checked then (getFilenameFile TexPrevArr[renameSingleIndex]) else (getFilenameFile TexArr[renameSingleIndex]))
	)
)
createDialog renameSingle_rollout 200 50 pos:[mouse.screenpos.X-100, mouse.screenpos.Y-30] style:#(#style_titlebar, #style_toolwindow, #style_sysmenu) modal:true
setFocus renameSingle_rollout.btn_Name
--  */
)
	-------------------------------------------------------------------------------------------------------------------
on mlbx_RN_RenamerList rightclick arg do with undo on
(
if keyboard.altPressed
then (fn_SelectIdentical())
else if keyboard.controlPressed
then (mlbx_RN_RenamerList.selection = #{})
else if keyboard.shiftPressed
then (fn_SelectAllList())
else (fn_SelectDependentObjects())
)
	-------------------------------------------------------------------------------------------------------------------
on chbtn_RN_ShowTexPath changed state do (fn_SetPreview())
	-------------------------------------------------------------------------------------------------------------------
on edt_RN_NameFilter changed txt do (fn_GetDataSetPreview(); setFocus edt_RN_NameFilter)
	-------------------------------------------------------------------------------------------------------------------
on btn_RN_Refresh pressed do (fn_GetDataSetPreview())
	-------------------------------------------------------------------------------------------------------------------
on rdbtn_RN_SelectedOrScene changed state do (fn_GetDataSetPreview())
	-------------------------------------------------------------------------------------------------------------------
on ddl_RN_ObjClasses selected item do (mlbx_RN_RenamerList.selection = #{}; fn_GetDataSetPreview())
on ddl_RN_MatClasses selected item do
(
mlbx_RN_RenamerList.selection = #{}
if item == 11
then (fn_GetCustomMaterialClass())
else (fn_GetDataSetPreview())
)
on ddl_RN_TexTypes selected item do (mlbx_RN_RenamerList.selection = #{}; fn_GetDataSetPreview())
	-------------------------------------------------------------------------------------------------------------------
local chbtnMode = #(chbtn_RN_Objects, chbtn_RN_Materials, chbtn_RN_Textures)
local cntrlChbCol1 = #(chbtn_RN_ShowTexPath, chbtn_RN_MaterialAsBase, chbtn_RN_MABAutoRename)
-- local cntrlDis1 = #(lbl_RN_ShowTexPath, chbtn_RN_ShowTexPath, btn_RN_LoadersToEditor, btn_RN_MaterialsToEditor)
local cntrlDis1 = #(lbl_RN_ShowTexPath, chbtn_RN_ShowTexPath, btn_RN_SelectMissing, btn_RN_Open, rdbtn_RN_CopyOrReplace)
local cntrlDis2 = #(ddl_RN_ObjClasses, ddl_RN_MatClasses, ddl_RN_TexTypes)
local cntrlDis3 = #(grp_RN_MaterialAsBase, chbtn_RN_MaterialAsBase, lbl_RN_MaterialAsBase, grp_RN_MABAutoRename, chbtn_RN_MABAutoRename, spnr_RN_MABCounterDigs, edt_RN_MABSepar)
local cntrlDis4 = #(lbl_RN_MaterialAsBase, grp_RN_MABAutoRename, chbtn_RN_MABAutoRename, spnr_RN_MABCounterDigs, edt_RN_MABSepar)
	-------------------------------------------------------------------------------------------------------------------
on chbtn_RN_Objects changed state do
(
mlbx_RN_RenamerList.selection = #{}
chbtnMode.checked = cntrlDis2.enabled = false
chbtn_RN_Objects.checked = ddl_RN_ObjClasses.enabled = true
cntrlDis1.enabled = false
cntrlDis3.enabled = true
cntrlDis4.enabled = chbtn_RN_MaterialAsBase.checked
if chbtn_RN_MaterialAsBase.checked do spnr_RN_MABCounterDigs.enabled = edt_RN_MABSepar.enabled = chbtn_RN_MABAutoRename.checked
ATfn_.chbtnColorUpdate cntrlChbCol1 colCHBX
fn_GetData(); fn_SetPreview()
)
	-------------------------------------------------------------------------------------------------------------------
on chbtn_RN_Materials changed state do
(
mlbx_RN_RenamerList.selection = #{}
chbtnMode.checked = cntrlDis2.enabled = false
chbtn_RN_Materials.checked = ddl_RN_MatClasses.enabled  = true
cntrlDis1.enabled = false
-- btn_RN_MaterialsToEditor.enabled = true
cntrlDis3.enabled = false
ATfn_.chbtnColorUpdate cntrlChbCol1 colCHBX
fn_GetData(); fn_SetPreview()
)
	-------------------------------------------------------------------------------------------------------------------
on chbtn_RN_Textures changed state do
(
mlbx_RN_RenamerList.selection = #{}
chbtnMode.checked = cntrlDis2.enabled = false
chbtn_RN_Textures.checked = ddl_RN_TexTypes.enabled  = true
cntrlDis1.enabled = true
cntrlDis3.enabled = true
cntrlDis4.enabled = chbtn_RN_MaterialAsBase.checked
if chbtn_RN_MaterialAsBase.checked do spnr_RN_MABCounterDigs.enabled = edt_RN_MABSepar.enabled = chbtn_RN_MABAutoRename.checked
ATfn_.chbtnColorUpdate cntrlChbCol1 colCHBX
fn_GetData(); fn_SetPreview()
)
	-------------------------------------------------------------------------------------------------------------------
on btn_RN_ReplaceSwap rightclick do (local RIT = edt_RN_ReplaceIt.text; edt_RN_ReplaceIt.text = edt_RN_ReplaceWith.text; edt_RN_ReplaceWith.text = RIT; fn_SetPreview())
on btn_RN_ReplaceSwap pressed do (edt_RN_ReplaceIt.text = edt_RN_ReplaceWith.text = ""; fn_SetPreview())
	-------------------------------------------------------------------------------------------------------------------
on chbtn_RN_Preview changed state do (fn_SetPreview())
	-------------------------------------------------------------------------------------------------------------------
on chbtn_RN_RemFirstSymbols changed state do (fn_SetPreview(); spnr_RN_RemFirstSymbols.enabled = lbl_RN_FirstSymbols.enabled = state)
on spnr_RN_RemFirstSymbols changed val do (fn_SetPreview())
on chbtn_RN_Prefix changed state do (fn_SetPreview(); edt_RN_Prefix.enabled = state)
on chbtn_RN_Prefix rightclick do (edt_RN_Prefix.text = ""; fn_SetPreview())
on edt_RN_Prefix changed txt do (fn_SetPreview(); setFocus edt_RN_Prefix)
	-------------------------------------------------------------------------------------------------------------------
on chbtn_RN_Base changed state do
(
edt_RN_Base.enabled = state
if not chbtn_RN_Materials.checked do cntrlDis3.enabled = not state
chbtn_RN_MaterialAsBase.checked = false
cntrlDis4.enabled = false
ATfn_.chbtnColorUpdate cntrlDis3 colCHBX
fn_SetPreview()
)
on chbtn_RN_Base rightclick do (edt_RN_Base.text = ""; fn_SetPreview())
on edt_RN_Base changed txt do (fn_SetPreview(); setFocus edt_RN_Base)
	-------------------------------------------------------------------------------------------------------------------
on chbtn_RN_MaterialAsBase changed state do
(
-- chbtn_RN_Base.checked = false
cntrlDis4.enabled = state
if state do spnr_RN_MABCounterDigs.enabled = edt_RN_MABSepar.enabled = chbtn_RN_MABAutoRename.checked
ATfn_.chbtnColorUpdate cntrlDis4 colCHBX
fn_SetPreview()
)
on chbtn_RN_MABAutoRename changed state do (fn_SetPreview(); spnr_RN_MABCounterDigs.enabled = edt_RN_MABSepar.enabled = state)
on spnr_RN_MABCounterDigs changed val do (fn_SetPreview())
on edt_RN_MABSepar changed txt do (fn_SetPreview())
	-------------------------------------------------------------------------------------------------------------------
on chbtn_RN_RemLastSymbols changed state do (fn_SetPreview(); spnr_RN_RemLastSymbols.enabled = lbl_RN_LastSymbols.enabled = state)
on spnr_RN_RemLastSymbols changed val do (fn_SetPreview())
on chbtn_RN_Suffix changed state do (fn_SetPreview(); edt_RN_Suffix.enabled = state)
on chbtn_RN_Suffix rightclick do (edt_RN_Suffix.text = ""; fn_SetPreview())
on edt_RN_Suffix changed txt do (fn_SetPreview(); setFocus edt_RN_Suffix)
	-------------------------------------------------------------------------------------------------------------------
local counterCtrls = #(lbl_RN_CounterAt, rdbtn_RN_CounterBeginOrEnd, spnr_RN_CounterDigits, chbtn_RN_Separator, edt_RN_Separator, spnr_RN_StartFrom, spnr_RN_CountStep)
on chbtn_RN_Counter changed state do
(
counterCtrls.enabled = state
if not chbtn_RN_Separator.checked do edt_RN_Separator.enabled = false
ATfn_.chbtnColorUpdate counterCtrls colCHBX
fn_SetPreview()
)
on rdbtn_RN_CounterBeginOrEnd changed state do (fn_SetPreview())
on spnr_RN_CounterDigits changed val do (fn_SetPreview())
on chbtn_RN_Separator changed state do (fn_SetPreview(); edt_RN_Separator.enabled = state)
on edt_RN_Separator changed txt do (fn_SetPreview())
on spnr_RN_StartFrom changed val do (fn_SetPreview())
on spnr_RN_CountStep changed val do (fn_SetPreview())
	-------------------------------------------------------------------------------------------------------------------
on chbtn_RN_Replace changed state do (fn_SetPreview(); edt_RN_ReplaceIt.enabled = edt_RN_ReplaceWith.enabled = btn_RN_ReplaceSwap.enabled = state)
on chbtn_RN_Replace rightclick do (edt_RN_ReplaceIt.text = edt_RN_ReplaceWith.text = ""; fn_SetPreview())
on edt_RN_ReplaceIt changed txt do (fn_SetPreview(); setFocus edt_RN_ReplaceIt)
on edt_RN_ReplaceWith changed txt do (fn_SetPreview(); setFocus edt_RN_ReplaceWith)
	-------------------------------------------------------------------------------------------------------------------
on rollout_Renamer resized size do
	(
-- 	for n=1 to shCntrls.count do (shCntrls[n].pos.y = size[2] - shCntrlsPosY[n])
-- 	mlbx_RN_RenamerList.height = size[2] - 32 - 85
	if size[2] >= fixedH do (for n=1 to shCntrls.count do (shCntrls[n].pos.y = size[2] - shCntrlsPosY[n]))
	if size[2] < fixedH then mlbx_RN_RenamerList.height = fixedH else mlbx_RN_RenamerList.height = size[2] - 32 - 89
	if size[2] < fixedH do rollout_Renamer.height = fixedH
	if size[1] < fixedW then mlbx_RN_RenamerList.width = fixedW - 205 else mlbx_RN_RenamerList.width = size[1] - 205
	if size[1] < fixedW do rollout_Renamer.width = fixedW
	)
	-------------------------------------------------------------------------------------------------------------------
on rollout_Renamer open do
	(
	if (hasINISetting iniFile rollTitle) do (ATfn_.LoadRolloutINI rollout_Renamer iniFile ExcludedControls)
	if (hasINISetting iniFile rollTitle "shCntrlsPosY")
	then
		(
		shCntrlsPosY = ATfn_.GetINI 0 iniFile rollTitle "shCntrlsPosY" #()
		for n=1 to shCntrls.count do (shCntrls[n].pos.y = rollout_Renamer.height - shCntrlsPosY[n])
		)
	else
		(shCntrlsPosY = for n=1 to shCntrls.count collect (rollout_Renamer.height - shCntrls[n].pos.y))
	ddl_RN_ObjClasses.Enabled = ATfn_.GetINI 0 iniFile rollTitle "ddl_RN_ObjClasses_Enabled" true
	ddl_RN_MatClasses.Enabled = ATfn_.GetINI 0 iniFile rollTitle "ddl_RN_MatClasses_Enabled" true
	ddl_RN_TexTypes.Enabled = ATfn_.GetINI 0 iniFile rollTitle "ddl_RN_TexTypes_Enabled" true
	MatClasses[11] = "More..." + (CustomMaterialClass as string)
	ddl_RN_MatClasses.items = MatClasses
-- 	ATfn_.chbtnColorUpdate #(chbtn_RN_MaterialAsBase, chbtn_RN_MABAutoRename, chbtn_RN_ShowTexPath) colCHBX
	if floater_AssemblyTool != undefined do (floater_AssemblyTool.rollouts[1].chbtn_TL_Renamer.checked = true)
	mlbx_RN_RenamerList.height = rollout_Renamer.height - 32 - 89
	rollout_Renamer.width = fixedW
-- 	rollout_Renamer.height = fixedH
	ATSOps.Refresh(); ATSOps.Silent = true; ATSOps.Disabled = true; ATSOps.AutoLogin = false; ATSOps.DisplayExcluded = true; ATSOps.ExcludeOutputFiles = true
	callbacks.addScript #selectionSetChanged "rollout_Renamer.fn_GetDataSetPreview()" id:#ATcallbacks_RN_
	callbacks.addScript #nodePostDelete "rollout_Renamer.fn_GetDataSetPreview()" id:#ATcallbacks_RN_
	callbacks.addScript #filePostOpenProcess "rollout_Renamer.fn_GetDataSetPreview()" id:#ATcallbacks_RN_
	callbacks.addScript #sceneUndo "rollout_Renamer.fn_GetDataSetPreview()" id:#ATcallbacks_RN_
	callbacks.addScript #sceneRedo "rollout_Renamer.fn_GetDataSetPreview()" id:#ATcallbacks_RN_
	fn_GetDataSetPreview()
	)
	-------------------------------------------------------------------------------------------------------------------
on rollout_Renamer close do 
	(
	ATfn_.UpdateSceneMaterials()
	if floater_AssemblyTool != undefined do (floater_AssemblyTool.rollouts[1].chbtn_TL_Renamer.checked = false)
	ATfn_.SaveRolloutINI rollout_Renamer iniFile ExcludedControls
	if not (hasINISetting iniFile rollTitle "shCntrlsPosY")
	do (setINISetting iniFile rollTitle "shCntrlsPosY" ((for cntrl in shCntrls collect (rollout_Renamer.height - cntrl.pos.y)) as string))
	setINISetting iniFile rollTitle "ddl_RN_ObjClasses_Enabled" (ddl_RN_ObjClasses.enabled as string)
	setINISetting iniFile rollTitle "ddl_RN_MatClasses_Enabled" (ddl_RN_MatClasses.enabled as string)
	setINISetting iniFile rollTitle "ddl_RN_TexTypes_Enabled" (ddl_RN_TexTypes.enabled as string)
	callbacks.removeScripts id:#ATcallbacks_RN_
	try(close openedBitMap; free openedBitMap)catch()
	try(DestroyDialog renameSingle_rollout)catch()
	rollout_Renamer = undefined
	freeSceneBitmaps()
	gc light:true
	)
)
	----===============================================================================================================
rollout_Renamer = ATfn_.CreateRollout rollout_Renamer iniFile rollTitle roll0W roll0H \
RStyle:#(#style_resizing, #style_titlebar, #style_sysmenu, #style_minimizebox, #style_maximizebox)
-------------------------------------------------------------------------------------------------------------
)
