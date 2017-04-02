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

    public class WorkManager {

        private Util.Countdown countdown;
        private Util.Timer total_time;

        int ticks = 1;

        public WorkManager () {
            countdown = new Util.Countdown ();
            total_time = new Util.Timer ();

            if (!saved.is_date_today () && preferences.reset_work_everyday) {
                reset ();
            } else {
                set_countdown (saved.countdown);
                set_total_time (saved.total_time);
            }
            saved.update_date ();
        }

        public int raw_countdown () {
            return countdown.get_current_time ();
        }

        public string formatted_countdown () {
            return countdown.get_current_ftime ();
        }

        public string formatted_total_time () {
            return total_time.get_current_ftime ();
        }

        public void start () {
            set_status (Status.POMODORO);
        }

        public void stop () {
            set_status (Status.START);
            message ("New status -> Start");
        }

        public void tick () {
            saved.countdown = countdown.tick ();

            if (saved.status == Status.POMODORO) {
                if (ticks == 60) {
                    saved.total_time = total_time.tick ();
                    ticks = 1;
                    message ("+1 minute worked");
                } else {
                    ticks += 1;
                }
            }
        }

        public void set_status (Status status) {
            saved.status = status;
        }

        public bool time_is_over () {
            bool is_over = countdown.is_over ();
            if (is_over) {
                if (saved.status == Status.POMODORO)
                    saved.pomodoro_count += 1;
                update_status ();
                reset_countdown ();
            }
            return is_over;
        }

        public void reset () {
            stop ();
            ticks = 1;

            reset_countdown ();
            set_total_time (0);

            saved.pomodoro_count = 0;
        }

        public void reset_countdown () {
            switch (saved.status) {
            case Status.START:
            case Status.POMODORO:
                set_countdown (settings.pomodoro_duration * 60);
                break;
            case Status.SHORT_BREAK:
                set_countdown (settings.short_break_duration * 60);
                break;
            case Status.LONG_BREAK:
                set_countdown (settings.long_break_duration * 60);
                break;
            }

            /*if (preferences.debug_mode) {
                set_countdown (10);
            }*/
        }

        private void set_countdown (int time) {
            countdown.set_current_time (time);
            saved.countdown = time;
        }

        private void set_total_time (int time) {
            total_time.set_current_time (time);
            saved.total_time = time;
        }

        private void update_status () {
            if (saved.status == Status.POMODORO && saved.pomodoro_count % settings.long_break_delay == 0) {
                set_status (Status.LONG_BREAK);
                message ("New status -> Long Break");
            } else if (saved.status == Status.POMODORO && saved.pomodoro_count % settings.long_break_delay != 0) {
                set_status (Status.SHORT_BREAK);
                message ("New status -> Short Break");
            } else {
                set_status (Status.POMODORO);
                message ("New status -> Pomodoro");
            }
        }

    }
}
