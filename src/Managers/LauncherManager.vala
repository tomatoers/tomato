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

        public signal void resume_clicked ();
        public signal void pause_clicked ();
        public signal void stop_clicked ();
        public signal void skip_clicked ();

        private Unity.LauncherEntry launcher;
        private Dbusmenu.Menuitem menu;
        private Dbusmenu.Menuitem sep;
        private Dbusmenu.Menuitem info;
        private Dbusmenu.Menuitem resume;
        private Dbusmenu.Menuitem pause;
        private Dbusmenu.Menuitem stop;
        private Dbusmenu.Menuitem skip;

        public LauncherManager () {
            launcher = Unity.LauncherEntry.get_for_desktop_id ("tomato.desktop");
            setup_menus ();
            set_pause (paused);
            next_status ();
            connect_signals ();
        }

        public void set_pause (bool topause = true) {
            if (topause) {
                resume.property_set_bool ("enabled", true);
                pause.property_set_bool ("enabled", false);
                stop.property_set_bool ("enabled", false);
            } else {
                resume.property_set_bool ("enabled", false);
                pause.property_set_bool ("enabled", true);
                stop.property_set_bool ("enabled", true);
            }
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

            launcher.progress = 1 - saved.countdown / duration;
            info.property_set ("label", work.formatted_countdown ());
        }

        public void show_progress () {
            launcher.progress_visible = true;
            message ("Progress bar is visible");
        }

        public void hide_progress () {
            launcher.progress_visible = false;
            message ("Progress bar is hidden");
        }

        private void setup_menus () {
            info = new Dbusmenu.Menuitem ();
            info.property_set ("label", work.formatted_countdown ());
            info.property_set_bool ("enabled", false);

             /*Creates a separator between the time info and controls */
            sep = new Dbusmenu.Menuitem ();
            sep.property_set ("type", Dbusmenu.CLIENT_TYPES_SEPARATOR);

            resume = new Dbusmenu.Menuitem ();
            resume.property_set ("label", _("Resume"));

            pause = new Dbusmenu.Menuitem ();
            pause.property_set ("label", _("Pause"));

            stop = new Dbusmenu.Menuitem ();
            stop.property_set ("label", _("Stop"));

            skip = new Dbusmenu.Menuitem ();
            skip.property_set ("label", _("Skip"));

            menu = new Dbusmenu.Menuitem ();
            menu.child_append (info);
            menu.child_append (sep);
            launcher.quicklist = menu;
        }

        public void next_status () {
            if (saved.status == Status.START) {
                menu.child_delete (resume);
                menu.child_delete (pause);
                menu.child_delete (stop);
                menu.child_delete (skip);
            } else if (saved.status == Status.SHORT_BREAK || saved.status == Status.LONG_BREAK) {
                menu.child_delete (resume);
                menu.child_delete (pause);
                menu.child_delete (stop);
                menu.child_append (skip);
            } else {
                menu.child_delete (skip);
                menu.child_append (resume);
                menu.child_append (pause);
                menu.child_append (stop);
            }
            update_progress ();
        }

        private void connect_signals () {
            resume.item_activated.connect (() => {resume_clicked ();});
            pause.item_activated.connect (() => {pause_clicked ();});
            stop.item_activated.connect (() => {stop_clicked ();});
            skip.item_activated.connect (() => {skip_clicked ();});
        }
    }
}
