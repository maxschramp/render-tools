macroScript tyProp
				category: "tyFlow" 
				internalCategory: "tyFlow" 
				tooltip: "tyProp" 
				ButtonText: "tyProp" 
				( 
					on execute do StartObjectCreation tyProp 
					on isChecked return mcrUtils.IsCreating tyProp 
					) 
