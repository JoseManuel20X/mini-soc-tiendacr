# Evidencias — Mini SOC TiendaCR

Capturas del laboratorio, en orden.

## Despliegue y arquitectura
- 01 — Adaptador de red socnet (aislada) en el objetivo
- 02 — IP fija 10.10.10.10 en la interfaz socnet
- 03 — DVWA corriendo en Docker (puerto 8080)
- 04/05 — Setup de DVWA y nivel de seguridad Low

## Control de acceso (2.2)
- 06 — UFW con denegación por defecto, solo IP del equipo
- 07 — SSH solo con llaves (contraseña rechazada)

## Monitoreo (2.3)
- 08 — Panel central de Wazuh
- 09 — Agente del objetivo en estado Active

## Ataques y detección (2.4 / 2.5)
- 10 — Ataque 1: escaneo nmap, técnicas MITRE en el panel
- 11/12 — Ataque 2: fuerza bruta SSH (panel + auth.log)
- 13 — Ataque 3: sqlmap vuelca la tabla de usuarios
- 14 — Ataque 3: detección por regla propia de Suricata
- 15 — Ataque 4: FIM detecta el defacement

## Respuesta automática (2.6)
- 16 — firewall-drop ejecutándose (active-responses.log + iptables)
- 17 — IP del atacante bloqueada (ping 100% de pérdida)

## Remediación (2.8)
- 18 — Mismo SQLi ya no es inyectable tras consultas parametrizadas
