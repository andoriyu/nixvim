{self, ...}: {
  globals.mapleader = ",";
  opts = {
    # Line numbers
    number = true;
    relativenumber = true;
    # Always show the signcolumn, otherwise text would be shifted when displaying error icons
    signcolumn = "yes";

    # Tab defaults (might get overwritten by an LSP server)
    tabstop = 2;
    shiftwidth = 2;
    softtabstop = 2;
    expandtab = true;
    smarttab = true;

    # Highlight the current line
    cursorline = true;

    # Show line and column when searching
    ruler = true;
    # Global substitution by default
    gdefault = true;

    # Start scrolling when the cursor is X lines away from the top/bottom
    scrolloff = 5;
  };
}
