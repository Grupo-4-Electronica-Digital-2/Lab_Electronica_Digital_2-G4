# Laboratorio 01  
## Lab01: FPGA (Zybo Z7), Vivado/Vitis y Validación de Hardware

Maquinas de estado 
Codigo comentado / explicaciones 
Pantallazo GTK Wave 
---

## Integrantes

- Andres Felipe Castro Lopez – 1014298415
- Nombre completo – DNI
- Nombre completo – DNI

**Grupo de trabajo: G4  
**Semestre:2026-2  

---

## Índice
- [Diseño implementado](#diseño-implementado)
- [Simulaciones](#simulaciones)
- [Implementación](#implementación)
- [Conclusiones](#conclusiones)
- [Referencias](#referencias)

---

## Diseño implementado

El diseño implementa en la FPGA una unidad lógica aritmética (ALU) combinacional de 4 bits, encargada de realizar diferentes operaciones sobre dos operandos de 4 bits. 

Los operandos se obtienen de los ocho switches disponibles. Los cuatro switches inferiores (sw[3:0]) corresponden al operando \(A\), mientras que los cuatro switches superiores (sw[7:4]) corresponden al operando \(B\). Debido a que los switches externos utilizan una configuración pull-up, estos últimos se invierten mediante ~sw[7:4] para obtener la representación lógica esperada.

La operación de la ALU se selecciona mediante los cuatro botones:

| Botón | Operación | Expresión      | Indicador RGB |
| ----- | --------- | -------------- | ------------- |
| BTN0  | AND       | \(A \and B\)  | Rojo          |
| BTN1  | OR        | \(A \or B\)   | Verde         |
| BTN2  | XOR       | \(A \xor B\) | Azul          |
| BTN3  | Suma      | \(A+B\)        | Rojo + verde  |

La salida de cada operación se presenta mediante los cuatro LED (led[3:0]). Adicionalmente, el LED RGB permite identificar  la operación seleccionada. Las salidas se actualizan de manera combinacional cada vez que cambia alguna de las entradas.

---

## Simulaciones

Describa las simulaciones realizadas para verificar el funcionamiento del diseño.

Incluya:
- Descripción del testbench.
- Señales observadas.
- Resultados obtenidos.

### Evidencias

(Incluya capturas de pantalla de GTKWave donde se evidencie el correcto funcionamiento.)
#### Ejercicio 1: 



## Implementación

El diseño se implementó en Verilog mediante el módulo alu_personalizada, organizado en tres partes principales: definición de entradas y salidas, asignación de los operandos y lógica combinacional para seleccionar la operación de la ALU.

Los ocho switches se utilizan como entradas para los dos operandos de 4 bits. El operando \(A\) se obtiene directamente de sw[3:0], mientras que el operando \(B\) se obtiene de sw[7:4] aplicando una inversión lógica (~sw[7:4]), en el archivo Zybo-Z7.xdc se declara el pull up para los cuatro switches en la protoboar y se remueve el comentario del pin 1 al 4 del puerto JE, tambien se conecta tierra de la FPGA a la protoboard para compartir la referencia .

La lógica de operación se implementó mediante un bloque always @(*), utilizando una estructura if - else if para seleccionar entre AND, OR, XOR y suma según el botón presionado. Antes de evaluar los botones se asignan valores por defecto a todas las salidas, evitando estados no definidos.

Comportamiento esperado:

El sistema debe mostrar en los cuatro LED el resultado de la operación seleccionada entre los operandos \(A\) y \(B\). Simultáneamente, el LED RGB indica qué operación se encuentra activa mediante diferentes colores.

Cuando no se presiona ningún botón, los LED permanecen apagados. Si se presionan varios botones al mismo tiempo, se aplica la prioridad definida por la estructura condicional: BTN0, BTN1, BTN2 y finalmente BTN3.

## Conclusiones

- Principales aprendizajes del laboratorio.
- Dificultades encontradas.
- Importancia de la simulación en el diseño digital.

---

## Referencias
