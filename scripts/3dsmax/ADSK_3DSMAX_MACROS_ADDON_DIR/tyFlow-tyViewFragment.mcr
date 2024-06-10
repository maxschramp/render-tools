macroScript tyViewFragment
				category: "tyFlow" 
				internalCategory: "tyFlow" 
				tooltip: "tyViewFragment" 
				ButtonText: "tyViewFragment" 
				( 
					on execute do StartObjectCreation tyViewFragment 
					on isChecked return mcrUtils.IsCreating tyViewFragment 
					) 
