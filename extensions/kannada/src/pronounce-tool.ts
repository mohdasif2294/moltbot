import { Type } from "@sinclair/typebox";
import type { OpenClawPluginApi } from "openclaw/plugin-sdk";

const KannadaPronounceSchema = Type.Object({
  text: Type.String({
    description:
      "The Kannada phrase to pronounce, in Latin/Roman transliteration.",
  }),
  voice: Type.Optional(
    Type.String({
      description:
        "Optional OpenAI TTS voice to use (e.g. 'alloy', 'nova', 'shimmer'). Defaults to plugin config or 'nova'.",
    }),
  ),
});

/**
 * Creates the kannada_pronounce tool that generates TTS audio for Kannada phrases.
 * Delegates to the built-in TTS infrastructure (OpenAI gpt-4o-mini-tts).
 */
export function createKannadaPronounceTool(api: OpenClawPluginApi) {
  return {
    name: "kannada_pronounce",
    label: "Kannada Pronounce",
    description:
      "Generate pronunciation audio for a Kannada phrase (given in Latin transliteration). Returns a MEDIA: path the agent must include verbatim in its reply so the user hears the audio.",
    parameters: KannadaPronounceSchema,

    async execute(_toolCallId: string, args: Record<string, unknown>) {
      const text = typeof args.text === "string" ? args.text : "";
      if (!text.trim()) {
        return {
          content: [{ type: "text" as const, text: "No text provided." }],
        };
      }

      const voice =
        (typeof args.voice === "string" && args.voice) ||
        (api.pluginConfig as Record<string, unknown>)?.voice as string ||
        "nova";

      // Use the runtime TTS function exposed by the plugin API.
      // Falls back to the global textToSpeech if runtime doesn't expose one.
      const { textToSpeech } = await import("../../../src/tts/tts.js");
      const { loadConfig } = await import("../../../src/config/config.js");

      const cfg = api.config ?? loadConfig();
      const result = await textToSpeech({
        text,
        cfg,
        overrides: {
          openai: { voice, model: "gpt-4o-mini-tts" },
        },
      });

      if (result.success && result.audioPath) {
        const lines: string[] = [];
        if (result.voiceCompatible) {
          lines.push("[[audio_as_voice]]");
        }
        lines.push(`MEDIA:${result.audioPath}`);
        return {
          content: [{ type: "text" as const, text: lines.join("\n") }],
          details: { audioPath: result.audioPath, provider: result.provider },
        };
      }

      return {
        content: [
          {
            type: "text" as const,
            text: result.error ?? "Pronunciation audio generation failed.",
          },
        ],
        details: { error: result.error },
      };
    },
  };
}
