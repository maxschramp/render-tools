macroScript tyActor
				category: "tyFlow" 
				internalCategory: "tyFlow" 
				tooltip: "tyActor" 
				ButtonText: "tyActor" 
				( 
					on execute do StartObjectCreation tyActor 
					on isChecked return mcrUtils.IsCreating tyActor 
					) 
