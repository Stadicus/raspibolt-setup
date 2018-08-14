# raspibolt-setup
Automated installation for RaspiBolt

The goal of this project is to enable you to get your own Bitcoin & Lightning full node up and running as quickly as possible. Key is a completely automated setup, ideally without touching the Linux command line at all. There are different key areas to achieve that.

### Linux distribution that allows for automation  
   The setup process needs to be as trustless as possible. It is therefore helpful to start with a well-known Linux distribution and automate the setup process using public scripts that are pulled from a easily verifiable source. 
   
This solution is based on DietPi ([Website](https://dietpi.com/), [Github](https://github.com/Fourdee/DietPi)), which is completely open-source and available for wide range of single-board computers. It's very lightweight, features a heavily customizable automated  setup and allows to execute a custom scripts after setup.

**This is very much work in progress and does not work yet!**

To try it out, follow these steps:

1. Get the DietPi image for your hardware, eg. a Raspberry Pi 3  
  https://dietpi.com/#download  
  
1. Burn the image to a sdcard (16 GB is recommended)  
  https://dietpi.com/phpbb/viewtopic.php?f=8&t=9#p9
  
1. Download the file /dietpi.txt from this repo and copy it to the "boot" partition of your sdcard  
  https://github.com/Stadicus/raspibolt-setup/blob/master/dietpi.txt
  
1. Connect your Pi to the internet using a network cable, a monitor (to watch the setup beauty), insert the sdcard and power your Pi up

Setup can take up to 10 minutes. At the moment, this is just a proof-of-concept, but we're getting there.

### Other areas for an easy setup
After the base system is set up, the node needs to be configured. This is another area to work on.

* Customization scripts on operating system-level
* Usage of a PiScreen to convey the current status & install / setup progress
* Web interface for setup and continuous management of hardware / Bitcoin / Lightning components
* Connectivity / TLS certificates for backend usage
* and more...

If you'd like to help, feel free to send me a DM on Twitter [@Stadicus3000](https://twitter.com/Stadicus3000).
