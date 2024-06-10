macroScript tyFlow
				category: "tyFlow" 
				internalCategory: "tyFlow" 
				tooltip: "tyFlow" 
				ButtonText: "tyFlow" 
				( 
					on execute do StartObjectCreation tyFlow 
					on isChecked return mcrUtils.IsCreating tyFlow 
					) 
