Files=getArgument;
Lenght=lengthOf(Files) 
Separator=indexOf(Files, ";")
Mask=substring(Files, 0, Separator)
Float=substring(Files, Separator+1, Lenght)

setBatchMode(true);
showStatus("Opening Float");
run("Bio-Formats (Windowless)", "open="+Float);
rename("PETFloat");
run("Macro...", "code=[if(v<=25) v=0] stack");

run("Bio-Formats (Windowless)", "open="+Mask);
showStatus("Opening Mask");
rename("EloiseMask");
// Ajouter 1 au num de ROI pour eviter la valeur 1 qui est le background
run("Macro...", "code=[if(v>=1) v=(v+1)] stack");
//On somme float et mask si resultat a 0 voxel sous le seuil et hors ROI
run("Calculator Plus", "i1=PETFloat i2=EloiseMask operation=[Add: i2 = (i1+i2) x k1 + k2] k1=1 k2=0 create");
//Ici tous les pixels inferieur au seuil de SUV ET 0 dans le mask sont à 0;
rename("Addition");
//On prepare les valeur qu'on va sommer si 0 on assigne 1 si different de 1 on met à 0
run("Macro...", "code=[if(v==0) v=1] stack");
run("Macro...", "code=[if(v!=1) v=0] stack");
//on somme sur le mask original pour passer les 0 en 1 si sous le seuil
run("Calculator Plus", "i1=Addition i2=EloiseMask operation=[Add: i2 = (i1+i2) x k1 + k2] k1=1 k2=0 create");
rename("MaskFinal");

//Update Site need http://sites.imagej.net/IJ-Plugins/ to be installed 
run("Seeded Region Growing ...", "image=PETFloat seeds=MaskFinal stack=[3D volume]");
rename("GrowedMaskResult");
setBatchMode(false);

run("Macro...", "code=[if(v<=1) v=0] stack");

