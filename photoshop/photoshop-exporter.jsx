/*
Code for Import https://scriptui.joonas.me — (Triple click to select): 
{"activeId":11,"items":{"item-0":{"id":0,"type":"Dialog","parentId":false,"style":{"enabled":true,"varName":"","windowType":"Window","creationProps":{"su1PanelCoordinates":false,"maximizeButton":false,"minimizeButton":false,"independent":false,"closeButton":false,"borderless":false,"resizeable":false},"text":"Image Exporter","preferredSize":[200,0],"margins":16,"orientation":"column","spacing":10,"alignChildren":["center","top"]}},"item-2":{"id":2,"type":"RadioButton","parentId":6,"style":{"enabled":true,"varName":null,"text":"Preview (1500px)","preferredSize":[0,0],"alignment":null,"helpTip":"JPG, Quality: 4, 200kb","checked":false}},"item-3":{"id":3,"type":"RadioButton","parentId":6,"style":{"enabled":true,"varName":"","text":"Draft (3500px)","preferredSize":[0,0],"alignment":null,"helpTip":"JPG, Quality: 4, 750kb","checked":false}},"item-4":{"id":4,"type":"RadioButton","parentId":6,"style":{"enabled":true,"varName":null,"text":"Final (5000px)","preferredSize":[0,0],"alignment":null,"helpTip":"JPG, Quality: 7, 8MB ","checked":false}},"item-6":{"id":6,"type":"Group","parentId":0,"style":{"enabled":true,"varName":null,"preferredSize":[0,0],"margins":0,"orientation":"column","spacing":10,"alignChildren":["left","center"],"alignment":"left"}},"item-8":{"id":8,"type":"Button","parentId":11,"style":{"enabled":true,"varName":null,"text":"Export","justify":"center","preferredSize":[0,0],"alignment":null,"helpTip":"Export current photoshop file"}},"item-9":{"id":9,"type":"Divider","parentId":0,"style":{"enabled":true,"varName":null}},"item-11":{"id":11,"type":"Group","parentId":0,"style":{"enabled":true,"varName":null,"preferredSize":[0,0],"margins":0,"orientation":"row","spacing":20,"alignChildren":["center","center"],"alignment":null}},"item-12":{"id":12,"type":"Button","parentId":11,"style":{"enabled":true,"varName":null,"text":"Export All","justify":"center","preferredSize":[0,0],"alignment":null,"helpTip":"Export all open photoshop files"}},"item-13":{"id":13,"type":"Progressbar","parentId":0,"style":{"enabled":true,"varName":null,"preferredSize":[250,4],"alignment":null,"helpTip":null}},"item-15":{"id":15,"type":"Group","parentId":0,"style":{"enabled":true,"varName":null,"preferredSize":[0,0],"margins":0,"orientation":"row","spacing":16,"alignChildren":["left","center"],"alignment":null}},"item-16":{"id":16,"type":"Button","parentId":15,"style":{"enabled":true,"varName":null,"text":"...","justify":"center","preferredSize":[0,0],"alignment":null,"helpTip":"Select Directory..."}},"item-17":{"id":17,"type":"EditText","parentId":15,"style":{"enabled":true,"varName":null,"creationProps":{"noecho":false,"readonly":false,"multiline":false,"scrollable":false,"borderless":false,"enterKeySignalsOnChange":false},"softWrap":false,"text":"C:/Path/To/Export","justify":"left","preferredSize":[200,0],"alignment":null,"helpTip":"Select Directory..."}},"item-18":{"id":18,"type":"Button","parentId":11,"style":{"enabled":true,"varName":null,"text":"Cancel","justify":"center","preferredSize":[0,0],"alignment":null,"helpTip":""}}},"order":[0,6,2,3,4,9,15,17,16,11,8,12,18,13],"settings":{"importJSON":true,"indentSize":false,"cepExport":false,"includeCSSJS":true,"showDialog":true,"functionWrapper":false,"afterEffectsDockable":false,"itemReferenceList":"None"}}
*/

// Window
// ===
var win = new Window("dialog", "window", undefined, undefined, { closeButton: false });
win.text = "Image Exporter";
win.preferredSize.width = 360;
win.orientation = "column";
win.alignChildren = ["center", "top"];
win.spacing = 10;
win.margins = 16;

// Selection Buttons
// ======
var groupSelection = win.add("group", undefined, { name: "groupSelection" });
groupSelection.orientation = "column";
groupSelection.alignChildren = ["left", "center"];
groupSelection.spacing = 10;
groupSelection.margins = 0;
groupSelection.alignment = ["left", "top"];

var selectPreview = groupSelection.add("radiobutton", undefined, undefined, { name: "selectPreview" });
selectPreview.helpTip = "JPG, Quality: 5, 250kb";
selectPreview.text = "Preview (1500px)";
selectPreview.value = true;

var selectDraft = groupSelection.add("radiobutton", undefined, undefined, { name: "selectDraft" });
selectDraft.helpTip = "JPG, Quality: 6, 750kb";
selectDraft.text = "Draft (3000px)";

var selectFinal = groupSelection.add("radiobutton", undefined, undefined, { name: "selectFinal" });
selectFinal.helpTip = "JPG, Quality: 7, 1mb+";
selectFinal.text = "Final (5000px)";

var divider = win.add("panel", undefined, undefined, { name: "divider" });
divider.alignment = "fill";

// groupDirectory
// ======
var groupDirectory = win.add("group", undefined, { name: "groupDirectory" });
groupDirectory.orientation = "row";
groupDirectory.alignChildren = ["left", "center"];
groupDirectory.spacing = 16;
groupDirectory.margins = 0;

var pathDirectory = groupDirectory.add('edittext {properties: {name: "pathDirectory"}}');
pathDirectory.helpTip = "Export will ";
// Set default directory to the current Photoshop document's folder, or fallback if unsaved
try {
    if (app.documents.length > 0 && app.activeDocument.fullName) {
        var docPath = app.activeDocument.fullName.parent.fsName + "\\EXPORT\\";
        pathDirectory.text = docPath;
    } else {
        pathDirectory.text = "File not saved! Please save before exporting.";
    }
} catch (e) {
    pathDirectory.text = "File not saved! Please save before exporting.";
}
pathDirectory.preferredSize.width = 300;

var docPath = pathDirectory.text; // Store initial directory

var buttonDirectory = groupDirectory.add("button", undefined, undefined, { name: "buttonDirectory" });
buttonDirectory.helpTip = "Select Directory...";
buttonDirectory.text = "...";

buttonDirectory.onClick = function() {
    var selectedFolder = Folder.selectDialog("Select export directory", docPath);
    if (selectedFolder) {
        docPath = selectedFolder.fsName + "\\EXPORT\\";
        pathDirectory.text = docPath;
    }
};

// groupButtons
// ======
var groupButtons = win.add("group", undefined, { name: "groupButtons" });
groupButtons.orientation = "row";
groupButtons.alignChildren = ["center", "center"];
groupButtons.spacing = 60;
groupButtons.margins = 0;

var buttonExport = groupButtons.add("button", undefined, undefined, { name: "buttonExport" });
buttonExport.helpTip = "Export current photoshop file";
buttonExport.text = "Export";

// Consolidated export function
function performExport(exportAll) {
    if (app.documents.length == 0) {
        alert(exportAll ? "No documents are open!" : "No document is open!");
        return;
    }
    
    // Get export settings based on selected radio button
    var exportSize = 1500; // Default to Preview
    var quality = 5; // Default quality for Preview
    var settingName = "PREVIEW";
    
    if (selectDraft.value) {
        exportSize = 3000;
        quality = 6;
        settingName = "DRAFT";
    } else if (selectFinal.value) {
        exportSize = 5000;
        quality = 7;
        settingName = "FINAL";
    }
    
    // Create export folder if it doesn't exist
    var exportFolder = new Folder(docPath);
    if (!exportFolder.exists) {
        exportFolder.create();
    }
    
    // Manual padding function since padStart isn't available in ExtendScript
    function pad(num) {
        return (num < 10 ? "0" : "") + num;
    }
    
    if (exportAll) {
        // Export All logic
        var docs = [];
        for (var i = 0; i < app.documents.length; i++) {
            docs.push(app.documents[i]);
        }
        
        var successCount = 0;
        var failCount = 0;
        
        // Process each document
        for (var d = 0; d < docs.length; d++) {
            var doc = docs[d];
            
            try {
                // Set as active document
                app.activeDocument = doc;
                
                // Check if document is saved
                if (!doc.fullName) {
                    pathDirectory.text = "Skipped unsaved: " + doc.name;
                    failCount++;
                    continue;
                }
                
                // Get filename without extension
                var fileName = doc.name.replace(/\.[^\.]+$/, '');
                
                // Create date prefix in YYMMDD format
                var today = new Date();
                var year = today.getFullYear() % 100;
                var month = today.getMonth() + 1;
                var day = today.getDate();
                
                var datePrefix = pad(year) + pad(month) + pad(day) + "_" + settingName + "_";
                
                // Create base filename with prefix
                var baseFileName = datePrefix + fileName;
                
                // Check if file exists and add suffix if needed
                var counter = 1;
                var finalFileName = baseFileName;
                while (new File(docPath + finalFileName + ".jpg").exists) {
                    var suffix = "_" + pad(counter);
                    finalFileName = baseFileName + suffix;
                    counter++;
                }
                var exportPath = docPath + finalFileName + ".jpg";
                
                // Save current history state to revert later
                var currentState = doc.activeHistoryState;
                
                try {
                    // Flatten the document
                    doc.flatten();
                    
                    // Calculate scale ratio for export
                    var currentWidth = doc.width.as("px");
                    var currentHeight = doc.height.as("px");
                    var ratio = Math.min(exportSize / currentWidth, exportSize / currentHeight);
                    
                    // Resize the image if needed
                    if (ratio < 1) {
                        var newWidth = Math.round(currentWidth * ratio);
                        var newHeight = Math.round(currentHeight * ratio);
                        doc.resizeImage(UnitValue(newWidth, "px"), UnitValue(newHeight, "px"), 72, ResampleMethod.BICUBIC);
                    }
                    
                    // Export as JPEG
                    var jpegOptions = new JPEGSaveOptions();
                    jpegOptions.quality = quality;
                    jpegOptions.embedColorProfile = true;
                    jpegOptions.formatOptions = FormatOptions.STANDARDBASELINE;
                    jpegOptions.matte = MatteType.NONE;
                    
                    var exportFile = new File(exportPath);
                    doc.saveAs(exportFile, jpegOptions, true, Extension.LOWERCASE);
                    
                    successCount++;
                    
                } catch (e) {
                    pathDirectory.text = "Export failed for " + fileName + ": " + e.message;
                    failCount++;
                } finally {
                    // Always revert to original state
                    doc.activeHistoryState = currentState;
                }
                
            } catch (e) {
                pathDirectory.text = "Error processing " + doc.name + ": " + e.message;
                failCount++;
            }
        }
        
        // Show final status
        pathDirectory.text = "Export All completed: " + successCount + " success, " + failCount + " failed";
        
    } else {
        // Single Export logic
        var doc = app.activeDocument;
        
        // Check if document is saved
        if (!doc.fullName) {
            alert("Please save the document first!");
            return;
        }
        
        // Get filename without extension
        var fileName = doc.name.replace(/\.[^\.]+$/, '');
        
        // Create date prefix in YYMMDD format
        var today = new Date();
        var year = today.getFullYear() % 100;
        var month = today.getMonth() + 1;
        var day = today.getDate();
        
        var datePrefix = pad(year) + pad(month) + pad(day) + "_" + settingName + "_";
        
        // Create base filename with prefix
        var baseFileName = datePrefix + fileName;
        var exportPath = docPath + baseFileName + ".jpg";
        
        // Check if file exists and add suffix if needed
        var counter = 1;
        var finalFileName = baseFileName;
        while (new File(docPath + finalFileName + ".jpg").exists) {
            var suffix = "_" + pad(counter);
            finalFileName = baseFileName + suffix;
            counter++;
        }
        exportPath = docPath + finalFileName + ".jpg";
        
        // Save current history state to revert later
        var currentState = doc.activeHistoryState;
        
        try {
            // Flatten the document
            doc.flatten();
            
            // Calculate scale ratio for export
            var currentWidth = doc.width.as("px");
            var currentHeight = doc.height.as("px");
            var ratio = Math.min(exportSize / currentWidth, exportSize / currentHeight);
            
            // Resize the image if needed
            if (ratio < 1) {
                var newWidth = Math.round(currentWidth * ratio);
                var newHeight = Math.round(currentHeight * ratio);
                doc.resizeImage(UnitValue(newWidth, "px"), UnitValue(newHeight, "px"), 72, ResampleMethod.BICUBIC);
            }
            
            // Export as JPEG
            var jpegOptions = new JPEGSaveOptions();
            jpegOptions.quality = quality;
            jpegOptions.embedColorProfile = true;
            jpegOptions.formatOptions = FormatOptions.STANDARDBASELINE;
            jpegOptions.matte = MatteType.NONE;
            
            var exportFile = new File(exportPath);
            doc.saveAs(exportFile, jpegOptions, true, Extension.LOWERCASE);
            
            pathDirectory.text = "Export completed: " + finalFileName + ".jpg";
            
        } catch (e) {
            pathDirectory.text = "Export failed: " + e.message;
        } finally {
            // Always revert to original state
            doc.activeHistoryState = currentState;
        }
    }
}

buttonExport.onClick = function() {
    performExport(false);
};

var buttonExportAll = groupButtons.add("button", undefined, undefined, { name: "buttonExportAll" });
buttonExportAll.helpTip = "Export all open photoshop files";
buttonExportAll.text = "Export All";

buttonExportAll.onClick = function() {
    performExport(true);
};

var buttonClose = groupButtons.add("button", undefined, undefined, { name: "buttonClose" });
buttonClose.text = "Close";
buttonClose.onClick = function() {
    win.close();
};

win.show();