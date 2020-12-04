Dialog.create("Apply ROI Manager To");
Dialog.addChoice("Type:", newArray("Liver", "Spleen", "Right K", "Left K"));
Dialog.show();
type = Dialog.getChoice();

choiceNb=1;
if(type=="Liver"){
	choiceNb=5;
}else if(type=="Spleen"){
	choiceNb=6;
}else if(type=="Right K"){
	choiceNb=7;
}else if(type=="Left K"){
	choiceNb=8;
}
print(choiceNb);
//Apply the Selected ROI on the mask
for (i = 0; i < roiManager("count"); i++) {
	roiManager("Select", i);
	run("Macro...", "code=[if(v==1 || v>4) v="+choiceNb+"]");
}