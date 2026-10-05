# Secure-Homelab

Self-hosted Cloud-Homelab mit Security-Fokus – Praxisprojekt für Cloud Security Engineering

> 🚧 **Work in Progress** – dieses Projekt entsteht aktuell, README wird laufend aktualisiert

## Tech-Stack

![Ubuntu](https://img.shields.io/badge/Ubuntu-Server-E95420?logo=ubuntu&logoColor=white)
![Docker](https://img.shields.io/badge/Docker-2496ED?logo=docker&logoColor=white)
![Terraform](https://img.shields.io/badge/Terraform-844FBA?logo=terraform&logoColor=white)
![Kubernetes](https://img.shields.io/badge/k3s-326CE5?logo=kubernetes&logoColor=white)
![Tailscale](https://img.shields.io/badge/Tailscale-242424?logo=tailscale&logoColor=white)
![GitHub Actions](https://img.shields.io/badge/GitHub%20Actions-2088FF?logo=githubactions&logoColor=white)
![Trivy](https://img.shields.io/badge/Trivy-1904DA?logo=aqua&logoColor=white)
![tfsec](https://img.shields.io/badge/tfsec-Security%20Scan-blue)
![Gitleaks](https://img.shields.io/badge/Gitleaks-Secret%20Scan-red)


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
- [x] k3s-Cluster installiert
- [x] RBAC-Rollen statt Standard-Admin-Zugriff konfiguriert
- [x] NetworkPolicies zwischen Pods eingerichtet

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
Aufgrund von Hardware beschränkungen erstmal gestoppt, stattdessen CI
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
| Schreibgeschütztes Container-Dateisystem (read_only bei Docker, readOnlyRootFilesystem bei Kubernetes) | Verhindert, dass Schadcode im Container abgelegt wird. Nur die Pfade, die nginx tatsächlich braucht, sind beschreibbar – und liegen im RAM, sind also nach einem Neustart weg. |
| no-new-privileges:true | Prozesse können über SetUID-Binaries keine zusätzlichen Rechte erlangen. Begrenzt den Schaden bei einer Kompromittierung. |
| Variablen in variables.tf / terraform.tfvars ausgelagert | Konfiguration vom Code getrennt. Bei Secrets bewusst ohne default, damit ein vergessener Wert nicht still durch einen Standardwert ersetzt wird. |
| securityContext mit runAsNonRoot, allowPrivilegeEscalation: false und capabilities: drop ALL| Mehrere unabhängige Schutzebenen: Der Container läuft nicht als root, kann keine Dateien ablegen, keine Rechte über SetUID erlangen und hat keine der standardmäßig vergebenen Linux-Capabilities. Jede Ebene unterbricht einen anderen Schritt einer Angriffskette. |
| NetworkPolicy mit Default-Deny und gezielter Freigabe | Standardmäßig darf jeder Pod jeden erreichen. Zugriff jetzt nur noch für Pods mit passendem Label. |
| automountServiceAccountToken: false | nginx braucht die Kubernetes-API nicht. Ohne Token findet ein kompromittierter Container keinen Clusterzugang. |


## Lessons Learned

Docker umgeht die Firewall
Ein veröffentlichter Container-Port war trotz ufw mit Default-Deny aus dem gesamten Heimnetz erreichbar. Docker schreibt eigene iptables-Regeln, die vor den ufw-Regeln greifen. Gefunden nur, weil in den nginx-Logs ein Zugriff von einer lokalen IP auftauchte, die dort nicht hätte stehen dürfen. Gelöst durch Bindung des Ports an das Tailscale-Interface statt an 0.0.0.0.

cloud-init überschreibt die SSH-Konfiguration
Die Härtung in /etc/ssh/sshd_config blieb wirkungslos, weil eine Datei in sshd_config.d/ sie übersteuerte. Eigene 99-hardening.conf angelegt – höhere Nummer gewinnt. Lehre: Nach jeder Änderung mit sshd -T prüfen, was tatsächlich gilt, statt der Konfigurationsdatei zu vertrauen.

Härtung ist iterativ, nicht deklarativ
read_only = true hat den Container beim ersten Versuch gekillt. Man muss erst herausfinden, wohin eine Anwendung tatsächlich schreibt – Logs lesen, Pfad ergänzen, wiederholen. Dasselbe beim Wechsel auf das unprivilegierte Image, plus der Grund dahinter: Prozesse ohne root dürfen keine Ports unter 1024 belegen.

Basis-Image-Wahl ist eine Security-Entscheidung
Trivy-Vergleich: 390 Schwachstellen bei nginx:latest gegen 2 bei nginx:alpine. Derselbe Webserver. Außerdem: Ein Treffer hatte Status fixed – Images veralten still, auch wenn der Tag gleich bleibt.

Hardware zuerst ausschließen
Die Installation hing an einer defekten Festplatte, nicht an einem Konfigurationsfehler. dmesg zeigte BadCRC und ICRC ABRT, also Übertragungsfehler auf SATA-Ebene. Vorher waren zwei Stunden in Rufus-Einstellungen und BIOS-Optionen geflossen.

Ressourcen planen, bevor man installiert
Das BIOS gibt nur 2,7 von 8 GB RAM frei, dazu reserviert der Kernel 320 MB für ungenutzte Crash-Dumps. Trivy scheiterte zudem an /tmp, das im RAM liegt und nur 1,4 GB groß ist. In Kubernetes zwingt das zu Ressourcenlimits – was man ohnehin tun sollte, hier aber nicht freiwillig lernt.

Zugriffskontrolle kostet Bequemlichkeit
Jeder neue Dienst braucht eine bewusste Freigabe: in ufw, in der Tailscale-ACL, in der NetworkPolicy. Das fühlt sich zunächst umständlich an und ist genau der Punkt – wer alles offen lässt, erspart sich die Entscheidung und verliert die Kontrolle.

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

Neben dem eigenen nginx-service ist der cluster-interne kubernetes-Service zu sehen, über den die API erreichbar ist. Beide vom Typ ClusterIP, also nur innerhalb des Clusters ansprechbar.

<img width="689" height="81" alt="Screenshot 2026-10-03 115900" src="https://github.com/user-attachments/assets/864a0370-e85f-4554-95c2-d8cdbb6117dd" />

---

Legt die gewünschte Anzahl an Pods fest (replicas: 1) und enthält sämtliche Härtungsmaßnahmen: nicht-root-Benutzer, keine Privilege Escalation und das Entfernen aller Linux-Capabilities.

<img width="784" height="664" alt="Screenshot 2026-10-03 120012" src="https://github.com/user-attachments/assets/15e60ab8-3179-44a9-82b0-d22aa4dc63ed" />

---

Pod-IPs ändern sich bei jedem Neustart. Der Service bietet deshalb einen festen Namen, über den die Pods clusterintern erreichbar bleiben, und leitet Port 80 auf den Container-Port 8080 weiter.

<img width="710" height="247" alt="Screenshot 2026-10-03 115925" src="https://github.com/user-attachments/assets/b5901c22-d3fd-4a61-8600-d0bc7b1f32ed" />

---

Standardmäßig wird jedem Pod ein Token für die Kubernetes-API ins Dateisystem gelegt. Da nginx die API nicht benötigt, wurde das Einhängen deaktiviert – ein kompromittierter Container findet damit keinen Zugang zum Cluster.

Vorher:

<img width="1165" height="39" alt="Screenshot 2026-10-03 140830" src="https://github.com/user-attachments/assets/345144c2-7701-4682-8ed2-ce3610f9635c" />

Nachher:

<img width="1297" height="79" alt="Screenshot 2026-10-03 141123" src="https://github.com/user-attachments/assets/8121ed69-6d15-4f3e-9e84-6142ae56e3e8" />

---

In Kubernetes darf standardmäßig jeder Pod jeden anderen erreichen. Die Policy kehrt das um: Eingehender Verkehr ist blockiert, erlaubt sind nur Pods mit dem Label role: client auf Port 8080.

<img width="800" height="508" alt="Screenshot 2026-10-04 162611" src="https://github.com/user-attachments/assets/424ffdda-4661-4820-b661-e2ab41339795" />

Nachweis mit zwei identischen Anfragen, die sich nur im Label des aufrufenden Pods unterscheiden:

Ohne Label – Zeitüberschreitung:

<img width="1096" height="134" alt="Screenshot 2026-10-04 162506" src="https://github.com/user-attachments/assets/a97b1a41-fd1c-4c2c-8025-a0dc444b68c5" />


Mit Label role: client – Anfrage geht durch:

<img width="1179" height="609" alt="Screenshot 2026-10-04 162533" src="https://github.com/user-attachments/assets/a762feb0-d170-4952-9f24-8442e0a41f30" />

---

Die Worker-Prozesse starten sauber, obwohl das Root-Dateisystem read-only ist. Beschreibbar ist nur /tmp, eingebunden als emptyDir im RAM.

<img width="735" height="209" alt="Screenshot 2026-10-04 165012" src="https://github.com/user-attachments/assets/4485bfdf-2ddc-4a09-9390-3ead5de4e726" />

Der Versuch, eine Datei im Container anzulegen, scheitert. Damit kann auch ein Angreifer keinen Schadcode ablegen.

<img width="1047" height="57" alt="Screenshot 2026-10-04 164954" src="https://github.com/user-attachments/assets/29106d88-7403-48c7-9f8e-45c41569ae4b" />

---

**Kontakt:** [Demian.W / https://github.com/headnutAi]
