MacroScript AdjustOutput
	category:"#render-tools"
	tooltip:"Adjust Output Values of selected nodes"
	buttontext:"Adjust Output Values"
(
	fn AdjustOutputAmount amt =
	(
		view = sme.GetView sme.activeView
		selected_nodes = view.GetSelectedNodes()

		for nodes in selected_nodes do
		(
			if amt == 0 then
			(
				i = nodes.reference.output.output_amount
				nodes.reference.output.output_amount = 1.0
				print nodes.reference.output.output_amount
			)
			else
			(
				i = nodes.reference.output.output_amount
				nodes.reference.output.output_amount = i + amt
				print nodes.reference.output.output_amount
			)
		)
	)
	
	fn resetIOR = 
	(
		view = sme.GetView sme.activeView
		selected_nodes = view.GetSelectedNodes()

		for nodes in selected_nodes do
		(
			nodes.reference.baseIor = 1.5
			nodes.reference.baseIorTexmapOn = false
			nodes.reference.baseRoughness = 1.0
			nodes.reference.baseRoughnessTexmapOn = false
			
			print nodes.reference.baseIor
			print nodes.reference.baseIorTexmapOn
		)
	)

	rollout valueRollout "Output Amount"
	(
		button btnMinus1  "-1.0"
		button btnMinus05 "-0.5"
		button btnReset   "Reset"
		button btnPlus05  "+0.5"
		button btnPlus1   "+1.0"
		button btnResetIor "Reset IOR"

		on btnMinus1 pressed do
		(
			format "Button -1.0 pressed\n"
			AdjustOutputAmount(-1.0)
			
		)
		on btnMinus05 pressed do
		(
			format "Button -0.5 pressed\n"
			AdjustOutputAmount(-0.5)
		)
		on btnReset pressed do
		(
			format "Button Reset pressed\n"
			AdjustOutputAmount(0)
		)
		on btnPlus05 pressed do
		(
			format "Button +0.5 pressed\n"
			AdjustOutputAmount(0.5)
		)
		on btnPlus1 pressed do
		(
			format "Button +1.0 pressed\n"
			AdjustOutputAmount(1.0)
		)
		on btnResetIor pressed do
		(
			format "Button Reset IOR pressed\n"
			resetIOR()
		)
		
	)

	createDialog valueRollout width:100 height:200
)