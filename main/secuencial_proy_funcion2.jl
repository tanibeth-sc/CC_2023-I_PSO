using Distributions
using Statistics
using Dates

# Implementación Secuencial

# Función objetivo
function funcion_prueba2(x,n)
    sum = 0
    for i = 1:n-1
        sum += (x[i])^2 + (x[i+1])^2
    end
    return sum
end

# Función PSO
function fun_pso(d,part_n,l,u,max_iter,funcion)
    # Inicialización de PSO
    x = l' .+ rand(Uniform(0,1), part_n, d) .* (u-l)'
    obj_func = [funcion(x[i,:],d) for i=1:part_n] # Evaluación función objetivo
    evol_func_obj = zeros(1, max_iter) # Almacenará valores de función objetivo
    nva_obj_func = zeros(1, part_n) # Guardará la nueva evaluación
    ind = argmin(obj_func) # Índice del mínimo global
    glob_opt = minimum(obj_func) # Mínimo global
    
    mejor_pos = x[ind,:]
    g_opt = ones(part_n,d)
    for i = 1:d
        g_opt[:,i] .= x[ind,i]
    end
    loc_opt = x # Mejor local para cada partícula
    
    # Inicialización de velocidades
    v = zeros(part_n,d)
    
    # Inicialización de optimización PSO
    t = 1
    for t = 1:max_iter
        v = v .+ rand(Uniform(0,1), part_n, d) .* (loc_opt - x) .+ rand(d)' .* (g_opt .- x)
        x = x.+v # Nueva posición
        # Verifica que las partículas no se salgan de los límites
        for i = 1:part_n
            if x[i,:] > u
                x[i,:] = u
            elseif x[i,:] < l
                x[i,:] = l
            end
            
            # Evaluamos las nuevas posiciones en la función objetivo
            nva_obj_func[i] = funcion(x[i,:],d)
            if nva_obj_func[i] < obj_func[i]
                loc_opt[i,:] = x[i,:] # Actualiza óptimo local
                obj_func[i] = nva_obj_func[i] # Actualiza función objetivo
            end
        end
        
        nvo_glob_opt = minimum(obj_func) # Nuevo mínimo global
        ind = argmin(obj_func) # índice del nuevo mínimo
        
        # Verifica si se actualiza el óptimo global
        if nvo_glob_opt < glob_opt
            glob_opt = nvo_glob_opt
            for i = 1:d
                g_opt[:,i] .= x[ind,i]
            end
            mejor_pos = x[ind,:]
        end
        evol_func_obj[t] = glob_opt # Almacena valores de función objetivo en cada iter
        
        t +=1 # Incrementa iter
    end    
    return mejor_pos
end

inicio = now()

d = 2
l = [-5,-5]
u = [10,10]
Part_N = 6500
Max_iter = 1000

res = fun_pso(d,Part_N,l,u,Max_iter,funcion_prueba2)

final = now()

println(res)
println("Tiempo de ejecución: $(final- inicio)")
