	-----------------
	--^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
(if ATIcons == undefined then (fileIn ((getFilenamePath(getThisScriptFilename())) + "AssemblyToolIcons.ms")))
(if ATfn_ == undefined then (fileIn ((getFilenamePath(getThisScriptFilename())) + "AssemblyToolStruct.ms")))
	--^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
(
Global floater_BatchExport
Global floater_AssemblyTool
try (if floater_BatchExport.dialogBar then (cui.UnRegisterDialogBar floater_BatchExport); closeRolloutFloater floater_BatchExport) catch()
	-------------------------------------------------------------------------------------------------------------------
local floaterTitle = "Batch Export"
local iniPath = (getFilenamePath (getThisScriptFilename())) + "INI\\"
local iniFile = iniPath + "BatchExport_Settings.ini"
local fl0W = 220; local fl0H = (ATfn_.GetINI 0 iniFile floaterTitle "LastSize" [fl0W,220])[2]
local colCHBX = ATfn_.GetINI 0 (iniPath + "AssemblyTool_Settings.ini") "Preferences" "color_PS_ChBxColor" [255,156,0]
local ExcludedControls = #("btn_BE_DockLeft", "btn_BE_DockFloat", "btn_BE_DockRight",
	"ddl_BE_ExportFormat")
-- 	"ddl_BE_ExportFormat", "ddl_BE_Paths")
	-------------------------------------------------------------------------------------------------------------------
local LastUsedPath = ATfn_.GetINI 1 iniFile floaterTitle "LastUsedPath" "C:"
local ExportFormat = #(".3ds", ".abc", ".ase", ".dae", ".dwf", ".dwg", ".dxf", ".fbx", ".flt", ".igs", ".obj", ".sat")
local ExportClass = #("3D_StudioExporterPlugin", "Alembic_Export", "AsciiExp", "DAEEXP", "DWF_Exporter", \
	"DWG_ExportExporterPlugin", "DWG_Export", "FBXEXP", "OpenFltExport", "IGES_Export", "ObjExp", "ACIS_SAT")
	----=BatchExport==============================================================================================
rollout rollout_BE_ floaterTitle
(
local yp1 = #(14, 35, 78, 106, 127, 152)
local DockX = 181; local DockW = 13
button btn_BE_DockLeft "<" pos:[DockX-DockW,0] width:DockW height:10 tooltip:" Dock Left "
button btn_BE_DockFloat "::" pos:[DockX,0] width:DockW height:10 tooltip:" Float "
button btn_BE_DockRight ">" pos:[DockX+DockW,0] width:DockW height:10 tooltip:" Dock Right "
on btn_BE_DockLeft pressed do (ATfn_.DockFloaterSide floater_BatchExport iniFile "left")
on btn_BE_DockRight pressed do (ATfn_.DockFloaterSide floater_BatchExport iniFile "right")
on btn_BE_DockFloat pressed do (ATfn_.DockFloaterFloat floater_BatchExport iniFile fl0W fl0H)
	-------
checkButton chbtn_BE_MoveToOrigin "" pos:[3,yp1[1]] width:14 height:14 checked:false highlightColor:colCHBX toolTip:" Set Model To Origin [0,0,0] "
label lbl_BE_MoveToOrigin "Move To Origin" pos:[21,yp1[1]] toolTip:chbtn_BE_MoveToOrigin.toolTip
checkButton chbtn_BE_MergeAllNodes "" pos:[105,yp1[1]] width:14 height:14 checked:false highlightColor:colCHBX toolTip:" Merge All Model Nodes "
label lbl_BE_MergeAllNodes "Collapse" pos:[123,yp1[1]] toolTip:chbtn_BE_MergeAllNodes.toolTip

checkButton chbtn_BE_ResetXForm "" pos:[3,yp1[2]] width:14 height:14 checked:false highlightColor:colCHBX toolTip:" Reset XForm "
label lbl_BE_ResetXForm "Reset XForm" pos:[21,yp1[2]] toolTip:chbtn_BE_ResetXForm.toolTip
checkButton chbtn_BE_RemoveHelpers "" pos:[95,yp1[2]] width:14 height:14 checked:false highlightColor:colCHBX toolTip:" Remove Top Parent Helpers and Groups "
label lbl_BE_RemoveHelpers "Remove Helpers" pos:[113,yp1[2]] toolTip:chbtn_BE_RemoveHelpers.toolTip
checkButton chbtn_BE_ConvertToEditableMesh "" pos:[3,yp1[2]+21] width:14 height:14 checked:false highlightColor:colCHBX toolTip:" Convert Model To Editable Mesh "
label lbl_BE_ConvertToEditableMesh "Convert To Editable Mesh" pos:[21,yp1[2]+21] toolTip:chbtn_BE_ConvertToEditableMesh.toolTip

label lbl_BE_ExportFormat "Export Format:" pos:[7,yp1[3]+2] toolTip:" Export Format "
dropdownlist ddl_BE_ExportFormat items:ExportFormat pos:[85,yp1[3]] width:75 height:33 selection:8 tooltip:lbl_BE_ExportFormat.toolTip

checkButton chbtn_BE_ShowDialog "" pos:[3,yp1[4]] width:14 height:14 checked:false highlightColor:colCHBX toolTip:" Show Format Configuration Dialog "
label lbl_BE_ShowDialog "Show Format Configuration Dialog" pos:[21,yp1[4]] toolTip:chbtn_BE_ResetXForm.toolTip

dropdownlist ddl_BE_Paths items:#("C:") pos:[3,yp1[5]] width:175 height:33 selection:1 tooltip:" Lmb - Choose Path \n Alt+Lmb - Remove Path \n Rmb - Open Folder \n Alt+Rmb - Remove All Paths "
button btn_BE_AddPath "..." pos:[180,yp1[5]] width:23 height:21 toolTip:" Add Path To List "

button btn_BE_Export "Export Selected" pos:[4,yp1[6]] width:(fl0W-20) height:37 toolTip:" Export Selected Models "
	-------------------------------------------------------------------------------------------------------------------
	-----fn------------------------------------------------------------------------------------------------------------
	-----fn------------------------------------------------------------------------------------------------------------
FN fn_Export dir =
(
max create mode
-- ATfn_.GetNHH (selection as array) true UseChildren:false
local selArr = selection as array
local dialogState = true
local parArr = #()
for o in selArr do (appendIfUnique parArr (ATfn_.GetTopParent o))
-- parArr = for par in parArr where not ((par.children).count == 0 and not (ATfn_.GCheck par VRProxy:false)) collect par
parArr = for par in parArr where not ((par.children).count == 0 and superClassOf par == helper) collect par

local filesStr = ""
for par in parArr do
	(
	local filePath = dir + "\\" + par.name + (ExportFormat[ddl_BE_ExportFormat.selection])
	if doesFileExist filePath do filesStr += ("\n" + filePath)
	)
if filesStr != "" do return (messageBox ("Files Already Exists:" + filesStr) title:"File Exists!" beep:false)
	
for par in parArr do
	(
	local model = #()
	local newPar
	local modelName = par.name
	local children = par.children
	par.isFrozen = par.isHidden = children.isFrozen = children.isHidden = false
	if children.count != 0
	then
		(
		if isOpenGroupHead par do (setGroupOpen par false)
		newPar = ATfn_.CopyObject par IInstance:false expandHierarchy:true
		if chbtn_BE_MoveToOrigin.checked do newPar.pos = [0,0,0]
		model = for ch in newPar.children collect ch
		appendIfUnique model newPar
		select model
		if chbtn_BE_RemoveHelpers.checked do
			(
			if (superClassOf newPar == helper) do
				(
				if (isGroupHead newPar)
				then (ungroup newPar)
				else (delete newPar)
				)
			)
		)
	else
		(
		newPar = ATfn_.CopyObject par IInstance:false
		if chbtn_BE_MoveToOrigin.checked do newPar.pos = [0,0,0]
		select newPar
		)
		
	if selection.count > 1 and chbtn_BE_MergeAllNodes.checked do
		(
		explodeGroup selection
		local geom = ATfn_.GetGeometry selection VRProxy:true
		local other = ATfn_.ArraysDifference selection geom
		ATfn_.ResetsXForm 1 #(geom[1])
		local attObj = ATfn_.Attach_ geom
		attObj.name = modelName
		attObj.pivot = par.pivot
-- 		ATfn_.quickResetXForm #(attObj)
		append other attObj
		select other
-- 		PolyBoost.Resetxfunc()
		)
-- 	if chbtn_BE_ResetXForm.checked do (PolyBoost.Resetxfunc())
	if chbtn_BE_ResetXForm.checked do (ATfn_.ResetsXForm 1 (ATfn_.GetGeometry selection VRProxy:false))
	if chbtn_BE_ConvertToEditableMesh.checked do (convertToMesh selection)
		
	local modelPath = dir + "\\" + modelName + (ExportFormat[ddl_BE_ExportFormat.selection])
	local classStrArr = for cls in exporterPlugin.classes collect (toLower (cls as string))
	local expClass = exporterPlugin.classes[findItem classStrArr (toLower ExportClass[ddl_BE_ExportFormat.selection])]
	
	if chbtn_BE_ShowDialog.checked and dialogState
	then
		(
		if not (exportFile modelPath selectedOnly:true using:expClass) do (delete selection; select selArr; return false)
		dialogState = false
		)
	else
		(
		exportFile modelPath #noPrompt selectedOnly:true using:expClass
		)
	
	delete selection
	)
select selArr
-- delete selArr
)
	-----fn------------------------------------------------------------------------------------------------------------
	-------------------------------------------------------------------------------------------------------------------
on btn_BE_Export pressed do with undo off
(
local SavePath = ddl_BE_Paths.selected
if SavePath != undefined do
	(
	fn_Export SavePath
	)
)
	-----------------------------------------------
on btn_BE_Export rightclick do with undo off
(
local SavePath = getSavePath initialDir:LastUsedPath
if SavePath != undefined do
	(
	fn_Export SavePath
	LastUsedPath = SavePath
	)
)
	-------------------------------------------------------------------------------------------------------------------
on btn_BE_AddPath pressed do
(
local SavePath = getSavePath initialDir:LastUsedPath
if SavePath != undefined do
	(
	LastUsedPath = SavePath
	local items = ddl_BE_Paths.items
	appendIfUnique items SavePath
	ddl_BE_Paths.items = deepCopy items
	ddl_BE_Paths.selection = items.count
	)
)
	-----------------------------------------------
-- on btn_BE_AddPath rightclick do
-- (
-- print ddl_BE_Paths.selected
-- )
	-------------------------------------------------------------------------------------------------------------------
on ddl_BE_Paths selected item do
(	
if keyboard.altPressed
then
	(
	local Paths = ddl_BE_Paths.items
	deleteItem Paths item
	if Paths.count == 0 do append Paths "C:"
	ddl_BE_Paths.items = deepCopy Paths
	ddl_BE_Paths.selection = 1
-- 	ATfn_.ddlWidthDynamic ddl_BE_Paths
	)
else ()
)
	-----------------------------------------------
on ddl_BE_Paths rightclick do
(	
if keyboard.altPressed
then
	(
	if queryBox "Clear All List?" title:" Assembly Tool" beep:false
	then
		(
		ddl_BE_Paths.items = #("C:")
		ddl_BE_Paths.selection = 1
		)
	else ()
	)
else
	(
	ShellLaunch "explorer.exe" ddl_BE_Paths.selected
	)
)
	-------------------------------------------------------------------------------------------------------------------
	----===============================================================================================================
on rollout_BE_ open do
	(
	if floater_AssemblyTool != undefined do try(floater_AssemblyTool.rollouts[1].chbtn_TL_BatchExport.checked = true)catch()
	)
on rollout_BE_ close do
	(
	if floater_AssemblyTool != undefined do try(floater_AssemblyTool.rollouts[1].chbtn_TL_BatchExport.checked = false)catch()
	ATfn_.SaveFloaterINI floater_BatchExport iniFile ExcludedControls
	setINISetting iniFile floaterTitle "LastUsedPath" LastUsedPath
	floater_BatchExport = undefined
	)
)
	----==============================================================================================================
floater_BatchExport = ATfn_.CreateFloater floater_BatchExport iniFile fl0W fl0H floaterTitle #(rollout_BE_)
on execute do
	(
	if (hasINISetting iniFile floaterTitle) do (ATfn_.LoadFloaterINI floater_BatchExport iniFile ExcludedControls)
-- 	for r in floater_BatchExport.Rollouts do (ATfn_.chbtnRunColor r.controls)
	)
)