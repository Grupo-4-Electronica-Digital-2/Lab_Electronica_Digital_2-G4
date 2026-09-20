# Laboratorio 00: Introducción a Verilog, Simulación y Máquinas de Estados Finitos (FSM) 
## Introducción a Verilog, Simulación y Máquinas de Estados Finitos (FSM)

Maquinas de estado 
Codigo comentado / explicaciones 
Pantallazo GTK Wave 
Bonus el ASM y lo que pasa con las variables 
---

## Integrantes

- Andres Felipe Castro Lopez – 1014298415
- Juan Pablo Castañeda Moncada - 1000851451
- Nombre completo – DNI

Grupo de trabajo: G4  
Semestre: 2026-2  

---

## Índice
- [Diseño implementado](#diseño-implementado)
- [Simulaciones](#simulaciones)
- [Implementación](#implementación)
- [Conclusiones](#conclusiones)
- [Referencias](#referencias)

---

## Diseño implementado

Durante el Laboratorio 00 se desarrollaron dos sistemas digitales secuenciales principales empleando el concepto de Máquina de Estados Finitos (FSM) y la integración de una FSM con un bloque de procesamiento de datos (datapath). Los diseños fueron descritos en Verilog y verificados mediante simulación utilizando Icarus Verilog para la compilación y ejecución y GTKWave para la visualización de las señales. La guía del laboratorio tiene como fin el diseño de sistemas que funcionen durante varios ciclos de reloj y comprobar su comportamiento con testbench.

### Ejercicio 1 – FSM de control: semáforo vehicular
El primer diseño es una Máquina de Estados Finitos (FSM) secuencial que controla un semáforo vehicular. El sistema usa el reloj (clk) como referencia de tiempo. También tiene una señal de reset (rst) para fijar el estado inicial.  


### Ejercicio 2 – FSM con datapath: acumulador secuencial

El segundo diseño es un sistema tipo FSM con datapath. En este, una máquina de estados controla las operaciones que se hacen sobre un registro acumulador. Este ejercicio permite separar la unidad de control, que es la FSM, del procesamiento de los datos, que lo hace el datapath.

## Simulaciones

Describa las simulaciones realizadas para verificar el funcionamiento del diseño.

Incluya:
- Descripción del testbench.
- Señales observadas.
- Resultados obtenidos.
- 
### Ejercicio 1: 
Se elaboró un testbench en Verilog, cuyo objetivo es comprobar el correcto funcionamiento de la FSM del semáforo, generando la señal de reloj clk, aplicando la señal de reset rst y permitiendo seguir la evolución del sistema a lo largo de varios ciclos.
Las señales presentes fueron las siguientes:
- clk: señal de reloj.
- rst: señal del reset del sistema.
- green, yellow, red: señales de salida del semáforo.
- state[1:0]: estado actual de la FSM.

La simulación ha permitido observar la secuencia de estados:
Verde ↔ Amarillo ↔ Rojo ↔ Amarillo ↔ Verde
El clock se encarga de controlar la permanencia en cada estado e indica el momento en que se debe realizar una transición como se puede observar en GTKWave, la secuencia se repite correctamente y las salidas son coherentes con el estado de la FSM.

### Evidencias

(Incluya capturas de pantalla de GTKWave donde se evidencie el correcto funcionamiento.)
### Ejercicio 1: 
<img width="763" height="497" alt="image" src="https://github.com/user-attachments/assets/e103c39a-2d7c-4703-8b72-13892b01e749" />


### Ejercicio 2


### Ejercicio 3


## Implementación

Explique cómo se implementó el diseño en Verilog.

Incluya:
- Organización del código.
- Manejo de reloj y reset.
- Comportamiento esperado del sistema.

> El código fuente debe encontrarse en la carpeta `src/`.

---

## Conclusiones

- Principales aprendizajes del laboratorio.
- Dificultades encontradas.
- Importancia de la simulación en el diseño digital.

---

## Referencias


