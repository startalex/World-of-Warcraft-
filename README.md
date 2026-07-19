# Solo Shuffle Voice

An ultra-lightweight, private, and secure World of Warcraft addon designed to easily coordinate voice communication between teammates during Solo Shuffle matches using WoW's native voice engine.

## 🛠️ How to Install
1. Download the `SoloShuffleVoice` folder.
2. Place the folder directly into your World of Warcraft directory at:
   `World of Warcraft/_retail_/Interface/AddOns/`
3. Launch World of Warcraft (or type `/reload` if the game is already open).
4. Type `/ssv` in your chat window to display the interface panel.

## 🎮 How It Works In-Game
1. **Entering the Arena:** The moment you load into a Solo Shuffle match, the addon automatically detects the arena environment and scans your immediate party.
2. **The Connection Choice:**
   - **If you are hosting:** Your interface updates to `Status: Hosting Channel`. Click **Join Voice** to spin up the room.
   - **If a teammate has already hosted:** Your interface updates to `Status: Team Channel Found`. Click **Connect to Team** to link up.
3. **Privacy Control:** Connecting to voice chat is entirely optional. If you or a teammate choose not to click the button, no connection or audio capture is ever initiated.

## ⚠️ Checklist: If You Can't Hear or Speak
Because this addon hooks directly into World of Warcraft's native systems, if your UI shows you are connected but you cannot hear or speak, it is an issue with your system or game permissions. Please check these three settings:

### 1. Check WoW Native Audio Options
- Press `Esc` -> **Options** -> **Audio** -> **Voice Chat**.
- Ensure **Enable Voice Chat** is checked.
- Double-check that your **Voice Chat Input Device** matches your actual microphone.
- Double-check that your **Voice Chat Output Device** matches your actual headphones.
- Test your mic sensitivity slider to make sure the game registers your voice.

### 2. Verify Windows Privacy Permissions
Windows sometimes blocks World of Warcraft from accessing your hardware:
- Open your Windows Settings -> **Privacy & Security** -> **Microphone**.
- Ensure **Microphone access** is turned ON.
- Scroll down to "Let desktop apps access your microphone" and verify that `World of Warcraft` is allowed.

### 3. Check Parental Controls / Account Settings
- Log out of the game and open your Battle.net Desktop App.
- Go to your Account Settings -> **Privacy & Communication**.
- Ensure that **Voice Chat** permissions are enabled on your Blizzard account profile.

## ⌨️ Command Console Tools
Type these commands into your game chat window to manage the system:
- `/ssv` - Toggles the visibility of the user interface panel.
- `/ssv debug` - Displays full connection states, active engine channel IDs, and world parameters.
- `/ssv list` - Shows an exact roster of active teammates currently running the addon in your group.

