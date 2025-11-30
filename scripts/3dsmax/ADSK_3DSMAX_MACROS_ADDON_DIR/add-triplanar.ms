

MacroScript CoronaBitmapTriplanar
	category:"#render-tools"
	tooltip:"Enable triplanar mapping in CoronaBitmap"
	buttontext:"Triplanar CoronaBitmap"
(
	fn AddTriplanar =
	(
		view = sme.GetView sme.activeView
		selected_nodes = view.GetSelectedNodes()

		for n in selected_nodes do
		(
			n.reference.triplanarMapping = True
			n.reference.triplanarScale = 1.0
			format "Enabled triplanar mapping for CoronaBitmap: %\n" n.name
		)
	)
	
	fn RemoveTriplanar =
	(
		view = sme.GetView sme.activeView
		selected_nodes = view.GetSelectedNodes()

		for n in selected_nodes do
		(
			n.reference.triplanarMapping = False
			n.reference.triplanarScale = 1.0
			format "Disabled triplanar mapping for CoronaBitmap: %\n" n.name
		)
	)
	

	rollout valueRollout "Output Amount"
	(
		button add_triplanar  "Add Triplanar"
		button remove_triplanar "Remove Triplanar"

		on add_triplanar pressed do
		(
			format "Adding Triplanar\n"
			AddTriplanar()
			
		)
		on remove_triplanar pressed do
		(
			format "Removing Triplanar\n"
			RemoveTriplanar()
		)
		
	)

	createDialog valueRollout width:100 height:200
)