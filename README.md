This MATLAB program implements the use of hyperdimensional (HD) computing to 
classify electroencephalography (EEG) error-related potentials for an 
application in noninvasive brain-computer interfaces.

This program is licensed as GNU GPLv3. 

The files are organized as follows.

1- “MATLAB” folder. It contains all necessary MATLAB functions and scripts to 
implement the HD encoding algorithm and classifier:

1.1- “learning_few_electrodes.m”: Train and test the HD classifier using 1 or 
2 electrode(s) and the CAR preprocessing; “myplot.m” can be used to regenerate 
Figure 2 and Figure 3 of the paper.

1.2- “learning_64_electrodes.m”: Train and test the HD classifier using 64 
electrodes without the CAR preprocessing. The result of this script can be 
used to regenerate Figure 4.


2- “dataset” folder. This folder is empty due to GitHub size limitation but
should contain datasets for training (“_s1”) and testing (“_s2”) sessions 
for six subjects. The datasets are publicly available and can be downloaded 
from the below link, namely “22. Monitoring error-related potentials (013-2015)”:  

http://bnci-horizon-2020.eu/database/data-sets 

Here are the individual links of datasets for six subjects:
http://bnci-horizon-2020.eu/database/data-sets/013-2015/Subject01_s1.mat
http://bnci-horizon-2020.eu/database/data-sets/013-2015/Subject01_s2.mat
http://bnci-horizon-2020.eu/database/data-sets/013-2015/Subject02_s1.mat
http://bnci-horizon-2020.eu/database/data-sets/013-2015/Subject02_s2.mat
http://bnci-horizon-2020.eu/database/data-sets/013-2015/Subject03_s1.mat
http://bnci-horizon-2020.eu/database/data-sets/013-2015/Subject03_s2.mat
http://bnci-horizon-2020.eu/database/data-sets/013-2015/Subject04_s1.mat
http://bnci-horizon-2020.eu/database/data-sets/013-2015/Subject04_s2.mat
http://bnci-horizon-2020.eu/database/data-sets/013-2015/Subject05_s1.mat
http://bnci-horizon-2020.eu/database/data-sets/013-2015/Subject05_s2.mat
http://bnci-horizon-2020.eu/database/data-sets/013-2015/Subject06_s1.mat
http://bnci-horizon-2020.eu/database/data-sets/013-2015/Subject06_s2.mat


Works that make use of this program should cite the following paper:

A. Rahimi, P. Kanerva, J. del R. Millán, J. M. Rabaey, “Hyperdimensional Computing for Noninvasive
Brain–Computer Interfaces: Blind and One-Shot Classification of EEG Error-Related Potentials,” In
10th EAI International Conference on Bio-inspired Information and Communications Technologies,
March 2017.