macroScript tyVertexOrder
				category: "tyFlow" 
				internalCategory: "tyFlow" 
				tooltip: "tyVertexOrder" 
				ButtonText: "tyVertexOrder" 
				( 
					on execute do AddMod tyVertexOrder 
					on isEnabled return mcrUtils.ValidMod tyVertexOrder 
					) 
