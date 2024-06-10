macroScript tySplines
				category: "tyFlow" 
				internalCategory: "tyFlow" 
				tooltip: "tySplines" 
				ButtonText: "tySplines" 
				( 
					on execute do StartObjectCreation tySplines 
					on isChecked return mcrUtils.IsCreating tySplines 
					) 
