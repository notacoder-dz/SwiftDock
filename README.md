# SwiftDock
A single-click virtual screening tool using AutoDock4 for Windows users
****************************************************************************************************************************
A new version of SwiftDock is available ! Visit https://github.com/notacoder-dz/SwiftDock1.0 to download the latest version.
****************************************************************************************************************************


Required installations :
- Python (preferably 3.0 or higher)
- MGLTools 1.5.7 (https://ccsb.scripps.edu/mgltools/downloads/)
- OpenBabel 3.1.1 (https://github.com/openbabel/openbabel/releases/tag/openbabel-3-1-1)
- AutoDock 4.2.6 (https://autodock.scripps.edu/download-autodock4/)

Disclaimer:

This open-source software provided in this repository, authored by LARBAOUI Billel, a PhD student at the University of Bejaia (Algeria), is intended for academic use and research purposes only. While efforts have been made to ensure the quality and reliability of the code, there is no guarantee of specific results or performance. It is offered "as is" without warranty of any kind, express or implied, including but not limited to the warranties of merchantability, fitness for a particular purpose, and non-infringement. This code may not be sold, redistributed, or used for commercial purposes without explicit permission from the author.

The author acknowledges the assistance received in the development of this code specifically from Professor MENAD Rafik (University of Algiers, Algeria). This code relies on or integrates with other software or libraries, each with its own licensing terms. Users are responsible for reviewing and complying with the licensing terms of any third-party dependencies used in conjunction with this code.

In no event shall the authors or copyright holders be liable for any claim, damages, or other liability, whether in an action of contract, tort, or otherwise, arising from, out of, or in connection with the use or performance of this code.

Usage :

1- Install the required software

2- Copy the source code to a text file and save it as a BAT file (the file could be converted to an executable "EXE" file) 

3- Put the BAT/EXE file in a folder, containing the ligand SDF files and the protein PDB file, and execute the program


PS: *The required programs should be installed in the destination folders defined in the source code :

MGLTools : "C:\Program Files (x86)\MGLTools-1.5.7"

OpenBabel : "C:\Program Files\OpenBabel-3.1.1"

AutoDock4 : "C:\Program Files (x86)\The Scripps Research Institute\Autodock\4.2.6"

However, the destination folders in the source code could be modified to accomodate the users' needs.

*The "SwiftDock.bat" file is designed to execute docking using default grid box dimensions. To perform blind docking or site-specific docking, integrate the 'Additional Script for Blind Docking' into the main code (see the additional script for details).   



-----------------------------If you use this software in your research, please cite our article:

Larbaoui, B., & Menad, R. (2024). Single-click molecular docking via SwiftDock: A new virtual screening tool using AutoDock4. Computational and Structural Biotechnology Reports, 1, 100017. https://doi.org/10.1016/j.csbr.2024.100017

-----------------------------If you encounter any issues or have questions about the software, feel free to contact us at:
bilellarbaoui@gmail.com or menadrafik@gmail.com
