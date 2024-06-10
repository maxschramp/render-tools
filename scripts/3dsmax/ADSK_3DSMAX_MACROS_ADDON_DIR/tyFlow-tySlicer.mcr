macroScript tySlicer
				category: "tyFlow" 
				internalCategory: "tyFlow" 
				tooltip: "tySlicer" 
				ButtonText: "tySlicer" 
				( 
					on execute do StartObjectCreation tySlicer 
					on isChecked return mcrUtils.IsCreating tySlicer 
					) 
