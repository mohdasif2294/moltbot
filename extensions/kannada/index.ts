import type { OpenClawPluginApi } from "openclaw/plugin-sdk";
import { emptyPluginConfigSchema } from "openclaw/plugin-sdk";

import { KANNADA_TUTOR_SYSTEM_PROMPT } from "./src/prompt.js";
import { createKannadaPronounceTool } from "./src/pronounce-tool.js";

const plugin = {
  id: "kannada",
  name: "Kannada Tutor",
  description: "Spoken Kannada learning assistant",
  configSchema: emptyPluginConfigSchema(),

  register(api: OpenClawPluginApi) {
    // Inject the Kannada tutor system prompt before every agent run.
    api.on("before_agent_start", async () => {
      return {
        prependContext: KANNADA_TUTOR_SYSTEM_PROMPT,
      };
    });

    // Register the pronunciation tool so the agent can generate audio.
    api.registerTool(createKannadaPronounceTool(api));
  },
};

export default plugin;
