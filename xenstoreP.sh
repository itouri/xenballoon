#!/bin/sh
xenstore-chmod / n0 b1 b2 b3 b4
xenstore-chmod /tool -r n0 b1 b2 b3 b4
xenstore-chmod /vm -r n0 b1 b2 b3 b4
xenstore-chmod /local -r n0 b1 b2 b3 b4
