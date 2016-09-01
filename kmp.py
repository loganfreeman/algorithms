#!/usr/bin/env python3
# -*- coding: utf-8 -*-

"""
Implementation of the Knuth–Morris–Pratt algorithm in Python.
This was done to insure the author's understanding of how the
algorithm works in preparation for a talk.
Basic usage:
    >>> import knuth_morris_pratt
    >>> text = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut"
    >>> pattern = "elit"
    >>> knuth_morris_pratt.kmp_find_word(text, pattern)
    51
    >>> knuth_morris_pratt.kmp_find_word(text, "foobar")
    -1
"""

import sys


def main():
    if len(sys.argv) != 3:
        print("Usage: {} <path/to/text/file> <search pattern>".format(sys.argv[0]), file=sys.stderr)
        sys.exit(1)
    path = sys.argv[1]
    pattern = sys.argv[2]
    with open(path, 'r') as f:
        text = f.read()
    pos = kmp_find_word(text, pattern)
    if pos == -1:
        print("Search pattern not found.")
    else:
        print(pos)


def kmp_find_word(text, word):
    borders = get_borders(word)
    text_position = 0
    word_position = 0
    while text_position <= len(text) - len(word):
        while text[text_position + word_position] == word[word_position]:
            word_position += 1
            if word_position == len(word):
                # Full match found
                return text_position
        text_position += (word_position - borders[word_position])
        word_position = max(0, borders[word_position])
    # No match found
    return -1


def get_borders(word):
    borders = [-1, 0]
    position = 0
    for j in range(2, len(word)):
        while (position >= 0) and (word[position] != word[j-1]):
            position = borders[position]
        position += 1
        borders.append(position)
    return borders


if __name__ == '__main__':
    main()
