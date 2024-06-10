	--^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
(if ATIcons == undefined then (fileIn ((getFilenamePath(getThisScriptFilename())) + "AssemblyToolIcons.ms")))
(if ATfn_ == undefined then (fileIn ((getFilenamePath(getThisScriptFilename())) + "AssemblyToolStruct.ms")))
	--^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
(
Global rollout_BatchImport
Global floater_AssemblyTool
try(if rollout_BatchImport.dialogBar then (cui.UnRegisterDialogBar rollout_BatchImport); destroyDialog rollout_BatchImport)catch()
	--^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
local rollTitle = "Batch Import"
local iniPath = (getFilenamePath (getThisScriptFilename())) + "INI\\"
local iniFile = iniPath + "BatchImport_Settings.ini"
local fixedW = 680; local startH = 245; local fixedH = 245
local roll0S = ATfn_.GetINI 0 iniFile rollTitle "LastSize" [fixedW,startH]; local roll0W = roll0S[1]; local roll0H = roll0S[2]
local colCHBX = ATfn_.GetINI 0 (iniPath + "AssemblyTool_Settings.ini") "Preferences" "color_PS_ChBxColor" [255,156,0]
local ExcludedControls = #("mlbx_BI_FilesList")
	-------------------------------------------------------------------------------------------------------------------
local LastUsedPath = ATfn_.GetINI 1 iniFile rollTitle "LastUsedPath" "C:\\"
	-------------------------------------------------------------------------------------------------------------------
	----===============================================================================================================
rollout rollout_BatchImport rollTitle
(
local mlbx_BI_FilesList_width_shift = 225
local mlbx_BI_FilesList_height_shift = 40
local yp1 = #(7, 49, 89, 157, 200)
button btn_BI_AddFiles "Add Files" pos:[220,yp1[1]] width:90 height:23
button btn_BI_AddFolder "Add Folder" pos:[315,yp1[1]] width:90 height:23
checkButton chbtn_BI_AddSubFolders "" pos:[410,yp1[1]+5] width:14 height:14 checked:true highlightColor:colCHBX toolTip:" Add Files From Subfolders "
label lbl_BI_AddSubFolders "Subfolders" pos:[428,yp1[1]+5] toolTip:chbtn_BI_AddSubFolders.toolTip
button btn_BI_RemoveAll "Clear List" pos:[490,yp1[1]] width:68 height:23
button btn_BI_RemoveSelected "Remove Selected" pos:[561,yp1[1]] width:100 height:23
button btn_BI_SelectAll "Select All" pos:[666,yp1[1]] width:68 height:23
multilistbox mlbx_BI_FilesList items:#() pos:[mlbx_BI_FilesList_width_shift-5,yp1[1]+28] width:(rollout_BatchImport.width-mlbx_BI_FilesList_width_shift) height:15 tooltip:" Files To Import \n DoubleClick - Opens File In Browser  "

label lbl_BI_Basename "Basename:" pos:[10,yp1[1]]
edittext edt_BI_Basename "" pos:[5,yp1[1]+16] width:205 height:17 bold:false

checkButton chbtn_BI_AddToLayer "" pos:[10,yp1[2]] width:14 height:14 checked:true highlightColor:colCHBX toolTip:" Add Imported Models to Separate Layer Named by Basename "
label lbl_BI_AddToLayer "Add Models to Layer" pos:[28,yp1[2]] toolTip:chbtn_BI_AddToLayer.toolTip

checkButton chbtn_BI_FreezeHelpers "" pos:[10,yp1[2]+20] width:14 height:14 checked:true highlightColor:colCHBX
label lbl_BI_FreezeHelpers "Freeze Helpers" pos:[28,yp1[2]+20] toolTip:" Freeze Helpers Layer "
spinner spnr_BI_TextSize "Text Size:" pos:[147,yp1[2]+20] width:60 range:[0,99999,20] type:#integer scale:1 toolTip:" Basename Text Size (if == 0 then Autosize) "

GroupBox grp_BI_ModelsAlignment "Models Alignment" pos:[7,yp1[3]] width:204 height:62
radiobuttons rdbtn_BI_TopCenterBottom "" labels:#("Top","Center","Bottom") pos:[15,yp1[3]+18] offsets:#([0,0],[0,0],[5,0]) columns:3 default:2 tooltip:" Models Alignment "
spinner spnr_BI_ModelsSpacing "Models Spacing: " pos:[90,yp1[3]+40] width:70 range:[0,999999,20] type:#integer scale:1 toolTip:" Models Spacing "

button btn_BI_ImportFromList "Import From List" pos:[7,yp1[4]] width:204 height:37

button btn_BI_ImportBrowse "Import From Browser" pos:[7,yp1[5]] width:204 height:37 toolTip:" Import Files From Browser "
	-------------------------------------------------------------------------------------------------------------------
	-----fn------------------------------------------------------------------------------------------------------------
fn fn_GetPath = getSavePath initialDir:(LastUsedPath + "\\")
	-----fn------------------------------------------------------------------------------------------------------------
FN fn_msgWrongCounter = (messageBox "Counter Field Must Contain Digits." title:"Wrong Counter!" beep:false)
	-----fn------------------------------------------------------------------------------------------------------------
FN fn_Import inputFiles =
(
local baseName = edt_BI_Basename.text
if baseName == "" do (return messageBox "Basename field is empty." title:"Enter Basename!" beep:false)
-- if (FilterString baseName "_").count != 2 do (return messageBox ("Basename must contain 2 parts (example: \"Name_A\")\n\nWe have  \""+baseName+"\"  with  "+((FilterString baseName "_").count as string)+"  parts.") title:"Wrong Basename!" beep:false)
-- if (ATfn_.CollectByPattern baseName).count > 0 do (return messageBox ("In scene already exists objects with Basename  \""+baseName+"\".\n\nPerhaps you forgot change the Name in the Basename field.") title:"Coincident Names Found!" beep:false)

local space = spnr_BI_ModelsSpacing.value
local startX = 0.
local startY = 0.
local rectHelpers = for o in objects where (matchPattern o.name pattern:"*RectangleHelper_*") collect o
if rectHelpers.count > 0 do
	(
	local minYArr = for h in rectHelpers collect h.min.y
	startY = rectHelpers[findItem minYArr (amin minYArr)].min.y
	)

local allObjsArr = #()
local matchArr = #()
local modelsGroups = #()
for nf=1 to inputFiles.count do
	(
	try
		(
		local file = inputFiles[nf]
		importFile file #noPrompt using:FBXIMP
		for o in selection do o.parent = undefined
		for objct in selection where not (ATfn_.GCheck objct) do delete objct
		ATfn_.CheckEmpty selection message:false deleteEmpty:true
		InstanceMgr.MakeObjectsUnique selection #individual
		ATfn_.quickResetXForm selection
		convertToPoly selection
		for o in selection do
			(
			local oldName = o.name
			o.name = uniqueName (oldName + "_Temp") numDigits:3
			local fstrNew = FilterString o.name "_Temp"
			if fstrNew[fstrNew.count] != "001" do (appendIfUnique matchArr (getNodeByName (oldName + "_Temp001")); appendIfUnique matchArr o)
			)
		join allObjsArr selection
		local modelGroup = group selection
		append modelsGroups modelGroup
		select modelGroup
		if chbtn_BI_AddToLayer.checked
		then
			(
			if (LayerManager.getLayerFromName baseName) == undefined then (layermanager.newLayerFromName baseName)
			local layerImported = LayerManager.getLayerFromName baseName
			for objct in selection do layerImported.addNode objct
			)
		else (for objct in selection do (LayerManager.getLayer 0).addNode objct)
		clearSelection()
		)
	catch
		(return messageBox ("Error While Importing File:\n\n" + file + "\n\nPossibly because of the name match.") title:"Import Error!" beep:false)
	)
ATfn_.DeleteEmptyLayers()

local gCount = modelsGroups.count
for g in modelsGroups do (setGroupOpen g true; g.pivot.z = g.min.z; setGroupOpen g false)
for g in modelsGroups do (g.pos.z = 0)
local MinMaxArr = ATfn_.GetMinMax modelsGroups
	
if (LayerManager.getLayerFromName "Helpers_ImportFBX") == undefined then (layermanager.newLayerFromName "Helpers_ImportFBX")
local layerHelpers = LayerManager.getLayerFromName "Helpers_ImportFBX"
layerHelpers.isFrozen = (chbtn_BI_FreezeHelpers.state)
	
local rectHelperY = (amax (for mm in MinMaxArr[5] collect mm[2])) + (space * 2.)
local rectHelperX = (space * gCount) + space
for n=1 to gCount do (rectHelperX += MinMaxArr[5][n][1])
local rectHelper = Rectangle length:rectHelperY width:rectHelperX showFrozenInGray:false wirecolor:green render_displayRenderMesh:false name:("RectangleHelper_" + baseName)
convertToSplineShape rectHelper
for k=1 to numknots rectHelper 1 do setKnotType rectHelper 1 k #corner; updateShape rectHelper
layerHelpers.addNode rectHelper
rectHelper.pos.x = startX + rectHelperX/2.
rectHelper.pos.y = startY - rectHelperY/2.
for n=1 to gCount do
	(
	g = modelsGroups[n]
	if n == 1
		then (g.pos.x = startX + space + MinMaxArr[5][n][1] / 2.)
		else (g.pos.x = modelsGroups[n-1].max.x + space + MinMaxArr[5][n][1] / 2.)
	g.pos.y = case rdbtn_BI_TopCenterBottom.state of
		(
		1: (startY - space - MinMaxArr[5][n][2] / 2.)
		2: (rectHelper.center.y)
		3: (startY - rectHelperY + space + MinMaxArr[5][n][2] / 2.)
		)
	)
	
local nameHelper = Text size:(if spnr_BI_TextSize.value != 0 then spnr_BI_TextSize.value else rectHelperY/4) kerning:0 leading:0 showFrozenInGray:false wirecolor:green render_displayRenderMesh:false text:baseName name:("NameHelper_" + baseName)
layerHelpers.addNode nameHelper
nameHelper.pos.x = startX - (nameHelper.max - nameHelper.min).x / 2 - space
nameHelper.pos.y = rectHelper.center.y
startY -= rectHelperY
for g in modelsGroups do (ungroup g)
	
if matchArr.count > 0
	then
		(
		for objct in allObjsArr do
			(
			local fstr = filterString objct.name "_"
			local colName = ""
			for ns=1 to fstr.count - 1 do (colName += fstr[ns] + "_")
			objct.name = trimRight colName "_"
			)
		select matchArr
		messageBox "Objects With Matched Names Found and Selected." title:"Matched Names Found!" beep:false
		)
	else (for objct in allObjsArr do (objct.name = substituteString objct.name "_Temp001" ""))
viewport.ZoomToBounds false (rectHelper.min) (rectHelper.max)
completeRedraw()
)
	-----fn------------------------------------------------------------------------------------------------------------
	-------------------------------------------------------------------------------------------------------------------
on btn_BI_ImportFromList pressed do with undo on
(
local indexArr = mlbx_BI_FilesList.selection as array
if indexArr.count == 0 do return (ATfn_.messageSI())
local files = for i in indexArr collect mlbx_BI_FilesList.items[i]
fn_Import files
completeRedraw()
)
	-------------------------------------------------------------------------------------------------------------------
on btn_BI_ImportBrowse pressed do
(
local files = ATfn_.GetDirFiles types:"FBX Files (*.fbx)|*.fbx" initialDir:LastUsedPath
if files != undefined do
	(
	fn_Import files
	LastUsedPath = trimRight (getFilenamePath files[1]) "\\"
	)
)
	-------------------------------------------------------------------------------------------------------------------
on mlbx_BI_FilesList doubleClicked arg do with undo off
(
ShellLaunch "explorer.exe" ("/e,/select,\"" + mlbx_BI_FilesList.items[arg] + "\\\"")
)
	-------------------------------------------------------------------------------------------------------------------
on btn_BI_AddFolder pressed do
(
local searchPath = fn_GetPath()
if searchPath != undefined do
	(
	local files = #()
	local dirs = #(searchPath)
	if chbtn_BI_AddSubFolders.checked do (for dir in dirs do (join dirs (getDirectories (dir + "/*"))))
	for dir in dirs do (for f in (getFiles (dir + "\\" + ("*.fbx"))) do appendIfUnique files f)
	ATfn_.AddListItems mlbx_BI_FilesList files
	LastUsedPath = searchPath
	)
)
	-------------------------------------------------------------------------------------------------------------------
on btn_BI_AddFiles pressed do
(
local files = ATfn_.GetDirFiles types:"FBX Files (*.fbx)|*.fbx" initialDir:LastUsedPath
if files != undefined do
	(
	ATfn_.AddListItems mlbx_BI_FilesList files
	LastUsedPath = trimRight (getFilenamePath files[1]) "\\"
	)
)
	-------------------------------------------------------------------------------------------------------------------
on btn_BI_SelectAll pressed do (mlbx_BI_FilesList.selection = #{1..mlbx_BI_FilesList.items.count})
	-------------------------------------------------------------------------------------------------------------------
on btn_BI_RemoveSelected pressed do (ATfn_.RemoveListItems mlbx_BI_FilesList mlbx_BI_FilesList.selection)
	-------------------------------------------------------------------------------------------------------------------
on btn_BI_RemoveAll pressed do (mlbx_BI_FilesList.items = #())
	-------------------------------------------------------------------------------------------------------------------
	--^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
	-------------------------------------------------------------------------------------------------------------------
on rollout_BatchImport resized size do
	(
	if size[2] < fixedH then mlbx_BI_FilesList.height = fixedH else mlbx_BI_FilesList.height = size[2] - mlbx_BI_FilesList_height_shift
	if size[2] < fixedH do rollout_BatchImport.height = fixedH
	if size[1] < fixedW then mlbx_BI_FilesList.width = fixedW - mlbx_BI_FilesList_width_shift else mlbx_BI_FilesList.width = size[1] - mlbx_BI_FilesList_width_shift
	if size[1] < fixedW do rollout_BatchImport.width = fixedW
	)
	-------------------------------------------------------------------------------------------------------------------
on rollout_BatchImport open do
	(
	if (hasINISetting iniFile rollTitle) do (ATfn_.LoadRolloutINI rollout_BatchImport iniFile ExcludedControls)
	mlbx_BI_FilesList.height = rollout_BatchImport.height - mlbx_BI_FilesList_height_shift
	mlbx_BI_FilesList.width = rollout_BatchImport.width - mlbx_BI_FilesList_width_shift
	mlbx_BI_FilesList.selection = #{}
	)
	-------------------------------------------------------------------------------------------------------------------
on rollout_BatchImport close do 
	(
	if floater_AssemblyTool != undefined do (floater_AssemblyTool.rollouts[1].chbtn_TL_BatchImport.checked = false)
	ATfn_.SaveRolloutINI rollout_BatchImport iniFile ExcludedControls
	setINISetting iniFile rollTitle "LastUsedPath" LastUsedPath
	rollout_BatchImport = undefined
-- 	gc light:true
-- 	macros.run "_lava" "ActioN04"
	)
)
	----===============================================================================================================
rollout_BatchImport = ATfn_.CreateRollout rollout_BatchImport iniFile rollTitle roll0W roll0H \
RStyle:#(#style_resizing, #style_titlebar, #style_sysmenu, #style_minimizebox, #style_maximizebox)
-------------------------------------------------------------------------------------------------------------
)
