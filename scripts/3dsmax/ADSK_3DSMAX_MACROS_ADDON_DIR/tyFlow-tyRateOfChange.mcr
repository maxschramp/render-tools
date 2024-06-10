macroScript tyRateOfChange
				category: "tyFlow" 
				internalCategory: "tyFlow" 
				tooltip: "tyRateOfChange" 
				ButtonText: "tyRateOfChange" 
				( 
					on execute do StartObjectCreation tyRateOfChange 
					on isChecked return mcrUtils.IsCreating tyRateOfChange 
					) 
