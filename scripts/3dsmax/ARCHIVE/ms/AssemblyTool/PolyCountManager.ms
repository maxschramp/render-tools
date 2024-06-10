(
Global rollout_PolyCountManager
Global floater_AssemblyTool
try(if rollout_PolyCountManager.dialogBar then (cui.UnRegisterDialogBar rollout_PolyCountManager); destroyDialog rollout_PolyCountManager)catch()
	-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local rollTitle = "PolyCountManager"
local iniPath = (getFilenamePath (getThisScriptFilename())) + "INI\\"
local iniFile = iniPath + "PolyCountManager_Settings.ini"
local roll0S = ATfn_.GetINI 0 iniFile rollTitle "LastSize" [220,500]; local roll0W = roll0S[1]; local roll0H = roll0S[2]
local colCHBX = ATfn_.GetINI 0 (iniPath + "AssemblyTool_Settings.ini") "Preferences" "color_PS_ChBxColor" [255,156,0]
local ExcludedControls = #("btn_PCM_DockLeft", "btn_PCM_DockFloat", "btn_PCM_DockRight", "mlbx_PCM_PolyCountList")
	-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local processObjects_PM = #()
	----================================================================================================================================
rollout rollout_PolyCountManager rollTitle
(
local DockX = 15; local DockW = 13
button btn_PCM_DockLeft "<" pos:[DockX-DockW,2] width:DockW height:10 tooltip:" Dock Left "
button btn_PCM_DockFloat "::" pos:[DockX,2] width:DockW height:10 tooltip:" Float "
button btn_PCM_DockRight ">" pos:[DockX+DockW,2] width:DockW height:10 tooltip:" Dock Right "
on btn_PCM_DockLeft pressed do (ATfn_.DockRolloutSide rollout_PolyCountManager iniFile "left")
on btn_PCM_DockRight pressed do (ATfn_.DockRolloutSide rollout_PolyCountManager iniFile "right")
on btn_PCM_DockFloat pressed do (ATfn_.DockRolloutFloat rollout_PolyCountManager iniFile roll0W roll0H)
	-------
local yp1 = #(18)
radiobuttons rdbtn_PCM_SelectedOrScene "" labels:#("Selected","Scene") pos:[6,yp1[1]-4] columns:2 offsets:#([0,0],[0,0]) default:1 tooltip:" Process Selected Objects \n Or All Scene Objects "
button btn_PCM_Refresh "Refresh" pos:[130,yp1[1]-14] width:86 height:26 border:true tooltip:" Refresh List "
multilistbox mlbx_PCM_PolyCountList items:#() pos:[0,yp1[1]+14] width:(rollout_PolyCountManager.width-0) height:100 tooltip:" Lmb - Select List Objects "

	-----fn-------------------------------------------------------------------------------------------------------------------------------------------------
FN fn_compareBy a b = if a[2] > b[2] then -1 else if a[2] < b[2] then 1 else 0 
	-----fn-------------------------------------------------------------------------------------------------------------------------------------------------
FN fn_GetPolycount = 
(
max create mode
local dataArr = #()
local objctArr = #()
if rdbtn_PCM_SelectedOrScene.state == 1
then (objctArr = for objct in selection where (ATfn_.GCheck objct) collect objct)
else (objctArr = for objct in objects where (ATfn_.GCheck objct) collect objct)
for objct in objctArr do
	(
	local tArr = #()
    local getPCount = getPolygonCount objct
	append tArr objct
	append tArr getPCount[1]
-- 	append tArr getPCount[2]
	append dataArr tArr
	)
qsort dataArr fn_compareBy
local mltlstbxInfoArr = #()
-- for n=1 to dataArr.count do (append mltlstbxInfoArr (" " + (dataArr[n][2] as string) + "    " + (dataArr[n][3] as string) + "    " + (dataArr[n][1].name) ))
for n=1 to dataArr.count do (append mltlstbxInfoArr (" " + (dataArr[n][2] as string) + "    " + (dataArr[n][1].name) ))
mlbx_PCM_PolyCountList.items = mltlstbxInfoArr
local mltlstbxSelection = #{}
objctArr = for arr in dataArr collect arr[1]
-- for objct in selection do (local itemN = findItem objctArr objct; if itemN != 0 then (append mltlstbxSelection itemN))
mlbx_PCM_PolyCountList.selection = mltlstbxSelection
max modify mode
-- return objctArr
processObjects_PM = objctArr
)
	-----fn-------------------------------------------------------------------------------------------------------------------------------------------------
	--------------------------------------------------------------------------------------------------------------------------------------------------------
on mlbx_PCM_PolyCountList selectionEnd do
with undo on 
(
clearSelection()
local SelArr = #()
for s in mlbx_PCM_PolyCountList.selection do (join SelArr processObjects_PM[s])
ATfn_.SelectInGroups SelArr
redrawViews()
)
	--------------------------------------------------------------------------------------------------------------------------------------------------------
on btn_PCM_Refresh pressed do (fn_GetPolycount())
	--------------------------------------------------------------------------------------------------------------------------------------------------------
on rdbtn_PCM_SelectedOrScene changed state do (fn_GetPolycount())
	--------------------------------------------------------------------------------------------------------------------------------------------------------
on rollout_PolyCountManager resized size do
	(
	mlbx_PCM_PolyCountList.width = size[1] - 0
	mlbx_PCM_PolyCountList.height = size[2] - 32
	)
	-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
on rollout_PolyCountManager open do
	(
	if (hasINISetting iniFile rollTitle) do (ATfn_.LoadRolloutINI rollout_PolyCountManager iniFile ExcludedControls)
	mlbx_PCM_PolyCountList.height = rollout_PolyCountManager.height - 32
	if floater_AssemblyTool != undefined do (floater_AssemblyTool.rollouts[1].chbtn_TL_PolyCountManager.checked = true)
	fn_GetPolycount()
	callbacks.addScript #nodePostDelete "rollout_PolyCountManager.fn_GetPolycount()" id:#ATcallbacks_PCM_
	callbacks.addScript #filePostOpenProcess "rollout_PolyCountManager.fn_GetPolycount()" id:#ATcallbacks_PCM_
	)
	-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
on rollout_PolyCountManager close do 
	(
	if floater_AssemblyTool != undefined do (floater_AssemblyTool.rollouts[1].chbtn_TL_PolyCountManager.checked = false)
	ATfn_.SaveRolloutINI rollout_PolyCountManager iniFile ExcludedControls
	callbacks.removeScripts id:#ATcallbacks_PCM_
	rollout_PolyCountManager = undefined
	gc light:true
	)
)
	----================================================================================================================================
rollout_PolyCountManager = ATfn_.CreateRollout rollout_PolyCountManager iniFile rollTitle roll0W roll0H \
RStyle:#(#style_resizing, #style_titlebar, #style_sysmenu, #style_minimizebox, #style_maximizebox)
-------------------------------------------------------------------------------------------------------------
)
