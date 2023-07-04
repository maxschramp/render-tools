(
Global floater_ResizeTextures
Global floater_AssemblyTool
try (if floater_ResizeTextures.dialogBar then (cui.UnRegisterDialogBar floater_ResizeTextures); closeRolloutFloater floater_ResizeTextures) catch()
	-------------------------------------------------------------------------------------------------------------------
local floaterTitle = "ResizeTextures"
local iniPath = (getFilenamePath (getThisScriptFilename())) + "INI\\"
local iniFile = iniPath + "ResizeTextures_Settings.ini"
local fl0W = 220; local fl0H = (ATfn_.GetINI 0 iniFile floaterTitle "LastSize" [fl0W,325])[2]
local colCHBX = ATfn_.GetINI 0 (iniPath + "AssemblyTool_Settings.ini") "Preferences" "color_PS_ChBxColor" [255,156,0]
local ExcludedControls = #("prgrs_RT_ProBar", "tmr_RT_prgrsFade", "btn_RT_DockLeft", "btn_RT_DockFloat", "btn_RT_DockRight", \
	"lbl_RT_Plus")
	-------------------------------------------------------------------------------------------------------------------
local chbtn_RT_RenameIdentical_ttp = \
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
	----=ResizeTextures==============================================================================================
rollout rollout_RT_ "Resize Textures"
(
local yp1 = #(0, 26, 64, 85, 108, 130, 220, 240, 283)
local DockX = 181; local DockW = 13
button btn_RT_DockLeft "<" pos:[DockX-DockW,0] width:DockW height:10 tooltip:" Dock Left "
button btn_RT_DockFloat "::" pos:[DockX,0] width:DockW height:10 tooltip:" Float "
button btn_RT_DockRight ">" pos:[DockX+DockW,0] width:DockW height:10 tooltip:" Dock Right "
on btn_RT_DockLeft pressed do (ATfn_.DockFloaterSide floater_ResizeTextures iniFile "left")
on btn_RT_DockRight pressed do (ATfn_.DockFloaterSide floater_ResizeTextures iniFile "right")
on btn_RT_DockFloat pressed do (ATfn_.DockFloaterFloat floater_ResizeTextures iniFile fl0W fl0H)
	-------
radiobuttons rdbtn_RT_SelectedOrScene "" labels:#("Selected","Scene") pos:[4,yp1[1]+3] columns:2 offsets:#([0,0],[0,0]) default:1 tooltip:" Process All Scene Objects \n Or Selected Objects "

label lbl_RT_ResizeTo "New Textures Size:" pos:[5,yp1[2]]
radiobuttons rdbtn_RT_PixelsOrPercents "" labels:#("Pixels:","Percents:") pos:[100,yp1[2]] columns:1 offsets:#([0,0],[0,1]) default:1 tooltip:" Resized Textures In Pixels Or Percents "
spinner spnr_RT_SizePixels "" pos:[155,yp1[2]] width:50 range:[1,99999,2048] type:#Integer scale:1 enabled:(rdbtn_RT_PixelsOrPercents.state==1) toolTip:" Resized Textures Value In Pixels "
spinner spnr_RT_SizePercents "" pos:[165,yp1[2]+16] width:40 range:[1,100,50] type:#Integer scale:1 enabled:(rdbtn_RT_PixelsOrPercents.state==2) toolTip:" Resized Textures Value In Percents "

label lbl_RT_ResizeBy "Resize By:" pos:[5,yp1[3]]
radiobuttons rdbtn_RT_LongestOrShortest "" labels:#("Longest","Shortest") pos:[64,yp1[3]-1] columns:2 offsets:#([0,0],[0,0]) default:1 tooltip:" Resize By Longest Or Shortest Side "

checkButton chbtn_RT_ResizeIfMore "" pos:[4,yp1[4]] width:14 height:14 checked:false highlightColor:colCHBX tooltip:" Resize If Texture Size \n More Than Spinner Value "
label lbl_RT_ResizeIfMore "Resize If Size More Than:" pos:[22,yp1[4]] tooltip:chbtn_RT_ResizeIfMore.tooltip
spinner spnr_RT_ResizeIfMore "" pos:[145,yp1[4]] width:60 range:[1,99999,2048] type:#Integer scale:1 enabled:(chbtn_RT_ResizeIfMore.checked) toolTip:chbtn_RT_ResizeIfMore.tooltip

checkButton chbtn_RT_CopyResized "" pos:[4,yp1[5]] width:14 height:14 checked:true highlightColor:colCHBX tooltip:" Copy Or Replace Resized Textures "
label lbl_RT_CopyResized "Copy Textures" pos:[22,yp1[5]] tooltip:chbtn_RT_CopyResized.tooltip
edittext edt_RT_ResizedSuffix "" text:"_#Wx#H" pos:[97,yp1[5]] width:103 height:17 bold:true tooltip:" Resized Textures Suffix \n #W - New Width \n #H - New Height "

checkButton chbtn_RT_CollectResized "" pos:[4,yp1[6]] width:14 height:14 checked:true highlightColor:colCHBX tooltip:" Collect Textures To Custom Location. \n If Unchecked Save Resized To Original Location "
label lbl_RT_CollectResized "Collect Resized Textures" pos:[22,yp1[6]] tooltip:chbtn_RT_CollectResized.tooltip
GroupBox grp_RT_CollectResized "Collect To" pos:[1,yp1[6]+18] width:(fl0W-14) height:66
checkButton chbtn_RT_UseScenePath "Scene Path" pos:[4,yp1[6]+35] width:76 height:19 checked:true highlightColor:colCHBX tooltip:" Use Scene Path To Save \n Resized Texture Files "
label lbl_RT_Plus "+ \\" pos:[83,yp1[6]+37]
edittext edt_RT_PlusFolder "" text:"ResizedMaps" pos:[97,yp1[6]+36] width:103 height:17 bold:false
dropdownlist ddl_RT_SetName items:#() pos:[4,yp1[6]+56] width:20 height:33 selection:0 enabled:(not chbtn_RT_UseScenePath.checked) tooltip:" Lmb - Choose Name \n Alt+Lmb - Delete Name \n Rmb - Clear Fild \n Alt+Rmb - Save Name "
edittext edt_RT_CustomPath "" pos:[21,yp1[6]+58] width:(fl0W-62) height:17 bold:false enabled:(not chbtn_RT_UseScenePath.checked) tooltip:" Custom Path To Save \n Resized Texture Files "
button btn_RT_GetScenePath " Get" width:23 height:19 pos:[180,yp1[6]+57] enabled:(not chbtn_RT_UseScenePath.checked) tooltip:" Lmb - Get Path \n Rmb - Get Scene Path "

checkButton chbtn_RT_RenameIdentical "" pos:[4,yp1[7]] width:14 height:14 checked:true highlightColor:colCHBX tooltip:chbtn_RT_RenameIdentical_ttp
label lbl_RT_RenameIdentical "Rename Identical Texture Names" pos:[22,yp1[7]] tooltip:chbtn_RT_RenameIdentical_ttp

button btn_RT_Resize "Resize" pos:[5,yp1[8]] width:(fl0W-20) height:37

progressBar prgrs_RT_ProBar pos:[0,yp1[9]] width:(fl0W-13) height:10 value:0 color:orange
timer tmr_RT_prgrsFade interval:((3*1000/68) as integer) active:false
on tmr_RT_prgrsFade tick do (ATfn_.ProgBarFade prgrs_RT_ProBar tmr_RT_prgrsFade)
	-----fn------------------------------------------------------------------------------------------------------------
FN fn_saveNewTextureResize inputBitmap outputTexture Width Height =
(
local newBitmap = bitmap Width Height
copy inputBitmap newBitmap; newBitmap.filename = outputTexture; save newBitmap
close inputBitmap; close newBitmap
free inputBitmap; free newBitmap
)
	-----fn------------------------------------------------------------------------------------------------------------
	-------------------------------------------------------------------------------------------------------------------
on btn_RT_Resize pressed do with undo on
(
	clearListener()
freeSceneBitmaps()
local textureDir = if chbtn_RT_UseScenePath.checked then ((trimright maxFilePath "\\") + "\\" + edt_RT_PlusFolder.text) else (edt_RT_CustomPath.text)
if chbtn_RT_CollectResized.checked do
	(
	if textureDir == ("\\" + edt_RT_PlusFolder.text) do (return messagebox "Save Scene To Define Scene Path." title:" ResizeTexture")
	if textureDir == "" do (return messagebox "Set Path To Save Resized Texture Files." title:" ResizeTexture")
	)
MatEditor.Close()
disableSceneRedraw()
tmr_RT_prgrsFade.active = false; prgrs_RT_ProBar.value = 0; prgrs_RT_ProBar.color = orange
local inputArr = #(); for o in (if rdbtn_RT_SelectedOrScene.state==1 then selection else objects) where o.material != undefined do (appendIfUnique inputArr o.material)
local MapTexArr = ATfn_.GetMapsTextures inputArr AlphabetSort:true
local MapsArr = MapTexArr[1]
local TexturesArr = MapTexArr[2]
local szPix = spnr_RT_SizePixels.value
local Percnt = spnr_RT_SizePercents.value
local newW; local newH
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
		if chbtn_RT_CopyResized.checked and chbtn_RT_CollectResized.checked do (texPath = textureDir; makeDir texPath)
		local texName = getFilenameFile tex
		local texExt = getFilenameType tex
		local oldBitmap = openBitMap tex
		local oldW = oldBitmap.width as float; local oldH = oldBitmap.height as float
		local newW; local newH
		
		local passBySize = true
		local checkSize
		if oldW == oldH
		then (checkSize = oldW)
		else
			(
			if rdbtn_RT_LongestOrShortest.state == 1
			then (if oldW > oldH then checkSize = oldW else checkSize = oldH)
			else (if oldW < oldH then checkSize = oldW else checkSize = oldH)
			)
		if chbtn_RT_ResizeIfMore.checked and checkSize < spnr_RT_ResizeIfMore.value do passBySize = false
		if passBySize do
			(
			if oldW == oldH
			then
				(
				case rdbtn_RT_PixelsOrPercents.state of
					(
					1: (newW = newH = szPix)
					2: (newW = newH = ATfn_.Round (oldW*(Percnt/100.)) 0)
					)
				)
			else
				(
				case rdbtn_RT_PixelsOrPercents.state of
					(
					1:
						(
						case rdbtn_RT_LongestOrShortest.state of
							(
							1:
								(
								if oldW > oldH
								then (newW = szPix; newH = ATfn_.Round (oldH*(szPix/oldW)) 0)
								else (newH = szPix; newW = ATfn_.Round (oldW*(szPix/oldH)) 0)
								)
							2: 
								(
								if oldW < oldH
								then (newW = szPix; newH = ATfn_.Round (oldH*(szPix/oldW)) 0)
								else (newH = szPix; newW = ATfn_.Round (oldW*(szPix/oldH)) 0)
								)
							)
						)
					2: (newW = ATfn_.Round (oldW*(Percnt/100.)) 0; newH = ATfn_.Round (oldH*(Percnt/100.)) 0)
					)
				)
			
			local texSuffix = if chbtn_RT_CopyResized.checked then (substituteString  (substituteString edt_RT_ResizedSuffix.text "#W" (newW as string)) "#H" (newH as string)) else ""
			local newBitmapStr = texPath + "\\" + texName + texSuffix + texExt
			
			if chbtn_RT_CopyResized.checked
			then
				(
				if not doesFileExist newBitmapStr
				then
					(
					fn_saveNewTextureResize oldBitmap newBitmapStr newW newH
					)
				else
					(
					format "!!! Coincidence --> % --> % \n" map tex
					if (findItem CompletedTexArr tex) == 0 do
						(
						if chbtn_RT_RenameIdentical.checked do
							(
							local score = 1
							while (doesFileExist newBitmapStr) do
								(
								local counter = if score < 10 then ("0" + (score as string)) else (score as string)
								newBitmapStr = texPath + "\\" + texName + texSuffix + "_" + counter + texExt
								score += 1
								)
							fn_saveNewTextureResize oldBitmap newBitmapStr newW newH
							)
						)
					)
				)
			else
				(
				if (findItem CompletedTexArr tex) == 0
				then
					(
					fn_saveNewTextureResize oldBitmap newBitmapStr newW newH
					)
-- 				else (format "!!! Coincidence --> % --> % \n" map tex)
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
	prgrs_RT_ProBar.value = 100.0*n/(MapsArr.count)
	)
prgrs_RT_ProBar.color = green; tmr_RT_prgrsFade.active = true
-- for s=1 to 24 do ( mat = medit.GetTopMtlSlot s ; setMTLMeditObjType mat (getMTLMeditObjType mat) )
	format "Found % Textures \n" TexturesArr.count
enableSceneRedraw()
completeRedraw()
freeSceneBitmaps()
)
	-------------------------------------------------------------------------------------------------------------------
on chbtn_RT_RenameIdentical changed state do (if not state do (messageBox RenameIdentical_msgStr title:" Warning !!!" beep:true))
	-------------------------------------------------------------------------------------------------------------------
on edt_RT_ResizedSuffix changed arg do (if not chbtn_RT_CollectResized.checked and arg == "" do edt_RT_ResizedSuffix.text = "_#Wx#H")
	-------------------------------------------------------------------------------------------------------------------
on chbtn_RT_ResizeIfMore changed state do (spnr_RT_ResizeIfMore.enabled = state)
	-------------------------------------------------------------------------------------------------------------------
on rdbtn_RT_PixelsOrPercents changed state do (spnr_RT_SizePixels.enabled = (state == 1); spnr_RT_SizePercents.enabled = (state == 2))
	-------------------------------------------------------------------------------------------------------------------
local CopyRcontrols = #(chbtn_RT_RenameIdentical, edt_RT_ResizedSuffix, chbtn_RT_CollectResized, btn_RT_GetScenePath, edt_RT_CustomPath, ddl_RT_SetName, edt_RT_PlusFolder, lbl_RT_Plus, chbtn_RT_UseScenePath, grp_RT_CollectResized)
local CollRcontrols = #(btn_RT_GetScenePath, edt_RT_CustomPath, ddl_RT_SetName, edt_RT_PlusFolder, lbl_RT_Plus, chbtn_RT_UseScenePath, grp_RT_CollectResized)
	-------------------------------------------------------------------------------------------------------------------
on chbtn_RT_CopyResized changed state do
(
if state
then
	(
	CopyRcontrols.enabled = state
	if chbtn_RT_CollectResized.checked
	then
		(
		CollRcontrols.enabled = true
		edt_RT_PlusFolder.enabled = chbtn_RT_UseScenePath.checked
		#(ddl_RT_SetName, edt_RT_CustomPath, btn_RT_GetScenePath).enabled = not chbtn_RT_UseScenePath.checked
		)
	else (CollRcontrols.enabled = false)
	)
else (CopyRcontrols.enabled = state)
ATfn_.chbtnColorUpdate CopyRcontrols colCHBX
)
	-------------------------------------------------------------------------------------------------------------------
on chbtn_RT_CollectResized changed state do
(
if state
then
	(
	CollRcontrols.enabled = state
	edt_RT_PlusFolder.enabled = chbtn_RT_UseScenePath.checked
	#(ddl_RT_SetName, edt_RT_CustomPath, btn_RT_GetScenePath).enabled = not chbtn_RT_UseScenePath.checked
	)
else
	(
	CollRcontrols.enabled = state
	if edt_RT_ResizedSuffix.text == "" do edt_RT_ResizedSuffix.text = "_#Wx#H"
	)
ATfn_.chbtnColorUpdate CollRcontrols colCHBX
)
	-------------------------------------------------------------------------------------------------------------------
on chbtn_RT_UseScenePath changed state do (edt_RT_PlusFolder.enabled = state; #(ddl_RT_SetName, edt_RT_CustomPath, btn_RT_GetScenePath).enabled = not state)
	-------------------------------------------------------------------------------------------------------------------
on ddl_RT_SetName selected item do
(	
if keyboard.altPressed
then
	(
	local savedNamesArr = ddl_RT_SetName.items
	if savedNamesArr[item] != "" then (deleteItem savedNamesArr item; ddl_RT_SetName.items = deepCopy savedNamesArr)
	fn_ddlWidthDynamic ddl_RT_SetName
	)
else (edt_RT_CustomPath.text = (ddl_RT_SetName.items)[item])
)
on ddl_RT_SetName rightclick do
(	
if keyboard.altPressed
then
	(
	local savedNamesArr = ddl_RT_SetName.items
	appendIfUnique savedNamesArr edt_RT_CustomPath.text
	sort savedNamesArr
	ddl_RT_SetName.items = deepCopy savedNamesArr
	fn_ddlWidthDynamic ddl_RT_SetName
	setFocus edt_RT_CustomPath
	)
else
	(
	edt_RT_CustomPath.text = ""
	setFocus edt_RT_CustomPath
	)
)
	-------------------------------------------------------------------------------------------------------------------
on btn_RT_GetScenePath pressed do
(
local SavePath = getSavePath initialDir:(edt_RT_CustomPath.text) "\\"
if SavePath != undefined do (edt_RT_CustomPath.text = try(trimright SavePath)catch(edt_RT_CustomPath.text))
)
on btn_RT_GetScenePath rightclick do if maxFilePath != "" do (edt_RT_CustomPath.text = trimright maxFilePath "\\")
	----================================================================================================================================
on rollout_RT_ open do
	(
	if floater_AssemblyTool != undefined do try(floater_AssemblyTool.rollouts[1].chbtn_TL_ResizeTextures.checked = true)catch()
	fn_ddlWidthDynamic ddl_RT_SetName
	)
on rollout_RT_ close do
	(
	if floater_AssemblyTool != undefined do try(floater_AssemblyTool.rollouts[1].chbtn_TL_ResizeTextures.checked = false)catch()
	ATfn_.SaveFloaterINI floater_ResizeTextures iniFile ExcludedControls
	floater_ResizeTextures = undefined
	)
)
	----==============================================================================================================
floater_ResizeTextures = ATfn_.CreateFloater floater_ResizeTextures iniFile fl0W fl0H floaterTitle #(rollout_RT_)
on execute do
	(
	if (hasINISetting iniFile floaterTitle) do (ATfn_.LoadFloaterINI floater_ResizeTextures iniFile ExcludedControls)
-- 	for r in floater_ResizeTextures.Rollouts do (ATfn_.chbtnRunColor r.controls)
	)
)