on run argv
    -- Check if the correct number of arguments is passed
    if (count of argv) is not equal to 3 then
        log "Usage: export-notes.scpt <notes folder> <output path>\n"
    end if

    -- Get the folder name from the arguments
    set folderNameArg to item 1 of argv

    set outputDirectoryArg to item 2 of argv

    tell application "Notes"
        set theAccounts to every account

        set anAccount to the first item of theAccounts

        set theFolders to every folder of anAccount
        
        if folderNameArg is equal to "" then
            log "No folder name specified.\nOptions are:"

            -- Initialize an empty string to store folder names
            set folderNames to ""
            
            repeat with aFolder in theFolders
                set folderNames to folderNames & (name of aFolder) & "\n" -- Add each folder name followed by a newline
            end repeat
            
            log "Folders: " & folderNames -- Log all folder names at once, separated by newlines
            return
        end if

        set aFolder to folder folderNameArg of anAccount

        set theNotes to notes of aFolder

        repeat with theNote in theNotes
            set noteTitle to name of theNote
            set noteId to id of theNote
            -- Extract the GUID portion from the noteId

            set AppleScript's text item delimiters to "/"
            set noteIdComponents to text items of noteId
            set noteGuid to item 5 of noteIdComponents
            set AppleScript's text item delimiters to ""
            
            log "- exporting: '" & (name of theNote) & "' -- to " & noteGuid & ".md"

            -- Convert noteTitle to lowercase
            -- set noteTitle to do shell script "echo " & quoted form of noteTitle & " | tr '[:upper:]' '[:lower:]'"

            -- Replace spaces with hyphens to convert to kebab-case
            -- set noteTitle to do shell script "echo " & quoted form of noteTitle & " | sed 's/ /-/g'"
            
            -- set noteFileName to noteGuid & "-" & noteTitle
            -- log "note file: " & noteFileName
            -- set noteProperties to properties of theNote
            -- log "Note properties: " & noteProperties
            
            set htmlContent to "<html>" & (body of theNote) & "</html>"

            -- Save HTML content to a temporary file
            set currentDirectory to (do shell script "pwd")
            set tmpFilePath to currentDirectory & "/tmp.html"
            set cleanedTmpFilePath to currentDirectory & "/cleaned_tmp.xhtml"
            set outputFilePath to outputDirectoryArg & "/" & noteGuid & ".md"

            try
                do shell script "rm " & quoted form of tmpFilePath
            end try
            try
                do shell script "echo " & quoted form of htmlContent & " > " & quoted form of tmpFilePath
            end try
            try
                do shell script "rm " & quoted form of cleanedTmpFilePath
            end try
            try
                -- clean up <br> and other unclosed tags that cause transformation errors
                do shell script "tidy -utf8 -asxhtml -i -b -q -o cleaned_tmp.xhtml " & quoted form of tmpFilePath -- & quoted form of cleanedTmpFilePath & " " & quoted form of tmpFilePath
            end try
            try
                -- replace the schema and doctype with <html> to prevent XSLT transformation errors
                do shell script "echo \"<html>\\n`tail -n +5 cleaned_tmp.xhtml`\" > cleaned_tmp.xhtml"
            end try
            try
                -- tidy is messing up &lt; and turning it into &amp;lt
                do shell script "sed -i '' 's/&amp;lt/\\&lt;/g' cleaned_tmp.xhtml"
            end try
            try
                -- transform the cleaned file to markdown
                do shell script "xmlstarlet tr ./notes-to-markdown.xslt " & quoted form of cleanedTmpFilePath & " > " & quoted form of outputFilePath
            end try
        end repeat
    end tell
end run
