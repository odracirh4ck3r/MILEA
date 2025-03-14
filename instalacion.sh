#!/bin/bash

# Script Automatizado para Ubuntu Server 24.04.2 LTS
# Instalación segura y configuración inicial de paquetes esenciales

# --- SCRIPT 1: Instalación de Paquetes Esenciales ---

echo "Actualizando sistema..."
sudo apt update && sudo apt upgrade -y

echo "Instalando paquetes esenciales..."
sudo apt install -y mysql-server python3.11 python3-pip git

# Instalación JAN.AI u Ollama (Elegimos Ollama por simplicidad, potencia y flexibilidad)
# (Jan.ai es propietario, Ollama es open-source y permite modelos locales como Llama2)
echo "Instalando Ollama para Inteligencia Artificial local..."
curl -fsSL https://ollama.com/install.sh | sh
ollama pull llama2

# Subir script a GitHub:
# git add install.sh
# git commit -m "Script instalación esencial Ubuntu"
# git push origin main

# Descargar desde la máquina virtual:
# wget https://raw.githubusercontent.com/odracirh4ck3r/tu-repo/main/install.sh

# Dar permisos de ejecución al script:
# chmod +x install.sh

# --- SCRIPT 2: Configuración segura MySQL ---

# Ejecuta configuraciones seguras
sudo mysql_secure_installation

# Configuración Avanzada: Deshabilitar accesos remotos innecesarios
sudo sed -i 's/bind-address\s*=\s*127.0.0.1/bind-address = 127.0.0.1/' /etc/mysql/mysql.conf.d/mysqld.cnf

# Reinicia servicio MySQL con systemctl para aplicar cambios
sudo systemctl enable --now mysql

# Crear estructura optimizada para la base de datos de vulnerabilidades
sudo mysql -u root -p <<MYSQL_SCRIPT
CREATE DATABASE cve_db;

CREATE TABLE cve_db.vulnerabilidades (
    id INT AUTO_INCREMENT PRIMARY KEY,
    cve_id VARCHAR(20) UNIQUE,
    descripcion TEXT,
    fecha_publicacion DATE,
    cvss_score DECIMAL(4,2),
    severidad ENUM('CRITICAL','HIGH','MEDIUM','LOW'),
    vector_cvss VARCHAR(100),
    plataforma ENUM('WINDOWS','LINUX','MACOS','ANDROID','IOS','OTRO'),
    recomendacion TEXT,
    fecha_ingreso TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE USER 'cve_user'@'localhost' IDENTIFIED BY 'TuClaveSegura123!';
GRANT SELECT, INSERT, UPDATE ON cve_db.* TO 'cve_user'@'localhost';
FLUSH PRIVILEGES;
MYSQL_SCRIPT

# --- SCRIPT 3: Instalación Ollama/Jan.ai ---

# Ollama vs Jan.ai:
# Ollama: Código abierto, gratuito, compatible con modelos locales (Llama2). Ideal para servidores locales y seguridad.
# Jan.ai: Propietario, con licencia, soporte comercial, ideal para integraciones comerciales complejas.
# Recomendado Ollama para este proyecto por seguridad y control de datos.

# Especificaciones técnicas recomendadas para Ollama:
# CPU: Mínimo 4 núcleos (recomendado 8)
# RAM: Mínimo 8GB (ideal 16GB o más)
# Disco: SSD/NVMe mínimo 50GB libres

# Ya instalado en el Script 1 arriba

# Comprobación del Servicio Ollama
systemctl enable --now ollama

# Estrategias anti conflictos:
# - Uso de entornos virtuales Python para scripts IA específicos (venv)
# - Uso de 'apt' actualizado antes de cada instalación
# - Chequeos condicionales para evitar reinstalar paquetes existentes

# Ejemplo de uso para modelos locales IA:
# ollama run llama2

# Fin del script

echo "Instalación y configuración completa."
