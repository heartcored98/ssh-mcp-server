# 🔐 ssh-mcp-server

![NPM Version](https://img.shields.io/npm/v/%40fangjunjie%2Fssh-mcp-server?label=%40fangjunjie%2Fssh-mcp-server)
![GitHub forks](https://img.shields.io/github/forks/classfang/ssh-mcp-server)
![GitHub Repo stars](https://img.shields.io/github/stars/classfang/ssh-mcp-server)
![GitHub Issues or Pull Requests](https://img.shields.io/github/issues/classfang/ssh-mcp-server)
![GitHub Issues or Pull Requests](https://img.shields.io/github/issues-closed/classfang/ssh-mcp-server)
![GitHub Issues or Pull Requests](https://img.shields.io/github/issues-pr/classfang/ssh-mcp-server)
![GitHub Issues or Pull Requests](https://img.shields.io/github/issues-pr-closed/classfang/ssh-mcp-server)

SSH-based MCP (Model Context Protocol) server that allows remote execution of SSH commands via the MCP protocol.

English Document | [中文文档](README_CN.md)

## 📝 Project Overview

ssh-mcp-server is a bridging tool that enables AI assistants and other applications supporting the MCP protocol to execute remote SSH commands through a standardized interface. This allows AI assistants to safely operate remote servers, execute commands, and retrieve results without directly exposing SSH credentials to AI models.

Wechat MCP Technical Exchange Group:

![wx_1.png](images/wx_1.png)

## ✨ Key Features

- **🔒 Secure Connections**: Supports multiple secure SSH connection methods, including password authentication and private key authentication (with passphrase support)
- **🛡️ Command Security Control**: Precisely control the range of allowed commands through flexible blacklist and whitelist mechanisms to prevent dangerous operations
- **🔄 Standardized Interface**: Complies with MCP protocol specifications for seamless integration with AI assistants supporting the protocol
- **📂 File Transfer**: Supports bidirectional file transfers, uploading local files to servers or downloading files from servers
- **🔑 Credential Isolation**: SSH credentials are managed entirely locally and never exposed to AI models, enhancing security
- **🚀 Ready to Use**: Can be run directly using NPX without global installation, making it convenient and quick to deploy

## 📦 Open Source Repository

GitHub: [https://github.com/classfang/ssh-mcp-server](https://github.com/classfang/ssh-mcp-server)

NPM: [https://www.npmjs.com/package/@fangjunjie/ssh-mcp-server](https://www.npmjs.com/package/@fangjunjie/ssh-mcp-server)

## 🛠️ Tools List

| Tool | Name | Description |
|---------|-----------|----------|
| execute-command | Command Execution Tool | Execute SSH commands on remote servers and get results |
| upload | File Upload Tool | Upload local files to specified locations on remote servers |
| download | File Download Tool | Download files from remote servers to local specified locations |
| list-servers | List Servers Tool | List all available SSH server configurations |

## 📚 Usage

### 🚀 Recommended Setup For Forks And Other Machines

If you are using this repository directly, a fork of it, or local unpublished changes, prefer running the built local entrypoint instead of `npx @fangjunjie/ssh-mcp-server`. The npm package only contains the code that has been published to npm.

Recommended bootstrap flow:

```bash
git clone <your-fork-or-repo-url>
cd ssh-mcp-server
npm install
npm run build
cp ssh-config.local.example.json ssh-config.local.json
```

Then update `ssh-config.local.json`:

- Use an absolute path for `privateKey` such as `/Users/alice/.ssh/id_rsa` or `/home/alice/.ssh/id_ed25519`.
- Do not use `~/.ssh/...` in config values. This server does not expand `~`.
- Prefer the object JSON format so the top-level key becomes a stable `connectionName`.
- Keep `collectSystemStatus` disabled unless you explicitly want system metadata returned by `list-servers`.

Collect the host fingerprint before connecting:

```bash
ssh-keyscan -p 22 server.example.com 2>/dev/null | ssh-keygen -lf - -E sha256
```

Run the server locally with your config:

```bash
node build/index.js --config-file /absolute/path/to/ssh-config.local.json --pre-connect
```

For Codex desktop / CLI style MCP registration, use the local build path:

```toml
[mcp_servers.ssh_multi]
command = "node"
args = [
  "/absolute/path/to/ssh-mcp-server/build/index.js",
  "--config-file",
  "/absolute/path/to/ssh-mcp-server/ssh-config.local.json",
  "--pre-connect",
]
```

Local config files such as `ssh-config.local.json` are intended to stay uncommitted. This repository already ignores common local config filenames.

### 🔧 MCP Configuration Examples

> **⚠️ Important**: In MCP configuration files, each command line argument and its value must be separate elements in the `args` array. Do NOT combine them with spaces. For example, use `"--host", "192.168.1.1"` instead of `"--host 192.168.1.1"`.

#### ⚙️ Command Line Options

```text
Options:
  --config-file       JSON configuration file path (recommended for multiple servers)
  --ssh               SSH connection configuration (can be JSON string or legacy format)
  -h, --host          SSH server host address
  -p, --port          SSH server port
  -u, --username      SSH username
  -w, --password      SSH password
  -k, --privateKey    SSH private key file path
  -P, --passphrase    Private key passphrase (if any)
  -f, --host-fingerprint  SSH host key fingerprint (recommended format: SHA256:...)
  --insecure-skip-host-key-checking  Disable host key verification (insecure, not recommended)
  -W, --whitelist     Command whitelist, comma-separated regular expressions
  -B, --blacklist     Command blacklist, comma-separated regular expressions
  -s, --socksProxy    SOCKS proxy server address (e.g., socks://user:password@host:port)
  --collect-status    Collect remote system status automatically (default: disabled)
  --pre-connect       Pre-connect to all configured SSH servers on startup

```

#### 🔑 Using Password

```json
{
  "mcpServers": {
    "ssh-mcp-server": {
      "command": "npx",
      "args": [
        "-y",
        "@fangjunjie/ssh-mcp-server",
        "--host", "192.168.1.1",
        "--port", "22",
        "--username", "root",
        "--password", "pwd123456",
        "--host-fingerprint", "SHA256:REPLACE_WITH_SERVER_FINGERPRINT"
      ]
    }
  }
}
```

#### 🔐 Using Private Key

```json
{
  "mcpServers": {
    "ssh-mcp-server": {
      "command": "npx",
      "args": [
        "-y",
        "@fangjunjie/ssh-mcp-server",
        "--host", "192.168.1.1",
        "--port", "22",
        "--username", "root",
        "--privateKey", "/absolute/path/to/id_rsa",
        "--host-fingerprint", "SHA256:REPLACE_WITH_SERVER_FINGERPRINT"
      ]
    }
  }
}
```

#### 🔏 Using Private Key with Passphrase

```json
{
  "mcpServers": {
    "ssh-mcp-server": {
      "command": "npx",
      "args": [
        "-y",
        "@fangjunjie/ssh-mcp-server",
        "--host", "192.168.1.1",
        "--port", "22",
        "--username", "root",
        "--privateKey", "/absolute/path/to/id_rsa",
        "--passphrase", "pwd123456",
        "--host-fingerprint", "SHA256:REPLACE_WITH_SERVER_FINGERPRINT"
      ]
    }
  }
}
```

#### 🌐 Using SOCKS Proxy

```json
{
  "mcpServers": {
    "ssh-mcp-server": {
      "command": "npx",
      "args": [
        "-y",
        "@fangjunjie/ssh-mcp-server",
        "--host", "192.168.1.1",
        "--port", "22",
        "--username", "root",
        "--password", "pwd123456",
        "--host-fingerprint", "SHA256:REPLACE_WITH_SERVER_FINGERPRINT",
        "--socksProxy", "socks://username:password@proxy-host:proxy-port"
      ]
    }
  }
}

```

#### 📝 Using Command Whitelist and Blacklist

Use the `--whitelist` and `--blacklist` parameters to restrict the range of executable commands. Multiple patterns are separated by commas. Each pattern is a regular expression used to match commands.

Example: Using Command Whitelist

```json
{
  "mcpServers": {
    "ssh-mcp-server": {
      "command": "npx",
      "args": [
        "-y",
        "@fangjunjie/ssh-mcp-server",
        "--host", "192.168.1.1",
        "--port", "22",
        "--username", "root",
        "--password", "pwd123456",
        "--host-fingerprint", "SHA256:REPLACE_WITH_SERVER_FINGERPRINT",
        "--whitelist", "^ls( .*)?,^cat .*,^df.*"
      ]
    }
  }
}
```

Example: Using Command Blacklist

```json
{
  "mcpServers": {
    "ssh-mcp-server": {
      "command": "npx",
      "args": [
        "-y",
        "@fangjunjie/ssh-mcp-server",
        "--host", "192.168.1.1",
        "--port", "22",
        "--username", "root",
        "--password", "pwd123456",
        "--host-fingerprint", "SHA256:REPLACE_WITH_SERVER_FINGERPRINT",
        "--blacklist", "^rm .*,^shutdown.*,^reboot.*"
      ]
    }
  }
}
```

> Note: If both whitelist and blacklist are specified, the system will first check whether the command is in the whitelist, and then check whether it is in the blacklist. The command must pass both checks to be executed.

### 🧩 Multi-SSH Connection Example

There are three ways to configure multiple SSH connections:

#### 📄 Method 1: Using Config File (Recommended)

Create a JSON configuration file (e.g., `ssh-config.json`):

> Tip: start from `ssh-config.local.example.json` and copy it to `ssh-config.local.json`. The object format below is the best fit for long-lived multi-host setups because each top-level key becomes the MCP `connectionName`.

**Array Format:**
```json
[
  {
    "name": "dev",
    "host": "1.2.3.4",
    "port": 22,
    "username": "alice",
    "privateKey": "/absolute/path/to/id_rsa",
    "hostFingerprint": "SHA256:REPLACE_WITH_DEV_FINGERPRINT",
    "collectSystemStatus": false,
    "commandBlacklist": ["^\\s*rm\\s+-rf\\s+/.*$"]
  },
  {
    "name": "prod",
    "host": "5.6.7.8",
    "port": 22,
    "username": "bob",
    "privateKey": "/absolute/path/to/id_ed25519",
    "hostFingerprint": "SHA256:REPLACE_WITH_PROD_FINGERPRINT",
    "collectSystemStatus": false,
    "commandBlacklist": ["^\\s*rm\\s+-rf\\s+/.*$"]
  }
]
```

**Object Format:**
```json
{
  "dev": {
    "host": "1.2.3.4",
    "port": 22,
    "username": "alice",
    "privateKey": "/absolute/path/to/id_rsa",
    "hostFingerprint": "SHA256:REPLACE_WITH_DEV_FINGERPRINT",
    "collectSystemStatus": false,
    "commandBlacklist": ["^\\s*rm\\s+-rf\\s+/.*$"]
  },
  "prod": {
    "host": "5.6.7.8",
    "port": 22,
    "username": "bob",
    "privateKey": "/absolute/path/to/id_ed25519",
    "hostFingerprint": "SHA256:REPLACE_WITH_PROD_FINGERPRINT",
    "collectSystemStatus": false,
    "commandBlacklist": ["^\\s*rm\\s+-rf\\s+/.*$"]
  }
}
```

Then use the `--config-file` parameter:

```json
{
  "mcpServers": {
    "ssh-mcp-server": {
      "command": "npx",
      "args": [
        "-y",
        "@fangjunjie/ssh-mcp-server",
        "--config-file", "ssh-config.json"
      ]
    }
  }
}
```

#### 🔧 Method 2: Using JSON Format with --ssh Parameter

You can pass JSON-formatted configuration strings directly:

```json
{
  "mcpServers": {
    "ssh-mcp-server": {
      "command": "npx",
      "args": [
        "-y",
        "@fangjunjie/ssh-mcp-server",
        "--ssh", "{\"name\":\"dev\",\"host\":\"1.2.3.4\",\"port\":22,\"username\":\"alice\",\"password\":\"{abc=P100s0}\",\"hostFingerprint\":\"SHA256:REPLACE_WITH_DEV_FINGERPRINT\",\"socksProxy\":\"socks://127.0.0.1:10808\"}",
        "--ssh", "{\"name\":\"prod\",\"host\":\"5.6.7.8\",\"port\":22,\"username\":\"bob\",\"password\":\"yyy\",\"hostFingerprint\":\"SHA256:REPLACE_WITH_PROD_FINGERPRINT\",\"socksProxy\":\"socks://127.0.0.1:10808\"}"
      ]
    }
  }
}
```

#### 📝 Method 3: Legacy Comma-Separated Format (Backward Compatible)

For simple cases without special characters in passwords, you can still use the legacy format:

```bash
npx @fangjunjie/ssh-mcp-server \
  --ssh "name=dev,host=1.2.3.4,port=22,user=alice,password=xxx,hostFingerprint=SHA256:REPLACE_WITH_DEV_FINGERPRINT" \
  --ssh "name=prod,host=5.6.7.8,port=22,user=bob,password=yyy,hostFingerprint=SHA256:REPLACE_WITH_PROD_FINGERPRINT"
```

> **⚠️ Note**: The legacy format may have issues with passwords containing special characters like `=`, `,`, `{`, `}`. Use Method 1 or Method 2 for passwords with special characters.

> **⚠️ Note**: `privateKey` values should be absolute filesystem paths. `~` is not expanded.

In MCP tool calls, specify the connection name via the `connectionName` parameter. If omitted, the default connection is used.

Example (execute command on 'prod' connection):

```json
{
  "tool": "execute-command",
  "params": {
    "cmdString": "ls -al",
    "connectionName": "prod"
  }
}
```

Example (execute command with timeout options):

```json
{
  "tool": "execute-command",
  "params": {
    "cmdString": "ping -c 10 127.0.0.1",
    "connectionName": "prod",
    "timeout": 5000
  }
}
```

### ⏱️ Command Execution Timeout

The `execute-command` tool supports timeout options to prevent commands from hanging indefinitely:

- **timeout**: Command execution timeout in milliseconds (optional, default is 30000ms)

This is particularly useful for commands like `ping`, `tail -f`, or other long-running processes that might block execution.

### 🗂️ List All SSH Servers

You can use the MCP tool `list-servers` to get all available SSH server configurations:

Example call:

```json
{
  "tool": "list-servers",
  "params": {}
}
```

Example response:

```json
[
  { "name": "dev", "host": "1.2.3.4", "port": 22, "username": "alice", "connected": true },
  { "name": "prod", "host": "5.6.7.8", "port": 22, "username": "bob", "connected": false }
]
```

If `collectSystemStatus` is enabled for a connection, the response can also include a `status` object with remote system metadata.

## 🛡️ Security Considerations

This server provides powerful capabilities to execute commands and transfer files on remote servers. To ensure it is used securely, please consider the following:

- **Command Whitelisting**: It is *strongly recommended* to use the `--whitelist` option to restrict the set of commands that can be executed. Without a whitelist, any command can be executed on the remote server, which can be a significant security risk.
- **Host Key Verification**: Set `--host-fingerprint SHA256:...` (or `hostFingerprint` in config) to pin the SSH server host key and prevent MITM attacks. Avoid `--insecure-skip-host-key-checking` unless you fully trust the network.
- **Private Key Paths**: Use absolute paths for `privateKey`. Shell shortcuts like `~` are not expanded by this server.
- **Private Key Security**: The server reads the SSH private key into memory. Ensure that the machine running the `ssh-mcp-server` is secure. Do not expose the server to untrusted networks.
- **Denial of Service (DoS)**: The server does not have built-in rate limiting. An attacker could potentially launch a DoS attack by flooding the server with connection requests or large file transfers. It is recommended to run the server behind a firewall or reverse proxy with rate-limiting capabilities.
- **Path Traversal**: Upload/download local paths are restricted to the current working directory. Use a dedicated workspace and least-privilege filesystem permissions.
- **Metadata Collection**: Remote system metadata collection is disabled by default. Enable it explicitly with `--collect-status` only when needed.

## 🌟 Star History

[![Star History Chart](https://api.star-history.com/svg?repos=classfang/ssh-mcp-server&type=date&legend=top-left)](https://www.star-history.com/#classfang/ssh-mcp-server&type=date&legend=top-left)
