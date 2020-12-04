run("Appearance...", "interpolate");
dir = getDirectory("macros");

run("Install...", "install=["+dir+"/toolsets/CostumToolsalim2.ijm]");
wait(50);
run("Scintigraphy Tools");
run("Read DICOM", "");