#!/usr/bin/env python3
# Copyright (c) 2019 The PIVX Developers
# Distributed under the MIT software license, see the accompanying
# file COPYING or http://www.opensource.org/licenses/mit-license.php.
'''
Run this script from the root of the repository to update all translations from
transifex.
It will do the following automatically:

- fetch all translations using the tx tool
- post-process them into valid and committable format
'''

import subprocess
import re
import sys
import os
import io
import xml.etree.ElementTree as ET

# Name of transifex tool
TX = 'tx'
XCB = 'xcodebuild'
# Name of source language file
SOURCE_LANG = 'en.xliff'
# Directory with locale files
LOCALE_DIR = 'contrib/transifex'
PROJ_FILE = 'PivxWallet.xcodeproj'

def check_at_repository_root():
    if not os.path.exists('.git'):
        print('No .git directory found')
        print('Execute this script at the root of the repository', file=sys.stderr)
        sys.exit(1)

def fetch_all_translations():
    if subprocess.call([TX, 'pull', '-f', '-a', '--minimum-perc=20']):
        print('Error while fetching translations', file=sys.stderr)
        sys.exit(1)

def all_xliff_files(suffix=''):
    for filename in os.listdir(LOCALE_DIR):
        # process only language files
        if not filename.endswith('.xliff'+suffix) or filename == SOURCE_LANG+suffix:
            continue
        if suffix: # remove provided suffix
            filename = filename[0:-len(suffix)]
        filepath = os.path.join(LOCALE_DIR, filename)
        yield(filename, filepath)

def postprocess_translations():
    for (filename,filepath) in all_xliff_files():
        if filename == SOURCE_LANG:
            continue

        print('Importing ' + filename + ' (' + filepath + ')')
        if subprocess.call([XCB, '-importLocalizations', '-localizationPath', filepath, '-project', PROJ_FILE]):
            print('Error while importing to XCode', file=sys.stderr)
            sys.exit(1)


if __name__ == '__main__':
    check_at_repository_root()
    fetch_all_translations()
    postprocess_translations()