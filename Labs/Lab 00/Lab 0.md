# Laboratorio 00: Introducción a Verilog, Simulación y Máquinas de Estados Finitos (FSM) 
## Introducción a Verilog, Simulación y Máquinas de Estados Finitos (FSM)

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

Durante el Laboratorio 00 se desarrollaron dos sistemas digitales secuenciales principales empleando el concepto de Máquina de Estados Finitos (FSM) y la integración de una FSM con un bloque de procesamiento de datos (datapath). Los diseños fueron descritos en Verilog y verificados mediante simulación utilizando Icarus Verilog para la compilación y ejecución y GTKWave para la visualización de las señales. La guía del laboratorio tiene como fin el diseño de sistemas que funcionen durante varios ciclos de reloj y comprobar su comportamiento con testbench.

### Ejercicio 1 – FSM de control: semáforo vehicular
El primer diseño es una Máquina de Estados Finitos (FSM) secuencial que controla un semáforo vehicular. El sistema usa el reloj (clk) como referencia de tiempo. También tiene una señal de reset (rst) para fijar el estado inicial. Para cumplir los requisitos de la guia, se usaron acciones de transicion para reiniciar el contador interno cuando viene una señal de reset (rst) o del estado YELLOW a GREEN sin agregar un estado mas, como se observa en la figura.

![Diagrama de Estados](./imagenes/DiagramaEstadosEj1.png)


### Ejercicio 2 – FSM con datapath: acumulador secuencial

El segundo diseño es un sistema tipo FSM con datapath. En este, una máquina de estados controla las operaciones que se hacen sobre un registro acumulador. Este ejercicio permite separar la unidad de control, que es la FSM, del procesamiento de los datos, que lo hace el datapath.
A continuación se presenta la maquina de estados:

![FSM Ejercicio 2](./imagenes/FSM_Ejercicio2.png)
### Ejercicio 3 – FSM con datapath: Transmisor Serial (ASM Completa)

El tercer diseño consiste en un transmisor serial síncrono de 8 bits implementado mediante una Máquina de Estados Algorítmica (ASM) bajo la arquitectura estricta de FSMD (Control + Datapath). El sistema recibe un byte de entrada (`data_in[7:0]`) y lo transmite bit a bit por la línea de salida `tx`, garantizando que cada bit dure exactamente la cantidad de ciclos definida por el parámetro `CLKS_PER_BIT`.

El diseño se dividió de manera modular:
*   **Unidad de Control (FSM):** Se encarga exclusivamente de dirigir el flujo de ejecución a través de los estados IDLE, LOAD, SEND, BIT_HOLD, SHIFT y DONE_ST. Solo genera las señales de control necesarias para comandar el hardware.
*   **Datapath:** Ejecuta las operaciones físicas (sumas, corrimientos y asignaciones). Contiene un registro de desplazamiento (`shift_reg`), un contador de temporización de ciclos (`tick_cnt`) y un contador de bits transmitidos (`bit_count`).

A continuación, se presenta el diagrama de la Máquina de Estados Algorítmica (ASM) que rigió la construcción del hardware:

![Diagrama ASM Ejercicio 3](./imagenes/DiagramaASM_Ej3.png)

## Simulaciones:

### Ejercicio 1: 
### 1. Descripción del Testbench
Se elaboró un testbench en Verilog, cuyo objetivo es comprobar el correcto funcionamiento de la FSM del semáforo, generando la señal de reloj clk, aplicando la señal de reset rst y permitiendo seguir la evolución del sistema a lo largo de varios ciclos.
Las señales presentes fueron las siguientes:
- clk: señal de reloj.
- rst: señal del reset del sistema.
- green, yellow, red: señales de salida del semáforo.
- state[1:0]: estado actual de la FSM.

### 2. Resultados Obtenidos y Evidencias
La simulación ha permitido observar la secuencia de estados:
Verde ↔ Amarillo ↔ Rojo ↔ Amarillo ↔ Verde
El clock se encarga de controlar la permanencia en cada estado e indica el momento en que se debe realizar una transición como se puede observar en GTKWave, la secuencia se repite correctamente y las salidas son coherentes con el estado de la FSM.

A continuación se presentan la captura de pantalla de las simulación correspondientes al semáforo y como este inicia en verde y se devuelve como la haría un semáforo real:

<img width="763" height="497" alt="image" src="https://github.com/user-attachments/assets/e103c39a-2d7c-4703-8b72-13892b01e749" />


### Ejercicio 2
### 1. Descripción del Testbench

El banco de pruebas (`tb_acumulador_sec.v`) fue diseñado para validar tanto el flujo de acumulación normal en todas sus variantes como la lógica de interrupción.

* **Generación de Reloj:** Se configuró un reloj con un período de $10\text{ ns}$ (frecuencia de $100\text{ MHz}$) mediante la directiva `always #5 clk = ~clk;`.
* **Secuencia de Estímulos:**
  1. **Reset Inicial:** Se aplica un pulso en alto a `rst` durante $10\text{ ns}$ para garantizar el estado inicial `IDLE (0)`.
  2. **Ciclo de Acumulación:** Se asigna un valor a la entrada `x[3:0]`, se habilita la señal `start` durante un ciclo de reloj y se deja evolucionar la FSM.
  3. **Prueba de Cancelación:** En un segundo ciclo de operación, se activa la señal `cancel` durante el estado `ADD` para comprobar el retorno inmediato a `IDLE`.

### 2. Señales Observadas

Las señales monitoreadas en el visor de formas de onda GTKWave se dividen en control y datos:

| Señal | Tipo | Descripción / Interpretación en GTKWave |
| :--- | :--- | :--- |
| `clk` | Entrada | Reloj principal del sistema ($T = 10\text{ ns}$). |
| `rst` | Entrada | Reset asíncrono. En nivel alto reinicia la FSM a `IDLE`. |
| `start` | Entrada | Pulso de inicio de la operación de acumulación. |
| `cancel` | Entrada | Señal de aborto de proceso. |
| `x[3:0]` | Entrada | Dato de $4\text{ bits}$ a acumular en cada ciclo. |
| `estado[1:0]` | Interna | Codificación del estado actual de la FSM:<br>• `0`: IDLE \| `1`: LOAD \| `2`: ADD \| `3`: DONE |
| `acc[5:0]` | Salida | Registro acumulador ($6\text{ bits}$) que almacena la suma progresiva. |
| `done` | Salida | Pulso de bandera que indica la finalización exitosa del cálculo. |


### 3. Resultados Obtenidos y Evidencias

A continuación se presentan las capturas de pantalla de las simulaciones correspondientes a las tres variantes de acumulación y a la función de cancelación.

#### Variante 1: Sumar X 3 veces (`VARIANTE = 0`)

En esta configuración, el sistema realiza la suma de $x$ durante 3 ciclos de reloj en el estado `ADD (2)`.

![Simulación Variante 1 - Sumar 3 veces](./imagenes/acum_3.png)

* **Análisis del resultado:**
  * Con $x = 3$, al presionar `start`, la FSM pasa de `IDLE (0)` a `LOAD (1)` y luego a `ADD (2)`.
  * La señal `acc` incrementa en pasos de $3$: $0 \rightarrow 3 \rightarrow 6 \rightarrow 9$.
  * Al completar los 3 ciclos, el sistema pasa al estado `DONE (3)`, donde se activa `done = 1` por un ciclo.
  * **Prueba de Cancelación:** En la segunda ráfaga con $x = 5$, la activación de `cancel` interrumpe el proceso, regresando la FSM a `IDLE (0)` y limpiando `acc` a $0$.


#### Variante 2: Sumar X 4 veces (`VARIANTE = 1`)

En esta configuración, la acumulación se ejecuta durante 4 ciclos consecutivos antes de finalizar.

![Simulación Variante 2 - Sumar 4 veces](./imagenes/acum_4.png)

* **Análisis del resultado:**
  * Para una entrada constante $x = 3$, el acumulador evoluciona secuencialmente: $0 \rightarrow 3 \rightarrow 6 \rightarrow 9 \rightarrow 12$.
  * Cumplidos los 4 ciclos requeridos, se alcanza el estado `DONE (3)` activando la bandera de salida `done`.


#### Variante 3: Sumar hasta que acc mayor o igual a 20 (`VARIANTE = 2`)

En esta configuración, el Datapath evalúa en cada ciclo si la suma acumulada alcanzará o superará el umbral de $20$.

![Simulación Variante 3 - Suma mayor o igual a 20](./imagenes/acum_20.png)

* **Análisis del resultado:**
  * Con entrada $x = 3$, el sistema acumula sucesivamente: $3, 6, 9, 12, 15, 18, 21$.
  * Al alcanzar $21$ ($21 \ge 20$), la condición de parada se cumple y la FSM transita inmediatamente al estado `DONE (3)`, activando el pulso `done`.


### Ejercicio 3

#### 1. Descripción del Testbench

El banco de pruebas (`tb_tx_serial.v`) se diseñó para comprobar la transmisión íntegra de bytes y la correcta temporización del sistema. Se instanció el módulo principal con el parámetro `CLKS_PER_BIT = 8` y un reloj de sistema de 10 ns de periodo.

El estímulo aplicado consistió en:
1.  **Reinicio Inicial:** Aplicación de un reset asíncrono para asegurar el arranque del sistema en el estado `IDLE` y la línea `tx` en reposo (alto).
2.  **Primera Transmisión:** Envío de un pulso `start` de duración exacta de un ciclo de reloj para cargar y transmitir el dato `8'hA5` (10100101 en binario).
3.  **Segunda Transmisión:** Tras esperar la confirmación de la bandera `done`, se repitió el proceso inyectando el dato `8'h3C` (00111100 en binario).

#### 2. Resultados Obtenidos y Evidencias en GTKWave

La simulación generó un archivo VCD cuyas ondas evidencian el cumplimiento íntegro de los criterios de éxito planteados:

*   **Transmisión de 8 bits:** Se observa que el registro `shift_reg` se desplaza progresivamente hacia la derecha. El sistema procesa correctamente los 8 bits (del LSB al MSB) evaluando la bandera lógica hasta que `bit_count` llega a 8, impidiendo el envío de bits fantasma o prematuros.
*   **Duración de cada bit:** La temporización es matemáticamente exacta. En el estado `BIT_HOLD`, la FSM evalúa `tick_cnt` permitiendo que cada bit permanezca en la línea de salida `tx` durante exactamente 8 ciclos de reloj completos[cite: 2].
*   **Señales de estado:** La señal `busy` se activa en `1` ininterrumpidamente desde que el sistema sale de `IDLE` hasta que se completa el byte. Asimismo, la señal `done` se levanta durante un (y solo un) ciclo de reloj inmediatamente después del octavo desplazamiento, retornando el sistema a su estado inactivo.

![Simulación Transmisión 8'hA5 y 8'h3C](./imagenes/simulacion_tx_completa.png)

![Detalle de Temporización de bit (Zoom GTKWave)](./imagenes/simulacion_tx_zoom.png)


## Implementación

### Ejercicio 1:

El diseño se divide en dos archivos:
- [semaforo.v](./src/semaforo.v): contiene el módulo principal de la FSM
- [tb_semaforo.v](./src/tb_semaforo.v): contiene el testbench de verificación

El módulo semaforo.v está organizado en dos bloques always:
el primero maneja la lógica secuencial (cambio de estados y contador), y el segundo maneja las salidas combinacionales.

El sistema opera en el flanco positivo del reloj (posedge clk).
El reset es asíncrono ya que esta en la lista sensitiva junto al clock y activo alto — al activarse, el sistema regresa inmediatamente al estado GREEN con count=0,independientemente del estado actual.

Los estados se codificaron con localparams de 2 bits:
S0_GREEN=00, S1_YELLOW=01, S2_RED=10.

El contador count es una variable interna de 4 bits que se incrementa en cada ciclo de reloj sin resetearse al cambiar de estado — esto permite usar valores absolutos como umbrales de transición (count==4, count==6, count==10, count==12).

Las salidas green, yellow y red se calculan en un bloque
always @(*) separado — esto garantiza que son señales Moore
puras, es decir, dependen únicamente del estado actual y sean puramente combinacionales.

La única excepción al comportamiento acumulado del contador
es la transición de YELLOW a GREEN cuando count==12, donde
se resetea a 0 para comenzar el siguiente ciclo completo.


### Ejercicio 2:
### Implementación del Diseño en Verilog
El acumulador secuencial se implementó mediante una arquitectura **FSM con Datapath** síncrona. El detalle técnico línea por línea se encuentra comentado directamente en el código fuente dentro de la carpeta [`src/`](./src/).

#### 1. Estructura y Código Fuente

* **Módulo Principal:** [`src/acumulador_sec.v`](./src/acumulador_sec.v)  
  Contiene el control por FSM (`IDLE`, `LOAD`, `ADD`, `DONE`), la lógica del Datapath (sumador/contador) y el soporte para la señal de cancelación.
* **Banco de Pruebas:** [`src/tb_acumulador_sec.v`](./src/tb_acumulador_sec.v)  
  Genera el reloj de $10\text{ ns}$, el reset asíncrono y los estímulos de prueba para generar el archivo de ondas para GTKWave.

#### 2. Puntos Clave del Hardware

* **Reloj y Reset:** Operación síncrona en flanco de subida (`posedge clk`) con reset asíncrono activo en alto (`rst`) que fuerza el estado inicial `IDLE (0)`.
* **Flujo del Sistema:** Tras recibir `start = 1`, la FSM limpia los registros en `LOAD`, ejecuta las sumas en `ADD` según el parámetro `VARIANTE`, emite el pulso `done = 1` en `DONE` y retorna automáticamente a `IDLE`[cite: 2, 3, 4]. La señal `cancel = 1` interrumpe el proceso en cualquier punto.
### Ejercicio 3

### Implementación del Diseño en Verilog

El transmisor serial fue desarrollado en el archivo fuente `tx_serial.v` materializando la separación estricta entre la toma de decisiones y el procesamiento de los datos.

#### 1. Unidad de Control (FSM)
Construida mediante una máquina de Moore. Utiliza un bloque combinacional dedicado exclusivamente a resolver la lógica del siguiente estado y activar variables de control de un solo bit: `espera`, `ctrl_rst`, `send`, `duracion`, `shft` y `ctrl_done`. Estas banderas comunican a la Ruta de Datos lo que debe hacer en el instante preciso.

#### 2. Datapath (Ruta de Datos)
Implementado en un bloque secuencial síncrono `always @(posedge clk or posedge rst)` que lee las variables de la FSM:
*   **Al recibir `ctrl_rst`:** Se carga `data_in` en `shift_reg`, se limpia el conteo de bits y se inicializa el temporizador de ciclos en 1, estrategia implementada directamente desde el diagrama de control para obviar lógica de resta en la comparación.
*   **Al recibir `duracion`:** Se habilita el incremento lógico del contador temporal (`tick_cnt + 1`).
*   **Al recibir `shft`:** Se efectúa el desplazamiento físico en el registro (`shift_reg >> 1`), se incrementa `bit_count` en una unidad y se reinicia el temporizador de ciclos de reloj de inmediato[cite: 2].

Las banderas que informan el progreso (`tick_done` y `bit_done`) viajan del Datapath a la FSM mediante lógica puramente combinacional (`assign`). Las salidas físicas del sistema (`tx`, `busy`, `done`) se dedujeron combinacionalmente a partir de las banderas de estado.



---

## Conclusiones
Como punto de partida del laboratorio, logramos instalar y verificar el correcto funcionamiento de Icarus Verilog y GTKWave, confirmando que tenemos el entorno listo para simular y analizar señales digitales sin problemas. Familiarizarnos con estas herramientas desde el principio es clave, ya que nos da la base para poder validar el comportamiento temporal de cualquier diseño antes de pensar en implementarlo en hardware físico.

En cuanto al Ejercicio 1, diseñar la máquina de estados para el semáforo nos sirvió bastante para entender en la práctica cómo usar el reloj (clk) para llevar el control del tiempo en el sistema. Algo muy útil de este diseño fue que logramos optimizar la lógica: para cumplir con los requisitos de la guía, usamos acciones de transición para reiniciar el contador interno (ya sea al aplicar el rst o al regresar de Amarillo a Verde) y así nos evitamos el problema de tener que agregar estados extra innecesarios. Al final, armar el testbench y ver las ondas en GTKWave nos confirmó visualmente que la secuencia cíclica (Verde ↔ Amarillo ↔ Rojo ↔ Amarillo ↔ Verde) se cumple a la perfección, respetando los tiempos de permanencia de cada color y demostrando que nuestra FSM funciona exactamente como lo planeamos.

Hablando del ejercicio 2, desarrollar el acumulador secuencial hizo mucho más clara la diferencia práctica entre usar lógica combinacional (para calcular las sumas o el próximo estado) y lógica secuencial (para guardar los datos en cada flanco de reloj). Diseñar la máquina de estados (FSM) conectada al Datapath nos ayudó a entender cómo coordinar un sistema que opera a lo largo de varios ciclos de reloj, asegurando que pase por sus estados correctamente (IDLE, LOAD, ADD, DONE), retenga el resultado al terminar y reaccione bien a señales como la cancelación. Al final, armar el testbench y revisar las ondas generadas nos demostró que la simulación es un paso obligatorio para cazar y corregir errores lógicos a tiempo.

---

## Referencias

[1]: S. L. Harris y D. Harris, *Digital Design and Computer Architecture: RISC-V Edition*. Waltham, MA, USA: Morgan Kaufmann, 2021.



