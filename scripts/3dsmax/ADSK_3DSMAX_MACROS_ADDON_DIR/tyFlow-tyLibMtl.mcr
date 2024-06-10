macroScript tyLibMtl
				category: "tyFlow" 
				internalCategory: "tyFlow" 
				tooltip: "tyLibMtl" 
				ButtonText: "tyLibMtl" 
				( 
					on execute do StartObjectCreation tyLibMtl 
					on isChecked return mcrUtils.IsCreating tyLibMtl 
					) 
