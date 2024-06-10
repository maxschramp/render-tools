macroScript tyMeshRepair
				category: "tyFlow" 
				internalCategory: "tyFlow" 
				tooltip: "tyMeshRepair" 
				ButtonText: "tyMeshRepair" 
				( 
					on execute do AddMod tyMeshRepair 
					on isEnabled return mcrUtils.ValidMod tyMeshRepair 
					) 
