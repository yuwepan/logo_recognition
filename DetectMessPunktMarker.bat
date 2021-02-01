::SET OPENCV_BIN=C:\Daten\opencv\build\x64\vc14\bin\
SET OPENCV_BIN=I:\A-D\CAD-KI\Software\opencv_3.1.0\build\x64\vc14\bin\
SET PROJ_PFAD=I:\A-D\CAD-KI\Projekte\MarkerErkennung\
SET DATEN_PFAD=%PROJ_PFAD%
SET PYTHON_BIN=I:\A-D\CAD-KI\Software\Python_2.7.12\



::SET PROJ_DIR=I:\E-I\InnoTeam\04_prototyping\Fahrzeugerkennung\
::SET OPENCV_BIN=%PROJ_DIR%Software\opencv_3.1.0\build\x64\vc14\bin\
::SET DATEN_PFAD=%PROJ_DIR%TypX157\
::SET PYTHON_BIN=%PROJ_DIR%Software\Python_2.7.12\

Set "PYTHONPATH=%PYTHONPATH%;%PYTHON_BIN%Lib\;%PYTHON_BIN%Lib\site-packages\;%OPENCV_DIR D%;C:\Daten\Software\opencv\build\x64\vc12\bin;C:\Daten\Software\opencv\build\x64\vc12\lib"
Set "path=%path%;%PYTHON_BIN%Lib\;%PYTHON_BIN%Lib\site-packages\;C:\Daten\Software\opencv\build\x64\vc12\lib\;%PYTHON_BIN%Lib\;%PYTHON_BIN%Lib\site-packages" 

::dir %PYTHON_BIN%python.exe 
::dir MB-Stern-Detector.py 
::dir cascadeMB-Stern_1.xml
%PYTHON_BIN%python.exe -d DetectMessPunktMarker.py cascade_MessPunktMarker.xml

