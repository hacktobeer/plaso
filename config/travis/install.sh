#!/bin/bash
#
# Script to set up Travis-CI test VM.

COVERALLS_DEPENDENCIES="python-coverage python-coveralls python-docopt";

L2TBINARIES_DEPENDENCIES="PyYAML XlsxWriter artifacts bencode binplist certifi chardet construct dateutil dfdatetime dfvfs dfwinreg dpkt efilter future hachoir-core hachoir-metadata hachoir-parser idna libbde libesedb libevt libevtx libewf libfsntfs libfvde libfwnt libfwsi liblnk libmsiecf libolecf libqcow libregf libscca libsigscan libsmdev libsmraw libvhdi libvmdk libvshadow libvslvm lzma pefile psutil pycrypto pyparsing pysqlite pytsk3 pytz pyzmq requests six urllib3 yara-python";

L2TBINARIES_TEST_DEPENDENCIES="funcsigs mock pbr";

PYTHON2_DEPENDENCIES="libbde-python libesedb-python libevt-python libevtx-python libewf-python libfsntfs-python libfvde-python libfwnt-python libfwsi-python liblnk-python libmsiecf-python libolecf-python libqcow-python libregf-python libscca-python libsigscan-python libsmdev-python libsmraw-python libvhdi-python libvmdk-python libvshadow-python libvslvm-python python-artifacts python-backports.lzma python-bencode python-binplist python-certifi python-chardet python-construct python-crypto python-dateutil python-dfdatetime python-dfvfs python-dfwinreg python-dpkt python-efilter python-future python-hachoir-core python-hachoir-metadata python-hachoir-parser python-idna python-pefile python-psutil python-pyparsing python-pysqlite2 python-pytsk3 python-requests python-six python-tz python-urllib3 python-xlsxwriter python-yaml python-yara python-zmq";

PYTHON2_TEST_DEPENDENCIES="python-mock python-tox";

PYTHON3_DEPENDENCIES="libbde-python3 libesedb-python3 libevt-python3 libevtx-python3 libewf-python3 libfsntfs-python3 libfvde-python3 libfwnt-python3 libfwsi-python3 liblnk-python3 libmsiecf-python3 libolecf-python3 libqcow-python3 libregf-python3 libscca-python3 libsigscan-python3 libsmdev-python3 libsmraw-python3 libvhdi-python3 libvmdk-python3 libvshadow-python3 libvslvm-python3 python3-artifacts python3-bencode python3-binplist python3-certifi python3-chardet python3-construct python3-crypto python3-dateutil python3-dfdatetime python3-dfvfs python3-dfwinreg python3-dpkt python3-efilter python3-future python3-idna python3-pefile python3-psutil python3-pyparsing python3-pysqlite2 python3-pytsk3 python3-requests python3-six python3-tz python3-urllib3 python3-xlsxwriter python3-yaml python3-yara python3-zmq";

PYTHON3_TEST_DEPENDENCIES="python3-mock python3-setuptools python3-tox";

# Exit on error.
set -e;

if test ${TRAVIS_OS_NAME} = "osx";
then
	git clone https://github.com/log2timeline/l2tbinaries.git -b dev;

	mv l2tbinaries ../;

	for PACKAGE in ${L2TBINARIES_DEPENDENCIES};
	do
		sudo /usr/bin/hdiutil attach ../l2tbinaries/macos/${PACKAGE}-*.dmg;
		sudo /usr/sbin/installer -target / -pkg /Volumes/${PACKAGE}-*.pkg/${PACKAGE}-*.pkg;
		sudo /usr/bin/hdiutil detach /Volumes/${PACKAGE}-*.pkg
	done

	for PACKAGE in ${L2TBINARIES_TEST_DEPENDENCIES};
	do
		sudo /usr/bin/hdiutil attach ../l2tbinaries/macos/${PACKAGE}-*.dmg;
		sudo /usr/sbin/installer -target / -pkg /Volumes/${PACKAGE}-*.pkg/${PACKAGE}-*.pkg;
		sudo /usr/bin/hdiutil detach /Volumes/${PACKAGE}-*.pkg
	done

elif test ${TRAVIS_OS_NAME} = "linux";
then
	sudo rm -f /etc/apt/sources.list.d/travis_ci_zeromq3-source.list;

	sudo add-apt-repository ppa:gift/dev -y;
	sudo apt-get update -q;

	if test ${TRAVIS_PYTHON_VERSION} = "2.7";
	then
		sudo apt-get install -y ${COVERALLS_DEPENDENCIES} ${PYTHON2_DEPENDENCIES} ${PYTHON2_TEST_DEPENDENCIES};
	else
		sudo apt-get install -y ${PYTHON3_DEPENDENCIES} ${PYTHON3_TEST_DEPENDENCIES};
	fi
fi
