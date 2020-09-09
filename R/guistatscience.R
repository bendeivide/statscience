#' Graphical User Interface for statscience package
#'
#' \code{guistatscience} A Graphical User Interface (GUI) for
#'     the statscience package
#' @param gui Logical argument, \code{TRUE} or \code{FALSE}. The default is \code{TRUE}
#' @return \code{guistatscience} presents a GUI for ...
#' @examples
#' # Loading package
#' library(MCPtests)
#' if (interactive()) {
#'   guistatscience(gui = FALSE)
#' }
#'
# @import "tcltk"
# @import "tkrplot"
# @importFrom "grDevices" "dev.new"
# @importFrom "stats" "aov"
#' @export
guistatscience <- function(gui = TRUE) {
  # Language
  # # portugues
  # Sys.setenv(LANG = "pt_BR")
  #
  # # Ingles
  # Sys.setenv(LANG = "en")
  if (gui == TRUE) {
    # Insert images
    tkimage.create("photo", "::image::logostatscience", file = system.file("etc", "statscience.gif", package = "statscience"))
    tkimage.create("photo", "::image::iconstatscience", file = system.file("etc", "iconstatscience.gif", package = "statscience"))
    tkimage.create("photo", "::image::edit",
                   file = system.file("etc", "edit.gif", package = "statscience"))
    tkimage.create("photo", "::image::directory",
                   file = system.file("etc", "directory.gif", package = "statscience"))
    tkimage.create("photo", "::image::open", file = system.file("etc", "open.gif", package = "statscience"))


    # ##########################
    # # Configuration of widgets
    # ##########################
    # #Clear the configurations of the option function
    .Tcl("option clear")
    #
    # Button and TButton configurations
    .Tcl("option add *Button.Pady 2
          #option add *Button.Background #e1eff7
          #option add Button.Foreground #e1eff7
          #option add *Button.Foreground black
          option add *Button.Cursor draft_small 46
          option add *TButton.Cursor draft_small 46")
    #
    # # Label configurations
    # .Tcl("option add *Label.Background #e1eff7")
    #
    # # Chackbutton configurations
    # .Tcl("option add *Checkbutton.Background #e1eff7")
    #
    # # Frame configurations
    # .Tcl("option add *Frame.Background #e1eff7")
    #
    #
    # Style TFrame
    #tcl("ttk::style" , "configure" , "Toolbar.TFrame", relief = "solid", expand = TRUE)
    .Tcl("ttk::style configure Toolbar.TFrame -relief solid")
    #
    # # Style LabelFrame
    # .Tcl("ttk::style configure Toolbar.TLabelframe -background #e1eff7
    #       ttk::style configure Toolbar.TLabelframe.Label -background #e1eff7")
    #
    #
    # # Style PanedWindow
    # .Tcl("ttk::style configure Toolbar.TPanedwindow -background #e1eff7")
    #
    # # Class disabled/Enabled
    .Tcl("option add *Ativado.Entry.state normal 81
          option add *Ativado.Label.state normal 81
          option add *Ativado.Button.state normal 81
          option add *Desativado.Entry.state disabled 81
          option add *Desativado.Label.state disabled 81
          option add *Desativado.Button.state disabled 81")


    # Disabled GUI (Type I)
    oldmode <- tclServiceMode(FALSE)

    # Top-level window
    wid <- 1019
    hei <- 700

    topwinstat <- tktoplevel(
      width = wid,
      height = hei
      #background = "blue"
    )
    # Disabled GUI (Type II)
    #tkwm.state(topwinstat, "withdraw")

    ####################################
    # Configurations of top-level window
    ####################################

    # Title
    tkwm.title(topwinstat,
               gettext("GUI to the statscience package", domain = "R-statscience"))

    #Icon main toplevel window
    tcl("wm", "iconphoto", topwinstat, "-default", "::image::iconstatscience")

    # Not propagate
    tkpack.propagate(topwinstat, FALSE)

    # Initial screen
    tkpack(telainicial <- tklabel(parent = topwinstat, image = "::image::logostatscience"),
           expand = TRUE, fill = "both")


    # Auxiliar functions
    f.read <- NULL
    f.read <- function(file) {
      if (grepl("\\.txt$", file)) {
        if (tclvalue(group_cbox_1_resp) == "TRUE") {
          return(read.table(file, header = TRUE, dec = ",", sep = tclvalue(group_cbox_2_resp)))
        }
        if (tclvalue(group_cbox_1_resp) == "FALSE") {
          return(read.table(file, header = TRUE, sep = tclvalue(group_cbox_2_resp)))
        }
      }
      if (grepl("\\.csv$", file)) {
        if (tclvalue(group_cbox_1_resp)) {
          return(read.table(file, header = TRUE, dec = ",", sep = tclvalue(group_cbox_2_resp)))
        }
        if (tclvalue(group_cbox_1_resp) == FALSE) {
          return(read.table(file, header = TRUE, sep = tclvalue(group_cbox_2_resp)))
        }
      }
    }
    group_cbox_1_resp <- tclVar("FALSE")
    group_cbox_2_resp <- tclVar("")
    openfile <- function(...) {
      tclServiceMode(FALSE)
      if (exists("confdata")) {
        tkwm.deiconify(confdata)
      } else{
        confdata <- tktoplevel()
        tkwm.resizable(confdata, FALSE, FALSE)
        tkwm.title(confdata,
                   gettext("Configurations of the data", domain = "R-statscience"))
      }
      # Group of buttons
      tkpack(group_cbox <- tkframe(parent = confdata),
             expand = TRUE, fill = "x", pady = "1m")
      #tkpack.configure(group_cbox, expand = TRUE, fill = "both")

      # Checkbox
      tkpack(group_cbox_1 <- tkcheckbutton(parent = group_cbox,
                                           text = gettext("Comma as decimal points", domain = "R-statscience"),
                                           variable = group_cbox_1_resp,
                                           onvalue = "TRUE",
                                           offvalue = "FALSE"),
             anchor = "nw", padx = "1m", side = "left")

      ##
      ##Separator
      tkpack(ttkseparator(parent = group_cbox, orient = "vertical"),
             fill = "both", side = "left")
      ##
      tkpack(tklabel(parent = group_cbox,
                     text = gettext("Separator of variables:",
                                    domain = "R-statscience")),
             side = "left", anchor = "nw", padx = "1m"
      )
      ##
      tkpack(group_cbox_2 <- tkentry(textvariable = group_cbox_2_resp,
                                     parent = group_cbox,
                                     width = 5),
             side = "left", anchor = "nw", padx = "1m"
      )

      ##Separator
      tkpack(ttkseparator(parent = confdata, orient = "horizontal"),
             fill = "x")
      tkpack(bconfdata <- ttkbutton(parent = confdata,
                                    text = gettext("Enter the data", domain = "R-statscience")), anchor = "e")

      tclServiceMode(TRUE)
      tkfocus(bconfdata)
      funcbconfdata <- function(...){
        filetemp <- tkgetOpenFile(filetypes = paste(
          "{{txt files} {.txt} }" ,
          "{{csv files} {.csv}}" ,
          sep = " "))
        start_dir <- tclvalue(filetemp)
        if (file.exists(start_dir)) {
          tkwm.withdraw(confdata)
          dat <- NULL
          dat2 <- NULL
          dat2 <<- dat <<- f.read(start_dir)
          tcl(search_results, "delete", "1.0", "end")
          tkinsert(search_results, "end",
                   paste(gettext("The variables in the file:", domain = "R-statscience"),
                         "===========================",
                         as.character(start_dir),
                         "===========================",
                         sep = "\n"))
          tkinsert(search_results, "end", "\n")
          tkinsert(search_results, "end",
                   paste(paste(names(f.read(start_dir)), collapse = "\n", sep = "\n"),
                         sep = "\n"), "variablesTag")
          tkinsert(search_results, "end", "\n")
          tkinsert(search_results, "end",
                   paste("===========================",
                         gettext("R object created: 'dat'", domain = "R-statscience"), sep = "\n"))
          tkmessageBox(message = gettext("Check the data has been loaded correctly. To do this, use the 'Edit/View' button or the 'Output' frame.", domain = "R-satscience"))
        }
        if (file.exists(start_dir) == FALSE) {
          tkwm.withdraw(confdata)
          tkmessageBox(message = gettext("No data set has been entered!", domain = "R-statscience"))
        }
      }
      tkbind(bconfdata, "<ButtonRelease>", funcbconfdata)
      tkbind(confdata, "<Return>", funcbconfdata)
      tkbind(confdata, "<Escape>", function(){
        tkwm.withdraw(confdata)
      })
    }
    # Menu
    menu_bar <- tkmenu(topwinstat)
    tkconfigure(topwinstat, menu = menu_bar)


    # File menu
    file_menu <- tkmenu(menu_bar, tearoff = FALSE)
    chosdir <- function(...) {
      dir_name <- tkchooseDirectory()
      if (nchar(dir_name <- tclvalue(dir_name))) {
        dir_name <- setwd(dir_name)
        on.exit(setwd(dir_name)) # Return initial directory
      }
    }
    tkadd(file_menu, 'command', label = gettext('Choose directory...', domain = "R-MCP"),
          accelerator = 'Ctrl+Shift+H', command = chosdir,
          image = "::image::directory", compound = "left")
    tkadd(menu_bar, 'cascade', label = gettext('File', domain = "R-MCP"), menu = file_menu)
    tkadd(file_menu, 'command', label = gettext('Open file (.txt or .csv)...', domain = "R-MCP"),
          accelerator = 'Ctrl+O', command = openfile, image = "::image::open", compound = "left")


    ## Edit menu
    # This variable is important in the event of the "bentry" button
    dat2 <- NULL # This variable is internal, not exported to the console
    fedit <- function(...) {
      if (is.null(dat2)) {
        tkmessageBox(message = gettext("No data set has been entered!", domain = "R-MCP"))
      } else{
        dat <- NULL
        dat2 <<- dat <- dat <<- edit(dat2)
      }
    }
    edit_menu <- tkmenu(menu_bar, tearoff = FALSE)
    tkadd(menu_bar, "cascade", label = gettext("Edit", domain = "R-MCP"), menu = edit_menu)
    tkadd(edit_menu, "command", label = gettext("Data set...", domain = "R-MCP"),
          accelerator = "Ctrl+E", command = fedit,
          image = "::image::edit", compound = "left")


    tkbind(topwinstat, "<Control-O>", openfile)
    tkbind(topwinstat, "<Control-o>", openfile)
    tkbind(topwinstat, "<Control-E>", fedit)
    tkbind(topwinstat, "<Control-e>", fedit)
    tkbind(topwinstat, "<Control-Shift-H>", chosdir)
    tkbind(topwinstat, "<Control-Shift-h>", chosdir)




    # Activate GUI
    finish <- tclServiceMode(oldmode)

  }
  if (gui == FALSE) {
    print("Olá!")
  }
}
