import { useState, useEffect, useCallback, useMemo } from "react";
import {
  CoqMessageEvent,
  ConfigChangeEvent,
  CoqLspClientConfig,
  ConfigFieldKey,
} from "../../lib/types";

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
              const newConfig: CoqLspClientConfig = prevConfig
                ? { ...prevConfig }
                : ({} as CoqLspClientConfig);
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
  const handleConfigChange = useCallback(
    (changes: ConfigChangeEvent[]) => {
      const change = changes.find((c) => c.field === field);
      // We only perform an update if relevant config changes occurred
      if (change) {
        setValue(change.newValue);
      }
    },
    [field]
  );

  // Memoize fields
  const fields = useMemo(() => [field], [field]);

  useConfigSubscription(fields, handleConfigChange);

  return value;
}
