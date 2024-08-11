# Overview
This repository contains the implementation for Lab 4 of the CPEN 311 course at the University of British Columbia. In this lab, I designed and implemented an RC4 decryption circuit, gained experience working with on-chip memory, and performed a brute-force attack to crack encrypted messages.

# Project Structure
The lab consists of three main tasks:

**Task 1:** Creating a Memory, Instantiating it, and Writing to it
Created a 256x8 RAM using the Megafunction Wizard and implemented an algorithm to initialize this memory. The memory contents were verified using the In-System Memory Content Editor.

**Task 2:** Building a Single Decryption Core
This task involved building an RC4 decryption core using the memory created in Task 1. The core takes a 24-bit key from the board's switches and decrypts a 32-byte encrypted message stored in ROM. The decrypted message is stored in another RAM, and the contents are verified to ensure correct decryption.

**Task 3:** Cracking RC4
In this task, the decryption circuit was modified to perform a brute-force attack on an encrypted message. The circuit cycles through all possible keys until it successfully decrypts the message. The cracked key is displayed on the 7-segment display, and the decrypted message is stored in RAM.

# Testing
- **Memory Verification:** Use the In-System Memory Content Editor to check the contents of the RAMs at various stages.
- **Decryption Validation:** Test with different encrypted messages and keys to ensure accurate decryption.
- **Brute-Force Validation:** Ensure that the circuit can correctly identify and decrypt messages without prior knowledge of the key.

# Conclusion
This lab provided practical experience with digital design, focusing on memory utilization and FSMs, while also exploring the security implications of cryptographic algorithms. The modular design approach and incremental testing ensured a robust implementation of the RC4 decryption and cracking circuit.
