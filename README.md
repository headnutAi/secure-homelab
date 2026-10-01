# Secure-Homelab

Self-hosted Cloud-Homelab mit Security-Fokus – Praxisprojekt für Cloud Security Engineering

> 🚧 **Work in Progress** – dieses Projekt entsteht aktuell, README wird laufend aktualisiert

## Tech-Stack

![Ubuntu](https://img.shields.io/badge/Ubuntu-Server-E95420?logo=ubuntu&logoColor=white)
![Docker](https://img.shields.io/badge/Docker-2496ED?logo=docker&logoColor=white)
![Terraform](https://img.shields.io/badge/Terraform-844FBA?logo=terraform&logoColor=white)
![Kubernetes](https://img.shields.io/badge/k3s-326CE5?logo=kubernetes&logoColor=white)
![Tailscale](https://img.shields.io/badge/Tailscale-VPN-black)
![Grafana](https://img.shields.io/badge/Grafana-F46800?logo=grafana&logoColor=white)

<!-- Weitere Badges nach Bedarf: https://shields.io -->

## Architektur

<!-- Diagramm hier einbinden, z.B. mit Excalidraw oder draw.io erstellt -->



## Motivation

Dieses Projekt entsteht, um Cloud- und Security-Konzepte praktisch zu üben, statt sie nur in Tutorials zu lesen – mit dem Ziel, mich für eine Rolle als Cloud Security Engineer vorzubereiten.


## Was wurde umgesetzt

### Infrastruktur
- [x] Ubuntu Server (headless) auf dem PC installiert, inkl. OpenSSH
- [x] System aktuell gehalten (apt update/upgrade, ggf. unattended-upgrades)
- [x] SSH gehärtet: nur Public-Key-Login, Passwort-Login deaktiviert, Root-Login gesperrt
- [x] Firewall (ufw) mit minimal nötigen offenen Ports
- [x] fail2ban gegen Brute-Force-Versuche eingerichtet

### Container & Sicherheit
- [x] Docker installiert
- [x] Container laufen nicht als root (USER-Direktive im Dockerfile)
- [x] Images vor dem Start mit Trivy gescannt
- [ ] k3s-Cluster installiert
- [ ] RBAC-Rollen statt Standard-Admin-Zugriff konfiguriert
- [ ] NetworkPolicies zwischen Pods eingerichtet

### Infrastructure as Code
- [x] Terraform installiert
- [x] Docker-Provider für Terraform eingerichtet
- [x] main.tf mit provider/docker_image/docker_container geschrieben
- [x] Secrets/Variablen in .tfvars ausgelagert statt im Code
- [x] .tfstate und .tfvars in .gitignore eingetragen

### Netzwerk & Zugriff
- [x] Tailscale auf dem Server installiert und verbunden
- [x] Tailscale auf Endgeräten (Laptop/Handy) eingerichtet
- [x] ACLs in der Tailscale-Admin-Konsole konfiguriert

### Monitoring & Logging
- [ ] Prometheus + Grafana installiert
- [ ] Loki für zentrales Logging eingerichtet
- [ ] auditd auf dem Host aktiviert
- [ ] Dashboards für Server-/Cluster-Zustand erstellt
## Security-Entscheidungen

<!-- Dieser Abschnitt ist für eine Security-Engineer-Bewerbung der wichtigste Teil.
     Nicht nur WAS du gemacht hast, sondern WARUM. -->

| Entscheidung | Begründung |
|---|---|
| Firewall (ufw) nur mit nötigen Ports offen | Jeder offene Port ist eine potenzielle Angriffsfläche. Default-Policy deny incoming, nur Port 22 freigegeben. |
| fail2ban aktiv | Sperrt IPs nach wiederholten fehlgeschlagenen Login-Versuchen und unterbindet so Brute-Force-Angriffe. |
| Tailscale statt Portfreigabe im Router | Verschlüsselte Peer-to-Peer-Verbindung (WireGuard) zwischen den Geräten. Der Server ist aus dem öffentlichen Internet nicht erreichbar. |
| SSH nur mit Public-Key, Passwort-Login deaktiviert | Keys lassen sich nicht per Brute-Force erraten.  |
| Root-Login gesperrt | root existiert auf jedem System und ist ein bekanntes Angriffsziel. Admin-Aktionen laufen über sudo und bleiben nachvollziehbar. |
| Tailscale-ACLs statt Standard-Freigabe | Standardmäßig darf jedes Gerät jedes andere erreichen. Die ACL erlaubt nur Admin-Zugriff auf tag:server an Port 22 (Least Privilege) |
| Automatisierte ACL-Tests | Jede Policy-Änderung wird beim Speichern gegen definierte Erwartungen geprüft – verhindert versehentliche Fehlkonfiguration. |
| Device Approval aktiviert | Neue Geräte müssen manuell freigegeben werden. Zweite Kontrollebene, falls der Account kompromittiert wird. |
| Tailscale SSH bewusst nicht aktiviert | Authentifizierung bleibt bei den eigenen SSH-Keys, statt sie an einen Drittanbieter abzugeben. |
| Kein User in der docker-Gruppe | Gruppenmitglieder können über Container das Host-Dateisystem mounten und so root-Rechte erlangen – ohne sudo-Protokollierung. Docker wird bewusst nur über sudo genutzt. |
| Alpine-basierte Images statt Debian-Standard | Vergleichsscan mit Trivy: nginx:latest (145 Pakete) zeigt 390 bekannte Schwachstellen, nginx:alpine (71 Pakete) nur 2. Weniger installierte Software bedeutet weniger Angriffsfläche. |
| Images vor dem Einsatz mit Trivy gescannt | Jeder Container erbt alle Schwachstellen seines Images. Ein Scan zeigte auch Lücken mit Status fixed – Images veralten still, auch wenn der Tag gleich bleibt. |
| nginxinc/nginx-unprivileged statt Standard-nginx | Der Standard-nginx läuft als root im Container. Wird eine Lücke ausgenutzt, hat der Angreifer sofort root-Rechte und ist einem Container-Ausbruch deutlich näher. |
| read_only = true mit tmpfs für /var/cache/nginx und /run | Verhindert, dass Schadcode im Container abgelegt wird. Nur die Pfade, die nginx tatsächlich braucht, sind beschreibbar – und liegen im RAM, sind also nach einem Neustart weg. |
| no-new-privileges:true | Prozesse können über SetUID-Binaries keine zusätzlichen Rechte erlangen. Begrenzt den Schaden bei einer Kompromittierung. |
| Variablen in variables.tf / terraform.tfvars ausgelagert | Konfiguration vom Code getrennt. Bei Secrets bewusst ohne default, damit ein vergessener Wert nicht still durch einen Standardwert ersetzt wird. |
| Trivy-Scan vor Container-Start |  |
| Terraform-State/Secrets nicht im Git |  |
| RBAC/NetworkPolicies in k3s |  |


## Angriffssimulation

Work in progress

## Lessons Learned

Work in progress

## Screenshots

Trivy Sicherheitsscan von dem nginx image mit der alpine

<img width="1692" height="703" alt="trivyAlpineScan" src="https://github.com/user-attachments/assets/d20ec430-ae42-42df-b972-d13a4f7d5d54" />

---

Unterschied zwischen debian und alpine 

<img width="537" height="148" alt="Screenshot 2026-10-01 124837" src="https://github.com/user-attachments/assets/97c183fa-775e-4175-8b56-aea979e587ab" />

<img width="651" height="141" alt="Screenshot 2026-10-01 124820" src="https://github.com/user-attachments/assets/2b825f57-e2c1-44e3-9f68-eba042bada6d" />

Vergleich der Basis-Images: nginx:latest (Debian, 145 Pakete) → 390 bekannte Schwachstellen. nginx:alpine (71 Pakete) → 2. Gleicher Webserver, deutlich kleinere Angriffsfläche.

---

Nachweis, dass das Container-Dateisystem schreibgeschützt ist

<img width="666" height="40" alt="Screenshot 2026-10-01 141904" src="https://github.com/user-attachments/assets/ef2b93e3-5e48-4a98-a2ad-698222ebb3d6" />

---

## Setup / Nachbauen

Work in progress

## Nächste Schritte

- [ ] [Was ist noch geplant / ausbaufähig?]

---

**Kontakt:** [Demian.W / https://github.com/headnutAi]
