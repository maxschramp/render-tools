macroScript tySpacewarp
				category: "tyFlow" 
				internalCategory: "tyFlow" 
				tooltip: "tySpacewarp" 
				ButtonText: "tySpacewarp" 
				( 
					on execute do StartObjectCreation tySpacewarp 
					on isChecked return mcrUtils.IsCreating tySpacewarp 
					) 
