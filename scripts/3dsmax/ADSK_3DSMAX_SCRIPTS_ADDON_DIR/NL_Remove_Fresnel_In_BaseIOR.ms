(
	/* Main script execution starts here */
    local affectedMaterials = #()
    /* Function to get all sub-maps of a given map */
    fn getSubMaps map =
    (
        local subMaps = #()
        if isKindOf map TextureMap then
        (
            local props = getPropNames map
            for p in props do
            (
                local propValue = getProperty map p
                if isKindOf propValue TextureMap then
                (
                    append subMaps propValue
                )
            )
        )
        return subMaps
    )
    
    /* Recursive function to traverse all connected maps */
    fn traverseMaps mat currentMap =
    (
        if currentMap != undefined then
        (
			print (classof currentMap)
            -- Check if the current map is a Falloff map
            if classof currentMap == Falloff then
            (
				
                -- Check if the Falloff Type is set to Fresnel (type index 4)
                if currentMap.falloff_type == 2 then
                (
                    -- Disconnect the first child of baseIorTexmap
                    mat.baseIorTexmap = undefined
                    -- Add material to the affected list
                    if findItem affectedMaterials mat == 0 do append affectedMaterials mat
                    -- Exit recursion after disconnection
                    return true
                )
            )
            -- Continue traversing through sub-maps
            local subMaps = getSubMaps currentMap
            for subMap in subMaps do
            (
                if traverseMaps mat subMap then return true
            )
        )
        return false
    )
    
    /* Recursive function to process materials, including Multi/Sub-Object materials */
    fn processMaterial mat =
    (
        if mat != undefined then
        (
            
                -- Access the baseIorTexmap
                local baseIorMap = mat.baseIorTexmap
                if baseIorMap != undefined then
                (
					print mat.name
                    -- Start recursive traversal from the baseIorTexmap
                    traverseMaps mat baseIorMap
                )
            
        )
    )
    
    
    
    
	
	
	
	
	
	fn getCoronaPhysicalMaterials mat accum =
(
    if (isKindOf mat CoronaPhysicalMtl) then
    (
        append accum mat
    )
    else if (isKindOf mat MultiMaterial or isKindOf mat Blend or isKindOf mat CoronaLayeredMtl) then
    (
        for i = 1 to mat.numsubs do
        (
			if (isKindOf mat Blend) then print mat[i].name
            getCoronaPhysicalMaterials mat[i] accum
        )
    )
    else if (isKindOf mat SubMaterial) then
    (
        getCoronaPhysicalMaterials mat.material accum
    )
    
    return accum
)

fn getAllSceneMaterials =
(
    local mats = #()
    for mat in sceneMaterials do
    (
        getCoronaPhysicalMaterials mat mats
    )
    return makeUniqueArray mats
)



	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
    
    -- Get all materials in the scene
    local allMats = getAllSceneMaterials()
    
    -- Process each material
    for mat in allMats do
    (
-- 		print mat.name
        processMaterial mat
    )
    
    /* Provide feedback to the user */
    if affectedMaterials.count > 0 then
    (
        local matNames = for m in affectedMaterials collect m.name
        local message = "The following materials were updated:\n" + (matNames as string)
        messageBox message title:"Materials Updated"
    )
    else
    (
        messageBox "No materials with a Fresnel Falloff in baseIorTexmap were found." title:"No Materials Found"
    )
)
