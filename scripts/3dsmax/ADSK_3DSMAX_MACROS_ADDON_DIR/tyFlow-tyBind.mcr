macroScript tyBind
				category: "tyFlow" 
				internalCategory: "tyFlow" 
				tooltip: "tyBind" 
				ButtonText: "tyBind" 
				( 
					on execute do StartObjectCreation tyBind 
					on isChecked return mcrUtils.IsCreating tyBind 
					) 
