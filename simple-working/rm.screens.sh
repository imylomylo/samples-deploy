#!/bin/bash
screen -ls | grep instance | cut -d '.' -f 1 | awk '{print $1}' | xargs kill
