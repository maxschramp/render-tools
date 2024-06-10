macroScript tyCarve
				category: "tyFlow" 
				internalCategory: "tyFlow" 
				tooltip: "tyCarve" 
				ButtonText: "tyCarve" 
				( 
					on execute do AddMod tyCarve 
					on isEnabled return mcrUtils.ValidMod tyCarve 
					) 
