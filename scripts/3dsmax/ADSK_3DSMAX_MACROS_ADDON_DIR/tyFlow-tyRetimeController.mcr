macroScript tyRetimeController
				category: "tyFlow" 
				internalCategory: "tyFlow" 
				tooltip: "tyRetimeController" 
				ButtonText: "tyRetimeController" 
				( 
					on execute do StartObjectCreation tyRetimeController 
					on isChecked return mcrUtils.IsCreating tyRetimeController 
					) 
