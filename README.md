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

## Was wurde umgesetzt

### Infrastruktur
- [ ] Ubuntu Server (headless) auf dem PC installiert, inkl. OpenSSH
- [ ] System aktuell gehalten (apt update/upgrade, ggf. unattended-upgrades)
- [ ] SSH gehärtet: nur Public-Key-Login, Passwort-Login deaktiviert, Root-Login gesperrt
- [ ] Firewall (ufw) mit minimal nötigen offenen Ports
- [ ] fail2ban gegen Brute-Force-Versuche eingerichtet

### Container & Sicherheit
- [ ] Docker installiert
- [ ] Container laufen nicht als root (USER-Direktive im Dockerfile)
- [ ] Images vor dem Start mit Trivy gescannt
- [ ] k3s-Cluster installiert
- [ ] RBAC-Rollen statt Standard-Admin-Zugriff konfiguriert
- [ ] NetworkPolicies zwischen Pods eingerichtet

### Infrastructure as Code
- [ ] Terraform installiert
- [ ] Docker-Provider für Terraform eingerichtet
- [ ] main.tf mit provider/docker_image/docker_container geschrieben
- [ ] Secrets/Variablen in .tfvars ausgelagert statt im Code
- [ ] .tfstate und .tfvars in .gitignore eingetragen

### Netzwerk & Zugriff
- [ ] Tailscale auf dem Server installiert und verbunden
- [ ] Tailscale auf Endgeräten (Laptop/Handy) eingerichtet
- [ ] ACLs in der Tailscale-Admin-Konsole konfiguriert

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
| Firewall (ufw) nur mit nötigen Ports offen |  |
| fail2ban aktiv |  |
| Tailscale statt Portfreigabe im Router |  |
| Trivy-Scan vor Container-Start |  |
| Terraform-State/Secrets nicht im Git |  |
| RBAC/NetworkPolicies in k3s |  |

## Angriffssimulation


## Lessons Learned



## Screenshots

<!-- z.B. Grafana-Dashboard, terraform plan-Output, kubectl get pods -->


## Setup / Nachbauen



## Nächste Schritte

- [ ] [Was ist noch geplant / ausbaufähig?]

---

**Kontakt:** [Demian.W / https://github.com/headnutAi]
