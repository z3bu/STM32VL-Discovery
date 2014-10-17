#include "stm32f10x.h"

/**
   @brief  Enable clocking on various system peripheral devices
   @params None
   @retval None
**/

void RCC_init()
{
  /* enable clocking on Port C */
  RCC_APB2PeriphClockCmd(RCC_APB2Periph_GPIOC, ENABLE);
}

void Setup(void)
{
  GPIO_InitTypeDef GPIOC_init_params;

  RCC_init();

  /* Blue LED sits on PC[8] and Green LED sits on PC[9]*/
  GPIOC_init_params.GPIO_Pin = GPIO_Pin_8 | GPIO_Pin_9;
  /* Output maximum frequency selection is 10 MHz.
     Do not worry that internal oscillator of STM32F100RB
     works on 8MHz frequency - Cortex-M3 core has a various
     facilities to carefully tune the frequency for almost
     peripheral devices.
  */
  GPIOC_init_params.GPIO_Speed = GPIO_Speed_10MHz;
  /* Push-pull output  */
  GPIOC_init_params.GPIO_Mode = GPIO_Mode_Out_PP;
  GPIO_Init(GPIOC, &GPIOC_init_params);
}

int main(void)
{
	int i=0;
	while (1)
	{
		/* Set pins 8 and 9 at PORTC to high level */
		GPIO_SetBits(GPIOC, GPIO_Pin_8);
		GPIO_SetBits(GPIOC, GPIO_Pin_9);
		while(i<0xFFFFE)
		{
			i++;
		}
		i=0;
		GPIO_ResetBits(GPIOC, GPIO_Pin_8);
		GPIO_ResetBits(GPIOC, GPIO_Pin_9);		
		while(i<0xFFFFE)
		{
			i++;
		}
		i=0;
	}
}
