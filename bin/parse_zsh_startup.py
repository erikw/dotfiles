#!/usr/bin/env python
# Source: https://bitbucket.org/kevinburke/small-dotfiles/src/a5cedb39194c92f7a34d80405bad9603932909ed/scripts/parse_zsh_startup.py?at=master&fileviewer=file-view-default

import datetime
import sys

SLOW_THRESHOLD = 7

def parse_line(raw_line):
    nonewline = raw_line.strip('\n')
    timestr, rest = nonewline.split(' ', 1)
    return int(timestr), rest

def main(filename):
    with open(filename) as f:
        count = 0
        start_time, rest = parse_line(f.readline())
        print("{since_start} {diff} {prev_line}")
        print('=' * 30)
        print("0 {line}".format(line=rest))

        prev_line = rest
        prev_line_start = start_time
        for line in f.readlines():
            count += 1
            if len(line) == 0 or line == "\n":
                continue
            if not line[0].isdigit():
                continue

            try:
                t, rest = parse_line(line)
                diff = t - prev_line_start
                if diff > SLOW_THRESHOLD:
                    print("{since_start} {diff} {prev_line}".format(
                        since_start=t-start_time, diff=diff, prev_line=prev_line))
                prev_line_start = t
                prev_line = rest
            except ValueError:
                continue

if __name__ == "__main__":
    main(sys.argv[1])
