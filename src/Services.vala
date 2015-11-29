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
* with Hello Again. If not, see http://www.gnu.org/licenses/.
*/

namespace Tomato.Services {

    public class SavedState : Granite.Services.Settings {
        public string date {get; set;}
        public Status status {get; set;}
        public int countdown {get; set;}
        public int total_time {get; set;}
        public int pomodoro_count {get; set;}

        public bool is_date_today () {
            var dt = new DateTime.now_local ();
            return date == dt.format ("%Y-%m-%d");
        }

        public void update_date () {
            date = (new DateTime.now_local ()).format ("%Y-%m-%d");
        }

        public SavedState () {
            base ("org.pantheon.tomato.saved");
        }
    }

    public class Settings : Granite.Services.Settings {
        public int pomodoro_duration {get; set;}
        public int short_break_duration {get; set;}
        public int long_break_duration {get; set;}
        public int long_break_delay {get; set;}

        public Settings () {
            base ("org.pantheon.tomato.settings");
        }
    }

    public class Preferences : Granite.Services.Settings {
        public bool reset_work_everyday {get; set;}
        public bool pause_after_break {get; set;}
        public bool warning_notification {get; set;}
        public bool pomodoro_sound_enabled {get; set;}
        public bool animations_enabled {get; set;}
        public bool notifications_blocked {get; set;}
        public bool debug_mode {get; set;}

        public Preferences () {
            base ("org.pantheon.tomato.preferences");
        }
    }
}
