Files=getArgument;
Lenght=lengthOf(Files) 
Separator=indexOf(Files, ";")
Mask=substring(Files, 0, Separator)
Float=substring(Files, Separator+1, Lenght)
///print("FileMask="+Mask);
//print("FileFloat="+Float);

setBatchMode(true);
showStatus("Overture du Float");
run("Bio-Formats (Windowless)", "open="+Float);
rename("PETFloat");
//run("Subtract...", "value=15 stack");
//run("Macro...", "code=[if(v<=0) v=0] stack");
//run("Macro...", "code=[if(v>=50) v=200] stack");


run("Bio-Formats (Windowless)", "open="+Mask);
showStatus("Ouverture du Mask");
rename("EloiseMask");

//Update Site need http://sites.imagej.net/IJ-Plugins/ to be installed 
//waitForUser("Select 32bit float PET (from the 4 Nifti) and click OK");
//waitForUser("Select EloiseMask (Nifti/Out folder) and click OK");

run("Seeded Region Growing ...", "image=PETFloat seeds=EloiseMask stack=[3D volume]");
rename("GrowedMaskResult");
setBatchMode(false);
makeRectangle(1, 1, 2, 2);
getRawStatistics(nPixels, mean, min, max, std, histogram)
run("Select None");
run("Macro...", "code=[if(v=="+max+") v=0] stack");
showStatus("Termine");

