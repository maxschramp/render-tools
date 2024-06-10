	-----------------
	--^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
(if ATIcons == undefined then (fileIn ((getFilenamePath(getThisScriptFilename())) + "AssemblyToolIcons.ms")))
(if ATfn_ == undefined then (fileIn ((getFilenamePath(getThisScriptFilename())) + "AssemblyToolStruct.ms")))
	--^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
(
Global floater_BatchRenamer
Global floater_AssemblyTool
try (if floater_BatchRenamer.dialogBar then (cui.UnRegisterDialogBar floater_BatchRenamer); closeRolloutFloater floater_BatchRenamer) catch()
	-------------------------------------------------------------------------------------------------------------------
local floaterTitle = "Batch Renamer"
local iniPath = (getFilenamePath (getThisScriptFilename())) + "INI\\"
local iniFile = iniPath + "BatchRenamer_Settings.ini"
local fl0W = 220; local fl0H = (ATfn_.GetINI 0 iniFile floaterTitle "LastSize" [fl0W,360])[2]
local colCHBX = ATfn_.GetINI 0 (iniPath + "AssemblyTool_Settings.ini") "Preferences" "color_PS_ChBxColor" [255,156,0]
local ExcludedControls = #("btn_BR_DockLeft", "btn_BR_DockFloat", "btn_BR_DockRight", \
	"edt_BR_RenameCounter", "spnr_BR_RenameNext", "chbtn_BR_VisualTolerance", "color_BR_ToleranceColor", "spnr_BR_ToleranceOpacity")
	-------------------------------------------------------------------------------------------------------------------
local TolHelpArr = #()
	----=BatchRenamer==============================================================================================
rollout rollout_BR_ floaterTitle
(
local yp1 = #(14, 44, 235)
local DockX = 181; local DockW = 13
button btn_BR_DockLeft "<" pos:[DockX-DockW,0] width:DockW height:10 tooltip:" Dock Left "
button btn_BR_DockFloat "::" pos:[DockX,0] width:DockW height:10 tooltip:" Float "
button btn_BR_DockRight ">" pos:[DockX+DockW,0] width:DockW height:10 tooltip:" Dock Right "
on btn_BR_DockLeft pressed do (ATfn_.DockFloaterSide floater_BatchRenamer iniFile "left")
on btn_BR_DockRight pressed do (ATfn_.DockFloaterSide floater_BatchRenamer iniFile "right")
on btn_BR_DockFloat pressed do (ATfn_.DockFloaterFloat floater_BatchRenamer iniFile fl0W fl0H)
	-------
button btn_BR_ResetNames "Reset Names" pos:[4,yp1[1]] width:(fl0W-22) height:27 toolTip:" Rename Selected Objects as \"Object_\" + Counter "

GroupBox grp_BR_Rename "Rename By Rule:" pos:[2,yp1[2]] width:(fl0W-16) height:185
edittext edt_BR_RenameBasename "" pos:[4,yp1[2]+17] width:195 height:17 bold:false
edittext edt_BR_RenameCounter "+" text:"01" pos:[130,yp1[2]+38] width:50 height:17 bold:false toolTip:" Model Counter "
spinner spnr_BR_RenameNext "" pos:[182,yp1[2]+40] width:15 range:[1,999,1] type:#integer scale:1 toolTip:" Model Counter "

label lbl_BR_Manually "Manually:" pos:[12,yp1[2]+40] toolTip:" Manually Rename Models "
button btn_BR_RenameSingle "Rename" pos:[8,yp1[2]+59] width:60 height:27 toolTip:" Renames Model without Adding <Part..> (Single Object) "
button btn_BR_RenameWithPart "Rename With <Part..>" pos:[71,yp1[2]+59] width:129 height:27 toolTip:" Renames Model with <Part..> "

checkButton chbtn_BR_Autodetect "" pos:[8,yp1[2]+94] width:14 height:14 checked:false highlightColor:colCHBX toolTip:" Automatically Detects Models in Selection \n and Renames them According to the Rule \n in the Direction of the X-Axis "
label lbl_BR_Autodetect "Autodetect:" pos:[26,yp1[2]+94] toolTip:chbtn_BR_Autodetect.toolTip
spinner spnr_BR_DetectTolerance "Detect Tolerance:" pos:[51,yp1[2]+110] width:95 range:[0,999999,0.] type:#float scale:.001 enabled:false toolTip:" Detect Group of Objects Tolerance "
checkButton chbtn_BR_VisualTolerance "Preview" pos:[149,yp1[2]+108] width:52 height:21 highlightColor:colCHBX enabled:false tooltip:" Detect Group of Objects Tolerance Preview "
colorpicker color_BR_ToleranceColor "Preview Diffuse" width:100 height:21 pos:[11,yp1[2]+128] color:AT_ToleranceHelperMaterial.Diffuse modal:false enabled:false tooltip:" Tolerance Helper Material Diffuse Color "
spinner spnr_BR_ToleranceOpacity "Opacity" pos:[145,yp1[2]+132] width:55 range:[5,100,AT_ToleranceHelperMaterial.Opacity] type:#integer scale:1 enabled:false toolTip:" Tolerance Helper Material Opacity "
button btn_BR_RenameAutodetect "Rename" pos:[8,yp1[2]+152] width:(fl0W-28) height:27 enabled:false toolTip:" Automatically Detects Models in Selection \n and Renames them According to the Rule \n in the Direction of the X-Axis "

GroupBox grp_BR_ReplacePart "Replace  <Part..>  with:" pos:[2,yp1[3]] width:(fl0W-16) height:95
dropdownlist ddl_BR_SetName items:#("Body","Main","Top") pos:[8,yp1[3]+16] width:20 height:33 selection:0 tooltip:" Lmb - Choose Name \n Alt+Lmb - Delete Name \n Rmb - Clear Fild \n Alt+Rmb - Save Name "
edittext edt_BR_ReplacePart "" pos:[25,yp1[3]+18] width:173 height:17 bold:false toolTip:" Replace <Part..> in Object Name with Custom String "
checkButton chbtn_BR_AddPartCounter "" pos:[10,yp1[3]+42] width:14 height:14 checked:false highlightColor:colCHBX
label lbl_BR_AddPartCounter "Add Counter" pos:[28,yp1[3]+42]
spinner spnr_BR_PartCounterDigits "Digits: " pos:[130,yp1[3]+42] width:50 range:[1,9,2] type:#integer scale:1 enabled:false
button btn_BR_ReplacePart "Replace" pos:[8,yp1[3]+62] width:(fl0W-28) height:27 toolTip:edt_BR_ReplacePart.tooltip
	-------------------------------------------------------------------------------------------------------------------
local cntrlsManually = #(edt_BR_RenameCounter, spnr_BR_RenameNext, lbl_BR_Manually, btn_BR_RenameSingle, btn_BR_RenameWithPart)
local cntrlsAutodetect = #(spnr_BR_DetectTolerance, chbtn_BR_VisualTolerance, color_BR_ToleranceColor, spnr_BR_ToleranceOpacity, btn_BR_RenameAutodetect)
	-----fn------------------------------------------------------------------------------------------------------------
FN fn_compareArraysByXPos a1 a2 =
(
case of
	(
	(a1[1].center.x < a2[1].center.x): -1
	(a1[1].center.x > a2[1].center.x): 1
	default: 0
	)
)
	-----fn------------------------------------------------------------------------------------------------------------
FN fn_delTolHelpers = with undo off (for o in TolHelpArr where isValidNode o do delete o; free TolHelpArr; chbtn_BR_VisualTolerance.checked = false; gc())
	-----fn------------------------------------------------------------------------------------------------------------
FN fn_msgWrongCounter = (messageBox "Counter Field Must Contain Digits." title:"Wrong Counter!" beep:false)
	-----fn------------------------------------------------------------------------------------------------------------
	------------------------------------------
on chbtn_BR_VisualTolerance changed state do with undo off
(
local InArr = ATfn_.GetNotGroupHeads selection
if state
then
	(
	if InArr.count == 0 do (chbtn_BR_VisualTolerance.checked = false; return ATfn_.messageNS())
	TolHelpArr = ATfn_.CreateBoundingBoxes InArr baseName:"VisualToleranceHelper"
	TolHelpArr.material = AT_ToleranceHelperMaterial
	TolHelpArr.scale = [1. + spnr_BR_DetectTolerance.value, 1. + spnr_BR_DetectTolerance.value, 1. + spnr_BR_DetectTolerance.value]
	)
else (fn_delTolHelpers())
ATfn_.Refresh()
)
	-------------------------------------------------------------------------------------------------------------------
on spnr_BR_DetectTolerance changed val do with undo off
(
if chbtn_BR_VisualTolerance.checked and TolHelpArr.count != 0 do
	(for o in TolHelpArr do o.scale = [1 + val, 1 + val, 1 + val])
)	
	-------------------------------------------------------------------------------------------------------------------
on color_BR_ToleranceColor changed col do (AT_ToleranceHelperMaterial.Diffuse = col)
	-------------------------------------------------------------------------------------------------------------------
on spnr_BR_ToleranceOpacity changed val do with undo off (AT_ToleranceHelperMaterial.Opacity = val)
	-------------------------------------------------------------------------------------------------------------------
on btn_BR_RenameAutodetect pressed do with undo on
(
-- 	clearListener()
fn_delTolHelpers()
-- max group explode
local InArr = for o in (selection as array) where (not o.isFrozen and not o.isHidden) collect o
if InArr.count == 0 do return (ATfn_.messageNGNS())
if (ATfn_.GetNHH InArr false)[2].count != 0 do return (ATfn_.messageGF())
local baseName = edt_BR_RenameBasename.text
if baseName == "" do (return messageBox "Basename field is empty." title:"Enter Basename!" beep:false)
if (FilterString baseName "_").count != 2 do (return messageBox ("Basename must contain 2 parts (example: \"Name_A\")\n\nWe have  \""+baseName+"\"  with  "+((FilterString baseName "_").count as string)+"  parts.") title:"Wrong Basename!" beep:false)
-- if (ATfn_.CollectByPattern baseName).count != 0 do (return messageBox ("In scene already exists objects with Basename  \""+baseName+"\".\n\nPerhaps you forgot change the Name in the Basename field.") title:"Coincident Names Found!" beep:false)
local groupArr = ATfn_.GroupCollect InArr tolerance:spnr_BR_DetectTolerance.value
qsort groupArr fn_compareArraysByXPos
for ng=1 to groupArr.count do
	(
	for no=1 to groupArr[ng].count do
		(
		local objct = groupArr[ng][no]
		local bnFS = FilterString baseName "_"
		if groupArr[ng].count == 1
			then (objct.name = "SM_" + baseName + (ATfn_.Counter ng CounterDigits:2) + "_01")
			else (objct.name = "SM_" + bnFS[1] + "_" + bnFS[2] + (ATfn_.Counter ng CounterDigits:2) + "_<Part" + (ATfn_.Counter no CounterDigits:2) + ">_01")
		)
	)
free groupArr
ATfn_.Refresh()
)
	-------------------------------------------------------------------------------------------------------------------
on chbtn_BR_Autodetect changed state do
(
cntrlsManually.enabled = not state
cntrlsAutodetect.enabled = state
)
	-------------------------------------------------------------------------------------------------------------------
on btn_BR_ResetNames pressed do with undo on
(
selection.name = ""
for objct in selection do objct.name = uniqueName "Object_" numDigits:2
)
	-------------------------------------------------------------------------------------------------------------------
on edt_BR_RenameCounter entered txt do
(
local cnt = edt_BR_RenameCounter.text as number
if cnt == undefined
then (edt_BR_RenameCounter.text = "01"; spnr_BR_RenameNext.value = 1; fn_msgWrongCounter())
else (spnr_BR_RenameNext.value = cnt; edt_BR_RenameCounter.text = if cnt < 10 then ("0" + (cnt as string)) else (cnt as string))
)
	-------------------------------------------------------------------------------------------------------------------
FN fn_spnr_BR_RenameNext =
(
local val = spnr_BR_RenameNext.value
local cnt = edt_BR_RenameCounter.text as number
if cnt == undefined
then (edt_BR_RenameCounter.text = "01"; spnr_BR_RenameNext.value = 1; fn_msgWrongCounter())
else (edt_BR_RenameCounter.text = if val < 10 then ("0" + (val as string)) else (val as string))
)
	-------------------
on spnr_BR_RenameNext changed val do fn_spnr_BR_RenameNext()
on spnr_BR_RenameNext entered inSpin_arg inCancel_arg do fn_spnr_BR_RenameNext()
	-------------------------------------------------------------------------------------------------------------------
fn fn_RenameManually part:true =
(
-- 	clearListener()
local InArr = for o in (selection as array) where (not o.isFrozen and not o.isHidden) collect o
if InArr.count == 0 do (return ATfn_.messageNGNS())
if (ATfn_.GetNHH InArr false)[2].count != 0 do return (ATfn_.messageGF())
local baseName = edt_BR_RenameBasename.text
if baseName == "" do (return messageBox "Basename field is empty." title:"Enter Basename!" beep:false)
if (FilterString baseName "_").count != 2 do (return messageBox ("Basename must contain 2 parts (example: \"Name_A\")\n\nWe have  \""+baseName+"\"  with  "+((FilterString baseName "_").count as string)+"  parts.") title:"Wrong Basename!" beep:false)
-- if (ATfn_.CollectByPattern baseName).count != 0 do (return messageBox ("In scene already exists objects with Basename  \""+baseName+"\".\n\nPerhaps you forgot change the Name in the Basename field.") title:"Coincident Names Found!" beep:false)
if (edt_BR_RenameCounter.text as number) == undefined do (return fn_msgWrongCounter())
for no=1 to InArr.count do
	(
	local objct = InArr[no]
	local bnFS = FilterString baseName "_"
	if not part
		then (objct.name = "SM_" + baseName + edt_BR_RenameCounter.text + "_01")
		else (objct.name = "SM_" + bnFS[1] + "_" + bnFS[2] + edt_BR_RenameCounter.text + "_<Part" + (ATfn_.Counter no CounterDigits:2) + ">_01")
	)
ATfn_.Refresh()
)
on btn_BR_RenameSingle pressed do with undo on (fn_RenameManually part:false)
on btn_BR_RenameWithPart pressed do with undo on (fn_RenameManually part:true)
	-------------------------------------------------------------------------------------------------------------------
on chbtn_BR_AddPartCounter changed state do (spnr_BR_PartCounterDigits.enabled = state)
	-------------------------------------------------------------------------------------------------------------------
on btn_BR_ReplacePart pressed do with undo on
(
fn_delTolHelpers()
local InArr = (ATfn_.GetGeometry (selection as array))
if InArr.count == 0 do return false
if edt_BR_ReplacePart.text == "" do return messageBox "Fill in the field." title:"Field is Empty!" beep:false
for n=1 to InArr.count do
	(
	local objct = InArr[n]
	local part = ""
	for s in (FilterString objct.name "_") where (s[1] == "<" and s[s.count] == ">") do (part = s)
	if part == "" do return false
	objct.name = substituteString objct.name part (edt_BR_ReplacePart.text + (if chbtn_BR_AddPartCounter.checked then (ATfn_.Counter n CounterDigits:(spnr_BR_PartCounterDigits.value)) else ""))
	)
ATfn_.Refresh()
)
	-------------------------------------------------------------------------------------------------------------------
on ddl_BR_SetName selected item do
(	
if keyboard.altPressed
then
	(
	local savedNamesArr = ddl_BR_SetName.items
	if savedNamesArr[item] != "" then (deleteItem savedNamesArr item; ddl_BR_SetName.items = deepCopy savedNamesArr)
	ATfn_.ddlWidthDynamic ddl_BR_SetName
	)
else (edt_BR_ReplacePart.text = (ddl_BR_SetName.items)[item])
)
on ddl_BR_SetName rightclick do
(	
if keyboard.altPressed
then
	(
	local savedNamesArr = ddl_BR_SetName.items
	appendIfUnique savedNamesArr edt_BR_ReplacePart.text
	sort savedNamesArr
	ddl_BR_SetName.items = deepCopy savedNamesArr
	ATfn_.ddlWidthDynamic ddl_BR_SetName
	setFocus edt_BR_ReplacePart
	)
else
	(
	edt_BR_ReplacePart.text = ""
	setFocus edt_BR_ReplacePart
	)
)
	-------------------------------------------------------------------------------------------------------------------
	----===============================================================================================================
on rollout_BR_ open do
	(
	if floater_AssemblyTool != undefined do try(floater_AssemblyTool.rollouts[1].chbtn_TL_BatchRenamer.checked = true)catch()
	ATfn_.ddlWidthDynamic ddl_BR_SetName
	)
on rollout_BR_ close do
	(
	if floater_AssemblyTool != undefined do try(floater_AssemblyTool.rollouts[1].chbtn_TL_BatchRenamer.checked = false)catch()
	ATfn_.SaveFloaterINI floater_BatchRenamer iniFile ExcludedControls
	fn_delTolHelpers()
	floater_BatchRenamer = undefined
	)
)
	----==============================================================================================================
floater_BatchRenamer = ATfn_.CreateFloater floater_BatchRenamer iniFile fl0W fl0H floaterTitle #(rollout_BR_)
on execute do
	(
	if (hasINISetting iniFile floaterTitle) do (ATfn_.LoadFloaterINI floater_BatchRenamer iniFile ExcludedControls)
-- 	for r in floater_BatchRenamer.Rollouts do (ATfn_.chbtnRunColor r.controls)
	)
)