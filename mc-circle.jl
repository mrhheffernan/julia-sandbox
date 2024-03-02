# Math's hello world: Calculating pi via Monte Carlo

n_samples = parse(Int64, ARGS[1]::String) # Allow user to specify number of samples
radius = 1

function check(sample_x, sample_y)
    # Check if sample is in the circle
    sample_radius = (sample_x ^ 2 + sample_y ^ 2)^0.5
    return sample_radius < radius
end

function integrate_quadrant(n_samples)
    success = 0    
    for i in 1:n_samples
        checker = check(samples[i,1], samples[i,2])
        if checker
            success = success + 1
        end
    end
    return success / n_samples
end

samples = rand(n_samples, 2) # 2D integration only
quadrant = integrate_quadrant(n_samples)
pi_estimate = 4 * quadrant
println("pi: ", pi_estimate)