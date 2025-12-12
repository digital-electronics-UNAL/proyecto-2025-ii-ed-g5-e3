[![Open in Visual Studio Code](https://classroom.github.com/assets/open-in-vscode-2e0aaae1b6195c2367325f4f02e2d04e9abb55f0b24a779b69b11b9e10269abc.svg)](https://classroom.github.com/online_ide?assignment_repo_id=21718021&assignment_repo_type=AssignmentRepo)
# Proyecto final - Electrónica Digital 1 - 2025-II

# Integrantes
[Johan Arturo Barajas Herrera](https://github.com/jbarajash-desing)<br>
[Edwar Camilo Torres Carrillo](https://github.com/camiu026)<br>
[Kevin Gustavo Castro Sanchez](https://github.com/KevinCastroUnal)
# Nombre del proyecto
**Impresora Portátil - Print’n Roll**
# Documentación

## Descripción de la arquitectura
El proyecto consiste en el desarrollo del hardware para controlar un cabezal térmico comercial (**JX-2R-17**) mediante una FPGA, diseñado para impresión en blanco y negro recibiendo datos vía Bluetooth.

**Características principales:**
* **Alimentación:** Batería de 3.7V con módulo de carga USB-C.
* **Control del Motor:** Driver **DRV8833** para el motor paso a paso del cabezal (paso de 9°, corriente máx 0.357A).
* **Comunicación:** Módulo Bluetooth configurado en modo recepción (Rx) para transmitir la imagen a la FPGA.
* **Lógica de Control:** El cabezal no utiliza un protocolo de comunicación estándar. Se implementó un protocolo de control físico que gestiona:
    1.  Carga de datos seriales a un *Shift Register*.
    2.  Latch de datos para almacenamiento temporal.
    3.  Activación de resistencias térmicas (Strobe) por grupos de 64 puntos para limitar el consumo de corriente.

**Módulos Verilog implementados:**
* `RETO`: Módulo Top que integra el sistema.
* `Rx`: Filtrado y recepción de datos Bluetooth (Hex a Binario).
* `Sigma (enviandoDatos)`: Gestión de salida de datos (`DO`) y reloj de alta velocidad hacia el cabezal.
* `Latch-Strobe`: Generación de señales de control para "quemar" los puntos en el papel.
* `MoverMotor`: Lógica de avance del papel sincronizada con la impresión, incluyendo un submódulo `PWM` para el control de potencia.

## Diagramas de la arquitectura

### 1. Circuito General
Diseño de interconexión entre batería, FPGA, Driver y Cabezal.
![Circuito Diseñado](imagenes/Untitled.jpg)

### 2. Lógica Interna del Cabezal
Esquema de funcionamiento del registro de desplazamiento y compuertas de calentamiento.
![Trama de Datos](tramadeDatos.png)

### 3. Diagrama de Módulos FPGA
Arquitectura de hardware descrita en Verilog.
![Módulos FPGA](Untitled(1).png)

### 4. Señales de Control (Esperado)
Diagrama de tiempos para las señales Latch y Strobe.
![Señal Latch Strobe](imagenes/DatalatchStrobe.png)

## Simulaciones
Se realizaron pruebas de simulación para validar la lógica antes de la síntesis:

* **Resultados Positivos:** Los módulos `Rx` y `MoverMotor` funcionaron correctamente, validando la recepción de datos y la secuencia de fases del motor (A, A', B, B').
* **Resultados Parciales:** Los módulos `Sigma` y `Latch` presentaron desafíos. Aunque la lógica teórica del diagrama de tiempos es correcta, surgieron dificultades en la síntesis relacionadas con el manejo simultáneo de registros en múltiples bloques `always`, lo que requirió ajustes respecto a la simulación ideal.

## Evidencias de implementación
El sistema fue montado sobre una **PCB diseñada a medida** que integra:
* Alimentación y carga.
* Conexión al Driver del motor y Módulo Bluetooth.
* Interfaz con el cabezal térmico.

**Estado final:**
Se logró controlar el motor para el avance de papel y establecer conexión Bluetooth. Sin embargo, la calidad de impresión final se vio afectada por ruido eléctrico en la PCB y la complejidad de sincronización en tiempo real de los módulos de control térmico (`Sigma`), dejando como lección la importancia de la integridad de señal en el diseño de hardware de potencia.

