macroScript tyMeshToSplines
				category: "tyFlow" 
				internalCategory: "tyFlow" 
				tooltip: "tyMeshToSplines" 
				ButtonText: "tyMeshToSplines" 
				( 
					on execute do AddMod tyMeshToSplines 
					on isEnabled return mcrUtils.ValidMod tyMeshToSplines 
					) 
