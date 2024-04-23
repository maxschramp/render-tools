macroScript displacementPresets buttontext: "Displacement Presets" toolTip:"Displacement Presets" category:"#render-tools"
(

fn setDisplacement = (
	selectedNodes = (sme.GetView(sme.activeView)).GetSelectedNodes()
	for i = 1 to (selectedNodes.count) do
	(
		print selectedNodes[i].reference
		selectedNodes[i].reference.displacementMinimum = displacementLevel * -1
		selectedNodes[i].reference.displacementMaximum = displacementLevel
	)
)

rollout displacementRollout "Displacement Presets" -- width:162 height:148
(
	global displacementLevel = 0
	
	
	button 'btn1' "Set Displacement" pos:[4,113] width:151 height:20 align:#left
	button 'btn2' "100mm" pos:[4,32] width:75 height:20 align:#left
	button 'btn4' "1000mm" pos:[4,57] width:75 height:20 align:#left
	button 'btn6' "10mm" pos:[4,7] width:75 height:20 align:#left
	spinner 'spn1' "Custom" pos:[4,89] width:152 height:16 range:[0,10000,0] type:#worldunits scale:0.1 controller:undefined align:#left
	button 'btn9' "500mm" pos:[82,33] width:75 height:20 align:#left
	button 'btn10' "2000mm" pos:[82,58] width:75 height:20 align:#left
	button 'btn11' "50mm" pos:[82,8] width:75 height:20 align:#left
	
	on btn2 pressed  do
	(	displacementLevel = 10
		setDisplacement()
	)
	on btn4 pressed  do
	(	displacementLevel = 100
		setDisplacement()
	)
	on btn6 pressed  do
	(	displacementLevel = 1
		setDisplacement()
	)
	on btn9 pressed  do
	(	displacementLevel = 50
		setDisplacement()
	)
	on btn10 pressed  do
	(	displacementLevel = 200
		setDisplacement()
	)
	on btn11 pressed  do
	(	displacementLevel = 5
		setDisplacement()
	)
	on spn1 changed theVal do
	(	displacementLevel = theVal
		-- print displacementLevel
		)
	on btn1 pressed  do
	(
		setDisplacement() 
	)
)
CreateDialog displacementRollout width:162 height:148
)
