KochSnowflakeExample <- function(triangbg=rgb(0,0,0), triangbdr=rgb(0,0,0), numiter=4){
        
        iterate <- function(T,i){
                A = T[ ,1]; B=T[ ,2]; C = T[,3];
                if (i == 1){
                        d = (A + B)/2; h = (C-d); d = d-(1/3)*h;
                        e = (2/3)*B + (1/3)*A; f = (1/3)*B + (2/3)*A;
                }
                
                if (i == 2){
                        d = B; e = (2/3)*B + (1/3)*C; f = (2/3)*B + (1/3)*A;
                }
                
                if (i == 3){
                        d = (B + C)/2; h = (A-d); d = d-(1/3)*h;
                        e = (2/3)*C + (1/3)*B; f = (1/3)*C + (2/3)*B;
                }
                
                if (i == 4){
                        d = C; e = (2/3)*C + (1/3)*A; f = (2/3)*C + (1/3)*B;
                }
                
                if (i == 5){
                        d = (A + C)/2; h = (B-d); d = d-(1/3)*h;
                        e = (2/3)*A + (1/3)*C; f = (1/3)*A + (2/3)*C;
                }
                
                if (i == 6){
                        d = A; e = (2/3)*A + (1/3)*C; f = (2/3)*A + (1/3)*B;
                }
                
                if (i == 0){
                        d = A; e = B; f = C;
                }
                
                Tnew = cbind(d,e,f)
                return(Tnew); #Return a smaller triangle.
        }
        
        draw <- function(T, col=rgb(0,0,0),border=rgb(0,0,0)){
                polygon(T[1,],T[2,],col=col,border=border)
        }
        
        Iterate = function(T,v,col=rgb(0,0,0),border=rgb(0,0,0)){
                for (i in v) T = iterate(T,i);
                draw(T,col=col,border=border);
        }
        
        #The vertices of the initial triangle:
        A = matrix(c(1,0),2,1);
        B = matrix(c(cos(2*pi/3), sin(2*pi/3)),2,1);
        C = matrix(c(cos(2*pi/3),-sin(2*pi/3)),2,1);
        T0 = cbind(A,B,C);
        
        plot(numeric(0),xlim=c(-1.1,1.1),ylim=c(-1.1,1.1),axes=FALSE,frame=FALSE,ann=FALSE);
        par(mar=c(0,0,0,0),bg=rgb(1,1,1));
        par(usr=c(-1.1,1.1,-1.1,1.1));
        
        #triangbg = rgb(triangbgR,triangbgG,triangbgB, triangbgAlpha, maxColorValue=255)
        #triangbgr = character(4)
        #for (a in 0:4) triangbgr[a] <- rgb(triangbgR+a,triangbgG+a,triangbgB+a, triangbgAlpha, maxColorValue=255)
        #Draw snowflake:
        maxi <- if (numiter>0) 6 else 0
        maxj <- if (numiter>1) 6 else 0
        maxk <- if (numiter>2) 6 else 0
        maxl <- if (numiter>3) 6 else 0
        for (i in 0:maxi) for (j in 0:maxj) for (k in 0:maxk) for (l in 0:maxl) Iterate(T0,c(i,j,k,l), col=triangbg, border=triangbdr);
}

generateComplexPoints <- function(realRange, imaginaryRange) {
        result <- NULL
        for(i in imaginaryRange) {
                imag <- complex(imaginary = i)
                result <- c(result, realRange + imag)
        }
        dim(result) <- c(length(realRange), length(imaginaryRange))
        return (result)
}
generateJuliaFancy <- function(len=400, many=50, mycol) {
        realValues <- seq(-1.5,1.5,length.out=len)
        imaginaryValues <- seq(-1.5,1.5,length.out=len)
        initialPoints <- generateComplexPoints(realRange=realValues,imaginaryRange=imaginaryValues)
        
        timeToGetLarge <- rep(0, length(initialPoints))
        offset <- complex(real=-0.09375,imaginary=-0.8268743)
        current <- initialPoints
        for(i in 1:many) {
                current <- current**2 + offset;
                # in this one keep track of how many steps it takes before the points get
                # larger that 2
                timeToGetLarge <- timeToGetLarge + ifelse(Mod(current) < 2, 1, 0)
        }
        image(realValues,imaginaryValues,timeToGetLarge, col=c(mycol(many-1), "black"))

}       


shinyServer(
        function(input, output, session) {
                triangbg <- reactive({rgb(input$bgR, input$bgG, input$bgB, input$bgA, maxColorValue=255)})
                triangbdr <- reactive({rgb(input$bdrR, input$bdrG, input$bdrB, input$bdrA, maxColorValue=255)})
                output$type <- renderText(if(input$fractalType==0) "Please select a Fractal type from the dropdown list on the left" 
                                          else paste0("Fractal Type = ", if(input$fractalType==1) paste0("Koch with ",input$iterations," iterations.") 
                                                      else paste0("Julia with ",input$depth," colors and ", input$points, " points.")))
                output$textbg <- renderText(if(input$fractalType==1) paste0("Fill Color = ", {triangbg() }) else "")
                output$textbdr <- renderText(if(input$fractalType==1) paste0("Border Color = ", {triangbdr() }) else "")
                output$credits <- renderText(if(input$fractalType==1) "Credits: Base Koch fractal script by A. Roberts, 2013, modified by A.Taglioni (me) to make it configurable with parameters" else
                        if(input$fractalType==2) "Credits: Julia fractal script by Mike Hewner, 2012, modified by A.Taglioni (me) to make it configurable with parameters")
                mycol <- reactive({if (input$colormap == 1 ) rainbow else
                        if (input$colormap == 2 ) terrain.colors else
                                if (input$colormap == 3 ) topo.colors else
                                        cm.colors
                })
                
                output$myFractal <- renderPlot(
                        if (input$fractalType==1) {
                                KochSnowflakeExample(triangbg(), triangbdr(), numiter=input$iterations)
                        } else if (input$fractalType==2) {                                
                                generateJuliaFancy(input$points, input$depth, mycol())
                        }
                )
                observe({
                        input$resetbg
                        updateSliderInput(session, "bgR", value = 73)
                        updateSliderInput(session, "bgG", value = 82)
                        updateSliderInput(session, "bgB", value = 115)
                        updateSliderInput(session, "bgA", value = 187)
                })                
                observe({
                        input$resetbdr
                        updateSliderInput(session, "bdrR", value = 187)
                        updateSliderInput(session, "bdrG", value = 255)
                        updateSliderInput(session, "bdrB", value = 255)
                        updateSliderInput(session, "bdrA", value = 80)
                        
                }) 
                observe({
                        input$resetJulia
                        updateSliderInput(session, "depth", value = 30)
                        updateSliderInput(session, "points", value = 300)
                }) 
        }
)