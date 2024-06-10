macroScript AssemblyTool
category:"#render-tools"
tooltip: "Assembly Tool"
ButtonText: "Assembly Tool"

(
Global floater_AssemblyTool
local mainScript = (GetDir #userScripts) + "\AssemblyTool" + "\AssemblyTool.ms"
on execute do
	(
	if doesFileExist mainScript
	then
		(
		if floater_AssemblyTool == undefined
		then (fileIn mainScript)
		else (if floater_AssemblyTool.dialogBar do (cui.UnRegisterDialogBar floater_AssemblyTool); closeRolloutFloater floater_AssemblyTool)
		)
	else (messagebox ("The script was not found :\n\n" + mainScript) title:"Script not found")
	)
)