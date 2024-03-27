@echo off
echo.
echo OOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO
echo O O O O  O           O  O  O O O O  O O O O  O O      O O O    O O O  O   O
echo O         O         O   O  O           O     O   O   O     O  O       O  O
echo O O O O    O   O   O    O  O O O       O     O    O  O     O  O       O O
echo       O     O O O O     O  O           O     O   O   O     O  O       O  O
echo O O O O      O   O      O  O           O     O O      O O O    O O O  O   O
echo OOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO
echo.           

REM .......................................................................
REM Checking if the necessary files are present
REM .......................................................................

@echo off
title SwiftDock
setlocal enabledelayedexpansion

set pdb_present=0
set sdf_present=0

for %%f in (*.pdb) do set pdb_present=1

for %%f in (*.sdf) do (
    set sdf_present=1
    goto sdf_check_done
)

for /D %%d in ("SDF-Ligands") do (
    for %%f in ("%%d\*.sdf") do (
        set sdf_present=1
        goto sdf_check_done
    )
)

:sdf_check_done

set missing_files=0

if %pdb_present%==0 (
    echo PLEASE ADD A PROTEIN FILE IN PDB FORMAT!
    set missing_files=1
)

if %sdf_present%==0 (
    echo PLEASE ADD THE LIGAND FILE(S) IN SDF FORMAT!
    set missing_files=1
)

if %missing_files%==1 (
    timeout /t 5000
    exit
) else (
    echo ****************************************************
    echo  ALL NECESSARY FILES ARE PRESENT!
    echo ****************************************************
)

endlocal

REM .......................................................................
REM Putting SDF files in the "SDF-Ligands" folder (if there isn't one)
REM .......................................................................

@echo off
if not exist "SDF-Ligands" (
    mkdir "SDF-Ligands"
) else (
    goto :skiploop
)

for %%i in (*.sdf) do move "%%i" "SDF-Ligands\" >nul

:skiploop

REM .......................................................................
REM Labelling the Protein file and the Ligand file(s)
REM .......................................................................

@echo off
for %%a in (*.pdb) do (
    set "name=%%~na"
    echo %%~na | findstr /i /b "P-" >nul || ren "%%a" "P-%%a"
)

@echo off
cd SDF-Ligands

for %%a in (*.sdf) do (
    set "ext=%%~xa"
    echo %%~na | findstr /i /b "L-" >nul || ren "%%a" "L-%%a"
)

cd ..


echo.                                                                                                
echo OOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO
echo.
echo PREPARING THE PROTEIN FILE !
echo.
echo OOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO
echo.

REM .......................................................................
REM Processing the protein file with prepare_receptor4.py generating a pdbqt file
REM .......................................................................

@echo off
setlocal enabledelayedexpansion

for %%f in (P-*.pdb) do (
    set "a=%%~nf"  
    echo PREPARING !a! ...
    python "C:\Program Files (x86)\MGLTools-1.5.7\Lib\site-packages\AutoDockTools\Utilities24\prepare_receptor4.py" -r "%%f" -o !a!.pdbqt -A hydrogens >nul
) 

endlocal

echo.
echo OOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO
echo.
echo CONVERTING THE LIGAND FILE(S) !
echo.
echo OOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO
echo.

REM .......................................................................
REM Converting the sdf ligand files to pdb files using OpenBabel
REM .......................................................................

@echo off
cd SDF-Ligands
"C:\Program Files\OpenBabel-3.1.1\obabel.exe" -isdf *.sdf -opdb -O *.pdb


REM .......................................................................
REM Moving the PDB Ligand file(s) in the "PDB-Ligands" folder
REM .......................................................................

@echo off
if not exist "..\PDB-Ligands" mkdir "..\PDB-Ligands"
for %%i in (*.pdb) do move "%%i" "..\PDB-Ligands\" >nul
cd ..


echo.
echo OOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO
echo.
echo PREPARING THE LIGAND FILE(S) !
echo.
echo OOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO
echo.


REM .......................................................................
REM Processing the ligand file(s) with prepare_ligand4.py generating pdbqt file(s)
REM .......................................................................


cd PDB-Ligands
@echo off
setlocal enabledelayedexpansion

for %%f in (L-*.pdb) do (
    set "b=%%~nf" 
    echo PREPARING !b! ...
    python "C:\Program Files (x86)\MGLTools-1.5.7\Lib\site-packages\AutoDockTools\Utilities24\prepare_ligand4.py" -l "%%f" -o !b!.pdbqt -A hydrogens >nul
)

endlocal

REM .......................................................................
REM Moving the PDBQT Ligand file(s) in the "PDBQT-Ligands" folder
REM .......................................................................

@echo off
if not exist "..\PDBQT-Ligands" mkdir "..\PDBQT-Ligands"
for %%i in (*.pdbqt) do move "%%i" "..\PDBQT-Ligands\" >nul
cd ..


echo.
echo.
echo OOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO
echo.
echo GENERATING GPF AND DPF FILE(S) !
echo.
echo OOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO
echo.

REM .......................................................................
REM Preparing GPF and DPF files for each ligand using prepare_gpf4.py and prepare_dpf4.py respectively
REM .......................................................................

@echo off
setlocal enabledelayedexpansion
for %%a in (P-*.pdbqt) do (
    set "f=%%~na"
    for %%b in ("PDBQT-Ligands\L-*.pdbqt") do (
        set "g=%%~nb"
        echo.
        echo.
        echo Generating GPF for !g! ...
        echo.
        mkdir "!g!" 2>nul
        python "C:\Program Files (x86)\MGLTools-1.5.7\Lib\site-packages\AutoDockTools\Utilities24\prepare_gpf4.py" -l "%%b" -r "%%a" -o "!g!\!g!.gpf"
	      echo.
	      echo Generating DPF for !g! ...
	      echo.
	      python "C:\Program Files (x86)\MGLTools-1.5.7\Lib\site-packages\AutoDockTools\Utilities24\prepare_dpf4.py" -l "%%b" -r "%%a" -o "!g!\!g!.dpf"
    )
)

endlocal




REM ----------------------------------------------------------------------------------------------------------------------------------------

REM Here you can add the code found in the file "Additional Script for Blind Docking" file to execute a blind docking with a bigger grid box

REM ----------------------------------------------------------------------------------------------------------------------------------------



echo.
echo OOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO
echo.
echo GENERATING GRIDS AND MAPS BY RUNNING AUTOGRID4!
echo.
echo OOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO
echo.


REM .......................................................................
REM Copying the pdbqt protein file to ligands folders (for the execution of autogrid4.exe and autodock4.exe)
REM .......................................................................


@echo off
setlocal enabledelayedexpansion

for %%F in (P-*.pdbqt) do (
    for /D %%D in (L-*) do (
        copy "%%F" "%%D" >nul
    )
)

REM .......................................................................
REM Copying the pdbqt ligands files to their folders (for the execution of autogrid4.exe and autodock4.exe)
REM .......................................................................

@echo off
for %%F in ("PDBQT-Ligands\L-*.pdbqt") do (
    copy "%%F" "%%~nF" >nul
)

REM .......................................................................
REM Executing autogrid4.exe in the ligands folders 
REM .......................................................................

@echo off
for /d %%d in (L-*) do (
    echo Running autogrid4.exe for %%d  ...
    cd %%d
    for %%e in (L-*.gpf) do (
    set "g=%%~ne"
    "C:\Program Files (x86)\The Scripps Research Institute\Autodock\4.2.6\autogrid4.exe" -p %%e -l "!g!.glg"
    cd ..
    )
)
        
endlocal


echo.
echo OOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO
echo.
echo PERFORMING MOLECULAR DOCKING BY RUNNING AUTODOCK4 !
echo.
echo OOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO
echo.


REM .......................................................................
REM Executing autodock4.exe for every ligand (in the ligands folders) 
REM .......................................................................


@echo off
setlocal enabledelayedexpansion

for /d %%a in (L-*) do (
    echo Running autodock4.exe for %%a  ...
    cd %%a
    for %%b in (L-*.dpf) do (
        set "g=%%~nb"
        "C:\Program Files (x86)\The Scripps Research Institute\Autodock\4.2.6\autodock4.exe" -p %%b -l "!g!.dlg"
        cd ..
    )
)
        
endlocal


echo.
echo OOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO
echo.
echo EXTRACTING THE FREE BINDING ENERGY VALUES FOR EACH LIGAND !
echo.
echo OOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO
echo.

REM .......................................................................
REM Extracting the lowest binding energy generated in kcal/mol for each ligand 
REM .......................................................................

@echo off
(echo Extracted values:)> "FREE_BINDING_ENERGIES.txt"
for /d %%D in (L-*) do (
    set "folderName=%%~nxD"
    for %%F in ("%%D\*.dlg") do (
        for /f "tokens=2 delims=|" %%A in ('findstr /C:"   1 |    " "%%F"') do (
            echo %%~nF : %%A kcal/mol>> "FREE_BINDING_ENERGIES.txt"
        )
    )
)

endlocal


REM .......................................................................
REM Additional step to remove the Labelling of the ligand names 
REM .......................................................................

@echo off
setlocal enabledelayedexpansion

set "file=FREE_BINDING_ENERGIES.txt"
set "tempFile=%file%.tmp"

set "skipFirstLine=true"
(for /f "delims=" %%a in (%file%) do (
    if defined skipFirstLine (
        echo %%a
        set "skipFirstLine="
    ) else (
        set "line=%%a"
        echo !line:~2!
    )
)) > %tempFile%

move /y %tempFile% %file% >nul

endlocal

echo Extraction completed. The free binding energies of the ligands were outputted in the "FREE_BINDING_ENERGIES.txt" file. 

echo.
echo OOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO
echo.
echo WRITING THE LOWEST ENERGY CONFORMATION FOR LIGAND(S) !
echo.
echo OOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO
echo.

REM .......................................................................
REM Extracting the best pose for each ligand using write_lowest_energy_ligand.py for visualization purposes 
REM .......................................................................

@echo off
setlocal enabledelayedexpansion

for /d %%a in (L-*) do (
    echo Extracting lowest energy pose for %%a  ...
    for %%b in ("%%a\*.dlg") do (
        set "g=%%~nb"
        python "C:\Program Files (x86)\MGLTools-1.5.7\Lib\site-packages\AutoDockTools\Utilities24\write_lowest_energy_ligand.py" -f %%b -o "!g!/!g!.pdbqt" -N >nul
    )
)
        
endlocal

echo.
echo.
echo All operations done.
echo.
echo Now you can visualize your P-L complexes.
echo.
echo Thank you for using SwiftDock.
echo.
echo PRESS ANY KEY TO EXIT !
echo.
pause
