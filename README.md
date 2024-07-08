# PUF-based Cipher ASIC

This chip implements a Physical Unclonable Function (PUF) based cipher that encodes a set of characters.

## What the Chip Does

1. Stores a secret phrase.

2. Implements a simple PUF using ring oscillator simulators (counters).

3. Encodes characters from the phrase using the PUF response.

4. Outputs the encoded character and part of the PUF response.

## How to Decode

To decode the message hidden in this chip, you would need to:

1. Manufacture the chip: The PUF behavior is unique to each manufactured instance of the chip.

2. Characterize the PUF:
   - Apply different 4-bit challenge inputs to the chip.
   - Record the PUF responses for each challenge.
   - Create a lookup table or model of the chip's unique behavior.

3. Decode the output:
   - For each encoded character output:
     a. Note the current challenge input
     b. Look up the expected PUF response for that challenge
     c. XOR the encoded character with the PUF response to recover the original character

4. Assemble the decoded characters to reveal the secret phrase.
