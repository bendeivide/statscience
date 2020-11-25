# #  Drag & Drop Example by Bryan Oakley
# #                         bryan@bitmover.com
# #                         http://purl.oclc.org/net/oakley
# #
# # The way bindings work, as long as a button is pressed, the widget
# # that handles the press event is the only widget that sees the
# # motion event (someobody correct me if I'm wrong or if it's
# # slightly more complex than that).
# #
# # But, you can use this to your advantage. Remember that you can get
# # the absolute (root) x and y coordinates of the mouse with your
# # event. And we have the command [winfo containing], which tells us
# # which widget "contains" this x,y position. So, your command that
# # handles the motion can modify the appearance of widgets that it
# # moves over, or perhaps send them events to process (such as
# # <<DragEnter>>, for example).
# #
# # Here's a quick hack I just threw together to illustrate the
# # possibilities. The example is contrived and hard-coded for some
# # specific widgets, but you can see the general idea.
#
#
# catch {destroy .l1 .l2 .reset}
#
# label .l1 \
# -text "Right-click and drag this label..." \
# -bd 2 \
# -padx 10 \
# -relief groove \
# -height 4
# pack .l1 -fill x -pady 10
#
# label .l2 \
# -text "... and drag it over this label" \
# -bd 2 \
# -padx 10 \
# -relief groove \
# -height 4
# pack .l2 -fill x -pady 10
#
# bind .l1 <ButtonPress-3>   [list drag start %W]
# bind .l1 <Motion>          [list drag motion %X %Y]
# bind .l1 <ButtonRelease-3> [list drag stop %X %Y]
#
# bind .l2 <<DragOver>>      [list drag over %W]
# bind .l2 <<DragLeave>>     [list drag leave %W]
# bind .l2 <<DragDrop>>      [list drag drop  %W]
#
# button .reset -text "Reset" -command {
#   .l2 configure \
#   -foreground black \
#   -text "... and drag it over this label"
# }
# pack .reset
#
# proc drag {command args} {
#   global _dragging
#   global _lastwidget
#   global _dragwidget
#
#   switch $command {
#     init {
#       # one-time code to initialize variables
#       set _lastwidget {}
#       set _dragging 0
#     }
#
#     start {
#       set w [lindex $args 0]
#       set _dragging 1
#       set _lastwidget $w
#       set _dragwidget $w
#       $w configure -cursor gobbler
#     }
#
#     motion {
#       if {!$_dragging} {return}
#
#       set x [lindex $args 0]
#       set y [lindex $args 1]
#       set w [winfo containing $x $y]
#       if {$w != $_lastwidget && [winfo exists $_lastwidget]} {
#         event generate $_lastwidget <<DragLeave>>
#       }
#       set _lastwidget $w
#       if {[winfo exists $w]} {
#         event generate $w <<DragOver>>
#       }
#       if {$w == ".l2"}  {
#         $_dragwidget configure -cursor gumby
#       } else {
#         $_dragwidget  configure -cursor gobbler
#       }
#     }
#
#     stop {
#       if {!$_dragging} {return}
#       set x [lindex $args 0]
#       set y [lindex $args 1]
#       set w [winfo containing $x $y]
#       if {[winfo exists $w]} {
#         event generate $w <<DragLeave>>
#           event generate $w <<DragDrop>>
#       }
#       set _dragging 0
#       $_dragwidget configure -cursor {}
#     }
#
#     over {
#       if {!$_dragging} {return}
#       set w [lindex $args 0]
#       $w configure -relief raised
#     }
#
#     leave {
#       if {!$_dragging} {return}
#       set w [lindex $args 0]
#       $w configure -relief groove
#       $w configure -cursor {}
#     }
#
#     drop {
#       set w [lindex $args 0]
#       $w configure -foreground red -text "THUD!!!"
#     }
#   }
# }
#
# drag init

#####################
# Tentando reproduzir
#####################

tt <- tktoplevel()

l1 <- tklabel(tt, text = "Right-click and drag this label...",
              #bg = 2,
              padx = 10,
              relief = "groove",
              height = 4)
tkpack(l1, fill = "x", pady = 10)

l2 <- tklabel(tt, text = "... and drag it over this label",
              #bg = 2,
              padx = 10,
              relief = "groove",
              height = 4)
tkpack(l2, fill = "x", pady = 10)

.lastwidget <<- ""
.dragging <<- FALSE
.dragwidget <<- ""

tkbind(l1, "<ButtonPress-3>", function(W){
  w <<- as.character(tcl(W, "lindex", 0))
  tkconfigure(W, cursor = "gobbler")
  .dragging <<- TRUE
  .lastwidget <<- as.character(tcl(W, "lindex", 0))
  .dragwidget <<- as.character(tcl(W))

})
