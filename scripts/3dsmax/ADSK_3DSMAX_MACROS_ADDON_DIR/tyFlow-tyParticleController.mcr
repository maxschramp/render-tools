macroScript tyParticleController
				category: "tyFlow" 
				internalCategory: "tyFlow" 
				tooltip: "tyParticleController" 
				ButtonText: "tyParticleController" 
				( 
					on execute do StartObjectCreation tyParticleController 
					on isChecked return mcrUtils.IsCreating tyParticleController 
					) 
