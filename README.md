# [Projektname, z.B. "Secure Homelab"]

> [Ein-Satz-Pitch: was das Projekt ist und wofür es gebaut wurde, z.B. "Self-hosted Cloud-Homelab mit Security-Fokus – Praxisprojekt für Cloud Security Engineering"]

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
![Architektur](docs/architecture.png)

[Kurz erklären, was das Diagramm zeigt: wie hängen PC, Docker/k3s, Tailscale und Monitoring zusammen?]

## Motivation

[Warum hast du das Projekt gebaut? Bezug zu deinem Ziel Cloud Security Engineer herstellen]

## Was wurde umgesetzt

### Infrastruktur
- [ ] [z.B. Ubuntu Server auf altem PC installiert]
- [ ] [z.B. Docker + Container-Setup]
- [ ] [z.B. k3s-Cluster mit ... Services]

### Infrastructure as Code
- [ ] [z.B. Terraform für Docker-Ressourcen]
- [ ] [Was wird dadurch automatisiert?]

### Netzwerk & Zugriff
- [ ] [z.B. Tailscale für Remote-Zugriff ohne Portfreigabe]
- [ ] [ACL-Regeln, falls konfiguriert]

### Monitoring
- [ ] [z.B. Prometheus + Grafana Dashboards]
- [ ] [Loki für zentrales Logging]

## Security-Entscheidungen

<!-- Dieser Abschnitt ist für eine Security-Engineer-Bewerbung der wichtigste Teil.
     Nicht nur WAS du gemacht hast, sondern WARUM. -->

| Entscheidung | Begründung |
|---|---|
| [z.B. SSH nur mit Public-Key] | [z.B. verhindert Brute-Force auf Passwörter] |
| [z.B. Container laufen nie als root] | [z.B. begrenzt Schaden bei Container-Escape] |
| [z.B. Secrets in .tfvars statt im Code] | [z.B. verhindert versehentliches Commit von Zugangsdaten] |
| [...] | [...] |

## Angriffssimulation

[Falls umgesetzt: welche verwundbare App wurde getestet, welche Angriffe simuliert, wurden sie im Monitoring erkannt?]

## Lessons Learned

- [Was hat nicht auf Anhieb funktioniert?]
- [Was würdest du beim nächsten Mal anders machen?]
- [Welches Konzept hat "Klick" gemacht?]

## Screenshots

<!-- z.B. Grafana-Dashboard, terraform plan-Output, kubectl get pods -->
![Screenshot 1](docs/screenshot1.png)

## Setup / Nachbauen

```bash
# Kurzanleitung, falls jemand das Projekt nachbauen will
git clone [dein-repo-link]
cd [projektname]
# ...
```

## Nächste Schritte

- [ ] [Was ist noch geplant / ausbaufähig?]

---

**Kontakt:** [dein Name / LinkedIn / GitHub-Profil-Link]
