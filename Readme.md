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

## 🚀 Quick Start (Deployment)

### Prerequisites

* [Docker Desktop](https://www.docker.com/products/docker-desktop/?utm_source=gemini) installed on host machine.

### Step 1: Launch Container

Run the appropriate command for your host terminal. Replace `YOUR_USERNAME` with your Docker Hub username.

#### **Windows (PowerShell):**

```
docker run -d `
  --name my-dev-workspace `
  -p 8080:8080 `
  -v "${PWD}\workspace:/home/coder/workspace" `
  YOUR_USERNAME/linux-dev-env:latest

```

#### **Linux / macOS (Bash):**

```
docker run -d \
  --name my-dev-workspace \
  -p 8080:8080 \
  -v "$(pwd)/workspace:/home/coder/workspace" \
  YOUR_USERNAME/linux-dev-env:latest

```

> **Note:** Host files placed in the local `workspace` directory are mounted to `/home/coder/workspace` and remain safe across container restarts or deletions.

## 💻 Access Options

### Option A: Web Browser Interface (Default)

1. Open your host browser and navigate to:

   ```
   http://localhost:8080
   
   ```

2. Your full `code-server` IDE will open with all tools ready.

### Option B: VS Code Desktop via Dev Containers (Recommended for Extension Webviews)

If using extensions with complex UI webviews (like AI assistants, Antigravity, or Copilot) that encounter browser proxy restrictions in `code-server`:

1. Install the **Dev Containers** extension in your host PC's VS Code.

2. Click the bottom-left Remote icon ($\gt\_$) or press `Ctrl + Shift + P`.

3. Select **Dev Containers: Attach to Running Container**.

4. Choose `my-dev-workspace`.

## 🔄 Updating & Preserving State (`docker commit` Workflow)

When you make changes *inside* the container (e.g., installing new extensions, CLI tools, or packages) and want to save them into your cloud snapshot:

### 1. Clean Temporary Caches (Inside Container Terminal)

Run the following inside the container terminal to keep your image size optimal:

```
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

```
# Freeze current live container state into image
docker commit my-dev-workspace YOUR_USERNAME/linux-dev-env:latest

# Push updated snapshot to Docker Hub
docker push YOUR_USERNAME/linux-dev-env:latest

```

## ⚙️ Helpful Commands

| Action | Command | 
 | ----- | ----- | 
| **Check Environment Diagnostics** | `flutter doctor` *(inside container)* | 
| **Stop Workspace** | `docker stop my-dev-workspace` | 
| **Start Stopped Workspace** | `docker start my-dev-workspace` | 
| **Remove Container** | `docker rm -f my-dev-workspace` | 
| **Pull Fresh Image** | `docker pull YOUR_USERNAME/linux-dev-env:latest` | 
