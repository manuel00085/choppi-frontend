# 🧩 README – Choppi App (Frontend Flutter)

##  Aplicación Móvil – Flutter  
Proyecto frontend desarrollado como parte de la **Prueba Técnica Full-stack Engineer — Choppi**.  
La aplicación permite gestionar tiendas, productos, autenticación y carrito, siguiendo buenas prácticas y arquitectura modular.

---

#  Tecnologías utilizadas

- **Flutter 3.x**
- **Dart**
- **BLoC / Cubit**
- **Dio**
- **Secure Storage**
- **Arquitectura Feature-Driven**
- **Railway**
- **Material Design 3**

---

#  Arquitectura

El proyecto sigue **Feature-Driven Architecture**, organizada por módulos:

```
lib/
 ├── core/
 │     ├── dio/
 │     ├── storage/
 │     ├── app_notifier.dart
 │     └── app_loading.dart
 │
 ├── features/
 │     ├── auth/
 │     ├── stores/
 │     ├── products/
 │     ├── cart/
 │
 └── main.dart
```

---

#  Autenticación

- Login con email/contraseña  
- Token JWT en SecureStorage  
- Interceptor automático  
- Pantalla AuthGate  
- Manejo global de errores  

---

#  Tiendas

- Lista de tiendas  
- Buscador  
- Paginación con infinite scroll  
- Cards visuales  
- Navegación a detalles  

---

#  Detalle de Tienda

- Lista de productos  
- Buscador  
- Filtro de disponibilidad  
- Navegación a producto  

---

#  Detalle de Producto

- Imagen  
- Categoría  
- Descripción  
- Precio y stock  
- Botón fijo “Agregar al carrito”  

---

#  Carrito (Local)

- Manejado con Cubit  
- Añadir/quitar productos  
- Calcular total  
- Vista de carrito  

---

#  Manejo de errores

- Snackbars globales  
- Loading modal  
- Interceptores Dio  
- Manejo de timeouts  

---

#  Conexión Backend

Base URL:  

```
https://choppi-backend-production-4818.up.railway.app
```

Endpoints usados:
- /auth/login  
- /stores  
- /stores/:id/products  
- /products/:id  

---

#  Instalación y ejecución

### 1. Instalar dependencias
```
flutter pub get
```

### 2. Ejecutar en debug
```
flutter run
```

### 3. Ejecutar en dispositivo físico
```
flutter devices
flutter run -d <device_id>
```

### 4. Generar APK Release
```
flutter build apk --release
```

APK generado en:

```
build/app/outputs/flutter-apk/app-release.apk
```

---

# 🔧 Configuración importante

### Permiso de internet

```xml
<uses-permission android:name="android.permission.INTERNET" />
```

### Cleartext + Network Security

```xml
android:usesCleartextTraffic="true"
android:networkSecurityConfig="@xml/network_security_config"
```

---


