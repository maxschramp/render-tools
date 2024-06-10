-- (if ATIcons == undefined then (fileIn ((getFilenamePath(getThisScriptFilename())) + "AssemblyToolIcons.ms")))
-- (if ATfn_ == undefined then (fileIn ((getFilenamePath(getThisScriptFilename())) + "AssemblyToolStruct.ms")))
	-----------------
(
Global floater_MDLMaterialFilters
	--------
try (closeRolloutFloater floater_MDLMaterialFilters) catch()
	-------------------------------------------------------------------------------------------------------------------
local floaterTitle = "Filters"
local iniPath = (getFilenamePath (getThisScriptFilename())) + "INI\\"
local iniFile = iniPath + "MDLMaterialFilters_Settings.ini"
local fl0W = 220; local fl0H = (ATfn_.GetINI 0 iniFile floaterTitle "LastSize" [fl0W,500])[2]
-- local colCHBX = ATfn_.GetINI 0 (iniPath + "AssemblyTool_Settings.ini") "Preferences" "color_PS_ChBxColor" [255,156,0]
	--------
local ExcludedControls = #()
local ddl_Keys_ttp = " Assign Texture If Texture Name Contains Key From List "
local btn_AddKey_ttp = " Add Key To List "
	-----fn------------------------------------------------------------------------------------------------------------
FN fn_AddKeyToDDList ddlControl edtControl =
(
if edtControl.text == "" do return false
local items = ddlControl.items as Array
appendIfUnique items edtControl.text
-- sort items
ddlControl.items = items
edtControl.text = ""
setFocus edtControl
)
	-----fn------------------------------------------------------------------------------------------------------------
FN fn_DDListSelect ddlControl item =
(
if keyboard.altPressed
then
	(
	local items = ddlControl.items
	if items.count == 1 do return false
	deleteItem items item
	ddlControl.items = deepCopy items
	ddlControl.selection = 1
-- 	ATfn_.ddlWidthDynamic ddl_MDL_SetName
	)
else ()
)
	-----fn------------------------------------------------------------------------------------------------------------
	----=OmniPBR=================================================================================================
rollout rollout_OmniPBR_ "OmniPBR"
(
local yp1 = #(0, 66, 132, 198, 264, 330, 396, 462)
local PBR_AlbedoKeys = #("Albedo")
GroupBox grp_OmniPBR_Albedo "Albedo" pos:[2,yp1[1]] width:(fl0W-16) height:63
edittext edt_OmniPBR_AlbedoAddKey "" pos:[5,yp1[1]+16] width:(fl0W-50) height:17 bold:false
button btn_OmniPBR_AlbedoAddKey "+" pos:[178,yp1[1]+14] width:22 height:20 images:ATIcons[1] tooltip:btn_AddKey_ttp
dropdownlist ddl_OmniPBR_AlbedoKeys items:PBR_AlbedoKeys pos:[7,yp1[1]+37] width:194 height:33 selection:1 tooltip:ddl_Keys_ttp
local PBR_RoughnessKeys = #("Roughness")
GroupBox grp_OmniPBR_Roughness "Roughness" pos:[2,yp1[2]] width:(fl0W-16) height:63
edittext edt_OmniPBR_RoughnessAddKey "" pos:[5,yp1[2]+16] width:(fl0W-50) height:17 bold:false
button btn_OmniPBR_RoughnessAddKey "+" pos:[178,yp1[2]+14] width:22 height:20 images:ATIcons[1] tooltip:btn_AddKey_ttp
dropdownlist ddl_OmniPBR_RoughnessKeys items:PBR_RoughnessKeys pos:[7,yp1[2]+37] width:194 height:33 selection:1 tooltip:ddl_Keys_ttp
local PBR_MetallicKeys = #("Metallic")
GroupBox grp_OmniPBR_Metallic "Metallic" pos:[2,yp1[3]] width:(fl0W-16) height:63
edittext edt_OmniPBR_MetallicAddKey "" pos:[5,yp1[3]+16] width:(fl0W-50) height:17 bold:false
button btn_OmniPBR_MetallicAddKey "+" pos:[178,yp1[3]+14] width:22 height:20 images:ATIcons[1] tooltip:btn_AddKey_ttp
dropdownlist ddl_OmniPBR_MetallicKeys items:PBR_MetallicKeys pos:[7,yp1[3]+37] width:194 height:33 selection:1 tooltip:ddl_Keys_ttp
local PBR_ORMKeys = #("ORM")
GroupBox grp_OmniPBR_ORM "ORM" pos:[2,yp1[4]] width:(fl0W-16) height:63
edittext edt_OmniPBR_ORMAddKey "" pos:[5,yp1[4]+16] width:(fl0W-50) height:17 bold:false
button btn_OmniPBR_ORMAddKey "+" pos:[178,yp1[4]+14] width:22 height:20 images:ATIcons[1] tooltip:btn_AddKey_ttp
dropdownlist ddl_OmniPBR_ORMKeys items:PBR_ORMKeys pos:[7,yp1[4]+37] width:194 height:33 selection:1 tooltip:ddl_Keys_ttp
local PBR_AOKeys = #("AO")
GroupBox grp_OmniPBR_AO "AO" pos:[2,yp1[5]] width:(fl0W-16) height:63
edittext edt_OmniPBR_AOAddKey "" pos:[5,yp1[5]+16] width:(fl0W-50) height:17 bold:false
button btn_OmniPBR_AOAddKey "+" pos:[178,yp1[5]+14] width:22 height:20 images:ATIcons[1] tooltip:btn_AddKey_ttp
dropdownlist ddl_OmniPBR_AOKeys items:PBR_AOKeys pos:[7,yp1[5]+37] width:194 height:33 selection:1 tooltip:ddl_Keys_ttp
local PBR_EmissiveKeys = #("Emissive")
GroupBox grp_OmniPBR_Emissive "Emissive" pos:[2,yp1[6]] width:(fl0W-16) height:63
edittext edt_OmniPBR_EmissiveAddKey "" pos:[5,yp1[6]+16] width:(fl0W-50) height:17 bold:false
button btn_OmniPBR_EmissiveAddKey "+" pos:[178,yp1[6]+14] width:22 height:20 images:ATIcons[1] tooltip:btn_AddKey_ttp
dropdownlist ddl_OmniPBR_EmissiveKeys items:PBR_EmissiveKeys pos:[7,yp1[6]+37] width:194 height:33 selection:1 tooltip:ddl_Keys_ttp
local PBR_OpacityKeys = #("Opacity")
GroupBox grp_OmniPBR_Opacity "Opacity" pos:[2,yp1[7]] width:(fl0W-16) height:63
edittext edt_OmniPBR_OpacityAddKey "" pos:[5,yp1[7]+16] width:(fl0W-50) height:17 bold:false
button btn_OmniPBR_OpacityAddKey "+" pos:[178,yp1[7]+14] width:22 height:20 images:ATIcons[1] tooltip:btn_AddKey_ttp
dropdownlist ddl_OmniPBR_OpacityKeys items:PBR_OpacityKeys pos:[7,yp1[7]+37] width:194 height:33 selection:1 tooltip:ddl_Keys_ttp
local PBR_NormalKeys = #("Normal")
GroupBox grp_OmniPBR_Normal "Normal" pos:[2,yp1[8]] width:(fl0W-16) height:63
edittext edt_OmniPBR_NormalAddKey "" pos:[5,yp1[8]+16] width:(fl0W-50) height:17 bold:false
button btn_OmniPBR_NormalAddKey "+" pos:[178,yp1[8]+14] width:22 height:20 images:ATIcons[1] tooltip:btn_AddKey_ttp
dropdownlist ddl_OmniPBR_NormalKeys items:PBR_NormalKeys pos:[7,yp1[8]+37] width:194 height:33 selection:1 tooltip:ddl_Keys_ttp
	-----fn------------------------------------------------------------------------------------------------------------
	-----fn------------------------------------------------------------------------------------------------------------
on btn_OmniPBR_AlbedoAddKey pressed do (fn_AddKeyToDDList ddl_OmniPBR_AlbedoKeys edt_OmniPBR_AlbedoAddKey)
	-------------------------------------------------------------------------------
on ddl_OmniPBR_AlbedoKeys selected item do (fn_DDListSelect ddl_OmniPBR_AlbedoKeys item)
	-------------------------------------------------------------------------------------------------------------------
on btn_OmniPBR_RoughnessAddKey pressed do (fn_AddKeyToDDList ddl_OmniPBR_RoughnessKeys edt_OmniPBR_RoughnessAddKey)
	-------------------------------------------------------------------------------
on ddl_OmniPBR_RoughnessKeys selected item do (fn_DDListSelect ddl_OmniPBR_RoughnessKeys item)
	-------------------------------------------------------------------------------------------------------------------
on btn_OmniPBR_MetallicAddKey pressed do (fn_AddKeyToDDList ddl_OmniPBR_MetallicKeys edt_OmniPBR_MetallicAddKey)
	-------------------------------------------------------------------------------
on ddl_OmniPBR_MetallicKeys selected item do (fn_DDListSelect ddl_OmniPBR_MetallicKeys item)
	-------------------------------------------------------------------------------------------------------------------
on btn_OmniPBR_ORMAddKey pressed do (fn_AddKeyToDDList ddl_OmniPBR_ORMKeys edt_OmniPBR_ORMAddKey)
	-------------------------------------------------------------------------------
on ddl_OmniPBR_ORMKeys selected item do (fn_DDListSelect ddl_OmniPBR_ORMKeys item)
	-------------------------------------------------------------------------------------------------------------------
on btn_OmniPBR_AOAddKey pressed do (fn_AddKeyToDDList ddl_OmniPBR_AOKeys edt_OmniPBR_AOAddKey)
	-------------------------------------------------------------------------------
on ddl_OmniPBR_AOKeys selected item do (fn_DDListSelect ddl_OmniPBR_AOKeys item)
	-------------------------------------------------------------------------------------------------------------------
on btn_OmniPBR_EmissiveAddKey pressed do (fn_AddKeyToDDList ddl_OmniPBR_EmissiveKeys edt_OmniPBR_EmissiveAddKey)
	-------------------------------------------------------------------------------
on ddl_OmniPBR_EmissiveKeys selected item do (fn_DDListSelect ddl_OmniPBR_EmissiveKeys item)
	-------------------------------------------------------------------------------------------------------------------
on btn_OmniPBR_OpacityAddKey pressed do (fn_AddKeyToDDList ddl_OmniPBR_OpacityKeys edt_OmniPBR_OpacityAddKey)
	-------------------------------------------------------------------------------
on ddl_OmniPBR_OpacityKeys selected item do (fn_DDListSelect ddl_OmniPBR_OpacityKeys item)
	-------------------------------------------------------------------------------------------------------------------
on btn_OmniPBR_NormalAddKey pressed do (fn_AddKeyToDDList ddl_OmniPBR_NormalKeys edt_OmniPBR_NormalAddKey)
	-------------------------------------------------------------------------------
on ddl_OmniPBR_NormalKeys selected item do (fn_DDListSelect ddl_OmniPBR_NormalKeys item)
	-------------------------------------------------------------------------------------------------------------------
	--^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
-- on rollout_OmniPBR_ open do
-- 	(
-- 	)
on rollout_OmniPBR_ close do
	(
	try (ATfn_.SaveFloaterINI floater_MDLMaterialFilters iniFile ExcludedControls) catch (print "--- Error --->>> Close MDL Material Filters")
	try (rollout_MDLMaterial.chbtn_MDL_MDLMaterialFilters.checked = false) catch()
	floater_MDLMaterialFilters = undefined
	)
)
	/*
	----=OmniGlass=================================================================================================
rollout rollout_GLS_ "OmniGlass"
(
local yp1 = #(0, 66, 132, 198, 264)
local Surface_AlbedoKeys = #("Albedo")
GroupBox grp_GLS_Albedo "Albedo" pos:[2,yp1[1]] width:(fl0W-16) height:63
edittext edt_GLS_AlbedoAddKey "" pos:[5,yp1[1]+16] width:(fl0W-50) height:17 bold:false
button btn_GLS_AlbedoAddKey "+" pos:[178,yp1[1]+14] width:22 height:20 images:ATIcons[1] tooltip:btn_AddKey_ttp
dropdownlist ddl_GLS_AlbedoKeys items:Surface_AlbedoKeys pos:[7,yp1[1]+37] width:194 height:33 selection:1 tooltip:ddl_Keys_ttp
local Surface_ORMKeys = #("ORM")
GroupBox grp_GLS_ORM "ORM" pos:[2,yp1[2]] width:(fl0W-16) height:63
edittext edt_GLS_ORMAddKey "" pos:[5,yp1[2]+16] width:(fl0W-50) height:17 bold:false
button btn_GLS_ORMAddKey "+" pos:[178,yp1[2]+14] width:22 height:20 images:ATIcons[1] tooltip:btn_AddKey_ttp
dropdownlist ddl_GLS_ORMKeys items:Surface_ORMKeys pos:[7,yp1[2]+37] width:194 height:33 selection:1 tooltip:ddl_Keys_ttp
local Surface_NormalKeys = #("Normal")
GroupBox grp_GLS_Normal "Normal" pos:[2,yp1[3]] width:(fl0W-16) height:63
edittext edt_GLS_NormalAddKey "" pos:[5,yp1[3]+16] width:(fl0W-50) height:17 bold:false
button btn_GLS_NormalAddKey "+" pos:[178,yp1[3]+14] width:22 height:20 images:ATIcons[1] tooltip:btn_AddKey_ttp
dropdownlist ddl_GLS_NormalKeys items:Surface_NormalKeys pos:[7,yp1[3]+37] width:194 height:33 selection:1 tooltip:ddl_Keys_ttp
local Surface_OpacityKeys = #("Opacity")
GroupBox grp_GLS_Opacity "Opacity" pos:[2,yp1[4]] width:(fl0W-16) height:63
edittext edt_GLS_OpacityAddKey "" pos:[5,yp1[4]+16] width:(fl0W-50) height:17 bold:false
button btn_GLS_OpacityAddKey "+" pos:[178,yp1[4]+14] width:22 height:20 images:ATIcons[1] tooltip:btn_AddKey_ttp
dropdownlist ddl_GLS_OpacityKeys items:Surface_OpacityKeys pos:[7,yp1[4]+37] width:194 height:33 selection:1 tooltip:ddl_Keys_ttp
local Surface_EmissiveKeys = #("Emissive")
GroupBox grp_GLS_Emissive "Emissive" pos:[2,yp1[5]] width:(fl0W-16) height:63
edittext edt_GLS_EmissiveAddKey "" pos:[5,yp1[5]+16] width:(fl0W-50) height:17 bold:false
button btn_GLS_EmissiveAddKey "+" pos:[178,yp1[5]+14] width:22 height:20 images:ATIcons[1] tooltip:btn_AddKey_ttp
dropdownlist ddl_GLS_EmissiveKeys items:Surface_EmissiveKeys pos:[7,yp1[5]+37] width:194 height:33 selection:1 tooltip:ddl_Keys_ttp
	-----fn------------------------------------------------------------------------------------------------------------
	-----fn------------------------------------------------------------------------------------------------------------
on btn_GLS_AlbedoAddKey pressed do (fn_AddKeyToDDList ddl_GLS_AlbedoKeys edt_GLS_AlbedoAddKey)
	-------------------------------------------------------------------------------
on ddl_GLS_AlbedoKeys selected item do (fn_DDListSelect ddl_GLS_AlbedoKeys item)
	-------------------------------------------------------------------------------------------------------------------
on btn_GLS_ORMAddKey pressed do (fn_AddKeyToDDList ddl_GLS_ORMKeys edt_GLS_ORMAddKey)
	-------------------------------------------------------------------------------
on ddl_GLS_ORMKeys selected item do (fn_DDListSelect ddl_GLS_ORMKeys item)
	-------------------------------------------------------------------------------------------------------------------
on btn_GLS_NormalAddKey pressed do (fn_AddKeyToDDList ddl_GLS_NormalKeys edt_GLS_NormalAddKey)
	-------------------------------------------------------------------------------
on ddl_GLS_NormalKeys selected item do (fn_DDListSelect ddl_GLS_NormalKeys item)
	-------------------------------------------------------------------------------------------------------------------
on btn_GLS_OpacityAddKey pressed do (fn_AddKeyToDDList ddl_GLS_OpacityKeys edt_GLS_OpacityAddKey)
	-------------------------------------------------------------------------------
on ddl_GLS_OpacityKeys selected item do (fn_DDListSelect ddl_GLS_OpacityKeys item)
	-------------------------------------------------------------------------------------------------------------------
on btn_GLS_OpacityAddKey pressed do (fn_AddKeyToDDList ddl_GLS_OpacityKeys edt_GLS_OpacityAddKey)
	-------------------------------------------------------------------------------
on ddl_GLS_OpacityKeys selected item do (fn_DDListSelect ddl_GLS_OpacityKeys item)
	-------------------------------------------------------------------------------------------------------------------
on btn_GLS_EmissiveAddKey pressed do (fn_AddKeyToDDList ddl_GLS_EmissiveKeys edt_GLS_EmissiveAddKey)
	-------------------------------------------------------------------------------
on ddl_GLS_EmissiveKeys selected item do (fn_DDListSelect ddl_GLS_EmissiveKeys item)
	-------------------------------------------------------------------------------------------------------------------
	--^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
-- on rollout_GLS_ open do
-- 	(
-- 	)
on rollout_GLS_ close do
	(
	floater_MDLMaterialFilters = undefined
	)
)
--  */
	----===============================================================================================================
floater_MDLMaterialFilters = ATfn_.CreateFloater floater_MDLMaterialFilters iniFile fl0W fl0H floaterTitle \
#(rollout_OmniPBR_)
-- #(rollout_OmniPBR_, rollout_GLS_)
on execute do
	(
	if (hasINISetting iniFile rollout_OmniPBR_.title) do
		(
		ATfn_.LoadFloaterINI floater_MDLMaterialFilters iniFile ExcludedControls
		)
	)
)