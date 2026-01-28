#!/bin/bash

VERSION="Dev"
GITHUB_URL="https://raw.githubusercontent.com/WhatCPSYT/utility-tool/refs/heads/main/linux_tool.sh"
GITHUB_VER_URL="https://raw.githubusercontent.com/WhatCPSYT/utility-tool/refs/heads/main/linuxversion.txt"

if [ "$EUID" -ne 0 ]; then
  echo "Ten program wymaga uprawnien administratora (root)."
  echo "Uruchom ponownie jako root (np. sudo $0)"
  exit
fi

update_script() {
  clear
  echo "Sprawdzanie dostepnosci aktualizacji..."
  REMOTE_VER=$(curl -s "$GITHUB_VER_URL")

  if [ -z "$REMOTE_VER" ]; then
    echo "Nie udalo sie polaczyc z GitHubem lub brak pliku wersji."
  elif [ "$VERSION" != "$REMOTE_VER" ]; then
    echo "Dostepna nowa wersja: $REMOTE_VER (Obecna: $VERSION)"
    read -p "Czy chcesz zaktualizowac program? (T/N): " choice
    if [[ "$choice" =~ ^[Tt]$ ]]; then
      echo "Pobieranie nowej wersji..."
      curl -s "$GITHUB_URL" -o "$0"
      echo "Aktualizacja zakonczona! Restartowanie programu..."
      sleep 2
      bash "$0"
      exit
    fi
  else
    echo "Masz najnowsza wersje ($VERSION)."
  fi
  read -p "Enter..."
  menu
}

menu() {
  clear
  echo "============================================"
  echo "         Linux Utility Tool v$VERSION"
  echo "============================================"
  echo "--- Ustawienia kont ------------------------"
  echo "1.  Utworz konto z haslem"
  echo "2.  Utworz konto bez hasla"
  echo "3.  Usun konto"
  echo "4.  Pokaz liste kont (passwd)"
  echo "5.  Informacje o systemie"
  echo "6.  Aktywuj konto"
  echo "7.  Dezaktywuj konto"
  echo "8.  Ustaw pelna nazwe"
  echo "9.  Ustaw komentarz"
  echo "10. Ustaw date wygasniecia"
  echo "11. Resetuj haslo"
  echo "12. Szczegoly konta"
  echo "13. Zmien powloke (bash/sh)"
  echo "14. Stworz katalog domowy"
  echo "15. Pokaz shadow (hasla)"
  echo "16. Pokaz GID"
  echo
  echo "--- Ustawienia grup ------------------------"
  echo "17. Dodaj konto do grupy"
  echo "18. Pokaz liste grup (group)"
  echo "19. Utworz nowa grupe"
  echo "20. Usun grupe"
  echo "21. Szczegoly grupy"
  echo
  echo "--- Uprawnienia i Wlasciciele --------------"
  echo "22. Nadaj pelny dostep (root)"
  echo "23. Nadaj modyfikacje"
  echo "24. Nadaj zapis"
  echo "25. Nadaj odczyt"
  echo "26. Zmien wlasciciela (chown)"
  echo "27. Zmien grupe (chgrp)"
  echo "28. Legenda uprawnien i sciezek"
  echo
  echo "--- Operacje na plikach --------------------"
  echo "29. Lista plikow (ls)"
  echo "30. Szczegolowa lista (ls -l)"
  echo "31. Utworz plik (touch)"
  echo "32. Wyswietl plik (cat)"
  echo "33. Edytor Nano"
  echo "34. Edytor MCEdit"
  echo "35. Utworz folder (mkdir)"
  echo "36. Usun pusty folder (rmdir)"
  echo "37. Usun plik/folder (rm -r)"
  echo
  echo "--- Inne -----------------------------------"
  echo "38. Sprawdz aktualizacje"
  echo "39. Credits"
  echo "40. Wyjscie"
  echo "41. Self-Destruct"
  echo "============================================"
  read -p "Podaj numer opcji: " wybor

  case $wybor in
    1) createpass ;; 2) createnopass ;; 3) deleteuser ;; 4) catpasswd ;;
    5) sysinfo ;; 6) activate ;; 7) deactivate ;; 8) fullname ;;
    9) comment ;; 10) expire ;; 11) resetpass ;; 12) userdetails ;;
    13) changeshell ;; 14) mkhome ;; 15) catshadow ;; 16) showgid ;;
    17) addgroup ;; 18) catgroup ;; 19) creategroup ;; 20) deletegroup ;;
    21) groupdetails ;; 22) fullaccess ;; 23) modify ;; 24) writeperm ;;
    25) readperm ;; 26) changeowner ;; 27) changegrp ;; 28) legend ;; 
    29) listfiles ;; 30) listlong ;; 31) createfile ;; 32) catfile ;; 
    33) opennano ;; 34) openmcedit ;; 35) makedir ;; 36) removedir ;; 
    37) removeforce ;; 38) update_script ;; 39) credits ;; 40) end ;; 
    41) selfdestruct ;;
    *) menu ;;
  esac
}

# --- FUNKCJE KONT ---
createpass() {
  read -p "Podaj nazwe uzytkownika: " u
  if id "$u" &>/dev/null; then echo "Konto $u juz istnieje."; read -p "Enter..."; menu; fi
  useradd -m "$u"
  passwd "$u"
  echo "Konto $u zostalo utworzone z haslem."
  read -p "Enter..."
  menu
}

createnopass() {
  read -p "Podaj nazwe uzytkownika: " u
  if id "$u" &>/dev/null; then echo "Konto $u juz istnieje."; read -p "Enter..."; menu; fi
  useradd -m "$u"
  echo "Konto $u zostalo utworzone bez hasla."
  read -p "Enter..."
  menu
}

deleteuser() {
  read -p "Podaj nazwe uzytkownika do usuniecia: " u
  if ! id "$u" &>/dev/null; then echo "Konto $u nie istnieje."; read -p "Enter..."; menu; fi
  userdel -r "$u"
  echo "Konto $u zostalo usuniete."
  read -p "Enter..."
  menu
}

catpasswd() {
  echo "Lista kont lokalnych (/etc/passwd):"
  cat /etc/passwd
  read -p "Enter..."
  menu
}

catshadow() {
  echo "Zawartosc pliku shadow (hasla):"
  cat /etc/shadow
  read -p "Enter..."
  menu
}

sysinfo() {
  clear
  echo "============================================"
  echo "Informacje o systemie:"
  echo "============================================"
  echo "Nazwa komputera: $(hostname)"
  echo "Uzytkownik: $SUDO_USER"
  echo "Wersja systemu:"
  uname -a
  echo "--------------------------------------------"
  echo "Adres IP:"
  hostname -I
  echo "============================================"
  read -p "Enter..."
  menu
}

activate() {
  read -p "Podaj nazwe uzytkownika do aktywacji: " u
  if ! id "$u" &>/dev/null; then echo "Konto $u nie istnieje."; read -p "Enter..."; menu; fi
  usermod -U "$u"
  echo "Konto $u zostalo aktywowane."
  read -p "Enter..."
  menu
}

deactivate() {
  read -p "Podaj nazwe uzytkownika do dezaktywacji: " u
  if ! id "$u" &>/dev/null; then echo "Konto $u nie istnieje."; read -p "Enter..."; menu; fi
  usermod -L "$u"
  echo "Konto $u zostalo dezaktywowane."
  read -p "Enter..."
  menu
}

fullname() {
  read -p "Podaj nazwe uzytkownika: " u
  if ! id "$u" &>/dev/null; then echo "Konto $u nie istnieje."; read -p "Enter..."; menu; fi
  read -p "Podaj pelna nazwe: " n
  chfn -f "$n" "$u"
  echo "Pelna nazwa ustawiona dla $u."
  read -p "Enter..."
  menu
}

comment() {
  echo "Komentarze nie sa standardowo wspierane w Linuxie (brak odpowiednika net user /comment)."
  read -p "Enter..."
  menu
}

expire() {
  read -p "Podaj nazwe uzytkownika: " u
  if ! id "$u" &>/dev/null; then echo "Konto $u nie istnieje."; read -p "Enter..."; menu; fi
  read -p "Podaj date wygasniecia (YYYY-MM-DD): " d
  chage -E "$d" "$u"
  echo "Data wygasniecia ustawiona dla $u."
  read -p "Enter..."
  menu
}

resetpass() {
  read -p "Podaj nazwe uzytkownika: " u
  if ! id "$u" &>/dev/null; then echo "Konto $u nie istnieje."; read -p "Enter..."; menu; fi
  passwd "$u"
  echo "Haslo dla $u zostalo zmienione."
  read -p "Enter..."
  menu
}

userdetails() {
  read -p "Podaj nazwe uzytkownika: " u
  if ! id "$u" &>/dev/null; then echo "Konto $u nie istnieje."; read -p "Enter..."; menu; fi
  echo "Informacje o koncie $u:"
  id "$u"
  getent passwd "$u"
  chage -l "$u"
  read -p "Enter..."
  menu
}

changeshell() {
  read -p "Podaj nazwe uzytkownika: " u
  read -p "Podaj sciezke powloki (np. /bin/bash): " s
  chsh -s "$s" "$u"
  echo "Powloka uzytkownika $u zostala zmieniona na $s."
  read -p "Enter..."
  menu
}

mkhome() {
  read -p "Podaj nazwe uzytkownika: " u
  mkdir -p "/home/$u"
  chown "$u:$u" "/home/$u"
  echo "Katalog domowy dla $u zostal utworzony."
  read -p "Enter..."
  menu
}

showgid() {
  read -p "Podaj nazwe uzytkownika: " u
  echo "GID uzytkownika $u: $(id -g $u)"
  read -p "Enter..."
  menu
}

# --- FUNKCJE GRUP ---
addgroup() {
  read -p "Podaj nazwe uzytkownika: " u
  if ! id "$u" &>/dev/null; then echo "Konto $u nie istnieje."; read -p "Enter..."; menu; fi
  read -p "Podaj nazwe grupy: " g
  getent group "$g" >/dev/null || { echo "Grupa $g nie istnieje."; read -p "Enter..."; menu; }
  usermod -aG "$g" "$u"
  echo "Konto $u dodane do grupy $g."
  read -p "Enter..."
  menu
}

catgroup() {
  echo "Lista grup lokalnych (/etc/group):"
  cat /etc/group
  read -p "Enter..."
  menu
}

creategroup() {
  read -p "Podaj nazwe nowej grupy: " g
  getent group "$g" >/dev/null && { echo "Grupa $g juz istnieje."; read -p "Enter..."; menu; }
  groupadd "$g"
  echo "Grupa $g zostala utworzona."
  read -p "Enter..."
  menu
}

deletegroup() {
  read -p "Podaj nazwe grupy do usuniecia: " g
  getent group "$g" >/dev/null || { echo "Grupa $g nie istnieje."; read -p "Enter..."; menu; }
  groupdel "$g"
  echo "Grupa $g zostala usunieta."
  read -p "Enter..."
  menu
}

groupdetails() {
  read -p "Podaj nazwe grupy: " g
  getent group "$g" || echo "Grupa $g nie istnieje."
  read -p "Enter..."
  menu
}

# --- UPRAWNIENIA ---
fullaccess() {
  read -p "Podaj sciezke folderu: " f
  if [ ! -e "$f" ]; then echo "Sciezka nie istnieje."; read -p "Enter..."; menu; fi
  chmod 777 "$f"
  echo "Pelny dostep do $f zostal nadany."
  read -p "Enter..."
  menu
}

modify() {
  read -p "Podaj sciezke folderu: " f
  if [ ! -e "$f" ]; then echo "Sciezka nie istnieje."; read -p "Enter..."; menu; fi
  chmod 755 "$f"
  echo "Modyfikacja do $f zostala nadana."
  read -p "Enter..."
  menu
}

writeperm() {
  read -p "Podaj sciezke folderu: " f
  if [ ! -e "$f" ]; then echo "Sciezka nie istnieje."; read -p "Enter..."; menu; fi
  chmod u+w "$f"
  echo "Prawo zapisu do $f zostalo nadane."
  read -p "Enter..."
  menu
}

readperm() {
  read -p "Podaj sciezke folderu: " f
  if [ ! -e "$f" ]; then echo "Sciezka nie istnieje."; read -p "Enter..."; menu; fi
  chmod u+r "$f"
  echo "Prawo odczytu do $f zostalo nadane."
  read -p "Enter..."
  menu
}

changeowner() {
  read -p "Podaj uzytkownika: " u
  read -p "Podaj sciezke: " f
  chown "$u" "$f"
  echo "Wlasciciel $f zostal zmieniony na $u."
  read -p "Enter..."
  menu
}

changegrp() {
  read -p "Podaj grupe: " g
  read -p "Podaj sciezke: " f
  chgrp "$g" "$f"
  echo "Grupa $f zostala zmieniona na $g."
  read -p "Enter..."
  menu
}

legend() {
  clear
  echo "============================================"
  echo "   LEGENDA UPRAWNIEN I WARTOSCI"
  echo "============================================"
  echo "777 - Full access (pelny dostep)"
  echo "755 - Modify (modyfikacja)"
  echo "u+w - Write (tylko zapis)"
  echo "u+r - Read (tylko odczyt)"
  echo "--------------------------------------------"
  echo "Wartosci chmod:"
  echo "4 = Odczyt (r), 2 = Zapis (w), 1 = Wykonanie (x)"
  echo "--------------------------------------------"
  echo "Jak podawac sciezke:"
  echo "- Podaj pelna sciezke, np. /home/user/Dokumenty"
  echo "============================================"
  
  read -p "Enter..."
  menu
}

# --- PLIKI I EDYTORY ---
listfiles() { ls -F; read -p "Enter..."; menu; }
listlong() { ls -l; read -p "Enter..."; menu; }
createfile() { read -p "Podaj nazwe pliku: " f; touch "$f"; echo "Plik $f zostal utworzony."; read -p "Enter..."; menu; }
catfile() { read -p "Podaj nazwe pliku: " f; cat "$f"; read -p "Enter..." ; menu; }
opennano() { read -p "Podaj nazwe pliku: " f; nano "$f"; menu; }
openmcedit() { read -p "Podaj nazwe pliku: " f; mcedit "$f"; menu; }
makedir() { read -p "Podaj nazwe folderu: " d; mkdir -p "$d"; echo "Folder $d zostal utworzony."; read -p "Enter..."; menu; }
removedir() { read -p "Podaj nazwe pustego folderu: " d; rmdir "$d"; echo "Folder $d zostal usuniety."; read -p "Enter..."; menu; }

removeforce() {
  read -p "Podaj sciezke do usuniecia (rm -r): " f
  echo "UWAGA: Ta operacja usunie plik lub folder $f na zawsze!"
  read -p "Czy chcesz kontynuowac? (T/N): " choice
  if [[ "$choice" =~ ^[Tt]$ ]]; then
    rm -rf "$f"
    echo "Element $f zostal usuniety."
  fi
  read -p "Enter..."
  menu
}

credits() {
  clear
  echo "============================================"
  echo "            Linux Utility Tool"
  echo "============================================"
  echo "Autor: WhatCPS?"
  echo "Wersja: $VERSION"
  echo "Ostatnia aktualizacja: 28 Styczen 2026"
  echo "============================================"
  read -p "Enter..."
  menu
}

end() {
  echo "Koniec programu."
  exit
}

selfdestruct() {
  clear
  echo "============================================"
  echo "Ta operacja wylaczy ten program i usunie go z komputera."
  echo "============================================"
  read -p "Czy chcesz kontynuowac? (T/N): " choice
  if [[ "$choice" =~ ^[Tt]$ ]]; then
    rm -- "$0"
    exit
  fi
  menu
}

menu
