macroScript tyProperties
				category: "tyFlow" 
				internalCategory: "tyFlow" 
				tooltip: "tyProperties" 
				ButtonText: "tyProperties" 
				( 
					on execute do AddMod tyProperties 
					on isEnabled return mcrUtils.ValidMod tyProperties 
					) 
