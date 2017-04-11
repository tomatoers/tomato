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

namespace Tomato.Managers {

    public class LauncherManager {

        private Unity.LauncherEntry launcher;

        public LauncherManager () {
            launcher = Unity.LauncherEntry.get_for_desktop_id ("com.github.luizaugustomm.tomato.desktop");
            update_progress ();
        }


        public void update_progress () {
            double duration;
            if (saved.status == Status.SHORT_BREAK) {
                duration = settings.short_break_duration * 60.0;
            }
            else if (saved.status == Status.LONG_BREAK) {
                duration = settings.long_break_duration * 60.0;
            }
            else {
                duration = settings.pomodoro_duration * 60.0;
            }

            launcher.progress = 1 - work.raw_countdown () / duration;
        }

        public bool has_progress () {
            return launcher.progress != 0;
        }

        public void show_progress () {
            launcher.progress_visible = true;
        }

        public void hide_progress () {
            launcher.progress_visible = false;
        }

    }
}
