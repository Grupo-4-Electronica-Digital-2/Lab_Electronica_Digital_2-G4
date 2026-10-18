# Laboratorio 02  
## Diseño, simulación e implementación de una ALU de 4 bits

---

## Integrantes

- Andres Felipe Castro Lopez – 1014298415
- Juan Pablo Castañeda Moncada - 1000851451
- Angel Manuel Cortavarria Salas – 1044213907

**Grupo de trabajo:** 4  
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

El diseño está compuesto por regustros de 4 bits,
una unidad de control para la selección de operaciones y un
módulo de visualización mediante LEDs.

El sistema combina lógica secuencial, utilizada para almacenar
los operandos y seleccionar la operación, con lógica combinacional,
encargada de realizar las operaciones aritméticas y lógicas.

## Módulos implementados

- `top.v`: integra los módulos del sistema y conecta las entradas
  y salidas de la FPGA.
- `registro.v`: almacena los operandos A y B cuando se activa
  la señal de carga correspondiente.
- `op_selector.v`: actualiza la operación seleccionada mediante
  los botones `btn2` y `btn3`.
- `alu.v`: realiza las operaciones de suma, resta, AND y OR
  sobre los operandos de 4 bits.
- `rgb_ctrl.v`: representa la operación seleccionada mediante
  el LED RGB.


### Estados y operaciones

El selector utiliza dos bits, `op[1:0]`, para representar
las cuatro operaciones disponibles:

| Código | Operación |
|--------|-----------|
| `00`   | Suma: A + B |
| `01`   | Resta: A - B |
| `10`   | AND: A & B |
| `11`   | OR: A \| B |

Estos cuatro códigos representan los modos de operación del
sistema. El selector cambia los bits de operación al detectar
las pulsaciones de los botones correspondientes.

### Funcionamiento general

1. Los interruptores `sw[3:0]` permiten introducir los operandos.
2. El botón `btn0` almacena el valor de los interruptores en A.
3. El botón `btn1` almacena el valor de los interruptores en B.
4. Los botones `btn2` y `btn3` modifican la operación seleccionada.
5. La ALU calcula continuamente el resultado según A, B y `op`.
6. Los LEDs `led[3:0]` muestran el resultado binario de la operación.
7. El LED RGB indica la operación seleccionada.

### Máquina de estados

El diseño no utiliza una FSM convencional con estados nombrados
y transiciones explícitas mediante una instrucción `case`.
El módulo `op_selector` mantiene un código de operación de dos bits
que cambia según las pulsaciones detectadas. Por esta razón,
los cuatro códigos de operación pueden representarse como modos
de funcionamiento, sin confundirlos con una FSM independiente.

## Simulaciones

Describa las simulaciones realizadas para verificar el funcionamiento del diseño.

Incluya:
- Descripción del testbench.
- Señales observadas.
- Resultados obtenidos.

### Evidencias

(Incluya capturas de pantalla de GTKWave donde se evidencie el correcto funcionamiento.)

---

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


