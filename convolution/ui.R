shinyUI(pageWithSidebar( 
        headerPanel(HTML(" &nbsp; &nbsp;LTI systems: convolution &nbsp;&nbsp;&nbsp;&nbsp;&nbsp; y(t) = x(t) * h(t)")), 
        sidebarPanel(
                h4('Global time settings'),
                numericInput('tmin', 'Lower time limit:', -10, min = -50, max = 50, step = 1),
                numericInput('tmax', 'Upper time limit:', 10, min = -50, max = 50, step = 1),
                uiOutput("slider"),
                h4('Input signal x(t)'),
                numericInput('xtmin', 'Lower time limit:', -4, min = -50, max = 50, step = 0.1),
                numericInput('xtmax', 'Upper time limit:', 4, min = -50, max = 50, step = 0.1),
                textInput('eqx', 'Equation:', value = "0.5*t"),
                actionButton("addX", "Add function"),
                h4('Impulse reponse h(t)'),
                numericInput('htmin', 'Lower time limit:', -8, min = -50, max = 50, step = 0.1),
                numericInput('htmax', 'Upper time limit:', 0.1, min = -50, max = 50, step = 0.1),
                textInput('eqh', 'Equation:', value = "exp(0.2*t)"),
                actionButton("addH","Add function")
        ),
        mainPanel( 
                tabsetPanel(
                        tabPanel("App Results", h4(HTML(paste("Computation of y(t", tags$sub(0), ") and output signal y(t)", sep = ""))),
                                 plotOutput('convFunction'), 
                                 h4('Input signal x(t) and impulse response h(t)'),   
                                 plotOutput('xhFunction')                                   
                                 ), 
                        tabPanel("App Description", 
                                 h4("Motivation"),
                                 p("This App has been designed to help students understand how the convolution of two signals
                                   x(t) and h(t) is computed."),
                                 p("In Linear Time Invariant (LTI) systems that are defined by its impulse response h(t), i.e.
                                   the system output when the input is the Dirac delta function, the output to a generic 
                                   input signal x(t) is computed as y(t)=x(t)*h(t) being * the convolution operator. Mathematically,
                                   "),
                                 img(src = "conv.png", height = 80, width=350),
                                 h4("How it works"),
                                 p("Do the following steps:"),
                                 HTML("<ul><li>Define the upper and lower time limits in global time settings. 
                                                Signals x(t) and h(t) will be defined inside this
                                                time window and assumed to be zero outside. Important note: 
                                                changing the global time settings resets the App.</li>
                                        <li> Define input and impulse response signals x(t) and h(t), respectively.</li>
                                                <ul><li> The signals are defined in time intervals, which may be overriden. </li>
                                                <li> To define one interval of the function, adjust lower and upper time limits
                                                     and write the desired mathematical expression in R format, where t is the 
                                                     independent variable. Examples: cos(t), 3*t^2, exp(0.1*t), etc. Note: avoid division by 0. </li>
                                                <li> Hit Add function button. </li>
                                                <li> Repeat the last two steps as many times as desired. </li>
                                                <li> Resulting x(t) and h(t) signals can be seen at the two bottom figures. </li>
                                                </ul>
                                        <li>The convolution result can be seen at the top right figure.</li>
                                        <li>Move the slider to see how y(t) is computed for t=t<sub>0</sub>.</li>
                                        <li>Black and blue curves at the top left figure plot the functions inside the convolution integral 
                                                for t=t<sub>0</sub>, i.e. x(&tau;) and h(t<sub>0</sub>-&tau;).</li>
                                        <li>The orange curve plots the product of the previous functions 
                                            and the orange area is exactly the output at t=t<sub>0</sub>, i.e. y(t<sub>0</sub>). </li>
                                        <li>In the output plot at the top right, the resulting curve is highlighted for t &#60; t<sub>0</sub>.</li>
                                        </ul>"),
                                        h4("Troubleshooting"),
                                        p("If the App does not respond as expected, try to reset it by changing the values
                                          in Global Time Settings.")
                                 )                
                )               
        ) 
))