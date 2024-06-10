(
Global floater_ConvertTextures
Global floater_AssemblyTool
try (if floater_ConvertTextures.dialogBar then (cui.UnRegisterDialogBar floater_ConvertTextures); closeRolloutFloater floater_ConvertTextures) catch()
	-------------------------------------------------------------------------------------------------------------------
local floaterTitle = "ConvertTextures"
local iniPath = (getFilenamePath (getThisScriptFilename())) + "INI\\"
local iniFile = iniPath + "ConvertTextures_Settings.ini"
local fl0W = 220; local fl0H = (ATfn_.GetINI 0 iniFile floaterTitle "LastSize" [fl0W,245])[2]
local colCHBX = ATfn_.GetINI 0 (iniPath + "AssemblyTool_Settings.ini") "Preferences" "color_PS_ChBxColor" [255,156,0]
local ExcludedControls = #("prgrs_CT_ProBar", "tmr_CT_prgrsFade", "btn_CT_DockLeft", "btn_CT_DockFloat", "btn_CT_DockRight", \
	"lbl_CT_Plus", "ddl_CT_Extensions")
	-------------------------------------------------------------------------------------------------------------------
local chbtn_CT_RenameIdentical_ttp = \
" Add Suffix To Identical Texture Names 
 Or 
 Use Existing Texture "
local RenameIdentical_msgStr = \
" Textures Having Same Names Will Be Replaced With: 
 The First Collected Texture 
 Or \n Already Existing In A Collect Folder. "
	-------------------------------------------------------------------------------------------------------------------
	-----fn------------------------------------------------------------------------------------------------------------
FN fn_ddlWidthDynamic ddl =
(
local ddl_koef = 5.; local ddlLim = 30.
local itemsArr = ddl.items
local maxStr = 100; if itemsArr.count != 0 then (strCountArr = (for f in itemsArr collect f.count);  maxStr = aMax strCountArr)
windows.sendmessage ddl.hwnd[1] 352 (maxStr*(ddl_koef + ddlLim/maxStr)) 0
)
	-----fn------------------------------------------------------------------------------------------------------------
	----=ConvertTextures===============================================================================================
rollout rollout_CT_ "Convert Textures"
(
local yp1 = #(0, 23, 50, 140, 160, 203)
local DockX = 181; local DockW = 13
button btn_CT_DockLeft "<" pos:[DockX-DockW,0] width:DockW height:10 tooltip:" Dock Left "
button btn_CT_DockFloat "::" pos:[DockX,0] width:DockW height:10 tooltip:" Float "
button btn_CT_DockRight ">" pos:[DockX+DockW,0] width:DockW height:10 tooltip:" Dock Right "
on btn_CT_DockLeft pressed do (ATfn_.DockFloaterSide floater_ConvertTextures iniFile "left")
on btn_CT_DockRight pressed do (ATfn_.DockFloaterSide floater_ConvertTextures iniFile "right")
on btn_CT_DockFloat pressed do (ATfn_.DockFloaterFloat floater_ConvertTextures iniFile fl0W fl0H)
	-------
radiobuttons rdbtn_CT_SelectedOrScene "" labels:#("Selected","Scene") pos:[4,yp1[1]+3] columns:2 offsets:#([0,0],[0,0]) default:1 tooltip:" Process All Scene Objects \n Or Selected Objects "

label lbl_CT_Format "Convert Textures To:" pos:[5,yp1[2]+3]
dropdownlist ddl_CT_Extensions items:#(".bmp", ".jpg", ".jpeg", ".png", ".tga", ".tiff") pos:[110,yp1[2]] width:54 height:33 selection:2 tooltip:" Converted Texture Extension "
button btn_CT_FormatSetup "Setup" pos:[165,yp1[2]] width:40 height:21 tooltip:" Format Setup "

checkButton chbtn_CT_CollectConverted "" pos:[4,yp1[3]] width:14 height:14 checked:true highlightColor:colCHBX tooltip:" Collect Textures To Custom Location. \n If Unchecked Save Converted To Original Location "
label lbl_CT_CollectConverted "Collect Converted Textures" pos:[22,yp1[3]] tooltip:chbtn_CT_CollectConverted.tooltip

GroupBox grp_CT_CollectConverted "Collect To" pos:[1,yp1[3]+18] width:(fl0W-14) height:66
checkButton chbtn_CT_UseScenePath "Scene Path" pos:[4,yp1[3]+35] width:76 height:19 checked:true highlightColor:colCHBX tooltip:" Use Scene Path To Save \n Converted Texture Files "
label lbl_CT_Plus "+ \\" pos:[83,yp1[3]+37]
edittext edt_CT_PlusFolder "" text:"ConvertedMaps" pos:[97,yp1[3]+36] width:103 height:17 bold:false
dropdownlist ddl_CT_SetName items:#() pos:[4,yp1[3]+56] width:20 height:33 selection:0 enabled:(not chbtn_CT_UseScenePath.checked) tooltip:" Lmb - Choose Name \n Alt+Lmb - Delete Name \n Rmb - Clear Fild \n Alt+Rmb - Save Name "
edittext edt_CT_CustomPath "" pos:[21,yp1[3]+58] width:(fl0W-62) height:17 bold:false enabled:(not chbtn_CT_UseScenePath.checked) tooltip:" Custom Path To Save \n Converted Texture Files "
button btn_CT_GetScenePath " Get" width:23 height:19 pos:[180,yp1[3]+57] enabled:(not chbtn_CT_UseScenePath.checked) tooltip:" Lmb - Get Path \n Rmb - Get Scene Path "

checkButton chbtn_CT_RenameIdentical "" pos:[4,yp1[4]] width:14 height:14 checked:true highlightColor:colCHBX tooltip:chbtn_CT_RenameIdentical_ttp
label lbl_CT_RenameIdentical "Rename Identical Texture Names" pos:[22,yp1[4]] tooltip:chbtn_CT_RenameIdentical_ttp

button btn_CT_Convert "Convert" pos:[5,yp1[5]] width:(fl0W-20) height:37

progressBar prgrs_CT_ProBar pos:[0,yp1[6]] width:(fl0W-13) height:10 value:0 color:orange
timer tmr_CT_prgrsFade interval:((3*1000/68) as integer) active:false
on tmr_CT_prgrsFade tick do (ATfn_.ProgBarFade prgrs_CT_ProBar tmr_CT_prgrsFade)
	-----fn------------------------------------------------------------------------------------------------------------
FN fn_saveNewTexture inputTexture outputTexture =
(
local oldBitmap = openBitMap inputTexture; local newBitmap = bitmap oldBitmap.width oldBitmap.height
copy oldBitmap newBitmap; newBitmap.filename = outputTexture; save newBitmap
close oldBitmap; close newBitmap
free oldBitmap; free newBitmap
)
	-----fn------------------------------------------------------------------------------------------------------------
	-------------------------------------------------------------------------------------------------------------------
on btn_CT_Convert pressed do with undo on
(
	clearListener()
freeSceneBitmaps()
local textureDir = if chbtn_CT_UseScenePath.checked then ((trimright maxFilePath "\\") + "\\" + edt_CT_PlusFolder.text) else (edt_CT_CustomPath.text)
if chbtn_CT_CollectConverted.checked do
	(
	if textureDir == ("\\" + edt_CT_PlusFolder.text) do (return messagebox "Save Scene To Define Scene Path." title:" ConvertTexture")
	if textureDir == "" do (return messagebox "Set Path To Save Converted Texture Files." title:" ConvertTexture")
	)
MatEditor.Close()
disableSceneRedraw()
tmr_CT_prgrsFade.active = false; prgrs_CT_ProBar.value = 0; prgrs_CT_ProBar.color = orange
local inputArr = #(); for o in (if rdbtn_CT_SelectedOrScene.state==1 then selection else objects) where o.material != undefined do (appendIfUnique inputArr o.material)
local MapTexArr = ATfn_.GetMapsTextures inputArr AlphabetSort:true
local MapsArr = MapTexArr[1]
local TexturesArr = MapTexArr[2]
local ext = ddl_CT_Extensions.selected
local CompletedTexArr = #()

for n=1 to MapsArr.count do
	(
	local map = MapsArr[n]
	local tex = TexturesArr[n]
	if doesFileExist tex
	then
		(
		format "% --> % \n" map tex
		local texPath = trimright (getFilenamePath tex) "\\"
		if chbtn_CT_CollectConverted.checked do (texPath = textureDir; makeDir texPath)
		local texName = getFilenameFile tex
		local texExt = getFilenameType tex
		if (ext == ".jpg" or ext == ".jpeg") and (texExt == ".jpg" or texExt == ".jpeg") do texExt = ext
		if texExt != ext do
			(
			local newBitmapStr = texPath + "\\" + texName + ext
			if not doesFileExist newBitmapStr
			then
				(
				fn_saveNewTexture tex newBitmapStr
				)
			else
				(
				format "!!! Coincidence --> % --> % \n" map tex
				if (findItem CompletedTexArr tex) == 0 do
					(
					if chbtn_CT_RenameIdentical.checked do
						(
						local score = 1
						while (doesFileExist newBitmapStr) do
							(
							local counter = if score < 10 then ("0" + (score as string)) else (score as string)
							newBitmapStr = texPath + "\\" + texName + "_" + counter + ext
							score += 1
							)
						fn_saveNewTexture tex newBitmapStr
						)
					)
				)
			case classOf map of
				(
				Bitmaptexture: (map.FileName = newBitmapStr)
				VRayBitmap: (map.HDRIMapName = newBitmapStr)
				)
			)
		append CompletedTexArr tex
		)
	else (format "!!! Texture Does Not Exist --> % \n" tex)
	prgrs_CT_ProBar.value = 100.0*n/(MapsArr.count)
	)
prgrs_CT_ProBar.color = green; tmr_CT_prgrsFade.active = true
-- for s=1 to 24 do ( mat = medit.GetTopMtlSlot s ; setMTLMeditObjType mat (getMTLMeditObjType mat) )
	format "Found % Textures \n" TexturesArr.count
enableSceneRedraw()
completeRedraw()
freeSceneBitmaps()
)
	-------------------------------------------------------------------------------------------------------------------
on chbtn_CT_RenameIdentical changed state do (if not state do (messageBox RenameIdentical_msgStr title:" Warning !!!" beep:true))
	-------------------------------------------------------------------------------------------------------------------
on chbtn_CT_CollectConverted changed state do
(
local CMTcontrols = #(btn_CT_GetScenePath, edt_CT_CustomPath, ddl_CT_SetName, edt_CT_PlusFolder, lbl_CT_Plus, chbtn_CT_UseScenePath, grp_CT_CollectConverted)
if state
then
	(
	CMTcontrols.enabled = state
	edt_CT_PlusFolder.enabled = chbtn_CT_UseScenePath.checked
	#(ddl_CT_SetName, edt_CT_CustomPath, btn_CT_GetScenePath).enabled = not chbtn_CT_UseScenePath.checked
	)
else (CMTcontrols.enabled = state)
ATfn_.chbtnColorUpdate CMTcontrols colCHBX
)
	-------------------------------------------------------------------------------------------------------------------
on chbtn_CT_UseScenePath changed state do (edt_CT_PlusFolder.enabled = state; #(ddl_CT_SetName, edt_CT_CustomPath, btn_CT_GetScenePath).enabled = not state)
	-------------------------------------------------------------------------------------------------------------------
on ddl_CT_SetName selected item do
(	
if keyboard.altPressed
then
	(
	local savedNamesArr = ddl_CT_SetName.items
	if savedNamesArr[item] != "" then (deleteItem savedNamesArr item; ddl_CT_SetName.items = deepCopy savedNamesArr)
	fn_ddlWidthDynamic ddl_CT_SetName
	)
else (edt_CT_CustomPath.text = (ddl_CT_SetName.items)[item])
)
on ddl_CT_SetName rightclick do
(	
if keyboard.altPressed
then
	(
	local savedNamesArr = ddl_CT_SetName.items
	appendIfUnique savedNamesArr edt_CT_CustomPath.text
	sort savedNamesArr
	ddl_CT_SetName.items = deepCopy savedNamesArr
	fn_ddlWidthDynamic ddl_CT_SetName
	setFocus edt_CT_CustomPath
	)
else
	(
	edt_CT_CustomPath.text = ""
	setFocus edt_CT_CustomPath
	)
)
	-------------------------------------------------------------------------------------------------------------------
on btn_CT_GetScenePath pressed do
(
local SavePath = getSavePath initialDir:(edt_CT_CustomPath.text) "\\"
if SavePath != undefined do (edt_CT_CustomPath.text = try(trimright SavePath)catch(edt_CT_CustomPath.text))
)
on btn_CT_GetScenePath rightclick do if maxFilePath != "" do (edt_CT_CustomPath.text = trimright maxFilePath "\\")
	-------------------------------------------------------------------------------------------------------------------
on btn_CT_FormatSetup pressed do
	(
	case ddl_CT_Extensions.selection of
		(
		1: ATfn_.SetupBMP()
		2: ATfn_.SetupJPEG()
		3: ATfn_.SetupJPEG()
		4: ATfn_.SetupPNG()
		5: ATfn_.SetupTGA()
		6: ATfn_.SetupTIFF()
		)
	)
	----================================================================================================================
	
on rollout_CT_ open do
	(
	if floater_AssemblyTool != undefined do try(floater_AssemblyTool.rollouts[1].chbtn_TL_ConvertTextures.checked = true)catch()
	fn_ddlWidthDynamic ddl_CT_SetName
	)
on rollout_CT_ close do
	(
	if floater_AssemblyTool != undefined do try(floater_AssemblyTool.rollouts[1].chbtn_TL_ConvertTextures.checked = false)catch()
	try (ATfn_.SaveFloaterINI floater_ConvertTextures iniFile ExcludedControls) catch(print "Close ConvertTextures")
	floater_ConvertTextures = undefined
	)
)
	----==============================================================================================================
floater_ConvertTextures = ATfn_.CreateFloater floater_ConvertTextures iniFile fl0W fl0H floaterTitle #(rollout_CT_)
on execute do
	(
	if (hasINISetting iniFile floaterTitle) do (ATfn_.LoadFloaterINI floater_ConvertTextures iniFile ExcludedControls)
-- 	for r in floater_ConvertTextures.Rollouts do (ATfn_.chbtnRunColor r.controls)
	)
)