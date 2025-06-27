// Imports
import { Lighting, Workspace } from "@rbxts/services";

enum LightingState {
	on = "on",
	off = "off",
}

// Functions
class LightingSystem {
	private static readonly DEBOUNCE_TIME = 0.25;
	public static readonly INDEX_NAME = "System";

	private source: Part;
	private light: PointLight;
	private sound: Sound;

	private state: LightingState = LightingState.off;
	private lastToggleTimestamp: number = os.clock();

	constructor(system: Model) {
		const lightModel = system.FindFirstChild("Light") as Model;
		this.source = lightModel.FindFirstChild("Source") as Part;
		this.light = this.source.FindFirstChild("Light") as PointLight;

		const switchModel = system.FindFirstChild("Switch") as Model;
		const clickbox = switchModel.FindFirstChild("Clickbox") as Model;
		this.sound = clickbox.FindFirstChild("Sound") as Sound;

		const clickDetector = clickbox.FindFirstChild("ClickDetector") as ClickDetector;
		clickDetector.MouseClick.Connect(() => {
			this.toggle();
		});
	}

	public on(): void {
		this.source.Material = Enum.Material.Neon;
		this.light.Enabled = true;
	}

	public off(): void {
		this.source.Material = Enum.Material.Plastic;
		this.light.Enabled = false;
	}

	public toggle(): void {
		if (os.clock() - this.lastToggleTimestamp < LightingSystem.DEBOUNCE_TIME) return;
		this.lastToggleTimestamp = os.clock();

		this.state = this.state === LightingState.on ? LightingState.off : LightingState.on;
		//print(this.state);
		if (this.state === "on") {
			this.on();
		} else {
			this.off();
		}

		this.sound?.Play();
	}
}

// Main
function initialize(obj: Instance): void {
	if (obj.IsA("Model") && obj.Name === LightingSystem.INDEX_NAME) {
		new LightingSystem(obj);
	}
}

Workspace.DescendantAdded.Connect(initialize);
for (const obj of Workspace.GetDescendants()) {
	initialize(obj);
}
