macroScript tySwitcher
				category: "tyFlow" 
				internalCategory: "tyFlow" 
				tooltip: "tySwitcher" 
				ButtonText: "tySwitcher" 
				( 
					on execute do StartObjectCreation tySwitcher 
					on isChecked return mcrUtils.IsCreating tySwitcher 
					) 
