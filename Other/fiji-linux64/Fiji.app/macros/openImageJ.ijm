arg = getArgument;
dir = split(arg," ");

for (i=0; i<dir.length; i++) {	
	run("Image Sequence...", "open="+dir[i]+" sort");
}


