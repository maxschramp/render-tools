macroScript tyVertexChamfer
				category: "tyFlow" 
				internalCategory: "tyFlow" 
				tooltip: "tyVertexChamfer" 
				ButtonText: "tyVertexChamfer" 
				( 
					on execute do AddMod tyVertexChamfer 
					on isEnabled return mcrUtils.ValidMod tyVertexChamfer 
					) 
