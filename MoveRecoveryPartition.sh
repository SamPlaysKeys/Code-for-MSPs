#########################
#Move Recovery Partition#
#########################
#
#Use diskpart to find current recovery partition and assign a driver letter(eg. O) to it:
#
DISKPART> list disk
DISKPART> select disk <the-number-of-disk-where-current-recovery-partition-locate>
DISKPART> list partition
DISKPART> select partition <the-number-of-current-recovery-partition>
DISKPART> assign letter=O
#
#Create an image file from current recovery partition:
#
Dism /Capture-Image /ImageFile:C:\recovery-partition.wim /CaptureDir:O:\ /Name:"Recovery"
#
#Apply the created image file to another partition(eg. N) that will become the new recovery partition:
#
Dism /Apply-Image /ImageFile:C:\recovery-partition.wim /Index:1 /ApplyDir:N:\
#
#Register the location of the recovery tools:
#
reagentc /disable
reagentc /setreimage /path N:\Recovery\WindowsRE
reagentc /enable
#
#Use diskpart to hide the recovery partition:
#For UEFI:
#
DISKPART> select volume N
DISKPART> set id="de94bba4-06d1-4d40-a16a-bfd50179d6ac"
DISKPART> gpt attributes=0x8000000000000001
DISKPART> remove
#
#For BIOS:
#
DISKPART> select volume N
DISKPART> set id=27
DISKPART> remove
#
#Reboot the computer, now the new recovery partition should be working
#
#(Optional) Delete the old recovery partition:
DISKPART> select volume O
DISKPART> delete partition override
#
#(Optional) Check if the recovery partition is working:
#
#Show the current status:
reagentc /info
#Specifies that Windows RE starts automatically the next time the system starts:
reagentc /boottore
#Reboot the computer and do your stuff in Windows RE (eg. enter CMD and run some tools)