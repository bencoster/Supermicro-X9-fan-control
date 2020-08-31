r/homelab
Posted byu/drdoak66
Getting those Supermicro X9 motherboard fans under control
Tutorial
I recently picked up a Supermicro X9DRi-LN4F+ v1.20 board from eBay and quickly realized that keeping the system fans quiet was going to be a big issue, as I'm currently roommies with my server, and my ears are like delicate flowers. Prior to picking it up I read that there were working fan scripts for X9/X10/X11 boards that would, through ipmitool, allow me to set the system fans automatically to whatever I like. While those scripts seem to work for the newer boards, they didn't work for the X9 board that I have. So after some digging I ran across others with the same issue as I was having while entering the raw fan speed controls into ipmitool and with no real solution that I could find. The command was returning this error or similar:

ipmitool raw 0x30 0x70 0x66 0x01 0x00 0x24    
Unable to send RAW command (channel=0x0 netfn=0x30 lun=0x0 cmd=0x91 rsp=0xc7): Request data length invalid
Luckily after pleading with the google for what seemed like days I finally found an out of the way FAQ article on Supermicro's website that brought that sweet relief and I wanted to share it with anyone else who is having or might run into these same problems with their X9 boards.

Now this will hopefully work with other X9 Supermicro boards but I don't have any to test it with unfortuantely. Most likely it will work with other Nuvoton WPCM450 BMC based systems. I've successfully got these commands working with firmware 3.48 but it may work on other versions; no guarantees.

To get into the ipmi shell, which isn't strictly necessary.

ipmitool -I lanplus -H your IPMI IP address -U username -P 'password' shell
Raw commands can be run in place of the shell argument if you prefer and I believe it will work on baremetal without authentication.

Set all system fans to full so the BMC doesn't mess with the fan profiles.

raw 0x30 0x45 0x01 0x02 
The ending number in the hex, 2 in this case is for the "full" fan profile.

Set "Periperal Zone" to 30% fan duty cycle

raw 0x30 0x91 0x5A 0x3 0x10 0x66
Set "CPU Zone" to 40% fan duty cycle

raw 0x30 0x91 0x5A 0x3 0x11 0x4D
The 0x4D(40%) and 0x66(30%) are hex codes for a numerical range from 0-255 corresponding to the duty cycle for the fans in this zone ranging from 0-100%. In the above case 40%.

The 0x10 and 0x11 correspond to the "peripheral zone" and "CPU zone" respectively.

In my system all my case and HDD fans are in the "CPU zone" (FAN1, FAN2, etc.), CPU fans are in the "peripheral zone" (FANA FANB).

Now I'm hoping someone who is better at scripting than I will pick this up hopefully integrate it into that fancy PID based fan control script that Mr. Horton put together.

I modified the above script to work with X9 series motherboards. I've been using the script for the better half of a year and it's been rock solid. This is runnin on a Proxmox host, and will need the 'ipmitool', 'hddtemp', and 'lm-sensors' packages installed. The modified script is here, and the associated systemd unit file I'm using is here.

If this has been posted before I apologize, but putting this info out here on Reddit should at least bring more visibility to the solution for anyone who's looking for it.

Edit: Corrected link for PID fan controller script. Added my modification to the script to work with X9 motherboards. Clarified information for setting the values.
