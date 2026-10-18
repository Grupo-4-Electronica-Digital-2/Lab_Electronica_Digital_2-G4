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

### Módulos implementados

- **`top.v` — Módulo principal:** integra los módulos del sistema y establece las conexiones entre las entradas físicas de la FPGA, los registros, la ALU y las salidas de visualización. Recibe los valores de los interruptores y los botones, y envía el resultado de la operación a los LEDs.

- **`registro.v` — Almacenamiento de operandos:** implementa un registro de 4 bits que almacena el valor presente en los interruptores `sw[3:0]` cuando se activa la señal `load` en un flanco positivo del reloj `clk`.

- **`op_selector.v` — Selector de operaciones:** genera el código de operación de 2 bits `op[1:0]` a partir de los botones `btn2` y `btn3`. Cada botón modifica uno de los bits del código al detectar una pulsación, permitiendo seleccionar entre las cuatro operaciones disponibles. El módulo incorpora sincronización de las entradas con el reloj para reducir los riesgos asociados a señales asíncronas.

- **`alu.v` — Unidad aritmético-lógica:** procesa los operandos A y B, ambos de 4 bits, y ejecuta la operación indicada por `op[1:0]`. Su implementación es completamente combinacional, por lo que el resultado se actualiza automáticamente cuando cambian los operandos o el código de operación. Las operaciones disponibles son suma, resta, AND bit a bit y OR bit a bit.

- **`rgb_ctrl.v` — Controlador del LED RGB:** decodifica el código de operación y establece las señales de control de los componentes rojo, verde y azul del LED RGB. De esta manera, permite identificar visualmente la operación seleccionada sin necesidad de consultar el código binario.


### Estados y operaciones

El selector utiliza dos bits, `op[1:0]`, para representar
las cuatro operaciones disponibles:

| Código `op[1:0]` | Operación | Color del LED RGB |
|:---:|---|---|
| `00` | Suma: A + B | Verde |
| `01` | Resta: A - B | Rojo |
| `10` | AND: A & B | Azul |
| `11` | OR: A \| B | Blanco |

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


