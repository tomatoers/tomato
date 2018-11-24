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

namespace Tomato.Window {

    public class PreferencesDialog : Gtk.Dialog {

        //stacks
        private Gtk.Stack         stack;
        private Gtk.StackSwitcher stackswitcher;

        //options - scales
        private Widget.ValueRange pomodoro_scale;
        private Widget.ValueRange short_break_scale;
        private Widget.ValueRange long_break_scale;
        private Widget.ValueRange long_break_delay_scale;

        //options - switches
        private Gtk.Switch reset_work_everyday;
        private Gtk.Switch pause_after_break;
        private Gtk.Switch auto_stop_enabled;
        private Gtk.Switch pomodoro_sound_enabled;
        private Gtk.Switch debug_switch;

        //options - button
        private Gtk.Button reset_timings;
        private Gtk.Button reset_work;

        //signals
        public signal void reset_work_clicked ();
        public signal void pomodoro_changed ();
        public signal void short_break_changed ();
        public signal void long_break_changed ();
        public signal void long_break_delay_changed ();

        //constructor
        public PreferencesDialog (Gtk.Window? parent) {
            //if parent window provided, make that the parent of this Dialog
            if (parent != null) {
                set_transient_for (parent);
            }

            //some dialog settings
            title = _("Preferences"); //set title
            set_resizable (false); //make dialog non-resizable
            set_deletable (false); //make dialog non-deletable
            set_modal (true);

            //instantiate stack objects

            stack = new Gtk.Stack ();
            stackswitcher = new Gtk.StackSwitcher ();

            stackswitcher.set_stack (stack);
            stackswitcher.set_halign (Gtk.Align.CENTER);

            bind_and_init_options ();
            create_ui ();
            update_timing_sensitivity ();
            update_work_sensitivity ();
            connect_signals ();
        }

        private void bind_and_init_options () {
            /* ** options - scales ** */
            //pomodoro_scale = new Gtk.Scale.with_range (Gtk.Orientation.HORIZONTAL, 5, 60, 1);
            pomodoro_scale = new Widget.ValueRange (5, 60, 1, _("minute"), _("minutes"));
            settings.schema.bind ("pomodoro-duration", pomodoro_scale, "current-value", SettingsBindFlags.DEFAULT);

            short_break_scale = new Widget.ValueRange (1, 10, 1, _("minute"), _("minutes"));
            settings.schema.bind ("short-break-duration", short_break_scale, "current-value", SettingsBindFlags.DEFAULT);

            long_break_scale = new Widget.ValueRange (10, 30, 1, _("minute"), _("minutes"));
            settings.schema.bind ("long-break-duration", long_break_scale, "current-value", SettingsBindFlags.DEFAULT);

            long_break_delay_scale = new Widget.ValueRange (2, 8, 1, _("pomodoro"), _("pomodoros"));
            settings.schema.bind ("long-break-delay", long_break_delay_scale, "current-value", SettingsBindFlags.DEFAULT);

            /* ** options - switches ** */
            reset_work_everyday = new Gtk.Switch ();
            preferences.schema.bind ("reset-work-everyday", reset_work_everyday, "active", SettingsBindFlags.DEFAULT);

            pause_after_break = new Gtk.Switch ();
            preferences.schema.bind ("pause-after-break", pause_after_break, "active", SettingsBindFlags.DEFAULT);

            auto_stop_enabled = new Gtk.Switch ();
            preferences.schema.bind ("auto-stop", auto_stop_enabled, "active", SettingsBindFlags.DEFAULT);

            pomodoro_sound_enabled = new Gtk.Switch ();
            preferences.schema.bind ("pomodoro-sound-enabled", pomodoro_sound_enabled, "active", SettingsBindFlags.DEFAULT);

            if (preferences.debug_mode) {
                pomodoro_scale = new Widget.ValueRange (1, 60, 1, _("minute"), _("minutes"));
                settings.schema.bind ("pomodoro-duration", pomodoro_scale, "current-value", SettingsBindFlags.DEFAULT);

                long_break_scale = new Widget.ValueRange (2, 30, 1, _("minute"), _("minutes"));
                settings.schema.bind ("long-break-duration", long_break_scale, "current-value", SettingsBindFlags.DEFAULT);

                debug_switch = new Gtk.Switch ();
                preferences.schema.bind ("debug-mode", debug_switch, "active", SettingsBindFlags.DEFAULT);
            }

            /* ** options - buttons ** */
            reset_timings = new Gtk.Button.with_label (_("Default Settings"));
            reset_work = new Gtk.Button.with_label (_("Reset Work"));
        }

        private void create_ui () {

            stack.set_transition_type (Gtk.StackTransitionType.SLIDE_LEFT_RIGHT);
            //create timing tab

            stack.add_titled (get_timing_box (), "timing", _("Timing"));

            //create misc tab

            stack.add_titled (get_misc_box (), "misc", _("Preferences"));

            //creat future tabs here

            //close button
            var close_button = new Gtk.Button.with_label (_("Close"));
            close_button.clicked.connect (() => { this.destroy (); });

            //button box
            var button_box = new Gtk.HButtonBox ();
            button_box.set_layout (Gtk.ButtonBoxStyle.END);
            button_box.pack_end (close_button);
            button_box.margin_right = 12;

            //puts everything into a grid
            var main_grid = new Gtk.Grid ();
            main_grid.attach (stackswitcher, 0, 0, 1, 1);
            main_grid.attach (
                stack, 0, 1, 1, 1);
            main_grid.attach (button_box, 0, 2, 1, 1);

            //add the grid to the dialog
            get_content_area ().add (main_grid);
        }

        private Gtk.Widget get_timing_box () {
            //setup the grid for the timing Box
            var grid = make_grid ();

            var row = 0;
            //create section
            /*var label = new Gtk.Label (_("General:"));
            add_section (grid, label, ref row);*/

            //pomodoro Scale
            var label = new Gtk.Label (_("Pomodoro duration:"));
            add_option (grid, label, pomodoro_scale, ref row);

            //short break scale
            label = new Gtk.Label (_("Short break duration:"));
            add_option (grid, label, short_break_scale, ref row);

            //long break scale
            label = new Gtk.Label (_("Long break duration:"));
            add_option (grid, label, long_break_scale, ref row);

            //long break delay scale
            label = new Gtk.Label (_("Long break delay:"));
            add_option (grid, label, long_break_delay_scale, ref row);

            //reset buttons
            var reset_grid = new Gtk.Grid ();
            reset_grid.column_spacing = 5;
            reset_grid.add (reset_timings);
            reset_grid.add (reset_work);
            label = new Gtk.Label (_("Reset:"));
            add_option (grid, label, reset_grid, ref row, 15);

            return grid;
        }

        private Gtk.Widget get_misc_box () {
            //setup the grid for the timing Box
            var grid = make_grid ();

            var row = 0;

            var label = new Gtk.Label (_("Behavior:"));
            add_section (grid, label, ref row);

            label = new Gtk.Label (_("Reset work everyday:"));
            add_option (grid, label, reset_work_everyday, ref row);

            label = new Gtk.Label (_("Start new pomodoro manually:"));
            add_option (grid, label, pause_after_break, ref row);

            label = new Gtk.Label (_("Auto stop:"));
            add_option (grid, label, auto_stop_enabled, ref row);

            label = new Gtk.Label (_("Sound:"));
            add_section (grid, label, ref row);

            label = new Gtk.Label (_("Pomodoro sound:"));
            add_option (grid, label, pomodoro_sound_enabled, ref row);

            if (preferences.debug_mode) {
                label = new Gtk.Label (_("Extras:"));
                add_section (grid, label, ref row);

                label = new Gtk.Label ("Debug mode:");
                add_option (grid, label, debug_switch, ref row);
            }

            return grid;
        }

        private void reset_scales () {
            pomodoro_scale.current_value = Default.POMODORO_DURATION;
            short_break_scale.current_value = Default.SHORT_BREAK_DURATION;
            long_break_scale.current_value = Default.LONG_BREAK_DURATION;
            long_break_delay_scale.current_value = Default.LONG_BREAK_DELAY;
        }

        public void update_timing_sensitivity () {
            var sensitive = false;
            if (pomodoro_scale.current_value != Default.POMODORO_DURATION) {
                sensitive = true;
            } else if (short_break_scale.current_value != Default.SHORT_BREAK_DURATION) {
                sensitive = true;
            } else if (long_break_scale.current_value != Default.LONG_BREAK_DURATION) {
                sensitive = true;
            } else if (long_break_delay_scale.current_value != Default.LONG_BREAK_DELAY) {
                sensitive = true;
            }
            reset_timings.sensitive = sensitive;

        }

        public void update_work_sensitivity () {
            var sensitive = false;
            if (saved.pomodoro_count != 0) {
                sensitive = true;
            } else if (saved.total_time != 0) {
                sensitive = true;
            } else if (saved.status != Status.START) {
                sensitive = true;
            }
            reset_work.sensitive = sensitive;
        }

        private void add_section (Gtk.Grid grid, Gtk.Label name, ref int row) {
            name.use_markup = true;
            name.set_markup ("<b>%s</b>".printf (name.get_text ()));
            name.halign = Gtk.Align.START;
            grid.attach (name, 0, row, 1, 1);

            row++; //add one to row
        }

        private void add_option (Gtk.Grid grid, Gtk.Widget label, Gtk.Widget switcher, ref int row, int margin_top = 0) {
            label.hexpand = true;
            label.halign = Gtk.Align.END;
            if (switcher is Gtk.Scale || switcher is Widget.ValueRange) label.valign = Gtk.Align.END;
            label.margin_left = 20;
            label.margin_top = margin_top;
            switcher.margin_top = margin_top;
            switcher.hexpand = true;
            switcher.halign = Gtk.Align.FILL;
            if (switcher is Gtk.Scale || switcher is Widget.ValueRange) switcher.valign = Gtk.Align.CENTER;

            //change halign of swicher in some cases
            if (switcher is Gtk.Switch || switcher is Gtk.Entry) {
               switcher.halign = Gtk.Align.START;
            }

            grid.attach (label, 0, row, 1, 1);
            grid.attach_next_to (switcher, label, Gtk.PositionType.RIGHT, 3, 1);

            row++; //add one to row
        }

        private Gtk.Grid make_grid () {
            var grid = new Gtk.Grid ();
            grid.row_spacing = 5;
            grid.column_spacing = 5;
            grid.margin_left = 12;
            grid.margin_right = 12;
            grid.margin_top = 12;
            grid.margin_bottom = 12;
            return grid;
        }

        private void connect_signals () {
            pomodoro_scale.changed.connect (() => {
                pomodoro_changed ();
            });

            short_break_scale.changed.connect (() => {
                short_break_changed ();
            });

            long_break_scale.changed.connect (() => {
                long_break_changed ();
            });

            long_break_delay_scale.changed.connect (() => {
                long_break_delay_changed ();
            });

            reset_timings.clicked.connect (reset_scales);

            reset_work.clicked.connect (() => {
                reset_work_clicked ();
            });

        }
    }
}
