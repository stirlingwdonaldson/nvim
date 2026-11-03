// Window layout helper for the <leader>t typst preview keybind.
// Run with: osascript -l JavaScript typst_layout.js <mode> [args...]
//
//   left              Move the frontmost window (your terminal) to the left
//                     half of the built-in display. Prints its previous
//                     bounds as "x y w h" so they can be restored later.
//   right <url>       Open <url> in a new browser window on the right half,
//                     then hand focus back to the terminal.
//   restore x y w h   Put the frontmost window back at the given bounds.
//   close <url>       Close any browser tabs showing <url>.
//
// Moving the terminal uses System Events, so your terminal app needs
// Accessibility permission (System Settings > Privacy & Security >
// Accessibility). macOS will prompt the first time.

ObjC.import("AppKit");

// "Safari", or a Chromium browser such as "Google Chrome".
const BROWSER = "Safari";

// Usable area (minus menu bar and Dock) of the MacBook's built-in display,
// converted from Cocoa's bottom-left origin to the top-left origin that
// System Events and the browser use. Falls back to the primary display.
function screenArea() {
	const screens = $.NSScreen.screens;
	const primaryHeight = screens.objectAtIndex(0).frame.size.height;
	let target = screens.objectAtIndex(0);
	for (let i = 0; i < screens.count; i++) {
		const s = screens.objectAtIndex(i);
		const name = s.localizedName ? s.localizedName.js : "";
		if (/built-in/i.test(name)) {
			target = s;
			break;
		}
	}
	const f = target.visibleFrame;
	return {
		x: f.origin.x,
		y: primaryHeight - (f.origin.y + f.size.height),
		width: f.size.width,
		height: f.size.height,
	};
}

function halves() {
	const a = screenArea();
	const half = Math.floor(a.width / 2);
	return {
		left: { x: a.x, y: a.y, width: half, height: a.height },
		right: { x: a.x + half, y: a.y, width: a.width - half, height: a.height },
	};
}

function frontProcess() {
	return Application("System Events").processes.whose({ frontmost: true })[0];
}

function setWindowBounds(win, b) {
	win.position = [Math.round(b.x), Math.round(b.y)];
	win.size = [Math.round(b.width), Math.round(b.height)];
}

function run(argv) {
	const mode = argv[0];

	if (mode === "left") {
		const win = frontProcess().windows[0];
		const pos = win.position();
		const size = win.size();
		setWindowBounds(win, halves().left);
		return [pos[0], pos[1], size[0], size[1]].join(" ");
	}

	if (mode === "restore") {
		const [x, y, width, height] = argv.slice(1).map(Number);
		setWindowBounds(frontProcess().windows[0], { x, y, width, height });
		return "";
	}

	if (mode === "right") {
		const url = argv[1];
		const terminal = frontProcess().bundleIdentifier();
		const browser = Application(BROWSER);
		let win;
		if (BROWSER === "Safari") {
			// A new Safari document opens in its own (front) window.
			browser.Document().make();
			win = browser.windows[0];
			win.currentTab.url = url;
		} else {
			win = browser.Window().make();
			win.activeTab.url = url;
		}
		win.bounds = halves().right;
		// Keep typing in nvim rather than landing in the browser.
		Application(terminal).activate();
		return "";
	}

	if (mode === "close") {
		const url = argv[1];
		const browser = Application(BROWSER);
		if (!browser.running()) return "";
		const wins = browser.windows();
		for (let i = wins.length - 1; i >= 0; i--) {
			const tabs = wins[i].tabs();
			for (let j = tabs.length - 1; j >= 0; j--) {
				const tabUrl = tabs[j].url() || "";
				if (tabUrl.indexOf(url) === 0) tabs[j].close();
			}
		}
		return "";
	}

	throw new Error("unknown mode: " + mode);
}
