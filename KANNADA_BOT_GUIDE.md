# Kannada Language Learning WhatsApp Bot - Setup Guide

## Overview
This guide helps you set up Moltbot as a WhatsApp-based Kannada language learning assistant with both text and voice support.

## Prerequisites
- Node.js 22+
- A phone number for WhatsApp (preferably separate from your personal number)
- Anthropic API key (for Claude) or OpenAI API key
- OpenAI API key (for Whisper STT and voice TTS if desired)

## Quick Start

### 1. Initial Setup

```bash
# From the moltbot repository
cd /Users/asif/Documents/workspace/moltbot

# Install dependencies
pnpm install

# Build the project
pnpm build

# Run onboarding wizard
pnpm moltbot onboard
```

### 2. Copy the Kannada Bot Configuration

```bash
# Copy the sample config to your Moltbot config
cp kannada-bot-config.json ~/.clawdbot/moltbot.json

# Edit it to add your phone number
# Replace +YOUR_PHONE_NUMBER_HERE with your actual number (E.164 format)
# Example: +919876543210 for Indian numbers
```

### 3. Configure Authentication

You need to set up your AI provider credentials:

**For Anthropic (Claude):**
```bash
pnpm moltbot login
# This will open a browser for OAuth login
```

**For OpenAI (for STT/TTS):**
Add to your config at `~/.clawdbot/moltbot.json`:
```json
{
  "messages": {
    "stt": {
      "provider": "openai",
      "openai": {
        "apiKey": "your-openai-api-key",
        "model": "whisper-1",
        "language": "kn"
      }
    },
    "tts": {
      "provider": "openai",
      "openai": {
        "apiKey": "your-openai-api-key",
        "voice": "nova",
        "model": "tts-1"
      }
    }
  }
}
```

### 4. Link WhatsApp

```bash
pnpm moltbot channels login
```

This will display a QR code. Scan it with WhatsApp:
1. Open WhatsApp on your phone
2. Go to Settings → Linked Devices
3. Tap "Link a Device"
4. Scan the QR code shown in your terminal

### 5. Start the Gateway

```bash
pnpm moltbot gateway --port 18789 --verbose
```

Keep this running in a terminal or use a process manager.

## Using Your Kannada Learning Bot

### Text Mode Examples

Send these messages to your WhatsApp bot:

1. **Basic Greetings:**
   - "Teach me basic Kannada greetings"
   - "How do I say 'How are you?' in Kannada?"

2. **Vocabulary:**
   - "Teach me 10 common Kannada words"
   - "What are the Kannada words for family members?"

3. **Grammar:**
   - "Explain Kannada verb conjugation"
   - "How do plurals work in Kannada?"

4. **Script Learning:**
   - "Teach me the Kannada alphabet"
   - "How do I write my name in Kannada?"

5. **Practice Conversations:**
   - "Let's have a simple conversation in Kannada"
   - "Help me order food at a restaurant in Kannada"

### Voice Mode Examples

**How it works:**
1. Record a voice message in WhatsApp (hold the microphone button)
2. Try saying Kannada words or phrases
3. The bot will transcribe your speech using Whisper
4. It will respond with corrections and encouragement

**Example voice practice:**
- Say "ನಮಸ್ಕಾರ" (namaskāra - hello)
- Say "ನನ್ನ ಹೆಸರು..." (nanna hesaru - my name is...)
- Practice counting in Kannada: "ಒಂದು, ಎರಡು, ಮೂರು" (ondu, eradu, mūru)

**To get voice responses back:**
The bot can respond with text by default. To enable voice responses, you can ask:
- "Respond with voice messages please"
- Or modify the agent to prefer voice output

## Configuration Options

### Separate Phone Number (Recommended)

For best results, use a separate phone number:
```json
{
  "channels": {
    "whatsapp": {
      "dmPolicy": "allowlist",
      "allowFrom": ["+910000"],
      "selfChatMode": false
    }
  }
}
```

### Personal Phone (Fallback)

If using your personal WhatsApp:
```json
{
  "channels": {
    "whatsapp": {
      "dmPolicy": "allowlist",
      "allowFrom": ["+910000"],
      "selfChatMode": true
    }
  }
}
```

Then message yourself using WhatsApp's "Message Yourself" feature.

## Customizing the Teacher Personality

Edit the `systemPrompt` in `~/.clawdbot/moltbot.json` to change:
- Teaching style (strict vs casual)
- Focus areas (conversational vs formal Kannada)
- Cultural depth
- Pace of learning

## Advanced Features

### Multi-level Learning

You can create different agents for different proficiency levels:

```json
{
  "agents": {
    "list": [
      {
        "id": "beginner",
        "systemPrompt": "Focus on basic vocabulary and simple greetings..."
      },
      {
        "id": "intermediate",
        "systemPrompt": "Practice conversations and grammar..."
      },
      {
        "id": "advanced",
        "systemPrompt": "Discuss literature and complex topics..."
      }
    ]
  }
}
```

### Voice Calls (Optional)

For live phone practice, you can set up the voice-call plugin:

```bash
pnpm moltbot plugins install @moltbot/voice-call
```

This requires:
- Twilio/Telnyx/Plivo account
- Public webhook URL
- Additional configuration (see docs/plugins/voice-call.md)

## Troubleshooting

### WhatsApp not linked
```bash
pnpm moltbot channels status
# If not linked, run:
pnpm moltbot channels login
```

### Gateway not running
```bash
# Check if gateway is running
pnpm moltbot health

# Start it if not running
pnpm moltbot gateway --port 18789
```

### Voice messages not transcribed

Make sure OpenAI API key is configured for Whisper:
```bash
pnpm moltbot config get messages.stt
```

### Bot not responding

1. Check allowlist includes your number
2. Verify gateway is running
3. Check logs:
```bash
pnpm moltbot logs --follow
```

## Resources

- **Moltbot Docs**: https://docs.molt.bot
- **WhatsApp Channel Guide**: https://docs.molt.bot/whatsapp
- **Configuration Reference**: https://docs.molt.bot/configuration
- **Voice Setup**: https://docs.molt.bot/plugins/voice-call

## Example Learning Path

**Week 1-2: Basics**
- Greetings: ನಮಸ್ಕಾರ, ಹೇಗಿದ್ದೀರಿ
- Numbers: 1-10, 1-100
- Common phrases: thank you, please, sorry

**Week 3-4: Conversations**
- Introducing yourself
- Asking for directions
- Ordering food
- Shopping phrases

**Week 5-6: Grammar**
- Verb conjugations
- Sentence structure
- Past/present/future tense

**Week 7-8: Script**
- Vowels (ಸ್ವರಗಳು)
- Consonants (ವ್ಯಂಜನಗಳು)
- Writing simple words

## Tips for Effective Learning

1. **Daily Practice**: Send at least 5 messages per day
2. **Mix Text and Voice**: Practice both writing and speaking
3. **Ask for Corrections**: Request feedback on your Kannada
4. **Cultural Context**: Ask about festivals, traditions, food
5. **Progressive Difficulty**: Start simple, gradually increase complexity
6. **Voice Practice**: Record yourself speaking Kannada phrases
7. **Immersion**: Try thinking in Kannada for simple daily activities

## Support

If you encounter issues:
1. Run `pnpm moltbot doctor` for health checks
2. Check the logs: `pnpm moltbot logs --follow`
3. Consult the docs: https://docs.molt.bot
4. Join Discord: https://discord.gg/clawd