using Distributions
using Statistics
using Dates
using MPI

# Función Rosenbrock
function fun_rosenbrock(x,n)
    sum = 0
    for i = 1:n-1
        sum += 100*((x[i]^2) - x[i+1])^2 + (x[i]-1)^2
    end
    return sum
end

# Función PSO
function fun_pso(d,part_n,l,u,max_iter)
    # Inicialización de PSO
    x = l' .+ rand(Uniform(0,1), part_n, d) .* (u-l)'
    obj_func = [fun_rosenbrock(x[i,:],d) for i=1:part_n] # Evaluación función objetivo
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
            nva_obj_func[i] = fun_rosenbrock(x[i,:],d)
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

# Implementación Paralela
MPI.Init()

comm = MPI.COMM_WORLD
rank = MPI.Comm_rank(comm)
size = MPI.Comm_size(comm)

if rank == 0
  inicio = now()
end

d = 2
l = [-5, -5]
u = [10, 10]
Part_N = 6500
Max_iter = 1000

div_n = Part_N ÷ size # Dividimos las partículas

min_act = fun_pso(d, div_n, l, u, Max_iter) # Inicializamos el mínimo

if rank != 0
  MPI.send(min_act, comm; dest=0, tag=0) # Mandamos el mínimo a los esclavos
else
  min_r = zeros(d)
  for i = 1:size-1
    mssgrv = MPI.recv(comm; source=i, tag=0)
    minimo_act = min(fun_rosenbrock(min_r, d), fun_rosenbrock(mssgrv, d))

    if minimo_act == fun_rosenbrock(min_r, d)
      global min_r = min_r
    else
      global min_r = mssgrv
    end
  end
end

if rank == 0
  final = now()
  println(min_r)
  println("Tiempo de ejecución: $(final- inicio)")
end


MPI.Barrier(comm)
MPI.Finalize()
