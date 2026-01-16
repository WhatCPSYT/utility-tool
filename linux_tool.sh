#!/bin/bash

if [ "$EUID" -ne 0 ]; then
  echo "Ten program wymaga uprawnien administratora (root)."
  echo "Uruchom ponownie jako root (np. sudo $0)"
  exit
fi

menu() {
  clear
  echo "============================================"
  echo "         Linux Utility Tool v1.0"
  echo "============================================"
  echo "--- Ustawienia kont ------------------------"
  echo "1.  Utworz konto z haslem"
  echo "2.  Utworz konto bez hasla"
  echo "3.  Usun konto"
  echo "4.  Pokaz liste kont"
  echo "5.  Informacje o systemie"
  echo "6.  Aktywuj konto"
  echo "7.  Dezaktywuj konto"
  echo "8.  Ustaw pelna nazwe"
  echo "9.  Ustaw komentarz"
  echo "10. Ustaw date wygasniecia"
  echo "11. Resetuj haslo"
  echo "12. Szczegoly konta"
  echo
  echo "--- Ustawienia grup ------------------------"
  echo "13. Dodaj konto do grupy"
  echo "14. Pokaz liste grup"
  echo "15. Utworz nowa grupe"
  echo "16. Usun grupe"
  echo "17. Szczegoly grupy"
  echo
  echo "--- Uprawnienia do folderow ----------------"
  echo "18. Nadaj pelny dostep (root)"
  echo "19. Nadaj modyfikacje"
  echo "20. Nadaj zapis"
  echo "21. Nadaj odczyt"
  echo "22. Legenda uprawnien i sciezek"
  echo
  echo "--- Inne -----------------------------------"
  echo "23. Credits"
  echo "24. Wyjscie"
  echo "25. Self-Destruct"
  echo "============================================"
  read -p "Podaj numer opcji: " wybor

  case $wybor in
    1) createpass ;;
    2) createnopass ;;
    3) deleteuser ;;
    4) listusers ;;
    5) sysinfo ;;
    6) activate ;;
    7) deactivate ;;
    8) fullname ;;
    9) comment ;;
    10) expire ;;
    11) resetpass ;;
    12) userdetails ;;
    13) addgroup ;;
    14) listgroups ;;
    15) creategroup ;;
    16) deletegroup ;;
    17) groupdetails ;;
    18) fullaccess ;;
    19) modify ;;
    20) writeperm ;;
    21) readperm ;;
    22) legend ;;
    23) credits ;;
    24) end ;;
    25) selfdestruct ;;
    *) menu ;;
  esac
}

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

listusers() {
  echo "Lista kont lokalnych:"
  cut -d: -f1 /etc/passwd
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

listgroups() {
  echo "Lista grup lokalnych:"
  cut -d: -f1 /etc/group
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

legend() {
  clear
  echo "============================================"
  echo "Legenda uprawnien (chmod):"
  echo "============================================"
  echo "777 - Full access (pelny dostep)"
  echo "755 - Modify (modyfikacja)"
  echo "u+w - Write (tylko zapis)"
  echo "u+r - Read (tylko odczyt)"
  echo "--------------------------------------------"
  echo "Jak podawac sciezke folderu:"
  echo "- Podaj pelna sciezke, np. /home/user/Dokumenty"
  echo "- Jesli folder ma spacje w nazwie, uzyj \"\""
  echo "============================================"
  read -p "Enter..."
  menu
}

credits() {
  clear
  echo "============================================"
  echo "            Linux Utility Tool"
  echo "============================================"
  echo "Autor: WhatCPS?"
  echo "Wersja: Developerska v1.0"
  echo "Data: Styczen 2026"
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
  echo "Jesli chcesz znowu pobrac, wejdz na strone: https://twoja-strona.github.io"
  echo "============================================"
  read -p "Czy chcesz kontynuowac? (T/N): " choice
  if [[ "$choice" =~ ^[Nn]$ ]]; then
    menu
  elif [[ "$choice" =~ ^[Tt]$ ]]; then
    echo "Program zostanie zamkniety i usuniety..."
    sleep 3
    rm -- "$0"
    exit
  else
    menu
  fi
}

menu
