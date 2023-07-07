// motor.h

#include "pico/stdlib.h"

struct motor_type{
  uint pwm;
  uint dir;
  uint slice;
  uint chan;
  uint speed;
  uint freq;
  uint resolution;
  bool on;};

void motorInit(struct motor_type *m, uint, uint, uint);
void motorOn(struct motor_type *m);
void motorOff(struct motor_type *m);
void motorMove(struct motor_type *m, uint, uint);
void motorStop(struct motor_type *m);

