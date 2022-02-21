# Install Easy2Boot.
# Official instructions: http://www.easy2boot.com/make-an-easy2boot-usb-drive/make-using-linux/
#
# ISOs to put on the stick:
#$ find MULTIBOOT/_ISO -name "*.iso"
#./LINUX/archlinux-2014.11.01-dual.iso
#./LINUX/ubuntu-14.04.1-desktop-amd64.iso
#./LINUX/ubuntu-14.04.1-desktop-i386.iso
#./LINUX/KNOPPIX_V7.4.2DVD-2014-09-28-EN.iso
#./LINUX/debian-7.7.0-i386-DVD-1.iso
#./LINUX/._debian-7.7.0-i386-DVD-1.iso
#./UTILITIES/systemrescuecd-x86-4.4.1.iso
#./UTILITIES/ubcd533.iso
#./UTILITIES/Hiren's.BootCD.15.2.iso



# Instructions and procedures extracted from the completely miserable script /_ISO/docs/linux_utils/fmt.sh
sudo -i
targdev=/dev/sdX
target=/media/usb_media

# Prepare disk.
fdisk $targdev	# create primary partition with W95 FAT32.
mkfs.vfat -F32 -n "MULTIBOOT" ${targdev}1
mount ${targdev}1 $target

# Download E2B.
curl -O http://url/to/easy2boot.exe # http://www.easy2boot.com/
mv easy2boot.exe easy2boot.zip
unzip easy2boot.zip

# Install GRUB.
cd easy2boot/_ISO_/docs/linux-utils
# Install grub4dos to MBR.
chmod 744 bootlace.com
./bootlace.com --time-out=0 $targdev
# Install grub4dos to PBR.
./bootlace.com --floppy=1 ${targetdev}1


# Copy over E2B files.
rsync -av easy2boot/ $target

# Copy over ISO files.
cp path/to/imgs/a-linux-dist.iso $target/_ISO/LINUX/
cp path/to/imgs/some-util.iso $target/_ISO/UTILITIES/


# Make drive contiguous.
perl ./defragfs $target -f


# Ignore file extension auto-suggestions
# http://www.easy2boot.com/add-payload-files/list-of-file-extensions-recognised-by-e2b
cat >> $target/_ISO/MyE2B.cfg
!BAT
set NOSUG=1



# Create data copy folder
mkdir -p $target/tmp


umount $target
