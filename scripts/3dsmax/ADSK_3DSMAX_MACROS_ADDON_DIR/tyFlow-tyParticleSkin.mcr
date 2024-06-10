macroScript tyParticleSkin
				category: "tyFlow" 
				internalCategory: "tyFlow" 
				tooltip: "tyParticleSkin" 
				ButtonText: "tyParticleSkin" 
				( 
					on execute do AddMod tyParticleSkin 
					on isEnabled return mcrUtils.ValidMod tyParticleSkin 
					) 
