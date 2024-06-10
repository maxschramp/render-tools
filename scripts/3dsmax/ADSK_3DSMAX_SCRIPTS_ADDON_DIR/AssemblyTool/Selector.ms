(
Global rollout_Selector
Global floater_AssemblyTool
try(if rollout_Selector.dialogBar then (cui.UnRegisterDialogBar rollout_Selector); destroyDialog rollout_Selector)catch()
	-------------------------------------------------------------------------------------------------------------------
local rollTitle = "Selector"
local iniPath = (getFilenamePath (getThisScriptFilename())) + "INI\\"
local iniFile = iniPath + "Selector_Settings.ini"
local roll0S = ATfn_.GetINI 0 iniFile rollTitle "LastSize" [220,500]; local roll0W = roll0S[1]; local roll0H = roll0S[2]
local colCHBX = ATfn_.GetINI 0 (iniPath + "AssemblyTool_Settings.ini") "Preferences" "color_PS_ChBxColor" [255,156,0]
local ExcludedControls = #("btn_SE_DockLeft", "btn_SE_DockFloat", "btn_SE_DockRight", "mlbx_SE_SetsList")
	----================================================================================================================================
rollout rollout_Selector rollTitle
(
local DockX = 15; local DockW = 13
button btn_SE_DockLeft "<" pos:[DockX-DockW,2] width:DockW height:10 tooltip:" Dock Left "
button btn_SE_DockFloat "::" pos:[DockX,2] width:DockW height:10 tooltip:" Float "
button btn_SE_DockRight ">" pos:[DockX+DockW,2] width:DockW height:10 tooltip:" Dock Right "
on btn_SE_DockLeft pressed do (ATfn_.DockRolloutSide rollout_Selector iniFile "left")
on btn_SE_DockRight pressed do (ATfn_.DockRolloutSide rollout_Selector iniFile "right")
on btn_SE_DockFloat pressed do (ATfn_.DockRolloutFloat rollout_Selector iniFile roll0W roll0H)
	-------
dropdownlist ddl_SE_SetName items:#() pos:[3,13] width:20 height:33 selection:0 tooltip:" Lmb - Choose Name \n Alt+Lmb - Delete Name \n Rmb - Clear Fild \n Alt+Rmb - Save Name "
edittext edt_SE_SetName "" pos:[20,14] width:(roll0W-24) height:17 bold:false
button btn_SE_AddSet "+" width:22 height:21 pos:[4,36] images:ATIcons[1] tooltip:" Add Selection Set "
button btn_SE_RemoveSet "-" width:22 height:21 pos:[29,36] images:ATIcons[2] tooltip:" Remove Selection Sets "
button btn_SE_AddToSet "{+}" width:22 height:21 pos:[54,36] images:ATIcons[39] tooltip:" Add Selected To Set "
button btn_SE_SubtractFromSet "{-}" width:22 height:21 pos:[79,36] images:ATIcons[40] tooltip:" Subtract Selected From Set "
button btn_SE_Up "Up" width:22 height:21 pos:[104,36] images:ATIcons[23] tooltip:" Lmb - Move Selected In List Up \n Rmb - Move Selected In List Top "
button btn_SE_Down "Dn" width:22 height:21 pos:[129,36] images:ATIcons[24] tooltip:" Lmb - Move Selected In List Down \n Rmb - Move Selected In List Bottom "
button btn_SE_SortAlphabet "A-Z" width:22 height:21 pos:[154,36] images:ATIcons[27] tooltip:" Sort List Alphabetically "
button btn_SE_SortReverse "R" width:22 height:21 pos:[179,36] images:ATIcons[28] tooltip:" Reverse List Order "
checkButton chbtn_SE_AddCounter "" pos:[5,62] width:14 height:14 checked:true highlightColor:colCHBX toolTip:" Add Counter to Set Name "
label lbl_SE_AddCounter "Add Counter" pos:[23,62] toolTip:chbtn_SE_AddCounter.toolTip
multilistbox mlbx_SE_SetsList items:(for ss in 1 to (getNumNamedSelSets()) collect (getNamedSelSetName ss)) pos:[0,80] width:(rollout_Selector.width-0) height:100 tooltip:" Lmb - Select Sets \n DoubleClick - Rename Set \n Rmb - Deselect List Items "
	-----fn------------------------------------------------------------------------------------------------------------
FN fn_msgSetNameExist setName = (messageBox ("Set Name \"" + setName + "\" Already Exists.") title:"Name Exists!" beep:false)
	-----fn------------------------------------------------------------------------------------------------------------
FN fn_ddlWidthDynamic ddl =
(
local ddl_koef = 5.; local ddlLim = 30.
local itemsArr = ddl.items
local maxStr = 100; if itemsArr.count != 0 then (strCountArr = (for f in itemsArr collect f.count);  maxStr = aMax strCountArr)
windows.sendmessage ddl.hwnd[1] 352 (maxStr*(ddl_koef + ddlLim/maxStr)) 0
)
	-----fn------------------------------------------------------------------------------------------------------------
-- FN fn_getNamedSelSets = (for ss in 1 to (getNumNamedSelSets()) collect (getNamedSelSetName ss))
-- (
-- local SetListItems = #()
-- for ss in 1 to (getNumNamedSelSets()) do (append SetListItems (getNamedSelSetName ss))
-- return SetListItems
-- )
	-----fn------------------------------------------------------------------------------------------------------------
FN fn_setListItems = (mlbx_SE_SetsList.items = for ss in 1 to (getNumNamedSelSets()) collect (getNamedSelSetName ss))
	-----fn------------------------------------------------------------------------------------------------------------
FN fn_CompareStr str1 str2 = (stricmp str1 str2)
	-----fn------------------------------------------------------------------------------------------------------------
FN fn_SortSSetsList a1_r2 =
(
local SelNames = for nn in (mlbx_SE_SetsList.selection as array) collect mlbx_SE_SetsList.items[nn]
local ListItems = deepCopy mlbx_SE_SetsList.items
local SetsArr = #(); for i=1 to mlbx_SE_SetsList.items.count do (NamedSelectionSetManager.GetNamedSelSetList &GetSet (i-1); append SetsArr GetSet)
case a1_r2 of
	(
	1: qsort ListItems fn_CompareStr
	2: ListItems = for i=ListItems.count to 1 by -1 collect ListItems[i]
	)
local NewSetsArr = #(); for i in ListItems do (append NewSetsArr (SetsArr[findItem mlbx_SE_SetsList.items i]))
for item in mlbx_SE_SetsList.items do (deleteItem selectionSets item)
for n=1 to ListItems.count do (selectionSets[(ListItems[n])] = NewSetsArr[n])
fn_setListItems()
mlbx_SE_SetsList.selection = for sn in SelNames collect findItem mlbx_SE_SetsList.items sn
)
	-----fn------------------------------------------------------------------------------------------------------------
FN fn_MoveInSSetsListUp ToTop =
(
local SetsArr = #(); for i=1 to mlbx_SE_SetsList.items.count do (NamedSelectionSetManager.GetNamedSelSetList &GetSet (i-1); append SetsArr GetSet)
ATfn_.MoveInListUp mlbx_SE_SetsList SetsArr ToTop
local ListSelection = for i=(mlbx_SE_SetsList.selection as array).count to 1 by -1 collect (mlbx_SE_SetsList.selection as array)[i]
local ListItems = mlbx_SE_SetsList.items
for item in mlbx_SE_SetsList.items do (deleteItem selectionSets item)
for n=1 to ListItems.count do (selectionSets[(ListItems[n])] = SetsArr[n])
fn_setListItems()
mlbx_SE_SetsList.selection = ListSelection as BitArray
)
	-----fn------------------------------------------------------------------------------------------------------------
FN fn_MoveInSSetsListDown ToBottom =
(
local SetsArr = #(); for i=1 to mlbx_SE_SetsList.items.count do (NamedSelectionSetManager.GetNamedSelSetList &GetSet (i-1); append SetsArr GetSet)
ATfn_.MoveInListDown mlbx_SE_SetsList SetsArr ToBottom
local ListSelection = for i=(mlbx_SE_SetsList.selection as array).count to 1 by -1 collect (mlbx_SE_SetsList.selection as array)[i]
local ListItems = mlbx_SE_SetsList.items
for item in mlbx_SE_SetsList.items do (deleteItem selectionSets item)
for n=1 to ListItems.count do (selectionSets[(ListItems[n])] = SetsArr[n])
fn_setListItems()
mlbx_SE_SetsList.selection = ListSelection as BitArray
)
	-----fn------------------------------------------------------------------------------------------------------------
	-------------------------------------------------------------------------------------------------------------------
on btn_SE_SortReverse pressed do with undo off (fn_SortSSetsList 2)
	-------------------------------------------------------------------------------------------------------------------
on btn_SE_SortAlphabet pressed do with undo off (fn_SortSSetsList 1)
	-------------------------------------------------------------------------------------------------------------------
on btn_SE_Up pressed do with undo off (fn_MoveInSSetsListUp false)
	-------
on btn_SE_Up rightclick do with undo off (fn_MoveInSSetsListUp true)
	-------------------------------------------------------------------------------------------------------------------
on btn_SE_Down pressed do with undo off (fn_MoveInSSetsListDown false)
	-------
on btn_SE_Down rightclick do with undo off (fn_MoveInSSetsListDown true)
	-------------------------------------------------------------------------------------------------------------------
on ddl_SE_SetName selected item do
(	
if keyboard.altPressed
then
	(
	local savedNamesArr = ddl_SE_SetName.items
	if savedNamesArr[item] != "" then (deleteItem savedNamesArr item; ddl_SE_SetName.items = deepCopy savedNamesArr)
	fn_ddlWidthDynamic ddl_SE_SetName
	)
else (edt_SE_SetName.text = (ddl_SE_SetName.items)[item])
)
	-------------------------------------------------------------------------------------------------------------------
on ddl_SE_SetName rightclick do
(	
if keyboard.altPressed
then
	(
	local savedNamesArr = ddl_SE_SetName.items
	appendIfUnique savedNamesArr edt_SE_SetName.text
	sort savedNamesArr
	ddl_SE_SetName.items = deepCopy savedNamesArr
	fn_ddlWidthDynamic ddl_SE_SetName
	setFocus edt_SE_SetName
	)
else
	(
	edt_SE_SetName.text = ""
	setFocus edt_SE_SetName
	)
)
	-------------------------------------------------------------------------------------------------------------------
on mlbx_SE_SetsList selectionEnd do with undo off 
(
clearSelection()
local items = mlbx_SE_SetsList.items
local selArr = #()
for n in mlbx_SE_SetsList.selection do (selArr += selectionSets[items[n]])
select selArr
forceCompleteRedraw()
-- mlbx_SE_SetsList.selection = #{}
)
on mlbx_SE_SetsList rightclick do with undo off (mlbx_SE_SetsList.selection = #{})
	-------------------------------------------------------------------------------------------------------------------
-- on mlbx_SE_SetsList doubleClicked arg do
-- (
-- Global g_oldName = rollout_Selector.mlbx_SE_SetsList.items[arg]
-- rollout rolloutRenameSSet "MoveToLayer"
-- 	(
-- 	edittext edt_Name pos:[0,6] width:200 height:17
-- 	on edt_Name entered txt do
-- 		(
-- 		selectionSets[g_oldName].name = txt
-- 		Destroydialog rolloutRenameSSet
-- 		fn_setListItems()
-- 		)
-- 	on rolloutRenameSSet open do (edt_Name.text = g_oldName)
-- 	on rolloutRenameSSet close do (GlobalVars.remove "g_oldName")
-- 	)
-- createDialog rolloutRenameSSet 204 28 style:#(#style_titlebar, #style_toolwindow, #style_sysmenu)
-- setFocus rolloutRenameSSet.edt_Name
-- )
on mlbx_SE_SetsList doubleClicked arg do
(
local oldName = rollout_Selector.mlbx_SE_SetsList.items[arg]
local NewName = undefined
local DNObj = dotNetObject "MaxCustomControls.RenameInstanceDialog" oldName
DNObj.text = "Rename Selection Set"
local DialogResult = DNObj.Showmodal()
if (dotnet.compareenums DNObj.DialogResult ((dotnetclass "System.Windows.Forms.DialogResult").OK)) then (NewName = DNObj.InstanceName)
if NewName != undefined do
	(
	if NewName == "" do NewName = "Set"
	if selectionSets[NewName] != undefined do return (fn_msgSetNameExist NewName)
	selectionSets[oldName].name = NewName
	fn_setListItems()
	)
)
	-------------------------------------------------------------------------------------------------------------------
on btn_SE_AddToSet pressed do with undo on
(
local ListSel = mlbx_SE_SetsList.selection as array
if ListSel.count != 1 do return messageBox "Select In List One Set To Which Add Objects." title:" Selector"
if selection.count == 0 do return messageBox "Select Objects Which Add To Set." title:" Selector"
local SSetName = mlbx_SE_SetsList.items[ListSel[1]]
local SSetArr = for o in selectionSets[SSetName] collect o
for objct in (selection as array) do (appendIfUnique SSetArr objct)
selectionSets[SSetName] = SSetArr
select SSetArr
)
	-------------------------------------------------------------------------------------------------------------------
on btn_SE_SubtractFromSet pressed do with undo on
(
local ListSel = mlbx_SE_SetsList.selection as array
if ListSel.count != 1 do return messageBox "Select In List One Set From Which Subtract Objects." title:" Selector"
if selection.count == 0 do return messageBox "Select Objects Which Subtract From Set." title:" Selector"
local SSetName = mlbx_SE_SetsList.items[ListSel[1]]
local SSetArr = for o in selectionSets[SSetName] collect o
SSetArr = ATfn_.ArraysDifference SSetArr (selection as array)
selectionSets[SSetName] = SSetArr
select SSetArr
)
	-------------------------------------------------------------------------------------------------------------------
on btn_SE_AddSet pressed do
(
local items = mlbx_SE_SetsList.items
if selection.count != 0
then
	(
	local SetName = ""
	local SaveName = ""
	if chbtn_SE_AddCounter.checked
	then
		(
		SetName = edt_SE_SetName.text + "_"
		if SetName == "_" do SetName = "Set_"
		SaveName = ""; local n = 0
		do  (
			SaveName = SetName
			n += 1
	-- 		SaveName += (if n<10 then ("00"+(n as string)) else (if n<100 then ("0"+(n as string)) else (n as string)))
			SaveName += (if n<10 then ("0"+(n as string)) else (n as string))
			) while (findItem items SaveName != 0)
		)
	else
		(
		SetName = edt_SE_SetName.text
		if (findItem items SetName != 0)
		then (return (fn_msgSetNameExist SetName))
		else (SaveName = SetName)
		)
	selectionSets[SaveName] = (selection as array)
-- 	fn_setListItems()
	) else (messageBox "Objects Not Selected." title:" Selector" beep:false)
)
	-------------------------------------------------------------------------------------------------------------------
on btn_SE_RemoveSet pressed do
(
local items = mlbx_SE_SetsList.items
for n in mlbx_SE_SetsList.selection do (deleteItem selectionSets items[n])
-- fn_setListItems()
)
	-------------------------------------------------------------------------------------------------------------------
on rollout_Selector resized size do
	(
	mlbx_SE_SetsList.width = size[1] - 0
	mlbx_SE_SetsList.height = size[2] - 79
-- 	if size[1] < 204 then rollout_Selector.width = 204
-- 	if size[2] < 100 then rollout_Selector.height = 100
	edt_SE_SetName.width = size[1] - 28
	)
	-------------------------------------------------------------------------------------------------------------------
on rollout_Selector open do
	(
	ATfn_.LoadRolloutINI rollout_Selector iniFile ExcludedControls
	mlbx_SE_SetsList.height = rollout_Selector.height - 79
	fn_setListItems()
	fn_ddlWidthDynamic ddl_SE_SetName
	if floater_AssemblyTool != undefined do (floater_AssemblyTool.rollouts[1].chbtn_TL_Selector.checked = true)
	callbacks.addScript #NamedSelSetCreated "rollout_Selector.fn_setListItems()" id:#ATcallbacks_SE_
	callbacks.addScript #NamedSelSetDeleted "rollout_Selector.fn_setListItems()" id:#ATcallbacks_SE_
	callbacks.addScript #nodePostDelete "rollout_Selector.fn_setListItems()" id:#ATcallbacks_SE_
	callbacks.addScript #filePostOpenProcess "rollout_Selector.fn_setListItems()" id:#ATcallbacks_SE_
	)
	-------------------------------------------------------------------------------------------------------------------
on rollout_Selector close do 
	(
	if floater_AssemblyTool != undefined do (floater_AssemblyTool.rollouts[1].chbtn_TL_Selector.checked = false)
	ATfn_.SaveRolloutINI rollout_Selector iniFile ExcludedControls
	callbacks.removeScripts id:#ATcallbacks_SE_
	rollout_Selector = undefined
	gc light:true
	)
)
	----================================================================================================================================
rollout_Selector = ATfn_.CreateRollout rollout_Selector iniFile rollTitle roll0W roll0H \
RStyle:#(#style_resizing, #style_titlebar, #style_sysmenu, #style_minimizebox, #style_maximizebox)
-------------------------------------------------------------------------------------------------------------
)
