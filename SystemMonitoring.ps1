# Monitoreo de uso de recursos del sistema
$cpuThreshold = 80  # Umbral de uso de CPU (en %)
$ramThreshold = 80  # Umbral de uso de RAM (en %)
$diskThreshold = 80 # Umbral de uso de disco (en %)

# Obtener información del sistema
$cpuUsage = Get-WmiObject -Class Win32_Processor | Select-Object -ExpandProperty LoadPercentage
$ramUsage = Get-WmiObject -Class Win32_OperatingSystem | Select-Object @{Name="TotalVisibleMemorySize";Expression={[math]::round($_.TotalVisibleMemorySize / 1MB)}}, @{Name="FreePhysicalMemory";Expression={[math]::round($_.FreePhysicalMemory / 1MB)}}
$ramUsagePercentage = [math]::round(($ramUsage.TotalVisibleMemorySize - $ramUsage.FreePhysicalMemory) / $ramUsage.TotalVisibleMemorySize * 100)

# Obtener espacio libre en disco y manejar múltiples discos
$diskUsage = Get-WmiObject -Class Win32_LogicalDisk -Filter "DriveType=3" | Select-Object -ExpandProperty FreeSpace

# Si hay múltiples discos, tomamos el valor del primero
$diskUsageGB = [math]::round($diskUsage[0] / 1GB, 2)

# Verifica si los recursos superan los umbrales
$alertMessage = ""
if ($cpuUsage -gt $cpuThreshold) {
    $alertMessage += "Alerta: Uso de CPU superior al umbral de $cpuThreshold% - $cpuUsage%`n"
}

if ($ramUsagePercentage -gt $ramThreshold) {
    $alertMessage += "Alerta: Uso de RAM superior al umbral de $ramThreshold% - $ramUsagePercentage%`n"
}

if ($diskUsageGB -lt 10) {  # Comprobamos que el espacio en disco esté por debajo de 10 GB
    $alertMessage += "Alerta: Espacio en disco inferior al umbral de 10GB`n"
}

# Guardar el reporte en un archivo CSV
$report = [PSCustomObject]@{
    CPU_Usage = $cpuUsage
    RAM_Usage_Percentage = $ramUsagePercentage
    Disk_Space_Left_GB = $diskUsageGB
    Alert_Message = $alertMessage
}
$report | Export-Csv -Path "C:\Reports\SystemResourcesReport.csv" -NoTypeInformation

# Enviar el reporte por correo si se detecta alguna alerta
if ($alertMessage) {
    $smtpServer = "smtp.gmail.com"
    $smtpFrom = "anabbresys@gmail.com"
    $smtpTo = "anabbresys@gmail.com"
    $smtpSubject = "Alerta de Monitoreo de Sistema"
    $smtpBody = "Se han detectado alertas en el monitoreo de recursos del sistema:`n`n$alertMessage"

    $smtp = New-Object System.Net.Mail.SmtpClient($smtpServer, 587)  # Puerto 587 para TLS
    $smtp.EnableSsl = $true  # Habilita la conexión segura TLS
    $smtp.Credentials = New-Object System.Net.NetworkCredential("anabbresys@gmail.com", "ertd dxpf jhoe zhgj")
    $smtp.Send($smtpFrom, $smtpTo, $smtpSubject, $smtpBody)

}
