macroScript PHXSimulatorExportPrt category:"PhoenixFD" buttontext:"Chaos Phoenix Export PRT Particles..." tooltip:"Export PRT Particles"
		(
		local enabled = false
		fn checkNodeIsSimulator = (
			enabled = (classof($) == PHXSimulator) or (classof($) == FireSmokeSim) or (classof($) == LiquidSim)
		)
		on isVisible do(
			checkNodeIsSimulator()
			enabled
		)
		on isEnabled do(
			checkNodeIsSimulator()
			enabled
		)
		on execute do( PHXShowExportParticlesDialog() )
		)
