# -----------------------------------------
# PASO 1: CONEXIÓN A AZURE
# -----------------------------------------

# Iniciar sesión en Azure
Connect-AzAccount

# Seleccionar la suscripción (asegúrate de que sea la correcta)
Set-AzContext -Subscription "Azure subscription 1"

# -----------------------------------------
# PASO 2: CONFIGURAR PARÁMETROS
# -----------------------------------------

# Grupo de recursos
$rgName = "GrupoRecursosAna"  # Nombre personalizable
$location = "EastUS"           # Región gratuita (EastUS, WestUS, NorthEurope)

# Red virtual y subred
$vnetName = "RedVirtualAna"
$subnetName = "SubredAna"

# Interfaz de red
$nicName = "TarjetaRedAna"

# Máquina virtual
$vmName = "VM-Ana"            # Nombre de la VM
$vmSize = "Standard_B1s"      # Tamaño gratuito (1 vCPU, 1 GB RAM)

# Credenciales
$adminUser = "anabbre"        # Nombre de usuario para acceder a la VM
$password = ConvertTo-SecureString "Mzyq2311....A" -AsPlainText -Force
$cred = New-Object System.Management.Automation.PSCredential ($adminUser, $password)

# -----------------------------------------
# PASO 3: CREAR GRUPO DE RECURSOS
# -----------------------------------------

New-AzResourceGroup -Name $rgName -Location $location

# -----------------------------------------
# PASO 4: CREAR RED VIRTUAL Y SUBRED
# -----------------------------------------

# Crear red virtual
$vnet = New-AzVirtualNetwork `
  -Name $vnetName `
  -ResourceGroupName $rgName `
  -Location $location `
  -AddressPrefix "10.0.0.0/16"

# Añadir subred
$subnetConfig = Add-AzVirtualNetworkSubnetConfig `
  -Name $subnetName `
  -AddressPrefix "10.0.0.0/24" `
  -VirtualNetwork $vnet

# Actualizar la red virtual
$vnet | Set-AzVirtualNetwork

# -----------------------------------------
# PASO 5: CREAR INTERFAZ DE RED (NIC)
# -----------------------------------------

# Obtener ID de la subred
$subnetId = (Get-AzVirtualNetwork -Name $vnetName -ResourceGroupName $rgName).Subnets[0].Id

# Crear NIC
$nic = New-AzNetworkInterface `
  -Name $nicName `
  -ResourceGroupName $rgName `
  -Location $location `
  -SubnetId $subnetId

# -----------------------------------------
# PASO 6: CONFIGURAR LA MÁQUINA VIRTUAL
# -----------------------------------------

# Configurar la VM
$vmConfig = New-AzVMConfig `
  -VMName $vmName `
  -VMSize $vmSize | `
  Set-AzVMOperatingSystem `
    -Windows `
    -ComputerName $vmName `
    -Credential $cred | `
  Set-AzVMSourceImage `
    -PublisherName "MicrosoftWindowsServer" `
    -Offer "WindowsServer" `
    -Skus "2019-Datacenter" `
    -Version "latest" | `
  Add-AzVMNetworkInterface `
    -Id $nic.Id

# -----------------------------------------
# PASO 7: CREAR LA MÁQUINA VIRTUAL
# -----------------------------------------

New-AzVM `
  -ResourceGroupName $rgName `
  -Location $location `
  -VM $vmConfig

# -----------------------------------------
# PASO 8: VERIFICAR EN AZURE PORTAL
# -----------------------------------------

# Abrir Azure Portal en el navegador
Start-Process "https://portal.azure.com"

Write-Host "¡VM creada correctamente! Verifica en Azure Portal." -ForegroundColor Green

# -----------------------------------------
# PASO 9: CREAR DIRECCIÓN IP PÚBLICA
# -----------------------------------------

# Crear dirección IP pública estática
$publicIp = New-AzPublicIpAddress `
  -Name "IPPublica-VMAna" `
  -ResourceGroupName $rgName `
  -Location $location `
  -AllocationMethod Static  # Cambiado a Static

# Asignar la IP pública a la interfaz de red
$nic = Get-AzNetworkInterface -Name $nicName -ResourceGroupName $rgName
$nic.IpConfigurations[0].PublicIpAddress = $publicIp
$nic | Set-AzNetworkInterface

# Obtener la IP pública de tu VM
$publicIp = Get-AzPublicIpAddress -Name "IPPublica-VMAna" -ResourceGroupName $rgName
Write-Host "Dirección IP pública: $($publicIp.IpAddress)"

# -----------------------------------------
# PASO 10: CREAR REGLA DE SEGURIDAD PARA RDP
# -----------------------------------------

# Crear grupo de seguridad de red (NSG)
$nsg = New-AzNetworkSecurityGroup `
  -Name "NSG-VMAna" `
  -ResourceGroupName $rgName `
  -Location $location

# Crear regla de seguridad para RDP
$nsg | Add-AzNetworkSecurityRuleConfig `
  -Name "Permitir-RDP" `
  -Access Allow `
  -Protocol Tcp `
  -Direction Inbound `
  -Priority 100 `
  -SourceAddressPrefix * `
  -SourcePortRange * `
  -DestinationAddressPrefix * `
  -DestinationPortRange 3389 | `
  Set-AzNetworkSecurityGroup

# Asociar el NSG a la subred
$vnet = Get-AzVirtualNetwork -Name $vnetName -ResourceGroupName $rgName
Set-AzVirtualNetworkSubnetConfig `
  -VirtualNetwork $vnet `
  -Name $subnetName `
  -AddressPrefix "10.0.0.0/24" `
  -NetworkSecurityGroup $nsg | `
  Set-AzVirtualNetwork
