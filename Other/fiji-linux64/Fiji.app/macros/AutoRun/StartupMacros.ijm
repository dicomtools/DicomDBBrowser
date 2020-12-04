run("Appearance...", "interpolate");
dir = getDirectory("macros");

if (File.exists(getDirectory("plugins")+"Conventional_Scintigraphy.jar") ) {
	run("Install...", "install=["+dir+"/toolsets/CostumToolsalim2.ijm]");
	wait(50);
    run("Scintigraphy Tools");
}else{
	run("Install...", "install=["+dir+"/toolsets/CostumToolsalim.ijm]");
}
run("Choose Startup Program...", "default");
wait(50);
run("Window Level Tool");
