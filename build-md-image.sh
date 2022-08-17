#!/usr/bin/env bash

curl https://get.pharo.org/64/100+vm | bash
./pharo Pharo.image eval --save load-md-agenda.st
