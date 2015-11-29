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

namespace Tomato.Util {

    public class Timer {

        private struct Time {
            int hours;
            int minutes;
        }

        private int current_time; //in minutes
        private string[] hours = {"", N_("hour"), N_("hours")};
        private string[] mins = {"", N_("minute"), N_("minutes")};

        public Timer () {
            set_current_time (0);
        }

        public void set_current_time (int time) {
            current_time = time;
        }

        public int get_current_time () {
            return current_time;
        }

        public string get_current_ftime () {
            var t = parse_time (current_time);

            int hour_index = t.hours == 0 || t.hours == 1 ? t.hours : 2;
            int minute_index = t.minutes == 0 || t.minutes == 1 ? t.minutes : 2;

            string time_label = t.hours == 0 ? "" : "%d %s".printf (t.hours, _(hours[hour_index]));
            time_label += time_label != "" && t.minutes != 0 ? _(" and ") : "";
            time_label += t.minutes == 0 ? "" : "%d %s".printf (t.minutes, _(mins[minute_index]));

            return time_label;
        }

        public int tick () {
            set_current_time (current_time + 1);
            return current_time;
        }

        private Time parse_time (int time) {
            var t = Time ();
            t.hours = time / 60;
            t.minutes = time %= 60;
            return t;
        }
    }
}
