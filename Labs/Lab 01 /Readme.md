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
<img width="763" height="497" alt="image" src="https://github.com/user-attachments/assets/e103c39a-2d7c-4703-8b72-13892b01e749" />


## Implementación



> El código fuente debe encontrarse en la carpeta `src/`.

---

## Conclusiones

- Principales aprendizajes del laboratorio.
- Dificultades encontradas.
- Importancia de la simulación en el diseño digital.

---

## Referencias
