	--^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
(if ATIcons == undefined then (fileIn ((getFilenamePath(getThisScriptFilename())) + "AssemblyToolIcons.ms")))
(if ATfn_ == undefined then (fileIn ((getFilenamePath(getThisScriptFilename())) + "AssemblyToolStruct.ms")))
	--^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
(
Global rollout_Collector
Global floater_AssemblyTool
try(if rollout_Collector.dialogBar then (cui.UnRegisterDialogBar rollout_Collector); destroyDialog rollout_Collector)catch()
	--^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
local rollTitle = "Collector"
local iniPath = (getFilenamePath (getThisScriptFilename())) + "INI\\"
local iniFile = iniPath + "Collector_Settings.ini"
local fixedW = 500; local startH = 500; local fixedH = 220
local roll0S = ATfn_.GetINI 0 iniFile rollTitle "LastSize" [fixedW,startH]; local roll0W = roll0S[1]; local roll0H = roll0S[2]
local colCHBX = ATfn_.GetINI 0 (iniPath + "AssemblyTool_Settings.ini") "Preferences" "color_PS_ChBxColor" [255,156,0]
local ExcludedControls = #("prgrs_CR_ProBar", "tmr_CR_prgrsFade", "mlbx_CR_CollectorList", "btn_CR_Paste")
	-------------------------------------------------------------------------------------------------------------------
local ATSArr = #()
local MapArr = #(); local TexArr = #()
local ProxyArr = #(); local VRMeshArr = #()
local CopyPasteStr = ""
local openedBitMap = undefined
local renameSingle_rollout; local renameSingleIndex
local lastSearchFolder = ATfn_.GetINI 1 iniFile rollTitle "lastSearchFolder" "C:\\"
	-------------------------------------------------------------------------------------------------------------------
	----===============================================================================================================
rollout rollout_Collector rollTitle
(
local yp1 = #(4, 405, 431, 457)
button btn_CR_Refresh "Refresh" pos:[4,yp1[1]] width:42 height:41 border:true tooltip:" Refresh List "
radiobuttons rdbtn_CR_SelectedOrScene "" labels:#("Selected","Scene") pos:[50,yp1[1]+1] columns:2 offsets:#([0,0],[0,0]) default:2 enabled:false tooltip:" Process Selected Objects \n Or All Scene Objects "
edittext edt_CR_NameFilter "Filter" pos:[52,yp1[1]+22] width:175 height:17 bold:true tooltip:" Filter List By Name "
local mlbx_CR_CollectorList_ttp = " DoubleClick - Opens Single Texture 
 Rmb - Selects Dependent Scene Objects \n Alt+Rmb - Selects Identical Textures \n Ctrl+Rmb - Deselect All List \n Shift+Rmb - Select/Deselect All List "
multilistbox mlbx_CR_CollectorList items:#() pos:[5,yp1[1]+45] width:(rollout_Collector.width-10) height:100 tooltip:mlbx_CR_CollectorList_ttp

button btn_CR_OpenAT "Open AT" pos:[170,yp1[1]] width:60 height:19 border:true tooltip:" Open Asset Tracking Dialog "
checkButton chbtn_CR_ATS "Asset\nTracking" pos:[235,yp1[1]+4] width:61 height:37 checked:false highlightColor:colCHBX tooltip:" View All Assets "
checkButton chbtn_CR_Objects "Objects\nMaterials" pos:[301,yp1[1]+4] width:61 height:37 checked:false highlightColor:colCHBX tooltip:" View Objects Materials In List "
checkButton chbtn_CR_MEditor "Material\nEditor" pos:[367,yp1[1]+4] width:61 height:37 checked:false highlightColor:colCHBX tooltip:" View Material Editor In List \n Rmb - Open Material Editor "
checkButton chbtn_CR_VRayProxy "VRay\nProxy" pos:[433,yp1[1]+4] width:61 height:37 checked:false highlightColor:colCHBX tooltip:" View Proxies In List "

dropdownlist ddl_CR_SetName items:#() pos:[4,379] width:20 height:33 selection:0 tooltip:" Lmb - Choose Name \n Alt+Lmb - Delete Name \n Rmb - Clear Fild \n Alt+Rmb - Save Name "
edittext edt_CR_CustomPath "" pos:[21,381] width:450 height:17 bold:false tooltip:" Collection Path "
button btn_CR_GetPath "..." pos:[473,379] width:23 height:21 tooltip:" Lmb - Set Collection Path \n Rmb - Get Scene Path As Collection Path "

button btn_CR_SelectMissing "Missing" pos:[5,yp1[2]] width:80 height:23 tooltip:" Selects Missing Files "
button btn_CR_SearchAndSet "Find" pos:[88,yp1[2]] width:80 height:23 tooltip:" Search Selected Files And Set Found "
button btn_CR_SelIncorName "Select Incorrect Names" pos:[171,yp1[2]] width:129 height:23 tooltip:" Selects Incorrect Texture Names In List "
button btn_CR_FixName "Fix Names" pos:[303,yp1[2]] width:67 height:23 tooltip:" Fix Selected Textures Names \n (Copy With Correct Name And Set)"
button btn_CR_SelectAll "Select All" pos:[373,yp1[2]] width:60 height:23 tooltip:" Lmb - Select All List Items \n Rmb - Invert List Items "
checkButton chbtn_CR_Repath "Repath" pos:[436,yp1[2]] width:60 height:23 checked:false highlightColor:colCHBX tooltip:" Repath Collected Textures "
	
button btn_CR_Remove "Remove" pos:[5,yp1[3]] width:46 height:23 tooltip:" Remove Texture Path From Source "
button btn_CR_OpenFolder "Open Folder" pos:[54,yp1[3]] width:65 height:23 tooltip:" Open Source Folder "
button btn_CR_LoadersToEditor "Loaders To Editor" pos:[122,yp1[3]] width:94 height:23 enabled:true tooltip:" Put Selected Textures Dependent Loaders \n To Material Editor "
button btn_CR_MaterialsToEditor "Materials To Editor" pos:[219,yp1[3]] width:98 height:23 enabled:true tooltip:" Put Selected Textures Dependent Materials \n To Material Editor "
button btn_CR_RenameSingle "Rename" pos:[320,yp1[3]] width:50 height:23 tooltip:" Rename Single Selected Texture "
button btn_CR_SetPath "Set Path" pos:[373,yp1[3]] width:60 height:23 tooltip:" Lmb - Set Collection Path As File Location \n Rmb - Get Selected File Path As Collection Path "

button btn_CR_Open "Open Textures" pos:[5,yp1[4]] width:83 height:23 tooltip:" Open Selected Textures "
button btn_CR_SelectObjects "Select Objects" pos:[91,yp1[4]] width:80 height:23 tooltip:" Selects Texture Dependent Objects In Scene "
button btn_CR_Copy "Copy" pos:[174,yp1[4]] width:35 height:23 tooltip:" Copy Texture Path From Source "
button btn_CR_Paste "Paste" pos:[212,yp1[4]] width:35 height:23 enabled:false tooltip:" Paste Texture Path Into Source "
button btn_CR_SelIdentical "Select Identical Names" pos:[250,yp1[4]] width:120 height:23 tooltip:" Selects Textures With \n Identical Name And Extension "
button btn_CR_StripPath "Strip Path" pos:[373,yp1[4]] width:60 height:23 tooltip:" Strip Selected In List Paths "

button btn_CR_Collect "Collect" pos:[436,yp1[3]] width:60 height:49

progressBar prgrs_CR_ProBar pos:[7,roll0H-15] width:(fixedW-13) height:10 value:0 color:orange
timer tmr_CR_prgrsFade interval:((3*1000/68) as integer) active:false
on tmr_CR_prgrsFade tick do (ATfn_.ProgBarFade prgrs_CR_ProBar tmr_CR_prgrsFade)
	-------------------------------------------------------------------------------------------------------------------
local shCntrlsPosY = #()
local shCntrls = #(ddl_CR_SetName, edt_CR_CustomPath, btn_CR_GetPath, btn_CR_SetPath, btn_CR_SelectObjects, chbtn_CR_Repath, \
	btn_CR_SelectMissing, btn_CR_SearchAndSet, btn_CR_StripPath, btn_CR_Remove, btn_CR_FixName, btn_CR_SelectAll, btn_CR_SelIncorName, \
	btn_CR_LoadersToEditor, btn_CR_MaterialsToEditor, btn_CR_OpenFolder, btn_CR_Copy, btn_CR_Paste, btn_CR_Collect, btn_CR_SelIdentical, \
	btn_CR_RenameSingle, btn_CR_Open, prgrs_CR_ProBar)
	-----fn------------------------------------------------------------------------------------------------------------
FN fn_GetProxyVRMesh objsArr AlphabetSort: =
(
if AlphabetSort == unsupplied do AlphabetSort = true
local mixArr = #()
for objct in objsArr where (classOf objct == VRayProxy) do (append mixArr #(objct, objct.FileName))
local ProxyArr = #(); local VRMeshArr = #()
	FN fn_compareBy a b = stricmp a[2] b[2]
if AlphabetSort do (qSort mixArr fn_compareBy)
for s in mixArr do (append ProxyArr s[1]; append VRMeshArr s[2])
return #(ProxyArr, VRMeshArr)
)
	-----fn------------------------------------------------------------------------------------------------------------
FN fn_getData_CR =
(
-- 	clearListener()
mlbx_CR_CollectorList.items = #()
if chbtn_CR_ATS.checked do
	(
	ATSOps.Refresh()
	ATSOps.GetFiles &ATSArr
	for n in ATSArr.count to 1 by -1 where (ATSArr[n] == maxFilePath + maxFileName) do (deleteItem ATSArr n)
	for n in ATSArr.count to 1 by -1 where (ATSOps.IsInputFile ATSArr[n] == false) do (deleteItem ATSArr n)
	ATSArr = for f in ATSArr where (matchPattern (getFilenameFile f) pattern:("*" + edt_CR_NameFilter.text + "*")) == true collect f
	mlbx_CR_CollectorList.items = ATSArr
	)
if chbtn_CR_Objects.checked or chbtn_CR_MEditor.checked  do
	(
	local MapsMatsArr = #()
	if chbtn_CR_Objects.checked
	then (for o in (if rdbtn_CR_SelectedOrScene.state==1 then selection else objects) where o.material != undefined do (appendIfUnique MapsMatsArr o.material))
-- 	then (for o in (if rdbtn_CR_SelectedOrScene.state==1 then selection else objects) where o.material != undefined do (append MapsMatsArr o.material))
	else (MapsMatsArr = for m in meditMaterials collect m)
	local MapTexArr = ATfn_.GetMapsTextures MapsMatsArr FilterName:(edt_CR_NameFilter.text) Corona:true
	MapArr = MapTexArr[1]; TexArr = MapTexArr[2]
	local InfoArr = #()
	for n=1 to TexArr.count do
		(
		case classOf MapArr[n] of
			(
			Bitmaptexture: (append InfoArr ("Bitmap --  " + TexArr[n]))
			VRayBitmap: (append InfoArr ("V-Ray  --  " + TexArr[n]))
			CoronaBitmap: (append InfoArr ("Corona --  " + TexArr[n]))
			)
		)
	mlbx_CR_CollectorList.items = InfoArr
	)
if chbtn_CR_VRayProxy.checked do
	(
	local ProxyVRMeshArr = fn_GetProxyVRMesh (if rdbtn_CR_SelectedOrScene.state==1 then selection else objects)
	ProxyArr = #(); VRMeshArr = #()
	local namesArr = for item in ProxyVRMeshArr[2] collect getFilenameFile item
	for n=1 to namesArr.count where (matchPattern namesArr[n] pattern:("*" + edt_CR_NameFilter.text + "*")) == true do
		(append ProxyArr ProxyVRMeshArr[1][n]; append VRMeshArr ProxyVRMeshArr[2][n])
	mlbx_CR_CollectorList.items = VRMeshArr
	)
mlbx_CR_CollectorList.selection = #{}
setFocus mlbx_CR_CollectorList
)
	-----fn------------------------------------------------------------------------------------------------------------
fn fn_SearchFiles folder fileNamesArr =
(
windows.processPostedMessages()
local dirsArr = #((folder + "\\"))
-- append dirsArr (GetDirectories (folder + "\*"))
for dir in dirsArr do (join dirsArr (GetDirectories (dir + "\*")))
-- sort dirsArr
local filesArr = #()
tmr_CR_prgrsFade.active = false; prgrs_CR_ProBar.value = 0; prgrs_CR_ProBar.color = orange
for f in fileNamesArr do
	(
	windows.processPostedMessages()
	local newPath = undefined
	for dir in dirsArr do (if doesFileExist (dir + f) do newPath = dir + f)
	append filesArr newPath
	prgrs_CR_ProBar.value = 100.0*((findItem fileNamesArr f)+1)/(fileNamesArr.count)
	)
prgrs_CR_ProBar.color = green; tmr_CR_prgrsFade.active = true
return filesArr
)
	-----fn------------------------------------------------------------------------------------------------------------
	/*
FN fn_SetFilenameByInputClass Input Filename =
(
case classOf Input of
	(
	Bitmaptexture: (Input.FileName = Filename)
	VRayBitmap: (Input.HDRIMapName = Filename)
	CoronaBitmap: (Input.FileName = Filename)
	VRayProxy: (Input.FileName = Filename)
	)
)
	-- */
FN fn_SetFilenameByInputClass Input Filename =
(
local Count = 0; local StopCount = 100
if classOf Input == Bitmaptexture or \
	classOf Input == CoronaBitmap or \
	classOf Input == VRayProxy do \
(while (Input.FileName != Filename and Count < StopCount) do (Count += 1; Input.FileName = Filename))
if classOf Input == VRayBitmap do \
(while (Input.HDRIMapName != Filename and Count < StopCount) do (Count += 1; Input.HDRIMapName = Filename))
)
	-----fn------------------------------------------------------------------------------------------------------------
FN fn_MSG_SelectItems = (messageBox "Select Items In List." title:" Collector" beep:false)
	-----fn------------------------------------------------------------------------------------------------------------
FN fn_MSG_SelectOneItem = (messageBox "Select One Item In List." title:" Collector" beep:false)
	-----fn------------------------------------------------------------------------------------------------------------
FN fn_MSG_FilenameExists = (messageBox "New Filename Already Exists." title:" Collector" beep:false)
	-----fn------------------------------------------------------------------------------------------------------------
FN fn_MSG_PathsNotExists = (messageBox "One Or More Texture Paths Are Missing." title:" Renamer" beep:false)
	-----fn------------------------------------------------------------------------------------------------------------
FN fn_SelectAllList =
(
local listCount = mlbx_CR_CollectorList.items.count
mlbx_CR_CollectorList.selection = #{1..listCount}
if chbtn_CR_ATS.checked do (ATSOps.ClearSelection(); ATSOps.SelectFiles ATSArr)
)
	-----fn------------------------------------------------------------------------------------------------------------
FN fn_SelectIdentical =
(
local indexIdentArr = #()
local itemsArr = #()
if chbtn_CR_ATS.checked do itemsArr = deepCopy ATSArr
if chbtn_CR_Objects.checked or chbtn_CR_MEditor.checked do itemsArr = deepCopy TexArr
if chbtn_CR_VRayProxy.checked do itemsArr = deepCopy VRMeshArr
local namesArr = for n=1 to (mlbx_CR_CollectorList.items.count) collect (filenameFromPath itemsArr[n])
for nm in namesArr do
	(
	local items = ATfn_.FindAllItems namesArr nm
	if items.count > 1 do join indexIdentArr items
	)
indexIdentArr = makeUniqueArray indexIdentArr
if chbtn_CR_ATS.checked do (ATSOps.ClearSelection(); ATSOps.SelectFiles (for i in indexIdentArr collect ATSArr[i]))
mlbx_CR_CollectorList.selection = indexIdentArr as BitArray
)
	-----fn------------------------------------------------------------------------------------------------------------
FN fn_SelectDependentObjects =
(
clearSelection()
local indexArr = mlbx_CR_CollectorList.selection as array
if indexArr.count == 0 do (return fn_MSG_SelectItems())
local SelArr = #()
if chbtn_CR_ATS.checked do ()
if chbtn_CR_Objects.checked or chbtn_CR_MEditor.checked do
	(
	for i in indexArr do (join SelArr (refs.dependentNodes MapArr[i]))
	)
if chbtn_CR_VRayProxy.checked do
	(
	for s in indexArr do (append SelArr ProxyArr[s])
	)
ATfn_.SelectInGroups SelArr
redrawViews()
)
	-----fn------------------------------------------------------------------------------------------------------------
FN fn_RestoreListSelection newListSel =
(
local newIndexArr = #()
for i in newListSel do
	(
	if chbtn_CR_ATS.checked do (join newIndexArr (ATfn_.FindAllItems ATSArr i))
	if chbtn_CR_Objects.checked or chbtn_CR_MEditor.checked do (join newIndexArr (ATfn_.FindAllItems MapArr i))
	if chbtn_CR_VRayProxy.checked do (join newIndexArr (ATfn_.FindAllItems VRMeshArr i))
	)
mlbx_CR_CollectorList.selection = newIndexArr as BitArray
)
	-----fn------------------------------------------------------------------------------------------------------------
FN fn_CopyReplaceOneFile_rollout =
(
renameSingleIndex = (mlbx_CR_CollectorList.selection as array)[1]
local checkPath = ""
if chbtn_CR_ATS.checked do checkPath = ATSArr[renameSingleIndex]
if chbtn_CR_Objects.checked or chbtn_CR_MEditor.checked do checkPath = TexArr[renameSingleIndex]
if chbtn_CR_VRayProxy.checked do checkPath = VRMeshArr[renameSingleIndex]
if not doesFileExist (ATfn_.CheckStripGetPath checkPath) do return fn_MSG_PathsNotExists()
rollout renameSingle_rollout "Rename"
(
edittext btn_Name text:"" pos:[4,4] width:192 height:17 bold:false
radiobuttons rdbtn_CopyOrReplace "" labels:#("Copy","Replace") pos:[7,28] columns:2 offsets:#([0,0],[-6,0]) default:1 tooltip:" Copy Or Replace Renaming Texture "
button btn_Rename "Rename" pos:[122,23] width:74 height:25
	-----fn------------
FN fn_CopyReplaceOneFile copyState: =
	(
	local newListSel = #()
	if chbtn_CR_ATS.checked do
		(
		local oldFile = ATfn_.CheckStripGetPath ATSArr[renameSingleIndex]
		local newFile = ATfn_.CheckStripGetPath ((getFilenamePath ATSArr[renameSingleIndex]) + (btn_Name.text) + (getFilenameType ATSArr[renameSingleIndex]))
		if doesFileExist newFile do (return fn_MSG_FilenameExists())
		ATSOps.ClearSelection()
		ATSOps.SelectFiles oldFile
		if copyState then copyFile oldFile newFile else renameFile oldFile newFile
		if (filterString ATSArr[renameSingleIndex] "\\").count == 1 do newFile = filenameFromPath newFile
		ATSOps.RetargetSelection newFile
		append newListSel newFile
		local oldMaxFile = (getFilenamePath oldFile) + (getFilenameFile oldFile) + ".max"
		local newMaxFile = (getFilenamePath oldFile) + (btn_Name.text) + ".max"
-- 		if doesFileExist newMaxFile do (return fn_MSG_FilenameExists())
		if doesFileExist oldMaxFile do (if copyState then copyFile oldMaxFile newMaxFile else renameFile oldMaxFile newMaxFile)
		)
	if chbtn_CR_Objects.checked or chbtn_CR_MEditor.checked do
		(
		local oldFile = ATfn_.CheckStripGetPath TexArr[renameSingleIndex]
		local newFile = ATfn_.CheckStripGetPath ((getFilenamePath TexArr[renameSingleIndex]) + (btn_Name.text) + (getFilenameType TexArr[renameSingleIndex]))
		if doesFileExist newFile do (return fn_MSG_FilenameExists())
		if copyState then copyFile oldFile newFile else renameFile oldFile newFile
		if (filterString TexArr[renameSingleIndex] "\\").count == 1 do newFile = filenameFromPath newFile
		append newListSel MapArr[renameSingleIndex]
		fn_SetFilenameByInputClass MapArr[renameSingleIndex] newFile
		)
	if chbtn_CR_VRayProxy.checked do 
		(
		local oldFile = ATfn_.CheckStripGetPath VRMeshArr[renameSingleIndex]
		local newFile = ATfn_.CheckStripGetPath ((getFilenamePath VRMeshArr[renameSingleIndex]) + (btn_Name.text) + (getFilenameType VRMeshArr[renameSingleIndex]))
		if doesFileExist newFile do (return fn_MSG_FilenameExists())
		if copyState then copyFile oldFile newFile else renameFile oldFile newFile
		if (filterString VRMeshArr[renameSingleIndex] "\\").count == 1 do newFile = filenameFromPath newFile
		append newListSel newFile
		fn_SetFilenameByInputClass ProxyArr[renameSingleIndex] newFile
		local oldMaxFile = (getFilenamePath oldFile) + (getFilenameFile oldFile) + ".max"
		local newMaxFile = (getFilenamePath oldFile) + (btn_Name.text) + ".max"
		if doesFileExist oldMaxFile do (if copyState then copyFile oldMaxFile newMaxFile else renameFile oldMaxFile newMaxFile)
		)
	fn_getData_CR()
	fn_RestoreListSelection newListSel
	Destroydialog renameSingle_rollout
	)
	-----fn------------
on btn_Rename pressed do with undo on
(
fn_CopyReplaceOneFile copyState:(rdbtn_CopyOrReplace.state == 1)
)
on renameSingle_rollout open do
	(
	if chbtn_CR_ATS.checked do btn_Name.text = getFilenameFile ATSArr[renameSingleIndex]
	if chbtn_CR_Objects.checked or chbtn_CR_MEditor.checked do btn_Name.text = getFilenameFile TexArr[renameSingleIndex]
	if chbtn_CR_VRayProxy.checked do btn_Name.text = getFilenameFile VRMeshArr[renameSingleIndex]
	)
)
createDialog renameSingle_rollout 200 50 pos:[mouse.screenpos.X-100, mouse.screenpos.Y-30] style:#(#style_titlebar, #style_toolwindow, #style_sysmenu)
setFocus renameSingle_rollout.btn_Name
)
	-----fn------------------------------------------------------------------------------------------------------------
	--^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
on btn_CR_Collect pressed do with undo on
(
-- 	clearListener()
local indexArr = mlbx_CR_CollectorList.selection as array
local dig = 2
local newListSel = #()
if indexArr.count == 0 do (return fn_MSG_SelectItems())
tmr_CR_prgrsFade.active = false; prgrs_CR_ProBar.value = 0; prgrs_CR_ProBar.color = orange
local newPath = (trimRight edt_CR_CustomPath.text "\\") + (if edt_CR_CustomPath.text != "" then "\\" else "")
if newPath == "" do (return (messageBox "Invalid Collection Path." title:" Collector" beep:false))
local oldFile = ""; local targFile = ""
if chbtn_CR_ATS.checked do
	(
	for i in indexArr do 
		(
		oldFile = ATSArr[i]; targFile = newPath + (filenameFromPath oldFile)
		makeDir newPath
		if chbtn_CR_Repath.checked do
			(
			if doesFileExist targFile and getFileSize oldFile != getFileSize targFile do
				(targFile = ATfn_.FoundNewFilename targFile oldFile CounterDigits:dig)
			)
		copyFile oldFile targFile
		local maxFile = (getFilenamePath oldFile) + (getFilenameFile oldFile) + ".max"
		if doesFileExist maxFile do copyFile maxFile (newPath + (getFilenameFile oldFile) + ".max")
		append newListSel targFile
		if chbtn_CR_Repath.checked do
			(
			ATSOps.ClearSelection(); ATSOps.SelectFiles oldFile
			ATSOps.RetargetSelection targFile
			)
		prgrs_CR_ProBar.value = 100.0*i/(indexArr.count)
		)
	)
if chbtn_CR_Objects.checked or chbtn_CR_MEditor.checked do
	(
	for i in indexArr do 
		(
		oldFile = TexArr[i]; targFile = newPath + (filenameFromPath oldFile)
		makeDir newPath
		if chbtn_CR_Repath.checked do
			(
			if doesFileExist targFile and getFileSize oldFile != getFileSize targFile do
				(targFile = ATfn_.FoundNewFilename targFile oldFile CounterDigits:dig)
			)
		copyFile oldFile targFile
		if chbtn_CR_Repath.checked do
			(
			fn_SetFilenameByInputClass MapArr[i] targFile
			)
		append newListSel MapArr[i]
		prgrs_CR_ProBar.value = 100.0*i/(indexArr.count)
		)
	)
if chbtn_CR_VRayProxy.checked do
	(
	for i in indexArr do
		(
		oldFile = VRMeshArr[i]; targFile = newPath + (filenameFromPath oldFile)
		makeDir newPath
		if chbtn_CR_Repath.checked do
			(
			if doesFileExist targFile and getFileSize oldFile != getFileSize targFile do
				(targFile = ATfn_.FoundNewFilename targFile oldFile CounterDigits:dig)
			)
		copyFile oldFile targFile
		local maxFile = (getFilenamePath oldFile) + (getFilenameFile oldFile) + ".max"
		if doesFileExist maxFile do copyFile maxFile (newPath + (getFilenameFile oldFile) + ".max")
		if chbtn_CR_Repath.checked do
			(
			fn_SetFilenameByInputClass ProxyArr[i] targFile
			)
		append newListSel targFile
		prgrs_CR_ProBar.value = 100.0*i/(indexArr.count)
		)
	)
prgrs_CR_ProBar.color = green; tmr_CR_prgrsFade.active = true
fn_getData_CR()
fn_RestoreListSelection newListSel
-- if chbtn_CR_ATS.checked or chbtn_CR_Objects.checked or chbtn_CR_MEditor.checked do (ATfn_.UpdateSceneMaterials())
completeRedraw()
)
	-------------------------------------------------------------------------------------------------------------------
on btn_CR_Open pressed do with undo off
(
local indexArr = mlbx_CR_CollectorList.selection as array
if indexArr.count == 0 do return (fn_MSG_SelectItems())
for i in indexArr do
	(
	local Item
	if chbtn_CR_ATS.checked do Item = ATSArr[i]
	if chbtn_CR_Objects.checked or chbtn_CR_MEditor.checked do Item = TexArr[i]
	if chbtn_CR_VRayProxy.checked do Item = VRMeshArr[i]
	openedBitMap = openBitMap Item
	if openedBitMap != undefined do (display openedBitMap caption:Item)
	)
)
	-------------------------------------------------------------------------------------------------------------------
on btn_CR_RenameSingle pressed do with undo on
(
if (mlbx_CR_CollectorList.selection as array).count != 1 do return (fn_MSG_SelectOneItem())
fn_CopyReplaceOneFile_rollout()
)
	-------------------------------------------------------------------------------------------------------------------
on btn_CR_SelIdentical pressed do with undo off (fn_SelectIdentical())
	-------------------------------------------------------------------------------------------------------------------
on btn_CR_SelectAll pressed do with undo off (fn_SelectAllList())
	-------------------------------------------------------------------------------------------------------------------
on btn_CR_SelectAll rightclick do with undo off
(
local listCount = mlbx_CR_CollectorList.items.count
local indexArr = mlbx_CR_CollectorList.selection as array
local indexInvArr = for n=1 to listCount where (findItem indexArr n == 0) collect n
if chbtn_CR_ATS.checked do
	(
	local invArr = for i in indexInvArr collect ATSArr[i]
	ATSOps.ClearSelection()
	ATSOps.SelectFiles invArr
	)
mlbx_CR_CollectorList.selection = indexInvArr as BitArray
)
	-------------------------------------------------------------------------------------------------------------------
on btn_CR_SelectObjects pressed do with undo on (fn_SelectDependentObjects())
	-------------------------------------------------------------------------------------------------------------------
on btn_CR_Paste pressed do with undo on
(
if CopyPasteStr == "" do return false
local indexArr = mlbx_CR_CollectorList.selection as array
if indexArr.count == 0 do return (fn_MSG_SelectItems())
local newListSel = #()
if chbtn_CR_ATS.checked do
	(
	for i in indexArr do
		(
		ATSOps.ClearSelection()
		ATSOps.SelectFiles ATSArr[i]
		ATSOps.RetargetSelection CopyPasteStr
		append newListSel CopyPasteStr
		)
	)
if chbtn_CR_Objects.checked or chbtn_CR_MEditor.checked do (for i in indexArr do (append newListSel MapArr[i]; fn_SetFilenameByInputClass MapArr[i] CopyPasteStr))
if chbtn_CR_VRayProxy.checked do (for i in indexArr do (append newListSel CopyPasteStr; fn_SetFilenameByInputClass ProxyArr[i] CopyPasteStr))
CopyPasteStr = ""
btn_CR_Paste.enabled = false
fn_getData_CR()
fn_RestoreListSelection newListSel
-- if chbtn_CR_ATS.checked or chbtn_CR_Objects.checked or chbtn_CR_MEditor.checked do (ATfn_.UpdateSceneMaterials())
)
	-------------------------------------------------------------------------------------------------------------------
on btn_CR_Copy pressed do with undo on
(
local indexArr = mlbx_CR_CollectorList.selection as array
if indexArr.count != 1 do return (fn_MSG_SelectOneItem())
local index = indexArr[1]
if chbtn_CR_ATS.checked do (CopyPasteStr = ATSArr[index])
if chbtn_CR_Objects.checked or chbtn_CR_MEditor.checked do (CopyPasteStr = TexArr[index])
if chbtn_CR_VRayProxy.checked do (CopyPasteStr = VRMeshArr[index])
setClipboardText CopyPasteStr
btn_CR_Paste.enabled = true
)
	-------------------------------------------------------------------------------------------------------------------
on btn_CR_FixName pressed do with undo on
(
local indexArr = mlbx_CR_CollectorList.selection as array
if indexArr.count == 0 do (return fn_MSG_SelectItems())
local dig = 2
local newListSel = #()
local missingSel = #()
local namesArr = #()
if chbtn_CR_ATS.checked do (for i in indexArr do append namesArr (getFilenameFile ATSArr[i]))
if chbtn_CR_Objects.checked or chbtn_CR_MEditor.checked do (for i in indexArr do append namesArr (getFilenameFile TexArr[i]))
if chbtn_CR_VRayProxy.checked do (for i in indexArr do append namesArr (getFilenameFile VRMeshArr[i]))
for n=1 to namesArr.count do
	(
	local fixedName = ATfn_.fixName namesArr[n]
	if fixedName != namesArr[n] do
		(
		local index = indexArr[n]
		if chbtn_CR_ATS.checked do
			(
			local oldFile = ATfn_.CheckStripGetPath ATSArr[index]
			local newFile = ATfn_.CheckStripGetPath ((getFilenamePath ATSArr[index]) + fixedName + (getFilenameType ATSArr[index]))
			if doesFileExist oldFile
			then
				(
				if doesFileExist newFile and getFileSize oldFile != getFileSize newFile do
					(newFile = ATfn_.FoundNewFilename newFile oldFile CounterDigits:dig)
				copyFile oldFile newFile
				if (filterString ATSArr[index] "\\").count == 1 do newFile = filenameFromPath newFile
				ATSOps.ClearSelection()
				ATSOps.SelectFiles #(oldFile)
				ATSOps.RetargetSelection newFile
				append newListSel newFile
				)
			else (append missingSel ATSArr[index])
			)
		if chbtn_CR_Objects.checked or chbtn_CR_MEditor.checked do
			(
			local oldFile = ATfn_.CheckStripGetPath TexArr[index]
			local newFile = ATfn_.CheckStripGetPath ((getFilenamePath TexArr[index]) + fixedName + (getFilenameType TexArr[index]))
			if doesFileExist oldFile
			then
				(
				if doesFileExist newFile and getFileSize oldFile != getFileSize newFile do
					(newFile = ATfn_.FoundNewFilename newFile oldFile CounterDigits:dig)
				copyFile oldFile newFile
				if (filterString TexArr[index] "\\").count == 1 do newFile = filenameFromPath newFile
				fn_SetFilenameByInputClass MapArr[index] newFile
				append newListSel MapArr[index]
				)
			else (append missingSel MapArr[index])
			)
		if chbtn_CR_VRayProxy.checked do
			(
			local oldFile = ATfn_.CheckStripGetPath VRMeshArr[index]
			local newFile = ATfn_.CheckStripGetPath ((getFilenamePath VRMeshArr[index]) + fixedName + (getFilenameType VRMeshArr[index]))
			if doesFileExist oldFile
			then
				(
				if doesFileExist newFile and getFileSize oldFile != getFileSize newFile do
					(newFile = ATfn_.FoundNewFilename newFile oldFile CounterDigits:dig)
				copyFile oldFile newFile
				if (filterString VRMeshArr[index] "\\").count == 1 do newFile = filenameFromPath newFile
				fn_SetFilenameByInputClass ProxyArr[index] newFile
				append newListSel newFile
				)
			else (append missingSel VRMeshArr[index])
			)
		)
	)
fn_getData_CR()
if missingSel.count == 0
then (fn_RestoreListSelection newListSel)
else
	(
	fn_RestoreListSelection missingSel
	fn_MSG_PathsNotExists()
	)
-- if chbtn_CR_ATS.checked or chbtn_CR_Objects.checked or chbtn_CR_MEditor.checked do (ATfn_.UpdateSceneMaterials())
)
	-------------------------------------------------------------------------------------------------------------------
on btn_CR_SelIncorName pressed do with undo off
(
local fixIndexArr = #()
local namesArr = #()
if chbtn_CR_ATS.checked do (for i in ATSArr do append namesArr (getFilenameFile i))
if chbtn_CR_Objects.checked or chbtn_CR_MEditor.checked do (for i in TexArr do append namesArr (getFilenameFile i))
if chbtn_CR_VRayProxy.checked do (for i in VRMeshArr do append namesArr (getFilenameFile i))
local selATSArr = #()
for n=1 to namesArr.count where (ATfn_.fixName namesArr[n]) != namesArr[n] do
		(append fixIndexArr n; if chbtn_CR_ATS.checked do (append selATSArr ATSArr[n]))
if chbtn_CR_ATS.checked do (ATSOps.ClearSelection(); ATSOps.SelectFiles selATSArr)
mlbx_CR_CollectorList.selection = fixIndexArr as bitarray
)
	-------------------------------------------------------------------------------------------------------------------
on btn_CR_Remove pressed do with undo on
(
local indexArr = mlbx_CR_CollectorList.selection as array
if indexArr.count == 0 do (return fn_MSG_SelectItems())
if queryBox "Delete Selected Items From Source?" title:" Collector" beep:false
then
	(
	if chbtn_CR_ATS.checked do
		(for i in indexArr do (ATSOps.ClearSelection(); ATSOps.SelectFiles #(ATSArr[i]); ATSOps.RetargetSelection ""))
	if chbtn_CR_Objects.checked or chbtn_CR_MEditor.checked do
		(for i in indexArr do (fn_SetFilenameByInputClass MapArr[i] ""))
	if chbtn_CR_VRayProxy.checked do
		(for i in indexArr do (fn_SetFilenameByInputClass ProxyArr[i] ""))
	fn_getData_CR()
	)
)
	-------------------------------------------------------------------------------------------------------------------
on btn_CR_SetPath pressed do with undo on
(
local indexArr = mlbx_CR_CollectorList.selection as array
if indexArr.count == 0 do (return fn_MSG_SelectItems())
local newListSel = #()
local newPath = (trimRight edt_CR_CustomPath.text "\\") + (if edt_CR_CustomPath.text != "" then "\\" else "")
if chbtn_CR_ATS.checked do
	(
	for i in indexArr do (append newListSel (newPath + (filenameFromPath ATSArr[i])))
	ATSOps.SetPathOnSelection newPath
	)
if chbtn_CR_Objects.checked or chbtn_CR_MEditor.checked do
	(
	for i in indexArr do
		(
		fn_SetFilenameByInputClass MapArr[i] (newPath + (filenameFromPath TexArr[i]))
		append newListSel MapArr[i]
		)
	)
if chbtn_CR_VRayProxy.checked do
	(for i in indexArr do (fn_SetFilenameByInputClass ProxyArr[i] (newPath + (filenameFromPath VRMeshArr[i])); append newListSel (newPath + (filenameFromPath VRMeshArr[i]))))
fn_getData_CR()
fn_RestoreListSelection newListSel
-- if chbtn_CR_ATS.checked or chbtn_CR_Objects.checked or chbtn_CR_MEditor.checked do (ATfn_.UpdateSceneMaterials())
)
	-------------------------------------------------------------------------------------------------------------------
on btn_CR_SetPath rightclick do with undo off
(
local indexArr = mlbx_CR_CollectorList.selection as array
if indexArr.count != 1 do (return fn_MSG_SelectOneItem())
local filePath = ""
if chbtn_CR_ATS.checked do filePath = ATSArr[indexArr[1]]
if chbtn_CR_Objects.checked or chbtn_CR_MEditor.checked do filePath = TexArr[indexArr[1]]
if chbtn_CR_VRayProxy.checked do filePath = VRMeshArr[indexArr[1]]
edt_CR_CustomPath.text = trimRight (getFilenamePath filePath) "\\"
)
	-------------------------------------------------------------------------------------------------------------------
on btn_CR_StripPath pressed do with undo on
(
local indexArr = mlbx_CR_CollectorList.selection as array
if indexArr.count == 0 do (return fn_MSG_SelectItems())
local newListSel = #()
if chbtn_CR_ATS.checked do
	(
	for i in indexArr do (append newListSel (filenameFromPath ATSArr[i]))
	ATSOps.SetPathOnSelection ""
	)
if chbtn_CR_Objects.checked or chbtn_CR_MEditor.checked do
	(
	for i in indexArr do
		(
		fn_SetFilenameByInputClass MapArr[i] (filenameFromPath TexArr[i])
		append newListSel MapArr[i]
		)
	)
if chbtn_CR_VRayProxy.checked do
	(for i in indexArr do (fn_SetFilenameByInputClass ProxyArr[i] (filenameFromPath VRMeshArr[i]); append newListSel (filenameFromPath VRMeshArr[i])))
fn_getData_CR()
fn_RestoreListSelection newListSel
-- if chbtn_CR_ATS.checked or chbtn_CR_Objects.checked or chbtn_CR_MEditor.checked do (ATfn_.UpdateSceneMaterials())
)
	-------------------------------------------------------------------------------------------------------------------
on btn_CR_OpenFolder pressed do
(
local indexArr = mlbx_CR_CollectorList.selection as array
if indexArr.count == 0 do (return fn_MSG_SelectItems())
local index = indexArr[1]
local file
if chbtn_CR_ATS.checked do file = ATSArr[index]
if chbtn_CR_Objects.checked or chbtn_CR_MEditor.checked do file = TexArr[index]
if chbtn_CR_VRayProxy.checked do file = VRMeshArr[index]
if doesFileExist file
then ShellLaunch "explorer.exe" ("/e,/select,\"" + file + "\\\"")
else ShellLaunch "explorer.exe" (getFilenamePath file)
)
	-------------------------------------------------------------------------------------------------------------------
local chbtnMode = #(chbtn_CR_ATS, chbtn_CR_Objects, chbtn_CR_MEditor, chbtn_CR_VRayProxy)
local cntrlOLM = #(btn_CR_SelectObjects, btn_CR_LoadersToEditor, btn_CR_MaterialsToEditor)
local cntrlLM = #(btn_CR_LoadersToEditor, btn_CR_MaterialsToEditor)
	-------------------------------------------------------------------------------------------------------------------
on btn_CR_OpenAT pressed do (ATSOps.Visible = not ATSOps.Visible)
	-------------------------------------------------------------------------------------------------------------------
on chbtn_CR_ATS changed state do
(
chbtnMode.checked = false
chbtn_CR_ATS.checked = true
cntrlOLM.enabled = false
rdbtn_CR_SelectedOrScene.enabled = false
fn_getData_CR()
)
on chbtn_CR_ATS rightclick do (ATSOps.Visible = not ATSOps.Visible)
	-------------------------------------------------------------------------------------------------------------------
on chbtn_CR_Objects changed state do
(
chbtnMode.checked = false
chbtn_CR_Objects.checked = true
cntrlOLM.enabled = true
rdbtn_CR_SelectedOrScene.enabled = true
fn_getData_CR()
)
	-------------------------------------------------------------------------------------------------------------------
on chbtn_CR_MEditor changed state do
(
chbtnMode.checked = false
chbtn_CR_MEditor.checked = true
cntrlLM.enabled = false; btn_CR_SelectObjects.enabled = true
rdbtn_CR_SelectedOrScene.enabled = false
fn_getData_CR()
)
on chbtn_CR_MEditor rightclick do (if MatEditor.isOpen() then MatEditor.Close() else MatEditor.Open())
	-------------------------------------------------------------------------------------------------------------------
on chbtn_CR_VRayProxy changed state do
(
chbtnMode.checked = false
chbtn_CR_VRayProxy.checked = true
cntrlLM.enabled = false; btn_CR_SelectObjects.enabled = true
rdbtn_CR_SelectedOrScene.enabled = true
fn_getData_CR()
)
	-------------------------------------------------------------------------------------------------------------------
on edt_CR_NameFilter changed txt do (fn_getData_CR(); setFocus edt_CR_NameFilter)
	-------------------------------------------------------------------------------------------------------------------
on btn_CR_SearchAndSet pressed do with undo on
(
local indexArr = mlbx_CR_CollectorList.selection as array
if indexArr.count == 0 do (return fn_MSG_SelectItems())
local SearchFolder = getSavePath caption:"Search Folder" initialDir:lastSearchFolder
if SearchFolder != undefined do
	(
	local notFoundIndexs = #{}
	local notFoundItems = #()
	local fileNamesArr = #()
	if chbtn_CR_ATS.checked do fileNamesArr = for i in indexArr collect (filenameFromPath ATSArr[i])
	if chbtn_CR_Objects.checked or chbtn_CR_MEditor.checked do fileNamesArr = for i in indexArr collect (filenameFromPath TexArr[i])
	if chbtn_CR_VRayProxy.checked do fileNamesArr = for i in indexArr collect (filenameFromPath VRMeshArr[i])
	local SearchArr = fn_SearchFiles SearchFolder fileNamesArr
	for n=1 to SearchArr.count do
		(
		local searchFile = SearchArr[n]
		local searchItem = ""
		if chbtn_CR_ATS.checked do searchItem = ATSArr[indexArr[n]]
		if chbtn_CR_Objects.checked or chbtn_CR_MEditor.checked do searchItem = MapArr[indexArr[n]]
		if chbtn_CR_VRayProxy.checked do searchItem = ProxyArr[indexArr[n]]
		if searchFile != undefined
		then 
			(
			if chbtn_CR_ATS.checked do
				(
					/*
				ATSOps.ClearSelection()
				ATSOps.SelectFiles #(searchItem)
				ATSOps.RetargetSelection searchFile
					-- */
					/*
				ATSOps.ClearSelection()
				ATSOps.SelectFiles #(searchItem)
				ATSOps.SetPathOnSelection (getFilenamePath searchFile)
					-- */
				for n=1 to 2 do 
					(
					ATSOps.ClearSelection()
					ATSOps.SelectFiles #(searchItem)
					ATSOps.SetPathOnSelection (getFilenamePath searchFile)
					)
				)
			if chbtn_CR_Objects.checked or chbtn_CR_MEditor.checked do (fn_SetFilenameByInputClass searchItem searchFile)
			if chbtn_CR_VRayProxy.checked do (searchItem.FileName = searchFile)
			)
		else (append notFoundItems searchItem)
		)
	fn_getData_CR()
	local ItemsArr = #()
	if chbtn_CR_ATS.checked do ItemsArr = ATSArr
	if chbtn_CR_Objects.checked or chbtn_CR_MEditor.checked do ItemsArr = MapArr
	if chbtn_CR_VRayProxy.checked do ItemsArr = ProxyArr
	for nfi in notFoundItems do append notFoundIndexs (findItem ItemsArr nfi)
	mlbx_CR_CollectorList.selection = notFoundIndexs
	lastSearchFolder = SearchFolder
	setINISetting iniFile rollTitle "lastSearchFolder" lastSearchFolder
-- 	if chbtn_CR_ATS.checked or chbtn_CR_Objects.checked or chbtn_CR_MEditor.checked do (ATfn_.UpdateSceneMaterials())
	)
)
	-------------------------------------------------------------------------------------------------------------------
on btn_CR_LoadersToEditor pressed do with undo on
(
local indexArr = mlbx_CR_CollectorList.selection as array
if indexArr.count == 0 do (return fn_MSG_SelectItems())
local toMEdit = #()
if chbtn_CR_ATS.checked do ()
if chbtn_CR_Objects.checked do 
	(
	for i in indexArr do (appendIfUnique toMEdit MapArr[i])
	)
local count = if toMEdit.count <= 24 then toMEdit.count else 24
if toMEdit.count != 0
then
	(
-- 	if queryBox "Open Selected Loaders in Material Editor?" title:"Open Materials?" beep:false do
		(MatEditor.Open(); for n=1 to count do (meditMaterials[n] = toMEdit[n]))
	)
)
	-------------------------------------------------------------------------------------------------------------------
on btn_CR_MaterialsToEditor pressed do with undo on
(
local indexArr = mlbx_CR_CollectorList.selection as array
if indexArr.count == 0 do (return fn_MSG_SelectItems())
local toMEditTemp = #()
if chbtn_CR_ATS.checked do ()
if chbtn_CR_Objects.checked do 
	(
	for i in indexArr do 
		(join toMEditTemp (for d in (refs.dependents MapArr[i]) where (superClassOf d == Material and d.name != "") collect d))
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
on btn_CR_SelectMissing pressed do
(
local missIndexArr = #()
if chbtn_CR_ATS.checked do
	(
	local missArr = #()
	for n=1 to ATSArr.count where (not doesFileExist (ATfn_.CheckStripGetPath ATSArr[n])) do
		(append missIndexArr n)
	for i in missIndexArr do (append missArr ATSArr[i])
	ATSOps.ClearSelection()
	ATSOps.SelectFiles missArr
	)
if chbtn_CR_Objects.checked or chbtn_CR_MEditor.checked do
	(
	for n=1 to TexArr.count where (not doesFileExist (ATfn_.CheckStripGetPath TexArr[n])) do
		(append missIndexArr n)
	)
if chbtn_CR_VRayProxy.checked do
	(
	for n=1 to VRMeshArr.count where (not doesFileExist (ATfn_.CheckStripGetPath VRMeshArr[n])) do
		(append missIndexArr n)
	)
mlbx_CR_CollectorList.selection = missIndexArr as bitarray
)
	-------------------------------------------------------------------------------------------------------------------
on mlbx_CR_CollectorList selectionEnd do with undo off
(
local indexArr = mlbx_CR_CollectorList.selection as array
if chbtn_CR_ATS.checked do
	(
	local selATSArr = #()
	for s in indexArr do (append selATSArr ATSArr[s])
	ATSOps.ClearSelection(); ATSOps.SelectFiles selATSArr
	)
)
	-------------------------------------------------------------------------------------------------------------------
on mlbx_CR_CollectorList doubleClicked arg do with undo off
(
local selItem
if chbtn_CR_ATS.checked do selItem = ATSArr[arg]
if chbtn_CR_Objects.checked or chbtn_CR_MEditor.checked do selItem = TexArr[arg]
if chbtn_CR_VRayProxy.checked do selItem = VRMeshArr[arg]
openedBitMap = openBitMap selItem
if openedBitMap != undefined
then
	(
	display openedBitMap caption:selItem
	)
else
	(
	if doesFileExist selItem
-- 	then (if queryBox "Show File In Folder?" title:" Collector " beep:false then (ShellLaunch "explorer.exe" ("/e,/select,\"" + selItem + "\\\"")))
	then (ShellLaunch "explorer.exe" ("/e,/select,\"" + selItem + "\\\""))
-- 	else (if queryBox "File Is Missing.\nOpen File Location?" title:" Collector " beep:false then (ShellLaunch "explorer.exe" (getFilenamePath selItem)))
	else (ShellLaunch "explorer.exe" (getFilenamePath selItem))
	)
)
	-------------------------------------------------------------------------------------------------------------------
on mlbx_CR_CollectorList rightclick arg do with undo on
(
if keyboard.altPressed
then (fn_SelectIdentical())
else if keyboard.controlPressed
then (mlbx_CR_CollectorList.selection = #{}; if chbtn_CR_ATS.checked do (ATSOps.ClearSelection(); ATSOps.SelectFiles #()))
else if keyboard.shiftPressed
then (fn_SelectAllList())
else (if not chbtn_CR_ATS.checked do (fn_SelectDependentObjects()))
)
	-------------------------------------------------------------------------------------------------------------------
on btn_CR_Refresh pressed do fn_getData_CR()
	-------------------------------------------------------------------------------------------------------------------
on rdbtn_CR_SelectedOrScene changed state do fn_getData_CR()
	-------------------------------------------------------------------------------------------------------------------
on ddl_CR_SetName selected item do
(	
if keyboard.altPressed
then
	(
	local savedNamesArr = ddl_CR_SetName.items
	if savedNamesArr[item] != "" then (deleteItem savedNamesArr item; ddl_CR_SetName.items = deepCopy savedNamesArr)
	ATfn_.ddlWidthDynamic ddl_CR_SetName
	)
else (edt_CR_CustomPath.text = (ddl_CR_SetName.items)[item])
)
on ddl_CR_SetName rightclick do
(	
if keyboard.altPressed
then
	(
	local savedNamesArr = ddl_CR_SetName.items
	appendIfUnique savedNamesArr edt_CR_CustomPath.text
	sort savedNamesArr
	ddl_CR_SetName.items = deepCopy savedNamesArr
	ATfn_.ddlWidthDynamic ddl_CR_SetName
	setFocus edt_CR_CustomPath
	)
else
	(
	edt_CR_CustomPath.text = ""
	setFocus edt_CR_CustomPath
	)
)
	-------------------------------------------------------------------------------------------------------------------
on btn_CR_GetPath pressed do
(
local SavePath = getSavePath initialDir:(edt_CR_CustomPath.text) "\\"
if SavePath != undefined do (edt_CR_CustomPath.text = try(trimright SavePath)catch(edt_CR_CustomPath.text))
)
on btn_CR_GetPath rightclick do if maxFilePath != "" do (edt_CR_CustomPath.text = trimright maxFilePath "\\")
	-------------------------------------------------------------------------------------------------------------------
	--^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
local mlbx_CR_CollectorList_width_shift = 10
local mlbx_CR_CollectorList_height_shift = 175
	-------------------------------------------------------------------------------------------------------------------
on rollout_Collector resized size do
	(
-- 	for n=1 to shCntrls.count do (shCntrls[n].pos.y = size[2] - shCntrlsPosY[n])
-- 	mlbx_CR_CollectorList.height = size[2] - 32 - 136
	if size[2] >= fixedH do (for n=1 to shCntrls.count do (shCntrls[n].pos.y = size[2] - shCntrlsPosY[n]))
	if size[2] < fixedH then mlbx_CR_CollectorList.height = fixedH else mlbx_CR_CollectorList.height = size[2] - mlbx_CR_CollectorList_height_shift
	if size[2] < fixedH do rollout_Collector.height = fixedH
	if size[1] < fixedW then mlbx_CR_CollectorList.width = fixedW - mlbx_CR_CollectorList_width_shift else mlbx_CR_CollectorList.width = size[1] - mlbx_CR_CollectorList_width_shift
	if size[1] < fixedW do rollout_Collector.width = fixedW
	)
	-------------------------------------------------------------------------------------------------------------------
on rollout_Collector open do
	(
	if (hasINISetting iniFile rollTitle) do (ATfn_.LoadRolloutINI rollout_Collector iniFile ExcludedControls)
	if (hasINISetting iniFile rollTitle "shCntrlsPosY")
	then
		(
		shCntrlsPosY = ATfn_.GetINI 0 iniFile rollTitle "shCntrlsPosY" #()
		for n=1 to shCntrls.count do (shCntrls[n].pos.y = rollout_Collector.height - shCntrlsPosY[n])
		)
	else
		(shCntrlsPosY = for n=1 to shCntrls.count collect (rollout_Collector.height - shCntrls[n].pos.y))
	mlbx_CR_CollectorList.height = rollout_Collector.height - mlbx_CR_CollectorList_height_shift
	rollout_Collector.width = fixedW
-- 	rollout_Collector.height = fixedH
	if floater_AssemblyTool != undefined do (floater_AssemblyTool.rollouts[1].chbtn_TL_Collector.checked = true)
	ATSOps.Refresh(); ATSOps.Silent = true; ATSOps.Disabled = true; ATSOps.AutoLogin = false; ATSOps.DisplayExcluded = true; ATSOps.ExcludeOutputFiles = true
	fn_getData_CR()
	ATfn_.ddlWidthDynamic ddl_CR_SetName
	callbacks.addScript #nodePostDelete "rollout_Collector.fn_getData_CR()" id:#ATcallbacks_CR_
	callbacks.addScript #filePostOpenProcess "rollout_Collector.fn_getData_CR()" id:#ATcallbacks_CR_
	callbacks.addScript #sceneUndo "rollout_Collector.fn_getData_CR()" id:#ATcallbacks_CR_
	callbacks.addScript #sceneRedo "rollout_Collector.fn_getData_CR()" id:#ATcallbacks_CR_
	)
	-------------------------------------------------------------------------------------------------------------------
on rollout_Collector close do 
	(
	ATfn_.UpdateSceneMaterials()
	if floater_AssemblyTool != undefined do (floater_AssemblyTool.rollouts[1].chbtn_TL_Collector.checked = false)
	ATfn_.SaveRolloutINI rollout_Collector iniFile ExcludedControls
	if not (hasINISetting iniFile rollTitle "shCntrlsPosY")
	do (setINISetting iniFile rollTitle "shCntrlsPosY" (with printAllElements on ((for cntrl in shCntrls collect (rollout_Collector.height - cntrl.pos.y)) as string)))
	callbacks.removeScripts id:#ATcallbacks_CR_
	try(close openedBitMap; free openedBitMap)catch()
	try(DestroyDialog renameSingle_rollout)catch()
	rollout_Collector = undefined
	freeSceneBitmaps()
	gc light:true
	)
)
	----===============================================================================================================
rollout_Collector = ATfn_.CreateRollout rollout_Collector iniFile rollTitle roll0W roll0H \
RStyle:#(#style_resizing, #style_titlebar, #style_sysmenu, #style_minimizebox, #style_maximizebox)
-------------------------------------------------------------------------------------------------------------
)
