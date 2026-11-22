# Laboratorio 04  
## Lab04 – SoC Zynq-7000

 ---

## Integrantes

- Andres Felipe Castro Lopez – 1014298415
- Juan Pablo Castañeda Moncada - 1000851451
- Angel Manuel Cortavarria Salas– 1044213907

**Grupo de trabajo:** G4  
**Semestre:** 2026-2  

---

## Índice

- [Evidencias](#evidencias)
- [Referencias](#referencias)

---





## Evidencias

Configuración de proyecto : Verifica la creación del proyecto Lab04 apuntando directamente a la tarjeta Zybo Z7-10 (xc7z010clg400-1) con lenguaje objetivo Verilog

<img width="1061" height="951" alt="Captura de pantalla 2026-11-18 215252" src="https://github.com/user-attachments/assets/c631de99-74d2-4ea2-a81f-092eab38be0b" />

Integración de periféricos : Muestra la etapa intermedia al añadir el bloque axi_gpio_0 con las interfaces leds_4bits y btns_4bits desde la pestaña Board antes de ejecutar la conexión automática.

<img width="1833" height="858" alt="Captura de pantalla 2026-11-18 220227" src="https://github.com/user-attachments/assets/a2e5b9e4-320b-4cae-8d87-142fc0f647f3" />

Diagrama de bloques final : Evidencia el SoC completo y organizado tras Regenerate Layout, conectando processing_system7_0 y proc_sys_reset_0 a través de axi_interconnect_0 hacia axi_bram_ctrl_0 (blk_mem_gen_0) y axi_gpio_0. Además, confirma que el canal 1 (GPIO) quedó asignado a btns_4bits y el canal 2 (GPIO2) a leds_4bits, lo cual coincide exactamente con las definiciones BTN_CHANNEL 1 y LED_CHANNEL 2 de src/main.c.


<img width="1767" height="637" alt="Captura de pantalla 2026-11-18 221314" src="https://github.com/user-attachments/assets/cc7846cb-1b0d-4df3-8948-c0a3620f42ca" />

Entorno Vitis : Muestra en Vitis Explorer (LAB04 - VITIS COMPONENTS) la plataforma de hardware platform [Platform] junto con la aplicación app_component [Application] [standalone_ps7_cortexa9_0].

<img width="487" height="282" alt="Captura de pantalla 2026-11-18 225632" src="https://github.com/user-attachments/assets/ae0240b0-1aa9-4fe2-bef0-d02e3491ac69" />

Se observa tambien que el proyecto se contruyó sin errores.

![Correcto build](build.png)

Video del funcionamiento en la FPGA: Después de realizar la implementación así se ve en la FPGA.




https://github.com/user-attachments/assets/eb046b8f-3da0-4dc6-8fd3-0d70f242470b





## Referencias

- AMD. (s. f.). *SoC AMD Zynq™ 7000*. Advanced Micro Devices, Inc.
- Digilent. (s. f.). *Zybo Z7 Reference Manual & Board Files*. Digilent Inc.
- FPGAs for Beginners. (2023, 28 de julio). *Zynq Part 1: Vivado block diagram (no Verilog/VHDL necessary!)* [Video]. YouTube.


