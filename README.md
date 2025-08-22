# Virtuelle Tastatur für Passwörter (PowerShell POC)

Dieses Projekt ist ein **Proof-of-Concept PowerShell-Skript**, das die Eingabe von Passwörtern in Umgebungen erleichtert, in denen **Copy & Paste deaktiviert** ist – z. B. bei Web-VNC-Verbindungen. Das Skript simuliert die Tastatureingabe, sodass lange und komplexe Passwörter nicht manuell eingetippt werden müssen.

⚠️ **Hinweis:** Dieses Projekt ist kein ausgereiftes Produkt, sondern ein funktionales POC. Der Fokus liegt auf **Einfachheit und Zweckmäßigkeit**, nicht auf Design oder Funktionsvielfalt.

## Motivation

* Viele Remote-Umgebungen (z. B. Web-VNC im Browser) erlauben kein Copy & Paste.
* Lange und sichere Passwörter manuell einzutippen ist fehleranfällig und mühsam.
* Dieses Skript löst das Problem, indem gespeicherte oder eingefügte Passwörter automatisch über eine virtuelle Tastatureingabe eingegeben werden.

## Systemvoraussetzungen

* **PowerShell:** Version 5.1 oder höher
* Windows-Betriebssystem (für die Tastatur-Simulation)

## Nutzung

### Standard-Workflow für eingefügte Passwörter:

1. **Starten** Sie das Skript (`.ps1`) mit PowerShell.

2. **⚠️ WICHTIG: Fügen Sie zuerst das Passwort ein und laden Sie es:**
   - Kopieren Sie Ihr Passwort aus einem Passwort-Manager
   - Fügen Sie es in das obere Textfeld ein (Strg+V)
   - Klicken Sie auf **„Passwort laden"**
   - Das Passwort wird nun in der Liste angezeigt

3. **Wählen Sie erst jetzt** den gewünschten Eintrag in der Liste aus.

4. Klicken Sie auf **„Passwort eingeben"** und wechseln Sie innerhalb von 2 Sekunden in das Ziel-Eingabefeld (z. B. im VNC-Login).

5. Das Passwort wird automatisch getippt.

> **💡 Tipp:** Die Reihenfolge ist wichtig! Erst einfügen → dann laden → dann auswählen → dann eingeben.

### Für gespeicherte Passwörter:

1. Wählen Sie einen bereits gespeicherten Eintrag aus der Liste.
2. Klicken Sie auf **„Passwort eingeben"**.
3. Wechseln Sie innerhalb von 2 Sekunden zum Ziel-Eingabefeld.

## Passwort-Verwaltung

Es gibt zwei Möglichkeiten, mit Passwörtern zu arbeiten:

### 1. **Empfohlene Variante (sicherer):**
* Speichern Sie Ihre Passwörter in einem **dedizierten Passwort-Manager** (z. B. KeePass, Bitwarden, 1Password).
* Kopieren Sie das Passwort bei Bedarf in das Skript (per Copy & Paste) und nutzen Sie die Eingabefunktion.
* Vorteil: Das Passwort verbleibt nicht dauerhaft in einer Datei.

### 2. **Alternative Variante (integrierte Speicherung):**
* Das Skript bietet die Möglichkeit, Passwörter im Textformat zu speichern.
* Dies ist **weniger sicher**, da die Passwörter im Klartext in einer Datei hinterlegt werden.
* Nutzen Sie diese Option nur für Testzwecke oder in geschützten Umgebungen.

