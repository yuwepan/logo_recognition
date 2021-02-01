
SET OBJEKT=MessPunktMarker
SET ONLY_TRAIN=N
SET IMG_W=128
SET IMG_H=32
SET IMG_NUM=200
SET MAXX=0.1   
::2.1
SET MAXY=0.1
::2.1
SET MAXZ=0.5
::3.15
SET IMG_RESERVE=5
SET MAXFALSEALARMRATE=0.5
SET NUMSTAGES=20

echo off


::____________________________________________________________________________________________________________________________
SET INST_PFAD=I:\A-D\CAD-KI\Lieferanterkennung\
::SET INST_PFAD=C:\Users\YUWEPAN\Desktop\Lieferanterkennung\
SET SW_PFAD=I:\A-D\CAD-KI\Software\
SET OPENCV_BIN=%SW_PFAD%opencv_3.1.0_TBB\build\bin\Release\
::SET OPENCV_BIN=%SW_PFAD%opencv-3.4.0\build\bin\Release\
SET PYTHON_2_7_BIN=%SW_PFAD%\Python_2.7.12\
SET PYTHON_BIN=%SW_PFAD%Python35\
SET MERGEV_BIN=%SW_PFAD%mergevec-master\

SET DATEN_PFAD=%INST_PFAD%%OBJEKT%\

IF "%ONLY_TRAIN%" NEQ "J" (

:: Negative Beispiele ______________________________________________________________________________________________________
echo "alte Negativ- Listen loeschen"
del /q "%DATEN_PFAD%Negativ_List.txt"
del /q "%DATEN_PFAD%Negativ_List_lang.txt"
::______________________________________________speziell
echo "neu Negativ- Listen erstellen"
for /R %DATEN_PFAD%Negativ %%f in (*.jpg *.png *.tif) do (
	echo %%f>> %DATEN_PFAD%Negativ_List_lang.txt
)
for /R %DATEN_PFAD%Negativ %%f in (*.jpg *.png *.tif) do  (
	echo Negativ\%%~nxf>> %DATEN_PFAD%Negativ_List.txt
)
::______________________________________________allgemein
REM for /R %INST_PFAD%Negativ %%f in (*.*) do (
	REM echo %%f>> %INST_PFAD%Negativ_List_lang.txt
REM )
REM for /R %INST_PFAD%Negativ %%f in (*.*) do  (
	REM echo Negativ\%%~nxf>> %INST_PFAD%Negativ_List.txt
REM )

del /q "%DATEN_PFAD%Positiv_List.txt"
del /q "%DATEN_PFAD%Positiv_konstant_List.txt"

:: Positive Beispiele _______________________________________________________________________________________________________
echo "alte Positiv- Liste erstellen"
for /R %DATEN_PFAD%Positiv %%f in (*.jpg *.png *.tif) do (
    echo %%f >> %DATEN_PFAD%Positiv_List.txt
)
for /R %DATEN_PFAD%Positiv_konstant %%f in (*.jpg *.png *.tif) do (
    echo %%f >> %DATEN_PFAD%Positiv_konstant_List.txt
)
echo on

:: einzelnes Bild transformieren in verschiedene Lagen ______________________________________________________________________
:: start /B  {exe}    für Hintergrundprozess
echo "alte Vec- Dateien loeschen"
del /q "%DATEN_PFAD%Vec\*.vec"
echo "Create Samples"
echo %OPENCV_BIN%opencv_createsamples
for /R %DATEN_PFAD%Positiv %%f in (*.jpg *.png *.tif) do  (
    echo %DATEN_PFAD%Positiv\%%~nxf
    echo %DATEN_PFAD%Negativ_List.txt
    echo %DATEN_PFAD%Vec\Objekte_%OBJEKT%_%%~nf.vec
    %OPENCV_BIN%opencv_createsamples	-img     %DATEN_PFAD%Positiv\%%~nxf ^
										-bg      %DATEN_PFAD%Negativ_List.txt ^
										-vec     %DATEN_PFAD%Vec\Objekte_%OBJEKT%_%%~nf.vec ^
										-num     %IMG_NUM% -maxxangle %MAXX% -maxyangle %MAXY% -maxzangle %MAXZ% ^
										-maxidev  40 -bgcolor 255 -bgthresh 5 -w %IMG_W% -h %IMG_H% 

)
:: statische Bilder ohne Transformation oder Austausch des Hintergrunds
for /R %DATEN_PFAD%Positiv_konstant %%f in (*.jpg *.png *.tif) do  (
    %OPENCV_BIN%opencv_createsamples	-img     %DATEN_PFAD%Positiv_konstant\%%~nxf ^
										-bg      %DATEN_PFAD%Negativ_List.txt ^
										-vec     %DATEN_PFAD%Vec\Objekte_%OBJEKT%_%%~nf.vec ^
										-num     1 -maxxangle 0 -maxyangle 0 -maxzangle 0 ^
										-maxidev  40 -bgcolor 255 -bgthresh 5 -w %IMG_W% -h %IMG_H% 

)
:: mergevec _______________________________________________________________________________________________________
echo "Merge Vektordateien"
%PYTHON_2_7_BIN%python.exe %MERGEV_BIN%mergevec_py2.py -v %DATEN_PFAD%Vec -o %DATEN_PFAD%Objekte_%OBJEKT%_Summe.vec

:: traincascade _______________________________________________________________________________________________________
echo "alte Classifier loeschen"
::del /q "%DATEN_PFAD%Classifier\*"
echo "test"
)
:: Ende IF nur Training -----------------------------------------------------------------------------------------------

echo on
set /A dateien=0
for /R %DATEN_PFAD%Positiv          %%f in (*.jpg *.png *tif) do ( set /A dateien=dateien+1 )
for /R %DATEN_PFAD%Positiv_konstant %%f in (*.jpg *.png *tif) do ( set /A dateienk=dateienk+1 )
set /A anzPos=%dateien%*%IMG_NUM%*(100-%IMG_RESERVE%)/100+%dateienk%
set /A anzNeg=%anzPos%*20
echo "Training ADABOOST LBP"
%OPENCV_BIN%opencv_traincascade.exe  -data     %DATEN_PFAD%Classifier ^
                                     -vec      %DATEN_PFAD%Objekte_%OBJEKT%_Summe.vec ^
									 -bg       %DATEN_PFAD%Negativ_List_lang.txt ^
									 -bt RAB -numStages %NUMSTAGES% -featureType LBP -minHitRate 0.999 -maxFalseAlarmRate %maxFalseAlarmRate% -maxWeakCount 500 ^
									 -numPos %anzPos% -numNeg %anzNeg% -w %IMG_W% -h %IMG_H% -precalcValBufSize 16240 -precalcIdxBufSize 16240
