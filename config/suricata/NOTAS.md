# Notas de configuracion de Suricata

- Interfaz monitoreada: `enp7s0` (red socnet, donde llegan los ataques).
- `HOME_NET: "[10.10.10.0/24]"`.
- `HTTP_PORTS: "80,8080"` (se anadio 8080 para inspeccionar DVWA).
- Ruleset: ET Open (via `suricata-update`).
- Cargar `local.rules` anadiendolo a `rule-files:` en `/etc/suricata/suricata.yaml`.
