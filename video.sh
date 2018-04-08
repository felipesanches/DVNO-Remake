#!/bin/bash
ffmpeg -r 30 -pattern_type glob -i '*.png' output.mp4
