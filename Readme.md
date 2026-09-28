# Portable Linux Development Environment (`linux-dev-env`)

A fully containerized, headless Linux development environment built on **Ubuntu 22.04** and powered by **code-server**. Designed to provide seamless continuity for Flutter and Python development across any host workstation via Docker.

## 🛠️ Included Tech Stack & Toolchains

* **IDE / Core:** `code-server` (VS Code web interface on port `8080`)
* **Flutter SDK:** `v3.47.0` (Configured on the `stable` branch)
* **Python Engine:** Python `3.11` (Default system runtime via `deadsnakes` PPA)
* **Android Toolchain:**
  * OpenJDK 17 (`JAVA_HOME` configured)
  * Android SDK Command-Line Tools
  * Android Platforms: `android-36` & `android-34`
  * Build Tools: `36.0.0` & `28.0.3`
* **Linux Desktop Toolchain:** `clang`, `cmake`, `ninja-build`, `pkg-config`, `libgtk-3-dev`, `mesa-utils`
* **Web Engine:** `chromium-browser` (`CHROME_EXECUTABLE` path pre-configured)

---

## 🚀 Quick Start (Deployment)

### Prerequisites

* [Docker Desktop](https://www.docker.com/products/docker-desktop/) installed and running on the host machine.

### Step 1: Launch Container

Run the appropriate command for your host terminal to pull and start the workspace.

#### **Windows (PowerShell):**

```powershell
docker run -d `
  --name my-dev-workspace `
  -p 8080:8080 `
  -v "${PWD}\workspace:/home/coder/workspace" `
  mhp2/linux-dev-env:latest `
  code-server --bind-addr 0.0.0.0:8080
```

#### **Linux / macOS (Bash):**

```bash
docker run -d \
  --name my-dev-workspace \
  -p 8080:8080 \
  -v "$(pwd)/workspace:/home/coder/workspace" \
  mhp2/linux-dev-env:latest \
  code-server --bind-addr 0.0.0.0:8080
```

> **Note:** Host files placed in the local `workspace` directory are mounted to `/home/coder/workspace` and remain persistent across container restarts or image updates.

---

## 💻 Access Options

### Option A: Web Browser Interface (Default)

1. Open your browser on the host machine and navigate to:
   ```text
   http://localhost:8080
   ```
2. Your full `code-server` IDE will load with all SDKs and tools ready to go.

### Option B: VS Code Desktop via Dev Containers

If using extensions with complex UI webviews (like AI assistants or Copilot) that encounter browser proxy restrictions in `code-server`:

1. Install the **Dev Containers** extension in VS Code on your host PC.
2. Press `Ctrl + Shift + P` (or `Cmd + Shift + P` on Mac).
3. Select **Dev Containers: Attach to Running Container**.
4. Choose `my-dev-workspace`.

---

## 🔄 Updating & Preserving State (`docker commit` Workflow)

When you make changes *inside* the container (e.g., installing new extensions or global packages) and want to update your cloud image:

### 1. Clean Temporary Caches (Inside Container Terminal)

Run the following inside the container terminal to keep your image size optimal:

```bash
# Clear APT caches
sudo apt clean
sudo rm -rf /var/lib/apt/lists/*

# Clear package and tool build caches
rm -rf ~/.cache/*
rm -rf ~/.gradle/caches/
sudo rm -rf /tmp/* /var/tmp/*

# Clear shell command history
cat /dev/null > ~/.bash_history && history -c
```

### 2. Freeze and Push Image (On Host Terminal)

Execute these commands in your host machine's terminal:

```powershell
# Freeze current live container state into the image snapshot
docker commit my-dev-workspace mhp2/linux-dev-env:latest

# Push updated snapshot to Docker Hub
docker push mhp2/linux-dev-env:latest
```

---

## ⚙️ Helpful Commands

| Action | Command |
| :--- | :--- |
| **Check Environment Diagnostics** | `flutter doctor` *(inside container)* |
| **Interactive Terminal Session** | `docker exec -it my-dev-workspace bash` |
| **Stop Workspace** | `docker stop my-dev-workspace` |
| **Start Stopped Workspace** | `docker start my-dev-workspace` |
| **Remove Container (Cleanup)** | `docker rm -f my-dev-workspace` |
| **Pull Fresh Image** | `docker pull mhp2/linux-dev-env:latest` |