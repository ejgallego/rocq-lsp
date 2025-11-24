import { WebviewPanel } from "vscode";
import { CoqLspClientConfig } from "./config";
import { useState, useEffect, useCallback, useMemo } from "react";
import { ConfigChangeEvent, CoqMessageEvent, ConfigChanged } from "../lib/types";

export type ConfigFieldKey = keyof CoqLspClientConfig;

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
      if (!oldConfig || (oldConfig[field] !== newConfig[field])) {
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


/**
 * Hook to subscribe to specific configuration fields
 * @param fields - Array of field names to watch for changes
 * @param onConfigChange - Callback when any of the watched fields change
 */
export function useConfigSubscription(
  fields: ConfigFieldKey[],
  onConfigChange: (changes: ConfigChangeEvent[]) => void
): CoqLspClientConfig | null {
  const [config, setConfig] = useState<CoqLspClientConfig | null>(null);

  useEffect(() => {
    function handleConfigMessage(event: CoqMessageEvent) {
      const { method, params } = event.data;

      switch (method) {
        case "configChanged":
          // Filter to only the fields we're subscribed to
          const relevantChanges = params.changes.filter((change) =>
            fields.includes(change.field)
          );

          if (relevantChanges.length > 0) {
            // Update config state
            setConfig((prevConfig) => {
              // TODO: Is the below unsafe?
              const newConfig: CoqLspClientConfig = prevConfig ? { ...prevConfig } : {} as CoqLspClientConfig;
              for (const change of relevantChanges) {
                (newConfig as any)[change.field] = change.newValue;
              }
              return newConfig;
            });

            // Notify callback
            onConfigChange(relevantChanges);
          }
          break;
      }
    }

    window.addEventListener("message", handleConfigMessage);
    return () => window.removeEventListener("message", handleConfigMessage);
  }, [fields, onConfigChange]);

  return config;
}

/**
 * Hook to get a specific configuration value with live updates
 * @param field - The configuration field to watch
 * @param defaultValue - Default value if config is not yet loaded
 */
export function useConfigValue<T>(field: ConfigFieldKey, defaultValue: T): T {
  // TODO: With some typescript fanciness, we could probably infer T from CoqLspClientConfig[field]
  const [value, setValue] = useState<T>(defaultValue);

  // Memoize the callback
  const handleConfigChange = useCallback((changes: ConfigChangeEvent[]) => {
    const change = changes.find((c) => c.field === field);
    // We only perform an update if relevant config changes occurred
    if (change) {
      setValue(change.newValue);
    }
  }, [field]);

  // Memoize fields
  const fields = useMemo(() => [field], [field]);

  useConfigSubscription(fields, handleConfigChange);

  return value;
}