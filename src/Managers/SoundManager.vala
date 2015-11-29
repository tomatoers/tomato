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

    public class SoundManager {

        private Canberra.Context? player;
        private string sound_id;

        public SoundManager () {
            this.with_custom_sound ("complete");
        }

        public SoundManager.with_custom_sound (string sound_id) {
            if (Canberra.Context.create (out player) < 0) {
                warning ("Sound will not be available");
                player = null;
            }

            this.sound_id = sound_id;
        }

        public void play () {
            if (player != null) {
                player.play (1, Canberra.PROP_EVENT_ID, sound_id,
                                Canberra.PROP_MEDIA_ROLE, "alarm");
            }
        }
    }
}
