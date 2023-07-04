	--^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
(if ATIcons == undefined then (fileIn ((getFilenamePath(getThisScriptFilename())) + "AssemblyToolIcons.ms")))
(if ATfn_ == undefined then (fileIn ((getFilenamePath(getThisScriptFilename())) + "AssemblyToolStruct.ms")))
	--^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
(
Global rollout_MDLMaterial
Global floater_AssemblyTool
try(if rollout_MDLMaterial.dialogBar then (cui.UnRegisterDialogBar rollout_MDLMaterial); destroyDialog rollout_MDLMaterial)catch()
	--^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
local rollTitle = "MDL Material"
local iniPath = (getFilenamePath (getThisScriptFilename())) + "INI\\"
local iniFile = iniPath + "MDLMaterial_Settings.ini"
local fixedW = 740; local startH = 438; local fixedH = 438
local roll0S = ATfn_.GetINI 0 iniFile rollTitle "LastSize" [fixedW,startH]; local roll0W = roll0S[1]; local roll0H = roll0S[2]
local colCHBX = ATfn_.GetINI 0 (iniPath + "AssemblyTool_Settings.ini") "Preferences" "color_PS_ChBxColor" [255,156,0]
local ExcludedControls = #("mlbx_MDL_Textures", "edt_MDL_AddFormat", "ddl_MDL_MDLMatType", "edt_MDL_RenameCounter", "spnr_MDL_RenameNext", "ddl_MDL_OtherMaterials", \
	"chbtn_MDL_MDLMaterialFilters")
	-------------------------------------------------------------------------------------------------------------------
local LastUsedPath = ATfn_.GetINI 1 iniFile rollTitle "LastUsedPath" "C:"
	-------------------------------------------------------------------------------------------------------------------
local openedBitMap = undefined
-- local TexArr = #()
	-------------------------------------------------------------------------------------------------------------------
	----===============================================================================================================
rollout rollout_MDLMaterial rollTitle
(
local mlbx_MDL_Textures_width_shift = 225
local mlbx_MDL_Textures_height_shift = 40
local yp1 = #(7, 65, 89, 206, 264, 351, 394)
button btn_MDL_AddFiles "Add Files" pos:[220,yp1[1]] width:90 height:23
button btn_MDL_AddFolder "Add Folder" pos:[315,yp1[1]] width:90 height:23
checkButton chbtn_MDL_AddSubFolders "" pos:[410,yp1[1]+5] width:14 height:14 checked:true highlightColor:colCHBX toolTip:" Add Files From Subfolders "
label lbl_MDL_AddSubFolders "Subfolders" pos:[428,yp1[1]+5] toolTip:chbtn_MDL_AddSubFolders.toolTip
button btn_MDL_RemoveAll "Clear List" pos:[490,yp1[1]] width:68 height:23
button btn_MDL_RemoveSelected "Remove Selected" pos:[561,yp1[1]] width:100 height:23
button btn_MDL_SelectAll "Select All" pos:[666,yp1[1]] width:68 height:23
multilistbox mlbx_MDL_Textures items:#() pos:[mlbx_MDL_Textures_width_shift-5,yp1[1]+28] width:(rollout_MDLMaterial.width-mlbx_MDL_Textures_width_shift) height:15 tooltip:" List Of Textures \n DoubleClick - View Texture  "

label lbl_MDL_Basename "Basename:" pos:[10,yp1[1]]
edittext edt_MDL_Basename "" pos:[5,yp1[1]+16] width:205 height:17 bold:false

edittext edt_MDL_RenameCounter "+" text:"01" pos:[143,yp1[1]+37] width:50 height:17 bold:false toolTip:" Material Counter "
spinner spnr_MDL_RenameNext "" pos:[195,yp1[1]+38] width:15 range:[1,999,1] type:#integer scale:1 toolTip:" Material Counter "

checkButton chbtn_MDL_AddPartName "" pos:[7,yp1[2]+2] width:14 height:14 checked:false highlightColor:colCHBX tooltip:" Add To Material Name Part Name Toggle "
label lbl_MDL_AddPartName "Part Name" pos:[25,yp1[2]+2] tooltip:chbtn_MDL_AddPartName.tooltip
dropdownlist ddl_MDL_SetName items:#("Body","Main","Top") pos:[78,yp1[2]-1] width:20 height:33 selection:0 enabled:false tooltip:" Lmb - Choose Name \n Alt+Lmb - Delete Name \n Rmb - Clear Fild \n Alt+Rmb - Save Name "
edittext edt_MDL_PartName "" pos:[95,yp1[2]+1] width:115 height:17 bold:false enabled:false

label lbl_MDL_TextureFormats "Texture Formats:" pos:[10,yp1[3]]
edittext edt_MDL_AddFormat "" pos:[5,yp1[3]+15] width:63 height:17 bold:false
button btn_MDL_AddFormat "+" width:22 height:20 pos:[73,yp1[3]+14] images:ATIcons[1] tooltip:" Add Format "
button btn_MDL_RemoveFormat "-" width:22 height:20 pos:[73,yp1[3]+36] images:ATIcons[2] tooltip:" Remove Format "
multilistbox mlbx_MDL_TextureFormats items:#(".png",".jpg",".jpeg",".tga",".tiff") pos:[9,yp1[3]+36] width:60 height:4 tooltip:" Texture Formats "

GroupBox grp_MDL_MatEditor "Material Editor" pos:[105,yp1[3]+1] width:106 height:96
checkButton chbtn_MDL_AddToMEdit "" pos:[115,yp1[3]+27] width:14 height:14 checked:false highlightColor:colCHBX tooltip:" Add Material to Material Editor "
label lbl_MDL_AddToMEdit "Add to Editor" pos:[133,yp1[3]+27] tooltip:chbtn_MDL_AddToMEdit.tooltip
radiobuttons rdbtn_MDL_Slot "" labels:#("Current Slot","Slot") pos:[118,yp1[3]+47] offsets:#([0,0],[0,7]) columns:1 default:1 enabled:false
spinner spnr_MDL_MEditSlot "" pos:[163,yp1[3]+70] width:33 range:[1,24,1] type:#integer enabled:false toolTip:" Add to Material Editor Slot "

GroupBox grp_MDL_MDLMaterial "MDL Material" pos:[7,yp1[4]-15] width:204 height:68
-- dropdownlist ddl_MDL_MDLMatType items:#("OmniPBR", "OmniGlass", "OmniSurfaceLite") pos:[12,yp1[4]+1] width:194 height:33 selection:1 tooltip:" MDL Material Type "
dropdownlist ddl_MDL_MDLMatType items:#("OmniPBR") pos:[12,yp1[4]+1] width:194 height:33 selection:1 tooltip:" MDL Material Type "
checkButton chbtn_MDL_MDLMaterialFilters "MDL Material Filters" pos:[12,yp1[4]+26] width:194 height:21 highlightColor:colCHBX tooltip:" Opens MDL Material Filters Floater "
	
GroupBox grp_MDL_CreateEmpty "Create Empty MDL Material" pos:[7,yp1[5]] width:204 height:83
checkButton chbtn_MDL_OtherMaterial "" pos:[12,yp1[5]+19] width:14 height:14 checked:false highlightColor:colCHBX tooltip:" Other Empty Material Types "
label lbl_MDL_OtherMaterial "Other" pos:[30,yp1[5]+19] tooltip:chbtn_MDL_OtherMaterial.tooltip
dropdownlist ddl_MDL_OtherMaterials items:#("Standard (Legacy)", "Physical Material", "PBR Metal/Rough", "PBR Spec/Gloss", "VRayMtl") pos:[62,yp1[5]+16] width:144 height:33 selection:1 enabled:false tooltip:" Other Materials "
button btn_MDL_CreateEmptySingle "Single" pos:[12,yp1[5]+40] width:60 height:37
button btn_MDL_CreateEmptyMultiple "Multiple" pos:[77,yp1[5]+40] width:60 height:37
spinner spnr_MDL_EmptyMultipleDigits "Digits" pos:[172,yp1[5]+41] width:30 range:[1,9,2] type:#integer scale:1 toolTip:" Counter Digits "
spinner spnr_MDL_EmptyMultipleFrom "From" pos:[169,yp1[5]+61] width:33 range:[1,99,1] type:#integer scale:1 toolTip:" Start Counter From "

button btn_MDL_CreateMatFromList "Material With Textures From List" pos:[8,yp1[6]] width:204 height:37

button btn_MDL_CreateMatFromBrowser "Material With Textures From Browser" pos:[8,yp1[7]] width:204 height:37
	-------------------------------------------------------------------------------------------------------------------
	-----fn------------------------------------------------------------------------------------------------------------
fn fn_GetPath = getSavePath initialDir:(LastUsedPath + "\\")
	-----fn------------------------------------------------------------------------------------------------------------
FN fn_msgWrongCounter = (messageBox "Counter Field Must Contain Digits." title:"Wrong Counter!" beep:false)
	-----fn------------------------------------------------------------------------------------------------------------
FN fn_OtherMatCreate =
(
local newMat = case ddl_MDL_OtherMaterials.selection of
	(
	default: Standardmaterial()
	1: Standardmaterial()
	2: PhysicalMaterial()
	3: PBRMetalRough()
	4: PBRSpecGloss()
	5: VRayMtl()
	)
return newMat
)
	-----fn------------------------------------------------------------------------------------------------------------
FN fn_MDMatCreateEmpty =
(
local mdlMat = MDLMaterial()
mdlMat.tname = nvomniverse.GetMdlTypeByDisplay ddl_MDL_MDLMatType.selected
return mdlMat
)
	-----fn------------------------------------------------------------------------------------------------------------
FN fn_GetTexByKey texFiles matType keyControls =
(
local iniKeys = iniPath + "MDLMaterialFilters_Settings.ini"
local outTexArr = #()
for kc in keyControls do
	(
	local tArr = #()
	for f in texFiles do
		(
		for k in (ATfn_.GetINI 0 iniKeys matType kc #("undefined")) do
			(
-- 			if (MatchPattern (getFilenameFile f) pattern:("*_" + k + "*")) do (appendIfUnique tArr f)
			if (MatchPattern (getFilenameFile f) pattern:("*_" + k)) or (MatchPattern (getFilenameFile f) pattern:("*_" + k + ".10*")) do (appendIfUnique tArr f)
			)
		)
	append outTexArr tArr
	)
return outTexArr
)
	-----fn------------------------------------------------------------------------------------------------------------
FN fn_CheckUDIM tex = MatchPattern (getFilenameFile tex) pattern:"*.10*"
	-----fn------------------------------------------------------------------------------------------------------------
FN fn_CheckGetMatName =
(
if selection.count == 0 and not chbtn_MDL_AddToMEdit.checked do return ATfn_.messageNS()
local baseName = edt_MDL_Basename.text
local partName = if chbtn_MDL_AddPartName.checked then ("_" + edt_MDL_PartName.text) else ""
if baseName == "" do (return messageBox "Basename field is empty." title:"Enter Basename!" beep:false)
local matName = "M_" + baseName + edt_MDL_RenameCounter.text + partName
-- if (for mat in sceneMaterials where mat.name == matName collect mat).count > 0 do (return messageBox ("Material With Name  \"" + matName + "\"  Already Exists.") title:" Assembly Tool" beep:false)
if (for obj in objects where (obj.mat != undefined and obj.mat.name == matName) collect obj).count > 0 do (return (messageBox ("Material With Name  \"" + matName + "\"  Already Exists.") title:" Assembly Tool" beep:false))
return matName
)
	-----fn------------------------------------------------------------------------------------------------------------
FN fn_CreateMaterial texFiles matName =
(
	clearListener()
try (closeRolloutFloater floater_MDLMaterialFilters) catch()

local keys = #()
local tex_Arr = #()
local properties = #()
local mdlMat
case ddl_MDL_MDLMatType.selected of
(
"OmniPBR":
	(
	keys = #("Albedo", "Roughness", "Metallic", "ORM", "AO", "Emissive", "Opacity", "Normal")
	tex_Arr = fn_GetTexByKey texFiles ddl_MDL_MDLMatType.selected (for k in keys collect ("ddl_" + ddl_MDL_MDLMatType.selected + "_" + k + "Keys_Items"))
-- 		for ta in tex_Arr do (format "% \n" ta)
	mdlMat = MDLMaterial()
	mdlMat.tname = nvomniverse.GetMdlTypeByDisplay ddl_MDL_MDLMatType.selected
		--- _Albedo
	mdlMat.diffuse_texture_colorSpace = 3
		--- _ORM (Reflectivity)
	mdlMat.reflection_roughness_texture_influence = 1
	mdlMat.metallic_texture_influence = 1
	if tex_Arr[4].count > 0 do
		(
		mdlMat.enable_ORM_texture = on
		mdlMat.ORM_texture_colorSpace = 2
		)
		--- _Emissive
	if tex_Arr[6].count > 0 do (mdlMat.enable_emission = on)
		--- _Opacity
	if tex_Arr[7].count > 0 do
		(
		mdlMat.enable_opacity = on
		mdlMat.enable_opacity_texture = on
		)
		--- _Normal
	mdlMat.normalmap_texture_colorSpace = 2
	
	mdlMat.name = matName
	
	properties = #("diffuse_texture", "reflectionroughness_texture", "metallic_texture", "ORM_texture", "ao_texture", "emissive_color_texture", "opacity_texture", "normalmap_texture")
	for n=1 to properties.count do
		(
		if tex_Arr[n].count != 0 do
			(
			if not (fn_CheckUDIM tex_Arr[n][1])
			then (setProperty mdlMat properties[n] (Bitmaptexture fileName:tex_Arr[n][1]))
			else
				(
				local mTile = MultiTile PatternFormat:2
				mTile.setPatternedImageFile tex_Arr[n][1]
				setProperty mdlMat properties[n] mTile
				)
			)
		)
	)
-- "OmniGlass": 
-- 	(
-- 	)
)

if chbtn_MDL_AddToMEdit.checked do (meditMaterials[if rdbtn_MDL_Slot.state == 1 then activeMeditSlot else spnr_MDL_MEditSlot.value] = mdlMat)
if selection.count != 0 do selection.mat = mdlMat
completeRedraw()
)
	-----fn------------------------------------------------------------------------------------------------------------
	-------------------------------------------------------------------------------------------------------------------
on btn_MDL_CreateMatFromList pressed do
(
local matName = fn_CheckGetMatName()
if classOf matName == OkClass do return false
local indexArr = mlbx_MDL_Textures.selection as array
if indexArr.count == 0 do return (ATfn_.messageSI())
fn_CreateMaterial (for i in indexArr collect mlbx_MDL_Textures.items[i]) matName
)
	-------------------------------------------------------------------------------------------------------------------
on btn_MDL_CreateMatFromBrowser pressed do
(
local matName = fn_CheckGetMatName()
if classOf matName == OkClass do return false
local types = ""
for type in mlbx_MDL_TextureFormats.items do types += "*" + type + "; "
trimRight types "; "
local texFiles = ATfn_.GetDirFiles types:("(" + types + ")|" + types) initialDir:LastUsedPath
if texFiles != undefined do
	(
	fn_CreateMaterial texFiles matName
	LastUsedPath = trimRight (getFilenamePath texFiles[1]) "\\"
	)
)
	-------------------------------------------------------------------------------------------------------------------
on chbtn_MDL_MDLMaterialFilters changed state do
(
if state
	then (filein ((getFilenamePath (getThisScriptFilename())) + "MDLMaterialFilters.ms"))
	else (closeRolloutFloater floater_MDLMaterialFilters; floater_MDLMaterialFilters = undefined)
)
	-------------------------------------------------------------------------------------------------------------------
on chbtn_MDL_OtherMaterial changed state do (#(ddl_MDL_MDLMatType, chbtn_MDL_MDLMaterialFilters, btn_MDL_CreateMatFromList, btn_MDL_CreateMatFromBrowser).enabled = not state; ddl_MDL_OtherMaterials.enabled = state)
	-------------------------------------------------------------------------------------------------------------------
on chbtn_MDL_AddPartName changed state do (#(lbl_MDL_AddPartName, ddl_MDL_SetName, edt_MDL_PartName).enabled = state)
	-------------------------------------------------------------------------------------------------------------------
on btn_MDL_CreateEmptyMultiple pressed do
(
	clearListener()
if selection.count == 0 do return ATfn_.messageNS()
local baseName = edt_MDL_Basename.text
local partName = if chbtn_MDL_AddPartName.checked then ("_" + edt_MDL_PartName.text) else ""
if baseName == "" do (return messageBox "Basename field is empty." title:"Enter Basename!" beep:false)
for n=1 to selection.count do
	(
	local newMat
	if chbtn_MDL_OtherMaterial.checked
	then (newMat = fn_OtherMatCreate())
	else (newMat = fn_MDMatCreateEmpty())
	newMat.name = "M_" + baseName + (ATfn_.Counter n CounterDigits:(spnr_MDL_EmptyMultipleDigits.value) StartFrom:(spnr_MDL_EmptyMultipleFrom.value) Step:1) + partName
	selection[n].mat = newMat
	)
)
	-------------------------------------------------------------------------------------------------------------------
on btn_MDL_CreateEmptySingle pressed do
(
-- 	clearListener()
if selection.count == 0 and not chbtn_MDL_AddToMEdit.checked do return ATfn_.messageNS()
local baseName = edt_MDL_Basename.text
local partName = if chbtn_MDL_AddPartName.checked then ("_" + edt_MDL_PartName.text) else ""
if baseName == "" do (return messageBox "Basename field is empty." title:"Enter Basename!" beep:false)
local newMat
if chbtn_MDL_OtherMaterial.checked
then (newMat = fn_OtherMatCreate())
else (newMat = fn_MDMatCreateEmpty())
newMat.name = "M_" + baseName + edt_MDL_RenameCounter.text + partName
if selection.count != 0 do selection.mat = newMat
if chbtn_MDL_AddToMEdit.checked do (meditMaterials[if rdbtn_MDL_Slot.state == 1 then activeMeditSlot else spnr_MDL_MEditSlot.value] = newMat)
)
	-------------------------------------------------------------------------------------------------------------------
on btn_MDL_RemoveFormat pressed do
(
ATfn_.RemoveListItems mlbx_MDL_TextureFormats mlbx_MDL_TextureFormats.selection
if mlbx_MDL_TextureFormats.items.count == 0 do (ATfn_.AddListItem mlbx_MDL_TextureFormats ".png")
)
	-------------------------------------------------------------------------------------------------------------------
on btn_MDL_AddFormat pressed do
(
local txt = edt_MDL_AddFormat.text
if txt != "" and txt[1] == "." do (ATfn_.AddListItem mlbx_MDL_TextureFormats edt_MDL_AddFormat.text)
)
	-------------------------------------------------------------------------------------------------------------------
on chbtn_MDL_AddToMEdit changed state do (#(rdbtn_MDL_Slot, spnr_MDL_MEditSlot).enabled = state)
	-------------------------------------------------------------------------------------------------------------------
on edt_MDL_RenameCounter entered txt do
(
local cnt = edt_MDL_RenameCounter.text as number
if cnt == undefined
then (edt_MDL_RenameCounter.text = "01"; spnr_MDL_RenameNext.value = 1; fn_msgWrongCounter())
else (spnr_MDL_RenameNext.value = cnt; edt_MDL_RenameCounter.text = if cnt < 10 then ("0" + (cnt as string)) else (cnt as string))
)
	-------------------------------------------------------------------------------------------------------------------
FN fn_spnr_MDL_RenameNext =
(
local val = spnr_MDL_RenameNext.value
local cnt = edt_MDL_RenameCounter.text as number
if cnt == undefined
then (edt_MDL_RenameCounter.text = "01"; spnr_MDL_RenameNext.value = 1; fn_msgWrongCounter())
else (edt_MDL_RenameCounter.text = if val < 10 then ("0" + (val as string)) else (val as string))
)
	-------------------
on spnr_MDL_RenameNext changed val do fn_spnr_MDL_RenameNext()
on spnr_MDL_RenameNext entered inSpin_arg inCancel_arg do fn_spnr_MDL_RenameNext()
	-------------------------------------------------------------------------------------------------------------------
on ddl_MDL_SetName selected item do
(	
if keyboard.altPressed
then
	(
	local savedNamesArr = ddl_MDL_SetName.items
	if savedNamesArr[item] != "" then (deleteItem savedNamesArr item; ddl_MDL_SetName.items = deepCopy savedNamesArr)
	ATfn_.ddlWidthDynamic ddl_MDL_SetName
	)
else (edt_MDL_PartName.text = (ddl_MDL_SetName.items)[item])
)
on ddl_MDL_SetName rightclick do
(	
if keyboard.altPressed
then
	(
	local savedNamesArr = ddl_MDL_SetName.items
	appendIfUnique savedNamesArr edt_MDL_PartName.text
	sort savedNamesArr
	ddl_MDL_SetName.items = deepCopy savedNamesArr
	ATfn_.ddlWidthDynamic ddl_MDL_SetName
	setFocus edt_MDL_PartName
	)
else
	(
	edt_MDL_PartName.text = ""
	setFocus edt_MDL_PartName
	)
)
	-------------------------------------------------------------------------------------------------------------------
on mlbx_MDL_Textures doubleClicked arg do with undo off
(
	clearListener()

local selItem = mlbx_MDL_Textures.items[arg]
openedBitMap = openBitMap selItem
if openedBitMap != undefined
	then (display openedBitMap caption:selItem)
	else (ShellLaunch "explorer.exe" (getFilenamePath selItem))
)
	-------------------------------------------------------------------------------------------------------------------
on btn_MDL_AddFolder pressed do
(
local searchPath = fn_GetPath()
if searchPath != undefined do
	(
	local texFiles = #()
	local dirs = #(searchPath)
	if chbtn_MDL_AddSubFolders.checked do (for dir in dirs do (join dirs (getDirectories (dir + "/*"))))
	for dir in dirs do
		(
		for type in mlbx_MDL_TextureFormats.items do
			(
			for f in (getFiles (dir + "\\" + ("*" + type + ""))) do appendIfUnique texFiles f
			)
		)
	ATfn_.AddListItems mlbx_MDL_Textures texFiles
	LastUsedPath = searchPath
	)
)
	-------------------------------------------------------------------------------------------------------------------
on btn_MDL_AddFiles pressed do
(
local types = ""
for type in mlbx_MDL_TextureFormats.items do types += "*" + type + "; "
trimRight types "; "
local texFiles = ATfn_.GetDirFiles types:("(" + types + ")|" + types) initialDir:LastUsedPath
if texFiles != undefined do
	(
	ATfn_.AddListItems mlbx_MDL_Textures texFiles
	LastUsedPath = trimRight (getFilenamePath texFiles[1]) "\\"
	)
)
	-------------------------------------------------------------------------------------------------------------------
on btn_MDL_SelectAll pressed do (mlbx_MDL_Textures.selection = #{1..mlbx_MDL_Textures.items.count})
	-------------------------------------------------------------------------------------------------------------------
on btn_MDL_RemoveSelected pressed do (ATfn_.RemoveListItems mlbx_MDL_Textures mlbx_MDL_Textures.selection)
	-------------------------------------------------------------------------------------------------------------------
on btn_MDL_RemoveAll pressed do (mlbx_MDL_Textures.items = #())
	-------------------------------------------------------------------------------------------------------------------
	--^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
	-------------------------------------------------------------------------------------------------------------------
on rollout_MDLMaterial resized size do
	(
	if size[2] < fixedH then mlbx_MDL_Textures.height = fixedH else mlbx_MDL_Textures.height = size[2] - mlbx_MDL_Textures_height_shift
	if size[2] < fixedH do rollout_MDLMaterial.height = fixedH
	if size[1] < fixedW then mlbx_MDL_Textures.width = fixedW - mlbx_MDL_Textures_width_shift else mlbx_MDL_Textures.width = size[1] - mlbx_MDL_Textures_width_shift
	if size[1] < fixedW do rollout_MDLMaterial.width = fixedW
	)
	-------------------------------------------------------------------------------------------------------------------
on rollout_MDLMaterial open do
	(
	if (hasINISetting iniFile rollTitle) do (ATfn_.LoadRolloutINI rollout_MDLMaterial iniFile ExcludedControls)
	mlbx_MDL_Textures.height = rollout_MDLMaterial.height - mlbx_MDL_Textures_height_shift
	mlbx_MDL_Textures.width = rollout_MDLMaterial.width - mlbx_MDL_Textures_width_shift
	mlbx_MDL_Textures.selection = #{}
	)
	-------------------------------------------------------------------------------------------------------------------
on rollout_MDLMaterial close do 
	(
	if floater_AssemblyTool != undefined do (floater_AssemblyTool.rollouts[1].chbtn_TL_MDLMaterial.checked = false)
	ATfn_.SaveRolloutINI rollout_MDLMaterial iniFile ExcludedControls
	setINISetting iniFile rollTitle "LastUsedPath" LastUsedPath
	try(close openedBitMap; free openedBitMap)catch()
	try (closeRolloutFloater floater_MDLMaterialFilters) catch()
	rollout_MDLMaterial = undefined
	freeSceneBitmaps()
	gc light:true
	)
)
	----===============================================================================================================
rollout_MDLMaterial = ATfn_.CreateRollout rollout_MDLMaterial iniFile rollTitle roll0W roll0H \
RStyle:#(#style_resizing, #style_titlebar, #style_sysmenu, #style_minimizebox, #style_maximizebox)
-------------------------------------------------------------------------------------------------------------
)
