#!/usr/bin/env python3
# Copyright (c) 2019 The PIVX Developers
# Distributed under the MIT software license, see the accompanying
# file COPYING or http://www.opensource.org/licenses/mit-license.php.
'''
Run this script from the root of the repository to update the english source
translation file for uploading to transifex.

The following actions will be performed:
- update/add storyboard english strings
- update/add source code english strings
- use XCode to export a default en.xliff file (dirty, contains dummy strings)
- use lxml to sanitize the exported en.xliff file
  - removes untranslated InfoPlist.strings files
  - removes strings marked as dummies with the #bc-ignore! tag

The resulting sanitized file is located in contrib/transifex/en.xliff

This script requires the following programs to be installed:
- XCode
- bartycrouch

And requires the following 3rd party python package:
- lxml
'''

import subprocess
import re
import sys
import os
import io
import lxml.etree as le

# Program Names
XCB = 'xcodebuild'
BC = 'bartycrouch'
XMS = 'xmlstarlet'

# Directory with locale files
LOCALE_DIR = 'contrib/transifex'
SOURCE_XLIFF = LOCALE_DIR + '/en.xcloc/Localized Contents/en.xliff'
# Project file
PROJ_FILE = 'PivxWallet.xcodeproj'


def check_at_repository_root():
    if not os.path.exists('.git'):
        print('No .git directory found')
        print('Execute this script at the root of the repository', file=sys.stderr)
        sys.exit(1)


def update_strings():
    if subprocess.call([BC, 'update', '-v']):
        print('Error updating strings')
        sys.exit(1)


def export_dirty():
    '''Uses XCode to export a dirty XLIFF file containing all translatable strings'''
    if subprocess.call([XCB, '-exportLocalizations', '-localizationPath', LOCALE_DIR, '-project', PROJ_FILE]):
        print('Error while exporting from XCode', file=sys.stderr)
        sys.exit(1)


def sanitize_file():
    '''Uses lxml to sanitize the exported XLIFF file'''
    with open(SOURCE_XLIFF, 'r') as f:
        doc = le.parse(f)
        for elem in doc.xpath('//*[attribute::original]'):
            if elem.attrib['original'].find('InfoPlist.strings') == -1:
                continue
            else:
                parent = elem.getparent()
                parent.remove(elem)

        for elem in doc.iter("{*}trans-unit"):
            if 'bc-ignore' in elem[1].text:
                parent = elem[1].getparent()
                grandparent = parent.getparent()
                grandparent.remove(parent)

        doc.write(LOCALE_DIR + '/en.xliff')


if __name__ == '__main__':
    check_at_repository_root()
    update_strings()
    export_dirty()
    sanitize_file()
