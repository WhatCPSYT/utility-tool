@echo off
title Windows Utility Tool

net session >nul 2>&1
if %errorlevel% neq 0 (
    :: Uruchom ponownie jako administrator
    powershell -Command "Start-Process '%~f0' -Verb RunAs"
    exit
)

goto menu

:menu
cls
echo ============================================
echo         Windows Utility Tool v1.0
echo ============================================

echo --- Ustawienia kont ------------------------
echo 1.  Utworz konto z haslem
echo 2.  Utworz konto bez hasla
echo 3.  Usun konto
echo 4.  Pokaz liste kont
echo 5.  Informacje o systemie
echo 6.  Aktywuj konto
echo 7.  Dezaktywuj konto
echo 8.  Ustaw pelna nazwe
echo 9.  Ustaw komentarz
echo 10. Ustaw date wygasniecia
echo 11. Resetuj haslo
echo 12. Szczegoly konta
echo.
echo --- Ustawienia grup ------------------------
echo 13. Dodaj konto do grupy
echo 14. Pokaz liste grup
echo 15. Utworz nowa grupe lokalna
echo 16. Usun grupe lokalna
echo 17. Szczegoly grupy
echo.
echo --- Uprawnienia do folderow ----------------
echo 18. Nadaj pelny dostep (Administrator)
echo 19. Nadaj modyfikacje
echo 20. Nadaj zapis
echo 21. Nadaj odczyt
echo 22. Legenda uprawnien i sciezek
echo.
echo --- Inne -----------------------------------
echo 23. Credits
echo 24. Wyjscie
echo 25. Self-Destruct
echo.
echo ============================================
set /p wybor=Podaj numer opcji: 

if "%wybor%"=="1" goto createpass
if "%wybor%"=="2" goto createnopass
if "%wybor%"=="3" goto delete
if "%wybor%"=="4" goto listusers
if "%wybor%"=="5" goto sysinfo
if "%wybor%"=="6" goto activate
if "%wybor%"=="7" goto deactivate
if "%wybor%"=="8" goto fullname
if "%wybor%"=="9" goto comment
if "%wybor%"=="10" goto expire
if "%wybor%"=="11" goto resetpass
if "%wybor%"=="12" goto userdetails
if "%wybor%"=="13" goto addgroup
if "%wybor%"=="14" goto listgroups
if "%wybor%"=="15" goto creategroup
if "%wybor%"=="16" goto deletegroup
if "%wybor%"=="17" goto groupdetails
if "%wybor%"=="18" goto fullaccess
if "%wybor%"=="19" goto modify
if "%wybor%"=="20" goto write
if "%wybor%"=="21" goto read
if "%wybor%"=="22" goto legend
if "%wybor%"=="23" goto credits
if "%wybor%"=="24" goto end
if "%wybor%"=="25" goto selfdestruct
goto menu

:createpass
set /p user=Podaj nazwe uzytkownika: 
set /p pass=Podaj haslo: 
net user %user% %pass% /add
echo Konto %user% zostalo utworzone z haslem.
pause
goto menu

:createnopass
set /p user=Podaj nazwe uzytkownika: 
net user %user% "" /add
echo Konto %user% zostalo utworzone bez hasla.
pause
goto menu

:delete
set /p user=Podaj nazwe uzytkownika do usuniecia: 
net user %user% /delete
echo Konto %user% zostalo usuniete.
pause
goto menu

:listusers
echo Lista kont lokalnych:
net user
pause
goto menu

:sysinfo
cls
echo ============================================
echo Informacje o systemie:
echo ============================================
echo Nazwa komputera: %COMPUTERNAME%
echo Uzytkownik: %USERNAME%
echo Wersja Windows:
ver
echo --------------------------------------------
echo Adres IP:
ipconfig | findstr /i "IPv4"
echo ============================================
pause
goto menu

:activate
set /p user=Podaj nazwe uzytkownika do aktywacji: 
net user %user% /active:yes
echo Konto %user% zostalo aktywowane.
pause
goto menu

:deactivate
set /p user=Podaj nazwe uzytkownika do dezaktywacji: 
net user %user% /active:no
echo Konto %user% zostalo dezaktywowane.
pause
goto menu

:fullname
set /p user=Podaj nazwe uzytkownika: 
set /p name=Podaj pelna nazwe: 
net user %user% /fullname:"%name%"
echo Pelna nazwa ustawiona dla %user%.
pause
goto menu

:comment
set /p user=Podaj nazwe uzytkownika: 
set /p text=Podaj komentarz: 
net user %user% /comment:"%text%"
echo Komentarz ustawiony dla %user%.
pause
goto menu

:expire
set /p user=Podaj nazwe uzytkownika: 
set /p date=Podaj date wygasniecia (MM/DD/YYYY): 
net user %user% /expires:%date%
echo Data wygasniecia ustawiona dla %user%.
pause
goto menu

:resetpass
set /p user=Podaj nazwe uzytkownika: 
set /p pass=Podaj nowe haslo: 
net user %user% %pass%
echo Haslo dla %user% zostalo zmienione.
pause
goto menu

:userdetails
set /p user=Podaj nazwe uzytkownika: 
net user %user%
pause
goto menu

:addgroup
set /p user=Podaj nazwe uzytkownika: 
set /p group=Podaj nazwe grupy (np. Administrators, Users): 
net localgroup %group% %user% /add
echo Konto %user% dodane do grupy %group%.
pause
goto menu

:listgroups
echo Lista grup lokalnych:
net localgroup
pause
goto menu

:creategroup
set /p group=Podaj nazwe nowej grupy: 
net localgroup %group% /add
echo Grupa %group% zostala utworzona.
pause
goto menu

:deletegroup
set /p group=Podaj nazwe grupy do usuniecia: 
net localgroup %group% /delete
echo Grupa %group% zostala usunieta.
pause
goto menu

:groupdetails
set /p group=Podaj nazwe grupy: 
net localgroup %group%
pause
goto menu

:fullaccess
set /p folder=Podaj sciezke folderu: 
icacls "%folder%" /grant Administrator:F
echo Administrator otrzymal pelny dostep do %folder%.
pause
goto menu

:modify
set /p folder=Podaj sciezke folderu: 
set /p user=Podaj nazwe uzytkownika: 
icacls "%folder%" /grant %user%:M
echo Uzytkownik %user% otrzymal modyfikacje do %folder%.
pause
goto menu

:write
set /p folder=Podaj sciezke folderu: 
set /p user=Podaj nazwe uzytkownika: 
icacls "%folder%" /grant %user%:W
echo Uzytkownik %user% otrzymal prawo zapisu do %folder%.
pause
goto menu

:read
set /p folder=Podaj sciezke folderu: 
set /p user=Podaj nazwe uzytkownika: 
icacls "%folder%" /grant %user%:R
echo Uzytkownik %user% otrzymal prawo odczytu do %folder%.
pause
goto menu

:legend
cls
echo ============================================
echo Legenda uprawnien (icacls):
echo ============================================
echo F  - Full access (pelny dostep)
echo M  - Modify (modyfikacja)
echo RX - Read and Execute (odczyt + uruchamianie)
echo R  - Read (tylko odczyt)
echo W  - Write (tylko zapis)
echo --------------------------------------------
echo Jak podawac sciezke folderu:
echo - Podaj pelna sciezke, np. C:\Dokumenty
echo - Jesli folder ma spacje w nazwie, uzyj ""
echo   np. "C:\Moje pliki\Folder testowy"
echo - Jesli podasz tylko nazwe (np. Dokumenty),
echo   program szuka w biezacym katalogu .bat
echo ============================================
echo Zalecenie: zawsze dodaj Administratora z F (Full access),
echo aby miec pelna kontrole nad folderem.
pause
goto menu

:credits
cls
echo ============================================
echo            Windows Utility Tool
echo ============================================
echo Autor: WhatCPS?
echo Wersja: Developerska v1.0
echo Data: Styczen 2026
echo =========================================
pause
goto menu

:end
echo Koniec programu.

:selfdestruct
cls
echo ============================================
echo Ta operacja wylaczy ten program i usunie go z komputera.
echo Jesli chcesz znowu pobrac, wejdz na strone: https://twoja-strona.github.io
echo ============================================
choice /c TN /n /m "Czy chcesz kontynuowac? (T/N)"

if %errorlevel%==2 goto menu
if %errorlevel%==1 goto destroy

:destroy
echo Program zostanie zamkniety i usuniety...
timeout /t 3 /nobreak >nul

set tempdeleter=%temp%\delete_me.bat
(
    echo @echo off
    echo timeout /t 2 /nobreak ^>nul
    echo if not exist "%~f0" goto end
    echo del "%~f0"
    echo :end
    echo del "%%~f0"
) > "%tempdeleter%"

start "" "%tempdeleter%"
exit
