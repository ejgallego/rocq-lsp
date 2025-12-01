import { WebviewPanel } from "vscode";
import {
  ConfigChangeEvent,
  ConfigChanged,
  CoqLspClientConfig,
  ConfigFieldKey,
} from "../lib/types";

export interface ConfigSubscription {
  fields: ConfigFieldKey[];
  callback: (changes: ConfigChangeEvent[]) => void;
}

/**
 * Manages client configuration changes and subscriptions
 */
export class ConfigManager {
  private currentConfig: CoqLspClientConfig | null = null;
  private webviewPanels: Set<WebviewPanel> = new Set();

  /**
   * Register a webview panel to receive config update messages
   */
  registerWebview(panel: WebviewPanel): void {
    this.webviewPanels.add(panel);

    // Clean up when panel is disposed
    panel.onDidDispose(() => {
      this.webviewPanels.delete(panel);
    });

    // Send initial config if available
    if (this.currentConfig) {
      const changes = this.detectChanges(null, this.currentConfig);
      this.notifyWebviews(changes);
    }
  }

  /**
   * Unregister a webview panel
   */
  unregisterWebview(panel: WebviewPanel): void {
    this.webviewPanels.delete(panel);
  }

  /**
   * Update the configuration and notify all subscribers
   */
  updateConfig(newConfig: CoqLspClientConfig): void {
    const changes = this.detectChanges(this.currentConfig, newConfig);

    if (changes.length > 0) {
      // Update current config
      this.currentConfig = newConfig;
      this.notifyWebviews(changes);
    }
  }

  /**
   * Detect changes between old and new config
   * @returns A list of the differences in ConfigChangeEvents
   */
  private detectChanges(
    oldConfig: CoqLspClientConfig | null,
    newConfig: CoqLspClientConfig
  ): ConfigChangeEvent[] {
    const changes: ConfigChangeEvent[] = [];
    // NOTE: sort of an unsafe cast here
    const keys = Object.keys(newConfig) as ConfigFieldKey[];

    for (const field of keys) {
      // Only compute differences.
      // NOTE: if oldConfig is null, we consider all fields as changed
      if (!oldConfig || oldConfig[field] !== newConfig[field]) {
        changes.push({
          field,
          oldValue: oldConfig ? oldConfig[field] : undefined,
          newValue: newConfig[field],
        });
      }
    }

    return changes;
  }

  /**
   * Post configuration changes to all registered webviews
   */
  private notifyWebviews(changes: ConfigChangeEvent[]): void {
    for (const panel of this.webviewPanels) {
      const msg: ConfigChanged = {
        method: "configChanged",
        params: { changes },
      };
      panel.webview.postMessage(msg);
    }
  }
}

// Global config manager instance
export const configManager = new ConfigManager();
