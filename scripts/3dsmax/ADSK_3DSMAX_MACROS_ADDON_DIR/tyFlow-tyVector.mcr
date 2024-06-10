macroScript tyVector
				category: "tyFlow" 
				internalCategory: "tyFlow" 
				tooltip: "tyVector" 
				ButtonText: "tyVector" 
				( 
					on execute do StartObjectCreation tyVector 
					on isChecked return mcrUtils.IsCreating tyVector 
					) 
