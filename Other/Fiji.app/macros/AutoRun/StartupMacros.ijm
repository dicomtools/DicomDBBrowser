// run("Choose Startup Program...", "default");
run("Appearance...", "interpolate");
dir = getDirectory("macros");
run("Install...", "install=["+dir+"/toolsets/CostumToolsalim.ijm]");
wait(50);
run("Scintigraphy Tools");
run("Window Level Tool");
