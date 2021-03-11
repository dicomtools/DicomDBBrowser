function tDicomInfo = browserDicomInfo4che3(sFileInput)
%function tDicomInfo = browserDicomInfo4che3(sFileInput)
%Fill a DICOM structure using dcm4che.
%See DicomDBBrowser.doc (or pdf) for more information about options.
%
%Note: option settings must fit on one line and can contain one semicolon at most.
%Options can be strings, cell arrays of strings, or numerical arrays.
%
%Author: Daniel Lafontaine, lafontad@mskcc.org
%
%Last specifications modified:
%
% Copyright 2020, Daniel Lafontaine, on behalf of the TriDFusion development team.
% 
% This file is part of The DICOM Database Browser (dicomDBBrowser).
% 
% DicomDBBrowser development has been led by: Daniel Lafontaine
% 
% DicomDBBrowser is distributed under the terms of the Lesser GNU Public License. 
% 
%     This version of dicomDBBrowser is free software: you can redistribute it and/or modify
%     it under the terms of the GNU General Public License as published by
%     the Free Software Foundation, either version 3 of the License, or
%     (at your option) any later version.
% 
% DicomDBBrowser is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY;
% without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
% See the GNU General Public License for more details.
% 
% You should have received a copy of the GNU General Public License
% along with DicomDBBrowser.  If not, see <http://www.gnu.org/licenses/>.

    try 
        din = org.dcm4che.io.DicomInputStream(...
                java.io.BufferedInputStream(java.io.FileInputStream(char(sFileInput))));    
    catch 
       tDicomInfo = ''; 
       return;
    end

    try 
        t4che3DataSet = din.readDataset(-1, -1);      
    catch
       tDicomInfo = ''; 
       return;
    end    
        
    tDicomInfo.PatientName       = char(t4che3DataSet.getString(org.dcm4che.data.Tag.PatientName, 0));
    tDicomInfo.PatientID         = char(t4che3DataSet.getString(org.dcm4che.data.Tag.PatientID  , 0));
    tDicomInfo.PatientSex        = char(t4che3DataSet.getString(org.dcm4che.data.Tag.PatientSex , 0));
    tDicomInfo.PatientAge        = char(t4che3DataSet.getString(org.dcm4che.data.Tag.PatientAge , 0));
    
    tDicomInfo.StudyDate         = char(t4che3DataSet.getString(org.dcm4che.data.Tag.StudyDate , 0));
    tDicomInfo.SeriesDate        = char(t4che3DataSet.getString(org.dcm4che.data.Tag.SeriesDate, 0));
           
    tDicomInfo.SeriesInstanceUID = char(t4che3DataSet.getString(org.dcm4che.data.Tag.SeriesInstanceUID, 0));
    tDicomInfo.StudyInstanceUID  = char(t4che3DataSet.getString(org.dcm4che.data.Tag.StudyInstanceUID , 0));
    
    tDicomInfo.AccessionNumber   = char(t4che3DataSet.getString(org.dcm4che.data.Tag.AccessionNumber, 0));
    
    tDicomInfo.SeriesDescription = char(t4che3DataSet.getString(org.dcm4che.data.Tag.SeriesDescription, 0));
    tDicomInfo.StudyDescription  = char(t4che3DataSet.getString(org.dcm4che.data.Tag.StudyDescription , 0));
   
    din.close();

end
