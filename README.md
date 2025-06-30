# CAVEaT Toolkit Installer

**Cloud Adversarial Vectors, Exploits, and Threats Development Environment**

A one-click installer for setting up the Cloud Security Alliance CAVEaT development environment on Windows.

## 🚀 Quick Start

### For End Users:
1. **Download** the installer: `caveat-installer.bat`
2. **Right-click** and select "Run as administrator"
3. **Follow the prompts** - the installer handles everything automatically!

### What It Does:
- ✅ Installs required prerequisites (Git, Node.js, GitHub CLI)
- ✅ Downloads the CAVEaT toolkit
- ✅ Helps you authenticate with GitHub
- ✅ Forks Cloud Security Alliance repositories to your account
- ✅ Sets up your development workspace
- ✅ Creates helpful reference documentation

## 📋 System Requirements

- **OS**: Windows 10/11
- **Permissions**: Administrator access required
- **Internet**: Active connection needed
- **GitHub**: Account required (free)

## 📁 What Gets Installed

After installation, you'll have:
%USERPROFILE%\caveat-toolkit\          # Installer and toolkit
%USERPROFILE%\caveat-workspace\        # Your development workspace
├── cti/                               # CTI repository (your fork)
├── CAVEaT/                           # CAVEaT repository (your fork)
├── QUICK-REFERENCE.md                # Quick start guide
└── SETUP-INSTRUCTIONS.md             # Detailed workflow instructions

## 🔧 Repositories Connected

The installer automatically connects you to:

- **Upstream**: `CloudSecurityAlliance/cti`
- **Upstream**: `CloudSecurityAlliance-WG/CAVEaT`
- **Your Forks**: `yourusername/cti` and `yourusername/CAVEaT`

## 🎯 Next Steps After Installation

1. **Read the documentation** in your workspace folder
2. **Open Claude** at https://claude.ai
3. **Connect GitHub integration** in Claude
4. **Grant access** to your forked repositories
5. **Start creating STIX objects** for cloud threat intelligence!

## 🔍 Troubleshooting

### If installation fails:
```cmd
cd %USERPROFILE%\caveat-toolkit
node bin\caveat-setup.js doctor