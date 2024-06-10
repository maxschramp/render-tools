	-----------------
	--^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
(if ATIcons == undefined then (fileIn ((getFilenamePath(getThisScriptFilename())) + "AssemblyToolIcons.ms")))
(if ATfn_ == undefined then (fileIn ((getFilenamePath(getThisScriptFilename())) + "AssemblyToolStruct.ms")))
	--^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
(
Global floater_Scatter
Global floater_AssemblyTool
try (if floater_Scatter.dialogBar then (cui.UnRegisterDialogBar floater_Scatter); closeRolloutFloater floater_Scatter) catch()
	-------------------------------------------------------------------------------------------------------------------
local floaterTitle = "Scatter"
local iniPath = (getFilenamePath (getThisScriptFilename())) + "INI\\"
local iniFile = iniPath + "Scatter_Settings.ini"
local fl0W = 220; local fl0H = (ATfn_.GetINI 0 iniFile floaterTitle "LastSize" [fl0W,525])[2]
local colCHBX = ATfn_.GetINI 0 (iniPath + "AssemblyTool_Settings.ini") "Preferences" "color_PS_ChBxColor" [255,156,0]
local ExcludedControls = #("prgrs_SC_ProBar", "tmr_SC_prgrsFade", "btn_SC_DockLeft", "btn_SC_DockFloat", "btn_SC_DockRight",
	"mlbx_SC_ToScatter", "mlbx_SC_ScatterOn")
	-------------------------------------------------------------------------------------------------------------------
local InputArr = #()
local ToScatterList = #()
local ScatterOnList = #()
local LastProcessed = #()
	----=Scatter==========================================================================================================================
rollout rollout_SC_ floaterTitle
(
local yp1 = #(20, 160, 284, 388, 410, 470)
local DockX = 181; local DockW = 13; local rh = 3; local hc = [160,160,160]
button btn_SC_DockLeft "<" pos:[DockX-DockW,0] width:DockW height:10 tooltip:" Dock Left "
button btn_SC_DockFloat "::" pos:[DockX,0] width:DockW height:10 tooltip:" Float "
button btn_SC_DockRight ">" pos:[DockX+DockW,0] width:DockW height:10 tooltip:" Dock Right "
on btn_SC_DockLeft pressed do (ATfn_.DockFloaterSide floater_Scatter iniFile "left")
on btn_SC_DockRight pressed do (ATfn_.DockFloaterSide floater_Scatter iniFile "right")
on btn_SC_DockFloat pressed do (ATfn_.DockFloaterFloat floater_Scatter iniFile fl0W fl0H)
	-------
label lbl_SC_ToScater "Objects :" pos:[2,yp1[1]-16] tooltip:" Scatter With Objects "
radiobuttons rdbtn_SC_SelectedOrList "" labels:#("Selected","List") pos:[50,yp1[1]-16] columns:2 offsets:#([0,0],[5,0]) default:2 tooltip:" Scatter With Selected Scene Objects \n Or Scatter With Objects In List "
button btn_SC_ToScatterAddObj "+" width:22 height:21 pos:[0,yp1[1]] images:ATIcons[1] tooltip:" Add Scattered Objects "
button btn_SC_ToScatterRemoveObj "-" width:22 height:21 pos:[26,yp1[1]] images:ATIcons[2] tooltip:" Remove Objects From Scattered "
button btn_SC_ToScatterRemoveAllObj "_" width:22 height:21 pos:[52,yp1[1]] images:ATIcons[3] tooltip:" Remove All Scattered Objects From List "
button btn_SC_ToScatterSelectAll "All" width:22 height:21 pos:[78,yp1[1]] images:ATIcons[4] tooltip:" Select All Scattered Objects "
multiListBox mlbx_SC_ToScatter items:#() width:(fl0W-16) height:7 pos:[2,yp1[1]+22] selection:0 tooltip:" Scattered Objects "

label lbl_SC_ScatterOn "Surface :" pos:[2,yp1[2]-16] tooltip:" Scatter On Objects "
button btn_SC_ScatterOnAddObj "+" width:22 height:21 pos:[0,yp1[2]] images:ATIcons[1] tooltip:" Add Ground Objects "
button btn_SC_ScatterOnRemoveObj "-" width:22 height:21 pos:[26,yp1[2]] images:ATIcons[2] tooltip:" Remove Objects From Ground "
button btn_SC_ScatterOnRemoveAllObj "_" width:22 height:21 pos:[52,yp1[2]] images:ATIcons[3] tooltip:" Remove All Ground Objects From List "
button btn_SC_ScatterOnSelectAll "All" width:22 height:21 pos:[78,yp1[2]] images:ATIcons[4] tooltip:" Select All Ground Objects "
multilistBox mlbx_SC_ScatterOn items:#() width:(fl0W-16) height:7 pos:[2,yp1[2]+22] selection:0 tooltip:" For Scattered On Them Objects "

radiobuttons rdbtn_SC_CopyOrInstance "" labels:#("Copy","Instance") pos:[5,yp1[3]] columns:2 offsets:#([0,0],[-7,0]) default:2 tooltip:" Copy Or Instance Scatter Objects "

spinner spnr_SC_PObjCount "Count:" pos:[22,yp1[3]+22] width:64 range:[1,9999,50] type:#integer scale:1 toolTip:" Count Of Objects Used "
spinner spnr_SC_PObjOffset "Offset:" pos:[110,yp1[3]+22] width:90 range:[-9999,9999,0] type:#float scale:0.1 toolTip:" Offset By Z "

checkButton chbtn_SC_PObjMatchFace "" pos:[4,yp1[3]+42] width:14 height:14 checked:false highlightColor:colCHBX toolTip:" Align Scattered Object To Surface Normal "
label lbl_SC_PObjMatchFace "Align Object To Surface Normal" pos:[22,yp1[3]+42] toolTip:chbtn_SC_PObjMatchFace.toolTip

checkButton chbtn_SC_PivotToCenterZMin "" pos:[4,yp1[3]+62] width:14 height:14 checked:false highlightColor:colCHBX toolTip:" Set Pivot To Objects Center And Z Minimum "
label lbl_SC_PivotToCenterZMin "Pivot To Center Z Minimum" pos:[22,yp1[3]+62] toolTip:chbtn_SC_PivotToCenterZMin.toolTip

checkButton chbtn_SC_RandomRotate "" pos:[4,yp1[3]+82] width:14 height:14 checked:false highlightColor:colCHBX tooltip:" Random Rotate Models 90, -90 or 180 Degrees (Z Axis) "
label lbl_SC_RandomRotate "Random Rotate" pos:[22,yp1[3]+82] tooltip:chbtn_SC_RandomRotate.tooltip
spinner spnr_SC_RandomRotate "" pos:[103,yp1[3]+82] width:50 range:[0,100,100] type:#integer scale:1 toolTip:" Percentage Of Models That Will Be Rotated "
label lbl_SC_Percent "%" pos:[157,yp1[3]+82]

checkButton chbtn_SC_SetWireColorState pos:[4,yp1[4]] width:14 height:14 highlightColor:colCHBX tooltip:" Set Uniform Wire Color To Processed Objects "
label lbl_SC_SetWireColorState "Set Uniform Wire Color To Processed" pos:[22,yp1[4]]

button btn_SC_ScatterObjects "Scatter" pos:[0,yp1[5]] width:73 height:39 tooltip:" Scatter Objects "
button btn_SC_ReplaceSelected "Replace" pos:[75,yp1[5]] width:65 height:39 tooltip:" Randomly Replace Selected \n With Objects From List "
button btn_SC_ReScatterSelected "Rescatter" pos:[142,yp1[5]] width:65 height:39 enabled:true tooltip:" Rescatter Selected Objects (No Copy) "

progressBar prgrs_SC_ProBar pos:[0,yp1[5]+42] width:(fl0W-13) height:10 value:0 color:orange
timer tmr_SC_prgrsFade interval:((3*1000/68) as integer) active:false
on tmr_SC_prgrsFade tick do (ATfn_.ProgBarFade prgrs_SC_ProBar tmr_SC_prgrsFade)

button btn_SC_SelLastProcessed "Select Last Processed Objects" pos:[1,yp1[6]] width:(fl0W-15) height:23
	---------------------------------------------------------------------------------------------------------------------
	-----fn------------------------------------------------------------------------------------------------------------
FN fn_compareByRayZMaxDecrease r1 r2 =
(
local r1ZMax = r1.pos.z
local r2ZMax = r2.pos.z
case of
	(
	(r1ZMax > r2ZMax): -1
	(r1ZMax < r2ZMax): 1
	default: 0
	)
)
	-----fn------------------------------------------------------------------------------------------------------------
FN fn_RandomRotate Arr =
(
if chbtn_SC_RandomRotate.checked do
	(
	local angleArr = #(-90, 90, 180)
	for objct in (ATfn_.RandomFromArray Arr spnr_SC_RandomRotate.value) do (objct.transform = (rotateZmatrix angleArr[random 1 3]) * objct.transform)
	)
)
	-----fn------------------------------------------------------------------------------------------------------------
FN fn_DefineInputArr =
(
if rdbtn_SC_SelectedOrList.state == 1
then
	(
	InputArr = ATfn_.GetNHH (selection as array) true
	if InputArr.count == 0 do
		(
		ATfn_.messageNS()
		return false
		)
	)
else
	(
	ToScatterList = for o in ToScatterList where isValidNode o collect o
	mlbx_SC_ToScatter.items = for o in ToScatterList collect o.name
	InputArr = deepCopy ToScatterList
	if InputArr.count == 0 do
		(
		messageBox "Objects List Is Empty." title:" Assembly Tool" beep:false
		return false
		)
	)
ScatterOnList = for o in ScatterOnList where isValidNode o collect o
mlbx_SC_ScatterOn.items = for o in ScatterOnList collect o.name
if ScatterOnList.count == 0 do
	(
	messageBox "Surface List Is Empty." title:" Assembly Tool" beep:false
	return false
	)
return true
)
	-----fn------------------------------------------------------------------------------------------------------------
	---------------------------------------------------------------------------------------------------------------------
on btn_SC_ScatterObjects pressed do with undo on
(
if not fn_DefineInputArr() do return false
local OnCount = ScatterOnList.count; local ToCount = InputArr.count
local Count = spnr_SC_PObjCount.value
local Offset = spnr_SC_PObjOffset.value
local StopperLimit = 1000
clearSelection()
local ScatteredObjs = #()
local OnMinMax = ATfn_.GetMinMax ScatterOnList
tmr_SC_prgrsFade.active = false; prgrs_SC_ProBar.value = 0; prgrs_SC_ProBar.color = orange
for n=1 to Count do
	(
-- 	if (((maxVersion())[1] / 1000) >= 13) do windows.processPostedMessages()
	if keyboard.escPressed then exit
	local GoGo = true
	local Stopper = 1
	local objScatter = undefined
	do (
		Stopper += 1
		local SearchCoord = [(random OnMinMax[3][1] OnMinMax[4][1]), (random OnMinMax[3][2] OnMinMax[4][2]), (OnMinMax[4][3] + 100)]
		local SearchRay = ray SearchCoord [0,0,-1]
		local IntRayArr = #()
		for objOn in ScatterOnList do
			(
			local IntRay = IntersectRay objOn SearchRay
			if IntRay != undefined do (append IntRayArr IntRay)
			)
		if IntRayArr.count > 0 do
			(
			qSort IntRayArr fn_compareByRayZMaxDecrease
			objScatter = ATfn_.CopyObject InputArr[random 1 ToCount] IInstance:(rdbtn_SC_CopyOrInstance.state == 2) Frozen:false Hidden:false
			if chbtn_SC_PivotToCenterZMin.checked do (ATfn_.SetPivot #(objScatter) 0 0 1 true)
			objScatter.pos = IntRayArr[1].pos
			if chbtn_SC_PObjMatchFace.checked then objScatter.dir = IntRayArr[1].dir
-- 			objScatter.pos.Z += Offset
			in coordsys #local objScatter.pos.z += Offset
			GoGo = false
			append ScatteredObjs objScatter
			)
		) while (GoGo and Stopper < StopperLimit)
	prgrs_SC_ProBar.value = 100.0*n/Count
	redrawviews()
	)
fn_RandomRotate ScatteredObjs
select ScatteredObjs
LastProcessed = deepcopy ScatteredObjs
-- ResetPivot ScatteredObjs
-- ResetPivot InputArr
if chbtn_SC_SetWireColorState.checked do ((ATfn_.GetArrayByHeads ScatteredObjs ObjectsOnly:false).wirecolor = ATfn_.RandomColor())
redrawviews()
prgrs_SC_ProBar.color = green; tmr_SC_prgrsFade.active = true
-- (dotNetClass "System.Media.SystemSounds").Asterisk.Play()
)
	---------------------------------------------------------------------------------------------------------------------
on btn_SC_ReScatterSelected pressed do with undo on
(
if not fn_DefineInputArr() do return false
-- local ReScatterArr = ATfn_.ArraysDifference InputArr ScatterOnList
local ReScatterArr = ATfn_.ArraysDifference (ATfn_.GetNHH (selection as array) true) ScatterOnList
local OnCount = ScatterOnList.count; local ReCount = ReScatterArr.count
local Offset = spnr_SC_PObjOffset.value
local StopperLimit = 1000
clearSelection()
local ScatteredObjs = #()
local OnMinMax = ATfn_.GetMinMax ScatterOnList
for o in ReScatterArr do o.rotation.controller.value = (quat 0 0 0 0)
if chbtn_SC_PivotToCenterZMin.checked do (ATfn_.SetPivot ReScatterArr 0 0 1 true)
tmr_SC_prgrsFade.active = false
prgrs_SC_ProBar.value = 0
prgrs_SC_ProBar.color = orange
for n=1 to ReCount do
	(
-- 	if (((maxVersion())[1] / 1000) >= 13) do windows.processPostedMessages()
	if keyboard.escPressed then exit
	local GoGo = true
	local Stopper = 1
	local objScatter = ReScatterArr[n]
	do (
		Stopper += 1
		local SearchCoord = [(random OnMinMax[3][1] OnMinMax[4][1]), (random OnMinMax[3][2] OnMinMax[4][2]), (OnMinMax[4][3] + 100)]
		local SearchRay = ray SearchCoord [0,0,-1]
		local IntRayArr = #()
		for objOn in ScatterOnList do
			(
			local IntRay = IntersectRay objOn SearchRay
			if IntRay != undefined do (append IntRayArr IntRay)
			)
		if IntRayArr.count > 0 do
			(
			qSort IntRayArr fn_compareByRayZMaxDecrease
			objScatter.pos = IntRayArr[1].pos
			if chbtn_SC_PObjMatchFace.checked then objScatter.dir = IntRayArr[1].dir
-- 			objScatter.pos.Z += Offset
			in coordsys #local objScatter.pos.z += Offset
			GoGo = false
			append ScatteredObjs objScatter
-- 			redrawviews()
			)
		) while (GoGo and Stopper < StopperLimit)
	prgrs_SC_ProBar.value = 100.0*n/ReCount
	redrawviews()
	)
fn_RandomRotate ScatteredObjs
select ScatteredObjs
LastProcessed = deepcopy ScatteredObjs
-- ResetPivot ScatteredObjs
-- ResetPivot ReScatterArr
if chbtn_SC_SetWireColorState.checked do ((ATfn_.GetArrayByHeads ScatteredObjs ObjectsOnly:false).wirecolor = ATfn_.RandomColor())
redrawviews()
prgrs_SC_ProBar.color = green
tmr_SC_prgrsFade.active = true
)
	---------------------------------------------------------------------------------------------------------------------
on btn_SC_ReplaceSelected pressed do with undo on
(
if not fn_DefineInputArr() do return false
local ReplacedArr = ATfn_.ArraysDifference (ATfn_.GetNHH (selection as array) true) ScatterOnList
ReplacedArr = ATfn_.ArraysDifference ReplacedArr ToScatterList
if ReplacedArr.count == 0 do return (messageBox "Select Scene Objects Not Contained In Objects List And Surface List." title:" Scatter" beep:false)
-- for o in ReplacedArr do o.rotation.controller.value = (quat 0 0 0 0)
-- if chbtn_SC_PivotToCenterZMin.checked do (ATfn_.SetPivot ReplacedArr 0 0 1 true)
local rCount = ReplacedArr.count
tmr_SC_prgrsFade.active = false; prgrs_SC_ProBar.value = 0; prgrs_SC_ProBar.color = orange
-- local ReplacedTMArr = for o in ReplacedArr collect o.transform
local ReplacedPosRotArr = for o in ReplacedArr collect #(o.rotation, o.pos)
delete ReplacedArr
-- for o in ToScatterList do o.rotation.controller.value = (quat 0 0 0 0)
if chbtn_SC_PivotToCenterZMin.checked do (ATfn_.SetPivot ToScatterList 0 0 1 true)
local ScatteredArr = #()
for n=1 to rCount do
	(
-- 	if (((maxVersion())[1] / 1000) >= 13) do windows.processPostedMessages()
	local objScatter = ATfn_.CopyObject ToScatterList[random 1 ToScatterList.count] IInstance:(rdbtn_SC_CopyOrInstance.state == 2) Frozen:false Hidden:false
-- 	objScatter.transform = ReplacedTMArr[n]
	objScatter.rotation = ReplacedPosRotArr[n][1]; objScatter.pos = ReplacedPosRotArr[n][2]
	append ScatteredArr objScatter
	redrawviews()
	prgrs_SC_ProBar.value = 100.0*n/rCount
	)
fn_RandomRotate ScatteredArr
select ScatteredArr
LastProcessed = deepcopy ScatteredArr
-- ResetPivot ToScatterList
if chbtn_SC_SetWireColorState.checked do ((ATfn_.GetArrayByHeads ScatteredArr ObjectsOnly:false).wirecolor = ATfn_.RandomColor())
prgrs_SC_ProBar.color = green; tmr_SC_prgrsFade.active = true
redrawviews()
)
	-----ScatterOn--------------------------------------------------------------------------------------------------------------
on mlbx_SC_ScatterOn selectionEnd do with undo off 
(
clearSelection()
ScatterOnList = ATfn_.ValidateArray ScatterOnList
mlbx_SC_ScatterOn.items = for o in ScatterOnList collect o.name
select (for s in mlbx_SC_ScatterOn.selection where isValidNode ScatterOnList[s] collect ScatterOnList[s])
forceCompleteRedraw()
)
on mlbx_SC_ScatterOn rightclick do with undo off (mlbx_SC_ScatterOn.selection = #{})
	-------------------------------------------------------------------------------------------------------------------
on btn_SC_ScatterOnSelectAll pressed do with undo off
(
ScatterOnList = ATfn_.ValidateArray ScatterOnList
select ScatterOnList
mlbx_SC_ScatterOn.items = for o in ScatterOnList collect o.name
)
	---------------------------------------------------------------------------------------------------------------------
on btn_SC_ScatterOnRemoveAllObj pressed do with undo off
(
ScatterOnList = #()
mlbx_SC_ScatterOn.items = #()
)
	---------------------------------------------------------------------------------------------------------------------
on btn_SC_ScatterOnRemoveObj pressed do with undo off
(
local selArr = ATfn_.GetGeometry (selection as array) VRProxy:false
if selArr.count == 0 do return ATfn_.messageNS()
ScatterOnList = ATfn_.ValidateArray ScatterOnList
ScatterOnList = ATfn_.ArraysDifference ScatterOnList selArr
mlbx_SC_ScatterOn.items = for o in ScatterOnList collect o.name
mlbx_SC_ScatterOn.selection = #{}
)
	---------------------------------------------------------------------------------------------------------------------
on btn_SC_ScatterOnAddObj pressed do with undo off
(
local selArr = ATfn_.GetGeometry (selection as array) VRProxy:false
if selArr.count == 0 do return ATfn_.messageNS()
ScatterOnList = ATfn_.ValidateArray ScatterOnList
ScatterOnList = ATfn_.ArraysSum ScatterOnList selArr
mlbx_SC_ScatterOn.items = for o in ScatterOnList collect o.name
)
	-----ToScatter--------------------------------------------------------------------------------------------------------------
on mlbx_SC_ToScatter selectionEnd do with undo off 
(
clearSelection()
ToScatterList = ATfn_.ValidateArray ToScatterList
mlbx_SC_ToScatter.items = for o in ToScatterList collect o.name
select (for s in mlbx_SC_ToScatter.selection where isValidNode ToScatterList[s] collect ToScatterList[s])
forceCompleteRedraw()
)
on mlbx_SC_ToScatter rightclick do with undo off (mlbx_SC_ToScatter.selection = #{})
	-------------------------------------------------------------------------------------------------------------------
on btn_SC_ToScatterSelectAll pressed do with undo off
(
ToScatterList = ATfn_.ValidateArray ToScatterList
select ToScatterList
mlbx_SC_ToScatter.items = for o in ToScatterList collect o.name
)
	---------------------------------------------------------------------------------------------------------------------
on btn_SC_ToScatterRemoveAllObj pressed do with undo off
(
ToScatterList = #()
mlbx_SC_ToScatter.items = #()
)
	---------------------------------------------------------------------------------------------------------------------
on btn_SC_ToScatterRemoveObj pressed do with undo off
(
local selArr = ATfn_.GetNHH (selection as array) true
if selArr.count == 0 do return ATfn_.messageNS()
ToScatterList = ATfn_.ValidateArray ToScatterList
ToScatterList = ATfn_.ArraysDifference ToScatterList selArr
mlbx_SC_ToScatter.items = for o in ToScatterList collect o.name
mlbx_SC_ToScatter.selection = #{}
)
	---------------------------------------------------------------------------------------------------------------------
on btn_SC_ToScatterAddObj pressed do with undo off
(
local selArr = ATfn_.GetNHH (selection as array) true
if selArr.count == 0 do return ATfn_.messageNS()
ToScatterList = ATfn_.ValidateArray ToScatterList
ToScatterList = ATfn_.ArraysSum ToScatterList selArr
mlbx_SC_ToScatter.items = for o in ToScatterList collect o.name
)
	---------------------------------------------------------------------------------------------------------------------
on btn_SC_SelLastProcessed pressed do with undo on (select (ATfn_.ValidateArray LastProcessed))
	---------------------------------------------------------------------------------------------------------------------
-- on rdbtn_SC_SelectedOrList changed state do (btn_SC_ReplaceSelected.enabled = state == 2; btn_SC_ReScatterSelected.enabled = state == 1)
	--^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
on rollout_SC_ open do
	(
	if floater_AssemblyTool != undefined do (floater_AssemblyTool.rollouts[1].chbtn_TL_Scatter.checked = true)
	)
on rollout_SC_ close do
	(
	if floater_AssemblyTool != undefined do (floater_AssemblyTool.rollouts[1].chbtn_TL_Scatter.checked = false)
	ATfn_.SaveFloaterINI floater_Scatter iniFile ExcludedControls
	floater_Scatter = undefined
	)
)
	----================================================================================================================================
floater_Scatter = ATfn_.CreateFloater floater_Scatter iniFile fl0W fl0H floaterTitle #(rollout_SC_)
on execute do
	(
	if (hasINISetting iniFile floaterTitle) do (ATfn_.LoadFloaterINI floater_Scatter iniFile ExcludedControls)
	)
)