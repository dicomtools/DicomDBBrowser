
var dCmds = newMenu("BethIsrael Menu Tool",
newArray("Read From CD","BI Database", "Send Dicom", "-" ,"Orthanc Query","Orthanc Import", "Orthanc Anonymize"));

macro "BethIsrael Menu Tool - C000 T1c09B T8c09I"{
	cmd = getArgument();
	if (cmd=="Read From CD")
		//Checker si ouvert et reaficher si c'est le cas
		doCommand("Read from CD...");
	else if (cmd=="BI Database")
		//Checker si ouvert et reaficher si c'est le cas
		doCommand("Read BI Studies...");
	else if (cmd=="Send Dicom")
		//Checker si ouvert et reaficher si c'est le cas
		doCommand("myDicom...");
	else if (cmd=="Orthanc Query")
		//Checker si ouvert et reaficher si c'est le cas
		doCommand("Launch queries");
	else if (cmd=="Orthanc Import")
		//Checker si ouvert et reaficher si c'est le cas
		doCommand("Launch import");
	else if (cmd=="Orthanc Anonymize")
		//Checker si ouvert et reaficher si c'est le cas
		doCommand("Launch anonymization");

}

macro "PET/CT Viewer Action Tool - T0708P T7708E Tf708T T0f08C T7f08T"{
    doCommand("Pet-Ct Viewer");
}

macro "Window Level"{
    doCommand("Window Level Tool");
}

macro "Postage Action Action Tool - R0063R0663R0c63Ra063Ra663Rac63" {
run("Postage Stamps");
}


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

