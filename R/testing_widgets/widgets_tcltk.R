library(tcltk)


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

# Example
window <- tktoplevel()
tkwm.title(window, "Simple code editor" )
frame <- ttkframe(window, padding = c(3, 3, 12, 12))
tkpack(frame, expand = TRUE, fill = "both")
#text_buffer <- tktext(frame , undo = TRUE)
#addScrollbars(frame, text_buffer)


# ttktreeview widget
treeview <- ttktreeview(frame,
                columns = 1 , # coluna identifica se 1 e 0 nao
                show = "headings" ,
                height = 25)
addScrollbars(frame, treeview)
#tcl(treeview, "configure", "-height", 20)

# Inserindo espelhos do CRAN
x <- getCRANmirrors()
Host <- x$Host
shade <- c("none", "gray")
##
for (i in seq_along(Host)) {
  ID <- tkinsert(treeview, "", "end",
                 values = as.tclObj(Host[i]),
                 tag = shade[i %% 2]) # nenhum ou cinza
}
tktag.configure(treeview, "gray", background = "gray95")

# Cabecalho da coluna
tcl(treeview, "heading", 1, text = "Host", anchor = "center")
# Configuracoes da coluna
tcl(treeview, "column", 1, width = 400,
      stretch = FALSE, anchor = "w")


# Recurso de Arrastar e Soltar (Lawrence, p. 438-439)
.selected_id <- "" # variaveis globais
.dragging <- FALSE

tkbind(treeview , "<Button-1>", function(W, x, y) {
  .selected_id <<- as.character(tcl(W, "identify", "row", x, y))
})
##
tkbind(treeview, "<B1-Motion >", function(W, x, y, X, Y) {
  tkconfigure(W, cursor = "gobbler") # Opcoes cursor="diamond_cross"
  .dragging <<- TRUE
})
tkbind(treeview, "<ButtonRelease-1>", function(W ,x ,y, X, Y) {
  if (.dragging && .selected_id != "") {
    w <- tkwinfo("containing", X, Y)
    if ( as.character(w) == as.character(W)) {
      dropID <- as.character(tcl(W , "identify", "row", x, y))
      tkmove(W , .selected_id , dropID , "0")
      # Para mover, eu não posso apontar o mouse para para outra
      # linha pq teremos problema de hierarquização dos widgets
    }
  }
  .dragging <<- FALSE; .selected_id <<- "" # r e s e t
} )



# Uma função de conveniência para preencher uma tabela
populate_rectangular_treeview <- function(parent, m) {
  enc_frame <- ttkframe(parent)
  frame <- ttkframe(enc_frame)
  tkpack(frame, expand = TRUE, fill = "both")
  treeview <- ttktreeview(frame,
                          columns = seq_len(ncol(m)),
                          show = "headings")
  addScrollbars(frame, treeview)
  tkpack.propagate(enc_frame, FALSE)
  font_measure <- tcl("font", "measure", "TkTextFont", "0")
  charWidth <- as.integer(tclvalue(font_measure))
  sapply(seq_len(ncol(m)) , function(i) {
    tcl(treeview, "heading", i, text = colnames(m)[i])
    tcl(treeview, "column", i ,
          width = 10 + charWidth * max(apply(m, 2, nchar)), anchor = "center")
  })
  tcl(treeview , "column" , ncol(m), stretch = TRUE)
  ## v a l u e s
  if (ncol(m) == 1) m <- as.matrix(paste("{", m, "}", sep = ""))
  apply( m , 1 , function(vals) {
    tcl(treeview , "insert", "", "end", values = vals)
  })

  ##
  return(list(treeview = treeview , frame = enc_frame))
}

# Usando um exemplo para a funcao 'populate_rectangular_treeview'
window <- tktoplevel()
m <- sapply(mtcars, as.character)
a <- populate_rectangular_treeview(window, m)
tkconfigure(a$treeview, selectmode = "extended") # multiplo
tkconfigure(a$frame, width = 300, height = 200) # tamanho do frame
tkpack(a$frame, expand = TRUE, fill = "both")

# Recuperando valores
children <- tcl(a$treeview, "children", "")
(children <- head(as.character(children)))
##
x <- tcl(a$treeview, "item", children[1], "-values")
as.character(x)
##

# Selecao das 6 primeiras linhas
tkselect(a$treeview, "set", children)
# Para alternar a selecao
tkselect(a$treeview , "toggle" , tcl(a$treeview, "children", ""))
# Retornar o ID da selecao
IDs <- as.character(tkselect(a$treeview))

# Eventos e chamadas
callback_example <- function(W, x, y ) {
  col <- as.character(tkidentify(W, "column", x, y))
  row <- as.character(tkidentify(W, "row", x, y))
  ## now do something . . .
}



# Para editar tabelas
library(tcltk2)
tcltk2::tk2edit(mtcars)


###################
# Arrastar e soltar
###################

# Example
window <- tktoplevel()
tkwm.title(window, "Simple code editor" )
frame <- ttkframe(window, padding = c(3, 3, 12, 12))
tkpack(frame, expand = TRUE, fill = "both")
#text_buffer <- tktext(frame , undo = TRUE)
#addScrollbars(frame, text_buffer)


# ttktreeview widget
treeview <- ttktreeview(frame,
                        columns = 1 , # coluna identifica se 1 e 0 nao
                        show = "headings" ,
                        height = 25)
addScrollbars(frame, treeview)
#tcl(treeview, "configure", "-height", 20)

# Inserindo espelhos do CRAN
x <- getCRANmirrors()
Host <- x$Host
shade <- c("none", "gray")
##
for (i in seq_along(Host)) {
  ID <- tkinsert(treeview, "", "end",
                 values = as.tclObj(Host[i]),
                 tag = shade[i %% 2]) # nenhum ou cinza
}
tktag.configure(treeview, "gray", background = "gray95")

# Cabecalho da coluna
tcl(treeview, "heading", 1, text = "Host", anchor = "center")
# Configuracoes da coluna
tcl(treeview, "column", 1, width = 400,
    stretch = FALSE, anchor = "w")


# Recurso de Arrastar e Soltar (Lawrence, p. 438-439)
.selected_id <- "" # variaveis globais
.dragging <- FALSE

tkbind(treeview , "<Button-1>", function(W, x, y) {
  .selected_id <<- as.character(tcl(W, "identify", "row", x, y))
})
##
tkbind(treeview, "<B1-Motion>", function(W, x, y, X, Y) {
  tkconfigure(W, cursor = "gobbler") # Opcoes cursor="diamond_cross"
  .dragging <<- TRUE
})
tkbind(treeview, "<ButtonRelease-1>", function(W ,x ,y, X, Y) {
  if (.dragging && .selected_id != "") {
    w <- tkwinfo("containing", X, Y)
    if ( as.character(w) == as.character(W)) {
      dropID <- as.character(tcl(W , "identify", "row", x, y))
      tkmove(W , .selected_id , dropID , "0")
      # Para mover, eu não posso apontar o mouse para para outra
      # linha pq teremos problema de hierarquização dos widgets
    }
  }
  .dragging <<- FALSE; .selected_id <<- "" # r e s e t
} )
