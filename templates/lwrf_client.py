import sys
import pigpio
import lightwaverf.lwrf
 
# This is a simple test class for the lwrf and pigpiod programs.
 
# The GPIO pin on the Pi you've connected the transmitter to.
# You probably need to change this!
gpio_pin = {{ gpio_pin }}
 
# How often to repeat the signal, 3 seems to be OK.
repeat = 3
 
# An ID that must be unique for each dimmer. 
id = {{ lwrf_dimmer_id }}
 
pi = pigpio.pi() # Connect to GPIO daemon.
tx = lightwaverf.lwrf.tx(pi, gpio_pin)
 
# this should be between 0 and 32
value = int(sys.argv[1])
 
if (value == 0):
  tx_val = 64 # according to the LightwaveRF docs, when turning off, this should be 64.
  c = 0 # "command" setting i.e. on/off
else:
  tx_val = value + 128
  c = 1
 
a = tx_val >> 4 # first 4 bits
b = tx_val % 16 # last 4 bits
data = [a, b, 0, c, 15, id, 0, 0, 0, 0]
tx.put(data, repeat)
print("Sent " + str(value))
tx.cancel();
pi.stop();

