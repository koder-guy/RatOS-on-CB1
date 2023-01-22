# Install RatOS on your BIGTREETECH CB1

<p>
<a href="https://os.ratrig.com"></a>
</p>

These scripts are designed to be run on a clean installation of the BIGTREETECH CB1 minimal kernel

# Instructions

You must first install the minimal kernel (the one without klipper) on your CB1 by following the instructions in the BIGTREETECH documentation here: https://github.com/bigtreetech/CB1

Then login via ssh as the initial user (username biqu password biqu) and create a pi user by running the two commands:

sudo adduser pi<br>
sudo usermod -aG sudo,tty,dialout pi

Switch to the pi user using the command:

su - pi

Clone this repository using the command:

git clone https://github.com/koder-guy/RatOS-on-CB1.git

Then finally run the main script:

cd RatOS-on-CB1
sudo ./build.sh

The full install takes a while, 15-20 minutes, and reboots at the end. When you open the RatOS web page for the first time you will see in the Machine section that the components are all showing as "Invalid". Just click the refresh button to sort that out.
