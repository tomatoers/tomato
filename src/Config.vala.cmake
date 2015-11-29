/* Copyright 2015 LuizAugustoMorais
*
* This file is part of Tomato.
*
* Tomato is free software: you can redistribute it
* and/or modify it under the terms of the GNU General Public License as
* published by the Free Software Foundation, either version 3 of the
* License, or (at your option) any later version.
*
* Tomato is distributed in the hope that it will be
* useful, but WITHOUT ANY WARRANTY; without even the implied warranty of
* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General
* Public License for more details.
*
* You should have received a copy of the GNU General Public License along
* with Tomato. If not, see http://www.gnu.org/licenses/.
*/

namespace Constants {
	public const string DATADIR = "@DATADIR@";
	public const string PKG_DATADIR = "@PKG_DATADIR@";
	public const string GETTEXT_PACKAGE = "@GETTEXT_PACKAGE@";
	public const string RELEASE_NAME = "@RELEASE_NAME@";
	public const string VERSION = "@VERSION@";
	public const string VERSION_INFO = "@VERSION_INFO@";
	public const string INSTALL_PREFIX = "@CMAKE_INSTALL_PREFIX@";
    public const string APP_NAME = "@APP_NAME@";
	public const string EXEC_NAME = "@EXEC_NAME@";
	public const string ICON_NAME = "@ICON_NAME@";
}

namespace Default {
	public const int POMODORO_DURATION = 25;
    public const int SHORT_BREAK_DURATION = 5;
    public const int LONG_BREAK_DURATION = 15;
    public const int LONG_BREAK_DELAY = 4;
}
