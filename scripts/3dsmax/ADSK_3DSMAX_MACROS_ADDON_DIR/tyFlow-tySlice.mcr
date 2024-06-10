macroScript tySlice
				category: "tyFlow" 
				internalCategory: "tyFlow" 
				tooltip: "tySlice" 
				ButtonText: "tySlice" 
				( 
					on execute do AddMod tySlice 
					on isEnabled return mcrUtils.ValidMod tySlice 
					) 
