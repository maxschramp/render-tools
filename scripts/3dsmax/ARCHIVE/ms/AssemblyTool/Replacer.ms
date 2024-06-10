	-----------------
	--^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
(if ATIcons == undefined then (fileIn ((getFilenamePath(getThisScriptFilename())) + "AssemblyToolIcons.ms")))
(if ATfn_ == undefined then (fileIn ((getFilenamePath(getThisScriptFilename())) + "AssemblyToolStruct.ms")))
	--^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
(
Global floater_Replacer
Global floater_AssemblyTool
try (if floater_Replacer.dialogBar then (cui.UnRegisterDialogBar floater_Replacer); closeRolloutFloater floater_Replacer) catch()
	-------------------------------------------------------------------------------------------------------------------
local floaterTitle = "Replacer"
local iniPath = (getFilenamePath (getThisScriptFilename())) + "INI\\"
local iniFile = iniPath + "Replacer_Settings.ini"
local fl0W = 220; local fl0H = (ATfn_.GetINI 0 iniFile floaterTitle "LastSize" [fl0W,265])[2]
-- local fl0P = ATfn_.GetINI 0 iniFile floaterTitle "LastPosition" [50,50]
local colCHBX = ATfn_.GetINI 0 (iniPath + "AssemblyTool_Settings.ini") "Preferences" "color_PS_ChBxColor" [255,156,0]
local ExcludedControls = #("tmr_RR_prgrsFade", "btn_RR_DockLeft", "btn_RR_DockFloat", "btn_RR_DockRight", \
	"prgrs_RR_ProBar")
	----=Replacer=====================================================================================================
rollout rollout_RR_ "Replacer"
(
local yp1 = #(8, 49, 90, 46, 136, 223)
local DockX = 181; local DockW = 13
button btn_RR_DockLeft "<" pos:[DockX-DockW,0] width:DockW height:10 tooltip:" Dock Left "
button btn_RR_DockFloat "::" pos:[DockX,0] width:DockW height:10 tooltip:" Float "
button btn_RR_DockRight ">" pos:[DockX+DockW,0] width:DockW height:10 tooltip:" Dock Right "
on btn_RR_DockLeft pressed do (ATfn_.DockFloaterSide floater_Replacer iniFile "left")
on btn_RR_DockRight pressed do (ATfn_.DockFloaterSide floater_Replacer iniFile "right")
on btn_RR_DockFloat pressed do (ATfn_.DockFloaterFloat floater_Replacer iniFile fl0W fl0H)
	-------
local xp1 = 5
GroupBox grp_RR_Position "Position" pos:[xp1,yp1[1]] width:75 height:40
checkButton chbtn_RR_PositionXTogg "X" pos:[xp1+4,yp1[1]+15] width:20 height:20 checked:true highlightColor:[204,64,64] tooltip:" X Position \n Rmb - All Axis Toggle "
checkButton chbtn_RR_PositionYTogg "Y" pos:[xp1+27,yp1[1]+15] width:20 height:20 checked:true highlightColor:[63,164,63] tooltip:" Y Position \n Rmb - All Axis Toggle "
checkButton chbtn_RR_PositionZTogg "Z" pos:[xp1+50,yp1[1]+15] width:20 height:20 checked:true highlightColor:[70,114,255] tooltip:" Z Position \n Rmb - All Axis Toggle "

local xr1 = xp1
GroupBox grp_RR_Rotation "Rotation" pos:[xr1,yp1[2]] width:75 height:40
checkButton chbtn_RR_RotationXTogg "X" pos:[xr1+4,yp1[2]+15] width:20 height:20 checked:true highlightColor:[204,64,64] tooltip:" X Rotation \n Rmb - All Axis Toggle "
checkButton chbtn_RR_RotationYTogg "Y" pos:[xr1+27,yp1[2]+15] width:20 height:20 checked:true highlightColor:[63,164,63] tooltip:" Y Rotation \n Rmb - All Axis Toggle "
checkButton chbtn_RR_RotationZTogg "Z" pos:[xr1+50,yp1[2]+15] width:20 height:20 checked:true highlightColor:[70,114,255] tooltip:" Z Rotation \n Rmb - All Axis Toggle "

local xs1 = xp1
GroupBox grp_RR_Scale "Scale" pos:[xs1,yp1[3]] width:75 height:40
checkButton chbtn_RR_ScaleXTogg "X" pos:[xs1+4,yp1[3]+15] width:20 height:20 checked:true highlightColor:[204,64,64] tooltip:" X Scale \n Rmb - All Axis Toggle "
checkButton chbtn_RR_ScaleYTogg "Y" pos:[xs1+27,yp1[3]+15] width:20 height:20 checked:true highlightColor:[63,164,63] tooltip:" Y Scale \n Rmb - All Axis Toggle "
checkButton chbtn_RR_ScaleZTogg "Z" pos:[xs1+50,yp1[3]+15] width:20 height:20 checked:true highlightColor:[70,114,255] tooltip:" Z Scale \n Rmb - All Axis Toggle "

local xp2 = 88
radiobuttons rdbtn_RR_ByPivotCenter "" labels:#("Pivot","Center") pos:[xp2,yp1[4]] columns:2 offsets:#([0,0],[-2,0]) default:1 tooltip:" Replace By Pivot Or Center "
checkButton chbtn_RR_DeleteOriginal "" pos:[xp2+1,yp1[4]+30] width:14 height:14 checked:true highlightColor:colCHBX toolTip:" Delete Replaced Objects Toggle "
label lbl_RR_DeleteOriginal "Delete Replaced" pos:[xp2+19,yp1[4]+30] tooltip:chbtn_RR_DeleteOriginal.tooltip
radiobuttons rdbtn_RR_CopyOrInstance "" labels:#("Copy","Instance") pos:[xp2,yp1[4]+60] columns:2 offsets:#([0,0],[-7,0]) default:2 tooltip:" Replace By Copy Or Instance "

button btn_RR_PickAndReplace "Pick And Replace" pos:[5,yp1[5]] width:(fl0W-22) height:39 tooltip:" Pick Object And Replace Selected "

button btn_RR_MultiPickAndReplace "Multiple Pick And Replace" pos:[5,yp1[5]+42] width:(fl0W-22) height:39 tooltip:" Multiple Pick Objects \n And Randomly Replace Selected "

progressBar prgrs_RR_ProBar pos:[0,yp1[6]] width:(fl0W-13) height:10 value:0 color:orange
timer tmr_RR_prgrsFade interval:((3*1000/68) as integer) active:false
on tmr_RR_prgrsFade tick do (ATfn_.ProgBarFade prgrs_RR_ProBar tmr_RR_prgrsFade)
	-----fn------------------------------------------------------------------------------------------------------------
FN fn_Replace MultiplePick: =
(
local byArr = #()
local outArr = #()
local IsoState = IsolateSelection.IsolateSelectionModeActive(); local IsoArr = #(); if IsoState do (for o in objects where (o.isHidden) do append IsoArr o); local vTM = viewport.getTM(); local vFDist = viewport.getFocalDistance()
local toArr = ATfn_.InstancesAppend (ATfn_.GetNHH (selection as array) true)
if toArr.count == 0 do (return messagebox "Select Objects To Replace." title:" Replacer")
for gh in toArr where (isGroupHead gh) do (setGroupOpen gh false)
local pickArr = #()
if MultiplePick
then
	(
	while isValidNode (pickObj = pickObject pickFrozen:false rubberBand:selection.center)
		do (appendIfUnique pickArr pickObj)
	)
else
	(
	if isValidNode (pickObj = pickObject pickFrozen:false rubberBand:selection.center)
		do (appendIfUnique pickArr pickObj)
	)
if pickArr.count > 0 do
	(
	local CPTM = getCommandPanelTaskMode()
	setCommandPanelTaskMode #create
	disablesceneredraw()
	byArr = (ATfn_.GetNHH pickArr true)
	for gh in byArr where (isGroupHead gh) do (setGroupOpen gh false)
	tmr_RR_prgrsFade.active = false; prgrs_RR_ProBar.value = 0; prgrs_RR_ProBar.color = orange
	for toObj in toArr do
		(
-- 		local toRot = quatToEuler toObj.rotation
		local toRot = quatToEuler2 toObj.rotation.controller.value
		local toScl = toObj.scale
-- 		local toPos = toObj.pos
		local toPos = case rdbtn_RR_ByPivotCenter.state of
			(
			1: toObj.pivot
			2: toObj.center
			)
		if chbtn_RR_DeleteOriginal.checked do (delete toObj)
		local byObj = ATfn_.CopyObject (byArr[random 1 byArr.count]) IInstance:(rdbtn_RR_CopyOrInstance.state == 2) Frozen:false Hidden:false
		local byPCSh = byObj.pivot - byObj.center
		if rdbtn_RR_ByPivotCenter.state == 2 do (CenterPivot byObj)
		append outArr byObj
		---rotation
-- 		local byRot = quatToEuler byObj.rotation
		local byRot = quatToEuler2 byObj.rotation.controller.value
		local XRot = if chbtn_RR_RotationXTogg.checked then toRot.X else byRot.X
		local YRot = if chbtn_RR_RotationYTogg.checked then toRot.Y else byRot.Y
		local ZRot = if chbtn_RR_RotationZTogg.checked then toRot.Z else byRot.Z
-- 		byObj.rotation.controller.value = (quat 0 0 0 0)
-- 		in coordsys local (byObj.rotation = eulerAngles -XRot -YRot -ZRot)
		byObj.rotation.controller[1].value = XRot
		byObj.rotation.controller[2].value = YRot
		byObj.rotation.controller[3].value = ZRot
		---scale
		local byScl = byObj.scale
		local XScl = if chbtn_RR_ScaleXTogg.checked then toScl.X else byScl.X
		local YScl = if chbtn_RR_ScaleYTogg.checked then toScl.Y else byScl.Y
		local ZScl = if chbtn_RR_ScaleZTogg.checked then toScl.Z else byScl.Z
		byObj.scale = [1,1,1]
		in coordsys local (byObj.scale = [XScl,YScl,ZScl])
-- 		in coordsys local scale byObj [XScl,YScl,ZScl]
		---position
		local XPos = if chbtn_RR_PositionXTogg.checked then toPos.X else byObj.pos.X
		local YPos = if chbtn_RR_PositionYTogg.checked then toPos.Y else byObj.pos.Y
		local ZPos = if chbtn_RR_PositionZTogg.checked then toPos.Z else byObj.pos.Z
		byObj.pos = [XPos, YPos, ZPos]
-- 		in coordsys local move byObj [XPos, YPos, ZPos]
		if rdbtn_RR_ByPivotCenter.state == 2 do (byObj.pivot += byPCSh)
		prgrs_RR_ProBar.value = 100.0*(findItem toArr toObj)/(toArr.count)
		)
	prgrs_RR_ProBar.color = green; tmr_RR_prgrsFade.active = true
	setCommandPanelTaskMode CPTM
	enablesceneredraw()
	if IsoState and not IsolateSelection.IsolateSelectionModeActive() do
		(select (ATfn_.ArraysDifference objects IsoArr); IsolateSelection.EnterIsolateSelectionMode(); viewport.setTM vTM; viewport.setFocalDistance vFDist)
	select outArr
	completeredraw()
	gc light:true
-- 	gc()
	)
)
	-----fn------------------------------------------------------------------------------------------------------------
	-------------------------------------------------------------------------------------------------------------------
on btn_RR_PickAndReplace pressed do with undo on (fn_Replace MultiplePick:false)
	-------------------------------------------------------------------------------------------------------------------
on btn_RR_MultiPickAndReplace pressed do with undo on (fn_Replace MultiplePick:true)
	-------------------------------------------------------------------------------------------------------------------
local ctrlsPos = #(chbtn_RR_PositionXTogg, chbtn_RR_PositionYTogg, chbtn_RR_PositionZTogg)
on chbtn_RR_PositionXTogg rightclick do (local state = chbtn_RR_PositionXTogg.checked; for ctrl in ctrlsPos do ctrl.checked = not state)
on chbtn_RR_PositionYTogg rightclick do (local state = chbtn_RR_PositionYTogg.checked; for ctrl in ctrlsPos do ctrl.checked = not state)
on chbtn_RR_PositionZTogg rightclick do (local state = chbtn_RR_PositionZTogg.checked; for ctrl in ctrlsPos do ctrl.checked = not state)
	-------------------------------------------------------------------------------------------------------------------
local ctrlsRot = #(chbtn_RR_RotationXTogg, chbtn_RR_RotationYTogg, chbtn_RR_RotationZTogg)
on chbtn_RR_RotationXTogg rightclick do (local state = chbtn_RR_RotationXTogg.checked; for ctrl in ctrlsRot do ctrl.checked = not state)
on chbtn_RR_RotationYTogg rightclick do (local state = chbtn_RR_RotationYTogg.checked; for ctrl in ctrlsRot do ctrl.checked = not state)
on chbtn_RR_RotationZTogg rightclick do (local state = chbtn_RR_RotationZTogg.checked; for ctrl in ctrlsRot do ctrl.checked = not state)
	-------------------------------------------------------------------------------------------------------------------
local ctrlsScl = #(chbtn_RR_ScaleXTogg, chbtn_RR_ScaleYTogg, chbtn_RR_ScaleZTogg)
on chbtn_RR_ScaleXTogg rightclick do (local state = chbtn_RR_ScaleXTogg.checked; for ctrl in ctrlsScl do ctrl.checked = not state)
on chbtn_RR_ScaleYTogg rightclick do (local state = chbtn_RR_ScaleYTogg.checked; for ctrl in ctrlsScl do ctrl.checked = not state)
on chbtn_RR_ScaleZTogg rightclick do (local state = chbtn_RR_ScaleZTogg.checked; for ctrl in ctrlsScl do ctrl.checked = not state)
	-------------------------------------------------------------------------------------------------------------------
on rollout_RR_ open do
	(
	if floater_AssemblyTool != undefined do (floater_AssemblyTool.rollouts[1].chbtn_TL_Replacer.checked = true)
	)
on rollout_RR_ close do
	(
	if floater_AssemblyTool != undefined do (floater_AssemblyTool.rollouts[1].chbtn_TL_Replacer.checked = false)
	ATfn_.SaveFloaterINI floater_Replacer iniFile ExcludedControls
	floater_Replacer = undefined
	)
)
	----===============================================================================================================
floater_Replacer = ATfn_.CreateFloater floater_Replacer iniFile fl0W fl0H floaterTitle #(rollout_RR_)
on execute do
	(
	if (hasINISetting iniFile floaterTitle) do (ATfn_.LoadFloaterINI floater_Replacer iniFile ExcludedControls)
	)
)