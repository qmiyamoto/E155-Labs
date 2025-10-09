/*
Name:  Quinn Miyamoto
Email: qmiyamoto@g.hmc.edu
Date:  October 4, 2025

Purpose: To allow the interrupt configuration functions to actually be used.
*/


#include "STM32L432KC.h"
#include <stm32l432xx.h>


#ifndef INTERRUPT_CONFIGURATION_H
#define INTERRUPT_CONFIGURATION_H

// function prototypes
void interrupt_configuration(void);
void EXTI9_5_IRQHandler(void);
void EXTI15_10_IRQHandler(void);
void TIM1_UP_TIM16_IRQHandler(void);
int _write(int file, char *ptr, int len);

#endif