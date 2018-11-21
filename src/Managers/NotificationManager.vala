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

        private SoundManager sound;

        //constructor
        public NotificationManager () {
            sound = new SoundManager ();
        }

        public void show_status () {
            string title, body;
            if (saved.status == Status.POMODORO) {
                title = _("Pomodoro Time");
                body = _("Get back to work!");
            } else if (saved.status == Status.SHORT_BREAK) {
                title = _("Short Break");
                body = _(break_messages[break_messages_index]);
            } else {
                title = _("Long Break!");
                body = _(break_messages[break_messages_index]);
            }
            if (Tomato.preferences.pomodoro_sound_enabled) {
                sound.play ();
            }
            show (title, body);
        }

        public void show (string title, string body) {
            var notification = new Notification (title);
            notification.set_body (body);
            var image = new Gtk.Image.from_icon_name ("tomato", Gtk.IconSize.DIALOG);
            notification.set_icon (image.gicon);
            GLib.Application.get_default ().send_notification ("com.github.tomatoers.tomato", notification);
        }
    }
}
