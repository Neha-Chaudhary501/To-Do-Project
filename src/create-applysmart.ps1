function Create-ApplySmartProject {
    param(
        [string]$Base = "C:\New folder (3)"
    )

    # Create folders
    $folders = @(
        "$Base",
        "$Base\src",
        "$Base\src\components",
        "$Base\src\pages",
        "$Base\src\utils"
    )
    foreach ($f in $folders) {
        if (-not (Test-Path $f)) { New-Item -ItemType Directory -Force -Path $f | Out-Null }
    }

    # Helper to write files
    function Write-File($relPath, $content) {
        $path = Join-Path $Base $relPath
        $dir = Split-Path $path
        if (-not (Test-Path $dir)) { New-Item -ItemType Directory -Force -Path $dir | Out-Null }
        $content | Out-File -FilePath $path -Encoding utf8 -Force
        Write-Host "Created $relPath"
    }

    # --- Files ---
    Write-File "package.json" @'
{
  "name": "applysmart",
  "version": "0.1.0",
  "private": true,
  "scripts": {
    "dev": "vite",
    "build": "vite build",
    "preview": "vite preview"
  },
  "dependencies": {
    "react": "^18.2.0",
    "react-dom": "^18.2.0",
    "react-router-dom": "^6.14.1"
  },
  "devDependencies": {
    "@vitejs/plugin-react": "^4.0.0",
    "autoprefixer": "^10.4.14",
    "postcss": "^8.4.23",
    "tailwindcss": "^3.6.0",
    "vite": "^5.0.0"
  }
}
'@

    # index.html
    Write-File "index.html" @'
<!doctype html>
<html lang="en">
  <head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width,initial-scale=1" />
    <title>ApplySmart</title>
  </head>
  <body class="bg-gray-50">
    <div id="root"></div>
    <script type="module" src="/src/main.jsx"></script>
  </body>
</html>
'@

    # vite.config.js
    Write-File "vite.config.js" @'
import { defineConfig } from "vite";
import react from "@vitejs/plugin-react";

export default defineConfig({
  plugins: [react()]
});
'@

    # tailwind.config.cjs
    Write-File "tailwind.config.cjs" @'
module.exports = {
  content: ["./index.html", "./src/**/*.{js,jsx}"],
  darkMode: "class",
  theme: {
    extend: {}
  },
  plugins: []
};
'@

    # postcss.config.cjs
    Write-File "postcss.config.cjs" @'
module.exports = {
  plugins: {
    tailwindcss: {},
    autoprefixer: {}
  }
};
'@

    # src/index.css
    Write-File "src/index.css" @'
@tailwind base;
@tailwind components;
@tailwind utilities;

:root {
  --brand-blue: #1e40af;
}
'@

    # src/main.jsx
    Write-File "src/main.jsx" @'
import React from "react";
import { createRoot } from "react-dom/client";
import { BrowserRouter } from "react-router-dom";
import App from "./App";
import "./index.css";

createRoot(document.getElementById("root")).render(
  <React.StrictMode>
    <BrowserRouter>
      <App />
    </BrowserRouter>
  </React.StrictMode>
);
'@

    # src/utils/storage.js
    Write-File "src/utils/storage.js" @'
export const STORAGE_KEY = "applysmart.jobs";
export const THEME_KEY = "applysmart.theme";

export const loadJobs = () => {
  try { return JSON.parse(localStorage.getItem(STORAGE_KEY) || "[]"); }
  catch { return []; }
};

export const saveJobs = (jobs) => localStorage.setItem(STORAGE_KEY, JSON.stringify(jobs));

export const loadTheme = () => localStorage.getItem(THEME_KEY) || "light";
export const saveTheme = (mode) => localStorage.setItem(THEME_KEY, mode);
'@

    Write-Host "`nAll files created in $Base"
    Write-Host "Next steps:"
    Write-Host "1. cd `"$Base`""
    Write-Host "2. npm install"
    Write-Host "3. npm run dev"
}

# Run the function
Create-ApplySmartProject
