#!/bin/bash

# Save the image from the clipboard to a temporary file
xclip -selection clipboard -t image/png -o > /tmp/clipboard_image.png

# Convert the image to a format suitable for Tesseract
convert /tmp/clipboard_image.png -resize 300% -type Grayscale - | tesseract - - -c preserve_interword_spaces=1 | xclip -selection clipboard

# Clean up the temporary file
rm /tmp/clipboard_image.png

# Notify the user
notify-send "OCR" "Text has been extracted from the image and is now in the clipboard."
