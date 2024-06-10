macroScript tyEdgeWeight
				category: "tyFlow" 
				internalCategory: "tyFlow" 
				tooltip: "tyEdgeWeight" 
				ButtonText: "tyEdgeWeight" 
				( 
					on execute do AddMod tyEdgeWeight 
					on isEnabled return mcrUtils.ValidMod tyEdgeWeight 
					) 
