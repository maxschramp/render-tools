(
Global rollout_ObjectClass
Global floater_AssemblyTool
try(if rollout_ObjectClass.dialogBar then (cui.UnRegisterDialogBar rollout_ObjectClass); destroyDialog rollout_ObjectClass)catch()
	-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local rollTitle = "Object Class"
local iniPath = (getFilenamePath (getThisScriptFilename())) + "INI\\"
local iniFile = iniPath + "ObjectClass_Settings.ini"
local roll0S = ATfn_.GetINI 0 iniFile rollTitle "LastSize" [220,500]; local roll0W = roll0S[1]; local roll0H = roll0S[2]
local colCHBX = ATfn_.GetINI 0 (iniPath + "AssemblyTool_Settings.ini") "Preferences" "color_PS_ChBxColor" [255,156,0]
local ExcludedControls = #("btn_OCM_DockLeft", "btn_OCM_DockFloat", "btn_OCM_DockRight", "mlbx_OCM_ByClassList")
	-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local Classes = #()
local ObjByClassArr = #()
local ObjByClassInfo = #()
	----================================================================================================================================
rollout rollout_ObjectClass rollTitle
(
local DockX = 15; local DockW = 13
button btn_OCM_DockLeft "<" pos:[DockX-DockW,2] width:DockW height:10 tooltip:" Dock Left "
button btn_OCM_DockFloat "::" pos:[DockX,2] width:DockW height:10 tooltip:" Float "
button btn_OCM_DockRight ">" pos:[DockX+DockW,2] width:DockW height:10 tooltip:" Dock Right "
on btn_OCM_DockLeft pressed do (ATfn_.DockRolloutSide rollout_ObjectClass iniFile "left")
on btn_OCM_DockRight pressed do (ATfn_.DockRolloutSide rollout_ObjectClass iniFile "right")
on btn_OCM_DockFloat pressed do (ATfn_.DockRolloutFloat rollout_ObjectClass iniFile roll0W roll0H)
	-------
local yp1 = #(14, 58)
radiobuttons rdbtn_OCM_SelectedOrScene "" labels:#("Selected","Scene") pos:[6,yp1[1]+2] columns:2 offsets:#([0,0],[0,0]) default:2 tooltip:" Process Selected Objects \n Or All Scene Objects "
radiobuttons rdbtn_OCM_SuperOrClass "" labels:#("SuperClass","Class") pos:[6,yp1[1]+22] columns:2 default:2 tooltip:" Manage Objects By Superclass Or Class "
button btn_OCM_Refresh "Refresh" pos:[130,yp1[1]-10] width:86 height:26 border:true tooltip:" Refresh List "
checkButton chbtn_OCM_Frozen "Frozen" pos:[131,yp1[1]+19] width:41 height:21 checked:true highlightColor:colCHBX tooltip:" Manage Frozen Objects "
checkButton chbtn_OCM_Hidden "Hidden" pos:[175,yp1[1]+19] width:41 height:21 checked:true highlightColor:colCHBX tooltip:" Manage Hidden Objects "
multilistbox mlbx_OCM_ByClassList items:#() pos:[0,yp1[2]] width:(rollout_ObjectClass.width-0) height:100 tooltip:" Lmb - Select Objects By Class "

	-----fn-------------------------------------------------------------------------------------------------------------------------------------------------
FN fn_GetInput =
(
local RArr = #()
RArr = for obj in (if rdbtn_OCM_SelectedOrScene.state == 1 then selection else objects) where (not isGroupHead obj) collect obj
if not chbtn_OCM_Frozen.checked do (RArr = for obj in RArr where not obj.isFrozen collect obj)
if not chbtn_OCM_Hidden.checked do (RArr = for obj in RArr where not obj.isHidden collect obj)
return RArr
)
	-----fn-------------------------------------------------------------------------------------------------------------------------------------------------
FN fn_compareAsString i1 i2 = stricmp (i1 as string) (i2 as string)
	-----fn-------------------------------------------------------------------------------------------------------------------------------------------------
-- FN fn_CloseGroups GHeadsArr = (for gh in GHeadsArr where (isValidObj gh) do (try (setGroupOpen gh false) catch()))
	-----fn-------------------------------------------------------------------------------------------------------------------------------------------------
FN fn_GetSClass obj = if rdbtn_OCM_SuperOrClass.state == 1 then SuperClassOf obj else ClassOf obj
	-----fn-------------------------------------------------------------------------------------------------------------------------------------------------
FN fn_Refresh  =
(
local inArr = fn_GetInput()
Classes = #()
ObjByClassArr = #()
ObjByClassInfo = #()
for o in inArr do appendIfUnique Classes (fn_GetSClass o)
qSort Classes fn_compareAsString
for c in Classes do
	(
	local tArr = for o in inArr where (fn_GetSClass o) == c collect o
	append ObjByClassArr tArr
	local ClassStr = c as string
	append ObjByClassInfo ((replace ClassStr 1 1 (toUpper ClassStr[1])) + "  " + (tArr.count as string))
	)
mlbx_OCM_ByClassList.items = ObjByClassInfo
mlbx_OCM_ByClassList.selection = #{}
redrawViews()
)
	-----fn-------------------------------------------------------------------------------------------------------------------------------------------------
	--------------------------------------------------------------------------------------------------------------------------------------------------------
on mlbx_OCM_ByClassList selectionEnd do
with undo on 
(
clearSelection()
local SelArr = #()
for s in mlbx_OCM_ByClassList.selection do join SelArr ObjByClassArr[s]
ATfn_.SelectInGroups SelArr
redrawViews()
)
	--------------------------------------------------------------------------------------------------------------------------------------------------------
on btn_OCM_Refresh pressed do (fn_Refresh())
on btn_OCM_Refresh rightclick do (print (rollout_ObjectClass.width))
	--------------------------------------------------------------------------------------------------------------------------------------------------------
on rdbtn_OCM_SelectedOrScene changed state do (fn_Refresh())
	--------------------------------------------------------------------------------------------------------------------------------------------------------
on rdbtn_OCM_SuperOrClass changed state do (fn_Refresh())
	--------------------------------------------------------------------------------------------------------------------------------------------------------
on chbtn_OCM_Frozen changed state do (fn_Refresh())
	--------------------------------------------------------------------------------------------------------------------------------------------------------
on chbtn_OCM_Hidden changed state do (fn_Refresh())
	--------------------------------------------------------------------------------------------------------------------------------------------------------
on rollout_ObjectClass resized size do
	(
	mlbx_OCM_ByClassList.width = size[1] - 0
	mlbx_OCM_ByClassList.height = size[2] - 58
	)
	-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
on rollout_ObjectClass open do
	(
	if (hasINISetting iniFile rollTitle) do (ATfn_.LoadRolloutINI rollout_ObjectClass iniFile ExcludedControls)
	mlbx_OCM_ByClassList.height = rollout_ObjectClass.height - 58
	if floater_AssemblyTool != undefined do (floater_AssemblyTool.rollouts[1].chbtn_TL_ObjectClass.checked = true)
	fn_Refresh()
	callbacks.addScript #nodePostDelete "rollout_ObjectClass.fn_Refresh()" id:#ATcallbacks_OCM_
	callbacks.addScript #filePostOpenProcess "rollout_ObjectClass.fn_Refresh()" id:#ATcallbacks_OCM_
	)
	-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
on rollout_ObjectClass close do 
	(
	if floater_AssemblyTool != undefined do (floater_AssemblyTool.rollouts[1].chbtn_TL_ObjectClass.checked = false)
	ATfn_.SaveRolloutINI rollout_ObjectClass iniFile ExcludedControls
	callbacks.removeScripts id:#ATcallbacks_OCM_
	rollout_ObjectClass = undefined
	gc light:true
	)
)
	----================================================================================================================================
rollout_ObjectClass = ATfn_.CreateRollout rollout_ObjectClass iniFile rollTitle roll0W roll0H \
RStyle:#(#style_resizing, #style_titlebar, #style_sysmenu, #style_minimizebox, #style_maximizebox)
-------------------------------------------------------------------------------------------------------------
)
