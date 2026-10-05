# Laboratorio 01  
## Lab01: FPGA (Zybo Z7), Vivado/Vitis y Validación de Hardware

Maquinas de estado 
Codigo comentado / explicaciones 
Pantallazo GTK Wave 
---

## Integrantes

- Andres Felipe Castro Lopez – 1014298415
- Juan Pablo Castañeda Moncada - 1000851451
- Angel Manuel Cortavarria Salas– 1044213907

**Grupo de trabajo:** G4  
**Semestre:** 2026-2  

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

Se presenta el reporte de la simulación realizada para comprobar que el diseño de la ALU funciona correctamente.

### Descripción del testbench

Para probar el circuito, se armó un testbench que le envía diferentes valores a la ALU a través de los interruptores (`sw`) y los botones (`btn`). La idea fue simular cambios cada 10 nanosegundos para ir pasando por las cuatro operaciones (AND, OR, XOR y SUMA) y ver cómo respondía el diseño. Hay que recordar que, por las condiciones del proyecto, el primer número (A) entra tal cual por los 4 primeros switches, pero el segundo número (B) sale de los otros 4 switches con los bits invertidos.

### Señales observadas

Al revisar la simulación en GTKWave, se acomodaron las siguientes variables para que fuera más fácil leer los resultados:

* **`btn[3:0]`**: Se dejó en binario para identificar rápido qué botón se estaba oprimiendo para elegir la operación.


* **`sw[7:0]`**: Se puso en hexadecimal para agrupar visualmente los dos números que entran por los interruptores.


* **`led[3:0]`**: Se dejó en binario para revisar el resultado final bit a bit.


* **`rgb_r`, `rgb_g`, `rgb_b**`: Se dejaron tal cual para comprobar que prendiera el color indicado en cada operación.

### Resultados obtenidos

**Primera ronda de pruebas (de 10 ns a 50 ns):**
Se configuraron los switches en `AC` (hexadecimal), lo que significa que el operando A valía 12 (`1100`) y el B valía 5 (`0101`).

* **De 10 a 20 ns:** Se probó la operación AND oprimiendo el botón correspondiente (`btn = 0001`). El resultado en los LEDs fue `0100` y prendió el indicador rojo (`rgb_r` en alto).


* **De 20 a 30 ns:** Se pasó a la operación OR (`btn = 0010`). Los LEDs mostraron `1101` y cambió al indicador verde (`rgb_g`).


* **De 30 a 40 ns:** Se seleccionó la XOR (`btn = 0100`). El resultado arrojó `1001` y prendió exclusivamente el color azul (`rgb_b`).


* **De 40 a 50 ns:** Se probó la SUMA (`btn = 1000`). El resultado en los LEDs fue `0001`. Esto es correcto porque 12 + 5 da 17, y al tener solo 4 bits para mostrar el resultado, el bit extra se pierde y queda el 1. Para mostrar que estaba sumando, prendieron el rojo y el verde al tiempo.



**Segunda ronda de pruebas (de 50 ns a 70 ns):**
Se cambiaron los switches a `C7`, así que A quedó valiendo 7 (`0111`) y B valiendo 3 (`0011`).

* **De 50 a 60 ns:** No se oprimió ningún botón (`btn = 0000`). Tal como se programó, los LEDs mostraron `0000` y los colores se apagaron.


* **De 60 a 70 ns:** Se volvió a sumar (`btn = 1000`). Los LEDs dieron el resultado `1010`, que es el número 10 en binario, confirmando que 7 + 3 se operó bien. Los colores rojo y verde volvieron a prenderse juntos.



**Tercera ronda de pruebas (de 70 ns a 80 ns):**
Se hizo una prueba poniendo todo en cero. Los switches pasaron a `F0`, lo que deja tanto a A como a B en cero.

* **De 70 a 80 ns:** Al hacer la operación AND (`btn = 0001`), la salida de los LEDs fue `0000` y solo prendió el indicador rojo.

### Evidencias

En la captura de pantalla de GTKWave (archivo "image_a770b8.png") se observa claramente que el código escrito en Verilog cumple con lo esperado. Las gráficas de ondas demuestran que la ALU ejecuta los cálculos correctos, incluyendo el detalle de invertir los switches altos para el segundo número. También se comprueba que el control de las luces RGB y los LEDs responde de inmediato a la selección de cada botón sin generar comportamientos extraños en la placa.


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
