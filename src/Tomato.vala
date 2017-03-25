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

using Granite.Services;

namespace Tomato {

    public enum Status {
        START,
        POMODORO,
        SHORT_BREAK,
        LONG_BREAK
    }

    public Services.SavedState saved;
    public Services.Settings settings;
    public Services.Preferences preferences;

    protected int break_messages_index = 0;
    protected const string[] break_messages = {N_("Go have a coffee"),
                                        N_("Check your emails"),
                                        N_("Drink some water"),
                                        N_("Get up and dance!"),
                                        N_("Have a break, have a tomato"),
                                        N_("Get up! Stand up! Fight for your fingers!"),
                                        N_("Take a break, save a life"),
                                        N_("Woot! Break time, baby!"),
                                        N_("It's coffee time!"),
                                        N_("What about a beer?"),
                                        N_("You can check Facebook notifications"),
                                        N_("You can use Twitter now!"),
                                        N_("Take a walk outside"),
                                        N_("Step away from the machine!")};
    protected Managers.NotificationManager notification;
    protected Managers.WorkManager work;
    protected int warning_countdown = 90;
    protected bool paused = true;
    protected bool stopped = true;

    //protected const bool DEBUG = true;

    public class TomatoApp : Granite.Application {

        construct {
            program_name = Constants.APP_NAME;
            exec_name = Constants.EXEC_NAME;
            build_version = Constants.VERSION;

            app_years = "2015";
            app_icon = Constants.ICON_NAME;
            app_launcher = "org.pantheon.tomato.desktop";
            application_id = "org.pantheon.tomato";

            main_url = "http://launchpad.net/tomatoapp";
            bug_url = "http://bugs.launchpad.net/tomatoapp";
            help_url = "http://answers.launchpad.net/tomatoapp";
            translate_url = "http://translations.launchpad.net/tomatoapp";

            about_authors = {"Luiz Augusto Morais <luizaugustomm@gmail.com>",
                             "Sam Thomas <sgpthomas@gmail.com>"};
            about_license_type = Gtk.License.GPL_3_0;
            about_artists = {"Luiz Augusto Morais <luizaugustomm@gmail.com>",
                             "Sam Thomas <sgpthomas@gmail.com>"};
            about_translators = "Launchpad Translators";
        }

        public signal void paused_on_break ();

        private Window.MainWindow window;
        private Window.PreferencesDialog pref_window;

        private const uint TIME = 1000;
        private uint work_timeout_id = 0;
        private uint wnotify_timeout_id = 0;

        //constructor
        public TomatoApp () {
            //logger initialization
            Logger.initialize (Constants.APP_NAME);
            Logger.DisplayLevel = LogLevel.DEBUG;

            // Initializing settings
            saved = new Services.SavedState ();
            settings = new Services.Settings ();
            preferences = new Services.Preferences ();

            // Instantiating tomato managers
            work = new Managers.WorkManager ();
            notification = new Managers.NotificationManager ();

            //initialize internationalization support
            Intl.setlocale (LocaleCategory.ALL, "");
            string langpack_dir = Path.build_filename (Constants.DATADIR, "locale");
            Intl.bindtextdomain (Constants.GETTEXT_PACKAGE, langpack_dir);
            Intl.bind_textdomain_codeset (Constants.GETTEXT_PACKAGE, "UTF-8");
            Intl.textdomain (Constants.GETTEXT_PACKAGE);

            //set debug state
            Tomato.preferences.debug_mode = false;
        }

        public override void activate () {
            if (window == null) {
                window = new Window.MainWindow (this);
                connect_signals ();
                Gtk.main ();
            } else {
                message ("There is an instance of tomato already open.");
                window.present ();
            }
        }

        private bool update_time () {
            var rand = new Rand ();
            if (!paused) {
                work.tick ();
                if (work.time_is_over ()) {
                    break_messages_index = rand.int_range (0, break_messages.length);
                    notification.show_status ();
                    next_status ();
                    if (preferences.pause_after_break && saved.status == Status.POMODORO) {
                        paused_on_break ();
                        return false;
                    }
                } update_progress ();
            } return !paused;
        }

        private bool warning_notification () {
            if (paused && !stopped) {
                warning_countdown -= 1;
                if (warning_countdown == 0) {
                    notification.show (_("Tomato has been paused for a long time!"), _("Shouldn't you be working?"));
                    warning_countdown = 90;
                }
            } return paused;
        }


        private void on_start_clicked () {
            work.start ();
            next_status ();
            update_progress ();
            play ();
        }

        private void on_resume_clicked () {
            if (preferences.warning_notification && wnotify_timeout_id != 0 && !stopped) {
                Source.remove (wnotify_timeout_id);
                wnotify_timeout_id = 0;
                warning_countdown = 90;
                message ("Notification warning countdown removed");
            }
            play ();
        }

        private void on_pause_clicked () {
            pause ();
            update_progress ();
            /* Show a notification when the app is paused for a long period */
            if (preferences.warning_notification && saved.status == Status.POMODORO) {
                message ("Notification warning countdown started");
                wnotify_timeout_id = Timeout.add (TIME, warning_notification);
            } else {
                wnotify_timeout_id = 0;
            }
        }

        private void on_stop_clicked () {
            stop ();
            work.start ();
            work.reset_countdown ();
            update_progress ();

            if (preferences.warning_notification && wnotify_timeout_id != 0 && stopped) {
                Source.remove (wnotify_timeout_id);
                wnotify_timeout_id = 0;
                warning_countdown = 90;
                message ("Notification warning countdown removed");
            }
        }

        private void on_skip_clicked () {
            stop ();
            work.start ();
            work.reset_countdown ();
            next_status ();
        }

        private void on_preferences_clicked () {
            if (!paused) {
                on_pause_clicked ();
            }

            //show preferences window
            pref_window = new Window.PreferencesDialog (window);
            pref_window.show_all ();

            connect_pref_signals ();
        }

        private void play () {
            set_pause (false);

            if (work_timeout_id != 0)
                Source.remove (work_timeout_id);
            work_timeout_id = Timeout.add (TIME, update_time);
        }

        private void pause () {
            set_pause (true);

            if (work_timeout_id != 0) {
                Source.remove (work_timeout_id);
                work_timeout_id = 0;
            }
        }

        private void stop () {
            stopped = true;
            pause ();
        }

        private void set_pause (bool topause = true) {
            paused = topause;
            if (!paused)
                stopped = paused;
            window.set_pause (topause);
        }

        private void update_progress () {
            window.update_progress ();
        }

        private void next_status () {
            window.next_status ();
        }

        private void connect_signals () {
            window.start_clicked.connect (on_start_clicked);
            window.resume_clicked.connect (on_resume_clicked);
            window.pause_clicked.connect (on_pause_clicked);
            window.stop_clicked.connect (on_stop_clicked);
            window.skip_clicked.connect (on_skip_clicked);
            window.preferences_clicked.connect (on_preferences_clicked);
            paused_on_break.connect (on_stop_clicked);
        }

        private void connect_pref_signals () {
            /* Watch for change in settings*/
            pref_window.pomodoro_changed.connect (() => {
                if (saved.status == Status.POMODORO) {
                    on_settings_changed ();
                    message ("Pomodoro scale changed");
                } pref_window.update_timing_sensitivity ();
            });

            pref_window.short_break_changed.connect (() => {
                if (saved.status == Status.SHORT_BREAK) {
                    on_settings_changed ();
                    message ("Short break scale changed");
                } pref_window.update_timing_sensitivity ();
            });

            pref_window.long_break_changed.connect (() => {
                if (saved.status == Status.LONG_BREAK) {
                    on_settings_changed ();
                    message ("Long break scale changed");
                } pref_window.update_timing_sensitivity ();
            });

            pref_window.long_break_delay_changed.connect (() => {
                pref_window.update_timing_sensitivity ();
            });

            //watch for change in preferences
            Tomato.preferences.changed.connect (on_preferences_changed);

            //watch for reset action
            pref_window.reset_work_clicked.connect (() => {
                work.reset ();
                window.next_status (Gtk.StackTransitionType.NONE);
                pref_window.update_work_sensitivity ();
            });
        }

        private void on_settings_changed () {
            work.reset_countdown ();
            window.update_progress ();
            message ("Settings Updated");
        }

        private void on_preferences_changed () {
            work_timeout_id = 0; // To avoid removing a timeout that doesn't exist
            pref_window.update_timing_sensitivity ();
            pref_window.update_work_sensitivity ();
        }
    }

    public static void main(string[] args) {
        Gtk.init(ref args);

        TomatoApp app = new TomatoApp ();
        app.run (args);
    }

}
