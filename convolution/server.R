library(Hmisc)
library(stats)
library(shiny)
timeRes <- 1/100
shinyServer( function(input, output,session) {
        tmin <- -10; tmax <- 10
        t <- seq(tmin,tmax,timeRes);
        tconv <- seq(2*tmin,2*tmax,timeRes)
        data <- list(tmin=tmin,tmax=tmax, t=t, x=t*0, h=t*0, 
                     tconv = tconv,conv = tconv*0)
        
         output$slider <- renderUI({ 
                input$tmin
                input$tmax
                sliderInput("t0", HTML(paste("Value of t", tags$sub(0), sep = "")),
                            value = 2*input$tmin, 
                            min = 2*input$tmin, max = 2*input$tmax, step = 0.1)
        })

        upAxis <- reactive({
                        if((input$tmin != data$tmin) | (input$tmax != data$tmax)){
                                data$t <<- seq(input$tmin,input$tmax,timeRes) 
                                data$x <<- seq(input$tmin,input$tmax,timeRes)*0
                                data$h <<- seq(input$tmin,input$tmax,timeRes)*0
                                data$tmin <<- input$tmin
                                data$tmax <<- input$tmax
                                data$tconv <<- seq(2*data$tmin,2*data$tmax,timeRes)
                                data$conv <<- data$tconv*0
                        }                  
        })        
  
        upX <- reactive({
                if(input$addX>0){
                        isolate({
                                t1 <- input$xtmin; t2 <- input$xtmax
                                seqt = which(data$t>=t1 & data$t<=t2)
                                eq <- input$eqx
                                eq <- gsub("t","data$t[seqt]", eq)
                                data$x[seqt] <<- eval(parse(text=eq))
                        })
                }                
        })
        
        upH <- reactive({
                if(input$addH>0){
                        isolate({
                                t1 <- input$htmin; t2 <- input$htmax
                                seqt = which(data$t>=t1 & data$t<=t2)
                                eq <- input$eqh
                                eq <- gsub("t","data$t[seqt]", eq)
                                data$h[seqt] <<- eval(parse(text=eq))
                        })
                }
        })
        
        convUp <- reactive({
                input$addH
                input$addX
                data$conv <<- convolve(data$x,rev(data$h),type="open")*timeRes                
        })
  
        output$xhFunction <- renderPlot({  
                upAxis(); upX(); upH()
                par(mfrow=c(1,2))
                plot(data$t,data$x,"l", main="Input signal x(t)", xlab="t", ylab="x(t)") 
                plot(data$t,data$h,"l", main="Impulse response h(t)", xlab="t", ylab="h(t)")
                par(mfrow=c(1,1))
                
        })
        
        output$convFunction <- renderPlot({
                input$tmin; input$tmax
                if (length(input$t0)>0){
                        t0 <- input$t0
                }else{
                        t0 <- 0    
                }                        
                convUp()                
                par(mfrow=c(1,2))
                ht0 <- rev(data$h); 
                ht0 <- Lag(ht0, round((t0-data$tmin-data$tmax)/timeRes))
                ht0[is.na(ht0)] <- 0
                xht0 <- data$x*ht0
                ymax <- max(data$h,xht0,data$x)
                ymin <- min(data$h,xht0,data$x)
                plot(data$t,ht0,"l",col="red", ylim=c(ymin,ymax),
                     main=expression("Computation of y(t"[0]*")"), xlab=expression(tau), ylab="")  
                polygon(data$t,xht0,col="#FF9933", border="#FF9900", lwd=3)  
                lines(data$t,data$x,"l", col="black")
                lines(data$t,ht0,col="#0033FF")                
                if (sum(abs(data$conv)) != 0){
                        t02d <- round(t0,2)
                        text(data$tmin+0.1*(data$tmax-data$tmin), 
                            ymin + 0.96*(ymax-ymin),
                            bquote(t[0] == .(t02d)))
                        legend("bottomright",
                               c(expression(paste("x(",tau,")·h(",t[0]-tau,")")),
                                 expression(paste("x(",tau,")")),
                                 expression(paste("h(",t[0]-tau,")"))),
                               lty=c(1,1,1), lwd=c(3,2,2),
                               col=c("#FF9900","black","#0033FF"), cex=0.9, horiz=FALSE)
                }              
                plot(data$tconv,data$conv,"l",col="grey", main="Output signal y(t)",
                     xlab="t", ylab="y(t)")
                tind <- which(data$tconv<=t0)
                lines(data$tconv[tind],data$conv[tind],lwd="3")
        })
        
} )