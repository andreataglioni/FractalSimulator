library(shiny)

shinyUI(fluidPage(
        headerPanel(h3("Fractal Simulator... by Andrea Taglioni - Ver 1.0 - Feb 2015", align="center"), windowTitle = "Fractal Simulator"),
        sidebarPanel(
                
                fluidRow(
                        column(10,selectInput("fractalType", h5("Choose Fractal Type:"),
                                              c("Select Fractal Type" = 0, "Koch" = 1, "Julia" = 2), selected = 0)),
                        HTML("<a href='#' style='color:red' onmouseover=\"document.getElementById('Help').style.visibility='visible';\" onmouseout=\"document.getElementById('Help').style.visibility = 'hidden';\">Pass mouse over here for help...</a>"),
                        HTML("<div id='Help' style='cursor: crosshair; position:absolute; left:30px; top:80px; z-index:2; visibility:hidden; overflow:visible; width: 600px; heigth=400px; color: #333333; background-color: #eeeeee; border: 2px solid grey; padding: 5px; font-size: 9pt;'><b>Instructions:</b><br><br>
                             <ol><li>Select a <span style='color:red'>fractal type</span> from the upper dropdown list</li><br>
                             <li>If the fractal type is <span style='color:red'>Koch:</span></li>
                                     <ul><li>select the <span style='color:red'>number of iterations</span> (determining the shape of the fractal) clicking on a radio button (1,2,3,4)</li>
                                             <li>You can change <span style='color:red'>Border Color or Fill color</span> clicking on the radio button (Fill or Border) and using the sliders</li>
                                             <li><span style='color:red'>Red, Green and Blue</span> sliders change colors, <span style='color:red'>Alpha</span> slider changes transparency</li><br>
                                     </ul>
                             <li>If the fractal type is <span style='color:red'>Julia set:</span></li>
                             <ul><li>select the <span style='color:red'>depth</span> with the slider (depth=number of colors used in the fractal)</li>
                             <li>select the <span style='color:red'>points</span> with the slider (points=number of X and Y points used in the fractal)</li>
                             <li>select the <span style='color:red'>color palette</span> with the radio button</li>
                             </ul><br>
                             <li>In both cases there are <span style='color:red'>reset buttons</span> to reset slider values.</li>
                             </ol>
                             The right panel will <i><span style='color:red'>automatically change and render the new Fractal</span></i>, reacting to the new input, and showing <i>summary details</i> about chosen parameters.<br>
                             <span style='color:red; float:right'>Enjoy!<br>Andrea Taglioni&nbsp;&nbsp;</span><br>&nbsp;  
                             </div>")
                ),
                conditionalPanel(
                        condition = "input.fractalType == 1",
                        
                        fluidRow(
                                column(10,radioButtons("iterations", h5("Choose number of Iterations:"),
                                     c(1, 2, 3, 4), selected = 4, inline = TRUE))
                        ),
                        fluidRow(
                                column(10,radioButtons("whichcolor", h5("Next, choose which Colour to set:"),
                                             c("None, I'm OK" = 0, "Fill Color" = 1, "Border Color" = 2), selected = 0, inline = TRUE))
                        ),
                        conditionalPanel(
                                condition = "input.whichcolor == 1",
                                fluidRow(
                                        column(12,p(h5("Choose fractal Fill RED, GREEN, BLUE and ALPHA:")), align="center")
                                ),
                                fluidRow(
                                column(3,p("RED:"),p("GREEN:"),p("BLUE:")),
                                column(3,sliderInput('bgR', '',value = 73, min = 0, max = 255, step = 1,)),
                                column(3,sliderInput('bgG', '',value = 82, min = 0, max = 255, step = 1,)),
                                column(3,sliderInput('bgB', '',value = 115, min = 0, max = 255, step = 1,))
                                ),
                                fluidRow(
                                        column(3,br(),p("ALPHA:"), p("(transparency)")),
                                        column(9,sliderInput('bgA', '',value = 187, min = 0, max = 255, step = 1,))
                                ),
                                fluidRow(
                                        column(12,actionButton("resetbg", label = "Reset fill color to default"), align="center")
                                )
                        ),
                        conditionalPanel(
                                condition = "input.whichcolor == 2",
                                fluidRow(
                                        column(12,p(h5("Choose fractal Border RED, GREEN, BLUE and ALPHA:")), align="center")
                                ),
                                fluidRow(
                                column(3,p("RED:"),p("GREEN:"),p("BLUE:")),
                                column(3,sliderInput('bdrR', '',value = 187, min = 0, max = 255, step = 1,)),
                                column(3,sliderInput('bdrG', '',value = 255, min = 0, max = 255, step = 1,)),
                                column(3,sliderInput('bdrB', '',value = 255, min = 0, max = 255, step = 1,))
                                ),
                                fluidRow(
                                        column(3,br(),p("ALPHA:"), p("(transparency)")),
                                        column(9,sliderInput('bdrA', '',value = 80, min = 0, max = 255, step = 1,))
                                ),
                                fluidRow(
                                        column(12,actionButton("resetbdr", label = "Reset border color to default"), align="center")
                                )
                        )
                ),   
                conditionalPanel(
                        condition = "input.fractalType == 2",
                        
                        p("Depth (number of colors):"),
                        fluidRow(
                                column(9,sliderInput('depth', '',value = 30, min = 1, max = 50, step = 1,))
                        ),
                        p("Number of points to be generated (precision):"),
                        fluidRow(
                                column(9,sliderInput('points', '',value = 300, min = 50, max = 500, step = 10,))
                        ),
                        fluidRow(
                                column(12,actionButton("resetJulia", label = "Reset Julia depth and points to default"), align="center")
                        ),
                        fluidRow(
                                column(9,radioButtons("colormap", h5("Choose a color map:"),
                                                       c("rainbow"=1, "terrain"=2, "topo"=3, "cm"=4), selected = 1, inline = TRUE))
                        )
                ),                
                width = 7
        ),
        mainPanel(
                plotOutput('myFractal'),
                textOutput("type"),
                textOutput("textbg"),
                textOutput("textbdr"),
                h6(textOutput("credits")),
                width = 5
        )
))


        