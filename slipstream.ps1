<#
   Script gemaakt door Marijn Deijnen
   
   Finished ISO komt in het ISO\slipstream mapje dat het aanmaakt.
   
   Last updated: 18-3-2019
#>

<# dit veranderen naar jou bestand namen namen i.p.v. update 1/2 #>
$update_name_ssu = "windows10.0-kb4485447-x64_e9334a6f18fa0b63c95cd62930a058a51bba9a14.msu" 
$update_name_cumu = "windows10.0-kb4485447-x64_e9334a6f18fa0b63c95cd62930a058a51bba9a14.msu"

$desktop_update1_ssu = "C:\Users\$env:username\Desktop\$update_name_ssu"
$desktop_update2_cumu = "C:\Users\$env:username\Desktop\$update_name_cumu"

$update1 = "C:\Users\$env:username\Desktop\ISO\updates\$update_name_ssu"
$update2 = "C:\Users\$env:username\Desktop\ISO\updates\$update_name_cumu"

$path = "C:\Users\$env:username\Desktop\ISO"
$mountpath = "C:\Users\$env:username\Desktop\ISO\Slipstream\mount"
$wimfile = "C:\Users\$env:username\Desktop\ISO\Slipstream\original\sources\install.wim"
$updatesfolder = "C:\Users\$env:username\Desktop\ISO\updates"
$progress = "C:\Users\$env:username\Desktop\slipstream\progress.txt"
$iso_date = Get-Date -Format m

Clear-Content $progress
if(!(test-path -Path $path)){
	mkdir $path
	cd $path
	mkdir slipstream
	mkdir updates
	cd slipstream
	mkdir original
	mkdir mount
	echo "Created folders" | Out-File -append $progress
}

echo "Copying updates to the \updates\ folder."
<#copy-item -path $desktop_update0_net -destination $updatesfolder#>
copy-item -path $desktop_update1_ssu -destination $updatesfolder
copy-item -path $desktop_update2_cumu -destination $updatesfolder


Mount-DiskImage C:\Users\$env:username\Desktop\Windows_ISO.iso

<# Hier E:\ naar het volgende letter aanpassen als de E:\ al in gebruik is #>
cd C:\Windows\System32
.\Robocopy /s /e E:\ $path\slipstream\original
Dismount-DiskImage C:\Users\$env:username\Desktop\Windows_ISO.iso

echo "Finished copying" | Out-File -append $progress

Write-Host "continuing in 5s"
Start-Sleep -s 5


.\dism /Get-WIMInfo /wimfile:$wimfile
echo "Welke index wil je gebruiken?"
$index = Read-Host

Set-ItemProperty $wimfile -Name IsReadOnly -Value $false

<#
	Adding Service Stack
#>
echo "Mounting WIM"
.\Dism /mount-wim /wimfile:$wimfile /mountdir:$mountpath /index:$index
echo "Finished mounting (16% completed)" | Out-File -append $progress
Get-Date -Format r | Out-File -append $progress

echo "Adding package(s)"
.\Dism /add-package /image:$mountpath /Packagepath:$update1 /LogPath=$path\SSU.log
echo "Added Service Stack package (33% completed)" | Out-File -append $progress
Get-Date -Format r | Out-File -append $progress

echo "Removing out-dated files"
.\Dism /image:$mountpath /cleanup-image /StartComponentCleanup /ResetBase
echo "Removed out-of-date files (50% completed)" | Out-File -append $progress
Get-Date -Format r | Out-File -append $progress

<#
	Adding Cumulative
#>

echo "Adding package(s)"
.\Dism /add-package /image:$mountpath /Packagepath:$update2 /LogPath=$path\CU.log
echo "Added Cumulative package (66% completed)" | Out-File -append $progress
Get-Date -Format r | Out-File -append $progress

echo "Removing out-dated files"
.\Dism /image:$mountpath /cleanup-image /StartComponentCleanup /ResetBase
echo "Removed out-of-date files (83% completed)" | Out-File -append $progress
Get-Date -Format r | Out-File -append $progress

echo "Unmounting image"
.\Dism /unmount-image /mountdir:$mountpath /commit 
echo "Finished mounting (100% completed)" | Out-File -append $progress
Get-Date -Format r | Out-File -append $progress

Write-Host "Making the ISO in 5s"
Start-Sleep -s 5

<#
	Maakt ISO via OSCDIMG
#>

cd "C:\Program Files (x86)\Windows Kits\10\Assessment and Deployment Kit\Deployment Tools\amd64\oscdimg"
.\oscdimg.exe -m -o -u2 -udfver102 -bootdata:2#p0,e,bC:\Users\$env:username\Desktop\ISO\slipstream\original\boot\etfsboot.com#pEF,e,bC:\Users\$env:username\Desktop\ISO\slipstream\original\efi\microsoft\boot\efisys.bin C:\Users\$env:username\Desktop\ISO\slipstream\original C:\Users\$env:username\Desktop\ISO\slipstream\WinServer2016x64_$iso_date.iso

echo "Finished, closing in 60 seconds or you can close it manually"








