	-----------------
	--^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
(if ATIcons == undefined then (fileIn ((getFilenamePath(getThisScriptFilename())) + "AssemblyToolIcons.ms")))
(if ATfn_ == undefined then (fileIn ((getFilenamePath(getThisScriptFilename())) + "AssemblyToolStruct.ms")))
	--^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
(
Global floater_DummyPlacer
Global floater_AssemblyTool
try (if floater_DummyPlacer.dialogBar then (cui.UnRegisterDialogBar floater_DummyPlacer); closeRolloutFloater floater_DummyPlacer) catch()
	-------------------------------------------------------------------------------------------------------------------
local floaterTitle = "Dummy Placer"
local iniPath = (getFilenamePath (getThisScriptFilename())) + "INI\\"
local iniFile = iniPath + "DummyPlacer_Settings.ini"
local fl0W = 220; local fl0H = (ATfn_.GetINI 0 iniFile floaterTitle "LastSize" [fl0W,425])[2]
local colCHBX = ATfn_.GetINI 0 (iniPath + "AssemblyTool_Settings.ini") "Preferences" "color_PS_ChBxColor" [255,156,0]
local ExcludedControls = #("prgrs_DP_ProBar", "tmr_DP_prgrsFade", "btn_DP_DockLeft", "btn_DP_DockFloat", "btn_DP_DockRight", \
	"chbtn_DP_DontAffectChildren", "spnr_DP_ResizeByRatio", "chbtn_DP_VisualTolerance", "color_DP_ToleranceColor", "spnr_DP_ToleranceOpacity")
	-------------------------------------------------------------------------------------------------------------------
local TolHelpArr = #()
	----=DummyPlacer==============================================================================================
rollout rollout_DP_ "Dummy Placer"
(
local yp1 = #(0, 30, 87, 152, 242, 265, 286, 329, 346, 371)
local DockX = 181; local DockW = 13
button btn_DP_DockLeft "<" pos:[DockX-DockW,0] width:DockW height:10 tooltip:" Dock Left "
button btn_DP_DockFloat "::" pos:[DockX,0] width:DockW height:10 tooltip:" Float "
button btn_DP_DockRight ">" pos:[DockX+DockW,0] width:DockW height:10 tooltip:" Dock Right "
on btn_DP_DockLeft pressed do (ATfn_.DockFloaterSide floater_DummyPlacer iniFile "left")
on btn_DP_DockRight pressed do (ATfn_.DockFloaterSide floater_DummyPlacer iniFile "right")
on btn_DP_DockFloat pressed do (ATfn_.DockFloaterFloat floater_DummyPlacer iniFile fl0W fl0H)
	-------
radiobuttons rdbtn_DP_SelectedOrAutodetect "" labels:#("Selected","Autodetect") pos:[4,yp1[1]+7] columns:2 offsets:#([0,0],[0,0]) default:1 tooltip:" Process Selected Objects As Group \n Or Autodetect Groups "

spinner spnr_DP_DetectTolerance "Detect Tolerance:" pos:[51,yp1[2]] width:95 range:[0,999999,0.] type:#float scale:.001 toolTip:" Autodetect Group of Objects Tolerance "
checkButton chbtn_DP_VisualTolerance "Preview" pos:[149,yp1[2]-2] width:52 height:21 highlightColor:colCHBX tooltip:" Detect Group of Objects Tolerance Preview "
colorpicker color_DP_ToleranceColor "Preview Diffuse" width:100 height:21 pos:[11,yp1[2]+18] color:AT_ToleranceHelperMaterial.Diffuse modal:false tooltip:" Tolerance Helper Material Diffuse Color "
spinner spnr_DP_ToleranceOpacity "Opacity" pos:[145,yp1[2]+22] width:55 range:[5,100,AT_ToleranceHelperMaterial.Opacity] type:#integer scale:1 toolTip:" Tolerance Helper Material Opacity "

GroupBox grp_DP_Size "Size" pos:[2,yp1[3]-15] width:(fl0W-16) height:60
radiobuttons rdbtn_DP_SizeOrFit "" labels:#("Set Size","Fit To Group") pos:[8,yp1[3]] columns:1 offsets:#([0,0],[0,6]) default:1 tooltip:" Set Dummy Size Value \n Or Fit To Group Size "
spinner spnr_DP_DummySize "" pos:[80,yp1[3]] width:70 range:[1,99999,10] type:#Integer scale:1 toolTip:" Dummy Size Value "

GroupBox grp_DP_Position "Position" pos:[2,yp1[4]-15] width:(fl0W-16) height:95
label lbl_DP_PPosOrigin "Origin" pos:[34,yp1[4]]
label lbl_DP_PPosMin "Min" pos:[85,yp1[4]]
label lbl_DP_PPosCenter "Center" pos:[120,yp1[4]]
label lbl_DP_PPosMax "Max" pos:[171,yp1[4]]
local LblPPosArr = #("","","","")
label lbl_DP_PPosX "X:" pos:[16,yp1[4]+19]
radiobuttons rdbtn_DP_PivotPositionX "" labels:LblPPosArr pos:[40,yp1[4]+18] columns:4 offsets:#([0,0],[6,0],[12,0],[16,0]) default:1 tooltip:" Dummy Or Pivot Position "
label lbl_DP_PPosY "Y:" pos:[16,yp1[4]+39]
radiobuttons rdbtn_DP_PivotPositionY "" labels:LblPPosArr pos:[40,yp1[4]+38] columns:4 offsets:#([0,0],[6,0],[12,0],[16,0]) default:1 tooltip:" Dummy Or Pivot Position "
label lbl_DP_PPosZ "Z:" pos:[16,yp1[4]+59]
radiobuttons rdbtn_DP_PivotPositionZ "" labels:LblPPosArr pos:[40,yp1[4]+58] columns:4 offsets:#([0,0],[6,0],[12,0],[16,0]) default:1 tooltip:" Dummy Or Pivot Position "

-- radiobuttons rdbtn_DP_PivotPosition "" labels:#("Center","World Origin","Z Minimum","Z 0") pos:[8,yp1[4]] columns:2 offsets:#([0,0],[0,0],[0,4],[0,4]) default:1 tooltip:" Dummy Or Pivot Position "

checkButton chbtn_DP_LinkToDummy "" pos:[4,yp1[5]] width:14 height:14 checked:false highlightColor:colCHBX tooltip:" Link Objects To Dummy "
label lbl_DP_LinkToDummy "Link Objects To Dummy" pos:[22,yp1[5]] tooltip:chbtn_DP_LinkToDummy.tooltip

checkButton chbtn_DP_DummyAutoName "" pos:[4,yp1[6]] width:14 height:14 checked:false highlightColor:colCHBX tooltip:" Get Dummy Name From Model (If Possible) "
label lbl_DP_DummyAutoName "Dummy Name From Model" pos:[22,yp1[6]] tooltip:chbtn_DP_DummyAutoName.tooltip

button btn_DP_CreateDummy "Create Dummies" pos:[2,yp1[7]] width:100 height:37
button btn_DP_RemoveDummy "Remove Dummies" pos:[106,yp1[7]] width:100 height:37

progressBar prgrs_DP_ProBar pos:[0,yp1[8]] width:(fl0W-13) height:10 value:0 color:orange
timer tmr_DP_prgrsFade interval:((3*1000/68) as integer) active:false
on tmr_DP_prgrsFade tick do (ATfn_.ProgBarFade prgrs_DP_ProBar tmr_DP_prgrsFade)

spinner spnr_DP_ResizeByRatio "Resize Dummies By Ratio: " pos:[115,yp1[9]+2] width:45 range:[0.1,99999,1] type:#float scale:0.001 toolTip:" Resize By Ratio "

checkButton chbtn_DP_DontAffectChildren "Don't Affect Children" pos:[0,yp1[10]] width:(fl0W-10) height:21 checked:(not maxOps.affectChildren) highlightColor:colCHBX tooltip:" Don't Affect Children "

-- button iconTect "" pos:[2,yp1[10]+50] width:100 height:100 images:ATIcons[62]
	-----fn------------------------------------------------------------------------------------------------------------
FN fn_delTolHelpers = with undo off (for o in TolHelpArr where isValidNode o do delete o; TolHelpArr = #(); chbtn_DP_VisualTolerance.checked = false)
	-----fn------------------------------------------------------------------------------------------------------------
	------------------------------------------
on chbtn_DP_VisualTolerance changed state do with undo off
(
local InArr = ATfn_.GetNotGroupHeads selection
if state
then
	(
	if InArr.count == 0 do (chbtn_DP_VisualTolerance.checked = false; return ATfn_.messageNS())
	TolHelpArr = ATfn_.CreateBoundingBoxes InArr baseName:"VisualToleranceHelper"
	TolHelpArr.material = AT_ToleranceHelperMaterial
	TolHelpArr.scale = [1. + spnr_DP_DetectTolerance.value, 1. + spnr_DP_DetectTolerance.value, 1. + spnr_DP_DetectTolerance.value]
	)
else (fn_delTolHelpers())
ATfn_.Refresh()
)
	-------------------------------------------------------------------------------------------------------------------
on spnr_DP_DetectTolerance changed val do with undo off
(
if chbtn_DP_VisualTolerance.checked and TolHelpArr.count != 0 do
	(for o in TolHelpArr do o.scale = [1 + val, 1 + val, 1 + val])
)	
	-------------------------------------------------------------------------------------------------------------------
on color_DP_ToleranceColor changed col do (AT_ToleranceHelperMaterial.Diffuse = col)
	-------------------------------------------------------------------------------------------------------------------
on spnr_DP_ToleranceOpacity changed val do with undo off (AT_ToleranceHelperMaterial.Opacity = val)
	-------------------------------------------------------------------------------------------------------------------
on btn_DP_CreateDummy pressed do with undo on
(
fn_delTolHelpers()
local DSVal = spnr_DP_DummySize.value
local InArr = for o in (selection as array) where (not o.isFrozen and not o.isHidden) collect o
local grps = (ATfn_.GetNHH selection false)[2]
if grps.count != 0 do (return ATfn_.messageGF())
local RebObjArr = for o in InArr where classOf o != Dummy collect o
if RebObjArr.count == 0 do return (ATfn_.messageNS())
local RebDumArr = for o in InArr where classOf o == Dummy collect o
for o in RebObjArr where o.parent != undefined and classOf o.parent == Dummy do appendIfUnique RebDumArr o.parent
for n=RebDumArr.count to 1 by -1 where RebDumArr[n].children.count == 0 do (delete RebDumArr[n]; deleteItem RebDumArr n)
local DGArr = #()
if rdbtn_DP_SelectedOrAutodetect.state == 1 or RebObjArr.count == 1
	then (DGArr = #(RebObjArr))
	else (DGArr = ATfn_.GroupCollect RebObjArr tolerance:spnr_DP_DetectTolerance.value)
-- for n=1 to DGArr.count do (DGArr[n].wirecolor = ATfn_.RandomColor())
tmr_DP_prgrsFade.active = false; prgrs_DP_ProBar.value = 0; prgrs_DP_ProBar.color = orange
local DumArr = #()
for n=1 to DGArr.count do
	(
	local DG = DGArr[n]
-- 	select DGArr[n]
-- 	local DG = selection
	local mmArr = ATfn_.GetMinMax DG
	local DGMin = mmArr[3]
	local DGMax = mmArr[4]
	local DGCenter = DGMin + (DGMax - DGMin)/2.
	local DumName = ""
	if chbtn_DP_DummyAutoName.checked
	then
		(
		if DG.count == 1
		then (DumName = DG[1].name)
		else
			(
			local fStr = FilterString DG[1].name "_"
			if fStr.count > 3 and fStr[1] == "SM"
				then (DumName = fStr[1] + "_" + fStr[2] + "_" + fStr[3] + "_01")
				else (DumName = uniquename "UndefinedName_" numDigits:2)
			)
		)
	else (DumName = uniquename "DummyGroup_" numDigits:2)
	local Dum = Dummy pos:DGCenter name:DumName
	append DumArr Dum
	local PPos = [0, 0, 0]
	PPos.x = case rdbtn_DP_PivotPositionX.state of
		(
		1: 0
		2: DGMin.x
		3: DGCenter.x
		4: DGMax.x
		)
	PPos.y = case rdbtn_DP_PivotPositionY.state of
		(
		1: 0
		2: DGMin.y
		3: DGCenter.y
		4: DGMax.y
		)
	PPos.z = case rdbtn_DP_PivotPositionZ.state of
		(
		1: 0
		2: DGMin.z
		3: DGCenter.z
		4: DGMax.z
		)
	if rdbtn_DP_SizeOrFit.state == 1
	then (Dum.boxsize = [DSVal, DSVal, DSVal]; Dum.pos = PPos)
	else (Dum.boxsize = DGMax - DGMin; Dum.pivot = PPos)
	if chbtn_DP_LinkToDummy.checked do (ATfn_.GetTopParentArray DG).parent = Dum
	prgrs_DP_ProBar.value = 100.0*n/(DGArr.count)
	)
select DumArr
prgrs_DP_ProBar.color = green; tmr_DP_prgrsFade.active = true
)
	-------------------------------------------------------------------------------------------------------------------
local RBRArr = #(); local RBRsizeArr = #()
	-------------
on spnr_DP_ResizeByRatio buttonDown do with undo on
(
RBRArr = #(); RBRsizeArr = #()
for d in selection where classOf d == Dummy do
	(append RBRArr d; append RBRsizeArr d.boxsize)
UNDO ON; for d in RBRArr do (d.boxsize = d.boxsize)   --- for undo
select RBRArr
)
	-------------
on spnr_DP_ResizeByRatio changed val do with undo on
(
for n=1 to RBRArr.count do (RBRArr[n].boxsize = RBRsizeArr[n] * val)
)
	-------------
on spnr_DP_ResizeByRatio buttonUp do (spnr_DP_ResizeByRatio.value = 1)
	-------------------------------------------------------------------------------------------------------------------
on btn_DP_RemoveDummy pressed do with undo on
(
local InArr = selection as array
if InArr.count == 0 do return (ATfn_.messageNS())
local DPArr = #()
for o in InArr where classOf o == Dummy do appendIfUnique DPArr o
-- for o in InArr do (if o.parent != undefined and classOf o.parent == Dummy do appendIfUnique DPArr o.parent)
if DPArr.count > 0 do delete DPArr
)
	-------------------------------------------------------------------------------------------------------------------
on rdbtn_DP_SelectedOrAutodetect changed state do (#(spnr_DP_DetectTolerance, chbtn_DP_VisualTolerance, color_DP_ToleranceColor, spnr_DP_ToleranceOpacity).enabled = state == 2)
	-------------------------------------------------------------------------------------------------------------------
on chbtn_DP_DontAffectChildren changed state do (maxOps.affectChildren = not state)
	-------------------------------------------------------------------------------------------------------------------
	----===============================================================================================================
on rollout_DP_ open do
	(
	if floater_AssemblyTool != undefined do try(floater_AssemblyTool.rollouts[1].chbtn_TL_DummyPlacer.checked = true)catch()
	)
on rollout_DP_ close do
	(
	if floater_AssemblyTool != undefined do try(floater_AssemblyTool.rollouts[1].chbtn_TL_DummyPlacer.checked = false)catch()
	ATfn_.SaveFloaterINI floater_DummyPlacer iniFile ExcludedControls
	fn_delTolHelpers()
	floater_DummyPlacer = undefined
	)
)
	----==============================================================================================================
floater_DummyPlacer = ATfn_.CreateFloater floater_DummyPlacer iniFile fl0W fl0H floaterTitle #(rollout_DP_)
on execute do
	(
	if (hasINISetting iniFile floaterTitle) do (ATfn_.LoadFloaterINI floater_DummyPlacer iniFile ExcludedControls)
-- 	for r in floater_DummyPlacer.Rollouts do (ATfn_.chbtnRunColor r.controls)
	)
)