#!/bin/bash

# Define the content of the switch-audio-port script
read -r -d '' SWITCH_AUDIO_PORT_SCRIPT <<'EOF'
#!/bin/bash

#!/bin/bash

# Update these descriptions to match your device names
SPEAKER_DESC="Starship/Matisse HD Audio Controller Analog Stereo"
HEADPHONE_DESC="HyperX 7.1 Audio Analog Stereo"

# Get sinks dynamically
SINK_SPEAKERS=$(pactl list sinks | grep -B 4 -i "$SPEAKER_DESC" | grep 'Name:' | awk '{print $2}')
SINK_HEADPHONES=$(pactl list sinks | grep -B 4 -i "$HEADPHONE_DESC" | grep 'Name:' | awk '{print $2}')

# Get active ports dynamically
PORT_SPEAKERS="analog-output-lineout"
PORT_HEADPHONES="analog-output-headphones"


# Print debugging information
echo "SINK_SPEAKERS: $SINK_SPEAKERS"
echo "SINK_HEADPHONES: $SINK_HEADPHONES"
echo "PORT_SPEAKERS: $PORT_SPEAKERS"
echo "PORT_HEADPHONES: $PORT_HEADPHONES"

current_sink=$(pactl list short sinks | grep RUNNING | awk '{print $2}')

if [ "$current_sink" == "$SINK_SPEAKERS" ]; then
    new_sink="$SINK_HEADPHONES"
    pactl set-sink-port "$SINK_HEADPHONES" "$PORT_HEADPHONES"
else
    new_sink="$SINK_SPEAKERS"
    pactl set-sink-port "$SINK_SPEAKERS" "$PORT_SPEAKERS"
fi

# Set new default sink and move all audio streams to the new sink
pactl set-default-sink "$new_sink"
pactl list short sink-inputs | while read -r stream; do
    stream_id=$(echo "$stream" | awk '{print $1}')
    pactl move-sink-input "$stream_id" "$new_sink"
done
EOF

# Create the switch-audio-port file in /usr/local/bin
echo "$SWITCH_AUDIO_PORT_SCRIPT" | sudo tee /usr/local/bin/switch-audio-port > /dev/null

# Set the file permissions to make it executable
sudo chmod +x /usr/local/bin/switch-audio-port

echo "switch-audio-port script has been created and installed."
