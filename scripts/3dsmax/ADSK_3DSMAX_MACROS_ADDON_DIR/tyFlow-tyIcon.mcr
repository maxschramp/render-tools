macroScript tyIcon
				category: "tyFlow" 
				internalCategory: "tyFlow" 
				tooltip: "tyIcon" 
				ButtonText: "tyIcon" 
				( 
					on execute do StartObjectCreation tyIcon 
					on isChecked return mcrUtils.IsCreating tyIcon 
					) 
