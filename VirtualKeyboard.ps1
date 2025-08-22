# VirtualKeyboard.ps1
# Ein PowerShell-Skript für eine virtuelle Tastatur, um gespeicherte Passwörter einzugeben

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# Funktion zum Senden von Tastatureingaben
function Send-Keys {
    param (
        [string]$text
    )
    
    # Kurze Verzögerung, um zum Zielfeld zu wechseln
    Start-Sleep -Milliseconds 2000
    
    # Sende die Zeichen einzeln, um spezielle Zeichen korrekt zu behandeln
    foreach ($char in $text.ToCharArray()) {
        [System.Windows.Forms.SendKeys]::SendWait($char)
        Start-Sleep -Milliseconds 50  # Kleine Verzögerung zwischen den Zeichen
    }
}

# Hauptfenster erstellen
$form = New-Object System.Windows.Forms.Form
$form.Text = "Virtuelle Tastatur für Passwörter"
$form.Size = New-Object System.Drawing.Size(600, 400)
$form.StartPosition = "CenterScreen"
$form.FormBorderStyle = "FixedDialog"
$form.MaximizeBox = $false

# Benutzerdefinierte Passwörter Textbox
$passwordsLabel = New-Object System.Windows.Forms.Label
$passwordsLabel.Text = "Gespeicherte Passwörter:"
$passwordsLabel.Location = New-Object System.Drawing.Point(20, 20)
$passwordsLabel.Size = New-Object System.Drawing.Size(200, 20)
$form.Controls.Add($passwordsLabel)

$passwordsTextbox = New-Object System.Windows.Forms.TextBox
$passwordsTextbox.Multiline = $true
$passwordsTextbox.Location = New-Object System.Drawing.Point(20, 50)
$passwordsTextbox.Size = New-Object System.Drawing.Size(540, 100)
$passwordsTextbox.ScrollBars = "Vertical"
$passwordsTextbox.Text = "# Speichere deine Passwörter hier im Format: `r`n# Beschreibung=Passwort `r`nMein Email=Beispiel123! `r`nMein Banking=BeispielPasswort456!"
$form.Controls.Add($passwordsTextbox)

# Passwortliste laden
$passwordListBox = New-Object System.Windows.Forms.ListBox
$passwordListBox.Location = New-Object System.Drawing.Point(20, 170)
$passwordListBox.Size = New-Object System.Drawing.Size(400, 150)
$form.Controls.Add($passwordListBox)

# Hilfstext
$helpLabel = New-Object System.Windows.Forms.Label
$helpLabel.Text = "Klicke auf einen Eintrag und dann auf 'Passwort eingeben'. Wechsle dann zum Zielfeld innerhalb von 2 Sekunden."
$helpLabel.Location = New-Object System.Drawing.Point(20, 330)
$helpLabel.Size = New-Object System.Drawing.Size(540, 20)
$form.Controls.Add($helpLabel)

# Schaltfläche zum Laden der Passwörter
$loadButton = New-Object System.Windows.Forms.Button
$loadButton.Location = New-Object System.Drawing.Point(440, 170)
$loadButton.Size = New-Object System.Drawing.Size(120, 30)
$loadButton.Text = "Passwörter laden"
$loadButton.Add_Click({
    $passwordListBox.Items.Clear()
    
    foreach ($line in $passwordsTextbox.Text -split "`r`n") {
        if (-not $line.StartsWith("#") -and $line.Contains("=")) {
            $description = $line.Split("=")[0].Trim()
            $passwordListBox.Items.Add($description)
        }
    }
})
$form.Controls.Add($loadButton)

# Schaltfläche zum Eingeben des Passworts
$inputButton = New-Object System.Windows.Forms.Button
$inputButton.Location = New-Object System.Drawing.Point(440, 220)
$inputButton.Size = New-Object System.Drawing.Size(120, 30)
$inputButton.Text = "Passwort eingeben"
$inputButton.Add_Click({
    if ($passwordListBox.SelectedItem) {
        $selectedDescription = $passwordListBox.SelectedItem.ToString()
        
        foreach ($line in $passwordsTextbox.Text -split "`r`n") {
            if ($line.StartsWith("$selectedDescription=")) {
                $password = $line.Substring($selectedDescription.Length + 1)
                
                # Hinweis anzeigen
                $messageForm = New-Object System.Windows.Forms.Form
                $messageForm.Text = "Bereit"
                $messageForm.Size = New-Object System.Drawing.Size(300, 150)
                $messageForm.StartPosition = "CenterScreen"
                $messageForm.TopMost = $true
                
                $messageLabel = New-Object System.Windows.Forms.Label
                $messageLabel.Text = "Klicke in das Zielfeld innerhalb von 2 Sekunden!"
                $messageLabel.Location = New-Object System.Drawing.Point(30, 30)
                $messageLabel.Size = New-Object System.Drawing.Size(240, 40)
                $messageForm.Controls.Add($messageLabel)
                
                $messageForm.Show()
                
                # Passwort eingeben
                Send-Keys -text $password
                
                $messageForm.Close()
                break
            }
        }
    }
    else {
        [System.Windows.Forms.MessageBox]::Show("Bitte wähle zuerst ein Passwort aus der Liste aus.")
    }
})
$form.Controls.Add($inputButton)

# Schaltfläche zum Speichern der Passwörter in einer Datei
$saveButton = New-Object System.Windows.Forms.Button
$saveButton.Location = New-Object System.Drawing.Point(440, 270)
$saveButton.Size = New-Object System.Drawing.Size(120, 30)
$saveButton.Text = "Speichern"
$saveButton.Add_Click({
    $saveDialog = New-Object System.Windows.Forms.SaveFileDialog
    $saveDialog.Filter = "Textdateien (*.txt)|*.txt|Alle Dateien (*.*)|*.*"
    $saveDialog.DefaultExt = "txt"
    $saveDialog.AddExtension = $true
    
    if ($saveDialog.ShowDialog() -eq [System.Windows.Forms.DialogResult]::OK) {
        [System.IO.File]::WriteAllText($saveDialog.FileName, $passwordsTextbox.Text)
        [System.Windows.Forms.MessageBox]::Show("Passwörter wurden gespeichert.")
    }
})
$form.Controls.Add($saveButton)

# Schaltfläche zum Laden der Passwörter aus einer Datei
$openButton = New-Object System.Windows.Forms.Button
$openButton.Location = New-Object System.Drawing.Point(440, 320)
$openButton.Size = New-Object System.Drawing.Size(120, 30)
$openButton.Text = "Datei öffnen"
$openButton.Add_Click({
    $openDialog = New-Object System.Windows.Forms.OpenFileDialog
    $openDialog.Filter = "Textdateien (*.txt)|*.txt|Alle Dateien (*.*)|*.*"
    
    if ($openDialog.ShowDialog() -eq [System.Windows.Forms.DialogResult]::OK) {
        $passwordsTextbox.Text = [System.IO.File]::ReadAllText($openDialog.FileName)
        [System.Windows.Forms.MessageBox]::Show("Passwörter wurden geladen.")
    }
})
$form.Controls.Add($openButton)

# Lade die Passwörter initial
$loadButton.PerformClick()

# Formular anzeigen
$form.ShowDialog()