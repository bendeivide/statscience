# Exemplo 17.1 Arrastar e soltar (Lawrence, p. 365)

window <- tktoplevel()
b_drag <- ttkbutton(window, text = "Drag me")
b_drop <- ttkbutton(window, text = "Drop here")
tkpack(b_drag)
tkpack(ttklabel(window, text = "Drag over me"))
tkpack(b_drop)

# Variaveis globais
.dragging <- FALSE # arrastando atualmente?
.drag_value <- "" # transferência de valor
.last_widget_id <- "" # último widget arrastado

tkbind(b_drag, "<ButtonPress-1>", function(W){
  tkconfigure(W, cursor = "gobbler")
  .dragging <<- TRUE
  .drag_value <<- as.character(tkcget(W, text = NULL))
  .last_widget_id <<- as.character(W)
} )

tkbind(window, "<B1-Motion>", function(W, X, Y) {
  if(!.dragging) return()
  ## veja a página de ajuda do cursor na API para mais opções
  ## Para cursores personalizados, cf. http://wiki.tcl.tk/8674 4 .
  tkconfigure(W , cursor = "coffee_mug") # definir o cursor
  win <- tkwinfo("containing", X, Y) # Passou o mouse sobre que widget?
  if(as.logical(tkwinfo("exists", win))) # Existe widget?
    tkevent.generate(win, "<<DragOver>>")
  ## gerar arrasto se deixarmos o último widget
  if (as.logical(tkwinfo("exists", win)) &&
       nchar(as.character(win)) > 0 &&
       length(.last_widget_id ) > 0) { # se não character(0))
    if(as.character(win) != .last_widget_id)
      tkevent.generate(.last_widget_id , "<<DragLeave>>")
  }
  .last_widget_id <<- as.character(win)
} )

tkbind(b_drag, "<ButtonRelease-1>", function(W, X, Y) {
  if (!.dragging) return()
  w <- tkwinfo("containing", X, Y)
  if (as.logical(tkwinfo("exists", w))) {
    tkevent.generate(w, "<<DragLeave>>")
    tkevent.generate(w, "<<DragDrop>>")
    tkconfigure(w, cursor = "")
  }
  .dragging <<- FALSE
  .last_widget_id <<- ""
  tkconfigure(W, cursor = "")
} )

tkbind(b_drop, "<<DragOver>>", function(W) {
  if (.dragging)
    tcl(W, "state", "active")
} )

tkbind(b_drop, "<<DragLeave>>", function(W) {
  if (.dragging) {
    tkconfigure(W, cursor = "")
    tcl (W, "state", "!active")
  }
} )

tkbind(b_drop, "<<DragDrop>>", function(W) {
  tkconfigure(W, text = .drag_value)
  .drag_value <- ""
} )

