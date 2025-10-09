/*
Name:  Quinn Miyamoto
Email: qmiyamoto@g.hmc.edu
Date:  October 4, 2025

Purpose: To allow the timer delay functions to actually be used.
*/


#include "STM32L432KC.h"
#include <stm32l432xx.h>


#ifndef TIMERDELAY_H
#define TIMERDELAY_H

// Function prototypes
void timer_initialization(void);
void sampling_period(int duration);

#endif