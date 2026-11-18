# Plan de respuesta a incidentes

Método: **NIST SP 800-61** aplicado al **Ataque 2 (fuerza bruta SSH)**.

## Incidente: intento de fuerza bruta contra SSH del servidor objetivo

**Roles**
- **Analista del SOC** (detección y análisis): Manuel Miranda.
- **Responsable de respuesta** (contención, erradicación, recuperación): Steven Ramírez.

| Fase | Acciones | Tiempo objetivo |
|---|---|---|
| **1. Preparación** | SOC desplegado (Wazuh + Suricata), reglas y respuesta automática configuradas, inventario de activos y respaldos al día, contactos del equipo definidos. | Continuo |
| **2. Detección y análisis** | Wazuh dispara la alerta *"sshd: Multiple authentication failures"* (nivel 10). El analista confirma la IP de origen, la cuenta atacada y el número de intentos, y descarta un falso positivo. | < 5 min |
| **3. Contención** | La **respuesta automática** de Wazuh bloquea temporalmente la IP atacante en el firewall (`firewall-drop`). El analista verifica el bloqueo y, si el ataque escala, amplía la contención de forma manual. | < 1 min (automática) |
| **4. Erradicación** | Verificar que no hubo acceso exitoso (`grep "Accepted" /var/log/auth.log`); si alguna credencial fue comprometida, rotarla; reforzar SSH (solo llaves, sin contraseña ni acceso de root). | < 30 min |
| **5. Recuperación** | Restaurar el servicio normal, retirar los bloqueos temporales que afecten tráfico legítimo y vigilar la reincidencia durante las horas siguientes. | < 1 h |
| **6. Lecciones aprendidas** | Documentar el incidente, ajustar los umbrales de la respuesta automática, migrar definitivamente SSH a llaves y evaluar MFA, un bastión o una VPN. Reunión post-incidente del equipo. | < 48 h |

## Riesgo de la respuesta automática
Un bloqueo por IP puede afectar **tráfico legítimo** (por ejemplo, si un administrador comparte
IP con el atacante o se equivoca de contraseña varias veces). Por eso el bloqueo es **temporal**
y se mantiene una **lista de excepciones (allowlist)** con las IP del equipo.
