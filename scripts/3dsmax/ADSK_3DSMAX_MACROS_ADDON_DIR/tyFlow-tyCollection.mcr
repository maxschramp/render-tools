macroScript tyCollection
				category: "tyFlow" 
				internalCategory: "tyFlow" 
				tooltip: "tyCollection" 
				ButtonText: "tyCollection" 
				( 
					on execute do StartObjectCreation tyCollection 
					on isChecked return mcrUtils.IsCreating tyCollection 
					) 
