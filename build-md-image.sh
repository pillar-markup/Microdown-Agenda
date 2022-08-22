#!/usr/bin/env bash

curl https://get.pharo.org/64/100 | bash
wget http://files.pharo.org/vm/pharo-spur64/Linux-x86_64/PharoVM-9.0.15-b487900-Linux-x86_64-stockReplacement-bin.zip
unzip *.zip
./pharo --headless Pharo.image eval --save ./Microdown-Agenda/load-md-agenda.st
