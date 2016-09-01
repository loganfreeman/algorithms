#!/usr/bin/env python3
# -*- coding: utf-8 -*-

"""
Implementation of the Boyer–Moore algorithm in Python.
This was done to insure the author's understanding of how the
algorithm works in preparation for a talk.
Basic usage:
    >>> import boyer_moore
    >>> text = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut"
    >>> pattern = "elit"
    >>> boyer_moore.bm_find_word(text, pattern)
    51
    >>> boyer_moore.bm_find_word(text, "foobar")
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
    pos = bm_find_word(text, pattern)
    if pos == -1:
        print("Search pattern not found.")
    else:
        print(pos)


def bm_find_word(text, word):
    occurence = get_occurence(word)
    good_suffix_shift = get_good_suffix_shift(word)
    text_position = 0
    word_position = len(word) - 1
    while text_position <= len(text) - len(word):
        while text[text_position + word_position] == word[word_position]:
            if word_position == 0:
                # full match found
                return text_position
            word_position -= 1
        text_position += get_offset(word_position, text_position, text, occurence,
                                    good_suffix_shift)
        word_position = len(word) - 1
    # no match found
    return -1


def get_occurence(pattern):
    shift = {}
    index = 0
    for letter in pattern:
        shift[letter] = index
        index += 1
    return shift


def get_bad_character_shift(bad_character, occurence, word_position):
    if bad_character not in occurence:
        occ = -1
    else:
        occ = occurence[bad_character]
    shift = word_position - occ
    return shift


def get_good_suffix_shift(pattern):
    shift_table = [len(pattern)] * len(pattern)
    pattern_border_lengths = [-1, 0]
    position = 0
    # part 1: shift <= suffix_length
    for suffix_length in range(2, len(pattern) + 1):
        while (position >= 0) and \
                (pattern[len(pattern) - position - 1] != pattern[len(pattern) - suffix_length]):
            shift = suffix_length - position - 1
            shift_table[len(pattern) - position - 1] = min(shift_table[len(pattern) - position - 1], shift)
            position = pattern_border_lengths[position]
        position += 1
        pattern_border_lengths.append(position)
    # part 2: shift > suffix_length
    suffix_length = 0
    borders = get_borders(pattern)
    position = borders[len(pattern)]
    while position >= 0:
        shift = len(pattern) - position
        while suffix_length < shift:
            shift_table[suffix_length] = min(shift_table[suffix_length], shift)
            suffix_length += 1
        position = borders[position]
    return shift_table


def get_borders(word):
    borders = [-1, 0]
    position = 0
    for j in range(2, len(word) + 1):
        while (position >= 0) and (word[position] != word[j-1]):
            position = borders[position]
        position += 1
        borders.append(position)
    return borders


def get_offset(word_position, text_position, text, occurence, good_suffix_shift):
    bad_character = text[text_position + word_position]
    gs = good_suffix_shift[word_position]
    bc = get_bad_character_shift(bad_character, occurence, word_position)
    return max(gs, bc)

if __name__ == '__main__':
    main()
