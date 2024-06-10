macroScript tyWind
				category: "tyFlow" 
				internalCategory: "tyFlow" 
				tooltip: "tyWind" 
				ButtonText: "tyWind" 
				( 
					on execute do StartObjectCreation tyWind 
					on isChecked return mcrUtils.IsCreating tyWind 
					) 
