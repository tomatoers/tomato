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

    public class MainWindow : Gtk.Dialog {

        public bool is_hidden = false;

        public signal void preferences_clicked ();
        public signal void start_clicked ();
        public signal void resume_clicked ();
        public signal void pause_clicked ();
        public signal void stop_clicked ();
        public signal void skip_clicked ();
        public signal void closed ();

        private TomatoApp app;

		private Gtk.HeaderBar headerbar;
		private Gtk.Button close_button;
        private Gtk.MenuButton appmenu;
        private Gtk.MenuItem preferences;
        private Widget.Slide slide;
		private Gtk.Box content;

        private Gtk.Label countdown_label;
        private Gtk.Label total_time_label;
        private Gtk.Button start;
        private Gtk.Button resume;
        private Gtk.Button pause;
        private Gtk.Button stop;
        private Gtk.Button skip;

        // constructor
        public MainWindow (TomatoApp app) {
			Object (use_header_bar: 1);

            this.app = app;
            this.title = Constants.APP_NAME;
            this.set_position (Gtk.WindowPosition.CENTER);
            this.set_resizable (false);
            this.set_size_request (450, 410);

            /* Initializing major components */
            slide = new Widget.Slide ();

            countdown_label = new Gtk.Label ("");
            total_time_label = new Gtk.Label ("");
            start = new Gtk.Button.with_label (_("Start"));
            resume = new Gtk.Button.with_label (_("Resume"));
            pause = new Gtk.Button.with_label (_("Pause"));
            stop = new Gtk.Button.with_label (_("Stop"));
            skip = new Gtk.Button.with_label (_("Skip"));

			content = this.get_content_area ();
			headerbar = this.get_header_bar () as Gtk.HeaderBar;

            setup_layout ();
            setup_style ();
            connect_signals ();

            show_all ();
            update_progress ();

            set_pause (true);
            next_status (Gtk.StackTransitionType.NONE);
        }

        public void set_pause (bool topause = true) {
            if (topause) {
                resume.show ();
                resume.grab_focus ();
                pause.hide ();
            } else {
                resume.hide ();
                pause.show ();
                pause.grab_focus ();
            }
        }

        public void next_status (Gtk.StackTransitionType transition = Gtk.StackTransitionType.NONE) {

            if (saved.status == Status.START) {
                slide.set_visible_screen ("start", transition);
                this.set_title ("Pomodoro %d".printf(saved.pomodoro_count+1));
                appmenu.set_sensitive (true);
            } else if (saved.status == Status.SHORT_BREAK) {
                slide.set_visible_screen ("break", transition);
                this.set_title (_("Short Break"));
                appmenu.set_sensitive (true);
            } else if (saved.status == Status.LONG_BREAK) {
                slide.set_visible_screen ("break", transition);
                this.set_title (_("Long Break"));
                appmenu.set_sensitive (true);
            } else {
                slide.set_visible_screen ("pomodoro", transition);
                this.set_title ("Pomodoro %d".printf(saved.pomodoro_count+1));
                appmenu.set_sensitive (false);
            }

            Widget.Screen screen = slide.get_visible_screen ();
            if (screen != null) {
                message ("Current screen: %s".printf (screen.get_name ()));
                screen.add_progress (countdown_label, total_time_label);
            } else {
                warning ("There's no visible screen!");
            }

            update_progress ();
        }

        public void update_progress () {
            update_countdown ();
            update_total_time ();
        }

        public void update_countdown () {
            countdown_label.set_label (work.formatted_countdown ());
        }

        public void update_stop (string text) {
            stop.set_label (text);
        }

        public void update_total_time () {
            if ((saved.status == Status.START || saved.status == Status.SHORT_BREAK || saved.status == Status.LONG_BREAK || paused) && saved.total_time != 0) {
                total_time_label.set_label (work.formatted_total_time () + _(" of work"));
            } else {
                total_time_label.set_label ("");
            }
        }

        private void setup_headerbar () {
            appmenu = new Gtk.MenuButton ();
			appmenu.relief = Gtk.ReliefStyle.NONE;
            preferences = new Gtk.MenuItem.with_label (_("Preferences…"));
            Gtk.Menu menu = new Gtk.Menu ();

            menu.append (preferences);
            menu.show_all ();

            var menu_icon = new Gtk.Image.from_icon_name ("emblem-system-symbolic", Gtk.IconSize.SMALL_TOOLBAR);
            appmenu.set_image (menu_icon);
            appmenu.popup = menu;

			close_button = new Gtk.Button.from_icon_name ("window-close-symbolic", Gtk.IconSize.SMALL_TOOLBAR);
			close_button.relief = Gtk.ReliefStyle.NONE;

			headerbar.set_show_close_button (false);

			headerbar.pack_start (close_button);
			headerbar.pack_end (appmenu);
        }

        private void setup_stack () {
            Widget.Screen start_screen = new Widget.Screen ("start");
            start_screen.add_control (start);

            Widget.Screen break_screen = new Widget.Screen ("break");
            break_screen.add_control (skip);

            Widget.Screen pomodoro_screen = new Widget.Screen ("pomodoro");
            pomodoro_screen.add_controls (new Gtk.Widget[] {resume, pause, stop});

            slide.add_screen (start_screen);
            slide.add_screen (break_screen);
            slide.add_screen (pomodoro_screen);
        }

        private void setup_layout () {
            setup_headerbar ();
            setup_stack ();
            // this.add (slide);
			content.add (slide);
        }

        private void setup_style () {
            /* Loading CSS theme */
            var css_file = Constants.PKG_DATADIR + "/style/window.css";
            var provider = new Gtk.CssProvider ();
            try {
                provider.load_from_path (css_file);
                Gtk.StyleContext.add_provider_for_screen (Gdk.Screen.get_default (),
                    provider, Gtk.STYLE_PROVIDER_PRIORITY_USER);
            } catch (Error e) {
                stderr.printf ("Error: %s", e.message);
            }

            /* Setting elements styles */
            countdown_label.get_style_context ().add_class ("countdown");
            total_time_label.get_style_context ().add_class ("total-time");

            start.get_style_context ().add_class ("start-button");
            skip.get_style_context ().add_class ("break-button");
            resume.get_style_context ().add_class ("pomodoro-button");
            pause.get_style_context ().add_class ("pomodoro-button");
            stop.get_style_context ().add_class ("pomodoro-button");

			headerbar.get_style_context ().add_class ("compact");
			headerbar.get_style_context ().remove_class ("titlebar");

			close_button.get_style_context ().add_class ("header-bar");
			appmenu.get_style_context ().add_class ("header-bar");

            slide.get_child_by_name ("start").get_style_context ().add_class ("start-window");
            slide.get_child_by_name ("pomodoro").get_style_context ().add_class ("pomodoro-window");
            slide.get_child_by_name ("break").get_style_context ().add_class ("break-window");
        }

        private void connect_signals () {
            start.clicked.connect (() => {start_clicked ();});
            resume.clicked.connect (() => {resume_clicked ();});
            pause.clicked.connect (() => {pause_clicked ();});
            stop.clicked.connect (() => {stop_clicked ();});
            skip.clicked.connect (() => {skip_clicked ();});
            preferences.activate.connect (() => {preferences_clicked ();});

			this.slide.changed.connect ((s) => {
					this.get_style_context ().remove_class ("start-window");
					this.get_style_context ().remove_class ("pomodoro-window");
					this.get_style_context ().remove_class ("break-window");
					this.get_style_context ().add_class (s.get_name () + "-window");
				});

			this.close_button.clicked.connect (() => {quit ();});
            this.delete_event.connect (quit);
        }

		private bool quit () {
			if (!paused) {
				hide ();
				return true;
			}
			Gtk.main_quit ();
			return false;
		}
    }
}
