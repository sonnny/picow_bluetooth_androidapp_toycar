// motor.c

#include "pico/stdlib.h"
#include "hardware/pwm.h"
#include "motor.h"

uint32_t pwm_set_freq_duty(uint slice_num, uint chan, uint32_t f, int d){
  uint32_t clock = 125000000;
  uint32_t divider16 = clock / f / 4096 + (clock % (f * 4096) != 0);
  if (divider16 / 16 == 0) divider16 = 16;
  uint32_t wrap = clock * 16 / divider16 / f - 1;
  pwm_set_clkdiv_int_frac(slice_num, divider16 / 16, divider16 & 0xF);
  pwm_set_wrap(slice_num, wrap);
  pwm_set_chan_level(slice_num, chan, wrap * d / 100);
  return wrap;}

uint32_t pwm_get_wrap(uint slice_num){
  valid_params_if(PWM, slice_num >= 0 && slice_num < NUM_PWM_SLICES);
  return pwm_hw->slice[slice_num].top;}

void pwm_set_duty(uint slice_num, uint chan, int d){
  pwm_set_chan_level(slice_num, chan, pwm_get_wrap(slice_num) * d / 100);}

void motorInit(struct motor_type *m, uint pwm, uint dir, uint freq){
  gpio_set_function(pwm, GPIO_FUNC_PWM);
  m->pwm = pwm;
  m->slice = pwm_gpio_to_slice_num(pwm);
  m->chan = pwm_gpio_to_channel(pwm);
  m->dir = dir;
  gpio_init(m->dir);
  gpio_set_dir(m->dir, GPIO_OUT);
  gpio_put(m->dir, 0);
  m->freq = freq;
  m->speed = 0;
  m->resolution = pwm_set_freq_duty(m->slice, m->chan, m->freq, m->speed);
  m->on = false;}

void motorSpeed(struct motor_type *m, uint s){
  pwm_set_duty(m->slice, m->chan, s);
  m->speed = s;}

void motorOn(struct motor_type *m){
  pwm_set_enabled(m->slice, true);
  m->on = true;}
  
void motorOff(struct motor_type *m){
  pwm_set_enabled(m->slice, false);
  m->on = false;}

void motorMove(struct motor_type *m, uint speed, uint direction){
  gpio_put(m->dir, direction);
  motorSpeed(m, speed);}
  
void motorStop(struct motor_type *m){
  motorSpeed(m, 0);}
  

  

