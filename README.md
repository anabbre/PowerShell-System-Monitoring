# PowerShell System Monitoring

Este script de PowerShell monitorea el uso de los recursos del sistema (CPU, RAM y espacio en disco) y envía alertas por correo electrónico si alguno de los umbrales establecidos se supera.

## Características:
- Monitorea el uso de CPU, RAM y espacio en disco.
- Envía alertas por correo electrónico si se superan los umbrales.
- Guarda un reporte detallado en formato CSV.

## Requisitos:
- PowerShell 5.1 o superior.
- Un servidor SMTP para enviar correos (por ejemplo, Gmail).
- Conexión a internet para enviar alertas por correo.

## Instalación:
1. Clona el repositorio:
   ```bash
   git clone git clone https://github.com/anabbre/PowerShell-System-Monitoring.git





# Automización Azure PowerShell y Terraform

Este proyecto contiene un script en PowerShell para la automatización de la creación de máquinas virtuales y redes virtuales en Azure. El script está diseñado para ayudar en la gestión de recursos de Azure y permitir a los usuarios crear infraestructuras en la nube de manera eficiente. 


El archivo principal del script es [automizacion_azure.ps1](./automizacion_azure.ps1).  

## Tecnologías utilizadas:  
- Powershell
- Terraform
- Azure
  
  
## Requisitos:

- Tener una suscripción activa en Azure.
- Tener instalado PowerShell 7.x o superior.
- Tener el módulo Az para PowerShell instalado.
- Tener instalado Terraform en tu máquina.
- Tener configurada la cuenta de Azure con el comando 'az login'.
  
  

## Uso de PowerShell (automatización con PowerShell)

### 1. Abre PowerShell con privilegios de administrador.
### 2. Conéctate a tu cuenta de Azure:
```
Connect-AzAccount
```
### 3. Ejecuta el script para crear el grupo de recursos, la red virtual, la subred y la máquina virutal:
```
.\automatizacion_azure.ps1
```

### El script creará lo siguiente:

- Un **grupo de recursos**.
- Una **red virtual** con una **subred**.
- Una **máquina virtual de Windows**.

![image](https://github.com/user-attachments/assets/55c12f54-43a6-4ae7-baab-064934a1c5a3)
  



![image](https://github.com/user-attachments/assets/af71e16f-d7e4-497d-a07c-2d54ac81e107)  




![image](https://github.com/user-attachments/assets/feee644e-4289-41fc-adbf-c94536a59661)




![image](https://github.com/user-attachments/assets/fde64924-286d-4717-8dd6-8ffca645cb39)  


## Uso de Terraform (automatización en Terraform)  

### 1. Inicializar el entorno de Terraform  
Abre una terminal y navega hasta el directorio donde se encunetra el archivo 'main.tf'. Luego, ejecuta el siguiente comando para inicializar Terraform:  
```
terraform init
```
### 2. Verificar el plan de ejecución  
Antes de aplicar cualquier cambio, es recomendable ver lo que Terraform planea hacer. Ejecuta:  
```
terraform plan
```
Esto te mostrará una lista de los recursos que serán creados, modificados o destruidos en Azure.  
### 3. Aplicar el plan  
Una vez que revises el plan, puedes ejecutar el siguiente comando para aplicar los cambios:  
```
terraform apply
```
Terraform te pedirá confirmación para proceder. Escribe yes y presiona enter.    
![image](https://github.com/user-attachments/assets/7ee21779-ca6b-4d89-bfba-e6327a173e8e)


### El scritp de Terraform creará los siguientes recursos:  

- Un **grupo de recursos**.
- Una **red virtual** con una **subred**.
- Una **máquina virtual de Windows**.
![image](https://github.com/user-attachments/assets/5f1c4eb6-c521-40d8-951d-b5f3604c01a8)

![image](https://github.com/user-attachments/assets/06bfd41c-172c-4f21-934d-7bda8a69a4ae)
  

![image](https://github.com/user-attachments/assets/804832e8-aa23-461d-807c-ac3fdf2998cf)



## Conclusión
Este proyecto proporciona una forma rápida de crear y gestionar infraestructura en Azure mediante PowerShell y Terraform. Puedes mejorar este proyecto añadiendo más recursos de Azure según sea necesario.

Si tienes alguna pregunta o sugerencia, no dudes en abrir un **issue** o contactar conmigo.

  





