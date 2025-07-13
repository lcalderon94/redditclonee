# 🪟 Windows Setup - Reddit Clone Eureka Server

## 📋 Paso a Paso para Windows

### 1. Preparar el Entorno

**Java 17+**
```cmd
# Descargar e instalar Java 17+ desde:
# https://adoptium.net/

# Verificar instalación
java -version
```

**Docker Desktop (Opcional)**
```cmd
# Descargar desde: https://www.docker.com/products/docker-desktop/
# Solo necesario si quieres usar Docker
```

### 2. Crear la Estructura del Proyecto

**Crear carpetas**
```cmd
mkdir reddit-clone-eureka-server
cd reddit-clone-eureka-server
mkdir src\main\java\com\redditclone\eureka
mkdir src\main\resources
mkdir .mvn\wrapper
```

### 3. Crear los Archivos (en este orden)

**Archivos principales:**
1. ✅ `pom.xml` (raíz)
2. ✅ `mvnw.cmd` (raíz) - **USAR VERSIÓN WINDOWS**
3. ✅ `run.bat` (raíz) - **USAR VERSIÓN WINDOWS**
4. ✅ `setup.bat` (raíz) - **NUEVO PARA WINDOWS**

**Configuración:**
5. ✅ `.mvn\wrapper\maven-wrapper.properties`
6. ✅ `src\main\resources\application.yml`

**Código fuente:**
7. ✅ `src\main\java\com\redditclone\eureka\EurekaServerApplication.java`

**Docker (opcional):**
8. ✅ `Dockerfile`
9. ✅ `docker-compose.yml`

**Documentación:**
10. ✅ `.gitignore`
11. ✅ `README.md`

### 4. Verificar Setup

**Ejecutar script de verificación**
```cmd
setup.bat
```

### 5. Ejecutar la Aplicación

**Opción 1: Local (Recomendado para desarrollo)**
```cmd
run.bat start
```

**Opción 2: Docker**
```cmd
run.bat docker
```

### 6. Verificar que Funciona

**Comando de verificación**
```cmd
run.bat health
```

**Acceso manual:**
- Abrir navegador: http://localhost:8761
- Usuario: `admin`
- Contraseña: `admin123`

## 🔧 Comandos Disponibles (Windows)

```cmd
run.bat start    # Iniciar servidor localmente
run.bat docker   # Iniciar con Docker
run.bat build    # Compilar aplicación
run.bat test     # Ejecutar tests
run.bat clean    # Limpiar archivos temporales
run.bat health   # Verificar que funciona
run.bat help     # Mostrar ayuda
```

## ❗ Errores Comunes en Windows

### Error: Java no encontrado
```cmd
# Verificar instalación
java -version

# Si no funciona, agregar Java al PATH:
# Panel de Control > Sistema > Variables de entorno
# Agregar: C:\Program Files\Eclipse Adoptium\jdk-17.x.x-hotspot\bin
```

### Error: Puerto 8761 en uso
```cmd
# Ver qué está usando el puerto
netstat -ano | findstr 8761

# Matar proceso
taskkill /F /PID <numero_de_proceso>
```

### Error: Docker no encontrado
```cmd
# Instalar Docker Desktop
# O ejecutar sin Docker:
run.bat start
```

### Error: mvnw.cmd no funciona
```cmd
# Verificar que el archivo existe
dir mvnw.cmd

# Si no existe, asegúrate de usar la versión para Windows
```

## ✅ Checklist Final

- [ ] Java 17+ instalado y en PATH
- [ ] Estructura de carpetas creada
- [ ] Todos los archivos copiados en sus ubicaciones
- [ ] `setup.bat` ejecutado sin errores
- [ ] `run.bat start` funciona
- [ ] http://localhost:8761 carga correctamente
- [ ] Login con admin/admin123 funciona

## 🎯 Siguiente Paso

Una vez que Eureka Server funcione correctamente:
- ✅ **Eureka Server** - ¡Completado!
- ⏭️ **API Gateway** - Siguiente en desarrollo

¡Ya tienes el Service Discovery funcionando en Windows! 🎉