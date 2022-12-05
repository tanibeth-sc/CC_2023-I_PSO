# Algoritmo de Optmización por Enjambre de Partículas (PSO)Algoritmo de Optmización por Enjambre de Partículas (PSO)

**Integrantes:**

- Chaparro Sicardo Tanibeth
- Lerín Hernández Natalia

El algoritmo de optimización por enjambre de partículas
(PSO) sirve para estudiar situaciones en las que se requiere conocer soluciones óptimas bajo condiciones o criterios particulares. Se distribuye la población de partículas en un espacio de búsqueda definido de modo que los operadores propios del algoritmo impiden soluciones imprecisas, pues no se estancan óptimos locales.

El algoritmo considera una población de partículas que operan dentro de un espacio de búsqueda dado, acotado. Se repite un mismo procedimiento iterativamente una cantidad de veces finita. En cada una de las iteraciones se producen nuevas posiciones para las partículas, a partir de una velocidad dada a partir de la posición global más óptima y la mejor posición actual de cada partícula. Se toma también una función objetiva para valorar la calidad de la población por medio de la evaluación individual de cada partícula en la nueva posición. También en cada iteración hay un intercambio de información entre los elementos de la población para alcanzar más rápidamente el objetivo común.

En este proyecto se consideraron dos conjuntos de pruebas: Uno a partir de la función de Rosenbrock y el otro a partir de la ecuación de una parábola en dos dimensiones centrada en el origen. Primero se realizó la implementación secuencial del algoritmo PSO y posteriormente se realizó la implementación en paralelo usando el lenguaje de programación Julia.

###End
