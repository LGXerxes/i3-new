#!/bin/bash

# Get list of sinks
sinks=$(pactl list short sinks | awk '{print $1}')
# active_sink=$(pactl info | grep "Default Sink" | awk '{print $3}' | cut -d'.' -f2)
active_sink=$(pactl info | grep "Default Sink" | awk '{print $3}')

# Convert the sinks to array and the full sink names to another array
sink_array=($sinks)
sink_name_array=($(pactl list short sinks | awk '{print $2}'))

active_index=-1

# Find the index of the active sink using its name
for i in "${!sink_name_array[@]}"; do
   if [[ "${sink_name_array[$i]}" = "${active_sink}" ]]; then
       active_index=$i
       break
   fi
done


# Calculate next sink index
next_index=$(( (active_index + 1) % ${#sink_array[@]} ))
next_sink=${sink_array[$next_index]}

# Set the next sink as default
pactl set-default-sink $next_sink

# Move all playing streams to the next sink
pactl list short sink-inputs | awk '{print $1}' | while read line; do
    pactl move-sink-input $line $next_sink
done

echo "All sinks: ${sink_array[@]}"
echo "All sink names: ${sink_name_array[@]}"
echo "Active sink: $active_sink"
echo "Active index: $active_index"
echo "Next index: $next_index"
