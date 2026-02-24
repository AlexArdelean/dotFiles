---
name: tsx
description: Before writting tsx claude should check these skills to make sure that the code is consistent.
---

When wrtting tsx code make sure that you follow these linter rules:

```typescript
rules: {
  eqeqeq: ["error", "smart"],
  "react-hooks/rules-of-hooks": "error",
  "react-hooks/exhaustive-deps": "warn",
  "react-compiler/react-compiler": "error",
  "@typescript-eslint/consistent-type-definitions": ["error", "type"],
  "no-unused-vars": "off",
  "@typescript-eslint/no-unused-vars": [
    "error",
    {
      argsIgnorePattern: "^_",
      varsIgnorePattern: "^_",
      caughtErrorsIgnorePattern: "^_",
    },
  ],
}
```
