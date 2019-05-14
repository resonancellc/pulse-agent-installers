#!/usr/bin/env python
# -*- coding: utf-8; -*-
#
# (c) 2016 siveo, http://www.siveo.net
#
# This file is part of Pulse 2, http://www.siveo.net
#
# Pulse 2 is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# Pulse 2 is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with Pulse 2; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston,
# MA 02110-1301, USA.

# coding:utf-8

import time
import re
from pathlib import Path
from SMWinservice import SMWinservice
import subprocess
import os
import psutil
import sys
import logging
import logging.handlers

log_file = os.path.join("c:\\", "Program Files", "Pulse", "var", "log", "service.log")

logger = logging.getLogger("pulseagentservice")

logger.setLevel(logging.DEBUG)

handler = logging.handlers.RotatingFileHandler(log_file, maxBytes=10485760, backupCount=2)
formatter = logging.Formatter('%(asctime)s - %(module)-10s - %(levelname)-8s %(message)s', '%d-%m-%Y %H:%M:%S')
handler.setFormatter(formatter)
logger.addHandler(handler)

class PulseAgentService(SMWinservice):
    _svc_name_ = "pulseagent"
    _svc_display_name_ = "Pulse agent"
    _svc_description_ = "Agent d'administration de poste de travail"
    isrunning = False
    isdebug = False

    def start(self):
        if "-debug" in sys.argv:
            self.isdebug = True
            logger.info("Service %s launched in debug mode"%self._svc_display_name_)
        else:
            logger.info("Service %s launched in normal mode"%self._svc_display_name_)
        self.isrunning = True

    def stop(self):
        self.isrunning = False
        logger.info("Service %s stopped" %self._svc_display_name_)
        os.system("taskkill /f /im  python.exe")
        for proc in psutil.process_iter():
            if proc.name() == PROCNAME:
                proc.kill()

    def main(self):
        i = 0
        while self.isrunning:
            batcmd ="NET START"
            result = subprocess.check_output(batcmd, shell=True)
            filter = "pulseagent"
            if not re.search(filter, result):
                if not self.isdebug:
                    os.system("C:\Python27\python.exe C:\Python27\Lib\site-packages\pulse_xmpp_agent\launcher.py -t machine")
                else:
                    os.system("C:\Python27\python.exe C:\Python27\Lib\site-packages\pulse_xmpp_agent\launcher.py -c -t machine")
            else:
                time.sleep(5)

if __name__ == '__main__':
    PulseAgentService.parse_command_line()
