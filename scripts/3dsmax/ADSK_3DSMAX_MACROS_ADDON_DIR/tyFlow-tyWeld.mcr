macroScript tyWeld
				category: "tyFlow" 
				internalCategory: "tyFlow" 
				tooltip: "tyWeld" 
				ButtonText: "tyWeld" 
				( 
					on execute do AddMod tyWeld 
					on isEnabled return mcrUtils.ValidMod tyWeld 
					) 
