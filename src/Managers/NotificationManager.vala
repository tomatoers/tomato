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

    public class NotificationManager {

        private Notify.Notification notification;
        private SoundManager sound;

        //constructor
        public NotificationManager () {
            Notify.init (Constants.GETTEXT_PACKAGE);
            sound = new SoundManager ();
        }

        public void show_status () {
            string summary, body;
            if (saved.status == Status.POMODORO) {
                summary = _("Pomodoro Time");
                body = _("Get back to work!");
            } else if (saved.status == Status.SHORT_BREAK) {
                summary = _("Short Break");
                body = _(break_messages[break_messages_index]);
            } else {
                summary = _("Long Break!");
                body = _(break_messages[break_messages_index]);
            }
            if (Tomato.preferences.pomodoro_sound_enabled) {
                sound.play ();
            } show (summary, body);
        }

        public void show (string summary, string? body = null) {
            try {
                if (notification == null) {
                    notification = new Notify.Notification (summary, body, Constants.GETTEXT_PACKAGE);
                } else {
                    notification.update (summary, body, Constants.GETTEXT_PACKAGE);
                }
                notification.show ();
            } catch (Error e) {
                error ("Error: %s", e.message);
            }
        }
    }
}
