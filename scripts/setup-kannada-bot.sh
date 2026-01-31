#!/usr/bin/env bash
set -euo pipefail

echo "🦞 Moltbot Kannada Language Learning Bot Setup"
echo "=============================================="
echo ""

# Check if running from the repo root
if [[ ! -f "package.json" ]] || ! grep -q "moltbot" package.json; then
  echo "❌ Error: Please run this script from the moltbot repository root"
  exit 1
fi

# Check Node version
NODE_VERSION=$(node --version | cut -d'v' -f2 | cut -d'.' -f1)
if [[ "$NODE_VERSION" -lt 22 ]]; then
  echo "❌ Error: Node.js 22+ required (you have: $(node --version))"
  exit 1
fi

echo "✅ Node.js version: $(node --version)"
echo ""

# Ask for phone number
echo "📱 WhatsApp Setup"
echo "Enter your phone number in E.164 format (e.g., +919876543210):"
read -r PHONE_NUMBER

if [[ ! "$PHONE_NUMBER" =~ ^\+[0-9]{10,15}$ ]]; then
  echo "⚠️  Warning: Phone number format might be incorrect. Continue anyway? (y/n)"
  read -r CONTINUE
  if [[ "$CONTINUE" != "y" ]]; then
    exit 1
  fi
fi

# Create config directory
mkdir -p ~/.clawdbot

# Copy and customize config
echo ""
echo "📝 Creating Moltbot configuration..."

cat > ~/.clawdbot/moltbot.json << EOF
{
  "identity": {
    "name": "Kannada Teacher Bot"
  },
  "channels": {
    "whatsapp": {
      "dmPolicy": "allowlist",
      "allowFrom": ["${PHONE_NUMBER}"],
      "selfChatMode": false,
      "sendReadReceipts": true,
      "ackReaction": {
        "emoji": "📚",
        "direct": true
      }
    }
  },
  "agents": {
    "defaults": {
      "systemPrompt": "You are a patient and encouraging Kannada language teacher named 'ಗುರು' (Guru). Your goal is to help users learn Kannada through:\n\n1. **Vocabulary Building**: Teach common words, phrases, and their pronunciation\n2. **Grammar Explanations**: Explain Kannada grammar rules clearly with examples\n3. **Conversational Practice**: Engage in simple conversations in Kannada\n4. **Cultural Context**: Share insights about Karnataka culture and traditions\n5. **Voice Learning**: When users send voice messages, help them with pronunciation\n6. **Script Learning**: Teach Kannada script (ಕನ್ನಡ ಲಿಪಿ) progressively\n\nAlways:\n- Respond in a mix of English and Kannada based on user's level\n- Provide transliterations for Kannada words (e.g., ನಮಸ್ಕಾರ - namaskāra)\n- Correct pronunciation gently when users practice\n- Celebrate progress and encourage continued learning\n- For beginners, start with basic greetings and common phrases\n- For voice messages, acknowledge their effort and provide feedback on pronunciation",
      "model": "claude-opus-4-5",
      "mediaMaxMb": 5,
      "thinking": "medium"
    }
  },
  "messages": {
    "stt": {
      "provider": "openai",
      "openai": {
        "model": "whisper-1",
        "language": "kn"
      }
    },
    "tts": {
      "provider": "openai",
      "openai": {
        "voice": "nova",
        "model": "tts-1"
      }
    }
  }
}
EOF

echo "✅ Configuration created at: ~/.clawdbot/moltbot.json"
echo ""

# Check if dependencies are installed
echo "📦 Checking dependencies..."
if [[ ! -d "node_modules" ]]; then
  echo "Installing dependencies (this may take a minute)..."
  pnpm install
else
  echo "✅ Dependencies already installed"
fi

# Build if needed
if [[ ! -d "dist" ]]; then
  echo ""
  echo "🔨 Building Moltbot..."
  pnpm build
else
  echo "✅ Build already exists"
fi

echo ""
echo "🎉 Setup complete!"
echo ""
echo "Next steps:"
echo ""
echo "1️⃣  Login to Anthropic (for Claude AI):"
echo "   pnpm moltbot login"
echo ""
echo "2️⃣  Link your WhatsApp:"
echo "   pnpm moltbot channels login"
echo "   (Scan the QR code with WhatsApp → Settings → Linked Devices)"
echo ""
echo "3️⃣  Start the gateway:"
echo "   pnpm moltbot gateway --port 18789 --verbose"
echo ""
echo "4️⃣  Send a test message from WhatsApp to ${PHONE_NUMBER}"
echo "   Try: 'Teach me basic Kannada greetings'"
echo ""
echo "📖 Full guide: KANNADA_BOT_GUIDE.md"
echo ""
echo "For voice support, you'll also need an OpenAI API key."
echo "Add it to ~/.clawdbot/moltbot.json under messages.stt.openai.apiKey"
echo "and messages.tts.openai.apiKey"
