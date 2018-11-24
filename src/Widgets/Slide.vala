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

namespace Tomato.Widget {

    public class Slide : Gtk.Stack {

        private List<Screen> screens;

        public signal void changed (Screen s);

        public Slide () {
            screens = new List<Screen> ();
            set_transition_duration (500);
            this.expand = true;
        }

        public void add_screen (Screen screen) {
            add_named (screen, screen.get_name ());
            screens.append (screen);
        }

        public void set_visible_screen (
            string name,
            Gtk.StackTransitionType transition = Gtk.StackTransitionType.SLIDE_LEFT
        ) {
            set_visible_child_full (name, transition);
            message (name);
            changed (find_screen (name));
        }

        public Screen? get_visible_screen () {
            return find_screen (get_visible_child_name ());
        }

        public Screen? find_screen (string name) {
            for (uint i = 0; i < screens.length (); i++) {
                if (screens.nth_data (i).get_name () == name)
                    return screens.nth_data (i);
            } return null;
        }
    }
}
