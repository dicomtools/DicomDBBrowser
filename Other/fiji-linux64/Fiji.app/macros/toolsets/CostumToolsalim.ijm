
var dCmds = newMenu("PET/CT Viewer Menu Tool",
newArray("Pet-Ct Viewer","-","Read DICOM", "Read Orthanc", "Send Dicom"));

macro "PET/CT Viewer Menu Tool - T0708P T7708E Tf708T T0f08C T7f08T"{
	cmd = getArgument();
	if (cmd=="Read DICOM")
		//Checker si ouvert et reaficher si c'est le cas
		doCommand("Read from CD...");
	else if (cmd=="Read Orthanc") doCommand("Read BI Studies...");
    else if (cmd=="Pet-Ct Viewer")
		//Checker si ouvert et reaficher si c'est le cas
		doCommand("Pet-Ct Viewer");
	else if (cmd=="Send Dicom")
		//Checker si ouvert et reaficher si c'est le cas
		doCommand("myDicom...");
}

macro "Window Level"{
    doCommand("Window Level Tool");
}

//macro "Postage Action Action Tool - R0063R0663R0c63Ra063Ra663Rac63" {
//run("Postage Stamps");
//}


macro "Inverse [F2]" {
    doCommand("Invert LUT");
}

macro "Draw [F3]" {
    run("Draw", "Slice");
	run("Select None");
}

var pmCmds = newMenu("Popup Menu",
        newArray("Copy", "Paste","Clear","-",
        "Inverse [F2]","-",
		"Draw [F3]"));

macro "Popup Menu" {
    cmd = getArgument;
    run(cmd);
}

var luts = getLutMenu();
var lCmds = newMenu("LUT Menu Tool", luts);

macro "LUT Menu Tool - C037T0b11LT6b09UTcb09T" {
	cmd = getArgument();
	if (cmd!="-") run(cmd);
}
function getLutMenu() {
	list = getLutList();
	menu = newArray(16+list.length);
	menu[0] = "Invert LUT"; menu[1] = "Apply LUT"; menu[2] = "-";
	menu[3] = "Fire"; menu[4] = "Grays"; menu[5] = "Ice";
	menu[6] = "Spectrum"; menu[7] = "3-3-2 RGB"; menu[8] = "Red";
	menu[9] = "Green"; menu[10] = "Blue"; menu[11] = "Cyan";
	menu[12] = "Magenta"; menu[13] = "Yellow"; menu[14] = "Red/Green";
	menu[15] = "-";
	for (i=0; i<list.length; i++)
		menu[i+16] = list[i];
	return menu;
}

function getLutList() {
	lutdir = getDirectory("luts");
	list = newArray("No LUTs in /ImageJ/luts");
	if (!File.exists(lutdir))
		return list;
	rawlist = getFileList(lutdir);
	if (rawlist.length==0)
		return list;
	count = 0;
	for (i=0; i< rawlist.length; i++)
		if (endsWith(rawlist[i], ".lut")) count++;
	if (count==0)
		return list;
	list = newArray(count);
	index = 0;
	for (i=0; i< rawlist.length; i++) {
		if (endsWith(rawlist[i], ".lut"))
			list[index++] = substring(rawlist[i], 0, lengthOf(rawlist[i])-4);
	}
	return list;
}

