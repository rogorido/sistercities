---
title: "Visualizing Urban and Demographic Data in R with ggplot2"
slug: urban-demographic-data-r-ggplot2
layout: lesson
collection: lessons
date: 2025-03-27
authors:
- Igor Sosa Mayor
- Nabeel Siddiqui
reviewers:
- Justin Wigard
- Amanda Regan
editors:
- Giulia Osti
review-ticket: https://github.com/programminghistorian/ph-submissions/issues/606
difficulty: 2
activity: presenting
topics: [r, data-visualization]
abstract: This lesson demonstrates how to use R's ggplot2 package to create sophisticated data visualizations through a 'grammar of graphics' framework. Using historical data about European sister-city relationships in the post-second world war period, including partnerships, population sizes, and geographic distances, the lesson guides readers through the process of creating various plots while exploring urban and demographic patterns.
avatar_alt: Crop of hand-drawn nautical chart showing two cities in Spain
doi: 10.46430/phen0123
---

{% include toc.html %}

## Introduction

Después de la Segunda Guerra Mundial, las ciudades europeas se enfrentaron a una tarea monumental: reconstruir no sólo su infraestructura física, sino también sus relaciones internacionales. Un foco fascinante a través del cual examinar la reconstrucción posbélica es las [ciudades hermanadas](https://perma.cc/H2ER-XTRS). Estas alianzas formales se desarrollaron entre las ciudades en el período de posguerra para fomentar la cooperación y el entendimiento transfronterizos.

Las relaciones entre ciudades hermanadas enfrentan a los historiadores con oportunidades y desafíos. La oportunidad radica en su potencial para revelar patrones de reconciliación y diplomacia posbélica. El desafío proviene de su escala y complejidad: hay cinetos de ciudades europeas y cada una podría haber formado decenas de parejas de hermanamientos a lo largo de múltiples décadas. Al convertir estas complejas redes de relaciones hermanas en patrones visuales, podemos explorar preguntas difíciles de responder únicamente con métodos tradicionales. Por ejemplo, ¿prefirieron las ciudades de [Alemania Occidental](https://perma.cc/ALL6-TWXA) establecer relaciones con ciudades francesas inmediatamente después de la guerra? ¿Creó el [Telón de Acero](https://perma.cc/XH8M-XCJ9) patrones distintos de relaciones entre Europa del Este y del Oeste? ¿Cómo influyeron el tamaño de la ciudad y la distancia geográfica en las conexiones diplomáticas? Este caso es un buen ejemplo de cómo puede ser útil la visualización de datos para la investigación histórica.

El paquete de R [ggplot2](http://ggplot2.tidyverse.org) proporciona herramientas poderosas para investigar preguntas de esta índole a través de la visualización de datos. Aunque las hojas de cálculo y los gráficos básicos pueden ocultar patrones, las capacidades de visualización avanzadas de ggplot2 permiten a los historiadores descubrir relaciones ocultas en los datos. Por ejemplo, los [gráficos de scatter](https://perma.cc/47QY-KL2V) pueden revelar correlaciones entre variables numéricas como tamaños poblacionales y distancias geográficas, los [gráficos de barras](https://perma.cc/H58M-6UDU) pueden mostrar la distribución de hermanamientos en diferentes categorías de ciudades y los [histogramas](https://perma.cc/W7TW-9V52) pueden exponer patrones en los datos demográficos que de otro modo podrían permanecer invisibles.

Este curso se diferencia de las guías estándar de ggplot2 al enfocarse específicamente en las necesidades de los historiadores urbanos. En lugar de utilizar conjuntos de datos generales, trabajaríamos con datos históricos sobre relaciones entre ciudades hermanadas para demostrar cómo los técnicas visuales pueden iluminar patrones y procesos históricos. A través de este enfoque, aprenderás a crear visualizaciones que revelen alianzas complejas y hacer encuentros históricos más accesibles a un público más amplio.

## Objetivos del Lecció

Al final de esta lección, deberás ser capaz de hacer las siguientes cosas con el paquete ggplot2:

- Crear diferentes tipos de gráficos para visualizar datos urbanos y demográficos, incluyendo gráficos de barras para mostrar relaciones entre ciudades y gráficos de dispersión para explorar relaciones entre diferentes variables.
- Manipular la apariencia de los gráficos, como su color o tamaño.
- Agregar etiquetas significativas a los gráficos.
- Comparar datos a través de grillas de gráficos.
- Mejorar tus gráficos con extensiones de ggplot2.

Esta lección supone que tienes conocimientos básicos de R. Se recomienda familiarizarse con las lecciones de *Programming Historian* [R Basics with Tabular Data](/en/lessons/r-basics-with-tabular-data) y [Data Wrangling and Management in R](/en/lessons/data-wrangling-and-management-in-r).

## Nuestros datos: ciudades hermanadas en la Unión Europea

Los datos urbanos y demográficos son fundamentales para comprender los desarrollos de las sociedades humanas. Los datos urbanos nos permiten reconstruir la compleja red de relaciones entre las ciudades. Esto abarca desde las conexiones administrativas formales, como las alianzas comerciales o las alianzas políticas, hasta las relaciones informales construidas a través del intercambio cultural y el movimiento de población. Las ciudades pueden estar unidas a través de rutas comerciales, estructuras de gobernanza compartidas o instituciones culturales. Las características físicas de las ciudades también forman una parte importante de los datos urbanos: su ubicación geográfica, su proximidad a otras centros urbanos y su posición en los sistemas de transporte influyen en cómo las ciudades interactúan entre sí.

La información urbana también nos ayuda a comprender los diferentes roles que desempeñan las ciudades en los sistemas más amplios sociales y económicos. Algunas ciudades sirven como centros administrativos, otras como puertos principales que facilitan el comercio internacional y, aún más, otras como centros industriales que impulsan el crecimiento económico. Estos roles a menudo cambian a lo largo del tiempo a medida que las ciudades se adaptan a las circunstancias políticas, económicas y tecnológicas cambiantes.

La información demográfica complementa este análisis urbano revelando la dimensión humana del cambio. En su nivel más básico, la información demográfica nos informa sobre las tasas de población y sus fluctuaciones, pero su verdadera valía radica en ayudarnos a comprender los complejos patrones de movimiento y asentamiento. Los cambios en la densidad poblacional reflejan los procesos de urbanización, las oportunidades económicas o las respuestas a los desafíos ambientales. Los patrones de migración pueden iluminar las relaciones económicas entre regiones, así como el impacto de las políticas. Las características sociales y económicas de las poblaciones - sus distribuciones por edad, patrones ocupacionales y estructuras sociales - también proporcionan un contexto crucial para comprender el desarrollo urbano.

Los historiadores pueden combinar estos tipos de datos para investigar el desarrollo urbano y las dinámicas demográficas. Como se mencionó anteriormente, analizaremos [ciudades hermanadas](https://perma.cc/H2ER-XTRS) – pares de ciudades que se han unido para promover vínculos culturales y comerciales. El concepto moderno de ciudades hermanadas se concibió después de la Segunda Guerra Mundial con el fin de fomentar la amistad y el entendimiento entre diferentes culturas y promover el comercio y el turismo. Estas alianzas a menudo implican intercambios estudiantiles, relaciones comerciales y eventos culturales. Al examinar estas alianzas, podemos evaluar si la proximidad geográfica, el idioma compartido o una población similar juegan un papel en la creación de una relación entre dos ciudades. También podemos explorar si las tensiones o alianzas históricas (como las entre Alemania, Francia e Polonia) o un patrimonio lingüístico compartido (por ejemplo, entre las ciudades hispanohablantes de América) moldean estas alianzas. En los últimos años, los historiadores han comenzado a [investigar de manera más cercana estas interacciones](https://perma.cc/8KW3-GKPR) de esta perspectiva.

La primera pregunta que surge es dónde obtener datos sobre ciudades hermanadas. Una posibilidad es eludir uno de los mayores repositorios de datos del mundo: [Wikidata](https://www.wikidata.org/wiki/Wikidata:Main_Page). En Wikidata, cada una de las pequeñas ciudades del mundo ha sido asignada un identificador único y tiene su propia página, conteniendo una cierta cantidad de información. Por ejemplo, la página dedicada a [Londres](https://perma.cc/3DES-EQWV) muestra, entre otras cosas, una lista de sus 'corporaciones administrativas unidas' (es decir, sus ciudades hermanadas). Con el [Protocolo de SPARQL y Lenguaje de Consulta RDF](https://perma.cc/FHK3-CTEY), podemos consultar estos datos y extraer información sobre las ciudades asociadas con Londres. Como siempre en la investigación histórica, es importante considerar la precisión de los datos, un tema que ha sido [analizado varias veces](https://perma.cc/6AS3-LFFU) en el caso de Wikidata.

Para los objetivos de este tema, hemos creado diversas consultas para extraer datos sobre ciudades en la [Unión Europea (UE)](https://perma.cc/R3PG-AJLC) y sus ciudades hermanadas. De este modo hemos compilado un conjunto de datos con los siguientes datos: el nombre, el país, el tamaño de la población y las coordenadas geográficas tanto de la "ciudad de origen" como de la "ciudad destino". También hemos calculado la distancia entre las dos ciudades, y hemos agregado una columna booleana indicando si la ciudad destino está dentro de la UE o no (todo origen está dentro de la UE). Puedes descargar este conjunto de datos desde el repositorio de _Programming Historian_'s.

Nuestra aproximación será fundamentalmente [exploratoria](https://perma.cc/SB6Z-22NT), con el objetivo de identificar patrones, tendencias y relaciones en los datos. Esperamos poder descubrir nuevos enfoques y generar hipótesis para futuras investigaciones más profundas.

## Ventajas de ggplot2

Tenemos muchas razones para elegir ggplot2 para este análisis. El paquete tiene un gran número de ventajas cuando se compara con otras opciones:

- Se basa en un marco teórico (detallado a continuación) que asegura que tus gráficos transmitan de manera significativa la información, lo que es particularmente importante cuando se trabaja con conjuntos de datos urbanos y demográficos complejos.
- Es relativamente sencillo de utilizar a pesar de su poder.
- Crea gráficos listos para la publicación.
- Viene con extensiones desarrolladas por la comunidad (http://www.ggplot2-exts.org/) que lo enriquecen aún más, como funciones adicionales, gráficos y temas.
- Es versátil, ya que puede manejar diversas estructuras de datos diversas como pueden ser
    * Datos numéricos (continuas e discretas)
    * Datos categoriales (factores y cadenas de caracteres)
    * Datos de fecha y hora
    * Coordenadas geográficas
    * Datos de texto

Crear gráficos es un asunto complicado, ya que nos obliga a considerar varios aspectos de nuestros datos: la información que queremos transmitir, el tipo de gráfico que queremos utilizar para transmitir esa información (gráfico de dispersión, gráfico de caja, histograma, y así sucesivamente), los elementos del gráfico que queremos ajustar (eje, variables, leyendas), y mucho más. Basado en un marco teórico conocido como la [gramática de gráficos](https://perma.cc/WA6W-R28Y) (de ahí el 'gg' en el nombre ggplot2) (de acuerdo con [Leland Wilkinson](https://perma.cc/2J35-L783)), ggplot2 es una herramienta útil para estandarizar estas opciones. Si todo esto suena complicado al principio, no te estreses. Solo necesitas saber un poco sobre la gramática para crear tu primer gráfico.

En el lenguaje de los gráficos, toda la composición de las representaciones gráficas se basa en siete capas interconectadas:

1. Datos: el material a analizar en la visualización.
2. [Estética](https://perma.cc/DTP2-8JFS): las formas en que las propiedades visuales se mapean sobre los supuestos 'geoms' (ver Objetos geométricos a continuación). En la mayoría de los casos, esto determina cómo deseas mostrar tus datos (posición, color, forma, relleno, tamaño).
3. [Escala](https://perma.cc/KVN7-M2LQ): el mapeo y la normalización de los datos para la visualización.
4. [Objetos geométricos](https://perma.cc/U24P-LYHG) (o 'geoms' en el lenguaje de ggplot2): cómo quieres representar tus datos. En la mayoría de los casos, esto determina el tipo de gráfico que usas, como un gráfico de barras, una gráfica de línea o un histograma.
5. [Estadística](https://perma.cc/J4HW-MXLK): las cálculos que puedes realizar sobre tus datos antes de visualizarlos.
6. [Facetas](https://perma.cc/K8M5-7NKV): la capacidad de categorizar y dividir los datos en múltiples subgráficos.
7. [Sistemas de coordenadas](https://perma.cc/H335-PJMH): cómo ggplot2 coloca diferentes geoms en la gráfica. La coordinada más común es el [sistema de coordenadas cartesianas](https://perma.cc/5HNS-XBMJ), pero ggplot2 también puede plotear [coordenadas polares](https://perma.cc/XBN8-QJ9Q) y [proyecciones estereográficas](https://perma.cc/T3LU-4NVA).

Para comenzar a utilizar ggplot2, es necesario instalar y cargarlo. Recomendamos instalar [tidyverse](https://www.tidyverse.org), una colección de paquetes R, entre ellos ggplot2, que trabajan juntos para proporcionar un flujo de trabajo coherente y eficiente a la hora de manipular, explorar y visualizar datos. En el corazón de la filosofía de tidyverse se encuentra el concepto de ['datos tidies'](https://perma.cc/XGM5-7SYY), un enfoque estándar para estructurar los datos para hacer que sea más fácil trabajar con ellos. En este tipo de datos, cada variable es una columna, cada observación es una fila y cada tipo de unidad de observación es una tabla. Esta estructura permite un enfoque coherente y predecible al trabajar con datos a lo largo de diferentes paquetes y funciones dentro de la colección tidyverse. Para obtener más detalles, consulta el libro [_R para Ciencia de Datos. Importar, Ensamblar, Transformar, Visualizar y Modelar Datos_](https://perma.cc/W8CR-JW2L) escrito por Hadley Wickham et al.

```
install.packages("tidyverse")
library("tidyverse")
```

### Cargando datos con readr

Antes de importar datos, es importante comprender cómo deben estar formateados. Las aplicaciones de hoja de cálculo comunes, como Microsoft Excel o Apple Numbers, colocan los datos en un formato propietario. Aunque existen paquetes que pueden leer datos de Excel, como [readxl](https://readxl.tidyverse.org/), se recomienda utilizar formatos abiertos en su lugar, como `.csv` (valores separados por comas) o `.tsv` (valores separados por tabuladores), ya que son compatibles con una amplia gama de herramientas de software y es más probable que puedan ser leídos también en el futuro con cualquier software.

R tiene comandos internos para leer estos archivos, pero usaremos la biblioteca [readr](https://readr.tidyverse.org/) del ecosistema tidyverse, que puede leer la mayoría de los formatos comunes. Para nuestro análisis, leeremos un archivo `.csv`. Vamos a [descargar el conjunto de datos](/assets/urban-demographic-data-r-ggplot2/sistercities.csv) y colocarlo en el directorio de trabajo actual del proyecto. A continuación, puedes usar [`read_csv()`](https://perma.cc/ED9L-9V98) con la ruta del archivo. (Si no instalaste tidyverse anteriormente, necesitarás cargar manualmente la biblioteca `readr` primero.)

```
eudata<-read_csv("sistercities.csv")
```

Ahora, podemos mostrar los datos como un tibble (13,081 x 15):

```
eudata
```

`tidyverse` convierte nuestros datos en un 'tibble' más que un 'data frame'. Los tibbles forman parte del universo de tidyverse y ofrecen la misma funcionalidad que los llamados dataframes, pero toman decisiones sobre cómo importar y mostrar los datos en R. R es un lenguaje de programación relativamente antiguo y, como resultado, las preferencias que se tomaron durante la implementación original son a menudo menos útiles ahora. Los tibbles, al contrario que los dataframes, no cambian los nombres de las variables, convierten el tipo de entrada o crean nombres de filas. Puedes [aprender más sobre tibbles aquí](https://perma.cc/4BJY-8M8U). Si esto no tiene sentido, no te preocupes. En la mayoría de los casos, podemos tratar los tibbles como dataframes y convertir entre los dos con facilidad. Para convertir tu dataframe a un tibble, utiliza la función `as_tibble()` con el nombre del dataframe como parámetro. De manera similar, para convertir de vuelta a data frame, utiliza la función `as.data.frame()`.

Empezaremos explorando los datos para las ciudades en seis países de la Unión Europea: Alemania, Francia, Portugal, Polonia, Hungría y Bulgaria (tres países europeos occidentales y tres europeos orientales). La tabla que viste anteriormente, llamada `eudata`, contiene esta información en 15 variables y 13081 filas.

El tibble contiene información completa que combina datos urbanos y demográficos sobre relaciones de ciudades hermanadas. Los datos urbanos incluyen el nombre de las ciudades de origen y destino (**origincity**, **destinationcity**), sus respectivos países (**origincountry**, **destinationcountry**) y sus coordenadas geográficas (**originlat**, **originlong**, **destinationlat**, **destinationlong**). También contiene información sobre la distancia entre las ciudades vinculadas (**dist**) y el estatus de relación administrativa de cada ciudad (**eu**). Para el análisis demográfico, tenemos la tamaño de población de ambas ciudades de origen y destino (**originpopulation**, **destinationpopulation**). Esta combinación de tipos de datos debe permitir explorar cómo las características de las ciudades y los patrones de población influyen en las relaciones entre ellas.

## Creando tu primer gráfico

Empecemos creando un primer gráfico. Analicemos un patrón urbano que se relaciona con cuestiones más amplias sobre la integración europea y las relaciones internacionales: ¿los ayuntamientos de la UE tienden a formar relaciones de hermanas ciudades más sólidas con ciudades dentro del mismo país, en otros países de la UE o fuera de la UE? Al responder a esta pregunta, podemos comprender no solo las relaciones de ciudades hermanadas, sino también procesos históricos más amplios como la reconciliación tras la guerra, el desarrollo de la identidad europea y la naturaleza cambiante de la diplomacia urbana. Las técnicas de visualización similares podrían utilizarse para estudiar otras relaciones internacionales, como las alianzas comerciales, los intercambios culturales o las misiones diplomáticas.

Vamos a empezar contando el número de ciudades de destino que son tanto nacionales (del mismo país que la ciudad de origen), de un país diferente de la UE o de un país no de la UE. Vamos a introducir el siguiente código:

```
ggplot(eudata, aes(x = typecountry)) +
  geom_bar()
```

{% include figure.html filename="en-or-urban-demographic-data-r-ggplot2-01.png" alt="Un gráfico de barras que muestra el total de ciudades destino que son nacionales, de la UE, o no de la UE" caption="Figura 1. Gráfico de barras que muestra el total de ciudades destino que son nacionales, de la UE, o no de la UE." %}

El primer parámetro de la función `ggplot()` son los datos (tibble o dataframe) que contienen la información que se está explorando, mientras que el segundo parámetro son las llamadas 'estéticas' del gráfico. Como puedes recordar de antes, las estéticas definen las variables en tus datos e indican cómo quieres mapearlas a las propiedades visuales del gráfico. Estos dos son los fundamentos de cualquier gráfico.

La capa `geom()` le dice a ggplot2 qué tipo de gráfico deseas producir. Para crear un gráfico de barras, necesitas la capa `geom_bar()`, que se puede agregar rápidamente utilizando el comando `+` como se muestra en el código anterior.

Entender el sintaxis de `ggplot()` puede ser confuso al principio pero una vez que comienza a hacer sentido, podrás ver la potencia del marco estándar que subyace a ggplot2 (la gramática de gráficos). Una manera de pensar en esta gramática es considerar la creación de gráficos como la construcción de una oración. En este ejemplo, le dijiste a R: "Crea un gráfico de ggplot utilizando los datos en `eudata`, mapea el campo `typecountry` a x y agrega una capa llamada `geom_bar()`. Esta estructura es relativamente sencilla. [`aes()`](https://perma.cc/AH27-4YE9) en sí mismo no es tan explicable, pero la idea detrás de ella es bastante simple: le dice a R que mapee ciertos campos en los datos a las propiedades visuales (estéticas) de los `geoms` en el gráfico. No te preocupes si no la entiendes completamente. Volveremos a profundizar más tarde.

¡Ahora tienes tu primer gráfico! Podrás notar que ggplot2 ha realizado algunas decisiones por su cuenta: el color de fondo, el tamaño de la fuente de los etiquetas, etc. Las configuraciones por defecto suelen ser suficientes, pero puedes personalizar estos aspectos si lo prefieres.

Dado que ggplot2 funciona dentro de un sintaxis consistente, puedes modificar fácilmente tus gráficos para que tenga un aspecto diferente o muestren diferentes datos. Por ejemplo, digamos que deseas porcentajes en lugar de conteos simples. Utilizando el siguiente código, puedes crear un nuevo tibble que calcula las porcentajes y agrega los nuevos datos en una nueva columna llamada **perc** (vuelve a la lección [Data Wrangling y Managment en R](/en/lessons/data-wrangling-and-management-in-r) sobre dplyr si este código no tiene sentido). Luego, solo necesitas hacer unos pocos ajustes en el código para agrupar los datos por tipo de país, agregar una nueva columna con porcentajes y mostrar el nuevo gráfico:

```
eudata.perc <- eudata %>%
  group_by(typecountry) %>%
  summarise(total = n()) %>%
  mutate(perc = total/sum(total))

ggplot(data = eudata.perc, aes(x = typecountry, y = perc)) +
  geom_bar(stat = "identity")
```

{% include figure.html filename="en-or-urban-demographic-data-r-ggplot2-02.png" alt="Bar graph showing percentage of destination cities that are domestic, EU, and non-EU." caption="Figure 2. Bar graph showing percentage of destination cities that are domestic, EU, and non-EU." %}

There is an important difference between the first plot (Figure 1) and this one. In the previous plot, ggplot2 counted the number of cities in every group (domestic, EU, non-EU). In our new plot, the tibble already contained each bar's numerical value, stored in the **perc** column. This is why we specify `y = perc` as a parameter of `aes()`. The tricky part is that by default, `geom_bar()` will use the parameter `stat = "count"`. This means it will count how many times a value appears. In other words, it aggregates data for you. However, you can inform ggplot2 that you have already calculated your values by using the parameter `stat = "identity"`.

Figure 2 shows that most sister cities are from a different country than the origin city, yet still within the EU (around 68%). This could be due to geographical proximity, cultural similarities, or economic ties within the European Union. you can get a more detailed look by adding in the name of each origin country to the visualization. You could decide to visualize this either by breaking down each bar into percentages by origin country (Figure 3), or by creating separate graphs for each origin country (this is called 'facetting' in ggplot2 lingo, which we [cover below](#Facetting-a-Graph)). Let's try the first approach, aggregating the data per country and per type of country while adding a new column with percentages:

Hay una diferencia importante entre el primer gráfico (Figura 1) y este. En el gráfico anterior, ggplot2 contó el número de ciudades en cada grupo (doméstico, UE, no-UE). En este gráfico nuevo, la tibble ya contenía el valor numérico de cada barra, almacenado en la columna **perc**. Esta es la razón por la que especificamos `y = perc` como un parámetro de `aes()`. La parte difícil es que por defecto, `geom_bar()` utilizará el parámetro `stat = "count"`. Esto significa que contará cuántas veces aparece un valor. En otras palabras, agrupará los datos para ti. Sin embargo, puedes informar a ggplot2 que ya has calculado tus valores utilizando el parámetro `stat = "identity"`.

El gráfico 2 muestra que la mayoría de las ciudades hermanas son de un país diferente al de origen, aún así dentro de la UE (cerca del 68%). Esto podría deberse a la proximidad geográfica, similitudes culturales o vínculos económicos dentro de la Unión Europea. Puedes obtener una mirada más detallada agregando el nombre de cada país de origen al gráfico. Podrías decidir visualizar esto de varias maneras, por ejemplo, dividiendo cada barra en porcentajes por país de origen (el gráfico 3), o creando gráficos separados para cada país de origen (esto se llama "faceting" en el lenguaje de ggplot2, que [abordaremos más abajo](#Faceting-a-Graph)). Vamos a intentar la primera aproximación, agrupando los datos por país y por tipo de país y agregando una nueva columna con porcentajes:

```
`eudata.perc.country` <- eudata %>%
  group_by(origincountry, typecountry) %>%
  summarise(total = n()) %>%
  mutate(perc = total/sum(total))

ggplot(data = `eudata.perc.country`, aes(x = typecountry, y = perc, fill = origincountry)) +
  geom_bar(stat = "identity", position="dodge")
```

{% include figure.html filename="en-or-urban-demographic-data-r-ggplot2-03.png" alt="Bar graph showing the percentage of destination cities that are domestic, EU, and non-EU with aggregated data per country and type of country." caption="Figure 3. Bar graph showing the percentage of destination cities that are domestic, EU, and non-EU, aggregating data by country name and type." %}

Figure 3 reveals that most countries in our analysis (Hungary, France, Poland and Germany) strongly prefer to establish sister-city relationships with other European Union countries, with approximately 60-80% of their partnerships in the EU. However, Bulgaria and Portugal differ from this trend: both of these countries seem to have a roughly equal proportion of sister city relationships with EU and non-EU countries. This suggests that Bulgaria and Portugal have a more balanced approach towards forming partnerships that involves actively engaging with cities outside the European Union.

In the case of Portugal, this more global outlook might be attributed to its extensive colonial history which may have fostered long-lasting cultural, linguistic, and economic ties with cities in its former colonies, such as those in Brazil, Angola, and Mozambique.

Para este gráfico (Figure 3), hemos creado un tibble que agrupó los datos según el origen del país y el tipo de país de destino (UE, no-UE, nacional). Hemos mapeado la variable `origincountry` a la estética de rellenado (`fill`) del comando `ggplot()` que define el rango de colores de las barras. También hemos agregado a `geom_bar()` el parámetro `position` con el valor `dodge` para que las barras no se superpongan (lo cual es el estándar por defecto), sino que se coloquen una al lado de otra. 

Ahora que has visualizado las relaciones urbanas (acuerdos entre ciudades), exploraremos cómo estos patrones interactúan con las características demográficas, especialmente la población. 

La figura 3 revela que la mayoría de los países en nuestro análisis (Hungría, Francia, Polonia y Alemania) prefiere establecer fuertes relaciones de ciudades hermanadas con otros países de la Unión Europea, con aproximadamente el 60-80% de sus acuerdos en la UE. Sin embargo, Bulgaria y Portugal difieren de este tendencia: ambos parecen tener una proporción similar de acuerdos con países de la UE y países que no son de la UE. Esto sugiere que Bulgaria y Portugal tienen un enfoque más equilibrado hacia la formación de acuerdos tanto dentro como fuera de la Unión Europea. 

En el caso de Portugal, este enfoque más global podría atribuirse a su extensa historia colonial que podría haber fomentado vínculos culturales, lingüísticos y económicos duraderos con ciudades en sus antiguas colonias, como Brasil, Angola y Mozambique.

En cuanto a Bulgaria, se necesitarían investigaciones más a fondo para descubrir los factores que contribuyen a su porcentaje relativamente alto de hermanamientos con ciudades que no son de la Unión Europea. Las posibles explicaciones incluyen su ubicación geográfica en la orilla de la Unión Europea, sus vínculos culturales y lingüísticos con países de los Balcanes y Europa del Este, o sus relaciones económicas con países fuera de la UE.

Mientras que estas primeras observaciones proporcionan un punto de partida para comprender los patrones de relaciones, es esencial profundizar en el contexto histórico, cultural y político de cada país para comprender las razones subyacentes a estas tendencias.

## Otros geoms: histogramas, gráficos de dispersión y diagramas de caja

So far, you have been introduced to the key syntax needed to operate ggplot2: creating layers and adding parameters. One of the most important layers is the `geoms` layer. Using it is quite straightforward, as every plot type has its associated geom:
- `geom_histogram()` for [histograms](https://perma.cc/64E8-GDFB)
- `geom_boxplot()` for [box plots](https://perma.cc/SE8K-5GPD)
- `geom_violin()` for [violin plots](https://perma.cc/9PLE-352E)
- `geom_dotplot()` for [dot plots](https://perma.cc/Y96C-HSYH)
- `geom_point()` for [scatter plot](https://perma.cc/4WMT-JNNJ)

[and so on](https://perma.cc/QA4T-2Q3A).

You can easily configure various aspects of each of these `geom()` types, such as their size and color.

To practice handling these geoms, let's create a histogram to visualize an important urban characteristic of sister cities: the distance between them. This spatial aspect can help understand how geographic proximity influences city partnerships. Run the following short chunk of code to filter the data and visualize it. Remember to load tidyverse or dplyr first, to ensure the filter doesn't throw an error.

Hasta ahora hemos presentado los elementos clave de la sintaxis para operar con ggplot2: crear capas y agregar parámetros. Una de las capas más importantes es la capa `geoms`. Su uso es bastante directo, ya que cada tipo de gráfico tiene su `geom` asociado: 
- `geom_histogram()` para gráficos de [histograma](https://perma.cc/64E8-GDFB)
- `geom_boxplot()` para [gráficos de caja](https://perma.cc/SE8K-5GPD)
- `geom_violin()` para [gráficos de violin](https://perma.cc/9PLE-352E)
- `geom_dotplot()` para [gráficos de puntos](https://perma.cc/Y96C-HSYH)
- `geom_point()` para [gráficos de dispersión](https://perma.cc/4WMT-JNNJ)

Se pueden configurar fácilmente aspectos de cada uno de estos `geoms`, como su tamaño y color. 

Para practicar el uso de estos `geoms`, vamos a crear un histograma para visualizar un aspecto importante de las ciudades hermanadas: la distancia entre ellas. Este aspecto espacial ayuda a entender cómo la proximidad geográfica influye en este tipo de alianzas. Corre el siguiente código para filtrar los datos y visualizar el gráfico. Recuerda cargar `tidyverse` o `dplyr` primero, para evitar que la función `filter` dé un error (pues usaría la función original de R y no la de `dplyr`).

```
eudata.filtered <- filter(eudata, dist < 5000)

ggplot(eudata.filtered, aes(x=dist)) +
  geom_histogram()
```

{% include figure.html filename="en-or-urban-demographic-data-r-ggplot2-04.png" alt="Histogram showing distances (in natural log) between sister cities." caption="Figure 4. Histogram showing distances between sister cities." %}

Como muestra el código de arriba, solo era necesario agregar `geom_histogram()` para crear un histograma. Sin embargo, crear un  histograma efectivo implica un poco más trabajo. Es importante, por ejemplo, determinar el tamaño de la [celda](https://perma.cc/4ABG-MV73) que da sentido a los datos. El tamaño de esa celda, también conocido como 'intervalo' o 'ancho de banda', se refiere al ancho de cada barra y determina cómo se agrupa y se muestran los datos a lo largo del eje x. En el gráfico representado en la figura 4, ggplot2 se apoyó en un valor  de 30 (`bins=30`) – pero se emite un mensaje de advertencia que recomienda elegir un valor mejor. Puedes explorar más posibilidades de configuración en la [documentación de `geom_histogram()`](https://perma.cc/G29K-53LK).

Este simple gráfico muestra una distribución [asimétrica](https://perma.cc/LA9B-YVGG) hacia la derecha: la variable `dist` nos dice que mientras que la mayoría de ciudades hermanadas tienden a estar geográficamente cerca, existen excepciones en las que las ciudades forman acuerdos con otras más lejanas.

Puedes utilizar una [función de distribución acumulativa (FDA) o función de distribución empírica](https://perma.cc/QL57-3BGA) utilizando el conjunto de datos no filtrado para obtener más información sobre este patrón y comprender mejor la distribución espacial de las relaciones de ciudades hermanadas. Piensa en esta FDA como subir una montaña: al igual que el perfil de la montaña revela su forma, la curva de la FDA revela la forma de la distribución de la variable `dist`. Una distribución [asimétrica](https://perma.cc/LA9B-YVGG) hacia la derecha se vería como una montaña con una subida inicial rápida (muchas ciudades con distancias cortas) seguida de una pendiente suave hacia la cima (pocas ciudades con distancias largas). Esto confirmaría que la obvia asimetría observada en la variable `dist` es una característica genuina de cómo las ciudades forman acuerdos. A diferencia de un histograma, que puede cambiar de forma dependiendo de cómo agrupes las distancias, la perfil de la montaña de la FCD permanece constante. 

En ggplot2, puedes crear una FDA agregando la capa `stat_ecdf()` a tu gráfico. Aquí hay un ejemplo:

```
ggplot(eudata, aes(x=dist)) +
  stat_ecdf()
```

{% include figure.html filename="en-or-urban-demographic-data-r-ggplot2-05.png" alt="ECDF Graph showing the distances between sister cities." caption="Figure 5. ECDF graph showing the distances between sister cities." %}

Vamos a examinar este gráfico de FDA creado utilizando el dataframe `eudata` no filtrado: confirma observaciones previas sobre la distribución desigual. Cerca del 75% de las ciudades tienen relaciones dentro de un radio de alrededor de 1000 kilómetros. Incluso más intrigante es que aproximadamente el 50% de las ciudades están conectadas a otras ciudades que no distan más de 500 kilómetros de distancia. 

Por último, crearemos un gráfico de cajas para comparar cómo diferentes países estructuran sus relaciones a lo largo del espacio. Esta visualización ayudará a comprender cómo ciertos países tienden a formar redes urbanas más localizadas mientras que otros mantienen conexiones geográficas más amplias. Al comparar la distribución de distancias, se pueden identificar patrones nacionales de cómo las ciudades construyen sus relaciones internacionales.

```
ggplot(eudata.filtered, aes(x = origincountry, y = dist)) +
  geom_boxplot()
```

{% include figure.html filename="en-or-urban-demographic-data-r-ggplot2-06.png" alt="Boxplots showing distances (in km) between sister cities of different countries." caption="Figure 6. Box plots showing distances (in km) between sister cities, grouped by country." %}

El gráfico 6 revela un patrón interesante de las ciudades alemanas, especialmente: muestra que tienden a establecer relaciones de hermanamiento con ciudades que están geográficamente más cerca, según indican los valores más bajos del promedio de distancia y menor dispersión de la caja en comparación con otros países. Esto podría reflejar la posición de Alemania como un país central y bien conectado dentro de la UE, con una ubicación geográfica fuerte y estrechas relaciones económicas con sus vecinos, que podrían fomentar la formación de alianzas regionales a una distancia más pequeña.

## Manipulaciones avanzadas de la apariencia del gráfico

Hasta ahora, hemos dejado que ggplot2 decida automáticamente la apariencia del gráfico. Sin embargo, es probable que existan diversas razones para adaptar sus opciones, como mejorar la legibilidad, resaltar aspectos específicos de los datos o ajustarse a guías de estilo específicas. ggplot2 ofrece una amplia gama de opciones de personalización para ajustar finamente la apariencia de sus gráficos. Comenzaremos con un gráfico simple y iremos progresando de manera incremental.

Exploraremos cómo las características demográficas influencian las relaciones urbanas examinando la población de las ciudades hermanadas. Este análisis nos vincual con preguntas históricas más amplias sobre cómo el tamaño de la ciudad afecta la influencia internacional, cómo se desarrollan las jerarquías urbanas y cómo se modelan los patrones demográficos para los intercambios culturales y económicos. Enfoques similares podrían utilizarse para estudiar preguntas históricas sobre los patrones de urbanización, el desarrollo de las regiones metropolitanas o la relación entre el tamaño de la población y el desarrollo económico.

Comenzaremos creando un gráfico de dispersión que conecta el tamaño de población de las ciudades de origen y destino. Un gráfico de dispersión es un gráfico que utiliza puntos o puntos para representar los valores de dos variables para cada observación relacionándolos en su punto de intersección. En este caso, cada punto del gráfico representará una pareja de ciudades hermanadas, con la coordenada `x` indicando el tamaño de población de la ciudad de origen y la coordenada `y` representando el tamaño de población de la ciudad de destino. Si observamos una clara tendencia positiva, con puntos agrupados a lo largo de una línea diagonal desde la izquierda inferior hasta la superior derecha, eso sugerirá que las ciudades tienden a formar relaciones con otras ciudades de un tamaño de población similar.

Dado que `eudata` contiene 13081 entradas, utilizar todas ellas daría un resultado difícilmente analizable. Por lo tanto, en este ejemplo, vamos a seleccionar un muestreo al azar del 15% de las ciudades presentes en nuestros datos, utilizando la función `slice_sample()`. También es útil trabajar con el [logaritmo natural](https://perma.cc/C8NX-WHP7) del tamaño de población para superar la asimetría. Dado que se está utilizando una selección de datos al azar, es necesario 'establecer un semilla' para garantizar la replicabilidad. Esto significa que si se ejecuta el código de nuevo, ggplot2 seleccionará de nuevo el mismo muestreo aleatorio. Esto se puede hacer mediante la función `set.seed()`.

```
set.seed(123)
```

Ahora extraigamos una muestra aleatoria del 15% de las ciudades: 

```
eudata.sample <- slice_sample(eudata, prop = 0.15)
```

Y creemos el gráfico con el siguiente código:

```
ggplot(data = eudata.sample, aes(x = log(originpopulation), y = log(destinationpopulation))) +
  geom_point()
```

{% include figure.html filename="en-or-urban-demographic-data-r-ggplot2-07.png" alt="Scatter plot displaying the relationship of population (in natural logarithm) in 15% of the sister cities that were randomly selected." caption="Figure 7. Scatter plot comparing the population size (in natual logarithm) of randomly selected sister-city pairs." %}

Ahora que hemos creado este gráfico básico, podemos empezar a jugar con su apariencia. ¿Por qué no empezar aplicando un tamaño fijo y un color a los puntos? El siguiente código cambia el color de los puntos a un borgoña, utilizando el código hexadecimal #4B0000:

```
ggplot(data = eudata.sample, aes(x = log(originpopulation), y = log(destinationpopulation))) +
  geom_point(size = 0.8, color = "#4B0000")
```

{% include figure.html filename="en-or-urban-demographic-data-r-ggplot2-08.png" alt="Changing the size and color of the points of a scatterplot." caption="Figure 8. Changing the size and color of the points in the scatter plot." %}

Para descubrir otros argumentos disponibles, puedes visitar la documentación de la función `geom_point()` (https://perma.cc/4WMT-JNNJ), o simplemente escribe `?geom_point` en R.

Puedes seguir mejorando el gráfico agregando etiquetas de eje y una leyenda. La manipulación de ejes suele hacerse a través de las funciones `scales` correspondientes, que trataremos más adelante. Sin embargo, cambiar las leyendas del gráfico es una acción muy común, y ggplot2 proporciona la función más breve [`labs()`](https://perma.cc/544S-88AV), que está destinada a este propósito.

```
ggplot(data = eudata.sample, aes(x = log(originpopulation), y = log(destinationpopulation))) +
  geom_point(size = 0.8, color = "#4B0000") +
  labs(title = "Population size of origin and destination city", caption = "Data: [www.wikidata.org](http://www.wikidata.org)", x =     "Population of origin city (log)", y = "Population of destination city (log)")
```

{% include figure.html filename="en-or-urban-demographic-data-r-ggplot2-09.png" alt="Scatterplot with added titles and caption using the labs() function." caption="Figure 9. Adding axis labels and a title." %}

Una vez que estás satisfecho con tu gráfico, lo puedes grabar:

```
ggsave("eudata.png")
```

Para grabarlo como PDF, utiliza el siguiente comando:

```
ggsave("eudata.pdf")
```
Esto creará un archivo `.png` del último gráfico que hemos construido. La función `ggsave()` también viene con [muchos parámetros ajustables](https://perma.cc/SL2S-X2PU) (dpi, altura, ancho, formato y más).

A veces necesitarás mejorar tu gráfico añadiendo información adicional, utilizando colores o formas diferentes. Esto es especialmente útil si deseas representar [variables categóricas](https://perma.cc/FZ9W-FQ8L) junto a las variables de interés principales. En el gráfico de dispersión (Figura 8), usamos valores estáticos para determinar el tamaño y el color de los puntos. Sin embargo, podríamos también mapear estas propiedades estéticas a columnas específicas de los datos, con el fin de visualizar sistemáticamente las diferentes categorías.

```
ggplot(data = eudata.sample, aes(x = log(originpopulation), y = log(destinationpopulation))) +
  geom_point(size = 0.8, alpha = 0.7, aes( color = typecountry )) +
  labs(title = "Population size of origin and destination city", caption = "Data: [www.wikidata.org](http://www.wikidata.org)", x =     "Population of origin city (log)", y = "Population of destination city (log)")
```

{% include figure.html filename="en-or-urban-demographic-data-r-ggplot2-10.png" alt="Scatterplot using colors to distinguish different types of sister city relationships based on the location of the destination city." caption="Figure 10. Using colors in scatter plots to visualize different country types." %}

El código anterior tiene dos modificaciones importantes. En primer lugar, modificamos `geom_point()` agregando el argumento `aes(color = typecountry)`. En segundo lugar, ya que había demasiados puntos superpuestos, agregamos el parámetro `alpha` para que tengan una transparencia del 70%. De nuevo, ggplot2 ha seleccionado colores y leyendas de serie por defecto para el gráfico.

### Scales: Colors, Legends, and Axes

Next, you'll explore ggplot2's `scales` function. You can think of scales as a set of rules, or a mapping system. They take your raw data (like population numbers or country names) and define how those values should be represented visually – what color something should be, where it should be placed on the graph, how big it should appear, etc. Without scales, ggplot2 wouldn't know how to translate your data into a meaningful picture.

Let's use the sister-city data as an example. When you create a plot, scales work behind the scenes to transform your raw data into visual elements. They specify, for example, how country names convert into different colors ('French cities should be shown in blue'), or how distance between cities translates into point size ('cities with populations over one million should be shown as large points'). These rules ensure that every element of your data is displayed consistently throughout your visualization, making it easier for readers to understand the patterns and relationships you're trying to show.

In ggplot2, scales follow a naming convention consisting of three parts separated by underscores:

1. The prefix `scale`.
2. The name of the scale being modified. As mentioned earlier, aesthetics define the visual properties of the plot that are mapped to data. Scales, on the other hand, control how those aesthetic mappings are translated into specific visual representations. This includes how data values are mapped to colors or shapes, and their position on the x and y axes.
3. The type of scale being applied (continuous, discrete, brewer).

Before you start adding scales, it will be helpful to store your previous plot in a variable `p1`: this is a convenient way to create different versions of the same plot in order to vary only certain aspects of it.

```
p1 <- ggplot(data = eudata.sample, aes(x = log(originpopulation), y = log(destinationpopulation))) +
  geom_point(size = 0.8, alpha = 0.7, aes( color = typecountry )) +
  labs(title = "Population size of origin and destination city", caption = "Data: [www.wikidata.org](http://www.wikidata.org)", x =     "Population of origin city (log)", y = "Population of destination city (log)")
```

One common use of scales is to change the colors of a plot. To manually specify the colors you want, you can use the `scale_color_manual()` function and provide a [vector](https://perma.cc/XV2R-DLSY) of color values, using color names [defined by R](https://perma.cc/TM3F-D8JP) or their hexadecimal codes. [`scale_colour_manual()`](https://perma.cc/T72S-NYXC) takes a compulsory argument (`values =`), namely a vector of the color names. In this way, you can create graphs with your chosen colors:

```
p1 +
  scale_colour_manual(values = c("red", "blue", "green"))
```

{% include figure.html filename="en-or-urban-demographic-data-r-ggplot2-11.png" alt="Scatter plot that uses scale_colour_manual() to change the colors of the scatterplot points." caption="Figure 11. Using scale_colour_manual() to specify the colors of the scatter plot's points." %}

However, you can also simply rely on predefined color scales, such as the [color brewer palettes](http://colorbrewer2.org). It's better to use these whenever possible, because choosing the right colors for visualizations is a very complicated issue (for instance, avoiding colors that are not distinguishable by people with impaired vision). Fortunately, ggplot2 comes with `scale_colour_brewer()` already [integrated](https://perma.cc/BST9-7GMG):

```
p1 +
  scale_colour_brewer(palette = "Dark2") # you can try others such as "Set1", "Accent", etc.
```

{% include figure.html filename="en-or-urban-demographic-data-r-ggplot2-12.png" alt="Scatter plot that uses scale_colour_brewer() to change the colors of the scatterplot points." caption="Figure 12. Using scale_colour_brewer() to change the colors of the scatter plot's points." %}

In the scatter plot above, you learned how to represent a qualitative (or categorical) variable (`typecountry`) using three different colors. In the next scatter plot, let's try to represent a [continuous variable](https://perma.cc/DT7J-MQD3) instead – for example, the distance between origin and destination cities, which we can show using varying intensities of color. You might try to simply map this color to the distance `log(dist)`, which is the continuous variable in this case:


```
p2 <- ggplot(data = eudata.sample, aes(x = log(originpopulation),y = log(destinationpopulation))) +
  geom_point(size = 0.8, aes( color = log(dist) )) +
  labs(title = "Population size of origin and destination city", subtitle = "Colored by distance between cities",
    caption = "Data: [www.wikidata.org](http://www.wikidata.org)", x = "Population of origin city (log)", y = "Population of            destination city (log)")

p2
```

{% include figure.html filename="en-or-urban-demographic-data-r-ggplot2-13.png" alt="Scatter plot showing population size of origin and destination city colored by distance between cities." caption="Figure 13. Mapping the plot colors to the distance between cities." %}

Immediately, you'll notice that this code hasn't produced the most intuitive visualization:

1. By default, ggplot2 uses a blue color gradient for continuous variables when no specific color is specified.

2. The default scale is also counterintuitive, because shorter distances are represented by a darker blue, not lighter (which we would expect).

In this example, again, using a scale will provide the tools to correct these defaults and create visualizations that more accurately and effectively communicate the underlying data. To represent a continuous variable, gradient – or 'continuous' – color scales assign colors to values based on a smooth transition between hues or shades. This allows for an accurate representation of the continuous variable, as the gradual color change corresponds to the change in the variable's value. Using a gradient scale, you can visualize the distribution of values and identify patterns or trends in the data.

There are [several methods for creating gradient scales in ggplot2](https://perma.cc/K6J3-GSQS). For our purpose, we will use the `scale_colour_gradient()` function. This allows you to assign specific colors to the minimum and maximum values of the continuous variable. ggplot2 then automatically interpolates the colors for the intermediate values based on the chosen gradient.

You can work with the `p2` object created earlier and use the `+` operator to modify it. You've already mapped the `dist` variable (distance between cities) to the color aesthetic using `color = dist` inside the `aes()` function. Now, add the `scale_colour_gradient()` function to customize the color gradient. In the code below, you set the color for the lowest value of the `dist` variable to white and the highest value to the hex code for a dark burgundy (#4B0000). This means lighter shades of red will represent shorter distances, while darker shades represent longer distances.

```
p2 +
  scale_colour_gradient(low = "white", high = "red3")
```

{% include figure.html filename="en-or-urban-demographic-data-r-ggplot2-14.png" alt="Scatter plot showing population size of origin and destination city colored by distance between cities using scale_colour_gradient()" caption="Figure 14. Population size of origin and destination city colored by distance between cities using scale_colour_gradient()." %}

What can we learn from this graph? To a certain extent, it appears that smaller cities tend to establish relationships with cities that are closer. In the previous sections, you examined the distribution of distances between sister cities using a histogram and an ECDF plot. These visualizations revealed that most sister-city relationships are characterized by short distances, mostly within a radius of 500 to 1000 kilometers. Comparing findings across different visualizations can strengthen the depth of the observed patterns and highlight the importance of considering certain key variables.

Building upon these insights, let's now modify the scatter plot's legend. Customizing it will improve clarity, making it easier for readers to interpret and understand the conveyed information.

You can modify the legend by editing the `guide` parameter within the `scale_colour_gradient()` function. The guide parameter specifies the legend's title, position, and orientation. Here, you will also use the `guide_colorbar()` function to create a color bar legend representing the range of distances between cities.

```
p2 <- p2 +
  scale_colour_gradient(low = "white", high = "red3", guide = guide_colorbar(title = "Distance in log(km)", direction =
    "horizontal", title.position = "top"))

p2
```

{% include figure.html filename="en-or-urban-demographic-data-r-ggplot2-15.png" alt="Scatter plot showing population size of origin and destination city colored by distance between cities using scale_colour_gradient() and guide_colorbar()." caption="Figure 15. Modifying the title and adding a color bar." %}

### Facetting a Graph

Another great feature of ggplot2 is that it allows you to split your data into different plots based on a certain variable. In ggplot2, this is called [facetting](https://perma.cc/B8NV-6LVE). The simplest facetting function is `facet_wrap()`, but you can also check out the richer [`facet_grid()`](https://perma.cc/A5UY-5HUQ) for more options.

Earlier in the lesson, you created a plot which highlighted whether destination cities were within the same country as the origin city, in a different EU or a non-EU country. Using the `eudata.perc.country` tibble, you could facet this graph by adding a `facet_wrap()` layer based on the different origin countries:

```
ggplot(`eudata.perc.country`, aes(x = typecountry, y = perc)) +
  geom_bar(stat = "identity") +
  facet_wrap(~origincountry)
```

The tilde (`~`) operator is commonly used in R formulas. Here, it indicates which variable ggplot2 should use to define the facetting structure. In other words, `~origincountry` formula tells ggplot2 to split the data based on the value of the `origincountry` variable, then create a separate graph to represent each value (in this case, each country). The resulting plot will display the bar graphs in a grid layout:

{% include figure.html filename="en-or-urban-demographic-data-r-ggplot2-16.png" alt="Faceted bar graphs using facet_wrap() where the bar graph for each country is displayed in a grid pattern." caption="Figure 16. Facetting a graph with facet_wrap()." %} 

### Themes: Changing Static Elements

Since the appearance of a graph is crucial for effectively communicating different insights, ggplot2 provides themes to help customize your visualizations further. These themes control the non-data elements of the plot, such as the background color and font styles.

Setting a theme is very simple: just apply it as a new layer using the `+` operator. Here's a classic dark-on-light theme:

```
p3 <- ggplot(`eudata.perc.country`, aes(x = typecountry, y = perc)) +
  geom_bar(stat = "identity") +
  facet_wrap(~origincountry)

p3 +
  theme_bw()
```

{% include figure.html filename="en-or-urban-demographic-data-r-ggplot2-17.png" alt="Faceted bar graph with changed static elements using the theme_bw() function." caption="Figure 17. Changing static elements using theme_bw()." %}

You can also install several packages which provide additional themes, such as [ggthemes](https://github.com/jrnold/ggthemes) or [ggtech](https://github.com/ricardo-bion/ggtech). In these, you will find for example `theme_excel` (replicating the classic charts in Excel) and `theme_wsj` (based on the plots in [_The Wall Street Journal_](https://perma.cc/ZDD6-SP95)). The advantage of using ggplot2's themes to replicate these recognizable styles is not only simplicity, but also the fact that ggplot2 automatically takes into account the grammar of graphics when mapping your data to elements of the graph. 

For instance, to mimic graphs created by _The Wall Street Journal_, you can write the following:

```
install.packages("ggthemes")

library(ggthemes)

p3 +
  theme_wsj()
```

{% include figure.html filename="en-or-urban-demographic-data-r-ggplot2-18.png" alt="Bar graph with changed static elements using the theme_wsj() function from the ggthemes package." caption="Figure 18. Changing static elements using The Wall Street Journal theme." %}

### Extending ggplot2 with Other Packages

One of ggplot2's strengths is its extensive collection of [extensions](http://www.ggplot2-exts.org/) that can help enhance your analysis with specialized visualizations like network graphs (useful for showing relationships between cities, for example), time series graphs (for tracking demographic changes over time), and ridgeline plots (for comparing population distributions across different urban areas).

Let's explore an example showcasing a ggplot2 extension that creates more advanced and visually striking plots. In this case, we will create a [ridgeline plot](https://perma.cc/D9Z2-XHAV) – also known as a 'joyplot' – designed to visualize changes in distributions over time, across different categories. Ridgeline plots are particularly effective for comparing multiple distributions in a compact and aesthetically pleasing manner.

To create a ridgeline plot, you're going to use the ggridges package (one of many ggplot2 extensions). This adds a new layer called `geom_density_ridges()` and a new theme `theme_ridges()`, which expands R's plotting possibilities.

This code is simple enough (again, using a log transformation due to the data's skewness):

```
install.packages("ggridges")
library(ggridges)

ggplot(eudata, aes(x=log(originpopulation), y = origincountry)) +
  geom_density_ridges() +
  theme_ridges() +
  labs(title = "Population (log) of the origin cities", caption = "Data: [www.wikidata.org](http://www.wikidata.org)", x =
    "Population (log)", y = "Country")
```

{% include figure.html filename="en-or-urban-demographic-data-r-ggplot2-19.png" alt="Ridge plot showing the population (log) of different countries origins." caption="Figure 19. Extending ggplot2 with the ggridges package." %}

This visualization of population distributions shows how urban demographic patterns vary by country. For example, Poland, Portugal and Bulgaria show distinct demographic profiles, with their cities tending toward larger population sizes, as indicated by the peaks on the right side of their respective density curves. 

## Conclusion

Through the analysis of sister-city relationships in the European Union using ggplot2 and its extensions, we've demonstrated how different visualization techniques can reveal patterns in urban networks and demographic characteristics. The dataset allowed us to uncover several key insights: cities tend to form partnerships within a 500-1000 km radius, countries vary significantly in their preference for domestic versus international partnerships, and population size plays a role in partnership formation. 

However, this is just the tip of the iceberg of ggplot2's possibilities. With an extensive ecosystem of extensions and packages, ggplot2 offers endless opportunities for customization and adaptation to specific data visualization needs. Whether you're working with time series data, network graphs, or geospatial information, there's likely a ggplot2 extension that can help you create compelling and informative visualizations. As you continue to explore and work with ggplot2, remember that effective data visualization is an iterative process that requires experimentation, refinement, and a keen understanding of your audience and communication goals. By mastering the principles and techniques this tutorial covers, you will be well-equipped to create impactful visualizations that illuminate the stories hidden within your data.

## Additional Resources

To gain a more thorough understanding of ggplot2, we recommend you explore some of the following sources:

* The [official ggplot2 site](https://ggplot2.tidyverse.org/).

* Hadley Wickham's books [`ggplot2`: _Elegant Graphics for Data Analysis_](https://ggplot2-book.org/) and [_R for Data Science_](http://r4ds.hadley.nz/).

* Hadley Wickham's [original paper](https://doi.org/10.1198/jcgs.2009.07098) on the grammar of graphics.

* Leland Wilkson's original book [_The Grammar of Graphics_](https://doi.org/10.1007/0-387-28695-0).

* Selva Prabhakaran's [tutorial on r-statistics.co](https://perma.cc/6Q2Q-L7UD).

* Data Science Dojo's video [Introduction to Data Visualization with ggplot2](https://www.youtube.com/watch?v=NXjPcXx42Yc).

* UC Business Analytics' [R Programming Guide](https://perma.cc/KZT6-GW9C).

* The official ggplot2 [extensions page](https://www.ggplot2-exts.org/) and [accompanying gallery](http://www.ggplot2-exts.org/gallery/).

* R Project’s [overview about extending ggplot2](https://perma.cc/465N-F9WU).

* The [general documentation](https://ggplot2.tidyverse.org/reference/).

* The [Cookbook for R](http://www.cookbook-r.com/Graphs/) book (based on  Winston Chang's [_R Graphics Cookbook. Practical Recipes for Visualizing Data_](http://shop.oreilly.com/product/0636920023135.do)).

* This official [R cheatsheet](https://www.rstudio.com/resources/cheatsheets/).

* The gradient scale [documentation page](https://perma.cc/8BWE-MVLV).
