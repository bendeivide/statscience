# tt <- tktoplevel()
# tkpack(quadroinicial <- tkframe(tt), fill = "both", expand = TRUE)
# telainicial <- ttknotebook(quadroinicial)
# ##
# paned1 <- ttkpanedwindow(telainicial, orient = "horizontal", style = "Toolbar.TPanedwindow")
# paned2 <- ttkpanedwindow(telainicial, orient = "horizontal", style = "Toolbar.TPanedwindow")
# paned3 <- ttkpanedwindow(telainicial, orient = "horizontal", style = "Toolbar.TPanedwindow")
# ##
# ##############
# # Child groups
# ##############
# #group1 <- NULL
# wid2 <- 400
# group1input <- ttkpanedwindow(paned1, orient = "vertical", width =  wid2, style = "Toolbar.TPanedwindow")
# tkadd(paned1, group1input)
#
# group2input <- ttkpanedwindow(paned1, orient = "vertical", width = wid - wid2, style = "Toolbar.TPanedwindow")
# tkadd(paned1, group2input)
# ##
# tkadd(telainicial, paned1, text = "Input")
# tkadd(telainicial, paned2, text = "Graphics")
# tkadd(telainicial, paned3, text = "Output")
# tkpack(telainicial, fill = "both", expand = TRUE)
#
# # Design of Exepriments
# #----------------------
# # Aba Input
# tkpack(infodados <- ttklabelframe(group1input,
#                       text = gettext("Configuration of the data",
#                                       domain = "R-statscience")),
#        fill = "both", expand = TRUE)
#
# tkpack(infoexp <- ttklabelframe(group1input,
#                                   text = gettext("Configuration of the Experiment",
#                                                  domain = "R-statscience")),
#        fill = "both", expand = TRUE)
#
# tkpack(treatstr <- ttklabelframe(group1input,
#                                 text = gettext("Treatment Structures",
#                                                domain = "R-statscience")),
#        fill = "both", expand = TRUE)
