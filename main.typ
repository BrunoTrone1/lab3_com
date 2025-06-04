#import "@preview/codly:1.0.0": *
#import "@preview/numberingx:0.0.1"

#show: codly-init.with()

#codly(
  languages: (
    cpp: (name: "c++", color: rgb("#0076a8")),
  )
)

#set par(
  justify: true
)

#set text(
  size: 11pt
)


#set figure(
  supplement: [Figura]
)



#set page(margin: 2cm)
#set par(leading: 0.55em, spacing: 0.55em, first-line-indent: 1.8em, justify: true)
#set text(font: "New Computer Modern")
#show raw: set text(font: "New Computer Modern Mono")
#show heading: set block(above: 1.4em, below: 1em)
#set heading(numbering: "I.")

#show outline.entry.where(
  level: 1
): it => {
  v(12pt, weak: true)
  strong(it)
}

#set page(
  footer: [
    Santiago, Chile
    #h(1fr)
    #datetime.today().display()
  ],
)

#align(center, 
  list(
    marker: "",
    v(0.5cm),
    text(size:19pt, weight: "bold" ,[UNIVERSIDAD DIEGO PORTALES]),
    v(0.5cm),
    text(size:11pt, weight: "bold", "FACULTAD DE INGENIERÍA Y CIENCIAS"),
    text(size:11pt, weight: "bold", "ESCUELA DE INFORMÁTICA Y TELECOMUNICACIONES"),
    v(0.35cm),
    image("logo_udp.png", width: 270pt),
    v(1mm),
    stack(
      spacing: 1.5mm,
      line(length: 100%, stroke: 0.5pt),
      line(length: 100%, stroke: 1.5pt)
    ),
    stack(
      spacing: 0.3cm,
      stack(
        spacing: 0.3cm,
        text("COMUNICACIONES DIGITALES CA02", size: 15pt, weight: "bold"),
        text("Informe Laboratorio 3: Modulación pasabanda de señales
        binarias", size: 15pt, weight: "bold"),
      ),
      stack(
        spacing: 1.5mm,
        line(length: 100%, stroke: 0.5pt),
        line(length: 100%, stroke: 1.5pt)
      ),
    ),
  )
)

#align(center, 
  list(
    marker: "",
    v(1cm),
    text("Profesor Cátedra:", size: 14pt, weight: "bold"),
    text("Luis Venegas", size: 14pt, weight: "bold"),
    v(1cm),
    
    text("Profesor Laboratorio:", size: 14pt, weight: "bold"),
    text("Marcos Fantóval", size: 14pt, weight: "bold"),
    v(1cm),
    
    text("Estudiantes: ", size: 14pt, weight: "bold"),
    text("Bruno Rosales", size: 14pt, weight: "bold"),
    text("Guillermo Carreño", size: 14pt, weight: "bold"),
    text("Diego Martin", size: 14pt, weight: "bold"),
  )
)

#set page(
  footer: [],
)

#pagebreak()

#set page(header: [
  #stack(
    dir: ltr,
    spacing: 1fr,
    image("logo_udp.png", height: 0.7cm),
    list(
      marker: "",
      text("Facultad de Ingeniería y Ciencias"),
      text("Instituto de Ciencias Básicas")
    )
  )
  #line(length: 100%)
])

#set page(footer: context {
  let current = counter(page).get().at(0)
  [
    #line(length: 100%)
    #h(1fr)
    Página #current
  ]
})

// --------------------------------------------- //

#set page(columns: 2)
= Introducción

Para este laboratorio se llevó a cabo como grupo actividades que incluyeron el estudio del comportamiento espectral de las señales ASK, el cálculo del ancho de banda teórico, la obtención de la envolvente compleja $g(t)$ y la representación gráfica de su transformada de Fourier. Este análisis permitió anticipar cómo se distribuye la energía de la señal en el dominio de la frecuencia y establecer comparaciones posteriores con los resultados experimentales.

Además del trabajo analítico, se desarrollaron simulaciones utilizando GNU Radio y Matlab. El grupo diseñó un transmisor OOK básico, en el que una señal binaria se utilizó para modular una portadora generada por un bloque de tipo Signal Source configurado con forma de onda cuadrada. Se emplearon bloques de control y visualización como QT GUI Time Sink y QT GUI Frequency Sink para observar el comportamiento temporal y espectral de la señal generada.

Estas actividades permitiron entender los fenómenos observados experimentalmente. En particular, observar el ancho de banda en la señal OOK con el ancho de banda teórico previamente calculado, y reflexionar sobre los posibles factores que explican cualquier diferencia entre ambos. Este enfoque integrador entre teoría y simulación constituyó un paso fundamental para una comprensión más profunda del proceso de modulación digital y sus implicancias en sistemas reales de transmisión.

= Antecedentes

La modulación digital es un proceso fundamental en las comunicaciones modernas que permite transmitir información binaria a través de un medio físico mediante señales analógicas moduladas. Entre las técnicas más sencillas y ampliamente utilizadas para este propósito se encuentra la ASK (Amplitude Shift Keying).

== Modulación ASK/OOK

La ASK o modulación por desplazamiento de amplitud es uno de los esquemas de modulación digital más fáciles en contextos donde se privilegia la simplicidad del transmisor. En esta técnica, la amplitud de una portadora sinusoidal varía en función de los datos binarios de entrada. Específicamente, para un esquema binario, la amplitud toma dos valores distintos: uno diferente de cero cuando el bit transmitido es un "1", y cero cuando el bit transmitido es un "0".

Una variante particular y común de ASK es la técnica denominada OOK (On-Off Keying), en la cual la presencia o ausencia de la portadora representa directamente los valores binarios. Esta técnica es sencilla de implementar y eficiente en potencia, ya que no se transmite energía durante los intervalos correspondientes a bits en "0".

La expresión general que modela una señal ASK binaria puede escribirse como:

\
$ s_"ASK"(t) = A_c dot m(t) dot cos(2pi f_c t) $
\

Donde:

- Ac​ es la amplitud de la portadora,

- $f_c$​ es la frecuencia de la portadora,

- $m(t)$ es la señal modulante binaria, que toma valores 0 o 1.

\

Desde el punto de vista espectral, el ancho de banda teórico de una señal ASK depende de la tasa de bits $f_b$​. Para una señal modulada en amplitud, este ancho de banda puede aproximarse como:

\
$ "BW"_"ASK" approx 2 dot f_b $
\

Este valor corresponde al doble de la frecuencia de símbolo, ya que la modulación en amplitud genera componentes en torno a la frecuencia portadora que se extienden hacia ambos lados.

== Modulación FSK

La FSK (Frequency Shift Keying) o modulación por desplazamiento de frecuencia representa otra técnica digital fundamental, en la cual la información se transmite mediante cambios discretos en la frecuencia de la portadora. En el caso más simple de FSK binaria, se utilizan dos frecuencias distintas: una para representar el bit "0" y otra para el bit "1". A diferencia de ASK, la amplitud de la señal permanece constante durante toda la transmisión, lo que otorga a FSK una mayor inmunidad al ruido y a las distorsiones de amplitud.

Matemáticamente, una señal FSK puede representarse como:

\
$ s_"FSK"(t) = A_c dot cos(2pi (f_c + Delta f dot m(t)) t) $
\

Donde:

- $A_c$​ es la amplitud constante,

- $f_c$ es la frecuencia central o nominal,

- $Delta f$ es el desplazamiento de frecuencia,

- $m(t)$ es la señal binaria modulante que toma valores −1 o +1, dependiendo del bit transmitido.

\

Para estimar el ancho de banda necesario para transmitir una señal FSK, se aplica la regla de Carson, ampliamente utilizada en modulación angular. Esta regla establece que el ancho de banda aproximado está dado por:

\
$ "BW"_"FSK" approx 2 dot Delta f + 2 dot f_b $
\

Donde:

- $Delta f$ es el desvío de frecuencia entre los dos tonos,

- $f_b$​ es la frecuencia de símbolo.

Este resultado refleja que el espectro de FSK incluye componentes ubicados a una distancia de $Delta f$ de la portadora, y que la tasa de bits introduce un ensanchamiento adicional de $±f_b$​. Por tanto, FSK requiere más ancho de banda que ASK, pero a cambio ofrece mayor robustez frente a errores inducidos por ruido e interferencias.

= Metodología

En este laboratorio se utilizaron 2 técnicas de modulación digital: ASK con su variante OOK y FSK. El calculo del ancho de banda teórico se llevo a cabo para ambas modulaciones, mediante las expresiones teóricas. Para la modulación OOK se utilizo la aproximación $"BW"_{"OOK"} approx 2 f_b$, mientras que para la modulacion FSK se aplico la regla de Carson $"BW"_{"FSK"} approx 2 Delta f + 2 f_b$, con $f_b$ siendo la tasa de bits y $Delta f$ el desplazamiento de frecuencia.

La implementación experimental se realizó en dos plataformas: GNU Radio y Matlab. Para esto se construyeron los sistemas completos de transmisión para OOK y FSK en GNU Radio, como se aprecia en @FSK_GNU y @OOK_GNU, mientras que se generaron señales y transformadas de Foureier en Matlab.

Para la  FSK que se aprecia en la figura @FSK_GNU, se genera una señal de datos digital mediante una fuente de onda cuadrada, la cual, junto con su versión invertida, controla la selección entre dos frecuencias portadoras distintas generadas por fuentes de onda cosenoidal. La multiplicación de los datos con sus respectivas portadoras y la posterior suma de estas señales producen la señal FSK modulada. Finalmente, esta señal se convierte a formato complejo y se visualiza en el dominio del tiempo y de la frecuencia utilizando los receptores gráficos QT G. Mientras que para la OOK se llevo a cabo un proceso distinto, con distintos bloques y que se ve reflejado en el analisis.

Complementariamente, en Matlab se desarrollaron scripts (los cuales se encuentran en el repositorio, y sus capturas en anexos como @Fourier_ASK, @Fourier_FSK, @Señal_ASK y @Señal_FSK) que permitieron verificar los resultados teóricos y simular escenarios controlados. Se generaron señales OOK y FSK, y se analizaron sus espectros utilizando la DFT (Transformada de Fourier Discreta). Matlab fue especialmente útil para comparar directamente el espectro ideal teórico con el observado en GRC, y para generar gráficos de mayor calidad que pudieran incorporarse en el informe final.

= Resultados y Análisis

Las imágenes y gráficos resultantes ilustran claramente las diferencias principales entre la Modulación por Desplazamiento de Frecuencia (FSK) y la Modulación por Desplazamiento de Amplitud (ASK), tanto en el dominio del tiempo como en el de la frecuencia. En los gráficos de FSK @Señal_FSK y @FSK_GNU_R, se puede observar que la amplitud de la señal permanece constante, mientras que la frecuencia cambia, representando los bits binarios. Esta característica se refleja en los espectros de las frecuencias de @FSK_GNU_R y @Fourier_FSK, donde aparecen dos picos distintivos, cada uno correspondiente a una de las frecuencias utilizadas. Esto muestra la robustez de FSK frente a las variaciones de amplitud generadas por el ruido.

Por otro lado, las imágenes y gráficos resultantes de ASK y OOK revelan una dinámica diferente. En los gráficos del dominio del tiempo de @Señal_ASK y @OOK_GNU_R, la frecuencia de la portadora se mantiene constante, pero la amplitud varía para codificar la información. Específicamente, en OOK, la señal se enciende o apaga completamente. Esta variación de amplitud se manifiesta en los espectros de frecuencia de @OOK_GNU_R y @Fourier_ASK, donde se observa un lóbulo principal centrado en la frecuencia portadora, rodeado de lóbulos laterales que reflejan la forma de los pulsos de datos. Esta dependencia de la amplitud hace que las señales ASK sean más susceptibles al ruido que afecta la magnitud, en contraste con la FSK.

= Conclusiones

Luego de realizar el laboratorio fue posible identificar y entender las principales diferencias entre la modulación ASK/OOK y la modulación FSK, siendo la diferencia fundamental la naturaleza de los parámetros modulados. Mientras ASK modula o altera la amplitud de la señal portadora, FSK varía la frecuencia de su señal portadora, lo que le da a FSK una mejor resistencia al ruido.

En términos de complejidad la modulación ASK es más simple y lineal, mientras que FSK, al involucrar componentes no lineales y generación precisa de frecuencias requiere de una implementación mucho más elaborada. 

Por otra parte en lo relativo a ancho de banda la modulación ASK utiliza mucho menos que la modulación FSK, mientras que ASK utiliza un ancho de banda de el doble de la tasa de bits FSK depende de la tasa de bits y del desplazamiento de frecuencias, lo que aumenta mucho su ancho de banda. Este uso de ancho de banda mayor por parte de FSK se justifica al ser mas confiable en entornos ruidosos.




= Referencias
+ L. Couch, Sistemas de comunicacion digitales y analogicos. Mexico: Pearson/Prentice Hall, 2008.
+ B. P. Lathi, Modern digital and analog communication systems. New York: Oxford University Press, 2019 

#pagebreak()

#set page(columns: 1)

= Anexos
- Repositorio Github: #link("https://github.com/BrunoTrone1/lab3_com")

\
#figure(
  image("Fourier_ASK.png"),
  caption: [Fourier ASK],
) <Fourier_ASK>
\
\
#figure(
  image("Fourier_FSK.png"),
  caption: [Fourier FSK],
) <Fourier_FSK>
\
\
#figure(
  image("Señal_ASK.png"),
  caption: [Señal ASK],
) <Señal_ASK>
\
\
#figure(
  image("Señal_FSK.png"),
  caption: [Señal FSK],
) <Señal_FSK>
\
\
#figure(
  image("FSK_GNU.png"),
  caption: [FSK GNU],
) <FSK_GNU>
\
\
#figure(
  image("OOK_GNU.png"),
  caption: [OOK GNU],
) <OOK_GNU>
\
\
#figure(
  image("FSK_GNU_R.png"),
  caption: [FSK GNU Resultados],
) <FSK_GNU_R>
\
\
#figure(
  image("OOK_GNU_R.png"),
  caption: [OOK GNU Resultados],
) <OOK_GNU_R>
\
