# Auxiliar functions
addScrollbars <- function(parent, widget,type=c("both", "x", "y")) {
  if (any(type %in% c("both","x"))) {
    xscr <- ttkscrollbar(parent, orient = "horizontal",
                         command = function(...) tkxview(widget, ...))
    tkconfigure(widget,
                xscrollcommand = function(...) tkset(xscr,...))
  }

  if (any(type %in% c("both","y"))) {
    yscr <- ttkscrollbar(parent, orient = "vertical",
                         command = function(...) tkyview(widget, ...))
    tkconfigure(widget,
                yscrollcommand = function(...) tkset(yscr,...))
  }

  ## place in grid
  tkgrid(widget, row = 0, column = 0, sticky = "news")
  if (any(type %in% c("both", "x"))) {
    tkgrid(xscr, row = 1, column = 0, sticky = "ew")
    tkgrid.columnconfigure(parent, 0, weight = 1)
  }
  if (any(type %in% c("both", "y"))) {
    tkgrid(yscr, row = 0, column = 1, sticky = "ns")
    tkgrid.rowconfigure(parent, 0, weight = 1)
  }
}
