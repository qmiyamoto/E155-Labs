// TIM16_struct.h
// Header for TIM16 functions

/*
Name:  Quinn Miyamoto
Email: qmiyamoto@g.hmc.edu
Date:  September 21, 2025

Purpose: 
*/

#ifndef TIM16_STRUCT_H
#define TIM16_STRUCT_H

#include <stdint.h>

///////////////////////////////////////////////////////////////////////////////
// Definitions
///////////////////////////////////////////////////////////////////////////////

#define __IO volatile
#define PRESCALER_VALUE_16 16

// Base addresses
#define TIM16_BASE (0x40014400UL) // base address of TIM16

typedef struct
{
  __IO uint32_t CR1;          /*!< TIM16 control register 1,                    Address offset: 0x00 */
  __IO uint32_t CR2;          /*!< TIM16 control register 2,                    Address offset: 0x04 */
       uint32_t RESERVED0;    /*!< Reserved,                                    Address offset: 0x08 */
  __IO uint32_t DIER;         /*!< TIM16 DMA/interrupt enable register,         Address offset: 0x0C */
  __IO uint32_t SR;           /*!< TIM16 status register,                       Address offset: 0x10 */
  __IO uint32_t EGR;          /*!< TIM16 event generation register,             Address offset: 0x14 */
  __IO uint32_t CCMR1_output; /*!< TIM16 capture/compare mode register 1,       Address offset: 0x18 */
  __IO uint32_t CCMR1_input;  /*!< TIM16 capture/compare mode register 1,       Address offset: 0x1C */
  __IO uint32_t CCER;         /*!< TIM16 capture/compare enable register,       Address offset: 0x20 */
  __IO uint32_t CNT;          /*!< TIM16 counter,                               Address offset: 0x24 */
  __IO uint32_t PSC;          /*!< TIM16 prescaler,                             Address offset: 0x28 */
  __IO uint32_t ARR;          /*!< TIM16 auto-reload register,                  Address offset: 0x2C */
  __IO uint32_t RCR;          /*!< TIM16 repetition counter regsiter,           Address offset: 0x30 */
  __IO uint32_t CCR1;         /*!< TIM16 capture/compare register 1,            Address offset: 0x34 */
       uint32_t RESERVED1;    /*!< Reserved,                                    Address offset: 0x38 */
       uint32_t RESERVED2;    /*!< Reserved,                                    Address offset: 0x3C */
       uint32_t RESERVED3;    /*!< Reserved,                                    Address offset: 0x40 */
  __IO uint32_t BDTR;         /*!< TIM16 breakand dead-time register,           Address offset: 0x44 */
  __IO uint32_t DCR;          /*!< TIM16 DMA control register,                  Address offset: 0x48 */
  __IO uint32_t DMAR;         /*!< TIM16 DMA address for full transfer,         Address offset: 0x4C */
  __IO uint32_t OR1_1;        /*!< TIM16 option register 1,                     Address offset: 0x50 */
       uint32_t RESERVED4;    /*!< Reserved,                                    Address offset: 0x54 */
       uint32_t RESERVED5;    /*!< Reserved,                                    Address offset: 0x58 */
       uint32_t RESERVED6;    /*!< Reserved,                                    Address offset: 0x5C */
  __IO uint32_t OR2_1;        /*!< TIM16 option register 2,                     Address offset: 0x60 */
} TIM16_TypeDef;

#define TIM16 ((TIM16_TypeDef *) TIM16_BASE)

///////////////////////////////////////////////////////////////////////////////
// Function prototypes
///////////////////////////////////////////////////////////////////////////////

void PWM_generation_initialization(void);
void PWM_generation(const int note_frequency);

#endif

