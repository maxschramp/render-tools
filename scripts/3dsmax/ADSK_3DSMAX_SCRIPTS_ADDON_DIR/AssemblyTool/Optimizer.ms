(
Global floater_Optimizer
Global floater_AssemblyTool
try (if floater_Optimizer.dialogBar then (cui.UnRegisterDialogBar floater_Optimizer); closeRolloutFloater floater_Optimizer) catch()
	-------------------------------------------------------------------------------------------------------------------
local floaterTitle = "Optimizer"
local iniPath = (getFilenamePath (getThisScriptFilename())) + "INI\\"
local iniFile = iniPath + "Optimizer_Settings.ini"
local fl0W = 220; local fl0H = (ATfn_.GetINI 0 iniFile floaterTitle "LastSize" [fl0W,350])[2]
-- local fl0P = ATfn_.GetINI 0 iniFile floaterTitle "LastPosition" [50,50]
local colCHBX = ATfn_.GetINI 0 (iniPath + "AssemblyTool_Settings.ini") "Preferences" "color_PS_ChBxColor" [255,156,0]
local ExcludedControls = #("prgrs_OZ_ProBar", "tmr_OZ_prgrsFade", "btn_OZ_DockLeft", "btn_OZ_DockFloat", "btn_OZ_DockRight", \
	"lbl_OZ_Plus")
	----=Optimizer=====================================================================================================
rollout rollout_OZ_ "Optimizer"
(
local yp1 = #(20, 206, 247, 297)
local DockX = 181; local DockW = 13
button btn_OZ_DockLeft "<" pos:[DockX-DockW,0] width:DockW height:10 tooltip:" Dock Left "
button btn_OZ_DockFloat "::" pos:[DockX,0] width:DockW height:10 tooltip:" Float "
button btn_OZ_DockRight ">" pos:[DockX+DockW,0] width:DockW height:10 tooltip:" Dock Right "
on btn_OZ_DockLeft pressed do (ATfn_.DockFloaterSide floater_Optimizer iniFile "left")
on btn_OZ_DockRight pressed do (ATfn_.DockFloaterSide floater_Optimizer iniFile "right")
on btn_OZ_DockFloat pressed do (ATfn_.DockFloaterFloat floater_Optimizer iniFile fl0W fl0H)
	-------
label lbl_OZ_Warning "! Requires Installed VRay !" pos:[5,yp1[1]-18]

checkButton chbtn_OZ_UseScenePath "Scene Path" pos:[0,yp1[1]-1] width:80 height:19 checked:true highlightColor:colCHBX tooltip:" Use Scene Path To Save \n .vrmesh And .max Files "
label lbl_OZ_Plus "+ \\" pos:[83,yp1[1]+1]
edittext edt_OZ_ProxyFolder "" pos:[97,yp1[1]] width:109 height:17 bold:false text:"Proxy"
	
dropdownlist ddl_OZ_SetName items:#() pos:[0,yp1[1]+20] width:20 height:33 selection:0 enabled:(not chbtn_OZ_UseScenePath.checked) tooltip:" Lmb - Choose Name \n Alt+Lmb - Delete Name \n Rmb - Clear Fild \n Alt+Rmb - Save Name "
edittext edt_OZ_CustomPath "" pos:[17,yp1[1]+22] width:(fl0W-54) height:17 bold:false enabled:(not chbtn_OZ_UseScenePath.checked) tooltip:" Custom Path To Save \n .vrmesh And .max Files "
button btn_OZ_GetScenePath " Get" width:24 height:19 pos:[184,yp1[1]+21] enabled:(not chbtn_OZ_UseScenePath.checked) tooltip:" Lmb - Get Path \n Rmb - Get Scene Path "

GroupBox grp_OZ_CreationRule "Creation Rule" pos:[2,yp1[1]+48] width:(fl0W-16) height:40
spinner spnr_OZ_MinPolycount "Polycount >" pos:[20,yp1[1]+66] width:120 range:[0,999999999,1000000] type:#Integer scale:1 enabled:true toolTip:" Create Proxy If Object Polycount \n More Then Spiner Value "
button btn_OZ_SelByPolycount "Select" width:55 height:23 pos:[144,yp1[1]+60] tooltip:" Select Objects With Polycount \n More Then Spiner Value \n Lmb - In Selected \n Rmb - In Scene "

GroupBox grp_OZ_ProxyPolyount "Proxy Polyount" pos:[2,yp1[1]+90] width:(fl0W-16) height:50
radiobuttons rdbtn_OZ_PolygonsOrPercents "" labels:#("     Polygons:","     Percents:") pos:[22,yp1[1]+104] columns:1 offsets:#([0,0],[0,0]) default:1 tooltip:" Polycount Calculation Method Toggle "
spinner spnr_OZ_ProxyPolygons "" pos:[120,yp1[1]+105] width:70 range:[1,9999999,10000] type:#Integer scale:1 enabled:(rdbtn_OZ_PolygonsOrPercents.state==1) toolTip:" Maximal Proxy Polycount "
spinner spnr_OZ_ProxyPercents "%" pos:[120,yp1[1]+120] width:70 range:[1,100,5] type:#Integer scale:1 enabled:(rdbtn_OZ_PolygonsOrPercents.state==2) toolTip:" Proxy Polycount As Percents \n Of Object Polycount "

button btn_OZ_CreateProxy "Create \n Proxy" width:100 height:37 pos:[0,yp1[1]+144] tooltip:" Create Proxy "
button btn_OZ_RestoreOriginal "Restore \n Original" width:100 height:37 pos:[106,yp1[1]+144] tooltip:" Restore Original "

label lbl_OZ_DisplayProxyAs "Proxy As:" pos:[5,yp1[1]+203]
button btn_OZ_DisplayBBox "Box" width:45 height:23 pos:[56,yp1[1]+199] tooltip:" Display Selected Proxy As Bounding Box "
button btn_OZ_DisplayPreview "Preview" width:55 height:23 pos:[101,yp1[1]+199] tooltip:" Display Selected Proxy As \n Preview From File (Faces) "
button btn_OZ_DisplayOriginal "Original" width:50 height:23 pos:[156,yp1[1]+199] tooltip:" Display Selected Proxy As Original Object "

GroupBox grp_OZ_FreezeTool "Freeze" pos:[2,yp1[3]] width:(fl0W-16) height:40
checkButton chbtn_OZ_AffectInstances "" pos:[8,yp1[3]+17] width:14 height:14 checked:true highlightColor:colCHBX toolTip:" Freeze Or Unfreeze Instances "
label lbl_OZ_AffectInstances "Affect  Instances" pos:[26,yp1[3]+17]
button btn_OZ_Freeze "Freeze" width:27 height:27 pos:[114,yp1[3]+10] images:ATIcons[72] tooltip:"       Lmb - Freeze Selected Objects \n Alt+Lmb - Freeze Scene Objects \n     If Object Polycount More Then \n     Proxy Creation Rule Spinner Value "
button btn_OZ_UnfreezeAll "UnfreezeAll" width:27 height:27 pos:[144,yp1[3]+10] images:ATIcons[5] tooltip:" Unfreeze All Scene Objects "
button btn_OZ_UnfreezeByHit "UnfreezeByHit" width:27 height:27 pos:[174,yp1[3]+10] images:ATIcons[4] tooltip:" Unfreeze Objects By Hit "

label lbl_OZ_DisplayObjAsBox "Display Selected As Box:" pos:[6,yp1[4]] tooltip:" Display Selected Objects Toggle "
button btn_OZ_DisObjAsBoxOn "On" width:35 height:23 pos:[127,yp1[4]-4] tooltip:" Display Selected Objects As Bounding Box "
button btn_OZ_DisObjAsBoxOff "Off" width:35 height:23 pos:[167,yp1[4]-4] tooltip:" Display Selected Objects As Mesh "

progressBar prgrs_OZ_ProBar pos:[0,yp1[2]] width:(fl0W-13) height:10 value:0 color:orange
timer tmr_OZ_prgrsFade interval:((3*1000/68) as integer) active:false
on tmr_OZ_prgrsFade tick do (ATfn_.ProgBarFade prgrs_OZ_ProBar tmr_OZ_prgrsFade)
	-----fn------------------------------------------------------------------------------------------------------------
FN fn_GetPolyCount objct = (getPolygonCount objct)[1]
	-----fn------------------------------------------------------------------------------------------------------------
FN fn_ddlWidthDynamic ddl =
(
local ddl_koef = 5.; local ddlLim = 30.
local itemsArr = ddl.items
local maxStr = 100; if itemsArr.count != 0 then (strCountArr = (for f in itemsArr collect f.count);  maxStr = aMax strCountArr)
windows.sendmessage ddl.hwnd[1] 352 (maxStr*(ddl_koef + ddlLim/maxStr)) 0
)
	-----fn------------------------------------------------------------------------------------------------------------
	-------------------------------------------------------------------------------------------------------------------
on btn_OZ_DisObjAsBoxOn pressed do with undo on ((ATfn_.InstancesAppend (selection as array)).boxmode = on; completeredraw())
	-------------------------------------------------------------------------------------------------------------------
on btn_OZ_DisObjAsBoxOff pressed do with undo on ((ATfn_.InstancesAppend (selection as array)).boxmode = off; completeredraw())
	-------------------------------------------------------------------------------------------------------------------
on btn_OZ_DisplayBBox pressed do with undo off ((for objct in (ATfn_.InstancesTrim (selection as array)) where classOf objct == VrayProxy collect objct).display = 0; completeredraw())
	-------------------------------------------------------------------------------------------------------------------
on btn_OZ_DisplayPreview pressed do with undo off ((for objct in (ATfn_.InstancesTrim (selection as array)) where classOf objct == VrayProxy collect objct).display = 3; completeredraw())
	-------------------------------------------------------------------------------------------------------------------
on btn_OZ_DisplayOriginal pressed do with undo off ((for objct in (ATfn_.InstancesTrim (selection as array)) where classOf objct == VrayProxy collect objct).display = 4; completeredraw())
	-------------------------------------------------------------------------------------------------------------------
on btn_OZ_RestoreOriginal pressed do with undo off
(
local CPTM = getCommandPanelTaskMode()
setCommandPanelTaskMode #create
local proxyArr = for objct in (selection as array) where classOf objct == VrayProxy collect objct
disablesceneredraw()
local proxNamesArr = for p in proxyArr collect p.name
local inArr = ATfn_.InstancesTrim proxyArr
if inArr.count == 0 do (enablesceneredraw(); return messagebox "Invalid Selection." title:" Optimizer")
local inputArr = #()
local outputArr = #()
local noMaxArr = #()
max select none
tmr_OZ_prgrsFade.active = false; prgrs_OZ_ProBar.value = 0; prgrs_OZ_ProBar.color = orange
for objct in inArr do
	(
	local objName = getFilenameFile objct.filename
	local maxFile = (getFilenamePath objct.filename) + objName + ".max"
	if doesFileExist maxFile
	then
		(
		mergemaxfile maxFile #select #noRedraw #mergeDups #useSceneMtlDups #neverReparent
		append inputArr objct
		append outputArr selection[1]
		)
	else (append noMaxArr objct)
	prgrs_OZ_ProBar.value = 100.0*(findItem inArr objct)/(inArr.count)
	)
prgrs_OZ_ProBar.color = green; tmr_OZ_prgrsFade.active = true
for n = 1 to inputArr.count do instanceReplace inputArr[n] outputArr[n]
delete outputArr
for VRProxy in noMaxArr do (VRProxy.display = 4; addModifier VRProxy (Edit_Poly ()); maxOps.CollapseNodeTo VRProxy 1 off)
local selArr = #(); for o in objects do (for pn in proxNamesArr where (o.name == pn) do append selArr o)
ATfn_.SelectInGroups selArr
setCommandPanelTaskMode CPTM
enablesceneredraw()
completeredraw()
gc()
)
	-------------------------------------------------------------------------------------------------------------------
on btn_OZ_SelByPolycount pressed do with undo on
(
local GArr = ATfn_.GetGeometry (selection as array)
local selArr = for objct in GArr where (fn_GetPolyCount objct) > spnr_OZ_MinPolycount.value collect objct
if selArr.count > 0 then (ATfn_.SelectInGroups selArr) else clearSelection()
)
	-------------------------------------------------------------------------------------------------------------------
on btn_OZ_SelByPolycount rightclick do with undo on
(
local GArr = ATfn_.GetGeometry (objects as array)
local selArr = for objct in GArr where (fn_GetPolyCount objct) > spnr_OZ_MinPolycount.value collect objct
if selArr.count > 0 then (ATfn_.SelectInGroups selArr) else clearSelection()
)
	-------------------------------------------------------------------------------------------------------------------
on btn_OZ_CreateProxy pressed do with undo off
(
local GArr = ATfn_.GetGeometry (for objct in (selection as array) where classOf objct != VrayProxy collect objct)
if GArr.count == 0 do return ATfn_.messageNGNS()
max group explode
local vrmeshDir = if chbtn_OZ_UseScenePath.checked then ((trimright maxFilePath "\\") + "\\" + edt_OZ_ProxyFolder.text) else (edt_OZ_CustomPath.text)
if vrmeshDir == ("\\" + edt_OZ_ProxyFolder.text) do (return messagebox "Save Scene To Define Scene Path." title:" Optimizer")
if vrmeshDir == "" do (return messagebox "Set Path To Save .vrmesh And .max Files." title:" Optimizer")
local CPTM = getCommandPanelTaskMode()
setCommandPanelTaskMode #create
disablesceneredraw()
makeDir vrmeshDir
local spnrMinPolycoun = spnr_OZ_MinPolycount.value
local uniqueArr = ATfn_.InstancesTrim GArr
local inArr = #()
local pCountArr = #()
tmr_OZ_prgrsFade.active = false; prgrs_OZ_ProBar.value = 0; prgrs_OZ_ProBar.color = orange
for objct in uniqueArr do
	(
	local pCount = fn_GetPolyCount objct
	if pCount > spnrMinPolycoun do
		(
		append inArr objct
		append pCountArr pCount
		)
	prgrs_OZ_ProBar.value = 100.0*(findItem uniqueArr objct)/(uniqueArr.count)
	)
prgrs_OZ_ProBar.color = green; tmr_OZ_prgrsFade.active = true
-- completeredraw()
if inArr.count == 0 do (enablesceneredraw(); return messagebox "Invalid Selection." title:" Optimizer")
local inputArr = #()
local outputArr = #()
max select none
tmr_OZ_prgrsFade.active = false; prgrs_OZ_ProBar.value = 0; prgrs_OZ_ProBar.color = orange
for objct in inArr do
	(
	local vrmeshName
	local originalName
	vrmeshName = vrmeshDir + "\\" + objct.name + ".vrmesh"
	originalName = vrmeshDir + "\\" + objct.name + ".max"
	saveNodes objct originalName
	select objct
	local maxFaces = if rdbtn_OZ_PolygonsOrPercents.state == 1 \
						then (spnr_OZ_ProxyPolygons.value)
						else (((pCountArr[findItem inArr objct] / 100) * spnr_OZ_ProxyPercents.value) as integer)
	vraymeshexport meshFile:vrmeshName maxPreviewFaces:maxFaces minPreviewFaces:0
	append inputArr objct
	append outputArr (VRayProxy filename:vrmeshName display:3)
	prgrs_OZ_ProBar.value = 100.0*(findItem inArr objct)/(inArr.count)
	)
prgrs_OZ_ProBar.color = green; tmr_OZ_prgrsFade.active = true

for n = 1 to inputArr.count do instanceReplace inputArr[n] outputArr[n]
for objct in outputArr do delete objct
ATfn_.SelectInGroups inputArr
setCommandPanelTaskMode CPTM
enablesceneredraw()
completeredraw()
gc()
)
	-------------------------------------------------------------------------------------------------------------------
on rdbtn_OZ_PolygonsOrPercents changed state do (spnr_OZ_ProxyPolygons.enabled = (state==1); spnr_OZ_ProxyPercents.enabled = (state==2))
	-------------------------------------------------------------------------------------------------------------------
on chbtn_OZ_UseScenePath changed state do (edt_OZ_ProxyFolder.enabled = state; #(ddl_OZ_SetName, edt_OZ_CustomPath, btn_OZ_GetScenePath).enabled = not state)
	-------------------------------------------------------------------------------------------------------------------
on btn_OZ_GetScenePath pressed do
(
local SavePath = getSavePath initialDir:(edt_OZ_CustomPath.text) "\\"
if SavePath != undefined do (edt_OZ_CustomPath.text = try(trimright SavePath)catch(edt_OZ_CustomPath.text))
)
on btn_OZ_GetScenePath rightclick do if maxFilePath != "" do (edt_OZ_CustomPath.text = trimright maxFilePath "\\")
	-------------------------------------------------------------------------------------------------------------------
on ddl_OZ_SetName selected item do
(	
if keyboard.altPressed
then
	(
	local savedNamesArr = ddl_OZ_SetName.items
	if savedNamesArr[item] != "" then (deleteItem savedNamesArr item; ddl_OZ_SetName.items = deepCopy savedNamesArr)
	fn_ddlWidthDynamic ddl_OZ_SetName
	)
else (edt_OZ_CustomPath.text = (ddl_OZ_SetName.items)[item])
)
on ddl_OZ_SetName rightclick do
(	
if keyboard.altPressed
then
	(
	local savedNamesArr = ddl_OZ_SetName.items
	appendIfUnique savedNamesArr edt_OZ_CustomPath.text
	sort savedNamesArr
	ddl_OZ_SetName.items = deepCopy savedNamesArr
	fn_ddlWidthDynamic ddl_OZ_SetName
	setFocus edt_OZ_CustomPath
	)
else
	(
	edt_OZ_CustomPath.text = ""
	setFocus edt_OZ_CustomPath
	)
)
	-------------------------------------------------------------------------------------------------------------------
on btn_OZ_Freeze pressed do with undo on
(
local inArr = if chbtn_OZ_AffectInstances.checked \
	then (ATfn_.InstancesAppend (selection as array))
	else (selection as array)
if keyboard.altPressed do (inArr = for objct in objects where ((try ((getPolygonCount objct)[1]) catch (0)) > spnr_OZ_MinPolycount.value) collect objct)
inArr.isFrozen = true
completeRedraw()
)
	-------------------------------------------------------------------------------------------------------------------
on btn_OZ_UnfreezeAll pressed do with undo on (max unfreeze all; completeRedraw())
	-------------------------------------------------------------------------------------------------------------------
on btn_OZ_UnfreezeByHit pressed do with undo on
(
local pickObj = undefined do
	(
	pickObj = pickObject pickFrozen:true
	if pickObj != undefined
	then
		(
		if chbtn_OZ_AffectInstances.checked
			then (InstanceMgr.GetInstances pickObj &Instances; Instances.isFrozen = false)
-- 			then (local Instances = ATfn_.InstancesAppend #(pickObj); Instances.isFrozen = false)
			else (pickObj.isFrozen = false)
		completeRedraw()
		)
	) while (pickObj != undefined)
)
	-------------------------------------------------------------------------------------------------------------------
on rollout_OZ_ open do
	(
	if floater_AssemblyTool != undefined do (floater_AssemblyTool.rollouts[1].chbtn_TL_Optimizer.checked = true)
	fn_ddlWidthDynamic ddl_OZ_SetName
	)
on rollout_OZ_ close do
	(
	if floater_AssemblyTool != undefined do (floater_AssemblyTool.rollouts[1].chbtn_TL_Optimizer.checked = false)
	ATfn_.SaveFloaterINI floater_Optimizer iniFile ExcludedControls
	floater_Optimizer = undefined
	)
)
	----===============================================================================================================
floater_Optimizer = ATfn_.CreateFloater floater_Optimizer iniFile fl0W fl0H floaterTitle #(rollout_OZ_)
on execute do
	(
	if (hasINISetting iniFile floaterTitle) do (ATfn_.LoadFloaterINI floater_Optimizer iniFile ExcludedControls)
-- 	local fr1 = floater_Optimizer.rollouts[1]
-- 	fr1.edt_OZ_ProxyFolder.enabled = fr1.chbtn_OZ_UseScenePath.checked
-- 	fr1.ddl_OZ_SetName.enabled = fr1.edt_OZ_CustomPath.enabled = fr1.btn_OZ_GetScenePath.enabled = not fr1.chbtn_OZ_UseScenePath.checked
-- 	fr1.spnr_OZ_ProxyPolygons.enabled = (fr1.rdbtn_OZ_PolygonsOrPercents.state == 1)
-- 	fr1.spnr_OZ_ProxyPercents.enabled = (fr1.rdbtn_OZ_PolygonsOrPercents.state == 2)
	)
)