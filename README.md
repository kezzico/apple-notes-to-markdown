# Apple Notes to Markdown

**Apple Notes to Markdown** is an AppleScript and XSLT transformation that automates the export of notes from a specific folder in Apple Notes, saving them in Markdown format. It’s a powerful tool for organizing and converting notes for further use outside of the Notes app.

## Features
- Exports notes from a specified folder in Apple Notes.
- Cleans up HTML content, using `tidy`, to avoid transformation issues.
- Converts the HTML from notes into Markdown using XSLT via `xmlstarlet`.

## Requirements
- **xmlstarlet** and **tidy**: Used for transformation. Install them via Homebrew:
  ```bash
  brew install xmlstarlet
  ```

## Usage
1. **Clone the Repository**:
    ```bash
    git clone https://github.com/kezzico/apple-notes-to-markdown.git
    ```

2. **Run the Script**:
    ```bash
    osascript export-notes.scpt "<notes folder>" "<output path>"
    ```
    Replace `<notes folder>` with the exact name of the folder in Apple Notes and `<output path>` with your preferred directory for exported Markdown files.

3. **Check Exported Files**: Your notes will appear in the specified output directory, saved as `.md` files with noteID-based filenames.

## Notes
- If `<notes folder>` is omitted, the script will log available folder names within Apple Notes.
- The script cleans and transforms note content for Markdown compatibility, fixing common HTML issues. Not all features are supported.

