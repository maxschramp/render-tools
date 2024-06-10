macroScript tyFlex
				category: "tyFlow" 
				internalCategory: "tyFlow" 
				tooltip: "tyFlex" 
				ButtonText: "tyFlex" 
				( 
					on execute do AddMod tyFlex 
					on isEnabled return mcrUtils.ValidMod tyFlex 
					) 
