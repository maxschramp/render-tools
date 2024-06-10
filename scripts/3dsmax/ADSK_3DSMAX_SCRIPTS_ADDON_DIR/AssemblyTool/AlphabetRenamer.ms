	-----------------
	--^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
(if ATIcons == undefined then (fileIn ((getFilenamePath(getThisScriptFilename())) + "AssemblyToolIcons.ms")))
(if ATfn_ == undefined then (fileIn ((getFilenamePath(getThisScriptFilename())) + "AssemblyToolStruct.ms")))
	--^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
(
Global floater_AlphabetRenamer
Global floater_AssemblyTool
try (if floater_AlphabetRenamer.dialogBar then (cui.UnRegisterDialogBar floater_AlphabetRenamer); closeRolloutFloater floater_AlphabetRenamer) catch()
	-------------------------------------------------------------------------------------------------------------------
local floaterTitle = "Alphabet Renamer"
local iniPath = (getFilenamePath (getThisScriptFilename())) + "INI\\"
local iniFile = iniPath + "AlphabetRenamer_Settings.ini"
local fl0W = 220; local fl0H = (ATfn_.GetINI 0 iniFile floaterTitle "LastSize" [fl0W,405])[2]
local colCHBX = ATfn_.GetINI 0 (iniPath + "AssemblyTool_Settings.ini") "Preferences" "color_PS_ChBxColor" [255,156,0]
local lastUsedPath = ATfn_.GetINI 1 iniFile floaterTitle "LastUsedPath" ""
local ExcludedControls = #("prgrs_AR_ProBar", "tmr_AR_prgrsFade", "btn_AR_DockLeft", "btn_AR_DockFloat", "btn_AR_DockRight", \
	"ddl_AR_Alphabet", "razdel00", "chbtn_AR_CollectPath", "ddl_AR_ConvertExtensions", "btn_AR_RenameTextures")
	-------------------------------------------------------------------------------------------------------------------
	----=AlphabetRenamer==============================================================================================
rollout rollout_AR_ "Alphabet Renamer"
(
local alphabetArr = #("A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z")
local ttp_AR_CollectPath = "Specify the folder to collect textures"
	-------
local yp1 = #(0, 42, 197, 365)
local DockX = 181; local DockW = 13
button btn_AR_DockLeft "<" pos:[DockX-DockW,0] width:DockW height:10 tooltip:" Dock Left "
button btn_AR_DockFloat "::" pos:[DockX,0] width:DockW height:10 tooltip:" Float "
button btn_AR_DockRight ">" pos:[DockX+DockW,0] width:DockW height:10 tooltip:" Dock Right "
on btn_AR_DockLeft pressed do (ATfn_.DockFloaterSide floater_AlphabetRenamer iniFile "left")
on btn_AR_DockRight pressed do (ATfn_.DockFloaterSide floater_AlphabetRenamer iniFile "right")
on btn_AR_DockFloat pressed do (ATfn_.DockFloaterFloat floater_AlphabetRenamer iniFile fl0W fl0H)
	-------
radiobuttons rdbtn_AR_SelectedOrScene "" labels:#("Selected","Scene") pos:[4,yp1[1]+4] columns:2 offsets:#([0,0],[0,0]) default:1 tooltip:" Process All Scene Objects \n Or Selected Objects "

label lbl_AR_RenameMatObj "Rename Materials And Objects" pos:[26,yp1[2]-18]

edittext edt_AR_NewName "" pos:[-4,yp1[2]] width:(fl0W-10) height:17

label lbl_AR_Alphabet "Alphabet:" pos:[4,yp1[2]+24]
dropdownlist ddl_AR_Alphabet items:alphabetArr pos:[54,yp1[2]+22] width:40 height:30 selection:1 tooltip:" Alphabet Counter "
label lbl_AR_Count "Count:" pos:[125,yp1[2]+24]
spinner spnr_AR_CharacterCount "" pos:[160,yp1[2]+24] width:40 range:[1,99,1] type:#integer scale:1 tooltip:" Characters Count "

checkButton chbtn_AR_AlphabetSeparator "" pos:[4,yp1[2]+46] width:14 height:14 highlightColor:colCHBX tooltip:" Separator For Alphabet Toggle "
label lbl_AR_AlphabetSeparator "Alphabet Separator:" pos:[22,yp1[2]+46]
edittext edt_AR_AlphabetSeparator "" text:"_" pos:[124,yp1[2]+44] width:40 height:17

checkButton chbtn_AR_ToLayer "" pos:[4,yp1[2]+65] width:14 height:14 highlightColor:colCHBX tooltip:" Add Objects To Layer By Material Name "
label lbl_AR_ToLayer "To Layer By Material Name" pos:[22,yp1[2]+65]

checkButton chbtn_AR_ToggleObjectCounter "" pos:[4,yp1[2]+84] width:14 height:14 highlightColor:colCHBX tooltip:" Objects Counter Toggle "
label lbl_AR_ToggleObjectCounter "Counter" pos:[22,yp1[2]+84]
spinner spnr_AR_ObjectCounter "Digits:" pos:[96,yp1[2]+84] width:40 range:[0,9,3] type:#integer scale:1 tooltip:" If Counter Set To 0 Then \n Counter Digits = Count Of Objects "

button btn_AR_RenameMatObj "Rename" pos:[0,yp1[2]+104] width:(fl0W-13) height:37 tooltip:" Rename Materials And Objects "

checkButton razdel_00 "" pos:[-8,yp1[3]-9] width:fl0W height:3 highlightColor:[200,200,200] checked:true enabled:false

label lbl_AR_RenameTextures "Rename And Collect Textures" pos:[30,yp1[3]]

checkButton chbtn_AR_CollectPath "Collect Textures to..." pos:[0,yp1[3]+17] width:(fl0W-13) height:23 tooltip:ttp_AR_CollectPath

checkButton chbtn_AR_Convert "" pos:[4,yp1[3]+45] width:14 height:14 highlightColor:colCHBX tooltip:" Convert Texture Toggle "
label lbl_AR_Convert "Convert to:" pos:[22,yp1[3]+45]
dropdownlist ddl_AR_ConvertExtensions items:#(".bmp", ".jpg", ".jpeg", ".png", ".tga", ".tiff") pos:[86,yp1[3]+43] width:54 height:33 selection:2 tooltip:" Convert Extensions "
button btn_AR_FormatSetup "Setup" pos:[143,yp1[3]+43] width:50 height:21 tooltip:" Convertion Format Setup "

checkButton chbtn_AR_SubFolders "" pos:[4,yp1[3]+65] width:14 height:14 highlightColor:colCHBX tooltip:" Create Subfolders By Material Name "
label lbl_AR_SubFolders "Subfolders by Material" pos:[22,yp1[3]+65]

checkButton chbtn_AR_SaveModel "" pos:[4,yp1[3]+85] width:14 height:14 highlightColor:colCHBX tooltip:" Save Models By Material Name "
label lbl_AR_SaveModel "Save Models by Material" pos:[22,yp1[3]+85]

checkButton chbtn_AR_ModelToLayer "" pos:[4,yp1[3]+105] width:14 height:14 highlightColor:colCHBX tooltip:" When Save Models\n Add Objects To Layer \n By Material Name "
label lbl_AR_ModelToLayer "Add Objects to Layer" pos:[22,yp1[3]+105]

button btn_AR_RenameTextures "Rename And Collect" pos:[0,yp1[3]+125] width:(fl0W-13) height:37 enabled:false tooltip:" Rename And Collect Textures "

progressBar prgrs_AR_ProBar pos:[0,yp1[4]] width:(fl0W-13) height:10 value:0 color:orange
timer tmr_AR_prgrsFade interval:((3*1000/68) as integer) active:false
on tmr_AR_prgrsFade tick do (ATfn_.ProgBarFade prgrs_AR_ProBar tmr_AR_prgrsFade)
	-----ControlArrays-------------------------------------------------------------------------------------------------
local CHBXarr = #(chbtn_AR_AlphabetSeparator, chbtn_AR_ToLayer, chbtn_AR_ToggleObjectCounter, chbtn_AR_Convert, \
	chbtn_AR_SubFolders, chbtn_AR_SaveModel, chbtn_AR_ModelToLayer)
	-----ControlArrays-------------------------------------------------------------------------------------------------
	-----fn------------------------------------------------------------------------------------------------------------
FN fn_GetObjs =
(
if rdbtn_AR_SelectedOrScene.state == 2
then (for objct in objects where objct.material != undefined collect objct)
else (for objct in selection where objct.material != undefined collect objct)
)
	-----fn------------------------------------------------------------------------------------------------------------
FN fn_GetMats = (local matsArr = #(); for objct in (fn_GetObjs()) do (appendIfUnique matsArr objct.material); return matsArr)
	-----fn------------------------------------------------------------------------------------------------------------
FN fn_NormalizeName nm =
(
local newName = ""
local ristrSymbls = #(" ","_","-",".",",",";",":","!","@","#","$","%","&","*","/","\\","|","'","+","=")
local strArr = #(nm)
for rs in ristrSymbls do
	(
	local tStrArr = #()
-- 	for s in strArr do (for fs in (filterString s rs) do (append tStrArr fs))
	for s in strArr do (join tStrArr (filterString s rs))
	strArr = tStrArr
	)
local findState = 1; do (findState = findItem strArr "Dup"; if findState != 0 then (deleteItem strArr findState)) while (findState != 0)
for s in strArr do (newName += (replace s 1 1 (toUpper s[1])))
case newName of
	(
	-----Standard
	"DiffuseColor": newName = "Diffuse"
	"AmbientColor": newName = "Ambient"
	"SpecularColor": newName = "Specular"
	"FilterColor": newName = "Filter"
	-----VRay
	"DiffuseMap": newName = "Diffuse"
	"SelfIllum": newName = "SelfIllumination"
	"ReflectMap": newName = "Reflect"
	"HilightGloss": newName = "HGlossiness"
	"ReflGloss": newName = "RGlossiness"
	"RefractMap": newName = "Refract"
	"RefrGloss": newName = "Glossiness"
	"BumpMap": newName = "Bump"
	-----Normal_Bump
	"AdditionalBump": newName = "Bump"
-- 	"": newName = ""
	)
return newName
)
	-----fn------------------------------------------------------------------------------------------------------------
FN fn_Warning1 = (messageBox "Objects not Selected ,  Scene Empty  or  Objects With No Materials." title:"WARNING !!!" beep:false)
	-----fn------------------------------------------------------------------------------------------------------------
	-------------------------------------------------------------------------------------------------------------------
on btn_AR_RenameMatObj pressed do with undo on
(
local separ = if chbtn_AR_AlphabetSeparator.checked then edt_AR_AlphabetSeparator.text else ""
local OArr = fn_GetObjs()
local processMatArr = fn_GetMats()
if processMatArr.count != 0 then
(
-----------------------------------------------------------------------Rename Root Materials and Objects-----------------------------------------------------------------------------
local SMArrArr = #()
local FAC = 27 - ddl_AR_Alphabet.selection
local MAAC = (((processMatArr.count)-FAC)/26)+1
for n=1 to (MAAC+1) do (append SMArrArr #())
for n=1 to FAC do (if processMatArr[n] != undefined then (append SMArrArr[1] processMatArr[n]) )
for n=1 to MAAC do (for mn=1 to 26 do (if processMatArr[FAC+(mn+(26*(n-1)))] != undefined then (append SMArrArr[n+1] processMatArr[FAC+(mn+(26*(n-1)))]) ) )
if (SMArrArr[SMArrArr.count]).count == 0 then (deleteItem SMArrArr (SMArrArr.count))
for mn=1 to (SMArrArr[1]).count do
	(
	local AlphabetStr = ""
	for n=1 to spnr_AR_CharacterCount.value do (AlphabetStr += (ddl_AR_Alphabet.items)[ddl_AR_Alphabet.selection-1+mn])
	local NewMatName = edt_AR_NewName.text + separ + AlphabetStr
	((SMArrArr[1])[mn]).name = NewMatName
	if chbtn_AR_ToLayer.checked then (layermanager.newLayerFromName NewMatName; local objctLayer = LayerManager.getlayerfromName NewMatName; for objct in OArr where (objct.material == (SMArrArr[1])[mn]) do (objctLayer.addNode objct))
	local MatObjArr = for objct in OArr where (objct.material == (SMArrArr[1])[mn]) collect objct
	if chbtn_AR_ToggleObjectCounter.checked then (ATfn_.RenameAddCounter NewMatName MatObjArr Separator:"_" CounterDigits:(spnr_AR_ObjectCounter.value)) else (MatObjArr.name = NewMatName)
	)
for an=2 to SMArrArr.count do
	(
	for mn=1 to (SMArrArr[an]).count do
		(
		local AlphabetStr = ""
		for n=1 to (spnr_AR_CharacterCount.value + an - 1) do (AlphabetStr += (ddl_AR_Alphabet.items)[mn])
		local NewMatName = edt_AR_NewName.text + separ + AlphabetStr
		((SMArrArr[an])[mn]).name = NewMatName
		if chbtn_AR_ToLayer.checked then (layermanager.newLayerFromName NewMatName; local objctLayer = LayerManager.getlayerfromName NewMatName; for objct in OArr where (objct.material == (SMArrArr[an])[mn]) do (objctLayer.addNode objct))
		local MatObjArr = for objct in OArr where (objct.material == (SMArrArr[an])[mn]) collect objct
		if chbtn_AR_ToggleObjectCounter.checked then (ATfn_.RenameAddCounter NewMatName MatObjArr Separator:"_" CounterDigits:(spnr_AR_ObjectCounter.value)) else (MatObjArr.name = NewMatName)
		)
	)
-----------------------------------------------------------------------Rename Sub Materials and Sub Maps-----------------------------------------------------------------------------
for pm in processMatArr do
(
local mainName = pm.name
--------------------------------------Get Sub Materials--------------------------------START
local allSubMats = #()
local subMats = #(pm)
for smt in subMats do
	(
-- 	join subMats ( for i = 1 to (getNumSubMtls smt) where (Mat = getSubMtl smt i) != undefined collect Mat )
	local getSub = #()
	for i = 1 to (getNumSubMtls smt) do
		(
		local Mat = copy (getSubMtl smt i)
		setSubMtl smt i Mat
		if Mat != undefined then append getSub Mat
		)
	join subMats getSub
	)
for smt in subMats do (append allsubMats smt)
--------------------------------------Get Sub Materials--------------------------------END
-- print allSubMats
--------------------------------------Get Sub Maps--------------------------------START
local allSubMaps = #()
local subMaps = #()
for asmp in allSubMats do
	(
	subMaps = #(asmp)
	for smp in subMaps do
		(
		join subMaps ( for i = 1 to (getNumSubTexmaps smp) where (Map = getSubTexmap smp i) != undefined collect Map )
-- 		local getSub = #()
-- 		for i = 1 to (getNumSubTexmaps smp) do
-- 			(
-- 			local Mat = copy (getSubTexmap smp i)
-- 			setSubTexmap smp i Mat
-- 			if Mat != undefined then append getSub Mat
-- 			)
-- 		join subMats getSub
		)
	deleteItem subMaps 1
	for smp in subMaps do (append allSubMaps smp)
	subMaps = #()
	)
--------------------------------------Get Sub Maps--------------------------------END
-- print allSubMaps
--------------------------------------Rename Sub Materials--------------------------------START
deleteItem allSubMats 1
local subMatsClasses = #()
for smt in allSubMats do (appendIfUnique subMatsClasses (classOf smt))
for mc in subMatsClasses do
	(
	local matsByClass = (for smt in allSubMats where (classOf smt == mc) collect smt)
	for n=1 to matsByClass.count do (local zer = if n<10 then "0" else ""; (matsByClass[n]).name = mainName + "_" + (fn_NormalizeName (mc as string)) + "_" + zer + (n as string) )
	)
--------------------------------------Rename Sub Materials--------------------------------END
--------------------------------------Rename Sub Maps--------------------------------START
local subMapsClasses = #()
for smp in allSubMaps do (appendIfUnique subMapsClasses (classOf smp))
for mc in subMapsClasses do
	(
	local mapsByClass = (for smp in allSubMaps where (classOf smp == mc) collect smp)
	for n=1 to mapsByClass.count do (local zer = if n<10 then "0" else ""; (mapsByClass[n]).name = mainName + "_" + (fn_NormalizeName (mc as string)) + "_" + zer + (n as string) )
	)
--------------------------------------Rename Sub Maps--------------------------------END
)
) else (fn_Warning1())
)
	-------------------------------------------------------------------------------------------------------------------
on chbtn_AR_CollectPath changed state do 
(
local CollectPath = getSavePath caption:"Select Folder" initialDir:lastUsedPath
if CollectPath != undefined
then
	(
	lastUsedPath = CollectPath
	chbtn_AR_CollectPath.caption = "...\\" + (filterString CollectPath "\\")[(filterString CollectPath "\\").count]
	chbtn_AR_CollectPath.checked = true
	btn_AR_RenameTextures.enabled = true
	setINISetting iniFile floaterTitle "LastUsedPath" CollectPath
	chbtn_AR_CollectPath.tooltip = ttp_AR_CollectPath + "\n" + CollectPath
	)
else
	(
	chbtn_AR_CollectPath.caption = "Collect Textures to..."
	btn_AR_RenameTextures.enabled = false
	chbtn_AR_CollectPath.tooltip = ttp_AR_CollectPath
	)
)
	-------------------------------------------------------------------------------------------------------------------
on btn_AR_FormatSetup pressed do
	(
	case ddl_AR_ConvertExtensions.selection of
		(
		1: ATfn_.SetupBMP()
		2: ATfn_.SetupJPEG()
		3: ATfn_.SetupJPEG()
		4: ATfn_.SetupPNG()
		5: ATfn_.SetupTGA()
		6: ATfn_.SetupTIFF()
		)
	)
	-------------------------------------------------------------------------------------------------------------------
on btn_AR_RenameTextures pressed do with undo off
(
local OArr = fn_GetObjs()
local processMatArr = fn_GetMats()
local missingTextures = #()
if processMatArr.count != 0 then
(
tmr_AR_prgrsFade.active = false; prgrs_AR_ProBar.value = 0; prgrs_AR_ProBar.color = orange

local LayersNameArr = for l=0 to (LayerManager.count-1) collect ((LayerManager.getLayer l).name)
local ObjByLayerArr = #(); for ln in LayersNameArr do (local ObjsArr = #(); (LayerManager.getLayerFromName ln).nodes &ObjsArr; append ObjByLayerArr ObjsArr)

local startTime = timeStamp()
for pm in processMatArr do
-- 	(
try (
	windows.processPostedMessages()
	local mainName = pm.name
	local newDir
	if chbtn_AR_SubFolders.checked then (newDir = lastUsedPath + "\\" + mainName + "\\"; makeDir newDir) else (newDir = lastUsedPath + "\\")
	--------------------------------------Get Sub Materials--------------------------------START
	local allSubMats = #()
	local subMats = #(pm)
	for smt in subMats do
		(
		local getSub = #()
		for i = 1 to (getNumSubMtls smt) do
			(
			local Mat = copy (getSubMtl smt i)
			setSubMtl smt i Mat
			if Mat != undefined then append getSub Mat
			)
		join subMats getSub
		)
	for smt in subMats do (append allsubMats smt)
	--------------------------------------Get Sub Materials--------------------------------END
-- 	print allSubMats
	--------------------------------------Get Sub Maps--------------------------------START
	local allSubMaps = #()
	local subMaps = #()
	for asmp in allSubMats do
		(
		subMaps = #(asmp)
		for smp in subMaps do
			(
			join subMaps ( for i = 1 to (getNumSubTexmaps smp) where (Map = getSubTexmap smp i) != undefined collect Map )
			)
		deleteItem subMaps 1
		for smp in subMaps do (appendIfUnique allSubMaps smp)
		subMaps = #()
		)
	--------------------------------------Get Sub Maps--------------------------------END
-- 	print allSubMaps
	--------------------------------------Rename and Collect Textures--------------------------------START
	local savedTextures = #()
	local allLoaders = for sm in allSubMaps where (classOf sm == VRayBitmap or classOf sm == BitmapTexture) collect sm
	local allLoadersSlotNames = #()
	for ldr in allLoaders do
		(
		local deps = #(ldr)
		local SubTexmapSlotName = ""
		local NormalBumpSlotName = ""
		do
			(
			mats = #()
			local mats = for item in refs.dependents deps[1] where isKindOf item Material collect item
			for mat in mats do
				(
				for n = 1 to (getNumSubTexmaps mat) where getSubTexmap mat n == deps[1] do
					(
					if classOf mat == Normal_Bump then NormalBumpSlotName = getSubTexmapSlotName mat n
					SubTexmapSlotName = getSubTexmapSlotName mat n
					)
				)
			deps = mats
			)
			while mats.count > 0
		if NormalBumpSlotName != "" then SubTexmapSlotName = NormalBumpSlotName
		append allLoadersSlotNames (fn_NormalizeName SubTexmapSlotName)
		)
	local allLoadersSlotNamesUnique = deepCopy allLoadersSlotNames; makeUniqueArray allLoadersSlotNamesUnique
	local allLoadersBySlot = #()
	for snu in allLoadersSlotNamesUnique do
		(
		local loadersBySlot = #()
		for sn=1 to allLoadersSlotNames.count do
			(
			if allLoadersSlotNames[sn] == snu then (append LoadersBySlot allLoaders[sn])
			)
		append allLoadersBySlot loadersBySlot
		)
	for LBS=1 to allLoadersBySlot.count do
		(
		windows.processPostedMessages()
		for n=1 to allLoadersBySlot[LBS].count do
			(
			windows.processPostedMessages()
			local oldFile = ""
			case classOf allLoadersBySlot[LBS][n] of
				(
				VRayBitmap: oldFile = allLoadersBySlot[LBS][n].HDRIMapName
				BitmapTexture: oldFile = allLoadersBySlot[LBS][n].filename
				)
			if not (doesFileExist oldFile) then (appendIfUnique missingTextures oldFile)
			local Ext = if chbtn_AR_Convert.checked then (ddl_AR_ConvertExtensions.selected) else (getFilenameType oldFile)
			local newFile
			if allLoadersBySlot[LBS].count == 1
			then
				(
				newFile = newDir + mainName + "_" + allLoadersSlotNamesUnique[LBS] + Ext
				)
			else
				(
				local zer = if n < 10 then "0" else ""
				newFile = newDir + mainName + "_" + allLoadersSlotNamesUnique[LBS] + "_" + zer + (n as string) + Ext
				)
			if chbtn_AR_Convert.checked
			then
				(
				local old_Bitmap = openBitMap oldFile; local new_Bitmap = bitmap old_Bitmap.width old_Bitmap.height
				copy old_Bitmap new_Bitmap; new_Bitmap.filename = newFile
				save new_Bitmap; close old_Bitmap; close new_Bitmap; free old_Bitmap; free new_Bitmap
				)
			else
				(
				if doesFileExist newFile
				then
					(
					local old_Bitmap = openBitMap oldFile; local new_Bitmap = bitmap old_Bitmap.width old_Bitmap.height
					copy old_Bitmap new_Bitmap; new_Bitmap.filename = newFile
					save new_Bitmap; close old_Bitmap; close new_Bitmap; free old_Bitmap; free new_Bitmap
					)
				else
					(
					copyFile oldFile newFile
					)
				)
			case classOf allLoadersBySlot[LBS][n] of
				(
				VRayBitmap: allLoadersBySlot[LBS][n].HDRIMapName = newFile
				BitmapTexture: allLoadersBySlot[LBS][n].filename = newFile
				)
			append savedTextures newFile
			)
		)
	local allSceneFilesAndPaths = #(); ATSOps.Refresh(); ATSOps.GetFiles &allSceneFilesAndPaths
	for t in savedTextures where (findItem allSceneFilesAndPaths t == 0) do (deleteFile t)
	--------------------------------------Rename and Collect Textures--------------------------------END
	if chbtn_AR_SaveModel.checked then
	(
	local DefaultLayer = LayerManager.getlayer 0; for objct in objects do DefaultLayer.addNode objct;local currentLayersNameArr = for l=0 to (LayerManager.count-1) collect ((LayerManager.getLayer l).name) ; for ln in currentLayersNameArr do (LayerManager.deleteLayerbyname ln)
	local MatObjArr = for objct in OArr where (objct.material == pm) collect objct
	if chbtn_AR_ModelToLayer.checked then (LayerManager.newLayerFromName pm.name; local ML = LayerManager.getLayerFromName pm.name; for objct in MatObjArr do ML.addNode objct)
	saveNodes MatObjArr (newDir + pm.name + ".max") quiet:true
	)
	if missingTextures.count != 0 then
		(
		actionMan.executeAction 0 "40472"
		clearlistener()
		for t in missingTextures do
			(
			format "Missing Texture:   %\n" t
			)
		)
	if (sysinfo.getSystemMemoryInfo())[1] > 90 then freeSceneBitmaps()
	prgrs_AR_ProBar.value = 100.0*(findItem processMatArr pm)/(processMatArr.count)
	) catch (print "Error")
-- 	)
if chbtn_AR_SaveModel.checked then
(
local DefaultLayer = LayerManager.getlayer 0; for objct in objects do DefaultLayer.addNode objct;local currentLayersNameArr = for l=0 to (LayerManager.count-1) collect ((LayerManager.getLayer l).name) ; for ln in currentLayersNameArr do (LayerManager.deleteLayerbyname ln)
for n=1 to LayersNameArr.count do (LayerManager.newLayerFromName LayersNameArr[n]; local RL = LayerManager.getLayerFromName LayersNameArr[n]; for objct in ObjByLayerArr[n] do RL.addNode objct)
)
format "Processing took % seconds\n" (filterString (((dotnetclass "TimeSpan").FromMilliseconds (timeStamp() - starttime)).ToString()) ".")[1]
freeSceneBitmaps(); gc light:true
prgrs_AR_ProBar.color = green; tmr_AR_prgrsFade.active = true
) else (fn_Warning1())
)
	----===============================================================================================================
on rollout_AR_ open do
	(
	if floater_AssemblyTool != undefined do try(floater_AssemblyTool.rollouts[1].chbtn_TL_AlphabetRenamer.checked = true)catch()
	)
on rollout_AR_ close do
	(
	if floater_AssemblyTool != undefined do try(floater_AssemblyTool.rollouts[1].chbtn_TL_AlphabetRenamer.checked = false)catch()
	ATfn_.SaveFloaterINI floater_AlphabetRenamer iniFile ExcludedControls
	floater_AlphabetRenamer = undefined
	)
)
	----==============================================================================================================
floater_AlphabetRenamer = ATfn_.CreateFloater floater_AlphabetRenamer iniFile fl0W fl0H floaterTitle #(rollout_AR_)
on execute do
	(
	if (hasINISetting iniFile floaterTitle) do (ATfn_.LoadFloaterINI floater_AlphabetRenamer iniFile ExcludedControls)
-- 	for r in floater_AlphabetRenamer.Rollouts do (ATfn_.chbtnRunColor r.controls ExcludePattern:"*razdel_*")
	)
)