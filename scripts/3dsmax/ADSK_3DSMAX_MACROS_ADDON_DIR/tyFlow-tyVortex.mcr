macroScript tyVortex
				category: "tyFlow" 
				internalCategory: "tyFlow" 
				tooltip: "tyVortex" 
				ButtonText: "tyVortex" 
				( 
					on execute do StartObjectCreation tyVortex 
					on isChecked return mcrUtils.IsCreating tyVortex 
					) 
