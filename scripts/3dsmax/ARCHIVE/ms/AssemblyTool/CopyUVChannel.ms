	-----------------
	--^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
(if ATIcons == undefined then (fileIn ((getFilenamePath(getThisScriptFilename())) + "AssemblyToolIcons.ms")))
(if ATfn_ == undefined then (fileIn ((getFilenamePath(getThisScriptFilename())) + "AssemblyToolStruct.ms")))
	--^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
(
Global floater_CopyUVChannel
Global floater_AssemblyTool
try (if floater_CopyUVChannel.dialogBar then (cui.UnRegisterDialogBar floater_CopyUVChannel); closeRolloutFloater floater_CopyUVChannel) catch()
	-------------------------------------------------------------------------------------------------------------------
local floaterTitle = "Copy UV Channel"
local iniPath = (getFilenamePath (getThisScriptFilename())) + "INI\\"
local iniFile = iniPath + "CopyUVChannel_Settings.ini"
local fl0W = 220; local fl0H = (ATfn_.GetINI 0 iniFile floaterTitle "LastSize" [fl0W,345])[2]
local colCHBX = ATfn_.GetINI 0 (iniPath + "AssemblyTool_Settings.ini") "Preferences" "color_PS_ChBxColor" [255,156,0]
local ExcludedControls = #("prgrs_UVC_ProBar", "tmr_UVC_prgrsFade", "btn_UVC_DockLeft", "btn_UVC_DockFloat", "btn_UVC_DockRight", \
	"ddl_UVC_Algorithm")
	-------------------------------------------------------------------------------------------------------------------
	----=CopyUVChannel==============================================================================================
rollout rollout_UVC_ "Copy UV Channel"
(
local yp1 = #(3, 27, 47, 67, 87, 100, 218, 238, 260, 303)
local DockX = 181; local DockW = 13
button btn_UVC_DockLeft "<" pos:[DockX-DockW,0] width:DockW height:10 tooltip:" Dock Left "
button btn_UVC_DockFloat "::" pos:[DockX,0] width:DockW height:10 tooltip:" Float "
button btn_UVC_DockRight ">" pos:[DockX+DockW,0] width:DockW height:10 tooltip:" Dock Right "
on btn_UVC_DockLeft pressed do (ATfn_.DockFloaterSide floater_CopyUVChannel iniFile "left")
on btn_UVC_DockRight pressed do (ATfn_.DockFloaterSide floater_CopyUVChannel iniFile "right")
on btn_UVC_DockFloat pressed do (ATfn_.DockFloaterFloat floater_CopyUVChannel iniFile fl0W fl0H)
	-------
radiobuttons rdbtn_UVC_SelectedOrScene "" labels:#("Selected","Scene") pos:[4,yp1[1]] offsets:#([0,0],[0,0]) columns:2 default:1 tooltip:" Process All Scene Objects \n Or Selected Objects "

checkButton chbtn_UVC_Weld pos:[4,yp1[2]] width:14 height:14  highlightColor:colCHBX tooltip:" Weld All Vertices "
label lbl_UVC_Weld "Weld Vertices" pos:[22,yp1[2]]
spinner spnr_UVC_WeldThreshold "Threshold" pos:[119,yp1[2]] width:85 range:[0.001,9999,0.001] type:#Float scale:0.001 tooltip:" Weld Threshold "

checkButton chbtn_UVC_ChToCh pos:[4,yp1[3]] width:14 height:14 highlightColor:colCHBX tooltip:" UV From Chanel 1 to New Chanel and Pack "
label lbl_UVC_ChToCh "Channel" pos:[22,yp1[3]] tooltip:chbtn_UVC_ChToCh.tooltip
spinner spnr_UVC_ToChannel "" pos:[65,yp1[3]] width:40 range:[0,99,1] type:#Integer scale:1 enabled:false tooltip:" New Channel "

radiobuttons rdbtn_UVC_ObjectOrMaterial "" labels:#("Object","Material") pos:[4,yp1[4]] offsets:#([0,0],[0,0]) columns:2 default:1 enabled:false tooltip:" Process by Object Or Material "

checkButton chbtn_UVC_Pack pos:[4,yp1[5]] width:14 height:14 highlightColor:colCHBX enabled:false tooltip:" Pack Toggle "
label lbl_UVC_Pack "Pack" pos:[22,yp1[5]] enabled:false tooltip:chbtn_UVC_Pack.tooltip

groupBox grp_UVC_Pack "" pos:[2,yp1[6]] width:(fl0W-16) height:110

dropdownlist ddl_UVC_Algorithm items:#("Linear Packing","Recursive Packing","Non-Convex","Unfold3D") pos:[8,yp1[6]+10] width:(fl0W-29) height:5 selection:4 enabled:false
spinner spnr_UVC_Padding "Padding" pos:[24,yp1[6]+35] width:100 range:[0.,1.,0.005] type:#Float scale:0.001 enabled:false tooltip:" The Gap Between Cluster In Percentage "

checkButton chbtn_UVC_NormalizeClstrs pos:[8,yp1[6]+53] width:14 height:14 highlightColor:colCHBX enabled:false
label lbl_UVC_NormalizeClstrs "Normalize Clusters" pos:[26,yp1[6]+53] enabled:false

checkButton chbtn_UVC_RotateClstrs pos:[8,yp1[6]+71] width:14 height:14 highlightColor:colCHBX enabled:false
label lbl_UVC_RotateClstrs "Rotate Clusters" pos:[26,yp1[6]+71] enabled:false

checkButton chbtn_UVC_FillHoles pos:[130,yp1[6]+89] width:14 height:14 highlightColor:colCHBX enabled:false
label lbl_UVC_FillHoles "Fill Holes" pos:[148,yp1[6]+89] enabled:false

checkButton chbtn_UVC_RescaleClusters pos:[8,yp1[6]+89] width:14 height:14  highlightColor:colCHBX enabled:false
label lbl_UVC_RescaleClusters "Rescale Clusters" pos:[26,yp1[6]+89] enabled:false

checkButton chbtn_UVC_PivotCenter pos:[4,yp1[7]] width:14 height:14 highlightColor:colCHBX tooltip:" Pivot In The Center Of The Object "
label lbl_UVC_PivotCenter "Pivot To Center" pos:[22,yp1[7]]

checkButton chbtn_UVC_PivotZmin pos:[110,yp1[7]] width:14 height:14 highlightColor:colCHBX tooltip:" Pivot To The Minimum Of The Object Z Axis"
label lbl_UVC_PivotZmin "Pivot To Z Min" pos:[128,yp1[7]]

checkButton chbtn_UVC_ResetXForm pos:[4,yp1[8]] width:14 height:14 highlightColor:colCHBX tooltip:" Reset XForm And Convert To Editable Poly "
label lbl_UVC_ResetXForm "Reset XForm" pos:[22,yp1[8]]

checkButton chbtn_UVC_SetColorState pos:[110,yp1[8]] width:14 height:14 highlightColor:colCHBX tooltip:" Set Rundom Wire Color To Processed Objects "
label lbl_UVC_SetColorState "Set Wire Color" pos:[128,yp1[8]]

button btn_UVC_Process "Process" pos:[5,yp1[9]] width:(fl0W-20) height:37 tooltip:" Lmb - Process Objects \n Rmb - Process And Open Unwrap "

progressBar prgrs_UVC_ProBar pos:[0,yp1[10]] width:(fl0W-13) height:10 value:0 color:orange
timer tmr_UVC_prgrsFade interval:((3*1000/68) as integer) active:false
on tmr_UVC_prgrsFade tick do (ATfn_.ProgBarFade prgrs_UVC_ProBar tmr_UVC_prgrsFade)
	-----Controls------------------------------------------------------------------------------------------------------
local CHBXarr = #(chbtn_UVC_Weld, chbtn_UVC_ChToCh, chbtn_UVC_Pack, chbtn_UVC_NormalizeClstrs, chbtn_UVC_RotateClstrs, \
	chbtn_UVC_FillHoles, chbtn_UVC_RescaleClusters, chbtn_UVC_PivotCenter, chbtn_UVC_PivotZmin, chbtn_UVC_ResetXForm, chbtn_UVC_SetColorState)
	-----Controls------------------------------------------------------------------------------------------------------
	-----fn------------------------------------------------------------------------------------------------------------
FN fn_Weld objArr Threshold =
(
for objct in objArr do
	(
	objct.EditablePoly.SetSelection #Vertex #{1..(objct.verts.count)}
	objct.weldThreshold = Threshold
	objct.EditablePoly.weldFlaggedVertices ()
	objct.EditablePoly.SetSelection #Vertex #{}
	)
)
	-----fn------------------------------------------------------------------------------------------------------------
FN fn_toEMtoEPnoSubSel inArr = 
(
for objct in inArr do
	(
	addModifier objct (Edit_Mesh ())
	addModifier objct (Edit_Poly ())
	maxOps.CollapseNodeTo objct 1 off
	objct.SetSelection #Vertex #{}; objct.SetSelection #Edge #{}; objct.SetSelection #Face #{}
	)
)
	-----fn------------------------------------------------------------------------------------------------------------
-- FN fn_RemoveCounter nm =
-- (
-- local NumStrArr = #("1","2","3","4","5","6","7","8","9","0")
-- while (findItem NumStrArr nm[nm.count] != 0) do (nm = replace nm (nm.count) 1 "")
-- if (nm[nm.count] == "_") then (nm = replace nm (nm.count) 1 "")
-- return nm
-- )
	-----fn------------------------------------------------------------------------------------------------------------
-- FN fn_RenameAddCounter NewName ObjectsArray Separator CounterDigits = (for objct in ObjectsArray do (objct.name = uniqueName "AbrAbrvalg" numDigits:9); for objct in ObjectsArray do (objct.name = uniqueName (NewName + Separator) numDigits:(if CounterDigits == 0 then (ObjectsArray.count as string).count else CounterDigits)))
	-----fn------------------------------------------------------------------------------------------------------------
FN fn_Attach objArr = 
(
for n in objArr.count to 2 by -1 do (polyop.attach objArr[1] objArr[n])
local objName = ATfn_.RemoveCounter objArr[1].name
-- objArr[1].name = uniqueName objName numDigits:3
ATfn_.RenameAddCounter objName #(objArr[1])
return objArr[1]
)
	-----fn------------------------------------------------------------------------------------------------------------
FN fn_Warning1 = (messageBox "Objects are not Selected or the Scene is Empty." title:" CopyUVChannel" beep:false)
	-----fn------------------------------------------------------------------------------------------------------------
	-------------------------------------------------------------------------------------------------------------------
FN fn_Process Rmb:false =
(
max create mode
local OArr = ATfn_.GetGeometry (if rdbtn_UVC_SelectedOrScene.state == 1 then selection else objects)
local toChVal = spnr_UVC_ToChannel.value
tmr_UVC_prgrsFade.active = false; prgrs_UVC_ProBar.value = 0; prgrs_UVC_ProBar.color = orange
if OArr.count != 0
then
	(
	resetXForm OArr; ConvertTo OArr Editable_Poly
	if chbtn_UVC_Weld.checked then (fn_Weld OArr spnr_UVC_WeldThreshold.value)
	fn_toEMtoEPnoSubSel OArr
	max modify mode
	if chbtn_UVC_ChToCh.checked do
		(
		if rdbtn_UVC_ObjectOrMaterial.state == 1
		then
			(
			for objct in OArr do
				(
				if (((maxVersion())[1] / 1000) >= 13) do windows.processPostedMessages()
				ChannelInfo.CopyChannel objct 3 1; ChannelInfo.PasteChannel objct 3 toChVal
				local unvr = Unwrap_UVW (); unvr.setMapChannel toChVal; unvr.setTVSubObjectMode 0; addmodifier objct unvr
				if chbtn_UVC_Pack.checked then
					(
					select objct
					$.modifiers[#unwrap_uvw].SetPackRescaleCluster (chbtn_UVC_RescaleClusters.checked)
					$.modifiers[#unwrap_uvw].pack ((ddl_UVC_Algorithm.selection)-1) (spnr_UVC_Padding.value) (chbtn_UVC_NormalizeClstrs.checked) (chbtn_UVC_RotateClstrs.checked) (chbtn_UVC_FillHoles.checked)
					subobjectLevel = 0
					)
				prgrs_UVC_ProBar.value = 100.0*(findItem OArr objct)/(OArr.count)
				)
			if chbtn_UVC_PivotCenter.checked then (for objct in OArr do (objct.pivot = objct.center))
			if chbtn_UVC_PivotZmin.checked then (for objct in OArr do (objct.pivot.Z = objct.min.Z))
			select OArr
			prgrs_UVC_ProBar.color = green; tmr_UVC_prgrsFade.active = true
			)
		else
			(
			local matArr = #(); for objct in OArr where (objct.material != undefined) do (appendIfUnique matArr objct.material)
			local objByMatArr = #(); local tArr = #(); for mat in matArr do (for objct in OArr where objct.material == mat do (appendIfUnique tArr objct); qSort tArr ATfn_.CompareNames; append objByMatArr tArr; tArr = #())
			local newObjArr = #()
			for mArr in objByMatArr do (if mArr.count > 1 then (local no = fn_Attach mArr; print (no.name); append newObjArr no) else (append newObjArr mArr[1]))
			resetXForm newObjArr; ConvertTo newObjArr Editable_Poly
			for newObj in newObjArr do
				(
				if (((maxVersion())[1] / 1000) >= 13) do windows.processPostedMessages()
				ChannelInfo.CopyChannel newObj 3 1; ChannelInfo.PasteChannel newObj 3 toChVal
				local unvr = Unwrap_UVW (); unvr.setMapChannel toChVal; unvr.setTVSubObjectMode 0; addmodifier newObj unvr
				if chbtn_UVC_Pack.checked then
					(
					select newObj
					$.modifiers[#unwrap_uvw].SetPackRescaleCluster (chbtn_UVC_RescaleClusters.checked)
					$.modifiers[#unwrap_uvw].pack ((ddl_UVC_Algorithm.selection)-1) (spnr_UVC_Padding.value) (chbtn_UVC_NormalizeClstrs.checked) (chbtn_UVC_RotateClstrs.checked) (chbtn_UVC_FillHoles.checked)
					subobjectLevel = 0
					)
				prgrs_UVC_ProBar.value = 100.0*(findItem newObjArr newObj)/(newObjArr.count)
				)
			if chbtn_UVC_PivotCenter.checked then (for objct in newObjArr do (objct.pivot = objct.center))
			if chbtn_UVC_PivotZmin.checked then (for objct in newObjArr do (objct.pivot.Z = objct.min.Z))
			select newObjArr
			prgrs_UVC_ProBar.color = green; tmr_UVC_prgrsFade.active = true
			)
		local ObjctsArr = selection as array
		if chbtn_UVC_SetColorState.checked then (for objct in ObjctsArr do (objct.wirecolor = ATfn_.RandomColor()))
		if not Rmb
		then
			(
			if chbtn_UVC_ResetXForm.checked
			then (ConvertTo ObjctsArr Editable_Mesh; resetXForm ObjctsArr; ConvertTo ObjctsArr Editable_Poly)
			)
		else
			(
			if chbtn_UVC_ResetXForm.checked
			then (ConvertTo ObjctsArr Editable_Mesh; resetXForm ObjctsArr; ConvertTo ObjctsArr Editable_Poly)
			else (select ObjctsArr[1]; ObjctsArr[1].modifiers[#unwrap_uvw].edit())
			)
		)
	)
else (fn_Warning1())
)
on btn_UVC_Process pressed do with undo on (fn_Process Rmb:false)
on btn_UVC_Process rightclick do with undo on (fn_Process Rmb:true)
	-------------------------------------------------------------------------------------------------------------------
on chbtn_UVC_Pack changed state do 
(
ddl_UVC_Algorithm.enabled = spnr_UVC_Padding.enabled = chbtn_UVC_NormalizeClstrs.enabled = \
lbl_UVC_NormalizeClstrs.enabled = chbtn_UVC_RotateClstrs.enabled = lbl_UVC_RotateClstrs.enabled = \
chbtn_UVC_FillHoles.enabled = lbl_UVC_FillHoles.enabled = chbtn_UVC_RescaleClusters.enabled = \
lbl_UVC_RescaleClusters.enabled = state
ATfn_.chbtnColorUpdate CHBXarr colCHBX
)
	-------------------------------------------------------------------------------------------------------------------
on chbtn_UVC_ChToCh changed state do 
(
spnr_UVC_ToChannel.enabled = rdbtn_UVC_ObjectOrMaterial.enabled = chbtn_UVC_Pack.enabled = lbl_UVC_Pack.enabled = state
ddl_UVC_Algorithm.enabled = spnr_UVC_Padding.enabled = chbtn_UVC_NormalizeClstrs.enabled = \
lbl_UVC_NormalizeClstrs.enabled = chbtn_UVC_RotateClstrs.enabled = lbl_UVC_RotateClstrs.enabled = \
chbtn_UVC_FillHoles.enabled = lbl_UVC_FillHoles.enabled = chbtn_UVC_RescaleClusters.enabled = \
lbl_UVC_RescaleClusters.enabled = (if chbtn_UVC_Pack.checked then state else false)
ATfn_.chbtnColorUpdate CHBXarr colCHBX
)
	-------------------------------------------------------------------------------------------------------------------
on chbtn_UVC_Weld changed state do spnr_UVC_WeldThreshold.enabled = state
	----===============================================================================================================
on rollout_UVC_ open do
	(
	if floater_AssemblyTool != undefined do try(floater_AssemblyTool.rollouts[1].chbtn_TL_CopyUVChannel.checked = true)catch()
	)
on rollout_UVC_ close do
	(
	if floater_AssemblyTool != undefined do try(floater_AssemblyTool.rollouts[1].chbtn_TL_CopyUVChannel.checked = false)catch()
	ATfn_.SaveFloaterINI floater_CopyUVChannel iniFile ExcludedControls
	floater_CopyUVChannel = undefined
	)
)
	----==============================================================================================================
floater_CopyUVChannel = ATfn_.CreateFloater floater_CopyUVChannel iniFile fl0W fl0H floaterTitle #(rollout_UVC_)
on execute do
	(
	if (hasINISetting iniFile floaterTitle) do (ATfn_.LoadFloaterINI floater_CopyUVChannel iniFile ExcludedControls)
-- 	for r in floater_CopyUVChannel.Rollouts do (ATfn_.chbtnRunColor r.controls)
	)
)