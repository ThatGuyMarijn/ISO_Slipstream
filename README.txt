Microsoft Catalogus: https://www.catalog.update.microsoft.com/Home.aspx
Download hier de Servicing Stack & Culumatieve update voor je gewenste Windows versie.
LET OP: Als je de updates download voor Windows Server zie je 3 soorten, 1709, 1803 en een zonder nummer, pak de download zonder een nummer want 1709,1803 zijn alleen core installaties dus geen GUI.

Windows ADK: https://docs.microsoft.com/en-us/windows-hardware/get-started/adk-install
Download ook even Windows ADK zodat wij de benodigde .\dism & .\oscdimg commando's krijgen

Dingen die je moet doen voordat je het script kan starten: 

-Zorg dat het mapje slipstream op je bureaublad staat.

-Hernoem je Windows ISO naar Windows_ISO.iso

-Plaats beide updates op je Bureablad.

-Hernoem $update_name_ssu & $update_name_cumu in het script naar de juiste naam.

-Als laatste; soms als je de script runned kan hij de ISO tijdens het mounten de verkeerde schijfletter geven dus bijvoorbeeld D:\ herstart het script, hij heeft hem automatisch geunmount als hij verkeerd was.
 De juiste schijfletter is E:\ - Helaas had ik geen commando gevonden waarmee je een schijfletter kon aangeven.


LET OP: Is de letter E:\ niet beschikbaar op je PC? Dan zul je de schijfletter moeten aanpassen in het script naar het eerst volgende letter dat hij zal gebruiken.


-Als je dit allemaal gedaan hebt start je run_slipstream.bat en dan wordt alles vanzelf gedaan.
De ISO wordt opgeslagen in Desktop\ISO\Slipstream


EXTRA: in het mapje Slipstream wat je gedownload hebt krijg je een progress.txt hier kun je zien hoe ver het script is.

Marijn Deijnen
18-4-2019

