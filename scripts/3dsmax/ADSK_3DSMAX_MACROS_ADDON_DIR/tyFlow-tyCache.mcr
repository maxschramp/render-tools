macroScript tyCache
				category: "tyFlow" 
				internalCategory: "tyFlow" 
				tooltip: "tyCache" 
				ButtonText: "tyCache" 
				( 
					on execute do StartObjectCreation tyCache 
					on isChecked return mcrUtils.IsCreating tyCache 
					) 
