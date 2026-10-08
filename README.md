# YARA + ClamAV Detection

Writing a YARA rule to detect a malicious Office document and running it through ClamAV. Part of the CYB2100 Cyber Defense exam at Kristiania.

## Overview

The scenario gave me a password-protected ZIP containing a Word document with a malicious VBA macro. Because the archive was encrypted and the container could be changed easily, a signature based on the file wrapper would be fragile. The macro held the actual payload, so that was the most reliable place to detect on.

## What I did

- Opened and decrypted the delivery email, then unlocked the document with the password from the message
- Analysed the document with **oletools** (`oleid`, `olevba`) and confirmed it contained VBA macros acting as a loader
- Wrote a **YARA rule** targeting the distinctive strings in the macro: the `ShellExecuteA` and `URLDownloadToFileA` declarations, the download URL, the dropped file path, and the `Sub Document_Open()` auto-run trigger
- Scanned the sample with **ClamAV** (`clamscan -d`) using the custom rule and confirmed a clean detection

## Why detect on the macro

The macro is what carries the harm, so a rule built on its contents holds up even if the attacker re-packages or re-encrypts the file. Matching on multiple independent strings (`all of`) keeps false positives down while staying robust to small changes.

## Tools & concepts

YARA · ClamAV · oletools (oleid, olevba) · VBA macro analysis · signature design

## What I took from it

Writing a rule myself made the trade-off clear: detect too specifically and you miss the next variant, too loosely and you drown in false positives. Anchoring on the behaviour that actually does the damage is the sweet spot.
