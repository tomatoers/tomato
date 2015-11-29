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

    public class Screen : Gtk.Frame {

        private Gtk.Box elements;
        private Gtk.Box progress_box;
        private Gtk.ButtonBox control_box;

        public Screen (string name) {
            this.name = name;

            elements = new Gtk.Box (Gtk.Orientation.VERTICAL, 0);
            progress_box = new Gtk.Box (Gtk.Orientation.VERTICAL, 0);
            control_box = new Gtk.ButtonBox (Gtk.Orientation.HORIZONTAL);

            setup_control_box ();
            setup_elements ();

            add (elements);
            set_shadow_type (Gtk.ShadowType.NONE);
        }

        public string get_name () {
            return name;
        }

        public void add_progress (Gtk.Label countdown, Gtk.Label total_time) {
            clear_progress (countdown);
            progress_box.pack_start (countdown);
            countdown.show ();

            clear_progress (total_time);
            progress_box.pack_start (total_time);
            total_time.show ();
        }

        public void add_control (Gtk.Widget control) {
            control_box.add (control);
        }

        public void add_controls (Gtk.Widget[] controls) {
            foreach (Gtk.Widget control in controls) {
                control_box.add (control);
            }
        }

        private void clear_progress (Gtk.Label progress) {
            var progress_parent = progress.get_parent ();
            if (progress_parent != null) {
                progress_parent.remove (progress);
            }
        }

        private void setup_elements () {
            elements.set_border_width (12);
            elements.pack_start (progress_box);
            elements.pack_start (control_box);
        }

        private void setup_control_box () {
            control_box.set_layout (Gtk.ButtonBoxStyle.CENTER);
            control_box.set_spacing (6);
            control_box.set_border_width (12);
        }
    }
}
